object TextEditForm: TTextEditForm
  Left = 571
  Top = 378
  Width = 400
  Height = 300
  Caption = 'TextEditForm'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object TextEditMemo: TMemo
    Left = 0
    Top = 0
    Width = 392
    Height = 213
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ActionPanel: TPanel
    Left = 0
    Top = 213
    Width = 392
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      392
      41)
    object CancelButton: TButton
      Left = 309
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
    object OKButton: TButton
      Left = 229
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object FormPlacement: TFormPlacement
    Left = 56
    Top = 80
  end
  object MainMenu: TMainMenu
    Left = 8
    Top = 8
    object FileMI: TMenuItem
      Caption = #1060#1072#1081#1083
      object OpenMI: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100'...'
        OnClick = OpenMIClick
      end
      object SaveMI: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100'...'
        OnClick = SaveMIClick
      end
      object ClearMI: TMenuItem
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        OnClick = ClearMIClick
      end
    end
  end
  object TextSaveDialog: TSaveDialog
    DefaultExt = 'txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 72
    Top = 8
  end
  object TextOpenDialog: TOpenDialog
    DefaultExt = 'txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' (*.txt)|*.txt'
    Left = 104
    Top = 8
  end
end
