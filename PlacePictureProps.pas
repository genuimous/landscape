unit PlacePictureProps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Placemnt, StdCtrls, DialMessages, Utils, DataErrors;

type
  TPlacePicturePropsForm = class(TForm)
    PlacePicturePropsGroupBox: TGroupBox;
    VisibleNameLabel: TLabel;
    VisibleNameEdit: TEdit;
    OKButton: TButton;
    CancelButton: TButton;
    FormPlacement: TFormPlacement;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PlacePicturePropsForm: TPlacePicturePropsForm;

function AskPlacePictureProps(var VisibleName: string): Boolean;

implementation

{$R *.dfm}

resourcestring
  rsVisibleNameEmpty = 'Название не может быть пустым!';

function AskPlacePictureProps(var VisibleName: string): Boolean;
begin
  with TPlacePicturePropsForm.Create(Application) do
  begin
    try
      VisibleNameEdit.Text := VisibleName;

      ShowModal;

      if ModalResult = mrOk then
      begin
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

procedure TPlacePicturePropsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  ErrorStr: string;
begin
  if ModalResult = mrOk then
  begin
    ErrorStr := EmptyStr;

    CheckError(VisibleNameEdit.Text = EmptyStr, ErrorStr, rsVisibleNameEmpty);

    TryCloseModal(ErrorStr, Action);
  end;
end;

end.
