object ImageViewForm: TImageViewForm
  Left = 477
  Top = 232
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'ImageViewForm'
  ClientHeight = 166
  ClientWidth = 269
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
  object Image: TImage
    Left = 0
    Top = 0
    Width = 269
    Height = 166
    Align = alClient
    AutoSize = True
    Center = True
    PopupMenu = ImagePopupMenu
    Proportional = True
    Stretch = True
    OnMouseDown = ImageMouseDown
  end
  object ImagePopupMenu: TPopupMenu
    Left = 72
    Top = 64
    object SaveImageMI: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100'...'
      OnClick = SaveImageMIClick
    end
  end
  object ImageSaveDialog: TSaveDialog
    DefaultExt = 'bmp'
    Filter = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1074' '#1092#1086#1088#1084#1072#1090#1077' JPEG (*.jpg;*.jpeg)|*.jpg;*.jpeg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
    Left = 136
    Top = 72
  end
end
