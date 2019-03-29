unit OziExportImport;

interface

uses
  SysUtils, Classes, Utils, Geoid, DBConnection;

const
  OziTrackExt: string = 'plt';
  OziPlaceListExt: string = 'wpt';

procedure OziTrackImport(Track: TTrack; const FileName: string);
procedure OziTrackExport(Track: TTrack; const FileName: string);

procedure OziPlaceListImport(PlaceList: TPlaceList; const FileName: string);
procedure OziPlaceListExport(PlaceList: TPlaceList; const FileName: string);

implementation

const
  OziDecimalSeparator: Char = '.';
  OziDataDelimiter: Char = ',';
  OziCoordinatesFormat: string = '0.000000';
  OziAltitudeFormat: string = '0';

  OziTrackHeaderLineCount: Integer = 6;
  OziTrackFileType: string = 'OziExplorer Track Point File Version 2.1';
  OziTrackDatum: string = 'WGS 84';
  OziTrackAltitudeIsInFeet: string = 'Altitude is in Feet';
  OziTrackReserved: string = 'Reserved';
  OziTrackWidth: Integer = 2;
  OziTrackColor: Integer = 255;
  OziTrackDescription: string = 'Created by Landscape software';
  OziTrackSkipValue: Integer = 0;
  OziTrackType: Integer = 0;
  OziTrackFillStyle: Integer = 2;
  OziTrackFillColor: Integer = 8421376;
  OziTrackPointLatitudeDegreeIndex: Integer = 0;
  OziTrackPointLongitudeDegreeIndex: Integer = 1;
  OziTrackPointType: Integer = 0;

  OziPlaceListHeaderLineCount: Integer = 4;
  OziPlaceListFileType: string = 'OziExplorer Waypoint File Version 1.1';
  OziPlaceListDatum: string = 'WGS 84';
  OziPlaceListReserved: string = 'Reserved';
  OziPlaceListGPSSymbolSet: string = 'garmin';
  OziPlaceIdentityNameIndex: Integer = 1;
  OziPlaceLatitudeDegreeIndex: Integer = 2;
  OziPlaceLongitudeDegreeIndex: Integer = 3;
  OziPlaceVisibleNameIndex: Integer = 10;
  OziPlaceSymbol: Integer = 70;
  OziPlaceStatus: Integer = 1;
  OziPlaceMapFormat: Integer = 4;
  OziPlaceForegroundColor: Integer = 0;
  OziPlaceBackgroundColor: Integer = 65535;
  OziPlacePointerDirection: Integer = 0;
  OziPlaceGarminDisplayFormat: Integer = 0;
  OziPlaceProximityDistance: Integer = 0;
  OziPlaceFontSize: Integer = 6;
  OziPlaceFontStyle: Integer = 0;
  OziPlaceSymbolSize: Integer = 17;

resourcestring
  rsNoDataFound = 'Ќет данных о координатах (%s; %s)!';

procedure OziTrackImport(Track: TTrack; const FileName: string);
var
  FormatSettings: TFormatSettings;
  OziTrackLines: TStringList;
  OziTrackPointData: TStrings;
  LineCounter: Integer;
  Latitude, Longitude: Integer;
  SurfacePointID: TRecordID;
  LatitudeDegree, LongitudeDegree: Real;
  PointProps: TPointProps;
begin
  FormatSettings.DecimalSeparator := OziDecimalSeparator;

  try
    OziTrackLines := TStringList.Create;
    OziTrackLines.LoadFromFile(FileName);

    // читаем содержимое трека
    for LineCounter := OziTrackHeaderLineCount to OziTrackLines.Count - 1 do
    begin
      if OziTrackLines[LineCounter] <> EmptyStr then
      begin
        SetLength(OziTrackPointData, 0);
        OziTrackPointData := DisAssembleStr(OziTrackLines[LineCounter], OziDataDelimiter);

        LatitudeDegree := StrToFloat(OziTrackPointData[OziTrackPointLatitudeDegreeIndex], FormatSettings);
        LongitudeDegree := StrToFloat(OziTrackPointData[OziTrackPointLongitudeDegreeIndex], FormatSettings);

        Latitude := Trunc(LatitudeDegree * PointsPerOneDegree);
        Longitude := Trunc(LongitudeDegree * PointsPerOneDegree);
        if Longitude < 0 then
        begin
          Longitude := Longitude + MaxLongitude +  1;
        end;

        SurfacePointID := LandscapeDB.NearPoint(Latitude, Longitude);

        if SurfacePointID <> 0 then
        begin
          PointProps.Latitude := Latitude;
          PointProps.Longitude := Longitude;
          PointProps.Altitude := LandscapeDB.PointAltitude(SurfacePointID);

          Track.Add(PointProps);
        end
        else
        begin
          raise Exception.Create(Format(rsNoDataFound, [Trim(OziTrackPointData[OziTrackPointLatitudeDegreeIndex]), Trim(OziTrackPointData[OziTrackPointLongitudeDegreeIndex])]));
        end;
      end;
    end;
  finally
    FreeAndNil(OziTrackLines);
  end;
end;

procedure OziTrackExport(Track: TTrack; const FileName: string);
var
  FormatSettings: TFormatSettings;
  OziTrackLines: TStringList;
  TrackPointCounter: Integer;
  Latitude, Longitude: Real;
  Altitude: TAltitude;
begin
  FormatSettings.DecimalSeparator := '.';

  try
    OziTrackLines := TStringList.Create;

    // заголовок
    OziTrackLines.Add(OziTrackFileType);
    OziTrackLines.Add(OziTrackDatum);
    OziTrackLines.Add(OziTrackAltitudeIsInFeet);
    OziTrackLines.Add(OziTrackReserved);
    OziTrackLines.Add
    (
      IntToStr(0) + OziDataDelimiter +
      IntToStr(OziTrackWidth) + OziDataDelimiter +
      IntToStr(OziTrackColor) + OziDataDelimiter +
      OziTrackDescription + OziDataDelimiter +
      IntToStr(OziTrackSkipValue) + OziDataDelimiter +
      IntToStr(OziTrackType) + OziDataDelimiter +
      IntToStr(OziTrackFillStyle) + OziDataDelimiter +
      IntToStr(OziTrackFillColor)
    );
    OziTrackLines.Add(IntToStr(Track.PointCount));

    // содержимое
    for TrackPointCounter := 0 to Track.PointCount - 1 do
    begin
      Latitude := Track[TrackPointCounter].Latitude / PointsPerOneDegree;
      Longitude := Track[TrackPointCounter].Longitude / PointsPerOneDegree;
      if Longitude >= MaxLongitudeDegree then
      begin
        Longitude := Longitude - DegreesPerEquator;
      end;
      Altitude := Track[TrackPointCounter].Altitude;

      OziTrackLines.Add
      (
        FormatFloat(OziCoordinatesFormat, Latitude, FormatSettings) + OziDataDelimiter +
        FormatFloat(OziCoordinatesFormat, Longitude, FormatSettings) + OziDataDelimiter +
        IntToStr(OziTrackPointType) + OziDataDelimiter +
        FormatFloat(OziAltitudeFormat, Altitude * FeetPerMetre, FormatSettings) + OziDataDelimiter +
        OziDataDelimiter +
        OziDataDelimiter
      );
    end;

    OziTrackLines.SaveToFile(FileName);
  finally
    FreeAndNil(OziTrackLines);
  end;
end;

procedure OziPlaceListImport(PlaceList: TPlaceList; const FileName: string);
var
  FormatSettings: TFormatSettings;
  OziPlaceListLines: TStringList;
  OziPlaceData: TStrings;
  LineCounter: Integer;
  IdentityName: string;
  VisibleName: string;
  Latitude, Longitude: Integer;
  SurfacePointID: TRecordID;
  LatitudeDegree, LongitudeDegree: Real;
  Place: TPlace;
begin
  FormatSettings.DecimalSeparator := OziDecimalSeparator;

  try
    OziPlaceListLines := TStringList.Create;
    OziPlaceListLines.LoadFromFile(FileName);

    // читаем содержимое списка объектов
    for LineCounter := OziPlaceListHeaderLineCount to OziPlaceListLines.Count - 1 do
    begin
      if OziPlaceListLines[LineCounter] <> EmptyStr then
      begin
        SetLength(OziPlaceData, 0);
        OziPlaceData := DisAssembleStr(OziPlaceListLines[LineCounter], OziDataDelimiter);

        IdentityName := OziPlaceData[OziPlaceIdentityNameIndex];
        VisibleName := OziPlaceData[OziPlaceVisibleNameIndex];
        LatitudeDegree := StrToFloat(OziPlaceData[OziPlaceLatitudeDegreeIndex], FormatSettings);
        LongitudeDegree := StrToFloat(OziPlaceData[OziPlaceLongitudeDegreeIndex], FormatSettings);

        Latitude := Trunc(LatitudeDegree * PointsPerOneDegree);
        Longitude := Trunc(LongitudeDegree * PointsPerOneDegree);
        if Longitude < 0 then
        begin
          Longitude := Longitude + MaxLongitude +  1;
        end;

        SurfacePointID := LandscapeDB.NearPoint(Latitude, Longitude);

        if SurfacePointID <> 0 then
        begin
          Place.IdentityName := IdentityName;
          Place.VisibleName := VisibleName;
          Place.PointProps.Latitude := Latitude;
          Place.PointProps.Longitude := Longitude;
          Place.PointProps.Altitude := LandscapeDB.PointAltitude(SurfacePointID);

          PlaceList.Add(Place);
        end
        else
        begin
          raise Exception.Create(Format(rsNoDataFound, [Trim(OziPlaceData[OziPlaceLatitudeDegreeIndex]), Trim(OziPlaceData[OziPlaceLongitudeDegreeIndex])]));
        end;
      end;
    end;
  finally
    FreeAndNil(OziPlaceListLines);
  end;
end;

procedure OziPlaceListExport(PlaceList: TPlaceList; const FileName: string);
var
  FormatSettings: TFormatSettings;
  OziPlaceListLines: TStringList;
  PlaceCounter: Integer;
  Latitude, Longitude: Real;
  Altitude: TAltitude;
  IdentityName: string;
  VisibleName: string;
begin
  FormatSettings.DecimalSeparator := '.';

  try
    OziPlaceListLines := TStringList.Create;

    // заголовок
    OziPlaceListLines.Add(OziPlaceListFileType);
    OziPlaceListLines.Add(OziPlaceListDatum);
    OziPlaceListLines.Add(OziPlaceListReserved);
    OziPlaceListLines.Add(OziPlaceListGPSSymbolSet);

    // содержимое
    for PlaceCounter := 0 to PlaceList.Count - 1 do
    begin
      Latitude := PlaceList[PlaceCounter].PointProps.Latitude / PointsPerOneDegree;
      Longitude := PlaceList[PlaceCounter].PointProps.Longitude / PointsPerOneDegree;
      if Longitude >= MaxLongitudeDegree then
      begin
        Longitude := Longitude - DegreesPerEquator;
      end;
      Altitude := PlaceList[PlaceCounter].PointProps.Altitude;
      IdentityName := PlaceList[PlaceCounter].IdentityName;
      VisibleName := PlaceList[PlaceCounter].VisibleName;

      OziPlaceListLines.Add
      (
        IntToStr(PlaceCounter + 1) + OziDataDelimiter +
        IdentityName + OziDataDelimiter +
        FormatFloat(OziCoordinatesFormat, Latitude, FormatSettings) + OziDataDelimiter +
        FormatFloat(OziCoordinatesFormat, Longitude, FormatSettings) + OziDataDelimiter +
        OziDataDelimiter + IntToStr(OziPlaceSymbol) + OziDataDelimiter +
        IntToStr(OziPlaceStatus) + OziDataDelimiter +
        IntToStr(OziPlaceMapFormat) + OziDataDelimiter +
        IntToStr(OziPlaceForegroundColor) + OziDataDelimiter +
        IntToStr(OziPlaceBackgroundColor) + OziDataDelimiter +
        VisibleName + OziDataDelimiter +
        IntToStr(OziPlacePointerDirection) + OziDataDelimiter +
        IntToStr(OziPlaceGarminDisplayFormat) + OziDataDelimiter +
        IntToStr(OziPlaceProximityDistance) + OziDataDelimiter +
        FormatFloat(OziAltitudeFormat, Altitude * FeetPerMetre, FormatSettings) + OziDataDelimiter +
        IntToStr(OziPlaceFontSize) + OziDataDelimiter +
        IntToStr(OziPlaceFontStyle) + OziDataDelimiter +
        IntToStr(OziPlaceSymbolSize) + OziDataDelimiter +
        OziDataDelimiter +
        OziDataDelimiter +
        OziDataDelimiter +
        OziDataDelimiter +
        OziDataDelimiter
      );
    end;

    OziPlaceListLines.SaveToFile(FileName);
  finally
    FreeAndNil(OziPlaceListLines);
  end;
end;

end.
