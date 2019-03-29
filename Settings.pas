unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Utils, DialMessages, Placemnt, DataErrors;

type
  TSettingsForm = class(TForm)
    SettingsPageControl: TPageControl;
    MainSettingsTabSheet: TTabSheet;
    CostSettingsTabSheet: TTabSheet;
    CostSettingsGroupBox: TGroupBox;
    OKButton: TButton;
    CancelButton: TButton;
    MainSettingsGroupBox: TGroupBox;
    DistanceCostEdit: TEdit;
    HeightUpCostEdit: TEdit;
    DistanceCostLabel: TLabel;
    HeightUpCostLabel: TLabel;
    MaxPointCountEdit: TEdit;
    MaxPointCountLabel: TLabel;
    MaxAngleLabel: TLabel;
    MaxAngleEdit: TEdit;
    MaxAngleEditUpDown: TUpDown;
    HeightDownCostEdit: TEdit;
    SaveTrackOnExitCheckBox: TCheckBox;
    AngleCostLabel: TLabel;
    AngleCostEdit: TEdit;
    HeightDownCostLabel: TLabel;
    MaxAltitudeLabel: TLabel;
    MaxAltitudeEdit: TEdit;
    FormPlacement: TFormPlacement;
    procedure MaxPointCountEditExit(Sender: TObject);
    procedure DistanceCostEditExit(Sender: TObject);
    procedure HeightUpCostEditExit(Sender: TObject);
    procedure AngleCostEditExit(Sender: TObject);
    procedure MaxAltitudeEditExit(Sender: TObject);
    procedure HeightDownCostEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  MinPointCount: Integer = 1024;
  MaxPointCount: Integer = 1048576;
  MinCost: Real = 0;
  MaxCost: Real = 1;
  MinAltitude: Integer = -32768;
  MaxAltitude: Integer = 32768;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

resourcestring
  rsWrongValue = 'Ќеверное значение!';
  rsSearchAreaRange = '«начение ограничени€ области поиска должно быть не менее %d и не более %d!';
  rsMaxAltitudeRange = '«начение максимальной высоты должно быть не менее %d и не более %d!';
  rsHorisontalCostRange = '«начение стоимости горизонтального перемещени€ должно быть не менее %g и не более %g!';
  rsVerticalCostRange = '«начение стоимости вертикального перемещени€ должно быть не менее %g и не более %g!';
  rsAngleCostRange = '«начение коэффициента вли€ни€ уклона должно быть не менее %g и не более %g!';

procedure TSettingsForm.MaxPointCountEditExit(Sender: TObject);
begin
  with MaxPointCountEdit do
  begin
    if Text <> EmptyStr then
    begin
      if IsError(not StrIsNumber(Text, False), rsWrongValue) then
      begin
        SetFocus;
      end
      else
      begin
        if IsError((StrToInt(Text) < MinPointCount) or (StrToInt(Text) > MaxPointCount), Format(rsSearchAreaRange, [MinPointCount, MaxPointCount])) then
        begin
          SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TSettingsForm.DistanceCostEditExit(Sender: TObject);
begin
  with DistanceCostEdit do
  begin
    if Text <> EmptyStr then
    begin
      if IsError(not StrIsNumber(Text, True), rsWrongValue) then
      begin
        SetFocus;
      end
      else
      begin
        if IsError((StrToFloat(Text) < MinCost) or (StrToFloat(Text) > MaxCost), Format(rsHorisontalCostRange, [MinCost, MaxCost])) then
        begin
          SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TSettingsForm.HeightUpCostEditExit(Sender: TObject);
begin
  with HeightUpCostEdit do
  begin
    if Text <> EmptyStr then
    begin
      if IsError(not StrIsNumber(Text, True), rsWrongValue) then
      begin
        SetFocus;
      end
      else
      begin
        if IsError((StrToFloat(Text) < MinCost) or (StrToFloat(Text) > MaxCost), Format(rsVerticalCostRange, [MinCost, MaxCost])) then
        begin
          SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TSettingsForm.HeightDownCostEditChange(Sender: TObject);
begin
  with HeightDownCostEdit do
  begin
    if Text <> EmptyStr then
    begin
      if IsError(not StrIsNumber(Text, True), rsWrongValue) then
      begin
        SetFocus;
      end
      else
      begin
        if IsError((StrToFloat(Text) < MinCost) or (StrToFloat(Text) > MaxCost), Format(rsVerticalCostRange, [MinCost, MaxCost])) then
        begin
          SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TSettingsForm.AngleCostEditExit(Sender: TObject);
begin
  with AngleCostEdit do
  begin
    if Text <> EmptyStr then
    begin
      if IsError(not StrIsNumber(Text, True), rsWrongValue) then
      begin
        SetFocus;
      end
      else
      begin
        if IsError((StrToFloat(Text) < MinCost) or (StrToFloat(Text) > MaxCost), Format(rsAngleCostRange, [MinCost, MaxCost])) then
        begin
          SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TSettingsForm.MaxAltitudeEditExit(Sender: TObject);
begin
  with MaxAltitudeEdit do
  begin
    if Text <> EmptyStr then
    begin
      if IsError(not StrIsNumber(Text, False), rsWrongValue) then
      begin
        SetFocus;
      end
      else
      begin
        if IsError((StrToInt(Text) < MinAltitude) or (StrToInt(Text) > MaxAltitude), Format(rsMaxAltitudeRange, [MinCost, MaxCost])) then
        begin
          SetFocus;
        end;
      end;
    end;
  end;
end;

end.
