object CalcPropsForm: TCalcPropsForm
  Left = 701
  Top = 300
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1088#1072#1089#1095#1077#1090#1072' '#1087#1091#1090#1080
  ClientHeight = 377
  ClientWidth = 257
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
  object CalcGroupBox: TGroupBox
    Left = 8
    Top = 176
    Width = 241
    Height = 161
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1088#1072#1089#1095#1077#1090#1072' '#1087#1091#1090#1080
    TabOrder = 1
    object StartPointLabel: TLabel
      Left = 16
      Top = 24
      Width = 70
      Height = 13
      Caption = #1058#1086#1095#1082#1072' '#1089#1090#1072#1088#1090#1072':'
    end
    object EndPointLabel: TLabel
      Left = 16
      Top = 88
      Width = 76
      Height = 13
      Caption = #1058#1086#1095#1082#1072' '#1092#1080#1085#1080#1096#1072':'
    end
    object StartLatLabel: TLabel
      Left = 16
      Top = 40
      Width = 37
      Height = 13
      Caption = #1096#1080#1088#1086#1090#1072
    end
    object StartLonLabel: TLabel
      Left = 128
      Top = 40
      Width = 40
      Height = 13
      Caption = #1076#1086#1083#1075#1086#1090#1072
    end
    object EndLatLabel: TLabel
      Left = 16
      Top = 104
      Width = 37
      Height = 13
      Caption = #1096#1080#1088#1086#1090#1072
    end
    object EndLonLabel: TLabel
      Left = 128
      Top = 104
      Width = 40
      Height = 13
      Caption = #1076#1086#1083#1075#1086#1090#1072
    end
    object StartLatitudeEdit: TEdit
      Left = 16
      Top = 56
      Width = 97
      Height = 21
      TabOrder = 0
      OnExit = StartLatitudeEditExit
    end
    object EndLatitudeEdit: TEdit
      Left = 16
      Top = 120
      Width = 97
      Height = 21
      TabOrder = 1
      OnExit = EndLatitudeEditExit
    end
    object StartLongitudeEdit: TEdit
      Left = 128
      Top = 56
      Width = 97
      Height = 21
      TabOrder = 2
      OnExit = StartLongitudeEditExit
    end
    object EndLongitudeEdit: TEdit
      Left = 128
      Top = 120
      Width = 97
      Height = 21
      TabOrder = 3
      OnExit = EndLongitudeEditExit
    end
  end
  object CancelButton: TButton
    Left = 174
    Top = 344
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object OKButton: TButton
    Left = 94
    Top = 344
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object SearchAreaGroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 241
    Height = 161
    Caption = #1054#1073#1083#1072#1089#1090#1100' '#1087#1086#1080#1089#1082#1072
    TabOrder = 0
    object LatBetweenLabel: TLabel
      Left = 16
      Top = 24
      Width = 87
      Height = 13
      Caption = #1043#1088#1072#1085#1080#1094#1072' '#1096#1080#1088#1086#1090#1099':'
    end
    object LonBetweenLabel: TLabel
      Left = 16
      Top = 88
      Width = 90
      Height = 13
      Caption = #1043#1088#1072#1085#1080#1094#1072' '#1076#1086#1083#1075#1086#1090#1099':'
    end
    object StartLatBorderLabel: TLabel
      Left = 16
      Top = 40
      Width = 11
      Height = 13
      Caption = #1086#1090
    end
    object EndLatBorderLabel: TLabel
      Left = 128
      Top = 40
      Width = 12
      Height = 13
      Caption = #1076#1086
    end
    object StartLonBorderLabel: TLabel
      Left = 16
      Top = 104
      Width = 11
      Height = 13
      Caption = #1086#1090
    end
    object EndLonBorderLabel: TLabel
      Left = 128
      Top = 104
      Width = 12
      Height = 13
      Caption = #1076#1086
    end
    object StartLatitudeBorderEdit: TEdit
      Left = 16
      Top = 56
      Width = 97
      Height = 21
      TabOrder = 0
      OnExit = StartLatitudeBorderEditExit
    end
    object EndLatitudeBorderEdit: TEdit
      Left = 128
      Top = 56
      Width = 97
      Height = 21
      TabOrder = 1
      OnExit = EndLatitudeBorderEditExit
    end
    object StartLongitudeBorderEdit: TEdit
      Left = 16
      Top = 120
      Width = 97
      Height = 21
      TabOrder = 2
      OnExit = StartLongitudeBorderEditExit
    end
    object EndLongitudeBorderEdit: TEdit
      Left = 128
      Top = 120
      Width = 97
      Height = 21
      TabOrder = 3
      OnExit = EndLongitudeBorderEditExit
    end
  end
  object FormPlacement: TFormPlacement
    Left = 40
    Top = 48
  end
end
