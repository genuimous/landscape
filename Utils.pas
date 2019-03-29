unit Utils;

interface

uses
  Forms, SysUtils, Error, ADODB, DB, Windows, Classes, Variants, RxMemDS,
  DBUtils, Dialogs, cxGrid, cxExportGrid4Link;

type
  TRecordID = Double;

  TStrings = array of string;
  TIndexes = array of Integer;

  TApplicationVersion = record
    Major, Minor, Release, Build: Word;
  end;

const
  PiDegree: Integer = 180;
  FeetPerMetre: Real = 3.28084;

resourcestring
  rsSpace = ' ';
  rsSemicolon = ';';
  rsLineBreak = #10#13;

function ApplicationFileName: string;
function ApplicationVersion: TApplicationVersion;
function GetFileSize(const FileName: string): Integer;
function AddStr(const Str: string; const AdditionalStr: string;
  const DelimiterStr: string): string;
function StrIsNumber(const Str: string; const IsFloat: Boolean): Boolean;
function DisAssembleStr(const Str: string; const Delimiter: Char): TStrings;
function FillDataSet(DataSet: TRxMemoryData; Source: TADOQuery;
  const SourceParamNames: array of string;
  const SourceParamValues: array of Variant; const MaxRecordCount: Integer = 0;
  const ClearOld: Boolean = True): Integer;
procedure InsertDatSetRecord(DataSet: TRxMemoryData);
procedure RetrieveDatSetRecord(DataSet: TRxMemoryData;
  RecordSource: TADOQuery; const RecordSourceParamNames: array of string;
  const RecordSourceParamValues: array of Variant);
procedure ExportGrid(Grid: TcxGrid);

implementation

resourcestring
  rsParamCountDiffers = ' оличество параметров не соответствует количеству значений';
  rsAmbiguousDataSet = 'Ќеоднозначный набор данных';
  rsExportGridFilter = ' нига Excel (*.xls)|*.xls|‘айл гипертекста (*.htm)|*.htm|“екстовый файл с разделител€ми (*.csv)|*.csv';

// возвращает полное им€ файла программы
function ApplicationFileName: string;
begin
  Result := ParamStr(0);
end;

// возвращает версию программы
function ApplicationVersion: TApplicationVersion;
var
  Info: Pointer;
  FileInfo: PVSFixedFileInfo;
  InfoSize, FileSize: Cardinal;
begin
  InfoSize := GetFileVersionInfoSize(PChar(Application.ExeName), FileSize);
  GetMem(Info, InfoSize);
  try
    GetFileVersionInfo(PChar(Application.ExeName), 0, InfoSize, Info);
    VerQueryValue(Info, '\', Pointer(FileInfo), FileSize);

    Result.Major := FileInfo.dwFileVersionMS shr 16;
    Result.Minor := FileInfo.dwFileVersionMS and $FFFF;
    Result.Release := FileInfo.dwFileVersionLS shr 16;
    Result.Build := FileInfo.dwFileVersionLS and $FFFF;
  finally
    FreeMem(Info);
  end;
end;

// возвращает размер файла
function GetFileSize(const FileName: string): Integer;
begin
  with TFileStream.Create(Filename, fmOpenRead) do
  begin
    try
      Result := Size;
    finally
      Free;
    end;
  end;
end;

// добавл€ет строку к строке через разделительную строку
function AddStr(const Str: string; const AdditionalStr: string;
  const DelimiterStr: string): string;
begin
  if Str = EmptyStr then
  begin
    Result := AdditionalStr;
  end
  else
  begin
    Result := Str + DelimiterStr + AdditionalStr;
  end;  
end;

// провер€ет, €вл€етс€ ли текст числом
function StrIsNumber(const Str: string; const IsFloat: Boolean): Boolean;
const
  Digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
var
  LocaleFormatSettings: TFormatSettings;
  CharCounter: Integer;
begin
  if Str <> EmptyStr then
  begin
    Result := True;

    GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, LocaleFormatSettings);

    for CharCounter := 1 to Length(Str) do
    begin
      if (not (Str[CharCounter] in Digits)) and ((not IsFloat) or IsFloat and (Str[CharCounter] <> LocaleFormatSettings.DecimalSeparator))
      then
      begin
        Result := False;
        Break;
      end;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

// разбирает строку с разделител€ми на подстроки
function DisAssembleStr(const Str: string; const Delimiter: Char): TStrings;
var
  CharCounter, StrLength, ChPos, SubstrCount: Integer;
  Substr: string;
begin
  SetLength(Result, 0);

  StrLength := Length(Str);
  SubstrCount := 0;
  ChPos := 1;

  for CharCounter := 1 to StrLength do
  begin
    if (Str[CharCounter] = Delimiter) or (CharCounter = StrLength) then
    begin
      Inc(SubstrCount);
      SetLength(Result, SubstrCount);

      if StrLength <> CharCounter then
        Substr := Copy(Str, ChPos, CharCounter - ChPos)
      else
        Substr := Copy(Str, ChPos, CharCounter - ChPos + 1);

      Result[SubstrCount - 1] := Substr;
      ChPos := CharCounter + 1;
    end;
  end;
end;

function FillDataSet(DataSet: TRxMemoryData; Source: TADOQuery;
  const SourceParamNames: array of string;
  const SourceParamValues: array of Variant; const MaxRecordCount: Integer = 0;
  const ClearOld: Boolean = True): Integer;
var
  ParamCounter: Integer;
begin
  if Length(SourceParamNames) <> Length(SourceParamValues) then
  begin
    raise Exception.Create(rsParamCountDiffers);
  end;

  for ParamCounter := 0 to Length(SourceParamNames) - 1 do
  begin
    Source.Parameters.ParamValues[SourceParamNames[ParamCounter]] := SourceParamValues[ParamCounter];
  end;
  
  Source.Open;

  try
    with DataSet do
    begin
      if not Active then
      begin
        if FieldDefs.Count = 0 then CopyStructure(Source);
        Open;
      end
      else
      begin
        if ClearOld then EmptyTable;
      end;

      if not Source.IsEmpty then
      begin
        DisableControls;

        try
          Result := LoadFromDataSet(Source, MaxRecordCount, lmAppend);
        finally
          EnableControls;

          if RecordCount > 0 then
          begin
            First;
          end;
        end;
      end
      else
      begin
        Result := 0;
      end;
    end;
  finally
    Source.Close;
  end;
end;

procedure InsertDatSetRecord(DataSet: TRxMemoryData);
begin
  with DataSet do
  begin
    Append;
    Post;
  end;
end;

procedure RetrieveDatSetRecord(DataSet: TRxMemoryData;
  RecordSource: TADOQuery; const RecordSourceParamNames: array of string;
  const RecordSourceParamValues: array of Variant);
var
  ParamCounter: Integer;
begin
  if Length(RecordSourceParamNames) <> Length(RecordSourceParamValues) then
  begin
    raise Exception.Create(rsParamCountDiffers);
  end;

  for ParamCounter := 0 to Length(RecordSourceParamNames) - 1 do
  begin
    RecordSource.Parameters.ParamValues[RecordSourceParamNames[ParamCounter]] := RecordSourceParamValues[ParamCounter];
  end;
  RecordSource.Open;

  try
    with DataSet do
    begin
      if not RecordSource.IsEmpty then
      begin
        if RecordSource.RecordCount = 1 then
        begin
          Edit;
          AssignRecord(RecordSource, DataSet, True);
          Post;
        end
        else
        begin
          raise Exception.Create(rsAmbiguousDataSet);
        end;
      end
      else
      begin
        Delete;
      end;
    end;
  finally
    RecordSource.Close;
  end;
end;

procedure ExportGrid(Grid: TcxGrid);
begin
  with TSaveDialog.Create(nil) do
  begin
    Options := [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing];
    Filter := rsExportGridFilter;

    if Execute then
    begin
      case FilterIndex of
        1: //если XLS
        begin
          ExportGrid4ToExcel(FileName, Grid, True, True, True, 'xls');
        end;
        2: //если HTML
        begin
          ExportGrid4ToHTML(FileName, Grid, True, True, 'htm');
        end;
        3: //если TXT
        begin
          ExportGrid4ToText(FileName, Grid, True, True, ';', EmptyStr, EmptyStr, 'csv');
        end;
      end;
    end;
  end;
end;

end.
