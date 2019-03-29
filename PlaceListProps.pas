unit PlaceListProps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DB, RxMemDS, Placemnt, StdCtrls, RxLookup, Utils, DataErrors;

type
  TPlaceListPropsForm = class(TForm)
    RecordGroupBox: TGroupBox;
    CategoryLabel: TLabel;
    CategoryComboBox: TRxDBLookupCombo;
    CancelButton: TButton;
    OKButton: TButton;
    FormPlacement: TFormPlacement;
    CategoriesDataSet: TRxMemoryData;
    CategoriesDataSource: TDataSource;
    CategoriesQuery: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PlaceListPropsForm: TPlaceListPropsForm;

function AskPlaceListProps(var CategoryID: TRecordID): Boolean;

implementation

{$R *.dfm}

resourcestring
  rsCategoryEmpty = 'Необходимо указать категорию!';

function AskPlaceListProps(var CategoryID: TRecordID): Boolean;
begin
  with TPlaceListPropsForm.Create(Application) do
  begin
    try
      CategoryComboBox.KeyValue := CategoryID;

      ShowModal;

      if ModalResult = mrOk then
      begin
        CategoryID := CategoryComboBox.KeyValue;

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

procedure TPlaceListPropsForm.FormCreate(Sender: TObject);
begin
  FillDataSet(CategoriesDataSet, CategoriesQuery, [], []);
end;

procedure TPlaceListPropsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ErrorStr: string;
begin
  if ModalResult = mrOk then
  begin
    ErrorStr := EmptyStr;
    CheckError(CategoryComboBox.Text = EmptyStr, ErrorStr, rsCategoryEmpty);

    TryCloseModal(ErrorStr, Action);
  end;
end;

end.
