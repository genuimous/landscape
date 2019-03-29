object SettingsForm: TSettingsForm
  Left = 572
  Top = 340
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 265
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object SettingsPageControl: TPageControl
    Left = 8
    Top = 8
    Width = 353
    Height = 217
    ActivePage = MainSettingsTabSheet
    TabOrder = 0
    object MainSettingsTabSheet: TTabSheet
      Caption = #1054#1089#1085#1086#1074#1085#1099#1077
      object MainSettingsGroupBox: TGroupBox
        Left = 8
        Top = 8
        Width = 329
        Height = 169
        Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
        TabOrder = 0
        object MaxPointCountLabel: TLabel
          Left = 16
          Top = 36
          Width = 125
          Height = 13
          Caption = #1056#1072#1079#1084#1077#1088' '#1086#1073#1083#1072#1089#1090#1080' '#1087#1086#1080#1089#1082#1072':'
        end
        object MaxAngleLabel: TLabel
          Left = 16
          Top = 68
          Width = 106
          Height = 13
          Caption = #1059#1082#1083#1086#1085', '#1085#1077' '#1073#1086#1083#1077#1077' ('#1075#1088'):'
        end
        object MaxAltitudeLabel: TLabel
          Left = 16
          Top = 100
          Width = 137
          Height = 13
          Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1074#1099#1089#1086#1090#1072' ('#1084'):'
        end
        object MaxPointCountEdit: TEdit
          Left = 216
          Top = 32
          Width = 97
          Height = 21
          MaxLength = 9
          TabOrder = 0
          OnExit = MaxPointCountEditExit
        end
        object MaxAngleEdit: TEdit
          Left = 216
          Top = 64
          Width = 40
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = '0'
        end
        object MaxAngleEditUpDown: TUpDown
          Left = 256
          Top = 64
          Width = 12
          Height = 21
          Associate = MaxAngleEdit
          Max = 90
          TabOrder = 2
        end
        object SaveTrackOnExitCheckBox: TCheckBox
          Left = 16
          Top = 132
          Width = 289
          Height = 17
          Caption = #1047#1072#1087#1088#1086#1089' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1090#1088#1077#1082#1072' '#1087#1088#1080' '#1074#1099#1093#1086#1076#1077' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
          TabOrder = 3
        end
        object MaxAltitudeEdit: TEdit
          Left = 216
          Top = 96
          Width = 97
          Height = 21
          TabOrder = 4
          OnExit = MaxAltitudeEditExit
        end
      end
    end
    object CostSettingsTabSheet: TTabSheet
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
      ImageIndex = 1
      object CostSettingsGroupBox: TGroupBox
        Left = 8
        Top = 8
        Width = 329
        Height = 169
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1090#1086#1080#1084#1086#1089#1090#1080
        TabOrder = 0
        object DistanceCostLabel: TLabel
          Left = 16
          Top = 36
          Width = 158
          Height = 13
          Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080':'
        end
        object HeightUpCostLabel: TLabel
          Left = 16
          Top = 68
          Width = 185
          Height = 13
          Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080' ('#1074#1074#1077#1088#1093'):'
        end
        object AngleCostLabel: TLabel
          Left = 16
          Top = 132
          Width = 156
          Height = 13
          Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1074#1083#1080#1103#1085#1080#1103' '#1091#1082#1083#1086#1085#1072':'
        end
        object HeightDownCostLabel: TLabel
          Left = 16
          Top = 100
          Width = 180
          Height = 13
          Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080' ('#1074#1085#1080#1079'):'
        end
        object DistanceCostEdit: TEdit
          Left = 216
          Top = 32
          Width = 97
          Height = 21
          MaxLength = 9
          TabOrder = 0
          OnExit = DistanceCostEditExit
        end
        object HeightUpCostEdit: TEdit
          Left = 216
          Top = 64
          Width = 97
          Height = 21
          MaxLength = 9
          TabOrder = 1
          OnExit = HeightUpCostEditExit
        end
        object HeightDownCostEdit: TEdit
          Left = 216
          Top = 96
          Width = 97
          Height = 21
          MaxLength = 9
          TabOrder = 2
          OnChange = HeightDownCostEditChange
        end
        object AngleCostEdit: TEdit
          Left = 216
          Top = 128
          Width = 97
          Height = 21
          MaxLength = 9
          TabOrder = 3
          OnExit = AngleCostEditExit
        end
      end
    end
  end
  object OKButton: TButton
    Left = 206
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelButton: TButton
    Left = 286
    Top = 232
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object FormPlacement: TFormPlacement
    Left = 8
    Top = 232
  end
end
