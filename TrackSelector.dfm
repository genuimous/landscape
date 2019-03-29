object TrackSelectorForm: TTrackSelectorForm
  Left = 438
  Top = 294
  Width = 700
  Height = 400
  Caption = #1042#1099#1073#1086#1088' '#1090#1088#1077#1082#1072
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 700
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
  object CategoryPanel: TPanel
    Left = 0
    Top = 0
    Width = 692
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      692
      89)
    object CategoryLabel: TLabel
      Left = 8
      Top = 8
      Width = 53
      Height = 13
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
    end
    object CategoryComboBox: TRxDBLookupCombo
      Left = 8
      Top = 24
      Width = 676
      Height = 21
      DropDownCount = 8
      Anchors = [akLeft, akTop, akRight]
      LookupField = 'id'
      LookupDisplay = 'visible_name'
      LookupSource = CategoriesDataSource
      TabOrder = 0
      OnChange = CategoryComboBoxChange
    end
    object UserOnlyCheckBox: TCheckBox
      Left = 8
      Top = 58
      Width = 89
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1089#1074#1086#1080
      TabOrder = 1
      OnClick = UserOnlyCheckBoxClick
    end
  end
  object ActionPanel: TPanel
    Left = 0
    Top = 332
    Width = 692
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      692
      41)
    object OKButton: TButton
      Left = 529
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight]
      Caption = 'OK'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
    object CancelButton: TButton
      Left = 609
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object TracksGrid: TcxGrid
    Left = 0
    Top = 89
    Width = 692
    Height = 243
    Align = alClient
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    object TracksView: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = TracksDataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
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
        Width = 80
      end
      object TracksViewCreatedColumn: TcxGridDBColumn
        Caption = #1057#1086#1079#1076#1072#1085#1086
        DataBinding.FieldName = 'created'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 120
      end
      object TracksViewCreatedByVisibleNameColumn: TcxGridDBColumn
        Caption = #1057#1086#1079#1076#1072#1083
        DataBinding.FieldName = 'created_by_visible_name'
        Width = 160
      end
    end
    object TracksLevel: TcxGridLevel
      GridView = TracksView
    end
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
    Left = 176
    Top = 48
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
    Left = 264
    Top = 40
  end
  object CategoriesDataSource: TDataSource
    DataSet = CategoriesDataSet
    Left = 296
    Top = 40
  end
  object TracksQuery: TADOQuery
    Connection = LandscapeDB.Connection
    Parameters = <
      item
        Name = 'category_id'
        DataType = ftFloat
        Size = -1
        Value = Null
      end
      item
        Name = 'user_only'
        DataType = ftBoolean
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select'
      '  id,'
      '  visible_name,'
      '  step_count,'
      '  created,'
      '  dbo.user_visible_name(created_by) created_by_visible_name'
      'from'
      '  dbo.all_tracks'
      'where'
      '  category_id = :category_id'
      '  and (created_by = user or :user_only = 0)'
      'order by'
      '  visible_name')
    Left = 312
    Top = 184
  end
  object TracksDataSource: TDataSource
    DataSet = TracksDataSet
    Left = 348
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
        Size = 250
      end
      item
        Name = 'created'
        DataType = ftDateTime
      end
      item
        Name = 'created_by_visible_name'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'step_count'
        DataType = ftInteger
      end>
    Left = 320
    Top = 224
  end
  object FormPlacement: TFormPlacement
    Left = 184
    Top = 144
  end
end
