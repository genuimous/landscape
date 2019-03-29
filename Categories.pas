unit Categories;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, ExtCtrls, RxMemDS, DBConnection,
  DBTables, Menus, CategoryProps, DB, cxDBData, Utils, cxLabel, cxTextEdit,
  DialMEssages, ADODB, cxCheckBox, Log, Error, Placemnt;

type
  TCategoriesForm = class(TForm)
    ActionPanel: TPanel;
    CancelButton: TButton;
    CategoryView: TcxGridDBTableView;
    CategoryLevel: TcxGridLevel;
    CategoryGrid: TcxGrid;
    CategoryDataSource: TDataSource;
    CategoryViewVisibleNameColumn: TcxGridDBColumn;
    CategoriesDataSet: TRxMemoryData;
    CategoriesPopupMenu: TPopupMenu;
    CreateCategoryMI: TMenuItem;
    EditCategoryMI: TMenuItem;
    DeleteCategoryMI: TMenuItem;
    CategoriesQuery: TADOQuery;
    CategoriesRecordQuery: TADOQuery;
    CategoryViewTrackCountColumn: TcxGridDBColumn;
    CategoryViewPlaceCountColumn: TcxGridDBColumn;
    CategoryViewObsoleteColumn: TcxGridDBColumn;
    FormPlacement: TFormPlacement;
    procedure FormShow(Sender: TObject);
    procedure CreateCategoryMIClick(Sender: TObject);
    procedure EditCategoryMIClick(Sender: TObject);
    procedure DeleteCategoryMIClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetControls;
    procedure CreateCategory;
    procedure EditCategory;
    procedure DeleteCategory;
  public
    { Public declarations }
  end;

var
  CategoriesForm: TCategoriesForm;

implementation

{$R *.dfm}

resourcestring
  rsCategoryCreation = 'Создание категории...';
  rsCategoryCreationError = 'Не удалось добавить категорию!';
  rsCategoryCreationOK = 'Категория создана.';
  rsCategoryEditing = 'Изменение категории...';
  rsCategoryEditingError = 'Не удалось изменить категорию!';
  rsCategoryEditingOK = 'Категория изменена.';
  rsCategoryDeleting = 'Удаление категории...';
  rsCategoryDeletingQuestion = 'Удалить выбранную категорию?';
  rsCategoryDeletingError = 'Не удалось удалить категорию!';
  rsCategoryDeletingOK = 'Категория удалена.';

procedure TCategoriesForm.FormShow(Sender: TObject);
begin
  FillDataSet(CategoriesDataSet, CategoriesQuery, [], []);

  SetControls;
end;

procedure TCategoriesForm.CreateCategoryMIClick(Sender: TObject);
begin
  CreateCategory;
end;

procedure TCategoriesForm.EditCategoryMIClick(Sender: TObject);
begin
  EditCategory;
end;

procedure TCategoriesForm.DeleteCategoryMIClick(Sender: TObject);
begin
  DeleteCategory;
end;

procedure TCategoriesForm.SetControls;
begin
  EditCategoryMI.Enabled := CategoriesDataSet.RecordCount > 0;
  DeleteCategoryMI.Enabled := CategoriesDataSet.RecordCount > 0;
end;

procedure TCategoriesForm.CreateCategory;
var
  ID: TRecordID;
  VisibleName: string;
  Obsolete: Boolean;
begin
  VisibleName := EmptyStr;
  Obsolete := False;

  if AskCategoryProps(VisibleName, Obsolete) then
  begin
    WriteToLog(rsCategoryCreation);

    InsertDatSetRecord(CategoriesDataSet);

    LandscapeDB.BeginTransaction;
    try
      ID := LandscapeDB.CreateCategory(VisibleName, Obsolete);
      RetrieveDatSetRecord(CategoriesDataSet, CategoriesRecordQuery, ['id'], [ID]);
      LandscapeDB.Commit;

      WriteToLog(rsCategoryCreationOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        CategoriesDataSet.Delete;

        WriteToLog(rsCategoryCreationError);
        ShowApplicationError(rsCategoryCreationError, E.Message);
      end;
    end;

    SetControls;
  end;
end;

procedure TCategoriesForm.DeleteCategory;
var
  ID: TRecordID;
begin
  ID := CategoriesDataSet.FieldValues['id'];

  if QuestionMsg(rsCategoryDeletingQuestion) = IDYES then
  begin
    WriteToLog(rsCategoryDeleting);

    LandscapeDB.BeginTransaction;
    try
      LandscapeDB.DeleteCategory(ID);
      RetrieveDatSetRecord(CategoriesDataSet, CategoriesRecordQuery, ['id'], [ID]);
      LandscapeDB.Commit;

      WriteToLog(rsCategoryDeletingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;
        
        WriteToLog(rsCategoryDeletingError);
        ShowApplicationError(rsCategoryDeletingError, E.Message);
      end;
    end;

    SetControls;
  end;
end;

procedure TCategoriesForm.EditCategory;
var
  ID: TRecordID;
  VisibleName: string;
  Obsolete: Boolean;
begin
  ID := CategoriesDataSet.FieldValues['id'];
  VisibleName := CategoriesDataSet.FieldValues['visible_name'];
  Obsolete := CategoriesDataSet.FieldValues['obsolete'];

  if AskCategoryProps(VisibleName, Obsolete) then
  begin
    WriteToLog(rsCategoryEditing);

    LandscapeDB.BeginTransaction;
    try
      LandscapeDB.EditCategory(ID, VisibleName, Obsolete);
      RetrieveDatSetRecord(CategoriesDataSet, CategoriesRecordQuery, ['id'], [ID]);
      LandscapeDB.Commit;

      WriteToLog(rsCategoryEditingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        WriteToLog(rsCategoryEditingError);
        ShowApplicationError(rsCategoryEditingError, E.Message);
      end;
    end;
  end;
end;

end.
