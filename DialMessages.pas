unit DialMessages;

interface

uses
  Windows, Forms;

procedure InfoMsg(const Msg: string);
procedure ErrorMsg(const Msg: string);
procedure WarningMsg(const Msg: string);
function QuestionMsg(const Msg: string): Byte;

implementation

// отображает информационное диалоговое окно
procedure InfoMsg(const Msg: string);
begin
  MessageBox(Application.Handle, PChar(Msg), 'Информация', MB_ICONINFORMATION or MB_OK);
end;

// отображает диалоговое окно с ошибкой
procedure ErrorMsg(const Msg: string);
begin
  MessageBox(Application.Handle, PChar(Msg), 'Ошибка', MB_ICONERROR or MB_OK);
end;

// отображает диалоговое окно с предупреждением
procedure WarningMsg(const Msg: string);
begin
  MessageBox(Application.Handle, PChar(Msg), 'Предупреждение', MB_ICONWARNING or MB_OK);
end;

// отображает диалоговое окно с вопросом
function QuestionMsg(const Msg: string): Byte;
begin
  Result := MessageBox(Application.Handle, PChar(Msg), 'Вопрос', MB_ICONQUESTION or MB_YESNOCANCEL);
end;

end.
