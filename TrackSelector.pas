unit TrackSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxTextEdit, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, StdCtrls, ExtCtrls, RxLookup,
  RxMemDS, ADODB, DBConnection, Utils, Placemnt;

type
  TTrackSelectorForm = class(TForm)
    CategoryPanel: TPanel;
    ActionPanel: TPanel;
    OKButton: TButton;
    CancelButton: TButton;
    TracksGrid: TcxGrid;
    TracksView: TcxGridDBTableView;
    TracksViewCreatedColumn: TcxGridDBColumn;
    TracksViewVisibleNameColumn: TcxGridDBColumn;
    TracksLevel: TcxGridLevel;
    CategoryComboBox: TRxDBLookupCombo;
    CategoryLabel: TLabel;
    UserOnlyCheckBox: TCheckBox;
    CategoriesQuery: TADOQuery;
    CategoriesDataSet: TRxMemoryData;
    CategoriesDataSource: TDataSource;
    TracksQuery: TADOQuery;
    TracksDataSource: TDataSource;
    TracksDataSet: TRxMemoryData;
    TracksViewCreatedByVisibleNameColumn: TcxGridDBColumn;
    TracksViewStepCountColumn: TcxGridDBColumn;
    FormPlacement: TFormPlacement;
    procedure FormCreate(Sender: TObject);
    procedure CategoryComboBoxChange(Sender: TObject);
    procedure UserOnlyCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshTracks;
    procedure SetControls;
  public
    { Public declarations }
  end;

var
  TrackSelectorForm: TTrackSelectorForm;

implementation

{$R *.dfm}

procedure TTrackSelectorForm.FormCreate(Sender: TObject);
begin
  FillDataSet(CategoriesDataSet, CategoriesQuery, [], []);
end;

procedure TTrackSelectorForm.SetControls;
begin
  OKButton.Enabled := TracksDataSet.RecordCount > 0;
end;

procedure TTrackSelectorForm.CategoryComboBoxChange(Sender: TObject);
begin
  RefreshTracks;
end;

procedure TTrackSelectorForm.UserOnlyCheckBoxClick(Sender: TObject);
begin
  if CategoryComboBox.KeyValue <> Null then
  begin
    RefreshTracks;
  end;
end;

procedure TTrackSelectorForm.RefreshTracks;
begin
  FillDataSet(TracksDataSet, TracksQuery, ['category_id', 'user_only'], [CategoryComboBox.KeyValue, UserOnlyCheckBox.Checked]);
  SetControls;
end;

end.
