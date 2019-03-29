object PlacePicturesForm: TPlacePicturesForm
  Left = 528
  Top = 315
  Width = 500
  Height = 300
  Caption = 'PlacePicturesForm'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PlacePicturesGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 492
    Height = 232
    Align = alClient
    PopupMenu = PlacePicturesPopupMenu
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    object PlacePicturesView: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = PlacePicturesDataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
      object PlacePicturesViewVisibleNameColumn: TcxGridDBColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'visible_name'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 300
      end
      object PlacePicturesViewCreatedColumn: TcxGridDBColumn
        Caption = #1057#1086#1079#1076#1072#1085#1086
        DataBinding.FieldName = 'created'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 120
      end
    end
    object PlacePicturesLevel: TcxGridLevel
      GridView = PlacePicturesView
    end
  end
  object ActionPanel: TPanel
    Left = 0
    Top = 232
    Width = 492
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      492
      41)
    object CloseButton: TButton
      Left = 410
      Top = 8
      Width = 74
      Height = 25
      Anchors = [akRight]
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object FormPlacement: TFormPlacement
    Left = 80
    Top = 48
  end
  object PlacePicturesPopupMenu: TPopupMenu
    Left = 88
    Top = 152
    object ShowPlacePictureMI: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088
      OnClick = ShowPlacePictureMIClick
    end
    object PlacePictureActionsSeparatorMI: TMenuItem
      Caption = '-'
    end
    object CreatePlacePictureMI: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100'...'
      OnClick = CreatePlacePictureMIClick
    end
    object EditPlacePictureMI: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
      OnClick = EditPlacePictureMIClick
    end
    object DeletePlacePictureMI: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = DeletePlacePictureMIClick
    end
    object LoadPlacePictureFromFileSeparatorMI: TMenuItem
      Caption = '-'
    end
    object LoadPlacePictureFromFileMI: TMenuItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100'...'
      OnClick = LoadPlacePictureFromFileMIClick
    end
  end
  object PlacePicturesQuery: TADOQuery
    Connection = LandscapeDB.Connection
    Parameters = <
      item
        Name = 'place_id'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select'
      '  id,'
      '  visible_name,'
      '  created'
      'from'
      '  dbo.place_pictures'
      'where'
      '  place_id = :place_id'
      'order by'
      '  visible_name')
    Left = 208
    Top = 128
  end
  object PlacePicturesRecordQuery: TADOQuery
    Connection = LandscapeDB.Connection
    Parameters = <
      item
        Name = 'id'
        DataType = ftFloat
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select'
      '  id,'
      '  visible_name,'
      '  created'
      'from'
      '  dbo.place_pictures'
      'where'
      '  id = :id')
    Left = 208
    Top = 168
  end
  object PlacePicturesDataSet: TRxMemoryData
    FieldDefs = <
      item
        Name = 'id'
        DataType = ftFloat
      end
      item
        Name = 'visible_name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'created'
        DataType = ftDateTime
      end>
    Left = 336
    Top = 128
  end
  object PlacePictureOpenDialog: TOpenDialog
    Filter = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1074' '#1092#1086#1088#1084#1072#1090#1077' JPEG (*.jpg;*.jpeg)|*.jpg;*.jpeg'
    Left = 288
    Top = 88
  end
  object PlacePictureDataQuery: TADOQuery
    Connection = LandscapeDB.Connection
    Parameters = <
      item
        Name = 'id'
        DataType = ftFloat
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select'
      '  picture_data'
      'from'
      '  dbo.place_pictures'
      'where'
      '  id = :id')
    Left = 336
    Top = 176
  end
  object PlacePicturesDataSource: TDataSource
    DataSet = PlacePicturesDataSet
    Left = 256
    Top = 144
  end
end
