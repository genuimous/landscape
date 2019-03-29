object PlacesSelectorForm: TPlacesSelectorForm
  Left = 403
  Top = 281
  Width = 790
  Height = 400
  Caption = #1042#1099#1073#1086#1088' '#1086#1073#1098#1077#1082#1090#1086#1074
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 790
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
    Width = 782
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      782
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
      Width = 766
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
    Width = 782
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      782
      41)
    object OKButton: TButton
      Left = 619
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
      Left = 699
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object PlacesGrid: TcxGrid
    Left = 0
    Top = 89
    Width = 782
    Height = 243
    Align = alClient
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    object PlacesView: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = PlacesDataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
      object PlacesViewCheckedColumn: TcxGridDBColumn
        DataBinding.FieldName = 'checked'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ValueChecked = 1
        Properties.ValueUnchecked = 0
        Width = 20
        IsCaptionAssigned = True
      end
      object PlacesViewIdentityNameColumn: TcxGridDBColumn
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        DataBinding.FieldName = 'identity_name'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 150
      end
      object PlacesViewVisibleNameColumn: TcxGridDBColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'visible_name'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 300
      end
      object PlacesViewCreatedColumn: TcxGridDBColumn
        Caption = #1057#1086#1079#1076#1072#1085#1086
        DataBinding.FieldName = 'created'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 120
      end
      object PlacesViewCreatedByVisibleNameColumn: TcxGridDBColumn
        Caption = #1057#1086#1079#1076#1072#1083
        DataBinding.FieldName = 'created_by_visible_name'
        Width = 160
      end
    end
    object PlacesLevel: TcxGridLevel
      GridView = PlacesView
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
  object PlacesQuery: TADOQuery
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
      '  latitude,'
      '  longitude,'
      '  altitude,'
      '  identity_name,'
      '  visible_name,'
      '  created,'
      '  dbo.user_visible_name(created_by) created_by_visible_name'
      'from'
      '  dbo.all_places'
      'where'
      '  category_id = :category_id'
      '  and (created_by = user or :user_only = 0)'
      'order by'
      '  identity_name')
    Left = 312
    Top = 184
  end
  object PlacesDataSource: TDataSource
    DataSet = PlacesDataSet
    Left = 348
    Top = 184
  end
  object PlacesDataSet: TRxMemoryData
    FieldDefs = <
      item
        Name = 'id'
        DataType = ftFloat
      end
      item
        Name = 'checked'
        DataType = ftInteger
      end
      item
        Name = 'latitude'
        DataType = ftInteger
      end
      item
        Name = 'longitude'
        DataType = ftInteger
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
      end>
    AfterInsert = PlacesDataSetAfterInsert
    Left = 320
    Top = 224
  end
  object FormPlacement: TFormPlacement
    Left = 152
    Top = 168
  end
end
