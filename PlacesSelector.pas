unit PlacesSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxTextEdit, RxMemDS, ADODB,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxControls, cxGridCustomView, cxGrid, StdCtrls, RxLookup,
  ExtCtrls, Utils, cxCheckBox, Placemnt;

type
  TPlacesSelectorForm = class(TForm)
    CategoryPanel: TPanel;
    CategoryLabel: TLabel;
    CategoryComboBox: TRxDBLookupCombo;
    UserOnlyCheckBox: TCheckBox;
    ActionPanel: TPanel;
    OKButton: TButton;
    CancelButton: TButton;
    PlacesGrid: TcxGrid;
    PlacesView: TcxGridDBTableView;
    PlacesViewVisibleNameColumn: TcxGridDBColumn;
    PlacesViewCreatedColumn: TcxGridDBColumn;
    PlacesViewCreatedByVisibleNameColumn: TcxGridDBColumn;
    PlacesLevel: TcxGridLevel;
    CategoriesQuery: TADOQuery;
    CategoriesDataSet: TRxMemoryData;
    CategoriesDataSource: TDataSource;
    PlacesQuery: TADOQuery;
    PlacesDataSource: TDataSource;
    PlacesDataSet: TRxMemoryData;
    PlacesViewIdentityNameColumn: TcxGridDBColumn;
    PlacesViewCheckedColumn: TcxGridDBColumn;
    FormPlacement: TFormPlacement;
    procedure FormCreate(Sender: TObject);
    procedure UserOnlyCheckBoxClick(Sender: TObject);
    procedure CategoryComboBoxChange(Sender: TObject);
    procedure PlacesDataSetAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
    procedure SetControls;
    procedure RefreshPlaces;
  public
    { Public declarations }
  end;

var
  PlacesSelectorForm: TPlacesSelectorForm;

implementation

{$R *.dfm}

procedure TPlacesSelectorForm.FormCreate(Sender: TObject);
begin
  FillDataSet(CategoriesDataSet, CategoriesQuery, [], []);
end;

procedure TPlacesSelectorForm.RefreshPlaces;
begin
  FillDataSet(PlacesDataSet, PlacesQuery, ['category_id', 'user_only'], [CategoryComboBox.KeyValue, UserOnlyCheckBox.Checked]);
  SetControls;
end;

procedure TPlacesSelectorForm.SetControls;
begin
  OKButton.Enabled := PlacesDataSet.RecordCount > 0;
end;

procedure TPlacesSelectorForm.UserOnlyCheckBoxClick(Sender: TObject);
begin
  if CategoryComboBox.KeyValue <> Null then RefreshPlaces;
end;

procedure TPlacesSelectorForm.CategoryComboBoxChange(Sender: TObject);
begin
  RefreshPlaces;
end;

procedure TPlacesSelectorForm.PlacesDataSetAfterInsert(DataSet: TDataSet);
begin
  with PlacesDataSet do
  begin
    FieldValues['checked'] := 1;
  end;
end;

end.
