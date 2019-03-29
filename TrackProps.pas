unit TrackProps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Utils, DialMessages, Placemnt, DataErrors, DB,
  DBCtrls, RxMemDS, DBConnection, RxLookup, ADODB;

type
  TTrackPropsForm = class(TForm)
    RecordGroupBox: TGroupBox;
    CancelButton: TButton;
    OKButton: TButton;
    VisibleNameEdit: TEdit;
    VisibleNameLabel: TLabel;
    FormPlacement: TFormPlacement;
    CategoriesDataSet: TRxMemoryData;
    CategoryLabel: TLabel;
    CategoriesDataSource: TDataSource;
    CategoryComboBox: TRxDBLookupCombo;
    CategoriesQuery: TADOQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TrackPropsForm: TTrackPropsForm;

function AskTrackProps(var CategoryID: TRecordID;
  var VisibleName: string): Boolean;

implementation

{$R *.dfm}

resourcestring
  rsCategoryEmpty = 'Необходимо указать категорию!';
  rsVisibleNameEmpty = 'Название не может быть пустым!';

function AskTrackProps(var CategoryID: TRecordID;
  var VisibleName: string): Boolean;
begin
  with TTrackPropsForm.Create(Application) do
  begin
    try
      CategoryComboBox.KeyValue := CategoryID;
      VisibleNameEdit.Text := VisibleName;

      ShowModal;

      if ModalResult = mrOk then
      begin
        CategoryID := CategoryComboBox.KeyValue;
        VisibleName := VisibleNameEdit.Text;

        Result := True;
      end
      else
      begin
        Result := False;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TTrackPropsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ErrorStr: string;
begin
  if ModalResult = mrOk then
  begin
    ErrorStr := EmptyStr;
    CheckError(CategoryComboBox.Text = EmptyStr, ErrorStr, rsCategoryEmpty);
    CheckError(VisibleNameEdit.Text = EmptyStr, ErrorStr, rsVisibleNameEmpty);

    TryCloseModal(ErrorStr, Action);
  end;
end;

procedure TTrackPropsForm.FormCreate(Sender: TObject);
begin
  FillDataSet(CategoriesDataSet, CategoriesQuery, [], []);
end;

end.
