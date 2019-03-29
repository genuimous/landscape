program Landscape;

{%ToDo 'Landscape.todo'}

uses
  Forms,
  DevExpressRU,
  LandscapeBuilder in 'LandscapeBuilder.pas' {LandscapeBuilderForm},
  Utils in 'Utils.pas',
  DialMessages in 'DialMessages.pas',
  Error in 'Error.pas' {ErrorForm},
  Geoid in 'Geoid.pas',
  Settings in 'Settings.pas' {SettingsForm},
  Log in 'Log.pas' {LogForm},
  CalcProps in 'CalcProps.pas' {CalcPropsForm},
  Tracks in 'Tracks.pas' {TracksForm},
  TrackProps in 'TrackProps.pas' {TrackPropsForm},
  TextEdit in 'TextEdit.pas' {TextEditForm},
  Places in 'Places.pas' {PlacesForm},
  PlaceProps in 'PlaceProps.pas' {PlacePropsForm},
  PlacePictures in 'PlacePictures.pas' {PlacePicturesForm},
  PlacePictureProps in 'PlacePictureProps.pas' {PlacePicturePropsForm},
  ImageView in 'ImageView.pas' {ImageViewForm},
  DBConnection in 'DBConnection.pas' {LandscapeDB: TDataModule},
  TrackChart in 'TrackChart.pas' {TrackChartForm},
  DataErrors in 'DataErrors.pas',
  OziExportImport in 'OziExportImport.pas',
  Categories in 'Categories.pas' {CategoriesForm},
  CategoryProps in 'CategoryProps.pas' {CategoryPropsForm},
  TrackSelector in 'TrackSelector.pas' {TrackSelectorForm},
  TrackPointProps in 'TrackPointProps.pas' {TrackPointPropsForm},
  PlaceListProps in 'PlaceListProps.pas' {PlaceListPropsForm},
  PlacesSelector in 'PlacesSelector.pas' {PlacesSelectorForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TLandscapeBuilderForm, LandscapeBuilderForm);
  Application.Run;
end.
