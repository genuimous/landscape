unit CalcProps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Placemnt, DialMessages, Utils, Geoid,
  DataErrors;

type
  TCalcPropsForm = class(TForm)
    CalcGroupBox: TGroupBox;
    StartPointLabel: TLabel;
    EndPointLabel: TLabel;
    CancelButton: TButton;
    OKButton: TButton;
    SearchAreaGroupBox: TGroupBox;
    LatBetweenLabel: TLabel;
    LonBetweenLabel: TLabel;
    StartLatitudeBorderEdit: TEdit;
    EndLatitudeBorderEdit: TEdit;
    StartLatBorderLabel: TLabel;
    EndLatBorderLabel: TLabel;
    StartLongitudeBorderEdit: TEdit;
    EndLongitudeBorderEdit: TEdit;
    StartLonBorderLabel: TLabel;
    EndLonBorderLabel: TLabel;
    StartLatitudeEdit: TEdit;
    EndLatitudeEdit: TEdit;
    StartLongitudeEdit: TEdit;
    EndLongitudeEdit: TEdit;
    StartLatLabel: TLabel;
    StartLonLabel: TLabel;
    EndLatLabel: TLabel;
    EndLonLabel: TLabel;
    FormPlacement: TFormPlacement;
    procedure StartLatitudeBorderEditExit(Sender: TObject);
    procedure EndLatitudeBorderEditExit(Sender: TObject);
    procedure StartLongitudeBorderEditExit(Sender: TObject);
    procedure EndLongitudeBorderEditExit(Sender: TObject);
    procedure StartLatitudeEditExit(Sender: TObject);
    procedure EndLatitudeEditExit(Sender: TObject);
    procedure StartLongitudeEditExit(Sender: TObject);
    procedure EndLongitudeEditExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CalcPropsForm: TCalcPropsForm;

implementation

{$R *.dfm}

resourcestring
  rsWrongValue = 'Неверное значение!';
  rsLatitudeDegreeRange = 'Широта должна быть в пределах от %d до %d градусов включительно!';
  rsLongitudeDegreeRange = 'Долгота должна быть в пределах от %d до %d градусов включительно!';
  rsSearchAreaEmpty = 'Не задана область поиска!';
  rsStartPointEmpty = 'Не заданы координаты начальной точки!';
  rsEndPointEmpty = 'Не заданы координаты конечной точки!';
  rsBadSearchArea = 'Неверно задана область поиска!';
  rsStartEqualsToEnd = 'Начальная и конечная точки не могут быть равны!';

procedure TCalcPropsForm.StartLatitudeBorderEditExit(Sender: TObject);
begin
  with StartLatitudeBorderEdit do
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

procedure TCalcPropsForm.EndLatitudeBorderEditExit(Sender: TObject);
begin
  with EndLatitudeBorderEdit do
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

procedure TCalcPropsForm.StartLongitudeBorderEditExit(Sender: TObject);
begin
  with StartLongitudeBorderEdit do
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

procedure TCalcPropsForm.EndLongitudeBorderEditExit(Sender: TObject);
begin
  with EndLongitudeBorderEdit do
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

procedure TCalcPropsForm.StartLatitudeEditExit(Sender: TObject);
begin
  with StartLatitudeEdit do
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

procedure TCalcPropsForm.EndLatitudeEditExit(Sender: TObject);
begin
  with EndLatitudeEdit do
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

procedure TCalcPropsForm.StartLongitudeEditExit(Sender: TObject);
begin
  with StartLongitudeEdit do
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

procedure TCalcPropsForm.EndLongitudeEditExit(Sender: TObject);
begin
  with EndLongitudeEdit do
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

procedure TCalcPropsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ErrorStr: string;
begin
  if ModalResult = mrOk then
  begin
    ErrorStr := EmptyStr;
    CheckError((StartLatitudeBorderEdit.Text = EmptyStr) or (EndLatitudeBorderEdit.Text = EmptyStr) or (StartLongitudeBorderEdit.Text = EmptyStr) or (EndLongitudeBorderEdit.Text = EmptyStr), ErrorStr, rsSearchAreaEmpty);
    CheckError((StartLatitudeEdit.Text = EmptyStr) or (StartLongitudeEdit.Text = EmptyStr), ErrorStr, rsStartPointEmpty);
    CheckError((EndLatitudeEdit.Text = EmptyStr) or (EndLongitudeEdit.Text = EmptyStr), ErrorStr, rsEndPointEmpty);
    if (StartLatitudeBorderEdit.Text <> EmptyStr) and (EndLatitudeBorderEdit.Text <> EmptyStr) and (StartLongitudeBorderEdit.Text <> EmptyStr) and (EndLongitudeBorderEdit.Text <> EmptyStr) then
    begin
      CheckError((StrToFloat(StartLatitudeBorderEdit.Text) >= StrToFloat(EndLatitudeBorderEdit.Text)) or (StrToFloat(StartLongitudeBorderEdit.Text) = StrToFloat(EndLongitudeBorderEdit.Text)), ErrorStr, rsBadSearchArea);
    end;
    if (StartLatitudeEdit.Text <> EmptyStr) and (StartLongitudeEdit.Text <> EmptyStr) and (EndLatitudeEdit.Text <> EmptyStr) and (EndLongitudeEdit.Text <> EmptyStr) then
    begin
      CheckError((StrToFloat(StartLatitudeEdit.Text) = StrToFloat(EndLatitudeEdit.Text)) or (StrToFloat(StartLongitudeEdit.Text) = StrToFloat(EndLongitudeEdit.Text)), ErrorStr, rsStartEqualsToEnd);
    end;

    TryCloseModal(ErrorStr, Action);
  end;
end;

end.
