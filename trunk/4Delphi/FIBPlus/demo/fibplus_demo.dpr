program fibplus_demo;

uses
  Forms,
  main in 'main.pas' {frmMain},
  dm_main in 'dm_main.pas' {dmMain: TDataModule},
  connect in 'connect.pas' {frmConnect},
  about in 'about.pas' {frmAbout},
  common in 'COMMON\common.pas',
  events in 'events.pas' {frmEvents},
  simple in 'simple.pas' {frmSimple},
  fishfact in 'fishfact.pas' {frmFishFact},
  cachexxx in 'cachexxx.pas' {frmCachexxx},
  cache_dialog in 'cache_dialog.pas' {frmCacheDialog},
  master_detail in 'master_detail.pas' {frmMasterDetail},
  edit_country in 'edit_country.pas' {frmEditCountry},
  local_search in 'local_search.pas' {frmLocalSearch},
  starting_with in 'starting_with.pas' {frmStartingWith},
  local_sorting in 'local_sorting.pas' {frmLocalSorting},
  local_filtering in 'local_filtering.pas' {frmLocalFiltering},
  midas_simple in 'midas_simple.pas' {frmMidas};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.
