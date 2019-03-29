object PlacesForm: TPlacesForm
  Left = 418
  Top = 263
  Width = 800
  Height = 600
  Caption = #1054#1073#1098#1077#1082#1090#1099
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
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
  object TracksSplitter: TSplitter
    Left = 235
    Top = 0
    Height = 532
  end
  object ActionPanel: TPanel
    Left = 0
    Top = 532
    Width = 792
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      792
      41)
    object CancelButton: TButton
      Left = 709
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight]
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object CategoryGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 235
    Height = 532
    Align = alLeft
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    object CategoryView: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = CategoriesDataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      object CategoryViewVisibleNameColumn: TcxGridDBColumn
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
        DataBinding.FieldName = 'visible_name'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 200
      end
    end
    object CategoryLevel: TcxGridLevel
      GridView = CategoryView
    end
  end
  object PlacesPanel: TPanel
    Left = 238
    Top = 0
    Width = 554
    Height = 532
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object CommentTextSplitter: TSplitter
      Left = 0
      Top = 349
      Width = 554
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object PlacesGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 554
      Height = 349
      Align = alClient
      PopupMenu = PlacesPopupMenu
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      object PlacesView: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = PlacesDataSource
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        object PlacesViewIdentityNameColumn: TcxGridDBColumn
          Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
          DataBinding.FieldName = 'identity_name'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = False
          Width = 150
        end
        object PlacesViewVisibleNameColumn: TcxGridDBColumn
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'visible_name'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          Width = 300
        end
        object PlacesViewPictureCountColumn: TcxGridDBColumn
          Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081
          DataBinding.FieldName = 'picture_count'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = False
          Width = 100
        end
        object PlacesViewLatitudeDegreeColumn: TcxGridDBColumn
          Caption = #1064#1080#1088#1086#1090#1072
          DataBinding.FieldName = 'latitude_degree'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          Width = 100
        end
        object PlacesViewLongitudeDegreeColumn: TcxGridDBColumn
          Caption = #1044#1086#1083#1075#1086#1090#1072
          DataBinding.FieldName = 'longitude_degree'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          Width = 100
        end
        object PlacesViewAltitudeColumn: TcxGridDBColumn
          Caption = #1042#1099#1089#1086#1090#1072
          DataBinding.FieldName = 'altitude'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          Width = 80
        end
        object PlacesViewCreatedColumn: TcxGridDBColumn
          Caption = #1057#1086#1079#1076#1072#1085#1086
          DataBinding.FieldName = 'created'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          Width = 120
        end
      end
      object PlacesLevel: TcxGridLevel
        GridView = PlacesView
      end
    end
    object PlaceCommentTextMemo: TMemo
      Left = 0
      Top = 352
      Width = 554
      Height = 180
      Align = alBottom
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object CategoriesDataSet: TRxMemoryData
    FieldDefs = <
      item
        Name = 'id'
        DataType = ftFloat
      end
      item
        Name = 'visible_name'
        DataType = ftString
        Size = 255
      end>
    AfterScroll = CategoriesDataSetAfterScroll
    Left = 64
    Top = 192
  end
  object CategoriesDataSource: TDataSource
    DataSet = CategoriesDataSet
    Left = 96
    Top = 192
  end
  object CategoriesQuery: TADOQuery
    Connection = LandscapeDB.Connection
    Parameters = <>
    SQL.Strings = (
      'select'
      '  id,'
      '  visible_name'
      'from'
      '  dbo.categories'
      'order by'
      '  visible_name')
    Left = 72
    Top = 312
  end
  object PlacesQuery: TADOQuery
    Connection = LandscapeDB.Connection
    Parameters = <
      item
        Name = 'category_id'
        DataType = ftFloat
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select'
      '  id,'
      '  latitude,'
      '  longitude,'
      '  altitude,'
      '  identity_name,'
      '  visible_name,'
      '  picture_count,'
      '  created'
      'from'
      '  dbo.user_places'
      'where'
      '  category_id = :category_id'
      'order by'
      '  visible_name')
    Left = 312
    Top = 184
  end
  object PlacesDataSet: TRxMemoryData
    FieldDefs = <
      item
        Name = 'id'
        DataType = ftFloat
      end
      item
        Name = 'latitude'
        DataType = ftInteger
      end
      item
        Name = 'latitude_degree'
        DataType = ftFloat
      end
      item
        Name = 'longitude'
        DataType = ftInteger
      end
      item
        Name = 'longitude_degree'
        DataType = ftFloat
      end
      item
        Name = 'altitude'
        DataType = ftInteger
      end
      item
        Name = 'identity_name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'visible_name'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'picture_count'
        DataType = ftInteger
      end
      item
        Name = 'created'
        DataType = ftDateTime
      end>
    BeforePost = PlacesDataSetBeforePost
    AfterScroll = PlacesDataSetAfterScroll
    Left = 320
    Top = 224
  end
  object PlacesDataSource: TDataSource
    DataSet = PlacesDataSet
    Left = 348
    Top = 184
  end
  object PlaceCommentTextQuery: TADOQuery
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
      '  comment_text'
      'from'
      '  dbo.user_places'
      'where'
      '  id = :id')
    Left = 320
    Top = 272
  end
  object PlacesRecordQuery: TADOQuery
    Connection = LandscapeDB.Connection
    Parameters = <
      item
        Name = 'id'
        DataType = ftFloat
        Size = -1
        Value = Null
      end
      item
        Name = 'category_id'
        DataType = ftFloat
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select'
      '  id,'
      '  latitude,'
      '  longitude,'
      '  altitude,'
      '  identity_name,'
      '  visible_name,'
      '  picture_count,'
      '  created'
      'from'
      '  dbo.user_places'
      'where'
      '  id = :id'
      '  and category_id = :category_id')
    Left = 416
    Top = 208
  end
  object PlacesPopupMenu: TPopupMenu
    Left = 416
    Top = 104
    object EditPlaceMI: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
      OnClick = EditPlaceMIClick
    end
    object DeletePlaceMI: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = DeletePlaceMIClick
    end
    object TrackInfoSeparatorMI: TMenuItem
      Caption = '-'
    end
    object SetPlaceCommentTextMI: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1087#1080#1089#1072#1085#1080#1077'...'
      OnClick = SetPlaceCommentTextMIClick
    end
    object ShowPlacePicturesMI: TMenuItem
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103'...'
      OnClick = ShowPlacePicturesMIClick
    end
  end
  object FormPlacement: TFormPlacement
    Left = 128
    Top = 56
  end
end
