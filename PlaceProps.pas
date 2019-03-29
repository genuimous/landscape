unit PlaceProps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Utils, DialMessages, Placemnt, Geoid, ADODB,
  DB, RxMemDS, RxLookup, DataErrors, Math;

type
  TPlacePropsForm = class(TForm)
    RecordGroupBox: TGroupBox;
    VisibleNameLabel: TLabel;
    CategoryLabel: TLabel;
    VisibleNameEdit: TEdit;
    CategoryComboBox: TRxDBLookupCombo;
    CancelButton: TButton;
    OKButton: TButton;
    FormPlacement: TFormPlacement;
    CategoriesDataSet: TRxMemoryData;
    CategoriesDataSource: TDataSource;
    CategoriesQuery: TADOQuery;
    LatitudeDegreeLabel: TLabel;
    LatitudeDegreeEdit: TEdit;
    LongitudeDegreeLabel: TLabel;
    LongitudeDegreeEdit: TEdit;
    IdentityNameLabel: TLabel;
    IdentityNameEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LatitudeDegreeEditExit(Sender: TObject);
    procedure LongitudeDegreeEditExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PlacePropsForm: TPlacePropsForm;

function AskPlaceProps(var CategoryID: TRecordID; var Latitude,
  Longitude: Integer; var IdentityName, VisibleName: string): Boolean;

implementation

{$R *.dfm}

resourcestring
  rsWrongValue = 'Неверное значение!';
  rsLatitudeDegreeRange = 'Широта должна быть в пределах от %d до %d градусов включительно!';
  rsLongitudeDegreeRange = 'Долгота должна быть в пределах от %d до %d градусов включительно!';
  rsCategoryEmpty = 'Необходимо указать категорию!';
  rsCoordinatesEmpty = 'Необходимо указать координаты!';
  rsIdentityNameEmpty = 'Идентификатор не может быть пустым!';
  rsVisibleNameEmpty = 'Название не может быть пустым!';

function AskPlaceProps(var CategoryID: TRecordID; var Latitude,
  Longitude: Integer; var IdentityName, VisibleName: string): Boolean;
begin
  with TPlacePropsForm.Create(Application) do
  begin
    try
      CategoryComboBox.KeyValue := CategoryID;
      LatitudeDegreeEdit.Text := FloatToStr(RoundTo(EncodeLatitude(Latitude), -CoordinatesDegreeRoundSigns));
      LongitudeDegreeEdit.Text := FloatToStr(RoundTo(EncodeLatitude(Longitude), -CoordinatesDegreeRoundSigns));
      IdentityNameEdit.Text := IdentityName;
      VisibleNameEdit.Text := VisibleName;

      ShowModal;

      if ModalResult = mrOk then
      begin
        CategoryID := CategoryComboBox.KeyValue;
        Latitude := DecodeLatitude(StrToFloat(LatitudeDegreeEdit.Text));
        Longitude := DecodeLatitude(StrToFloat(LongitudeDegreeEdit.Text));
        IdentityName := IdentityNameEdit.Text;
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

procedure TPlacePropsForm.FormCreate(Sender: TObject);
begin
  FillDataSet(CategoriesDataSet, CategoriesQuery, [], []);
end;

procedure TPlacePropsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ErrorStr: string;
begin
  if ModalResult = mrOk then
  begin
    ErrorStr := EmptyStr;
    CheckError(CategoryComboBox.Text = EmptyStr, ErrorStr, rsCategoryEmpty);
    CheckError((LatitudeDegreeEdit.Text = EmptyStr) or (LongitudeDegreeEdit.Text = EmptyStr), ErrorStr, rsCoordinatesEmpty);
    CheckError(IdentityNameEdit.Text = EmptyStr, ErrorStr, rsIdentityNameEmpty);
    CheckError(VisibleNameEdit.Text = EmptyStr, ErrorStr, rsVisibleNameEmpty);

    TryCloseModal(ErrorStr, Action);
  end;
end;

procedure TPlacePropsForm.LatitudeDegreeEditExit(Sender: TObject);
begin
  with LatitudeDegreeEdit do
  begin
    if Text <> EmptyStr then
    begin
      if IsError(not StrIsNumber(Text, True), rsWrongValue) then
      begin
        SetFocus;
      end
      else
      begin
        if IsError((StrToFloat(Text) < MinLatitudeDegree) or (StrToFloat(Text) > MaxLatitudeDegree), Format(rsLatitudeDegreeRange, [MinLatitudeDegree, MaxLatitudeDegree])) then
        begin
          SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TPlacePropsForm.LongitudeDegreeEditExit(Sender: TObject);
begin
  with LongitudeDegreeEdit do
  begin
    if Text <> EmptyStr then
    begin
      if IsError(not StrIsNumber(Text, True), rsWrongValue) then
      begin
        SetFocus;
      end
      else
      begin
        if IsError((StrToFloat(Text) < MinLongitudeDegree) or (StrToFloat(Text) > MaxLongitudeDegree), Format(rsLongitudeDegreeRange, [MinLongitudeDegree, MaxLongitudeDegree])) then
        begin
          SetFocus;
        end;
      end;
    end;
  end;
end;

end.
