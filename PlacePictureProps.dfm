object PlacePicturePropsForm: TPlacePicturePropsForm
  Left = 526
  Top = 409
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086#1073' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1080
  ClientHeight = 129
  ClientWidth = 481
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
  object PlacePicturePropsGroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 465
    Height = 81
    Caption = #1059#1082#1072#1078#1080#1090#1077' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1102' '#1086#1073' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1080
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
      Width = 433
      Height = 21
      TabOrder = 0
    end
  end
  object OKButton: TButton
    Left = 318
    Top = 96
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelButton: TButton
    Left = 398
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object FormPlacement: TFormPlacement
    Left = 8
    Top = 96
  end
end
