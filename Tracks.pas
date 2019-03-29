unit Tracks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, cxCheckBox, StdCtrls, ExtCtrls, Placemnt,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, cxMemo, cxTextEdit, cxCalendar,
  Utils, DBConnection, Menus, DB, ADODB, DialMessages, TrackProps,
  TextEdit, cxDBData, cxGridDBTableView, RxMemDS, cxTimeEdit, Log, Error;

type
  TTracksForm = class(TForm)
    FormPlacement: TFormPlacement;
    TracksPopupMenu: TPopupMenu;
    EditTrackMI: TMenuItem;
    DeleteTrackMI: TMenuItem;
    TrackInfoSeparatorMI: TMenuItem;
    SetTrackCommentTextMI: TMenuItem;
    ActionPanel: TPanel;
    CancelButton: TButton;
    CategoryLevel: TcxGridLevel;
    CategoryGrid: TcxGrid;
    TracksSplitter: TSplitter;
    TracksPanel: TPanel;
    TracksGrid: TcxGrid;
    TracksLevel: TcxGridLevel;
    TrackCommentTextMemo: TMemo;
    CommentTextSplitter: TSplitter;
    CategoriesDataSet: TRxMemoryData;
    CategoriesDataSource: TDataSource;
    CategoryView: TcxGridDBTableView;
    CategoryViewVisibleNameColumn: TcxGridDBColumn;
    CategoriesQuery: TADOQuery;
    TracksView: TcxGridDBTableView;
    TracksViewCreatedColumn: TcxGridDBColumn;
    TracksViewVisibleNameColumn: TcxGridDBColumn;
    TracksViewStepCountColumn: TcxGridDBColumn;
    TracksQuery: TADOQuery;
    TracksDataSet: TRxMemoryData;
    TracksDataSource: TDataSource;
    TrackCommentTextQuery: TADOQuery;
    TracksRecordQuery: TADOQuery;
    procedure SetTrackCommentTextMIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CategoriesDataSetAfterScroll(DataSet: TDataSet);
    procedure TracksDataSetAfterScroll(DataSet: TDataSet);
    procedure EditTrackMIClick(Sender: TObject);
    procedure DeleteTrackMIClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetControls;
    procedure EditTrack;
    procedure DeleteTrack;
    procedure SetTrackCommentText;
  public
    { Public declarations }
  end;

var
  TracksForm: TTracksForm;

implementation

{$R *.dfm}

resourcestring
  rsTrackEditing = 'Изменение трека...';
  rsTrackEditingOK = 'Трек изменен.';
  rsTrackEditingError = 'Не удалось изменить трек!';
  rsTrackDeleting = 'Удаление трека...';
  rsTrackDeletingQuestion = 'Удалить выбранный трек?';
  rsTrackDeletingOK = 'Трек удален.';
  rsTrackDeletingError = 'Не удалось удалить трек!';
  rsTrackDescriptionCaption = ' - описание трека';
  rsTrackDescriptionEditing = 'Изменение описания трека...';
  rsTrackDescriptionEditingOK = 'Описание трека изменено.';
  rsTrackDescriptionEditingError = 'Не удалось изменить описание трека!';

procedure TTracksForm.SetTrackCommentTextMIClick(Sender: TObject);
begin
  SetTrackCommentText;
end;

procedure TTracksForm.FormCreate(Sender: TObject);
begin
  FillDataSet(CategoriesDataSet, CategoriesQuery, [], []);
  
  SetControls;
end;

procedure TTracksForm.CategoriesDataSetAfterScroll(DataSet: TDataSet);
begin
  if not CategoriesDataSet.ControlsDisabled then
  begin
    FillDataSet(TracksDataSet, TracksQuery, ['category_id'], [CategoriesDataSet.FieldValues['id']]);

    SetControls;
  end;
end;

procedure TTracksForm.TracksDataSetAfterScroll(DataSet: TDataSet);
var
  MemoryStream: TMemoryStream;
begin
  if not TracksDataSet.ControlsDisabled then
  begin
    SetControls;

    if TracksDataSet.RecordCount > 0 then
    begin
      MemoryStream := TMemoryStream.Create;

      try
        with TrackCommentTextQuery do
        begin
          Parameters.ParamValues['id'] := TracksDataSet.FieldValues['id'];

          Open;

          try
            TBlobField(FieldByName('comment_text')).SaveToStream(MemoryStream);
          finally
            Close;
          end;
        end;

        MemoryStream.Position := 0;
        TrackCommentTextMemo.Lines.LoadFromStream(MemoryStream);
      finally
        FreeAndNil(MemoryStream);
      end;
    end;
  end;
end;

procedure TTracksForm.SetControls;
begin
  TrackCommentTextMemo.Lines.Clear;

  EditTrackMI.Enabled := TracksDataSet.RecordCount > 0;
  DeleteTrackMI.Enabled := TracksDataSet.RecordCount > 0;
  SetTrackCommentTextMI.Enabled := TracksDataSet.RecordCount > 0;
end;

procedure TTracksForm.SetTrackCommentText;
var
  MemoryStream: TMemoryStream;
begin
  with TTextEditForm.Create(Self) do
  begin
    try
      Caption := TracksDataSet.FieldValues['visible_name'] + rsTrackDescriptionCaption;
      TextEditMemo.Text := TrackCommentTextMemo.Text;

      ShowModal;

      if ModalResult = mrOk then
      begin
        WriteToLog(rsTrackDescriptionEditing);

        LandscapeDB.BeginTransaction;

        try
          MemoryStream := TMemoryStream.Create;

          try
            TextEditMemo.Lines.SaveToStream(MemoryStream);

            with TrackCommentTextQuery do
            begin
              Parameters.ParamValues['id'] := TracksDataSet.FieldValues['id'];

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

            TrackCommentTextMemo.Text := TextEditMemo.Text;
          finally
            FreeAndNil(MemoryStream);
          end;

          LandscapeDB.Commit;

          WriteToLog(rsTrackDescriptionEditingOK);
        except
          on E: Exception do
          begin
            LandscapeDB.Rollback;

            WriteToLog(rsTrackDescriptionEditingError);
            ShowApplicationError(rsTrackDescriptionEditingError, E.Message);
          end;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TTracksForm.DeleteTrack;
var
  ID: TRecordID;
begin
  ID := TracksDataSet.FieldValues['id'];

  if QuestionMsg(rsTrackDeletingQuestion) = IDYES then
  begin
    WriteToLog(rsTrackDeleting);

    LandscapeDB.BeginTransaction;
    try
      LandscapeDB.DeleteTrack(ID);
      RetrieveDatSetRecord(TracksDataSet, TracksRecordQuery, ['id', 'category_id'], [ID, CategoriesDataSet.FieldValues['id']]);
      LandscapeDB.Commit;

      WriteToLog(rsTrackDeletingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        WriteToLog(rsTrackDeletingError);
        ShowApplicationError(rsTrackDeletingError, E.Message);
      end;
    end;
  end;
end;

procedure TTracksForm.EditTrack;
var
  ID: TRecordID;
  CategoryID: TRecordID;
  VisibleName: string;
begin
  ID := TracksDataSet.FieldValues['id'];
  CategoryID := CategoriesDataSet.FieldValues['id'];
  VisibleName := TracksDataSet.FieldValues['visible_name'];

  if AskTrackProps(CategoryID, VisibleName) then
  begin
    WriteToLog(rsTrackEditing);

    LandscapeDB.BeginTransaction;
    try
      LandscapeDB.EditTrack(ID, CategoryID, VisibleName);
      RetrieveDatSetRecord(TracksDataSet, TracksRecordQuery, ['id', 'category_id'], [ID, CategoriesDataSet.FieldValues['id']]);
      LandscapeDB.Commit;

      WriteToLog(rsTrackEditingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        WriteToLog(rsTrackEditingError);
        ShowApplicationError(rsTrackEditingError, E.Message);
      end;
    end;
  end;
end;

procedure TTracksForm.EditTrackMIClick(Sender: TObject);
begin
  EditTrack;
end;

procedure TTracksForm.DeleteTrackMIClick(Sender: TObject);
begin
  DeleteTrack;
end;

end.
