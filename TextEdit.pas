unit TextEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Placemnt, Menus;

type
  TTextEditForm = class(TForm)
    TextEditMemo: TMemo;
    ActionPanel: TPanel;
    CancelButton: TButton;
    OKButton: TButton;
    FormPlacement: TFormPlacement;
    MainMenu: TMainMenu;
    FileMI: TMenuItem;
    OpenMI: TMenuItem;
    SaveMI: TMenuItem;
    ClearMI: TMenuItem;
    TextSaveDialog: TSaveDialog;
    TextOpenDialog: TOpenDialog;
    procedure OpenMIClick(Sender: TObject);
    procedure SaveMIClick(Sender: TObject);
    procedure ClearMIClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TextEditForm: TTextEditForm;

implementation

{$R *.dfm}

procedure TTextEditForm.OpenMIClick(Sender: TObject);
begin
  with TextOpenDialog do
  begin
    if Execute then
    begin
      TextEditMemo.Lines.LoadFromFile(FileName);
    end;
  end;
end;

procedure TTextEditForm.SaveMIClick(Sender: TObject);
begin
  with TextSaveDialog do
  begin
    if Execute then
    begin
      TextEditMemo.Lines.SaveToFile(FileName);
    end;
  end;
end;

procedure TTextEditForm.ClearMIClick(Sender: TObject);
begin
  TextEditMemo.Lines.Clear;
end;

end.
