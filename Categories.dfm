object CategoriesForm: TCategoriesForm
  Left = 534
  Top = 347
  Width = 600
  Height = 400
  Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ActionPanel: TPanel
    Left = 0
    Top = 332
    Width = 592
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      592
      41)
    object CancelButton: TButton
      Left = 509
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
    Width = 592
    Height = 332
    Align = alClient
    PopupMenu = CategoriesPopupMenu
    TabOrder = 1
    LookAndFeel.Kind = lfStandard
    object CategoryView: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = CategoryDataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
      object CategoryViewVisibleNameColumn: TcxGridDBColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'visible_name'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 300
      end
      object CategoryViewObsoleteColumn: TcxGridDBColumn
        Caption = #1053#1077' '#1080#1089#1087'.'
        DataBinding.FieldName = 'obsolete'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ReadOnly = True
        Width = 70
      end
      object CategoryViewTrackCountColumn: TcxGridDBColumn
        Caption = #1058#1088#1077#1082#1086#1074
        DataBinding.FieldName = 'track_count'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 80
      end
      object CategoryViewPlaceCountColumn: TcxGridDBColumn
        Caption = #1054#1073#1098#1077#1082#1090#1086#1074
        DataBinding.FieldName = 'place_count'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 80
      end
    end
    object CategoryLevel: TcxGridLevel
      GridView = CategoryView
    end
  end
  object CategoryDataSource: TDataSource
    DataSet = CategoriesDataSet
    Left = 304
    Top = 240
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
      end
      item
        Name = 'obsolete'
        DataType = ftBoolean
      end
      item
        Name = 'track_count'
        DataType = ftInteger
      end
      item
        Name = 'place_count'
        DataType = ftInteger
      end>
    Left = 272
    Top = 240
  end
  object CategoriesPopupMenu: TPopupMenu
    Left = 136
    Top = 208
    object CreateCategoryMI: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100'...'
      OnClick = CreateCategoryMIClick
    end
    object EditCategoryMI: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100'...'
      OnClick = EditCategoryMIClick
    end
    object DeleteCategoryMI: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = DeleteCategoryMIClick
    end
  end
  object CategoriesQuery: TADOQuery
    Connection = LandscapeDB.Connection
    Parameters = <>
    SQL.Strings = (
      'select'
      '  id,'
      '  visible_name,'
      '  obsolete,'
      
        '  (select count(*) from dbo.tracks where category_id = categorie' +
        's.id) track_count,'
      
        '  (select count(*) from dbo.places where category_id = categorie' +
        's.id) place_count'
      'from '
      '  dbo.categories'
      'order by '
      '  visible_name')
    Left = 72
    Top = 312
  end
  object CategoriesRecordQuery: TADOQuery
    Connection = LandscapeDB.Connection
    Parameters = <
      item
        Name = 'id'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select'
      '  id,'
      '  visible_name,'
      '  obsolete,'
      
        '  (select count(*) from dbo.tracks where category_id = categorie' +
        's.id) track_count,'
      
        '  (select count(*) from dbo.places where category_id = categorie' +
        's.id) place_count'
      'from '
      '  dbo.categories'
      'where'
      '  id = :id')
    Left = 104
    Top = 312
  end
  object FormPlacement: TFormPlacement
    Left = 168
    Top = 104
  end
end
