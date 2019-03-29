unit TrackPointProps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Geoid, Math, Utils, DataErrors, DialMessages, Placemnt;

type
  TTrackPointPropsForm = class(TForm)
    RecordGroupBox: TGroupBox;
    LatitudeDegreeLabel: TLabel;
    LongitudeDegreeLabel: TLabel;
    LatitudeDegreeEdit: TEdit;
    LongitudeDegreeEdit: TEdit;
    CancelButton: TButton;
    OKButton: TButton;
    FormPlacement: TFormPlacement;
    procedure LatitudeDegreeEditExit(Sender: TObject);
    procedure LongitudeDegreeEditExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TrackPointPropsForm: TTrackPointPropsForm;

function AskTrackPointProps(var Latitude, Longitude: Integer;
  const ShowDefault: Boolean): Boolean;

implementation

{$R *.dfm}

resourcestring
  rsWrongValue = 'Неверное значение!';
  rsLatitudeDegreeRange = 'Широта должна быть в пределах от %d до %d градусов включительно!';
  rsLongitudeDegreeRange = 'Долгота должна быть в пределах от %d до %d градусов включительно!';
  rsCoordinatesEmpty = 'Необходимо указать координаты!';

function AskTrackPointProps(var Latitude, Longitude: Integer;
  const ShowDefault: Boolean): Boolean;
begin
  with TTrackPointPropsForm.Create(Application) do
  begin
    try
      if ShowDefault then
      begin
        LatitudeDegreeEdit.Text := FloatToStr(RoundTo(EncodeLatitude(Latitude), -CoordinatesDegreeRoundSigns));
        LongitudeDegreeEdit.Text := FloatToStr(RoundTo(EncodeLatitude(Longitude), -CoordinatesDegreeRoundSigns));
      end;

      ShowModal;

      if ModalResult = mrOk then
      begin
        Latitude := DecodeLatitude(StrToFloat(LatitudeDegreeEdit.Text));
        Longitude := DecodeLatitude(StrToFloat(LongitudeDegreeEdit.Text));

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

procedure TTrackPointPropsForm.LatitudeDegreeEditExit(Sender: TObject);
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

procedure TTrackPointPropsForm.LongitudeDegreeEditExit(Sender: TObject);
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

procedure TTrackPointPropsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ErrorStr: string;
begin
  if ModalResult = mrOk then
  begin
    ErrorStr := EmptyStr;
    CheckError((LatitudeDegreeEdit.Text = EmptyStr) or (LongitudeDegreeEdit.Text = EmptyStr), ErrorStr, rsCoordinatesEmpty);

    TryCloseModal(ErrorStr, Action);
  end;
end;

end.
