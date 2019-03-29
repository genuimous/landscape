unit DBConnection;

interface

uses
  SysUtils, Classes, DB, ADODB, Forms, Geoid, Variants, Utils;

type
  TLandscapeDB = class(TDataModule)
    Connection: TADOConnection;
    InsertPointStoredProcedure: TADOStoredProc;
    CreateTrackStoredProcedure: TADOStoredProc;
    AddTrackPointStoredProcedure: TADOStoredProc;
    EditTrackStoredProcedure: TADOStoredProc;
    DeleteTrackStoredProcedure: TADOStoredProc;
    CreatePlaceStoredProcedure: TADOStoredProc;
    EditPlaceStoredProcedure: TADOStoredProc;
    DeletePlaceStoredProcedure: TADOStoredProc;
    CreatePlacePictureStoredProcedure: TADOStoredProc;
    EditPlacePictureStoredProcedure: TADOStoredProc;
    DeletePlacePictureStoredProcedure: TADOStoredProc;
    InsertPlaceStoredProcedure: TADOStoredProc;
    CreateCategoryStoredProcedure: TADOStoredProc;
    EditCategoryStoredProcedure: TADOStoredProc;
    DeleteCategoryStoredProcedure: TADOStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateConnection(const ConnectionString: string;
      const Connected: Boolean = True);
    procedure Connect;
    procedure Disconnect;
    function BeginTransaction: Integer;
    procedure Commit;
    procedure Rollback;
    function OpenQuery(const SQLString: string;
      const Timeout: Integer = 60): TADOQuery;
    procedure ExecQuery(const SQLString: string; const Timeout: Integer = 10);
    function InsertPoint(const Latitude, Longitude: Integer;
      const Altitude: TAltitude; const Measured: TDateTime): TRecordID;
    function NearPoint(const Latitude, Longitude: Integer): TRecordID;
    function PointAltitude(const PointID: TRecordID): TAltitude;
    function CreateCategory(const VisibleName: string;
      const Obsolete: Boolean): TRecordID;
    procedure EditCategory(const ID: TRecordID; const VisibleName: string;
      const Obsolete: Boolean);
    procedure DeleteCategory(const ID: TRecordID);
    function CreateTrack(const CategoryID: TRecordID;
      const VisibleName: string): TRecordID;
    procedure EditTrack(const ID: TRecordID; const CategoryID: TRecordID;
      const VisibleName: string);
    procedure DeleteTrack(const ID: TRecordID);
    function CreatePlace(const CategoryID: TRecordID;
      const Latitude, Longitude: Integer;
      const IdentityName, VisibleName: string): TRecordID;
    procedure EditPlace(const ID: TRecordID; const CategoryID: TRecordID;
      const Latitude, Longitude: Integer;
      const IdentityName, VisibleName: string);
    procedure DeletePlace(const ID: TRecordID);
    procedure AddTrackPoint(const TrackID: TRecordID;
      const PointNum: Smallint; const Latitude, Longitude: Integer);
    function CreatePlacePicture(const PlaceID: TRecordID;
      const VisibleName: string): TRecordID;
    procedure EditPlacePicture(const ID: TRecordID; const VisibleName: string);
    procedure DeletePlacePicture(const ID: TRecordID);
    function InsertPlace(const CategoryID: TRecordID;
      const Latitude, Longitude: Integer;
      const IdentityName, VisibleName: string): TRecordID;
  end;

var
  LandscapeDB: TLandscapeDB;

implementation

{$R *.dfm}

{ TLandscapeDB }

function TLandscapeDB.BeginTransaction: Integer;
begin
  Result := Connection.BeginTrans;
end;

procedure TLandscapeDB.Commit;
begin
  Connection.CommitTrans;
end;

procedure TLandscapeDB.Connect;
begin
  Connection.Connected := True;
end;

constructor TLandscapeDB.CreateConnection(const ConnectionString: string;
  const Connected: Boolean);
begin
  inherited Create(Application);

  Connection.ConnectionString := ConnectionString;
  Connection.Connected := Connected;
end;

function TLandscapeDB.OpenQuery(const SQLString: string;
  const Timeout: Integer): TADOQuery;
begin
  Result := TADOQuery.Create(Application);

  with Result do
  begin
    try
      Connection := Self.Connection;
      CommandTimeout := Timeout;
      SQL.Text := SQLString;
      Open;
    except
      Free;
      raise;
    end;
  end;
end;

procedure TLandscapeDB.Disconnect;
begin
  Connection.Connected := False;
end;

procedure TLandscapeDB.ExecQuery(const SQLString: string;
  const Timeout: Integer);
begin
  with TADOQuery.Create(Application) do
  begin
    try
      Connection := Self.Connection;
      CommandTimeout := Timeout;
      SQL.Text := SQLString;
      ExecSQL;
    finally
      Free;
    end;
  end;
end;

procedure TLandscapeDB.Rollback;
begin
  Connection.RollbackTrans;
end;

function TLandscapeDB.InsertPoint(const Latitude, Longitude: Integer;
  const Altitude: TAltitude; const Measured: TDateTime): TRecordID;
begin
  with InsertPointStoredProcedure do
  begin
    Parameters.ParamValues['@latitude'] := Latitude;
    Parameters.ParamValues['@longitude'] := Longitude;
    Parameters.ParamValues['@altitude'] := Altitude;
    Parameters.ParamValues['@measured'] := Measured;

    ExecProc;

    if not VarIsNull(Parameters.ParamValues['@id']) then
    begin
      Result := Parameters.ParamValues['@id'];
    end
    else
    begin
      Result := 0;
    end;
  end;
end;

function TLandscapeDB.NearPoint(const Latitude,
  Longitude: Integer): TRecordID;
begin
  with OpenQuery(Format('select dbo.near_point(%d, %d) point_id', [Latitude, Longitude])) do
  begin
    try
      if not VarIsNull(FieldValues['point_id']) then
      begin
        Result := FieldValues['point_id'];
      end
      else
      begin
        Result := 0;
      end;
    finally
      Free;
    end;
  end;
end;

function TLandscapeDB.PointAltitude(const PointID: TRecordID): TAltitude;
begin
  with OpenQuery(Format('select dbo.point_altitude(%.0f) altitude', [PointID])) do
  begin
    try
      if not VarIsNull(FieldValues['altitude']) then
      begin
        Result := FieldValues['altitude'];
      end
      else
      begin
        Result := 0;
      end;
    finally
      Free;
    end;
  end;
end;

function TLandscapeDB.CreateTrack(const CategoryID: TRecordID;
  const VisibleName: string): TRecordID;
begin
  with CreateTrackStoredProcedure do
  begin
    Parameters.ParamValues['@category_id'] := CategoryID;
    Parameters.ParamValues['@visible_name'] := VisibleName;

    ExecProc;

    if not VarIsNull(Parameters.ParamValues['@id']) then
    begin
      Result := Parameters.ParamValues['@id'];
    end
    else
    begin
      Result := 0;
    end;
  end;
end;

procedure TLandscapeDB.DeleteTrack(const ID: TRecordID);
begin
  with DeleteTrackStoredProcedure do
  begin
    Parameters.ParamValues['@id'] := ID;

    ExecProc;
  end;
end;

procedure TLandscapeDB.EditTrack(const ID: TRecordID;
  const CategoryID: TRecordID; const VisibleName: string);
begin
  with EditTrackStoredProcedure do
  begin
    Parameters.ParamValues['@id'] := ID;
    Parameters.ParamValues['@category_id'] := CategoryID;
    Parameters.ParamValues['@visible_name'] := VisibleName;

    ExecProc;
  end;
end;

procedure TLandscapeDB.AddTrackPoint(const TrackID: TRecordID;
  const PointNum: Smallint; const Latitude, Longitude: Integer);
begin
  with AddTrackPointStoredProcedure do
  begin
    Parameters.ParamValues['@track_id'] := TrackID;
    Parameters.ParamValues['@point_num'] := PointNum;
    Parameters.ParamValues['@latitude'] := Latitude;
    Parameters.ParamValues['@longitude'] := Longitude;

    ExecProc;
  end;
end;

function TLandscapeDB.CreatePlace(const CategoryID: TRecordID;
  const Latitude, Longitude: Integer;
  const IdentityName, VisibleName: string): TRecordID;
begin
  with CreatePlaceStoredProcedure do
  begin
    Parameters.ParamValues['@category_id'] := CategoryID;
    Parameters.ParamValues['@latitude'] := Latitude;
    Parameters.ParamValues['@longitude'] := Longitude;
    Parameters.ParamValues['@identity_name'] := IdentityName;
    Parameters.ParamValues['@visible_name'] := VisibleName;

    ExecProc;

    if not VarIsNull(Parameters.ParamValues['@id']) then
    begin
      Result := Parameters.ParamValues['@id'];
    end
    else
    begin
      Result := 0;
    end;
  end;
end;

procedure TLandscapeDB.DeletePlace(const ID: TRecordID);
begin
  with DeletePlaceStoredProcedure do
  begin
    Parameters.ParamValues['@id'] := ID;

    ExecProc;
  end;
end;

procedure TLandscapeDB.EditPlace(const ID, CategoryID: TRecordID;
  const Latitude, Longitude: Integer; const IdentityName, VisibleName: string);
begin
  with EditPlaceStoredProcedure do
  begin
    Parameters.ParamValues['@id'] := ID;
    Parameters.ParamValues['@category_id'] := CategoryID;
    Parameters.ParamValues['@latitude'] := Latitude;
    Parameters.ParamValues['@longitude'] := Longitude;
    Parameters.ParamValues['@identity_name'] := IdentityName;
    Parameters.ParamValues['@visible_name'] := VisibleName;

    ExecProc;
  end;
end;

function TLandscapeDB.CreatePlacePicture(const PlaceID: TRecordID;
  const VisibleName: string): TRecordID;
begin
  with CreatePlacePictureStoredProcedure do
  begin
    Parameters.ParamValues['@place_id'] := PlaceID;
    Parameters.ParamValues['@visible_name'] := VisibleName;

    ExecProc;

    if not VarIsNull(Parameters.ParamValues['@id']) then
    begin
      Result := Parameters.ParamValues['@id'];
    end
    else
    begin
      Result := 0;
    end;
  end;
end;

procedure TLandscapeDB.DeletePlacePicture(const ID: TRecordID);
begin
  with DeletePlacePictureStoredProcedure do
  begin
    Parameters.ParamValues['@id'] := ID;

    ExecProc;
  end;
end;

procedure TLandscapeDB.EditPlacePicture(const ID: TRecordID;
  const VisibleName: string);
begin
  with EditPlacePictureStoredProcedure do
  begin
    Parameters.ParamValues['@id'] := ID;
    Parameters.ParamValues['@visible_name'] := VisibleName;

    ExecProc;
  end;
end;

function TLandscapeDB.InsertPlace(const CategoryID: TRecordID;
  const Latitude, Longitude: Integer; const IdentityName,
  VisibleName: string): TRecordID;
begin
  with InsertPlaceStoredProcedure do
  begin
    Parameters.ParamValues['@category_id'] := CategoryID;
    Parameters.ParamValues['@latitude'] := Latitude;
    Parameters.ParamValues['@longitude'] := Longitude;
    Parameters.ParamValues['@identity_name'] := IdentityName;
    Parameters.ParamValues['@visible_name'] := VisibleName;

    ExecProc;

    if not VarIsNull(Parameters.ParamValues['@id']) then
    begin
      Result := Parameters.ParamValues['@id'];
    end
    else
    begin
      Result := 0;
    end;
  end;
end;

function TLandscapeDB.CreateCategory(const VisibleName: string;
  const Obsolete: Boolean): TRecordID;
begin
  with CreateCategoryStoredProcedure do
  begin
    Parameters.ParamValues['@visible_name'] := VisibleName;
    Parameters.ParamValues['@obsolete'] := Obsolete;

    ExecProc;

    if not VarIsNull(Parameters.ParamValues['@id']) then
    begin
      Result := Parameters.ParamValues['@id'];
    end
    else
    begin
      Result := 0;
    end;
  end;
end;

procedure TLandscapeDB.DeleteCategory(const ID: TRecordID);
begin
  with DeleteCategoryStoredProcedure do
  begin
    Parameters.ParamValues['@id'] := ID;

    ExecProc;
  end;
end;

procedure TLandscapeDB.EditCategory(const ID: TRecordID;
  const VisibleName: string; const Obsolete: Boolean);
begin
  with EditCategoryStoredProcedure do
  begin
    Parameters.ParamValues['@id'] := ID;
    Parameters.ParamValues['@visible_name'] := VisibleName;
    Parameters.ParamValues['@obsolete'] := Obsolete;

    ExecProc;
  end;
end;

end.
