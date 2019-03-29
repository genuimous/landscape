unit Places;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, cxTextEdit, StdCtrls, ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxClasses, cxControls,
  cxGridCustomView, cxGrid, DB, ADODB, DBConnection, Utils, TextEdit,
  Menus, Placemnt, PlaceProps, Geoid, DialMessages, PlacePictures,
  cxDBData, RxMemDS, cxGridDBTableView, Math, Log, Error;

type
  TPlacesForm = class(TForm)
    TracksSplitter: TSplitter;
    ActionPanel: TPanel;
    CancelButton: TButton;
    CategoryGrid: TcxGrid;
    CategoryView: TcxGridDBTableView;
    CategoryViewVisibleNameColumn: TcxGridDBColumn;
    CategoryLevel: TcxGridLevel;
    PlacesPanel: TPanel;
    CommentTextSplitter: TSplitter;
    PlacesGrid: TcxGrid;
    PlacesView: TcxGridDBTableView;
    PlacesViewVisibleNameColumn: TcxGridDBColumn;
    PlacesViewCreatedColumn: TcxGridDBColumn;
    PlacesLevel: TcxGridLevel;
    PlaceCommentTextMemo: TMemo;
    CategoriesDataSet: TRxMemoryData;
    CategoriesDataSource: TDataSource;
    CategoriesQuery: TADOQuery;
    PlacesQuery: TADOQuery;
    PlacesDataSet: TRxMemoryData;
    PlacesDataSource: TDataSource;
    PlaceCommentTextQuery: TADOQuery;
    PlacesRecordQuery: TADOQuery;
    PlacesViewLatitudeDegreeColumn: TcxGridDBColumn;
    PlacesViewLongitudeDegreeColumn: TcxGridDBColumn;
    PlacesViewAltitudeColumn: TcxGridDBColumn;
    PlacesPopupMenu: TPopupMenu;
    EditPlaceMI: TMenuItem;
    DeletePlaceMI: TMenuItem;
    TrackInfoSeparatorMI: TMenuItem;
    SetPlaceCommentTextMI: TMenuItem;
    PlacesViewIdentityNameColumn: TcxGridDBColumn;
    ShowPlacePicturesMI: TMenuItem;
    PlacesViewPictureCountColumn: TcxGridDBColumn;
    FormPlacement: TFormPlacement;
    procedure CategoriesDataSetAfterScroll(DataSet: TDataSet);
    procedure PlacesDataSetBeforePost(DataSet: TDataSet);
    procedure PlacesDataSetAfterScroll(DataSet: TDataSet);
    procedure EditPlaceMIClick(Sender: TObject);
    procedure DeletePlaceMIClick(Sender: TObject);
    procedure SetPlaceCommentTextMIClick(Sender: TObject);
    procedure ShowPlacePicturesMIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure SetControls;
    procedure EditPlace;
    procedure DeletePlace;
    procedure SetPlaceCommentText;
    procedure ShowPlacePictures;
  public
    { Public declarations }
  end;

var
  PlacesForm: TPlacesForm;

implementation

{$R *.dfm}

resourcestring
  rsPlaceEditing = 'Изменение объекта...';
  rsPlaceEditingOK = 'Объект изменен.';
  rsPlaceEditingError = 'Не удалось изменить объект!';
  rsPlaceDeleting = 'Удаление объекта...';
  rsPlaceDeletingQuestion = 'Удалить выбранный объект?';
  rsPlaceDeletingOK = 'Объект удален.';
  rsPlaceDeletingError = 'Не удалось удалить объект!';
  rsPlaceDescriptionCaption = 'Описание объекта %s';
  rsPlaceDescriptionEditing = 'Изменение описания объекта...';
  rsPlaceDescriptionEditingOK = 'Описание объекта изменено.';
  rsPlaceDescriptionEditingError = 'Не удалось изменить описание объекта!';
  rsPlacePicturesCaption = 'Изображения объекта %s';

procedure TPlacesForm.CategoriesDataSetAfterScroll(DataSet: TDataSet);
begin
  if not CategoriesDataSet.ControlsDisabled then
  begin
    FillDataSet(PlacesDataSet, PlacesQuery, ['category_id'], [CategoriesDataSet.FieldValues['id']]);

    SetControls;
  end;
end;

procedure TPlacesForm.PlacesDataSetBeforePost(DataSet: TDataSet);
begin
  with PlacesDataSet do
  begin
    FieldValues['latitude_degree'] := RoundTo(EncodeLatitude(FieldValues['latitude']), -CoordinatesDegreeRoundSigns);
    FieldValues['longitude_degree'] := RoundTo(EncodeLatitude(FieldValues['longitude']), -CoordinatesDegreeRoundSigns);
  end;
end;

procedure TPlacesForm.SetControls;
begin
  PlaceCommentTextMemo.Lines.Clear;

  EditPlaceMI.Enabled := PlacesDataSet.RecordCount > 0;
  DeletePlaceMI.Enabled := PlacesDataSet.RecordCount > 0;
  SetPlaceCommentTextMI.Enabled := PlacesDataSet.RecordCount > 0;
  ShowPlacePicturesMI.Enabled := PlacesDataSet.RecordCount > 0;
end;

procedure TPlacesForm.PlacesDataSetAfterScroll(DataSet: TDataSet);
var
  MemoryStream: TMemoryStream;
begin
  if not PlacesDataSet.ControlsDisabled then
  begin
    SetControls;

    if PlacesDataSet.RecordCount > 0 then
    begin
      MemoryStream := TMemoryStream.Create;

      try
        with PlaceCommentTextQuery do
        begin
          Parameters.ParamValues['id'] := PlacesDataSet.FieldValues['id'];

          Open;

          try
            TBlobField(FieldByName('comment_text')).SaveToStream(MemoryStream);
          finally
            Close;
          end;
        end;

        MemoryStream.Position := 0;
        PlaceCommentTextMemo.Lines.LoadFromStream(MemoryStream);
      finally
        FreeAndNil(MemoryStream);
      end;
    end;
  end;
end;

procedure TPlacesForm.DeletePlace;
var
  ID: TRecordID;
begin
  ID := PlacesDataSet.FieldValues['id'];

  if QuestionMsg(rsPlaceDeletingQuestion) = IDYES then
  begin
    WriteToLog(rsPlaceDeleting);

    LandscapeDB.BeginTransaction;
    try
      LandscapeDB.DeletePlace(ID);
      RetrieveDatSetRecord(PlacesDataSet, PlacesRecordQuery, ['id', 'category_id'], [ID, CategoriesDataSet.FieldValues['id']]);
      LandscapeDB.Commit;

      WriteToLog(rsPlaceDeletingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        WriteToLog(rsPlaceDeletingError);
        ShowApplicationError(rsPlaceDeletingError, E.Message);
      end;
    end;
  end;
end;

procedure TPlacesForm.EditPlace;
var
  ID: TRecordID;
  CategoryID: TRecordID;
  Latitude, Longitude: Integer;
  IdentityName, VisibleName: string;
begin
  ID := PlacesDataSet.FieldValues['id'];
  CategoryID := CategoriesDataSet.FieldValues['id'];
  Latitude := PlacesDataSet.FieldValues['latitude'];
  Longitude := PlacesDataSet.FieldValues['longitude'];
  IdentityName := PlacesDataSet.FieldValues['identity_name'];
  VisibleName := PlacesDataSet.FieldValues['visible_name'];

  if AskPlaceProps(CategoryID, Latitude, Longitude, IdentityName, VisibleName) then
  begin
    WriteToLog(rsPlaceEditing);

    LandscapeDB.BeginTransaction;
    try
      LandscapeDB.EditPlace(ID, CategoryID, Latitude, Longitude, IdentityName, VisibleName);
      RetrieveDatSetRecord(PlacesDataSet, PlacesRecordQuery, ['id', 'category_id'], [ID, CategoriesDataSet.FieldValues['id']]);
      LandscapeDB.Commit;

      WriteToLog(rsPlaceEditingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        WriteToLog(rsPlaceEditingError);
        ShowApplicationError(rsPlaceEditingError, E.Message);
      end;
    end;
  end;
end;

procedure TPlacesForm.EditPlaceMIClick(Sender: TObject);
begin
  EditPlace;
end;

procedure TPlacesForm.DeletePlaceMIClick(Sender: TObject);
begin
  DeletePlace;
end;

procedure TPlacesForm.SetPlaceCommentText;
var
  MemoryStream: TMemoryStream;
begin
  with TTextEditForm.Create(Self) do
  begin
    try
      Caption := Format(rsPlaceDescriptionCaption, [PlacesDataSet.FieldValues['visible_name']]);
      TextEditMemo.Text := PlaceCommentTextMemo.Text;

      ShowModal;

      if ModalResult = mrOk then
      begin
        WriteToLog(rsPlaceDescriptionEditing);

        LandscapeDB.BeginTransaction;

        try
          MemoryStream := TMemoryStream.Create;

          try
            TextEditMemo.Lines.SaveToStream(MemoryStream);

            with PlaceCommentTextQuery do
            begin
              Parameters.ParamValues['id'] := PlacesDataSet.FieldValues['id'];

              Open;

              try
                Edit;
                MemoryStream.Position := 0;
                TBlobField(FieldByName('comment_text')).LoadFromStream(MemoryStream);
                Post;
              finally
                Close;
              end;
            end;

            PlaceCommentTextMemo.Text := TextEditMemo.Text;
          finally
            FreeAndNil(MemoryStream);
          end;

          LandscapeDB.Commit;

          WriteToLog(rsPlaceDescriptionEditingOK);
        except
          on E: Exception do
          begin
            LandscapeDB.Rollback;

            WriteToLog(rsPlaceDescriptionEditingError);
            ShowApplicationError(rsPlaceDescriptionEditingError, E.Message);
          end;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TPlacesForm.SetPlaceCommentTextMIClick(Sender: TObject);
begin
  SetPlaceCommentText;
end;

procedure TPlacesForm.ShowPlacePicturesMIClick(Sender: TObject);
begin
  ShowPlacePictures;
end;

procedure TPlacesForm.ShowPlacePictures;
begin
  with TPlacePicturesForm.CreatePlace(PlacesDataSet.FieldValues['id']) do
  begin
    try
      Caption := Format(rsPlacePicturesCaption, [PlacesDataSet.FieldValues['visible_name']]);
      ShowModal;
      
      PlacesDataSet.Edit;
      PlacesDataSet.FieldValues['picture_count'] := PlacePicturesDataSet.RecordCount;
      PlacesDataSet.Post;
    finally
      Free;
    end;
  end;
end;

procedure TPlacesForm.FormCreate(Sender: TObject);
begin
  FillDataSet(CategoriesDataSet, CategoriesQuery, [], []);
  
  SetControls;
end;

end.
