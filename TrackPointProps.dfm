object TrackPointPropsForm: TTrackPointPropsForm
  Left = 474
  Top = 261
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1086#1095#1082#1080' '#1090#1088#1077#1082#1072
  ClientHeight = 129
  ClientWidth = 297
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
  object RecordGroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 281
    Height = 81
    Caption = #1059#1082#1072#1078#1080#1090#1077' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1102' '#1086' '#1090#1086#1095#1082#1077' '#1090#1088#1077#1082#1072
    TabOrder = 0
    object LatitudeDegreeLabel: TLabel
      Left = 16
      Top = 24
      Width = 38
      Height = 13
      Caption = #1064#1080#1088#1086#1090#1072
    end
    object LongitudeDegreeLabel: TLabel
      Left = 144
      Top = 24
      Width = 43
      Height = 13
      Caption = #1044#1086#1083#1075#1086#1090#1072
    end
    object LatitudeDegreeEdit: TEdit
      Left = 16
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 0
      OnExit = LatitudeDegreeEditExit
    end
    object LongitudeDegreeEdit: TEdit
      Left = 144
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      OnExit = LongitudeDegreeEditExit
    end
  end
  object CancelButton: TButton
    Left = 214
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object OKButton: TButton
    Left = 134
    Top = 96
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object FormPlacement: TFormPlacement
    Left = 40
    Top = 96
  end
end
