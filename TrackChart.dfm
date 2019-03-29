object TrackChartForm: TTrackChartForm
  Left = 533
  Top = 549
  Width = 600
  Height = 300
  Caption = #1043#1088#1072#1092#1080#1082' '#1090#1088#1077#1082#1072
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object TrackAltitudeChart: TChart
    Left = 0
    Top = 25
    Width = 592
    Height = 248
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BackWall.Pen.Visible = False
    MarginBottom = 0
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 0
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    AxisVisible = False
    Frame.Visible = False
    Legend.Visible = False
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 1
    object AltitudeSeries: TLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object SummaryPanel: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object FormPlacement: TFormPlacement
    Left = 184
    Top = 81
  end
end
