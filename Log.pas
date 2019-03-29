unit Log;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Placemnt, Utils;

type
  TLogForm = class(TForm)
    MainMenu: TMainMenu;
    FileMI: TMenuItem;
    SaveMI: TMenuItem;
    ClearMI: TMenuItem;
    LogMemo: TMemo;
    SaveDialog: TSaveDialog;
    FormPlacement: TFormPlacement;
    procedure ClearMIClick(Sender: TObject);
    procedure SaveMIClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

resourcestring
  rsLogDateTimeFormat = 'mm.dd.yyyy hh:nn:ss';

var
  LogForm: TLogForm;

procedure WriteToLog(const Msg: string);

implementation

{$R *.dfm}

procedure WriteToLog(const Msg: string);
begin
  if not(Assigned(LogForm)) then
  begin
    LogForm := TLogForm.Create(Application);
  end;

  LogForm.LogMemo.Lines.Append(FormatDateTime(rsLogDateTimeFormat, Now) + rsSpace + Msg);
end;

procedure TLogForm.ClearMIClick(Sender: TObject);
begin
  LogMemo.Clear;
end;

procedure TLogForm.SaveMIClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    LogMemo.Lines.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TLogForm.FormShow(Sender: TObject);
begin
  SendMessage(LogMemo.Handle, EM_LINESCROLL, 0, LogMemo.Lines.Count - 1);
end;

end.
