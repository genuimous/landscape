object LogForm: TLogForm
  Left = 480
  Top = 228
  Width = 640
  Height = 480
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LogMemo: TMemo
    Left = 0
    Top = 0
    Width = 632
    Height = 434
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object MainMenu: TMainMenu
    Left = 8
    Top = 8
    object FileMI: TMenuItem
      Caption = #1060#1072#1081#1083
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
  object SaveDialog: TSaveDialog
    DefaultExt = 'log'
    Filter = #1060#1072#1081#1083#1099' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' (*.log)|*.log'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 40
    Top = 8
  end
  object FormPlacement: TFormPlacement
    Left = 160
    Top = 136
  end
end
