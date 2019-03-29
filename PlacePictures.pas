unit PlacePictures;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Placemnt, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, cxTextEdit, StdCtrls, ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxClasses, cxControls,
  cxGridCustomView, cxGrid, Utils, DBConnection, DialMessages, DB, ADODB,
  Menus, PlacePictureProps, ImageView, JPEG, RxMemDS, Math, cxDBData,
  cxGridDBTableView, Log, Error;

type
  TPlacePicturesForm = class(TForm)
    FormPlacement: TFormPlacement;
    PlacePicturesGrid: TcxGrid;
    PlacePicturesLevel: TcxGridLevel;
    ActionPanel: TPanel;
    CloseButton: TButton;
    PlacePicturesPopupMenu: TPopupMenu;
    CreatePlacePictureMI: TMenuItem;
    EditPlacePictureMI: TMenuItem;
    DeletePlacePictureMI: TMenuItem;
    PlacePictureActionsSeparatorMI: TMenuItem;
    ShowPlacePictureMI: TMenuItem;
    PlacePicturesQuery: TADOQuery;
    PlacePicturesRecordQuery: TADOQuery;
    PlacePicturesDataSet: TRxMemoryData;
    LoadPlacePictureFromFileSeparatorMI: TMenuItem;
    LoadPlacePictureFromFileMI: TMenuItem;
    PlacePictureOpenDialog: TOpenDialog;
    PlacePictureDataQuery: TADOQuery;
    PlacePicturesView: TcxGridDBTableView;
    PlacePicturesViewVisibleNameColumn: TcxGridDBColumn;
    PlacePicturesViewCreatedColumn: TcxGridDBColumn;
    PlacePicturesDataSource: TDataSource;
    procedure CreatePlacePictureMIClick(Sender: TObject);
    procedure EditPlacePictureMIClick(Sender: TObject);
    procedure DeletePlacePictureMIClick(Sender: TObject);
    procedure ShowPlacePictureMIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadPlacePictureFromFileMIClick(Sender: TObject);
  private
    { Private declarations }
    PlaceID: TRecordID;
    procedure SetControls;
    procedure CreatePlacePicture;
    procedure EditPlacePicture;
    procedure DeletePlacePicture;
    procedure ShowPlacePicture;
    procedure LoadPlacePictureFromFile;
  public
    { Public declarations }
    constructor CreatePlace(const PlaceID: TRecordID);
  end;

var
  PlacePicturesForm: TPlacePicturesForm;

implementation

{$R *.dfm}

const
  MinImageDimensions: Integer = 100;
  MaxImageDimensions: Integer = 1200;
  MinImageCapacity: Integer = 102400;
  MaxImageCapacity: Integer = 1080000;
  ImageSizeLimit: Integer = 1048575;

resourcestring
  rsPlacePictureCreation = 'Создание изображения объекта...';
  rsPlacePictureCreationError = 'Не удалось добавить изображение объекта!';
  rsPlacePictureCreationOK = 'Изображение объекта создано.';
  rsPlacePictureEditing = 'Изменение изображения объекта...';
  rsPlacePictureEditingError = 'Не удалось изменить изображения объекта!';
  rsPlacePictureEditingOK = 'Изображение объекта изменено.';
  rsPlacePictureDeleting = 'Удаление изображения объекта...';
  rsPlacePictureDeletingQuestion = 'Удалить выбранное изображение объекта?';
  rsPlacePictureDeletingError = 'Не удалось удалить изображение объекта!';
  rsPlacePictureDeletingOK = 'Изображение объекта удалено.';
  rsPlacePictureLoading = 'Загрузка изображения объекта...';
  rsPlacePictureLoadingError = 'Не удалось загрузить изображение объекта!';
  rsPlacePictureLoadingOK = 'Изображение объекта загружено.';
  rsPlacePictureDataEmpty = 'Данные изображения отсутствуют!';
  rsTooBigFile = 'Размер файла с изображением должен быть не более %d байт!';
  rsTooBigImage = 'Изображение должно содержать не менее %d пикселей по меньшей стороне и не более %d пикселей по большей стороне при общем количестве пикселей от %d до %d включительно!';
  rsCanNotOpenImage = 'Не удалось открыть изображение!';
  rsCanNotRetrieveImage = 'Не удалось получить изображение!';

constructor TPlacePicturesForm.CreatePlace(const PlaceID: TRecordID);
begin
  inherited Create(Application);

  Self.PlaceID := PlaceID;
end;

procedure TPlacePicturesForm.CreatePlacePicture;
var
  ID: TRecordID;
  VisibleName: string;
begin
  VisibleName := EmptyStr;

  if AskPlacePictureProps(VisibleName) then
  begin
    WriteToLog(rsPlacePictureCreation);

    InsertDatSetRecord(PlacePicturesDataSet);

    LandscapeDB.BeginTransaction;
    try
      ID := LandscapeDB.CreatePlacePicture(PlaceID, VisibleName);
      RetrieveDatSetRecord(PlacePicturesDataSet, PlacePicturesRecordQuery, ['id'], [ID]);
      LandscapeDB.Commit;

      WriteToLog(rsPlacePictureCreationOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        PlacePicturesDataSet.Delete;

        WriteToLog(rsPlacePictureCreationError);
        ShowApplicationError(rsPlacePictureCreationError, E.Message);
      end;
    end;

    SetControls;
  end;
end;

procedure TPlacePicturesForm.ShowPlacePicture;
var
  PictureData: TJPEGImage;
  MemoryStream: TMemoryStream;
begin
  try
    MemoryStream := TMemoryStream.Create;

    try
      with PlacePictureDataQuery do
      begin
        Parameters.ParamValues['id'] := PlacePicturesDataSet.FieldValues['id'];

        Open;

        try
          TBlobField(FieldByName('picture_data')).SaveToStream(MemoryStream);
        finally
          Close;
        end;
      end;

      MemoryStream.Position := 0;

      if MemoryStream.Size > 0 then
      begin
        PictureData := TJPEGImage.Create;
        try
          PictureData.LoadFromStream(MemoryStream);
          DisplayImage(PictureData, PlacePicturesDataSet.FieldValues['visible_name'])
        finally
          FreeAndNil(PictureData);
        end;
      end
      else
      begin
        InfoMsg(rsPlacePictureDataEmpty);
      end;
    finally
      FreeAndNil(MemoryStream);
    end;
  except
    on E: Exception do
    begin
      ShowApplicationError(rsCanNotRetrieveImage, E.Message);
    end;
  end;
end;

procedure TPlacePicturesForm.EditPlacePicture;
var
  ID: TRecordID;
  VisibleName: string;
begin
  ID := PlacePicturesDataSet.FieldValues['id'];
  VisibleName := PlacePicturesDataSet.FieldValues['visible_name'];

  if AskPlacePictureProps(VisibleName) then
  begin
    WriteToLog(rsPlacePictureEditing);

    LandscapeDB.BeginTransaction;
    try
      LandscapeDB.EditPlacePicture(ID, VisibleName);
      RetrieveDatSetRecord(PlacePicturesDataSet, PlacePicturesRecordQuery, ['id'], [ID]);
      LandscapeDB.Commit;

      WriteToLog(rsPlacePictureEditingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        WriteToLog(rsPlacePictureEditingError);
        ShowApplicationError(rsPlacePictureEditingError, E.Message);
      end;
    end;
  end;
end;

procedure TPlacePicturesForm.DeletePlacePicture;
var
  ID: TRecordID;
begin
  ID := PlacePicturesDataSet.FieldValues['id'];

  if QuestionMsg(rsPlacePictureDeletingQuestion) = IDYES then
  begin
    WriteToLog(rsPlacePictureDeleting);

    LandscapeDB.BeginTransaction;
    try
      LandscapeDB.DeletePlacePicture(ID);
      RetrieveDatSetRecord(PlacePicturesDataSet, PlacePicturesRecordQuery, ['id'], [ID]);
      LandscapeDB.Commit;

      WriteToLog(rsPlacePictureDeletingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        WriteToLog(rsPlacePictureDeletingError);
        ShowApplicationError(rsPlacePictureDeletingError, E.Message);
      end;
    end;
  end;
end;

procedure TPlacePicturesForm.CreatePlacePictureMIClick(Sender: TObject);
begin
  CreatePlacePicture;
end;

procedure TPlacePicturesForm.EditPlacePictureMIClick(Sender: TObject);
begin
  EditPlacePicture;
end;

procedure TPlacePicturesForm.DeletePlacePictureMIClick(Sender: TObject);
begin
  DeletePlacePicture;
end;

procedure TPlacePicturesForm.ShowPlacePictureMIClick(Sender: TObject);
begin
  ShowPlacePicture;
end;

procedure TPlacePicturesForm.FormCreate(Sender: TObject);
begin
  FillDataSet(PlacePicturesDataSet, PlacePicturesQuery, ['place_id'], [PlaceID]);

  SetControls;
end;

procedure TPlacePicturesForm.SetControls;
begin
  ShowPlacePictureMI.Enabled := PlacePicturesDataSet.RecordCount > 0;
  EditPlacePictureMI.Enabled := PlacePicturesDataSet.RecordCount > 0;
  DeletePlacePictureMI.Enabled := PlacePicturesDataSet.RecordCount > 0;
  LoadPlacePictureFromFileMI.Enabled := PlacePicturesDataSet.RecordCount > 0;
end;

procedure TPlacePicturesForm.LoadPlacePictureFromFile;
var
  PictureData: TJPEGImage;
  MemoryStream: TMemoryStream;
begin
  with PlacePictureOpenDialog do
  begin
    if Execute then
    begin
      WriteToLog(rsPlacePictureLoading);

      if GetFileSize(FileName) <= ImageSizeLimit then
      begin
        try
          PictureData := TJPEGImage.Create;

          try
            PictureData.LoadFromFile(FileName);

            if
              (Min(PictureData.Width, PictureData.Height) >= MinImageDimensions)
              and
              (Max(PictureData.Width, PictureData.Height) <= MaxImageDimensions)
              and
              (PictureData.Width * PictureData.Height >= MinImageCapacity)
              and
              (PictureData.Width * PictureData.Height <= MaxImageCapacity)
            then
            begin
              LandscapeDB.BeginTransaction;

              try
                MemoryStream := TMemoryStream.Create;

                try
                  PictureData.SaveToStream(MemoryStream);

                  with PlacePictureDataQuery do
                  begin
                    Parameters.ParamValues['id'] := PlacePicturesDataSet.FieldValues['id'];

                    Open;

                    try
                      Edit;
                      MemoryStream.Position := 0;
                      TBlobField(FieldByName('picture_data')).LoadFromStream(MemoryStream);
                      Post;
                    finally
                      Close;
                    end;
                  end;
                finally
                  FreeAndNil(MemoryStream);
                end;

                LandscapeDB.Commit;

                WriteToLog(rsPlacePictureLoadingOK);
                InfoMsg(rsPlacePictureLoadingOK);
              except
                on E: Exception do
                begin
                  LandscapeDB.Rollback;

                  WriteToLog(rsPlacePictureLoadingError);
                  ShowApplicationError(rsPlacePictureLoadingError, E.Message);
                end;
              end;
            end
            else
            begin
              ErrorMsg(Format(rsTooBigImage, [MinImageDimensions, MaxImageDimensions, MinImageCapacity, MaxImageCapacity]));
            end;
          finally
            FreeAndNil(PictureData);
          end;
        except
          on E: Exception do
          begin
            WriteToLog(rsCanNotOpenImage);
            ShowApplicationError(rsCanNotOpenImage, E.message);
          end;
        end;
      end
      else
      begin
        ErrorMsg(Format(rsTooBigFile, [ImageSizeLimit]));
      end;
    end;
  end;
end;

procedure TPlacePicturesForm.LoadPlacePictureFromFileMIClick(Sender: TObject);
begin
  LoadPlacePictureFromFile;
end;

end.
