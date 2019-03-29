unit TrackChart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, TeeProcs, Chart, Menus, StdCtrls, ExtCtrls,
  ComCtrls, Placemnt;

type
  TTrackChartForm = class(TForm)
    TrackAltitudeChart: TChart;
    AltitudeSeries: TLineSeries;
    SummaryPanel: TPanel;
    FormPlacement: TFormPlacement;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TrackChartForm: TTrackChartForm;

implementation

{$R *.dfm}

end.
