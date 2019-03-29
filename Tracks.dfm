object TracksForm: TTracksForm
  Left = 278
  Top = 295
  Width = 800
  Height = 600
  Caption = #1047#1072#1087#1080#1089#1072#1085#1085#1099#1077' '#1090#1088#1077#1082#1080
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
  object TracksPanel: TPanel
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
    object TracksGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 554
      Height = 349
      Align = alClient
      PopupMenu = TracksPopupMenu
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      object TracksView: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = TracksDataSource
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        object TracksViewVisibleNameColumn: TcxGridDBColumn
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'visible_name'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          Width = 300
        end
        object TracksViewStepCountColumn: TcxGridDBColumn
          Caption = #1064#1072#1075#1086#1074
          DataBinding.FieldName = 'step_count'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          Width = 80
        end
        object TracksViewCreatedColumn: TcxGridDBColumn
          Caption = #1057#1086#1079#1076#1072#1085#1086
          DataBinding.FieldName = 'created'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ReadOnly = True
          Width = 120
        end
      end
      object TracksLevel: TcxGridLevel
        GridView = TracksView
      end
    end
    object TrackCommentTextMemo: TMemo
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
  object FormPlacement: TFormPlacement
    Left = 96
    Top = 80
  end
  object TracksPopupMenu: TPopupMenu
    Left = 304
    Top = 88
    object EditTrackMI: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
      OnClick = EditTrackMIClick
    end
    object DeleteTrackMI: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = DeleteTrackMIClick
    end
    object TrackInfoSeparatorMI: TMenuItem
      Caption = '-'
    end
    object SetTrackCommentTextMI: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1087#1080#1089#1072#1085#1080#1077'...'
      OnClick = SetTrackCommentTextMIClick
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
  object TracksQuery: TADOQuery
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
      '  visible_name,'
      '  step_count,'
      '  created'
      'from '
      '  dbo.user_tracks'
      'where'
      '  category_id = :category_id'
      'order by'
      '  visible_name')
    Left = 312
    Top = 184
  end
  object TracksDataSet: TRxMemoryData
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
        Name = 'step_count'
        DataType = ftInteger
      end
      item
        Name = 'created'
        DataType = ftDateTime
      end>
    AfterScroll = TracksDataSetAfterScroll
    Left = 320
    Top = 224
  end
  object TracksDataSource: TDataSource
    DataSet = TracksDataSet
    Left = 348
    Top = 184
  end
  object TrackCommentTextQuery: TADOQuery
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
      '  dbo.user_tracks'
      'where '
      '  id = :id')
    Left = 320
    Top = 272
  end
  object TracksRecordQuery: TADOQuery
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
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select'
      '  id,'
      '  visible_name,'
      '  step_count,'
      '  created'
      'from '
      '  dbo.user_tracks'
      'where'
      '  id = :id'
      '  and category_id = :category_id')
    Left = 416
    Top = 208
  end
end
