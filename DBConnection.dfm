object LandscapeDB: TLandscapeDB
  OldCreateOrder = False
  Left = 482
  Top = 212
  Height = 398
  Width = 476
  object Connection: TADOConnection
    CommandTimeout = 60
    ConnectionTimeout = 10
    LoginPrompt = False
    Left = 16
    Top = 16
  end
  object InsertPointStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.insert_point'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Direction = pdOutput
        Value = Null
      end
      item
        Name = '@latitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@longitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@altitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@measured'
        DataType = ftDateTime
        Value = Null
      end>
    Left = 16
    Top = 72
  end
  object CreateTrackStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.create_track'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Direction = pdOutput
        Value = Null
      end
      item
        Name = '@category_id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@visible_name'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    Left = 16
    Top = 128
  end
  object AddTrackPointStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.add_track_point'
    Parameters = <
      item
        Name = '@track_id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@point_num'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@latitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@longitude'
        DataType = ftInteger
        Value = Null
      end>
    Left = 144
    Top = 128
  end
  object EditTrackStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.edit_track'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@category_id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@visible_name'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    Left = 48
    Top = 128
  end
  object DeleteTrackStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.delete_track'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Value = Null
      end>
    Left = 80
    Top = 128
  end
  object CreatePlaceStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.create_place'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Direction = pdOutput
        Value = Null
      end
      item
        Name = '@category_id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@latitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@longitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@identity_name'
        DataType = ftString
        Size = -1
        Value = Null
      end
      item
        Name = '@visible_name'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    Left = 16
    Top = 176
  end
  object EditPlaceStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.edit_place'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@category_id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@latitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@longitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@identity_name'
        DataType = ftString
        Size = -1
        Value = Null
      end
      item
        Name = '@visible_name'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    Left = 48
    Top = 176
  end
  object DeletePlaceStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.delete_place'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Value = Null
      end>
    Left = 80
    Top = 176
  end
  object CreatePlacePictureStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.create_place_picture'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Direction = pdOutput
        Value = Null
      end
      item
        Name = '@place_id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@visible_name'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    Left = 144
    Top = 176
  end
  object EditPlacePictureStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.edit_place_picture'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@visible_name'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    Left = 176
    Top = 176
  end
  object DeletePlacePictureStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.delete_place_picture'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Value = Null
      end>
    Left = 208
    Top = 176
  end
  object InsertPlaceStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.insert_place'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Direction = pdOutput
        Value = Null
      end
      item
        Name = '@category_id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@latitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@longitude'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@identity_name'
        DataType = ftString
        Size = -1
        Value = Null
      end
      item
        Name = '@visible_name'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    Left = 272
    Top = 176
  end
  object CreateCategoryStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.create_category'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Direction = pdOutput
        Value = Null
      end
      item
        Name = '@visible_name'
        DataType = ftString
        Size = -1
        Value = Null
      end
      item
        Name = '@obsolete'
        DataType = ftBoolean
        Value = Null
      end>
    Left = 16
    Top = 224
  end
  object EditCategoryStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.edit_category'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@visible_name'
        DataType = ftString
        Size = -1
        Value = Null
      end
      item
        Name = '@obsolete'
        DataType = ftBoolean
        Value = Null
      end>
    Left = 48
    Top = 224
  end
  object DeleteCategoryStoredProcedure: TADOStoredProc
    Connection = Connection
    CommandTimeout = 60
    ProcedureName = 'dbo.delete_category'
    Parameters = <
      item
        Name = '@id'
        DataType = ftFloat
        Value = Null
      end>
    Left = 80
    Top = 224
  end
end
