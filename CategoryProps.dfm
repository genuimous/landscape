object CategoryPropsForm: TCategoryPropsForm
  Left = 777
  Top = 643
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1072#1088#1077#1084#1077#1090#1088#1099' '#1082#1072#1090#1077#1075#1086#1088#1080
  ClientHeight = 153
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
  PixelsPerInch = 96
  TextHeight = 13
  object RecordPropsGroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 433
    Height = 105
    Caption = #1059#1082#1072#1078#1080#1090#1077' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1102' '#1086' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
    TabOrder = 0
    object VisibleNameLabel: TLabel
      Left = 16
      Top = 24
      Width = 50
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
    end
    object VisibleNameEdit: TEdit
      Left = 16
      Top = 40
      Width = 401
      Height = 21
      TabOrder = 0
    end
    object ObsoleteCheckBox: TCheckBox
      Left = 16
      Top = 72
      Width = 113
      Height = 17
      Caption = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100
      TabOrder = 1
    end
  end
  object CancelButton: TButton
    Left = 366
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object OKButton: TButton
    Left = 286
    Top = 120
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object FormPlacement: TFormPlacement
    Left = 8
    Top = 120
  end
end
