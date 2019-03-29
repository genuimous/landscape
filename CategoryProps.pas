unit CategoryProps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Placemnt, StdCtrls, DataErrors;

type
  TCategoryPropsForm = class(TForm)
    RecordPropsGroupBox: TGroupBox;
    VisibleNameLabel: TLabel;
    VisibleNameEdit: TEdit;
    CancelButton: TButton;
    OKButton: TButton;
    FormPlacement: TFormPlacement;
    ObsoleteCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CategoryPropsForm: TCategoryPropsForm;

function AskCategoryProps(var VisibleName: string;
  var Obsolete: Boolean): Boolean;

implementation

{$R *.dfm}

resourcestring
  rsVisibleNameEmpty = 'Название не может быть пустым!';

function AskCategoryProps(var VisibleName: string;
  var Obsolete: Boolean): Boolean;
begin
  with TCategoryPropsForm.Create(Application) do
  begin
    try
      VisibleNameEdit.Text := VisibleName;
      ObsoleteCheckBox.Checked := Obsolete;

      ShowModal;

      if ModalResult = mrOk then
      begin
        VisibleName := VisibleNameEdit.Text;
        Obsolete := ObsoleteCheckBox.Checked;

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

procedure TCategoryPropsForm.FormClose(Sender: TObject;
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
