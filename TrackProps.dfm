object TrackPropsForm: TTrackPropsForm
  Left = 681
  Top = 447
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1088#1077#1082#1072
  ClientHeight = 177
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RecordGroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 433
    Height = 129
    Caption = #1059#1082#1072#1078#1080#1090#1077' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1102' '#1086' '#1090#1088#1077#1082#1077
    TabOrder = 0
    object VisibleNameLabel: TLabel
      Left = 16
      Top = 72
      Width = 50
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
    end
    object CategoryLabel: TLabel
      Left = 16
      Top = 24
      Width = 53
      Height = 13
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
    end
    object VisibleNameEdit: TEdit
      Left = 16
      Top = 88
      Width = 401
      Height = 21
      TabOrder = 1
    end
    object CategoryComboBox: TRxDBLookupCombo
      Left = 16
      Top = 40
      Width = 401
      Height = 21
      DropDownCount = 8
      LookupField = 'id'
      LookupDisplay = 'visible_name'
      LookupSource = CategoriesDataSource
      TabOrder = 0
    end
  end
  object CancelButton: TButton
    Left = 366
    Top = 144
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object OKButton: TButton
    Left = 286
    Top = 144
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object FormPlacement: TFormPlacement
    Left = 8
    Top = 144
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
end
