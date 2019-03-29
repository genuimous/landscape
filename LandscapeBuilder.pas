unit LandscapeBuilder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, IniFiles, DB, ADODB, ToolWin, ExtCtrls, ImgList,
  DialMessages, Utils, StdCtrls, Buttons, TeEngine, Error, Math, Geoid,
  cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, cxDBData, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxClasses, cxGridLevel, cxGrid, cxGridDBTableView,
  RxMemDS, cxExportGrid4Link, Settings, dxStatusBar, cxContainer,
  cxProgressBar, Log, CalcProps, DBConnection, Placemnt, Tracks,
  cxTextEdit, TrackProps, Places, TrackChart, OziExportImport, Categories,
  TrackSelector, TrackPointProps, cxPC, PlaceListProps,
  PlacesSelector;

type
  TElevationDataLoadType = (edltFile, edltDatabase);

  TLandscapeBuilderForm = class(TForm)
    MainMenu: TMainMenu;
    FileMI: TMenuItem;
    ExitSeparatorMI: TMenuItem;
    LoadElevationDataMI: TMenuItem;
    ExitMI: TMenuItem;
    HelpMI: TMenuItem;
    AboutMI: TMenuItem;
    ElevationDataOpenDialog: TOpenDialog;
    OpenMI: TMenuItem;
    SaveMI: TMenuItem;
    ImportMI: TMenuItem;
    ServiceMI: TMenuItem;
    SettingsMI: TMenuItem;
    ExportMI: TMenuItem;
    TrackSaveDialog: TSaveDialog;
    TrackDataSaveDialog: TSaveDialog;
    TrackOpenDialog: TOpenDialog;
    NewMI: TMenuItem;
    StatusBar: TdxStatusBar;
    ProgressStatusBarContainer: TdxStatusBarContainerControl;
    ProgressBar: TcxProgressBar;
    LogMI: TMenuItem;
    BuildTrackMI: TMenuItem;
    LogSeparatorMI: TMenuItem;
    TrackPointsPopupMenu: TPopupMenu;
    ExportTrackPointsGridtMI: TMenuItem;
    TrackDBSeparatorMI: TMenuItem;
    ToolBar: TToolBar;
    NewToolButton: TToolButton;
    MenuImageList: TImageList;
    OpenToolButton: TToolButton;
    SaveToolButton: TToolButton;
    ShowTrackChartToolButton: TToolButton;
    UtilsToolSeparator: TToolButton;
    ShowPlacesToolButton: TToolButton;
    RetrieveToolButton: TToolButton;
    ShowPlacesMI: TMenuItem;
    TrackDataOpenDialog: TOpenDialog;
    RetrieveMI: TMenuItem;
    ObjectListSeparatorMI: TMenuItem;
    ServiceToolSeparator: TToolButton;
    SettingsToolButton: TToolButton;
    LogToolButton: TToolButton;
    MemorizeMI: TMenuItem;
    MemorizeToolButton: TToolButton;
    FormPlacement: TFormPlacement;
    FileLoadElevationDataMI: TMenuItem;
    DatabaseLoadElevationDataMI: TMenuItem;
    ElevationDataSaveDialog: TSaveDialog;
    ConstMI: TMenuItem;
    UtilsMI: TMenuItem;
    ShowTrackChartMI: TMenuItem;
    BuildTrackSeparatorMI: TMenuItem;
    CategoriesMI: TMenuItem;
    DirectoriesSeparatorMI: TMenuItem;
    DataPageControl: TcxPageControl;
    TrackTabSheet: TcxTabSheet;
    PlaceListTabSheet: TcxTabSheet;
    TrackPointsGrid: TcxGrid;
    TrackPointsLevel: TcxGridLevel;
    ShowTracksToolButton: TToolButton;
    ShowTracksMI: TMenuItem;
    TrackPointsDataSet: TRxMemoryData;
    TrackPointsQuery: TADOQuery;
    TrackPointsView: TcxGridDBTableView;
    TrackPointsViewLatitudeDegreeColumn: TcxGridDBColumn;
    TrackPointsViewLongitudeDegreeColumn: TcxGridDBColumn;
    TrackPointsViewAltitudeColumn: TcxGridDBColumn;
    TrackPointsViewStepDistanceColumn: TcxGridDBColumn;
    TrackPointsViewStepHeightColumn: TcxGridDBColumn;
    TrackPointsViewStepCostColumn: TcxGridDBColumn;
    TrackPointsDataSource: TDataSource;
    TrackPointsViewStepNumColumn: TcxGridDBColumn;
    AddTrackPointMI: TMenuItem;
    AddTrackPointCurMI: TMenuItem;
    AddTrackPointLastMI: TMenuItem;
    PlaceListOpenDialog: TOpenDialog;
    PlaceListSaveDialog: TSaveDialog;
    PlaceListDataOpenDialog: TOpenDialog;
    PlaceListDataSaveDialog: TSaveDialog;
    PlacesGrid: TcxGrid;
    PlacesView: TcxGridDBTableView;
    PlacesViewVisibleNameColumn: TcxGridDBColumn;
    PlacesViewLatitudeDegreeColumn: TcxGridDBColumn;
    PlacesViewLongitudeDegreeColumn: TcxGridDBColumn;
    PlacesViewAltitudeColumn: TcxGridDBColumn;
    PlacesLevel: TcxGridLevel;
    PlacesDataSet: TRxMemoryData;
    PlacesDataSource: TDataSource;
    PlacesViewIdentityNameColumn: TcxGridDBColumn;
    DeleteTrackPointMI: TMenuItem;
    EditTrackPointMI: TMenuItem;
    PlacesViewPlaceNumColumn: TcxGridDBColumn;
    PlacesPopupMenu: TPopupMenu;
    AddPlaceMI: TMenuItem;
    AddPlaceCurMI: TMenuItem;
    AddPlaceLastMI: TMenuItem;
    EditPlaceMI: TMenuItem;
    DeletePlaceMI: TMenuItem;
    PlacesActionsSeparatorMI: TMenuItem;
    ExportPlacesGridMI: TMenuItem;
    ReverseTrackMI: TMenuItem;
    TrackActionsSeparatorMI: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ExitMIClick(Sender: TObject);
    procedure AboutMIClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImportMIClick(Sender: TObject);
    procedure SaveMIClick(Sender: TObject);
    procedure OpenMIClick(Sender: TObject);
    procedure NewMIClick(Sender: TObject);
    procedure SettingsMIClick(Sender: TObject);
    procedure TrackDataSaveDialogTypeChange(Sender: TObject);
    procedure LogMIClick(Sender: TObject);
    procedure BuildTrackMIClick(Sender: TObject);
    procedure ExportTrackPointsGridtMIClick(Sender: TObject);
    procedure ExportMIClick(Sender: TObject);
    procedure OpenToolButtonClick(Sender: TObject);
    procedure SaveToolButtonClick(Sender: TObject);
    procedure NewToolButtonClick(Sender: TObject);
    procedure ShowTrackChartToolButtonClick(Sender: TObject);
    procedure LogToolButtonClick(Sender: TObject);
    procedure SettingsToolButtonClick(Sender: TObject);
    procedure MemorizeMIClick(Sender: TObject);
    procedure MemorizeToolButtonClick(Sender: TObject);
    procedure RetrieveToolButtonClick(Sender: TObject);
    procedure RetrieveMIClick(Sender: TObject);
    procedure FileLoadElevationDataMIClick(Sender: TObject);
    procedure DatabaseLoadElevationDataMIClick(Sender: TObject);
    procedure ShowPlacesToolButtonClick(Sender: TObject);
    procedure ShowPlacesMIClick(Sender: TObject);
    procedure ConstMIClick(Sender: TObject);
    procedure ShowTrackChartMIClick(Sender: TObject);
    procedure CategoriesMIClick(Sender: TObject);
    procedure DataPageControlChange(Sender: TObject);
    procedure TrackModeMIClick(Sender: TObject);
    procedure PlacesModeMIClick(Sender: TObject);
    procedure ShowTracksMIClick(Sender: TObject);
    procedure ShowTracksToolButtonClick(Sender: TObject);
    procedure TrackPointsDataSetBeforePost(DataSet: TDataSet);
    procedure AddTrackPointCurMIClick(Sender: TObject);
    procedure AddTrackPointLastMIClick(Sender: TObject);
    procedure PlacesDataSetBeforePost(DataSet: TDataSet);
    procedure EditTrackPointMIClick(Sender: TObject);
    procedure DeleteTrackPointMIClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExportPlacesGridMIClick(Sender: TObject);
    procedure PlaceListDataSaveDialogTypeChange(Sender: TObject);
    procedure ReverseTrackMIClick(Sender: TObject);
  private
    { Private declarations }
    IniFileName: string;
    MaxPointCount: Integer;
    MaxAngle: Byte;
    MaxAltitude: TAltitude;
    Track: TTrack;
    PlaceList: TPlaceList;
    LatitudeStep, LongitudeStep: Word;
    PlanetRadius: Cardinal;
    DistanceCost, HeightUpCost, HeightDownCost, AngleCost: Real;
    SaveTrackOnExit: Boolean;
    procedure SetControls;
    procedure ShowLog;
    procedure EditSettings;
    procedure InitProgressBar(const OperationCount: Integer);
    procedure SetProgressBar(const OperationNum: Integer);
    procedure ResetProgressBar;
    procedure LoadElevationData(const LoadType: TElevationDataLoadType);
    procedure SetStatusText(const StatusText: string; PanelIndex: Integer);
    function TrackIsSaved: Boolean;
    function PlaceListIsSaved: Boolean;
    procedure BuildTrack;
    procedure DisplayTrack;
    procedure DisplayPlaceList;
    procedure Save;
    procedure SaveTrack;
    procedure SavePlaceList;
    procedure Open;
    procedure OpenTrack;
    procedure OpenPlaceList;
    procedure Init;
    procedure InitTrack;
    procedure InitPlaceList;
    procedure Memorize;
    procedure MemorizeTrack;
    procedure MemorizePlaceList;
    procedure Retrieve;
    procedure RetrieveTrack;
    procedure RetrievePlaceList;
    procedure ShowTracks;
    procedure ShowPlaces;
    procedure ShowTrackChart;
  protected
    { Protected declarations }
  public
    { Public declarations }
  end;

var
  LandscapeBuilderForm: TLandscapeBuilderForm;

implementation

{$R *.dfm}

const
  spHint: Integer = 0;
  spProgress: Integer = 1;
  spProvider: Integer = 2;

resourcestring
  rsProgramLaunch = 'Запуск программы.';
  rsProgramVersion = 'Проект Landscape - версия %d.%d.%d сборка %d';
  rsFileNotExists = 'Не удается найти файл ''%s''!';
  rsIniFileReadingError = 'Не удалось прочитать настройки!';
  rsNoConnectionString = 'Не задана строка подключения!';
  rsDBConnectionError = 'Невозможно подключиться к БД!';
  rsConstantsReadingError = 'Невозможно определить константы!';
  rsElevationDataReading = 'Чтение данных рельефа...';
  rsElevationDataReadingError = 'Не удалось прочитать даные рельефа!';
  rsElevationDataReadingOK = 'Чтение данных рельефа завершено.';
  rsLoadingElevationDataToFile = 'Загрузка данных рельефа в %s...';
  rsLoadingElevationDataToFileOK = 'Загрузка данных рельефа в %s завершена!';
  rsLoadingElevationDataToFileError = 'Не удалось загрузить данные рельефа в %s!';
  rsLoadingElevationDataToDB = 'Загрузка данных рельефа в БД...';
  rsLoadingElevationDataToDBOK = 'Загрузка данных рельефа в БД завершена!';
  rsLoadingElevationDataToDBError = 'Не удалось загрузить данные рельефа в БД!';
  rsNoElevationData = 'Недостаточно данных рельефа!';
  rsVertexListReading = 'Получение списка вершин...';
  rsVertexListParsing = 'Обработка списка вершин...';
  rsPathSearching = 'Поиск пути среди %d вершин...';
  rsPathFound = 'Найден путь из %d вершин.';
  rsPathNotFound = 'Путь не найден!';
  rsSearchConditionNotExistsInSearchArea = 'Условие поиска не входит в область поиска!';
  rsSearchAreaSizeExceedsLimit = 'Количество выбранных вершин превышает максимально допустимое значение!';
  rsSearchAreaEmpty = 'В области поиска нет данных!';
  rsCanNotBuildTrack = 'Не удалось построить трек!';
  rsStartEqualsToEnd = 'Начальная и конечная точки совпадают!';
  rsTrackSave = 'Трек не был сохранен. Сохранить?';
  rsTrackInit = 'Создан новый трек.';
  rsTrackImportingOzi = 'Импорт трека OziExplorer...';
  rsTrackImportingOK = 'Импортирован трек из %d точек.';
  rsTrackImportingError = 'Не удалось импортировать трек!';
  rsTrackExportingOzi = 'Экспорт трека OziExplorer...';
  rsTrackExportingOK = 'Трек экспортирован.';
  rsTrackExportingError = 'Не удалось экспортировать трек!';
  rsTrackMemorizing = 'Запоминание трека...';
  rsTrackMemorizingOK = 'Трек запомнен.';
  rsTrackMemorizingError = 'Не удалось запомнить трек!';
  rsTrackRetrieving = 'Получение трека...';
  rsTrackRetrievingOK = 'Получен трек из %d точек.';
  rsTrackRetrievingError = 'Не удалось получить трек!';
  rsTrackOpening = 'Открытие трека...';
  rsTrackOpeningOK = 'Открыт трек из %d точек.';
  rsTrackOpeningError = 'Не удалось открыть трек!';
  rsTrackSummary = 'D[istance] = %.2f; H[eigth] = %d; R[aise] = %d; F[all] = %d; C[ost] = %.2f';
  rsTrackSaving = 'Сохранение трека...';
  rsTrackSavingOK = 'Трек сохранен.';
  rsTrackSavingError = 'Не удалось сохранить трек!';
  rsPlaceListSave = 'Список объектов не был сохранен. Сохранить?';
  rsPlaceListInit = 'Создан новый список объектов.';
  rsPlaceListImportingOzi = 'Импорт списка объектов OziExplorer...';
  rsPlaceListImportingOK = 'Импортирован список объектов из %d штук.';
  rsPlaceListImportingError = 'Не удалось импортировать список объектов!';
  rsPlaceListExportingOzi = 'Экспорт списка объектов OziExplorer...';
  rsPlaceListExportingOK = 'Список объектов экспортирован.';
  rsPlaceListExportingError = 'Не удалось экспортировать список объектов!';
  rsPlaceListMemorizing = 'Запоминание списка объектов...';
  rsPlaceListMemorizingOK = 'Список объектов запомнен.';
  rsPlaceListMemorizingError = 'Не удалось запомнить список объектов!';
  rsPlaceListRetrieving = 'Получение списка объектов...';
  rsPlaceListRetrievingOK = 'Получен список объектов из %d элементов.';
  rsPlaceListRetrievingError = 'Не удалось получить список объектов!';
  rsPlaceListOpening = 'Открытие списка объектов...';
  rsPlaceListOpeningOK = 'Открыт список объектов из %d элементов.';
  rsPlaceListOpeningError = 'Не удалось открыть список объектов!';
  rsPlaceListSaving = 'Сохранение списка объектов...';
  rsPlaceListSavingOK = 'Список объектов сохранен.';
  rsPlaceListSavingError = 'Не удалось список объектов!';
  rsConstLatitudeStep = 'Шаг широты: %d';
  rsConstLongitudeStep = 'Шаг долготы: %d';
  rsConstPlanetRadius = 'Радиус планеты: %d';
  rsPointNotFound = 'Вершина с координатами, близкими к (%g; %g) не существует!';

procedure TLandscapeBuilderForm.FormCreate(Sender: TObject);
const
  DefaultMaxPointCount: Integer = 10000;
  DefaultMaxAngle: Integer = 90;
  DefaultMaxAltitude: Integer = 32767;
  DefaultDistanceCost: Real = 0;
  DefaultHeightUpCost: Real = 0;
  DefaultHeightDownCost: Real = 0;
  DefaultAngleCost: Real = 0;
var
  ExeFileName: string;
  ConnectionStringConfigFile: TextFile;
  ConnectionStringConfigFileName: string;
  ConnectionStringLine: string;
  ConnectionString: string;
begin
  ExeFileName := ApplicationFileName;

  IniFileName := Copy(ExeFileName, 1, Pos('.exe', ExeFileName) - 1) + '.ini';
  ConnectionStringConfigFileName := ExtractFilePath(ExeFileName) + 'ConnectionString.cfg';

  // читаем настройки из INI-файла
  if FileExists(IniFileName) then
  begin
    try
      with TIniFile.Create(IniFileName) do
      begin
        try
          // основные
          MaxPointCount := ReadInteger('main', 'MaxPointCount', DefaultMaxPointCount);
          MaxAngle := ReadInteger('main', 'MaxAngle', DefaultMaxAngle);
          MaxAltitude := ReadInteger('main', 'MaxHeight', DefaultMaxAltitude);
          SaveTrackOnExit := ReadBool('main', 'SaveTrackOnExit', False);
          // стоимость
          DistanceCost := ReadFloat('cost', 'DistanceCost', DefaultDistanceCost);
          HeightUpCost := ReadFloat('cost', 'HeightUpCost', DefaultHeightUpCost);
          HeightDownCost := ReadFloat('cost', 'HeightDownCost', DefaultHeightDownCost);
          AngleCost := ReadFloat('cost', 'AngleCost', DefaultAngleCost);
        finally
          Free;
        end;
      end;
    except
      on E: Exception do
      begin
        ShowApplicationError(rsIniFileReadingError, E.Message);
        Application.Terminate;
        Exit;
      end;
    end;
  end
  else
  begin
    ErrorMsg(Format(rsFileNotExists, [IniFileName]));
    Application.Terminate;
    Exit;
  end;

  // читаем строку подключения
  if FileExists(ConnectionStringConfigFileName) then
  begin
    try
      try
        AssignFile(ConnectionStringConfigFile, ConnectionStringConfigFileName);
        Reset(ConnectionStringConfigFile);

        ConnectionString := EmptyStr;
        while not Eof(ConnectionStringConfigFile) do
        begin
          Readln(ConnectionStringConfigFile, ConnectionStringLine);
          if ConnectionStringLine <> EmptyStr then
          begin
            ConnectionString := ConnectionString + ConnectionStringLine;
          end;
        end;
      finally
        CloseFile(ConnectionStringConfigFile);
      end;
    except
      on E: Exception do
      begin
        ShowApplicationError(rsNoConnectionString, E.Message);
        Application.Terminate;
        Exit;
      end;
    end;
  end
  else
  begin
    ErrorMsg(Format(rsFileNotExists, [ConnectionStringConfigFileName]));
    Application.Terminate;
    Exit;
  end;

  // подключаемся к базе
  try
    LandscapeDB := TLandscapeDB.CreateConnection(ConnectionString);
    LandscapeDB.Connect;

    SetStatusText(LandscapeDB.Connection.Provider, spProvider);
  except
    on E: Exception do
    begin
      ShowApplicationError(rsDBConnectionError, E.Message);
      Application.Terminate;
      Exit;
    end;
  end;

  // определяем константы
  try
    with LandscapeDB.OpenQuery('select dbo.latitude_step() latitude_step, dbo.longitude_step() longitude_step, dbo.planet_radius() planet_radius') do
    begin
      try
        LatitudeStep := FieldValues['latitude_step'];
        LongitudeStep := FieldValues['longitude_step'];
        PlanetRadius := FieldValues['planet_radius'];
      finally
        Free;
      end;
    end;
  except
    on E: Exception do
    begin
      ShowApplicationError(rsConstantsReadingError, E.Message);
      Application.Terminate;
      Exit;
    end;
  end;

  Track := TTrack.Create;
  PlaceList := TPlaceList.Create;

  TrackPointsDataSet.Open;
  PlacesDataSet.Open;

  InitTrack;
  InitPlaceList;
end;

procedure TLandscapeBuilderForm.LoadElevationData(
  const LoadType: TElevationDataLoadType);
var
  ReliefMap: TReliefMap;
  FileDate: TDateTime;
  Latitude, Longitude: Integer;
  LatitudeCounter, LongitudeCounter: Word;
  ElevationDataFile: TextFile;
begin
  with ElevationDataOpenDialog do
  begin
    if Execute then
    begin
      if FileExists(FileName) then
      begin
        try
          // определяем дату файла
          FileDate := FileDateToDateTime(FileAge(FileName));

          // читаем файл
          WriteToLog(rsElevationDataReading);
          SetStatusText(rsElevationDataReading, spHint);

          case FilterIndex of
            1: {SRTM}
            begin
              ReliefMap := TReliefMap.CreateSRTM(FileName, PlanetRadius);
            end;
          end;

          try
            WriteToLog(rsElevationDataReadingOK);

            InitProgressBar(Trunc(ReliefMap.Height * ReliefMap.LatitudeStep / LatitudeStep));

            // загружаем данные
            case LoadType of
              // в файл
              edltFile:
              begin
                with ElevationDataSaveDialog do
                begin
                  if Execute then
                  begin
                    WriteToLog(Format(rsLoadingElevationDataToFile, [FileName]));
                    SetStatusText(Format(rsLoadingElevationDataToFile, [FileName]), spHint);

                    try
                      AssignFile(ElevationDataFile, FileName);
                      Rewrite(ElevationDataFile);

                      try
                        for LatitudeCounter := 0 to Trunc((ReliefMap.Height - 1) * ReliefMap.LatitudeStep / LatitudeStep) do
                        begin
                          Latitude := ReliefMap.StartLatitude - LatitudeCounter * LatitudeStep;

                          for LongitudeCounter := 0 to Trunc((ReliefMap.Width - 1) * ReliefMap.LongitudeStep / LongitudeStep) do
                          begin
                            Longitude := (ReliefMap.StartLongitude + LongitudeCounter * LongitudeStep) mod (MaxLongitude + 1);

                            // пишем в файл
                            Writeln(ElevationDataFile, IntToStr(Latitude) + rsSemicolon + IntToStr(Longitude) + rsSemicolon + IntToStr(ReliefMap.Altitude(Latitude, Longitude)));

                            SetProgressBar(LatitudeCounter + 1);
                          end;
                        end;
                      finally
                        CloseFile(ElevationDataFile);
                      end;

                      WriteToLog(Format(rsLoadingElevationDataToFileOK, [FileName]));
                    except
                      on E: Exception do
                      begin
                        WriteToLog(rsLoadingElevationDataToFileError + rsSpace + E.Message);
                        ShowApplicationError(rsLoadingElevationDataToFileError, E.Message);
                      end;
                    end;
                  end;
                end;
              end;
              // в базу
              edltDatabase:
              begin
                try
                  WriteToLog(rsLoadingElevationDataToDB);
                  SetStatusText(rsLoadingElevationDataToDB, spHint);

                  for LatitudeCounter := 0 to Trunc((ReliefMap.Height - 1) * ReliefMap.LatitudeStep / LatitudeStep) do
                  begin
                    Latitude := ReliefMap.StartLatitude - LatitudeCounter * LatitudeStep;

                    for LongitudeCounter := 0 to Trunc((ReliefMap.Width - 1) * ReliefMap.LongitudeStep / LongitudeStep) do
                    begin
                      Longitude := (ReliefMap.StartLongitude + LongitudeCounter * LongitudeStep) mod (MaxLongitude + 1);

                      // выполняем процедуру вставки
                      LandscapeDB.InsertPoint
                      (
                        Latitude,
                        Longitude,
                        ReliefMap.Altitude(Latitude, Longitude),
                        FileDate
                      );

                      SetProgressBar(LatitudeCounter + 1);
                    end;
                  end;

                  WriteToLog(rsLoadingElevationDataToDBOK);
                except
                  on E: Exception do
                  begin
                    WriteToLog(rsLoadingElevationDataToDBError + rsSpace + E.Message);
                    ShowApplicationError(rsLoadingElevationDataToDBError, E.Message);
                  end;
                end;
              end;
            end;
          finally
            FreeAndNil(ReliefMap);
          end;
        except
          on E: Exception do
          begin
            WriteToLog(rsElevationDataReadingError + rsSpace + E.Message);
            ShowApplicationError(rsElevationDataReadingError, E.Message);
          end;
        end;

        ResetProgressBar;
        SetStatusText(EmptyStr, spHint);
      end
      else
      begin
        ErrorMsg(Format(rsFileNotExists, [FileName]));
      end;
    end;
  end;
end;

procedure TLandscapeBuilderForm.ResetProgressBar;
begin
  ProgressBar.Position := 0;
  Application.ProcessMessages;
end;

procedure TLandscapeBuilderForm.ExitMIClick(Sender: TObject);
begin
  Close;
end;

procedure TLandscapeBuilderForm.AboutMIClick(Sender: TObject);
var
  Version: TApplicationVersion;
begin
  Version := ApplicationVersion;
  InfoMsg(Format(rsProgramVersion, [Version.Major, Version.Minor, Version.Release, Version.Build]));
end;

procedure TLandscapeBuilderForm.FormShow(Sender: TObject);
begin
  WriteToLog(rsProgramLaunch);
end;

procedure TLandscapeBuilderForm.SetStatusText(const StatusText: string; PanelIndex: Integer);
begin
  StatusBar.Panels[PanelIndex].Text := StatusText;
  Application.ProcessMessages;
end;

procedure TLandscapeBuilderForm.BuildTrack;
var
  StartLatitudeBorder, EndLatitudeBorder, StartLongitudeBorder, EndLongitudeBorder: Integer;
  StartPointID, EndPointID: TRecordID;

  PointCount, PointCounter: Integer;
  StartPoint, EndPoint: Integer;
  Points: TPoints;
  BestPath: TPoints;

  function EdgeWeight(const Point1, Point2: TPoint): Real;
  var
    Distance: Real;
    Height: Smallint;
  begin
    // изначально считаем что связи нет
    Result := Infinity;

    // если точки не совпадают
    if (Point1.Props.Latitude <> Point2.Props.Latitude) or (Point1.Props.Longitude <> Point2.Props.Longitude) then
    begin
      // если точки соседние
      if
        (
          // широта равна
          (Point1.Props.Latitude = Point2.Props.Latitude)
          or
          // широта одного знака и разница равна шагу
          ((Point1.Props.Latitude >= 0) and (Point2.Props.Latitude >= 0) or (Point1.Props.Latitude < 0) and (Point2.Props.Latitude < 0)) and (Abs(Point1.Props.Latitude - Point2.Props.Latitude) = LatitudeStep)
          or
          // широта разного знака и разница равна шагу
          ((Point1.Props.Latitude < 0) and (Point2.Props.Latitude > 0) or (Point1.Props.Latitude > 0) and (Point2.Props.Latitude < 0)) and (Abs(Point1.Props.Latitude) + Abs(Point2.Props.Latitude) = LatitudeStep)
        )
        and
        (
          // долгота равна
          (Point1.Props.Longitude = Point2.Props.Longitude)
          or
          // долгота не переходит через 0 и разница равна шагу
          (Abs(Point1.Props.Longitude - Point2.Props.Longitude) = LongitudeStep)
          // долгота переходит через 0 и разница равна шагу
          or
          (Abs(Point1.Props.Longitude - Point2.Props.Longitude) = MaxLongitude - LongitudeStep + 1)
        )
      then
      begin
        // получаем длину отрезка
        Distance := ArcLength(Point1.Props.Latitude, Point1.Props.Longitude, Point2.Props.Latitude, Point2.Props.Longitude, PlanetRadius);

        // получаем перепад высот
        Height := AltitudeDifference(Point1.Props.Altitude, Point2.Props.Altitude);

        // если с углом наклона и высотой все в порядке
        if
          (ArcCos(Distance / Sqrt(Distance * Distance + Sqr(Height))) / Pi * PiDegree <= MaxAngle)
          and
          ((Point1.Props.Altitude <= MaxAltitude) and (Point2.Props.Altitude <= MaxAltitude))
        then
        begin
          // вычисляем стоимость
          Result := SegmentCost(Distance, Height, DistanceCost, HeightUpCost, HeightDownCost, AngleCost)
        end;
      end;
    end;
  end;

  function BestPathExists
  (
    const Points: TPoints; // список вершин
    const StartPointIndex, EndPointIndex: Integer; // начальная и конечная вершины
    var Path: TPoints // список вершин маршрута пути
  ): Boolean; // True - путь между вершинами есть; False - путь между вершинами отсутствует
  var
    PointCounter: Integer; // счетчик вершин
    PointCount: Integer; // количество вершин в графе
    PointIndex: Integer; // текущая вершина
    Weight: Real; // вес вершины
    Distance: Real; // вес ребра
    PathPointCounter: Integer; // счетчик вершин пути
    ViewList: array of Boolean; // False - еще не найден кратчайший путь в текущую вершину, True - уже найден
    ShortestDistances: array of Real; // содержит длину кратчайшего пути от начальной вершины в текущую вершину
    SavedPoints: array of Integer; // номера точек сохраненного пути
    PathPoints: array of Integer; // массив, куда будут сохраняться номера вершин пути (в обратном порядке)
    PathExists: Boolean; // True - путь между вершинами есть; False - путь между вершинами отсутствует
  begin
    // инициализируем выходные данные
    Result := False;
    SetLength(Path, 0);

    // инициализируем рабочие данные
    PointCount := Length(Points); // количество вершин
    SetLength(ViewList, PointCount);
    SetLength(ShortestDistances, PointCount);
    SetLength(SavedPoints, PointCount);
    for PointCounter := 0 to PointCount - 1 do
    begin
      ShortestDistances[PointCounter] := Infinity; // сначала все пути - бесконечно большие
      ViewList[PointCounter] := False; // ни одна из вершин еще не рассмотрена
    end;
    ShortestDistances[StartPointIndex] := 0; // кратчайший путь из первой вершины в нее же равен 0
    ViewList[StartPointIndex] := True; // для первой вершины найден кратчайший путь
    SavedPoints[StartPointIndex] := 0; // начало пути
    PointIndex := StartPointIndex; // делаем стартовую вершину текущей

    while (PointIndex <> EndPointIndex) do // пока не дойдем до цели
    begin
      // перебираем все вершины, смежные v, и ищем для них кратчайший путь
      for PointCounter := 0 to PointCount - 1 do
      begin
        // определяем вес ребра
        Distance := EdgeWeight(Points[PointIndex], Points[PointCounter]);
        // если вес равен бесконечности - значит связи нет, ничего не делаем
        if Distance = Infinity then Continue;
        // если для текущей вершины еще не найден кратчайший путь, и новый путь в нее короче чем старый
        if (ViewList[PointCounter] = False) and (ShortestDistances[PointCounter] > (ShortestDistances[PointIndex] + Distance)) then
        begin
          // запоминаем более короткую длину пути
          ShortestDistances[PointCounter] := ShortestDistances[PointIndex] + Distance;
          // запоминаем, что PointIndex -> PointCounter есть часть кратчайшего пути
          SavedPoints[PointCounter] := PointIndex;
        end;
      end;

      // ищем из всех длин некратчайших путей самый короткий;
      // в конце поиска PointIndex - вершина, в которую будет
      // найден новый кратчайший путь, она станет текущей вершиной
      Weight := Infinity;
      PathExists := False;
      // перебираем все вершины
      for PointCounter := 0 to PointCount - 1 do
      begin
        if (ViewList[PointCounter] = False) and (ShortestDistances[PointCounter] < Weight) then
        begin
          PointIndex := PointCounter;
          Weight := ShortestDistances[PointCounter];
          PathExists := True;
        end;
      end;

      // если пути нет - прекращаем алгоритм, иначе идем дальше
      if not PathExists then
        Break
      else
      begin
        ViewList[PointIndex] := True; // вершина v становится рассмотренной
        if PointIndex = EndPointIndex then // если дошли то точки назначения, формируем путь к ней
        begin
          // запоминаем номера вершин (от конечной к начальной)
          PathPointCounter := 0;
          PointCounter := EndPointIndex;
          repeat
            Inc(PathPointCounter);
            SetLength(PathPoints, PathPointCounter);
            PathPoints[PathPointCounter - 1] := PointCounter; // запоминаем очередную вершину
            PointCounter := SavedPoints[PointCounter]; // берем следующую
          until PathPoints[PathPointCounter - 1] = StartPointIndex; // пока не дойдем до начальной вершины

          // получаем путь
          SetLength(Path, PathPointCounter);
          for PointCounter := PathPointCounter - 1 downto 0 do
          begin
            Path[PathPointCounter - PointCounter - 1] := Points[PathPoints[PointCounter]];
          end;

          // возращаем положительный результат
          Result := True;
        end;
      end;
    end;
  end;
begin
  // запрашиваем параметры расчета
  with TCalcPropsForm.Create(Self) do
  begin
    try
      ShowModal;

      // если параметры заданы
      if ModalResult = mrOk then
      begin
        // определяем параметры
        StartLatitudeBorder := DecodeLatitude(StrToFloat(StartLatitudeBorderEdit.Text));
        EndLatitudeBorder := DecodeLatitude(StrToFloat(EndLatitudeBorderEdit.Text));
        StartLongitudeBorder := DecodeLongitude(StrToFloat(StartLongitudeBorderEdit.Text));
        EndLongitudeBorder := DecodeLongitude(StrToFloat(EndLongitudeBorderEdit.Text));
        StartPointID := LandscapeDB.NearPoint(DecodeLatitude(StrToFloat(StartLatitudeEdit.Text)), DecodeLongitude(StrToFloat(StartLongitudeEdit.Text)));
        EndPointID := LandscapeDB.NearPoint(DecodeLatitude(StrToFloat(EndLatitudeEdit.Text)), DecodeLongitude(StrToFloat(EndLongitudeEdit.Text)));

        if (StartPointID <> 0) and (EndPointID <> 0) then
        begin
          if StartPointID <> EndPointID then
          begin
            if TrackIsSaved then
            begin
              // получаем и обрабатываем массив вершин
              SetStatusText(rsVertexListReading, spHint);

              try
                with LandscapeDB.OpenQuery(Format('select s.point_id, s.latitude, s.longitude, s.altitude from dbo.surface s, dbo.area(%d, %d, %d, %d) a where a.point_id = s.id', [StartLatitudeBorder, EndLatitudeBorder, StartLongitudeBorder, EndLongitudeBorder])) do
                begin
                  try
                    PointCount := RecordCount;
                    if PointCount > 0 then
                    begin
                      if PointCount <= MaxPointCount then
                      begin
                        SetStatusText(rsVertexListParsing, spHint);

                        InitProgressBar(PointCount);
                        SetLength(Points, PointCount);
                        for PointCounter := 0 to PointCount - 1 do
                        begin
                          Points[PointCounter].ID := FieldValues['point_id'];
                          Points[PointCounter].Props.Latitude := FieldValues['latitude'];
                          Points[PointCounter].Props.Longitude := FieldValues['longitude'];
                          Points[PointCounter].Props.Altitude := FieldValues['altitude'];
                          Next;

                          SetProgressBar(PointCounter + 1);
                        end;
                        ResetProgressBar;

                        // проверяем наличие начальной и конечной точек в области поиска
                        SetStatusText('Проверка условие поиска на вхождение в область...', spHint);
                        InitProgressBar(PointCount);

                        StartPoint := 0;
                        EndPoint := 0;
                        for PointCounter := 0 to PointCount - 1 do
                        begin
                          if Points[PointCounter].ID = StartPointID then
                            StartPoint := PointCounter;
                          if Points[PointCounter].ID = EndPointID then
                            EndPoint := PointCounter;
                          SetProgressBar(PointCounter + 1);
                        end;
                        ResetProgressBar;

                        if (StartPoint <> 0) and (EndPoint <> 0) then
                        begin
                          WriteToLog(Format(rsPathSearching, [Length(Points)]));
                          SetStatusText(Format(rsPathSearching, [Length(Points)]), spHint);

                          if BestPathExists(Points, StartPoint, EndPoint, BestPath) then
                          begin
                            // запоминаем найденный путь
                            Track.Clear;
                            for PointCounter := 0 to Length(BestPath) - 1 do
                            begin
                              Track.Add(BestPath[PointCounter].Props);
                            end;

                            // выводим путь на экран
                            DisplayTrack;

                            WriteToLog(Format(rsPathFound, [Track.PointCount]));
                          end
                          else
                          begin
                            WriteToLog(rsPathNotFound);
                            WarningMsg(rsPathNotFound);
                          end;
                        end
                        else
                        begin
                          WriteToLog(rsSearchConditionNotExistsInSearchArea);
                          ErrorMsg(rsSearchConditionNotExistsInSearchArea);
                        end;
                      end
                      else
                      begin
                        WriteToLog(rsSearchAreaSizeExceedsLimit);
                        ErrorMsg(rsSearchAreaSizeExceedsLimit);
                      end;
                    end
                    else
                    begin
                      WriteToLog(rsSearchAreaEmpty);
                      ErrorMsg(rsSearchAreaEmpty);
                    end;
                  finally
                    Free;
                  end;
                end;
              except
                on E: Exception do
                begin
                  WriteToLog(rsCanNotBuildTrack + rsSpace + E.Message);
                  ShowApplicationError(rsCanNotBuildTrack, E.Message);
                end;
              end;

              SetStatusText(EmptyStr, spHint);
            end;
          end
          else
          begin
            WriteToLog(rsStartEqualsToEnd);
            ErrorMsg(rsStartEqualsToEnd);
          end;
        end
        else
        begin
          WriteToLog(rsNoElevationData);
          ErrorMsg(rsNoElevationData);
        end;
      end;
    finally
      Free;
    end;  
  end;
end;

procedure TLandscapeBuilderForm.SetProgressBar(const OperationNum: Integer);
begin
  ProgressBar.Position := OperationNum;
  Application.ProcessMessages;
end;

procedure TLandscapeBuilderForm.DisplayTrack;
var
  PointCounter: Integer;
  StepDistance, StepCost: Real;
  StepHeight, StepRaise, StepFall: TAltitude;
  PathDistance, PathCost: Real;
  PathRaise, PathFall: Integer;
  PathHeight: TAltitude;
begin
  StepDistance := 0;
  StepHeight := 0;
  StepCost := 0;
  PathDistance := 0;
  PathHeight := 0;
  PathRaise := 0;
  PathFall := 0;
  PathCost := 0;

  TrackChartForm.AltitudeSeries.Clear;
  
  with TrackPointsDataSet do
  begin
    DisableControls;
    EmptyTable;

    for PointCounter := 0 to Track.PointCount - 1 do
    begin
      if PointCounter > 0 then
      begin
        StepDistance := ArcLength(Track[PointCounter - 1].Latitude, Track[PointCounter - 1].Longitude, Track[PointCounter].Latitude, Track[PointCounter].Longitude, PlanetRadius);
        StepHeight := AltitudeDifference(Track[PointCounter - 1].Altitude, Track[PointCounter].Altitude);

        if StepHeight > 0 then StepRaise := StepHeight else StepRaise := 0;
        if StepHeight < 0 then StepFall := -StepHeight else StepFall := 0;

        StepCost := SegmentCost(StepDistance, StepHeight, DistanceCost, HeightUpCost, HeightDownCost, AngleCost);
        PathDistance := PathDistance + StepDistance;
        PathHeight := PathHeight + StepHeight;
        PathRaise := PathRaise + StepRaise;
        PathFall := PathFall + StepFall;
        PathCost := PathCost + StepCost;
      end;

      Append;
      FieldValues['step_num'] := PointCounter;
      FieldValues['latitude'] := Track[PointCounter].Latitude;
      FieldValues['longitude'] := Track[PointCounter].Longitude;
      FieldValues['altitude'] := Track[PointCounter].Altitude;
      FieldValues['step_distance'] := RoundTo(StepDistance, -DistanceRoundSigns);
      FieldValues['step_height'] := StepHeight;
      FieldValues['step_cost'] := RoundTo(StepCost, -CostRoundSigns);
      Post;

      TrackChartForm.AltitudeSeries.AddXY(PathDistance, Track[PointCounter].Altitude);
    end;

    First;
    EnableControls;
  end;

  TrackChartForm.SummaryPanel.Caption := Format(rsTrackSummary, [PathDistance, PathHeight, PathRaise, PathFall, PathCost]);

  SetControls;
end;

procedure TLandscapeBuilderForm.ImportMIClick(Sender: TObject);
var
  ImportedTrack: TTrack;
  ImportedPlaceList: TPlaceList;
begin
  if DataPageControl.ActivePage = TrackTabSheet then
  begin
    if TrackIsSaved then
    begin
      with TrackDataOpenDialog do
      begin
        if Execute then
        begin
          ImportedTrack := TTrack.Create;

          try
            try
              case FilterIndex of
                1: {ozi}
                begin
                  WriteToLog(rsTrackImportingOzi);
                  SetStatusText(rsTrackImportingOzi, spHint);

                  OziTrackImport(ImportedTrack, FileName);
                end;
              end;

              Track.Clear;
              Track.Append(ImportedTrack);

              DisplayTrack;

              WriteToLog(Format(rsTrackImportingOK, [Track.PointCount]));
            except
              on E: Exception do
              begin
                WriteToLog(rsTrackImportingError + rsSpace + E.Message);
                ShowApplicationError(rsTrackImportingError, E.Message);
              end;
            end;
          finally
            FreeAndNil(ImportedTrack);
          end;

          SetStatusText(EmptyStr, spHint);
        end;
      end;
    end;      
  end;

  if DataPageControl.ActivePage = PlaceListTabSheet then
  begin
    if PlaceListIsSaved then
    begin

      with PlaceListDataOpenDialog do
      begin
        if Execute then
        begin
          ImportedPlaceList := TPlaceList.Create;

          try
            try
              case FilterIndex of
                1: {ozi}
                begin
                  WriteToLog(rsPlaceListImportingOzi);
                  SetStatusText(rsPlaceListImportingOzi, spHint);

                  OziPlaceListImport(ImportedPlaceList, FileName);
                end;
              end;

              PlaceList.Clear;
              PlaceList.Append(ImportedPlaceList);

              DisplayPlaceList;

              WriteToLog(Format(rsPlaceListImportingOK, [PlaceList.Count]));
            except
              on E: Exception do
              begin
                WriteToLog(rsPlaceListImportingError + rsSpace + E.Message);
                ShowApplicationError(rsPlaceListImportingError, E.Message);
              end;
            end;
          finally
            FreeAndNil(ImportedPlaceList);
          end;

          SetStatusText(EmptyStr, spHint);
        end;
      end;
    end;
  end;
end;

procedure TLandscapeBuilderForm.SaveTrack;
begin
  with TrackSaveDialog do
  begin
    if Execute then
    begin
      WriteToLog(rsTrackSaving);
      SetStatusText(rsTrackSaving, spHint);

      try
        Track.SaveToFile(FileName);
      except
        on E: Exception do
        begin
          WriteToLog(rsTrackSavingError + rsSpace + E.Message);
          ShowApplicationError(rsTrackSavingError, E.Message);
        end;
      end;

      WriteToLog(rsTrackSavingOK);
      SetStatusText(EmptyStr, spHint);
    end;
  end;
end;

procedure TLandscapeBuilderForm.SaveMIClick(Sender: TObject);
begin
  Save;
end;

procedure TLandscapeBuilderForm.OpenTrack;
begin
  if TrackIsSaved then
  begin
    with TrackOpenDialog do
    begin
      if Execute then
      begin
        WriteToLog(rsTrackOpening);
        SetStatusText(rsTrackOpening, spHint);

        try
          Track.Clear;
          Track.LoadFromFile(FileName);

          DisplayTrack;

          WriteToLog(Format(rsTrackOpeningOK, [Track.PointCount]));
        except
          on E: Exception do
          begin
            WriteToLog(rsTrackOpeningError + rsSpace + E.Message);
            ShowApplicationError(rsTrackOpeningError, E.Message);
          end;
        end;

        SetStatusText(EmptyStr, spHint);
      end;
    end;
  end;
end;

procedure TLandscapeBuilderForm.OpenMIClick(Sender: TObject);
begin
  Open;
end;

procedure TLandscapeBuilderForm.InitTrack;
begin
  if not Assigned(TrackChartForm) then
  begin
    TrackChartForm := TTrackChartForm.Create(Self);
  end;

  if TrackIsSaved then
  begin
    Track.Clear;
    DisplayTrack;

    WriteToLog(rsTrackInit);
  end;
end;

procedure TLandscapeBuilderForm.NewMIClick(Sender: TObject);
begin
  Init;
end;

procedure TLandscapeBuilderForm.EditSettings;
var
  NewMaxPointCount: Cardinal;
  NewMaxAngle: Byte;
  NewMaxAltitude: TAltitude;
  NewSaveTrackOnExit: Boolean;
  NewDistanceCost, NewHeightUpCost, NewHeightDownCost, NewAngleCost: Real;
begin
  with TSettingsForm.Create(Self) do
  begin
    try
      // основные
      MaxPointCountEdit.Text := IntToStr(MaxPointCount);
      MaxAngleEditUpDown.Position := MaxAngle;
      MaxAltitudeEdit.Text := IntToStr(MaxAltitude);
      SaveTrackOnExitCheckBox.Checked := SaveTrackOnExit;
      // стоимость
      DistanceCostEdit.Text := FloatToStr(DistanceCost);
      HeightUpCostEdit.Text := FloatToStr(HeightUpCost);
      HeightDownCostEdit.Text := FloatToStr(HeightDownCost);
      AngleCostEdit.Text := FloatToStr(AngleCost);

      // выводим форму на экран
      ShowModal;

      // определяем новые параметры
      if ModalResult = mrOk then
      begin
        // основные
        NewMaxPointCount := StrToInt(MaxPointCountEdit.Text);
        NewMaxAngle := MaxAngleEditUpDown.Position;
        NewMaxAltitude := StrToInt(MaxAltitudeEdit.Text);
        NewSaveTrackOnExit := SaveTrackOnExitCheckBox.Checked;
        // стоимость
        NewDistanceCost := StrToFloat(DistanceCostEdit.Text);
        NewHeightUpCost := StrToFloat(HeightUpCostEdit.Text);
        NewHeightDownCost := StrToFloat(HeightDownCostEdit.Text);
        NewAngleCost := StrToFloat(AngleCostEdit.Text);

        // записываем в INI-файл
        with TIniFile.Create(IniFileName) do
        begin
          try
            // основные
            WriteInteger('main', 'MaxPointCount', NewMaxPointCount);
            WriteInteger('main', 'MaxAngle', NewMaxAngle);
            WriteInteger('main', 'MaxHeight', NewMaxAltitude);
            WriteBool('main', 'SaveTrackOnExit', NewSaveTrackOnExit);
            // стоимость
            WriteFloat('cost', 'DistanceCost', NewDistanceCost);
            WriteFloat('cost', 'HeightUpCost', NewHeightUpCost);
            WriteFloat('cost', 'HeightDownCost', NewHeightDownCost);
            WriteFloat('cost', 'AngleCost', NewAngleCost);
          finally
            Free;
          end;
        end;

        // применяем настройки
        MaxPointCount := NewMaxPointCount;
        MaxAngle := NewMaxAngle;
        MaxAltitude := NewMaxAltitude;
        SaveTrackOnExit := NewSaveTrackOnExit;
        DistanceCost := NewDistanceCost;
        HeightUpCost := NewHeightUpCost;
        HeightDownCost := NewHeightDownCost;
        AngleCost := NewAngleCost;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TLandscapeBuilderForm.SettingsMIClick(Sender: TObject);
begin
  EditSettings;
end;

procedure TLandscapeBuilderForm.TrackDataSaveDialogTypeChange(Sender: TObject);
begin
  with TrackDataSaveDialog do
  begin
    case FilterIndex of
      1: DefaultExt := OziTrackExt; {ozi}
    end;
  end;
end;

procedure TLandscapeBuilderForm.InitProgressBar(
  const OperationCount: Integer);
begin
  ProgressBar.Properties.Max := OperationCount;
  Application.ProcessMessages;
end;

procedure TLandscapeBuilderForm.LogMIClick(Sender: TObject);
begin
  ShowLog;
end;

procedure TLandscapeBuilderForm.BuildTrackMIClick(Sender: TObject);
begin
  BuildTrack;
end;

procedure TLandscapeBuilderForm.ExportTrackPointsGridtMIClick(
  Sender: TObject);
begin
  ExportGrid(TrackPointsGrid);
end;

procedure TLandscapeBuilderForm.ExportMIClick(Sender: TObject);
begin
  if DataPageControl.ActivePage = TrackTabSheet then
  begin
    TrackDataSaveDialogTypeChange(Self);

    with TrackDataSaveDialog do
    begin
      if Execute then
      begin
        try
          case FilterIndex of
            1: {ozi}
            begin
              WriteToLog(rsTrackExportingOzi);
              SetStatusText(rsTrackExportingOzi, spHint);

              OziTrackExport(Track, FileName);
            end;
          end;

          WriteToLog(rsTrackExportingOK);
        except
          on E: Exception do
          begin
            WriteToLog(rsTrackExportingError + rsSpace + E.Message);
            ShowApplicationError(rsTrackExportingError, E.Message);
          end;
        end;

        SetStatusText(EmptyStr, spHint);
      end;
    end;
  end;

  if DataPageControl.ActivePage = PlaceListTabSheet then
  begin
    PlaceListDataSaveDialogTypeChange(Self);

    with PlaceListDataSaveDialog do
    begin
      if Execute then
      begin
        try
          case FilterIndex of
            1: {ozi}
            begin
              WriteToLog(rsPlaceListExportingOzi);
              SetStatusText(rsPlaceListExportingOzi, spHint);

              OziPlaceListExport(PlaceList, FileName);
            end;
          end;

          WriteToLog(rsPlaceListExportingOK);
        except
          on E: Exception do
          begin
            WriteToLog(rsPlaceListExportingError + rsSpace + E.Message);
            ShowApplicationError(rsPlaceListExportingError, E.Message);
          end;
        end;

        SetStatusText(EmptyStr, spHint);
      end;
    end;
  end;
end;

procedure TLandscapeBuilderForm.ShowLog;
begin
  LogForm.Show;
end;

function TLandscapeBuilderForm.TrackIsSaved: Boolean;
begin
  Result := False;

  if (Track.PointCount > 0) and (not Track.IsSaved) then
  begin
    case QuestionMsg(rsTrackSave) of
      IDYES:
      begin
        SaveTrack;
        Result := Track.IsSaved;
      end;
      IDNO:
      begin
        Result := True;
      end;
      IDCANCEL:
      begin
        Result := False;
      end;
    end;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TLandscapeBuilderForm.OpenToolButtonClick(Sender: TObject);
begin
  Open;
end;

procedure TLandscapeBuilderForm.SaveToolButtonClick(Sender: TObject);
begin
  Save;
end;

procedure TLandscapeBuilderForm.NewToolButtonClick(Sender: TObject);
begin
  Init;
end;

procedure TLandscapeBuilderForm.ShowTrackChartToolButtonClick(Sender: TObject);
begin
  ShowTrackChart;
end;

procedure TLandscapeBuilderForm.LogToolButtonClick(Sender: TObject);
begin
  ShowLog;
end;

procedure TLandscapeBuilderForm.SettingsToolButtonClick(Sender: TObject);
begin
  EditSettings;
end;

procedure TLandscapeBuilderForm.MemorizeTrack;
var
  PointCounter: Integer;
  ID: TRecordID;
  CategoryID: TRecordID;
  VisibleName: string;
begin
  CategoryID := 0;
  VisibleName := EmptyStr;

  if AskTrackProps(CategoryID, VisibleName) then
  begin
    WriteToLog(rsTrackMemorizing);
    SetStatusText(rsTrackMemorizing, spHint);

    LandscapeDB.BeginTransaction;
    try
      ID := LandscapeDB.CreateTrack(CategoryID, VisibleName);
      for PointCounter := 0 to Track.PointCount - 1 do
      begin
        LandscapeDB.AddTrackPoint
        (
          ID,
          PointCounter + 1,
          Track[PointCounter].Latitude,
          Track[PointCounter].Longitude
        );
      end;
      LandscapeDB.Commit;

      WriteToLog(rsTrackMemorizingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        WriteToLog(rsTrackMemorizingError + rsSpace + E.Message);
        ShowApplicationError(rsTrackMemorizingError, E.Message);
      end;
    end;

    SetStatusText(EmptyStr, spHint);
  end;
end;

procedure TLandscapeBuilderForm.MemorizeMIClick(Sender: TObject);
begin
  Memorize;
end;

procedure TLandscapeBuilderForm.MemorizeToolButtonClick(
  Sender: TObject);
begin
  Memorize;
end;

procedure TLandscapeBuilderForm.RetrieveTrack;
var
  ID: TRecordID;
  PointProps: TPointProps;
begin
  if TrackIsSaved then
  begin
    with TTrackSelectorForm.Create(Self) do
    begin
      try
        ShowModal;

        if ModalResult = mrOk then
        begin
          ID := TracksDataSet.FieldValues['id'];

          WriteToLog(rsTrackRetrieving);
          SetStatusText(rsTrackRetrieving, spHint);

          try
            Track.Clear;

            with LandscapeDB.OpenQuery(Format('select latitude, longitude, altitude from dbo.track_points(%.0f)', [ID])) do
            begin
              try
                while not Eof do
                begin
                  PointProps.Latitude := FieldValues['latitude'];
                  PointProps.Longitude := FieldValues['longitude'];
                  PointProps.Altitude := FieldValues['altitude'];

                  Track.Add(PointProps);
                  Next;
                end;
              finally
                Free;
              end;
            end;

            DisplayTrack;

            WriteToLog(Format(rsTrackRetrievingOK, [Track.PointCount]));
          except
            on E: Exception do
            begin
              WriteToLog(rsTrackRetrievingError + rsSpace + E.Message);
              ShowApplicationError(rsTrackRetrievingError, E.Message);
            end;
          end;

          SetStatusText(EmptyStr, spHint);
        end;
      finally
        Free;
      end;
    end;
  end;  
end;

procedure TLandscapeBuilderForm.RetrieveToolButtonClick(Sender: TObject);
begin
  Retrieve;
end;

procedure TLandscapeBuilderForm.RetrieveMIClick(Sender: TObject);
begin
  Retrieve;
end;

procedure TLandscapeBuilderForm.FileLoadElevationDataMIClick(Sender: TObject);
begin
  LoadElevationData(edltFile);
end;

procedure TLandscapeBuilderForm.DatabaseLoadElevationDataMIClick(Sender: TObject);
begin
  LoadElevationData(edltDatabase);
end;

procedure TLandscapeBuilderForm.ShowPlaces;
begin
  with TPlacesForm.Create(Self) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TLandscapeBuilderForm.ShowPlacesToolButtonClick(Sender: TObject);
begin
  ShowPlaces;
end;

procedure TLandscapeBuilderForm.ShowPlacesMIClick(Sender: TObject);
begin
  ShowPlaces;
end;

procedure TLandscapeBuilderForm.ConstMIClick(Sender: TObject);
begin
  InfoMsg
  (
    Format(rsConstLatitudeStep, [LatitudeStep]) + rsLineBreak +
    Format(rsConstLongitudeStep, [LongitudeStep]) + rsLineBreak +
    Format(rsConstPlanetRadius, [PlanetRadius])
  );
end;

procedure TLandscapeBuilderForm.ShowTrackChart;
begin
  TrackChartForm.Visible := True;
end;

procedure TLandscapeBuilderForm.ShowTrackChartMIClick(Sender: TObject);
begin
  ShowTrackChart;
end;

procedure TLandscapeBuilderForm.CategoriesMIClick(Sender: TObject);
begin
  with TCategoriesForm.Create(Self) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TLandscapeBuilderForm.Memorize;
begin
  if DataPageControl.ActivePage = TrackTabSheet then MemorizeTrack;
  if DataPageControl.ActivePage = PlaceListTabSheet then MemorizePlaceList;
end;

procedure TLandscapeBuilderForm.Retrieve;
begin
  if DataPageControl.ActivePage = TrackTabSheet then RetrieveTrack;
  if DataPageControl.ActivePage = PlaceListTabSheet then RetrievePlaceList;
end;

procedure TLandscapeBuilderForm.Init;
begin
  if DataPageControl.ActivePage = TrackTabSheet then InitTrack;
  if DataPageControl.ActivePage = PlaceListTabSheet then InitPlaceList;
end;

procedure TLandscapeBuilderForm.Open;
begin
  if DataPageControl.ActivePage = TrackTabSheet then OpenTrack;
  if DataPageControl.ActivePage = PlaceListTabSheet then OpenPlaceList;
end;

procedure TLandscapeBuilderForm.Save;
begin
  if DataPageControl.ActivePage = TrackTabSheet then SaveTrack;
  if DataPageControl.ActivePage = PlaceListTabSheet then SavePlaceList;
end;

procedure TLandscapeBuilderForm.SetControls;
begin
  if DataPageControl.ActivePage = TrackTabSheet then
  begin
    SaveMI.Enabled := Track.PointCount > 0;
    ExportMI.Enabled := Track.PointCount > 0;
    BuildTrackMI.Enabled := True;
    MemorizeMI.Enabled := Track.PointCount > 0;
    ShowTrackChartMI.Enabled := True;

    SaveToolButton.Enabled := Track.PointCount > 0;
    MemorizeToolButton.Enabled := Track.PointCount > 0;
    ShowTrackChartToolButton.Enabled := True;

    AddTrackPointCurMI.Enabled := Track.PointCount > 0;
    EditTrackPointMI.Enabled := Track.PointCount > 0;
    DeleteTrackPointMI.Enabled := Track.PointCount > 0;    
    ExportTrackPointsGridtMI.Enabled := Track.PointCount > 0;
  end;

  if DataPageControl.ActivePage = PlaceListTabSheet then
  begin
    SaveMI.Enabled := PlaceList.Count > 0;
    ExportMI.Enabled := PlaceList.Count > 0;
    BuildTrackMI.Enabled := False;
    MemorizeMI.Enabled := PlaceList.Count > 0;
    ShowTrackChartMI.Enabled := False;

    SaveToolButton.Enabled := PlaceList.Count > 0;
    MemorizeToolButton.Enabled := PlaceList.Count > 0;
    ShowTrackChartToolButton.Enabled := False;

    AddPlaceCurMI.Enabled := PlaceList.Count > 0;
    EditPlaceMI.Enabled := PlaceList.Count > 0;
    DeleteTrackPointMI.Enabled := PlaceList.Count > 0;
    ExportPlacesGridMI.Enabled := PlaceList.Count > 0;
  end;
end;

procedure TLandscapeBuilderForm.DataPageControlChange(Sender: TObject);
begin
  SetControls;
end;

procedure TLandscapeBuilderForm.TrackModeMIClick(Sender: TObject);
begin
  DataPageControl.ActivePage := TrackTabSheet;
  SetControls;
end;

procedure TLandscapeBuilderForm.PlacesModeMIClick(Sender: TObject);
begin
  DataPageControl.ActivePage := PlaceListTabSheet;
  SetControls;
end;

procedure TLandscapeBuilderForm.ShowTracks;
begin
  with TTracksForm.Create(Self) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TLandscapeBuilderForm.ShowTracksMIClick(Sender: TObject);
begin
  ShowTracks;
end;

procedure TLandscapeBuilderForm.ShowTracksToolButtonClick(Sender: TObject);
begin
  ShowTracks;
end;

procedure TLandscapeBuilderForm.TrackPointsDataSetBeforePost(
  DataSet: TDataSet);
begin
  with TrackPointsDataSet do
  begin
    FieldValues['latitude_degree'] := RoundTo(EncodeLatitude(FieldValues['latitude']), -CoordinatesDegreeRoundSigns);
    FieldValues['longitude_degree'] := RoundTo(EncodeLongitude(FieldValues['longitude']), -CoordinatesDegreeRoundSigns);
  end;
end;

procedure TLandscapeBuilderForm.AddTrackPointCurMIClick(Sender: TObject);
var
  Latitude, Longitude: Integer;
  SurfacePointID: TRecordID;
  StepNum: Integer;
  PointProps: TPointProps;
begin
  if AskTrackPointProps(Latitude, Longitude, False) then
  begin
    SurfacePointID := LandscapeDB.NearPoint(Latitude, Longitude);

    if SurfacePointID <> 0 then
    begin
      StepNum := TrackPointsDataSet.RecNo - 1;
      TrackPointsDataSet.DisableControls;

      PointProps.Latitude := Latitude;
      PointProps.Longitude := Longitude;
      PointProps.Altitude := LandscapeDB.PointAltitude(SurfacePointID);

      Track.Add(PointProps, StepNum + 1);

      DisplayTrack;
      TrackPointsDataSet.RecNo := StepNum + 1;
      TrackPointsDataSet.EnableControls;
    end
    else
    begin
      ErrorMsg(Format(rsPointNotFound, [RoundTo(EncodeLatitude(Latitude), -CoordinatesDegreeRoundSigns), RoundTo(EncodeLongitude(Longitude), -CoordinatesDegreeRoundSigns)]));
    end;
  end;
end;

procedure TLandscapeBuilderForm.AddTrackPointLastMIClick(Sender: TObject);
var
  Latitude, Longitude: Integer;
  SurfacePointID: TRecordID;
  PointProps: TPointProps;
begin
  if AskTrackPointProps(Latitude, Longitude, False) then
  begin
    SurfacePointID := LandscapeDB.NearPoint(Latitude, Longitude);

    if SurfacePointID <> 0 then
    begin
      TrackPointsDataSet.DisableControls;

      PointProps.Latitude := Latitude;
      PointProps.Longitude := Longitude;
      PointProps.Altitude := LandscapeDB.PointAltitude(SurfacePointID);

      Track.Add(PointProps);

      DisplayTrack;
      TrackPointsDataSet.Last;
      TrackPointsDataSet.EnableControls;
    end
    else
    begin
      ErrorMsg(Format(rsPointNotFound, [RoundTo(EncodeLatitude(Latitude), -CoordinatesDegreeRoundSigns), RoundTo(EncodeLongitude(Longitude), -CoordinatesDegreeRoundSigns)]));
    end;
  end;
end;

function TLandscapeBuilderForm.PlaceListIsSaved: Boolean;
begin
  Result := False;

  if (PlaceList.Count > 0) and (not PlaceList.IsSaved) then
  begin
    case QuestionMsg(rsPlaceListSave) of
      IDYES:
      begin
        SavePlaceList;
        Result := PlaceList.IsSaved;
      end;
      IDNO:
      begin
        Result := True;
      end;
      IDCANCEL:
      begin
        Result := False;
      end;
    end;
  end
  else
  begin
    Result := True;
  end;
end;

procedure TLandscapeBuilderForm.InitPlaceList;
begin
  if PlaceListIsSaved then
  begin
    PlaceList.Clear;
    DisplayPlaceList;

    WriteToLog(rsPlaceListInit);
  end;
end;

procedure TLandscapeBuilderForm.DisplayPlaceList;
var
  PlaceCounter: Integer;
begin
  with PlacesDataSet do
  begin
    DisableControls;
    EmptyTable;

    for PlaceCounter := 0 to PlaceList.Count - 1 do
    begin
      Append;
      FieldValues['place_num'] := PlaceCounter + 1;
      FieldValues['identity_name'] := PlaceList[PlaceCounter].IdentityName;
      FieldValues['visible_name'] := PlaceList[PlaceCounter].VisibleName;
      FieldValues['latitude'] := PlaceList[PlaceCounter].PointProps.Latitude;
      FieldValues['longitude'] := PlaceList[PlaceCounter].PointProps.Longitude;
      FieldValues['altitude'] := PlaceList[PlaceCounter].PointProps.Altitude;
      Post;
    end;

    First;
    EnableControls;
  end;
  
  SetControls;
end;

procedure TLandscapeBuilderForm.PlacesDataSetBeforePost(DataSet: TDataSet);
begin
  with PlacesDataSet do
  begin
    FieldValues['latitude_degree'] := RoundTo(EncodeLatitude(FieldValues['latitude']), -CoordinatesDegreeRoundSigns);
    FieldValues['longitude_degree'] := RoundTo(EncodeLongitude(FieldValues['longitude']), -CoordinatesDegreeRoundSigns);
  end;
end;

procedure TLandscapeBuilderForm.MemorizePlaceList;
var
  PlaceCounter: Integer;

  CategoryID: TRecordID;
begin
  CategoryID := 0;

  if AskPlaceListProps(CategoryID) then
  begin
    WriteToLog(rsPlaceListMemorizing);
    SetStatusText(rsPlaceListMemorizing, spHint);

    LandscapeDB.BeginTransaction;
    try
      for PlaceCounter := 0 to PlaceList.Count - 1 do
      begin
        LandscapeDB.InsertPlace
        (
          CategoryID,
          PlaceList[PlaceCounter].PointProps.Latitude,
          PlaceList[PlaceCounter].PointProps.Longitude,
          PlaceList[PlaceCounter].IdentityName,
          PlaceList[PlaceCounter].VisibleName
        );
      end;
      LandscapeDB.Commit;

      WriteToLog(rsPlaceListMemorizingOK);
    except
      on E: Exception do
      begin
        LandscapeDB.Rollback;

        WriteToLog(rsPlaceListMemorizingError + rsSpace + E.Message);
        ShowApplicationError(rsPlaceListMemorizingError, E.Message);
      end;
    end;

    SetStatusText(EmptyStr, spHint);
  end;
end;

procedure TLandscapeBuilderForm.SavePlaceList;
begin
  with PlaceListSaveDialog do
  begin
    if Execute then
    begin
      WriteToLog(rsPlaceListSaving);
      SetStatusText(rsPlaceListSaving, spHint);

      try
        PlaceList.SaveToFile(FileName);
      except
        on E: Exception do
        begin
          WriteToLog(rsPlaceListSavingError + rsSpace + E.Message);
          ShowApplicationError(rsPlaceListSavingError, E.Message);
        end;
      end;

      WriteToLog(rsPlaceListSavingOK);
      SetStatusText(EmptyStr, spHint);
    end;
  end;
end;

procedure TLandscapeBuilderForm.OpenPlaceList;
begin
  if PlaceListIsSaved then
  begin
    with PlaceListOpenDialog do
    begin
      if Execute then
      begin
        WriteToLog(rsPlaceListOpening);
        SetStatusText(rsPlaceListOpening, spHint);

        try
          PlaceList.Clear;
          PlaceList.LoadFromFile(FileName);

          DisplayPlaceList;

          WriteToLog(Format(rsPlaceListOpeningOK, [PlaceList.Count]));
        except
          on E: Exception do
          begin
            WriteToLog(rsPlaceListOpeningError + rsSpace + E.Message);
            ShowApplicationError(rsPlaceListOpeningError, E.Message);
          end;
        end;

        SetStatusText(EmptyStr, spHint);
      end;
    end;
  end;
end;

procedure TLandscapeBuilderForm.RetrievePlaceList;
var
  Place: TPlace;
begin
  if PlaceListIsSaved then
  begin
    with TPlacesSelectorForm.Create(Self) do
    begin
      try
        ShowModal;

        if ModalResult = mrOk then
        begin
          WriteToLog(rsPlaceListRetrieving);
          SetStatusText(rsPlaceListRetrieving, spHint);

          try
            PlaceList.Clear;

            with PlacesDataSet do
            begin
              First;
              while not Eof do
              begin
                if FieldValues['checked'] = 1 then
                begin
                  Place.IdentityName := FieldValues['identity_name'];
                  Place.VisibleName := FieldValues['visible_name'];
                  Place.PointProps.Latitude := FieldValues['latitude'];
                  Place.PointProps.Longitude := FieldValues['longitude'];
                  Place.PointProps.Altitude := FieldValues['altitude'];

                  PlaceList.Add(Place);
                end;  

                Next;
              end;
            end;

            DisplayPlaceList;

            WriteToLog(Format(rsPlaceListRetrievingOK, [PlaceList.Count]));
          except
            on E: Exception do
            begin
              WriteToLog(rsPlaceListRetrievingError + rsSpace + E.Message);
              ShowApplicationError(rsPlaceListRetrievingError, E.Message);
            end;
          end;

          SetStatusText(EmptyStr, spHint);
        end;
      finally
        Free;
      end;
    end;
  end;
end;

procedure TLandscapeBuilderForm.EditTrackPointMIClick(Sender: TObject);
var
  Latitude, Longitude: Integer;
  SurfacePointID: TRecordID;
  StepNum: Integer;
  PointProps: TPointProps;
begin
  with TrackPointsDataSet do
  begin
    Latitude := FieldValues['latitude'];
    Longitude := FieldValues['longitude'];
  end;

  if AskTrackPointProps(Latitude, Longitude, True) then
  begin
    SurfacePointID := LandscapeDB.NearPoint(Latitude, Longitude);

    if SurfacePointID <> 0 then
    begin
      StepNum := TrackPointsDataSet.RecNo - 1;
      TrackPointsDataSet.DisableControls;

      PointProps.Latitude := Latitude;
      PointProps.Longitude := Longitude;
      PointProps.Altitude := LandscapeDB.PointAltitude(SurfacePointID);

      Track[StepNum] := PointProps;

      DisplayTrack;
      TrackPointsDataSet.RecNo := StepNum + 1;
      TrackPointsDataSet.EnableControls;
    end
    else
    begin
      ErrorMsg(Format(rsPointNotFound, [RoundTo(EncodeLatitude(Latitude), -CoordinatesDegreeRoundSigns), RoundTo(EncodeLongitude(Longitude), -CoordinatesDegreeRoundSigns)]));
    end;
  end;
end;


procedure TLandscapeBuilderForm.DeleteTrackPointMIClick(Sender: TObject);
var
  StepNum: Integer;
  RecordIndex: Integer;
  Indexes: TIndexes;
begin
  StepNum := TrackPointsDataSet.RecNo - 1;

  TrackPointsDataSet.DisableControls;

  if TrackPointsView.Controller.SelectedRecordCount <= 1 then
  begin
    Track.Delete(StepNum);
  end
  else
  begin
    SetLength(Indexes, 0);

    with TrackPointsView.Controller do
    begin
      for RecordIndex := 0 to SelectedRecordCount - 1 do
      begin
        SetLength(Indexes, Length(Indexes) + 1);
        Indexes[Length(Indexes) - 1] := SelectedRecords[RecordIndex].RecordIndex;
      end;
      ClearSelection;
    end;

    Track.Delete(Indexes);
  end;

  DisplayTrack;
  TrackPointsDataSet.RecNo := StepNum + 1;
  TrackPointsDataSet.EnableControls;
end;

procedure TLandscapeBuilderForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not (TrackIsSaved and PlaceListIsSaved) then
  begin
    Action := caNone;
  end;
end;

procedure TLandscapeBuilderForm.ExportPlacesGridMIClick(Sender: TObject);
begin
  ExportGrid(PlacesGrid);
end;

procedure TLandscapeBuilderForm.PlaceListDataSaveDialogTypeChange(
  Sender: TObject);
begin
  with PlaceListDataSaveDialog do
  begin
    case FilterIndex of
      1: DefaultExt := OziPlaceListExt; {ozi}
    end;
  end;
end;

procedure TLandscapeBuilderForm.ReverseTrackMIClick(Sender: TObject);
begin
  Track.Reverse;
  DisplayTrack;
end;

end.

