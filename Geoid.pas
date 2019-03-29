unit Geoid;

interface

uses
  Forms, SysConst, SysUtils, Math, Utils;

type
  TAltitude = Smallint;

  TPointProps = record
    Latitude: Integer;
    Longitude: Integer;
    Altitude: TAltitude;
  end;

  TPlace = record
    IdentityName: string[255];
    VisibleName: string[255];
    PointProps: TPointProps;
  end;

  TPoint = record
    ID: TRecordID;
    Props: TPointProps;
  end;

  TPointsProps = array of TPointProps;
  TPoints = array of TPoint;

  TReliefMap = class(TObject)
  private
    FPixels: array of array of TAltitude;
    FRadius: Integer;
    FStartLatitude: Integer;
    FStartLongitude: Integer;
    FLatitudeStep: Word;
    FLongitudeStep: Word;
    FHeight: Word;
    FWidth: Word;
    function GetPixel(const LatitudeLine, LongitudeLine: Word): TAltitude;
    procedure SetPixel(const LatitudeLine, LongitudeLine: Word;
      const Altitude: TAltitude);
    procedure SetHeight(const Height: Word);
    procedure SetWidth(const Width: Word);
  public
    constructor Create(const StartLatitude, StartLongitude: Integer;
      const LatitudeStep, LongitudeStep: Word; const Radius: Integer);
    constructor CreateSRTM(const FileName: string; const Radius: Integer);
    property Radius: Integer read FRadius;
    property StartLatitude: Integer read FStartLatitude;
    property StartLongitude: Integer read FStartLongitude;
    property LatitudeStep: Word read FLatitudeStep;
    property LongitudeStep: Word read FLongitudeStep;
    property Height: Word read FHeight write SetHeight;
    property Width: Word read FWidth write SetWidth;
    property Pixels[const LatitudeLine, LongitudeLine: Word]: TAltitude read GetPixel write SetPixel; default;
    function Altitude(const Latitude, Longitude: Integer): TAltitude;
  end;

  TTrack = class(TObject)
  private
    FPointsProps: TPointsProps;
    FIsSaved: Boolean;
    function GetPointCount: Integer;
    function GetPointProps(const Index: Integer): TPointProps;
    procedure SetPointProps(const Index: Integer; PointProps: TPointProps);
  public
    constructor Create;
    procedure Append(Track: TTrack);
    procedure Add(PointProps: TPointProps; const Index: Integer = 0);
    procedure Delete(const Index: Integer); overload;
    procedure Delete(const Indexes: TIndexes); overload;
    procedure Clear;
    procedure Reverse;
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string);
    property PointsProps[const Index: Integer]: TPointProps read GetPointProps write SetPointProps; default;
    property PointCount: Integer read GetPointCount;
    property IsSaved: Boolean read FIsSaved;
  end;

  TPlaceList = class(TObject)
  private
    FPlaces: array of TPlace;
    FIsSaved: Boolean;
    function GetCount: Integer;
    function Get(const Index: Integer): TPlace;
  public
    constructor Create;
    procedure Append(PlaceList: TPlaceList);
    procedure Add(Place: TPlace; const Index: Integer = 0);
    procedure Clear;
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string);
    property Places[const Index: Integer]: TPlace read Get; default;
    property Count: Integer read GetCount;
    property IsSaved: Boolean read FIsSaved;
  end;

const
  MinLatitude: Integer = -32400000;
  MaxLatitude: Integer = 32400000;
  MinLongitude: Integer = 0;
  MaxLongitude: Integer = 129599999;
  MinLatitudeDegree: Integer = -90;
  MaxLatitudeDegree: Integer = 90;
  MinLongitudeDegree: Integer = -180;
  MaxLongitudeDegree: Integer = 180;
  DegreesPerEquator: Integer = 360;
  PointsPerOneDegree: Integer = 360000;
  CoordinatesDegreeRoundSigns: Integer = 5;
  DistanceRoundSigns: Integer = 2;
  CostRoundSigns: Integer = 2;

function EncodeLatitude(const Latitude: Integer): Real;
function EncodeLongitude(const Longitude: Integer): Real;
function DecodeLatitude(const LatitudeDegree: Real): Integer;
function DecodeLongitude(const LongitudeDegree: Real): Integer;
function ArcLength(const Latitude1, Longitude1, Latitude2, Longitude2: Integer; const Radius: Integer): Real;
function AltitudeDifference(const Altitude1, Altitude2: TAltitude): Integer;
function SegmentCost(const Distance: Real; const Height: Integer; const DistanceCost, HeightUpCost, HeightDownCost, AngleCost: Real): Real;

implementation

resourcestring
  rsLatitudeDegreeRange = 'Ўирота должна быть в пределах от %d до %d градусов включительно';
  rsLongitudeDegreeRange = 'ƒолгота должна быть в пределах от %d до %d градусов включительно';
  rsBadLatitude = '«начение широты вне разрешенного диапазона';
  rsBadLongitude = '«начение долготы вне разрешенного диапазона';
  rsBadStartCoordinates = 'Ќачальные координаты вне разрешенного диапазона';
  rsBadMapHeight = '¬ысота карты превышает максимально допустимое значение';
  rsBadMapWidth = 'Ўирина карты превышает максимально допустимое значение';
  rsWrongCoordinates = 'Ќеверные координаты';
  rsWrongFileSize = 'Ќеверный размер файла';
  rsWrongFileName = 'Ќеверное им€ файла';
  rsWrongIndex = 'Ќеверный индекс';

function EncodeLatitude(const Latitude: Integer): Real;
var
  LatitudeDegree: Real;
begin
  if (Latitude >= MinLatitude) and (Latitude <= MaxLatitude) then
  begin
    LatitudeDegree := Latitude / PointsPerOneDegree;

    Result := LatitudeDegree;
  end
  else
  begin
    raise Exception.Create(rsBadLatitude);
  end;
end;

function EncodeLongitude(const Longitude: Integer): Real;
var
  LongitudeDegree: Real;
begin
  if (Longitude >= MinLongitude) and (Longitude <= MaxLongitude) then
  begin
    LongitudeDegree := Longitude / PointsPerOneDegree;

    if LongitudeDegree <= MaxLongitudeDegree then
    begin
      Result := LongitudeDegree;
    end
    else
    begin
      Result := LongitudeDegree - DegreesPerEquator;
    end;
  end
  else
  begin
    raise Exception.Create(rsBadLongitude);
  end;
end;

function DecodeLatitude(const LatitudeDegree: Real): Integer;
begin
  if (LatitudeDegree >= MinLatitudeDegree) and (LatitudeDegree <= MaxLatitudeDegree) then
  begin
    Result := Trunc(LatitudeDegree * PointsPerOneDegree);
  end
  else
  begin
    raise Exception.Create(Format(rsLatitudeDegreeRange, [MinLatitudeDegree, MaxLatitudeDegree]));
  end;
end;

function DecodeLongitude(const LongitudeDegree: Real): Integer;
begin
  if (LongitudeDegree >= MinLongitudeDegree) and (LongitudeDegree <= MaxLongitudeDegree) then
  begin
    Result := (Trunc(LongitudeDegree * PointsPerOneDegree) + MaxLongitude + 1) mod (MaxLongitude + 1);
  end
  else
  begin
    raise Exception.Create(Format(rsLongitudeDegreeRange, [MinLongitudeDegree, MaxLongitudeDegree]));
  end;
end;

function ArcLength(const Latitude1, Longitude1, Latitude2, Longitude2: Integer; const Radius: Integer): Real;
var
  lat1, lon1, lat2, lon2: Real;
begin
  if (Latitude1 = Latitude2) and (Longitude1 = Longitude2) then
  begin
    // если точки совпадают, то ничего не делаем, просто возвращаем 0
    Result := 0
  end
  else
  begin
    // вычисл€ем координаты в радианах
    lat1 := Latitude1 / PointsPerOneDegree * Pi / PiDegree;
    if Longitude1 <= (MaxLongitude + 1) / 2 then
      lon1 := Longitude1 / PointsPerOneDegree * Pi / PiDegree
    else
      lon1 := (Longitude1 - MaxLongitude + 1) / PointsPerOneDegree * Pi / PiDegree;

    lat2 := Latitude2 / PointsPerOneDegree * Pi / PiDegree;
    if Longitude2 <= (MaxLongitude + 1) / 2 then
      lon2 := Longitude2 / PointsPerOneDegree * Pi / PiDegree
    else
      lon2 := (Longitude2 - MaxLongitude + 1) / PointsPerOneDegree * Pi / PiDegree;

    // получаем результат
    Result := Radius * ArcCos(Sin(lat1) * Sin(lat2) + Cos(lat1) * Cos(lat2) * Cos(lon1 - lon2));
  end;
end;

function AltitudeDifference(const Altitude1, Altitude2: TAltitude): Integer;
begin
  Result := Altitude2 - Altitude1;
end;

function SegmentCost(const Distance: Real; const Height: Integer; const DistanceCost, HeightUpCost, HeightDownCost, AngleCost: Real): Real;
begin
  if Distance > 0 then
  begin
    if Height = 0 then
    begin
      Result := Distance * DistanceCost;
    end
    else
    begin
      if Height > 0 then
      begin
        Result := Sqrt(Sqr(Distance * DistanceCost) + Sqr(Height * HeightUpCost)) * Exp((Abs(Height) / Distance) * AngleCost);
      end
      else
      begin
        Result := Sqrt(Sqr(Distance * DistanceCost) + Sqr(Height * HeightDownCost)) * Exp((Abs(Height) / Distance) * AngleCost);
      end;
    end;
  end
  else
  begin
    Result := 0;
  end;
end;

constructor TTrack.Create;
begin
  Clear;
end;

procedure TTrack.Add(PointProps: TPointProps; const Index: Integer);
begin
  if Index <= Length(FPointsProps) then
  begin
    SetLength(FPointsProps, Length(FPointsProps) + 1);

    if Index = 0 then
    begin
      FPointsProps[Length(FPointsProps) - 1] := PointProps;
    end
    else
    begin
      Move(FPointsProps[Index - 1], FPointsProps[Index], (Length(FPointsProps) - Index) * SizeOf(TPointProps));
      FPointsProps[Index - 1] := PointProps;
    end;

    FIsSaved := False;
  end
  else
  begin
    raise Exception.Create(rsWrongIndex);
  end;
end;

procedure TTrack.Clear;
begin
  SetLength(FPointsProps, 0);
  FIsSaved := False;
end;

procedure TTrack.Reverse;
var
  PointPropsCounter: Integer;
  PointProps: TPointProps;
begin
  for PointPropsCounter := 0 to Trunc(Length(FPointsProps) / 2) - 1 do
  begin
    PointProps := FPointsProps[PointPropsCounter];
    FPointsProps[PointPropsCounter] := FPointsProps[Length(FPointsProps) - PointPropsCounter - 1];
    FPointsProps[Length(FPointsProps) - PointPropsCounter - 1] := PointProps;
  end;

  FIsSaved := False;
end;

procedure TTrack.SaveToFile(const FileName: string);
var
  TrackFile: file of TPointProps;
  PointPropsCounter: Integer;
begin
  try
    AssignFile(TrackFile, FileName);
    Rewrite(TrackFile);

    for PointPropsCounter := 0 to Length(FPointsProps) - 1 do
    begin
      Write(TrackFile, FPointsProps[PointPropsCounter]);
    end;

    FIsSaved := True;
  finally
    CloseFile(TrackFile);
  end;
end;

procedure TTrack.LoadFromFile(const FileName: string);
var
  TrackFile: file of TPointProps;
  PointProps: TPointProps;
begin
  AssignFile(TrackFile, FileName);
  try
    Reset(TrackFile);

    while not Eof(TrackFile) do
    begin
      Read(TrackFile, PointProps);
      Add(PointProps);
    end;

    FIsSaved := True;
  finally
    CloseFile(TrackFile);
  end;
end;

function TTrack.GetPointProps(const Index: Integer): TPointProps;
begin
  Result := FPointsProps[Index];
end;

{ TReliefMap }

constructor TReliefMap.Create(const StartLatitude, StartLongitude: Integer;
  const LatitudeStep, LongitudeStep: Word; const Radius: Integer);
begin
  if (StartLatitude <= MaxLatitude) and (StartLatitude >= MinLatitude) and (StartLongitude >= MinLongitude) and (StartLongitude <= MaxLongitude + 1) then
  begin
    FStartLatitude := StartLatitude;
    FStartLongitude := StartLongitude;

    FLatitudeStep := LatitudeStep;
    FLongitudeStep := LongitudeStep;

    FRadius := Radius;

    FHeight := 0;
    FWidth := 0;
  end
  else
  begin
    raise Exception.Create(rsBadStartCoordinates);
  end;
end;

function TReliefMap.GetPixel(const LatitudeLine, LongitudeLine: Word): TAltitude;
begin
  Result := FPixels[LatitudeLine, LongitudeLine];
end;

procedure TReliefMap.SetPixel(const LatitudeLine, LongitudeLine: Word;
  const Altitude: TAltitude);
begin
  FPixels[LatitudeLine, LongitudeLine] := Altitude;
end;

procedure TReliefMap.SetHeight(const Height: Word);
begin
  if FStartLatitude - (Height - 1) * FLatitudeStep >= MinLatitude then
  begin
    FHeight := Height;
    SetLength(FPixels, FHeight, FWidth);
  end
  else
  begin
    raise Exception.Create(rsBadMapHeight);
  end;
end;

procedure TReliefMap.SetWidth(const Width: Word);
begin
  if (Width - 1) * FLongitudeStep <= MaxLongitude then
  begin
    FWidth := Width;
    SetLength(FPixels, FHeight, FWidth);
  end
  else
  begin
    raise Exception.Create(rsBadMapWidth);
  end;
end;

function TReliefMap.Altitude(const Latitude,
  Longitude: Integer): TAltitude;
var
  CellTopLatitudeBorder, CellBottomLatitudeBorder: Integer;
  CellLeftLongitudeBorder, CellRightLongitudeBorder: Integer;
  CellTopLatitudeBorderIndex, CellBottomLatitudeBorderIndex: Integer;
  CellLeftLongitudeBorderIndex, CellRightLongitudeBorderIndex: Integer;
  FirstAltitude, SecondAltitude: TAltitude;
  FirstDistance, SecondDistance: Real;
  TopLeftAltitude, TopRightAltitude, BottomLeftAltitude, BottomRightAltitude: TAltitude;
  TopLeftDistance, TopRightDistance, BottomLeftDistance, BottomRightDistance: Real;
begin
  // провер€ем, что заданные координаты принадлежат карте
  if
    ((Latitude <= FStartLatitude) and (Latitude >= FStartLatitude - (FHeight - 1) * FLatitudeStep))
    and
    (
      ((FStartLongitude <= (FStartLongitude + (FWidth - 1) * FLongitudeStep) mod (MaxLongitude + 1)) and (Longitude >= FStartLongitude) and (Longitude <= (FStartLongitude + (FWidth - 1) * FLongitudeStep) mod (MaxLongitude + 1)))
      or
      ((FStartLongitude > (FStartLongitude + (FWidth - 1) * FLongitudeStep) mod (MaxLongitude + 1)) and ( (Longitude >= FStartLongitude) and (Longitude <= MaxLongitude) or (Longitude >= MinLongitude) and (Longitude <= (FStartLongitude + (FWidth - 1) * FLongitudeStep) mod (MaxLongitude + 1))))
    )
  then
  begin
    // если точка €вл€етс€ узлом сетки
    if (Latitude mod FLatitudeStep = 0) and (Longitude mod FLongitudeStep = 0) then
    begin
      // просто возвращаем высоту этого узла
      if Longitude >= FStartLongitude then
      begin
        Result := FPixels[Trunc((FStartLatitude - Latitude) / FLatitudeStep), Trunc((Longitude - FStartLongitude) / FLongitudeStep)];
      end
      else
      begin
        Result := FPixels[Trunc((FStartLatitude - Latitude) / FLatitudeStep), Trunc((MaxLongitude - FStartLongitude + 1) / FLongitudeStep + (Longitude - MinLongitude) / FLongitudeStep)];
      end;
    end
    else
    begin
      // определ€ем границы €чейки сетки, содержащей точку

      CellTopLatitudeBorder := FStartLatitude - Trunc(((FStartLatitude - Latitude) / FLatitudeStep)) * FLatitudeStep;
      if Latitude mod FLatitudeStep = 0 then
        CellBottomLatitudeBorder := CellTopLatitudeBorder
      else
        CellBottomLatitudeBorder := CellTopLatitudeBorder - FLatitudeStep;

      CellLeftLongitudeBorder := FStartLongitude + Trunc(((Longitude - FStartLongitude) / FLongitudeStep)) * FLongitudeStep;
      if Longitude mod FLongitudeStep = 0 then
        CellRightLongitudeBorder := CellLeftLongitudeBorder
      else
        CellRightLongitudeBorder := CellLeftLongitudeBorder + FLongitudeStep;

      // если точка лежит на ребре
      if (Latitude mod FLatitudeStep = 0) or (Longitude mod FLongitudeStep = 0) then
      begin
        // вычисл€ем интерполированное значение высот на точки концах ребра (по 2 вершинам)

        if CellLeftLongitudeBorder >= FStartLongitude then
        begin
          FirstAltitude := FPixels[Trunc((FStartLatitude - CellTopLatitudeBorder) / FLatitudeStep), Trunc((CellLeftLongitudeBorder - FStartLongitude) / FLongitudeStep)];
        end
        else
        begin
          FirstAltitude := FPixels[Trunc((FStartLatitude - CellTopLatitudeBorder) / FLatitudeStep), Trunc((MaxLongitude - FStartLongitude + 1) / FLongitudeStep + (CellLeftLongitudeBorder - MinLongitude) / FLongitudeStep)];
        end;
        if CellRightLongitudeBorder >= FStartLongitude then
        begin
          SecondAltitude := FPixels[Trunc((FStartLatitude - CellBottomLatitudeBorder) / FLatitudeStep), Trunc((CellRightLongitudeBorder - FStartLongitude) / FLongitudeStep)];
        end
        else
        begin
          SecondAltitude := FPixels[Trunc((FStartLatitude - CellBottomLatitudeBorder) / FLatitudeStep), Trunc((MaxLongitude - FStartLongitude + 1) / FLongitudeStep + (CellRightLongitudeBorder - MinLongitude) / FLongitudeStep)];
        end;

        FirstDistance := ArcLength(Latitude, Longitude, CellTopLatitudeBorder, CellLeftLongitudeBorder, FRadius);
        SecondDistance := ArcLength(Latitude, Longitude, CellBottomLatitudeBorder, CellRightLongitudeBorder, FRadius);

        Result
          :=
        Round
        (
          (FirstAltitude * (FirstDistance + SecondDistance) / FirstDistance + SecondAltitude * (FirstDistance + SecondDistance) / SecondDistance)
          /
          ((FirstDistance + SecondDistance) / FirstDistance + (FirstDistance + SecondDistance) / SecondDistance)
        );
      end
      else
      begin
        // вычисл€ем интерполированное значение высот на точки внутри €чейки (по 4 вершинам)

        if CellLeftLongitudeBorder >= FStartLongitude then
        begin
          TopLeftAltitude := FPixels[Trunc((FStartLatitude - CellTopLatitudeBorder) / FLatitudeStep), Trunc((CellLeftLongitudeBorder - FStartLongitude) / FLongitudeStep)];
          BottomLeftAltitude := FPixels[Trunc((FStartLatitude - CellBottomLatitudeBorder) / FLatitudeStep), Trunc((CellLeftLongitudeBorder - FStartLongitude) / FLongitudeStep)];
        end
        else
        begin
          TopLeftAltitude := FPixels[Trunc((FStartLatitude - CellTopLatitudeBorder) / FLatitudeStep), Trunc((MaxLongitude - FStartLongitude + 1) / FLongitudeStep + (CellLeftLongitudeBorder - MinLongitude) / FLongitudeStep)];
          BottomLeftAltitude := FPixels[Trunc((FStartLatitude - CellBottomLatitudeBorder) / FLatitudeStep), Trunc((MaxLongitude - FStartLongitude + 1) / FLongitudeStep + (CellLeftLongitudeBorder - MinLongitude) / FLongitudeStep)];
        end;
        if CellRightLongitudeBorder >= FStartLongitude then
        begin
          TopRightAltitude := FPixels[Trunc((FStartLatitude - CellTopLatitudeBorder) / FLatitudeStep), Trunc((CellRightLongitudeBorder - FStartLongitude) / FLongitudeStep)];
          BottomRightAltitude := FPixels[Trunc((FStartLatitude - CellBottomLatitudeBorder) / FLatitudeStep), Trunc((CellRightLongitudeBorder - FStartLongitude) / FLongitudeStep)];
        end
        else
        begin
          TopRightAltitude := FPixels[Trunc((FStartLatitude - CellTopLatitudeBorder) / FLatitudeStep), Trunc((MaxLongitude - FStartLongitude + 1) / FLongitudeStep + (CellRightLongitudeBorder - MinLongitude) / FLongitudeStep)];
          BottomRightAltitude := FPixels[Trunc((FStartLatitude - CellBottomLatitudeBorder) / FLatitudeStep), Trunc((MaxLongitude - FStartLongitude + 1) / FLongitudeStep + (CellRightLongitudeBorder - MinLongitude) / FLongitudeStep)];
        end;

        TopLeftDistance := ArcLength(Latitude, Longitude, CellTopLatitudeBorder, CellLeftLongitudeBorder, FRadius);
        TopRightDistance := ArcLength(Latitude, Longitude, CellTopLatitudeBorder, CellRightLongitudeBorder, FRadius);
        BottomLeftDistance := ArcLength(Latitude, Longitude, CellBottomLatitudeBorder, CellLeftLongitudeBorder, FRadius);
        BottomRightDistance := ArcLength(Latitude, Longitude, CellBottomLatitudeBorder, CellRightLongitudeBorder, FRadius);

        Result
          :=
        Round
        (
          (TopLeftAltitude * (TopLeftDistance + TopRightDistance + BottomLeftAltitude + BottomRightDistance) / TopLeftDistance + TopRightAltitude * (TopLeftDistance + TopRightDistance + BottomLeftAltitude + BottomRightDistance) / TopRightDistance + BottomLeftAltitude * (TopLeftDistance + TopRightDistance + BottomLeftAltitude + BottomRightDistance) / BottomLeftDistance + BottomRightAltitude * (TopLeftDistance + TopRightDistance + BottomLeftAltitude + BottomRightDistance) / BottomRightDistance)
          /
          ((TopLeftDistance + TopRightDistance + BottomLeftAltitude + BottomRightDistance) / TopLeftDistance + (TopLeftDistance + TopRightDistance + BottomLeftAltitude + BottomRightDistance) / TopRightDistance + (TopLeftDistance + TopRightDistance + BottomLeftAltitude + BottomRightDistance) / BottomLeftDistance + (TopLeftDistance + TopRightDistance + BottomLeftAltitude + BottomRightDistance) / BottomRightDistance)
        );
      end;
    end;
  end
  else
  begin
    raise Exception.Create(rsWrongCoordinates);
  end;
end;

constructor TReliefMap.CreateSRTM(const FileName: string;
  const Radius: Integer);
const
  MinLatitudeDegree: Integer = 0;
  MinLongitudeDegree: Integer = 0;
  MaxLatitudeDegree: Integer = 90;
  MaxLongitudeDegree: Integer = 180;

  North: Char = 'N';
  South: Char = 'S';
  East: Char = 'E';
  West: Char = 'W';

  SRTMFileNameLength: Integer = 7;
  SRTMFileNameLatitudeDegreePos: Integer = 2;
  SRTMFileNameLatitudeDegreeLength: Integer = 2;
  SRTMFileNameLongitudeDegreePos: Integer = 5;
  SRTMFileNameLongitudeDegreeLength: Integer = 3;
  SRTMFileNameLatitudeSignPos: Integer = 1;
  SRTMFileNameLongitudeSignPos: Integer = 4;
  SRTMGridSize: Integer = 1201;
  SRTMGridStep: Integer = 300;
  SRTMUndefinedElevation: Integer = -32768;
var
  SRTMFile: file of Smallint;
  SRTMFileName: string;
  SRTMFileNameIsOK: Boolean;
  SRTMFileSize: Integer;
  SRTMImage: array of array of Smallint;
  SRTMPixel: Smallint;

  LatitudeSign, LongitudeSign: Char;
  StartLatitudeDegree, StartLongitudeDegree: Word;
  StartLatitude, StartLongitude: Integer;
  Elevation: TAltitude;
  Latitude, Longitude: Integer;
  LatitudeCounter, LongitudeCounter: Word;
  LatitudeSubCounter, LongitudeSubCounter: Word;

  ElevationSearchOffset: Word;
  ElevationSearchStartLatitudeCount, ElevationSearchEndLatitudeCount, ElevationSearchStartLongitudeCount, ElevationSearchEndLongitudeCount: Word;
  ElevationSumm: Integer;
  ElevationPointCount: Integer;
begin
  // получаем и провер€ем им€ файла
  SRTMFileName := ChangeFileExt(ExtractFileName(FileName), EmptyStr);
  SRTMFileNameIsOK := True;

  if Length(SRTMFileName) = SRTMFileNameLength then
  begin
    try
      StartLatitudeDegree := StrToInt(Copy(SRTMFileName, SRTMFileNameLatitudeDegreePos, SRTMFileNameLatitudeDegreeLength));
      StartLongitudeDegree := StrToInt(Copy(SRTMFileName, SRTMFileNameLongitudeDegreePos, SRTMFileNameLongitudeDegreeLength));

      LatitudeSign := UpCase(SRTMFileName[SRTMFileNameLatitudeSignPos]);
      LongitudeSign := UpCase(SRTMFileName[SRTMFileNameLongitudeSignPos]);
      if
        ((LatitudeSign = North) and (StartLatitudeDegree >= MinLatitudeDegree) and (StartLatitudeDegree <= MaxLatitudeDegree) or (LatitudeSign = South) and (StartLatitudeDegree >= MinLatitudeDegree) and (StartLatitudeDegree < MaxLatitudeDegree))
        and
        ((LongitudeSign = East) and (StartLongitudeDegree >= MinLongitudeDegree) and (StartLongitudeDegree < MaxLongitudeDegree) or (LongitudeSign = West) and (StartLongitudeDegree >= MinLongitudeDegree) and (StartLongitudeDegree <= MaxLongitudeDegree))
      then
      begin
        if LatitudeSign = North then
        begin
          StartLatitude := (StartLatitudeDegree + 1) * PointsPerOneDegree;
        end
        else
        begin
          StartLatitude := (-StartLatitudeDegree + 1) * PointsPerOneDegree;
        end;

        if LongitudeSign = East then
        begin
          StartLongitude := StartLongitudeDegree * PointsPerOneDegree;
        end
        else
        begin
          StartLongitude := MaxLongitude - StartLongitudeDegree * PointsPerOneDegree + 1;
        end;

        // открываем файл
        AssignFile(SRTMFile, FileName);
        Reset(SRTMFile);

        // получаем размер файла
        SRTMFileSize := FileSize(SRTMFile);

        if SRTMFileSize = Sqr(SRTMGridSize) then
        begin
          try
            // загружаем файл в массив
            SetLength(SRTMImage, SRTMGridSize, SRTMGridSize);
            for LatitudeCounter := 0 to SRTMGridSize - 1 do
            begin
              for LongitudeCounter := 0 to SRTMGridSize - 1 do
              begin
                Read(SRTMFile, SRTMPixel);

                asm
                  mov ax, SRTMPixel
                  ror ax, 8
                  mov SRTMPixel, ax
                end;

                SRTMImage[LatitudeCounter, LongitudeCounter] := SRTMPixel;

                Application.ProcessMessages;
              end;
            end;
          finally
            CloseFile(SRTMFile);
          end;

          // преобразуем полученные данные

          FStartLatitude := StartLatitude;
          FStartLongitude := StartLongitude;
          FLatitudeStep := SRTMGridStep;
          FLongitudeStep := SRTMGridStep;
          FRadius := Radius;

          FWidth := SRTMGridSize;
          FHeight := SRTMGridSize;
          SetLength(FPixels, FHeight, FWidth);

          for LatitudeCounter := 0 to SRTMGridSize - 1 do
          begin
            for LongitudeCounter := 0 to SRTMGridSize - 1 do
            begin
              Elevation := SRTMImage[LatitudeCounter, LongitudeCounter];

              // если высота не определена, пытаемс€ вз€ть усредненное значение по соседним точкам
              if Elevation = SRTMUndefinedElevation then
              begin
                ElevationSearchOffset := 0;
                ElevationSumm := 0;
                ElevationPointCount := 0;
                repeat
                  Inc(ElevationSearchOffset);

                  ElevationSearchStartLatitudeCount := Max(LatitudeCounter - ElevationSearchOffset, 0);
                  ElevationSearchEndLatitudeCount := Min(LatitudeCounter + ElevationSearchOffset, SRTMGridSize - 1);
                  ElevationSearchStartLongitudeCount := Max(LongitudeCounter - ElevationSearchOffset, 0);
                  ElevationSearchEndLongitudeCount := Min(LongitudeCounter + ElevationSearchOffset, SRTMGridSize - 1);

                  for LatitudeSubCounter := ElevationSearchStartLatitudeCount to ElevationSearchEndLatitudeCount do
                  begin
                    for LongitudeSubCounter := ElevationSearchStartLongitudeCount to ElevationSearchEndLongitudeCount do
                    begin
                      if SRTMImage[LatitudeSubCounter, LongitudeSubCounter] <> SRTMUndefinedElevation then
                      begin
                        ElevationSumm := ElevationSumm + SRTMImage[LatitudeSubCounter, LongitudeSubCounter];
                        Inc(ElevationPointCount);
                      end;
                    end;
                  end;
                until (ElevationPointCount > 0) or (ElevationSearchOffset = SRTMGridSize);

                if ElevationPointCount > 0 then
                begin
                  Elevation := Round(ElevationSumm / ElevationPointCount);
                end;
              end;

              FPixels[LatitudeCounter, LongitudeCounter] := Elevation;

              Application.ProcessMessages;
            end;
          end;
        end
        else
        begin
          raise Exception.Create(rsWrongFileSize);
        end;
      end
      else
      begin
        SRTMFileNameIsOK := False;
      end;
    except
      SRTMFileNameIsOK := False;
    end;
  end
  else
  begin
    SRTMFileNameIsOK := False;
  end;

  if not(SRTMFileNameIsOK) then
  begin
    raise Exception.Create(rsWrongFileName);
  end;
end;

function TTrack.GetPointCount: Integer;
begin
  Result := Length(FPointsProps);
end;

{ TPlaceList }

procedure TPlaceList.Add(Place: TPlace; const Index: Integer);
begin
  if (Place.IdentityName <> EmptyStr) and (Index <= Length(FPlaces)) then
  begin
    SetLength(FPlaces, Length(FPlaces) + 1);

    if Index = 0 then
    begin
      FPlaces[Length(FPlaces) - 1] := Place;

      if FPlaces[Length(FPlaces) - 1].VisibleName = EmptyStr then FPlaces[Length(FPlaces) - 1].VisibleName := FPlaces[Length(FPlaces) - 1].IdentityName;
    end
    else
    begin
      Move(FPlaces[Index - 1], FPlaces[Index], (Length(FPlaces) - Index) * SizeOf(TPlace));
      FPlaces[Index - 1] := Place;

      if FPlaces[Index - 1].VisibleName = EmptyStr then FPlaces[Index - 1].VisibleName := FPlaces[Index - 1].IdentityName;
    end;

    FIsSaved := False;
  end
  else
  begin
    raise Exception.Create(rsWrongIndex);
  end;
end;

procedure TPlaceList.Append(PlaceList: TPlaceList);
begin
  if Length(PlaceList.FPlaces) > 0 then
  begin
    SetLength(FPlaces, Length(FPlaces) + Length(PlaceList.FPlaces));
    Move(PlaceList.FPlaces[0], FPlaces[Length(FPlaces) - Length(PlaceList.FPlaces)], Length(PlaceList.FPlaces) * SizeOf(TPlace));

    FIsSaved := False;
  end;
end;

procedure TPlaceList.Clear;
begin
  SetLength(FPlaces, 0);
  FIsSaved := False;
end;

constructor TPlaceList.Create;
begin
  Clear;
end;

function TPlaceList.Get(const Index: Integer): TPlace;
begin
  Result := FPlaces[Index];
end;

function TPlaceList.GetCount: Integer;
begin
  Result := Length(FPlaces);
end;

procedure TPlaceList.LoadFromFile(const FileName: string);
var
  PlaceListFile: file of TPlace;
  Place: TPlace;
begin
  AssignFile(PlaceListFile, FileName);
  try
    Reset(PlaceListFile);

    while not Eof(PlaceListFile) do
    begin
      Read(PlaceListFile, Place);
      Add(Place);
    end;

    FIsSaved := True;
  finally
    CloseFile(PlaceListFile);
  end;
end;

procedure TPlaceList.SaveToFile(const FileName: string);
var
  PlaceListFile: file of TPlace;
  PlaceCounter: Integer;
begin
  try
    AssignFile(PlaceListFile, FileName);
    Rewrite(PlaceListFile);

    for PlaceCounter := 0 to Length(FPlaces) - 1 do
    begin
      Write(PlaceListFile, FPlaces[PlaceCounter]);
    end;
    
    FIsSaved := True;
  finally
    CloseFile(PlaceListFile);
  end;
end;

procedure TTrack.SetPointProps(const Index: Integer;
  PointProps: TPointProps);
begin
  FPointsProps[Index] := PointProps;
end;

procedure TTrack.Delete(const Index: Integer);
begin
  if Index < Length(FPointsProps) then
  begin
    Move(FPointsProps[Index + 1], FPointsProps[Index], (Length(FPointsProps) - Index) * SizeOf(TPointProps));
    SetLength(FPointsProps, Length(FPointsProps) - 1);

    FIsSaved := False;
  end
  else
  begin
    raise Exception.Create(rsWrongIndex);
  end;
end;

procedure TTrack.Delete(const Indexes: TIndexes);
var
  PointPropsCounter, IndexCounter: Integer;
  SavedPointsProps: TPointsProps;
  Deleted: Boolean;
begin
  if Length(Indexes) > 0 then
  begin
    SetLength(SavedPointsProps, 0);

    for PointPropsCounter := 0 to Length(FPointsProps) - 1 do
    begin
      Deleted := False;

      for IndexCounter := 0 to Length(Indexes) - 1 do
      begin
        Deleted := Indexes[IndexCounter] = PointPropsCounter;
        if Deleted then Break;
      end;

      if not Deleted then
      begin
        SetLength(SavedPointsProps, Length(SavedPointsProps) + 1);
        SavedPointsProps[Length(SavedPointsProps) - 1] := FPointsProps[PointPropsCounter];
      end;
    end;

    SetLength(FPointsProps, Length(SavedPointsProps));
    FPointsProps := SavedPointsProps;

    FIsSaved := False;
  end;
end;

procedure TTrack.Append(Track: TTrack);
begin
  if Length(Track.FPointsProps) > 0 then
  begin
    SetLength(FPointsProps, Length(FPointsProps) + Length(Track.FPointsProps));
    Move(Track.FPointsProps[0], FPointsProps[Length(FPointsProps) - Length(Track.FPointsProps)], Length(Track.FPointsProps) * SizeOf(TPointProps));

    FIsSaved := False;
  end;
end;

end.
