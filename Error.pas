unit Error;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Placemnt;

type
  TErrorForm = class(TForm)
    CloseButton: TButton;
    DetailsMemo: TMemo;
    FormPlacement: TFormPlacement;
    DescriptionLabel: TLabel;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ErrorForm: TErrorForm;

procedure ShowApplicationError(const ErrorDescription, ErrorDetails: string);

implementation

{$R *.dfm}

procedure ShowApplicationError(const ErrorDescription, ErrorDetails: string);
const
  ErrorBeginMarker: string = '{';
  ErrorEndMarker: string = '}';
var
  ParsedErrorDetails: string;
  ErrorBegin, ErrorEnd: Integer;
begin
  ParsedErrorDetails := ErrorDetails;

  ErrorBegin := Pos(ErrorBeginMarker, ParsedErrorDetails);
  if ErrorBegin > 0 then
  begin
    ParsedErrorDetails := Copy
    (
      ParsedErrorDetails,
      ErrorBegin + Length(ErrorBeginMarker),
      Length(ParsedErrorDetails) - Length(ErrorBeginMarker) - ErrorBegin + 1
    );

    ErrorEnd := Pos(ErrorEndMarker, ParsedErrorDetails);
    if ErrorEnd > 0 then
    begin
      ParsedErrorDetails := Copy
      (
        ParsedErrorDetails,
        1,
        ErrorEnd - 1
      );
    end
    else
    begin
      ParsedErrorDetails := ErrorDetails;
    end;
  end;

  with TErrorForm.Create(Application) do
  begin
    try
      DescriptionLabel.Caption := ErrorDescription;
      DetailsMemo.Text := ParsedErrorDetails;
      ShowModal;
    finally
      Free;
    end;
  end;
end;

end.
