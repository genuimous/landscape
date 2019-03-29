unit ImageView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Placemnt, Menus;

type
  TImageViewForm = class(TForm)
    Image: TImage;
    ImagePopupMenu: TPopupMenu;
    SaveImageMI: TMenuItem;
    ImageSaveDialog: TSaveDialog;
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SaveImageMIClick(Sender: TObject);
  private
    { Private declarations }
    procedure SaveImage;
  public
    { Public declarations }
  end;

var
  ImageViewForm: TImageViewForm;

procedure DisplayImage(Graphic: TGraphic; const ImageName: string);

implementation

{$R *.dfm}

procedure DisplayImage(Graphic: TGraphic; const ImageName: string);
begin
  with TImageViewForm.Create(Application) do
  begin
    try
      Caption := ImageName;

      Width := Width - Image.Width + Graphic.Width;
      Height := Height - Image.Height + Graphic.Height;

      Image.Picture.Graphic := Graphic;

      ShowModal;
    finally
      Free;
    end;
  end;
end;

{ TImageViewForm }
procedure TImageViewForm.ImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE: Integer = $F012;
begin
  if WindowState = wsNormal	then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;  
end;

procedure TImageViewForm.SaveImage;
begin
  with ImageSaveDialog do
  begin
    if Execute then
    begin
      Image.Picture.SaveToFile(FileName);
    end;
  end;
end;

procedure TImageViewForm.SaveImageMIClick(Sender: TObject);
begin
  SaveImage;
end;

end.
