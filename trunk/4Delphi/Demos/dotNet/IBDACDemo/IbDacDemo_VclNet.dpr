{$I Base\DacDemo.inc}

program IbDacDemo_VclNet;

{%DelphiDotNetAssemblyCompiler 'System.Drawing.dll'}
{%DelphiDotNetAssemblyCompiler 'Borland.VclDbRtl.dll'}
{%DelphiDotNetAssemblyCompiler 'Borland.Delphi.dll'}
{%DelphiDotNetAssemblyCompiler 'Borland.VclRtl.dll'}
{%DelphiDotNetAssemblyCompiler 'Borland.Vcl.dll'}
{%DelphiDotNetAssemblyCompiler 'Devart.Dac.dll'}
{%DelphiDotNetAssemblyCompiler 'Devart.IbDac.dll'}

uses
  Forms,
  DemoBase in 'Base\DemoBase.pas',
  HtmlConsts in 'Base\HtmlConsts.pas',
  DemoForm in 'Base\DemoForm.pas' {DemoForm},
  DemoFrame in 'Base\DemoFrame.pas' {DemoFrame},
  CategoryFrame in 'Base\CategoryFrame.pas',
  VTable in 'VirtualTable\VTable.pas' {VirtualTableFrame},
  CRDBGrid in 'CRDBGrid\CRDBGrid.pas' {CRDBGridFrame},
  IbDacDemoForm in 'Base\IbDacDemoForm.pas' {IbDacForm},
  IbDacAbout in 'Base\IbDacAbout.pas' {IbDacAboutForm},
  ParamType in 'Base\ParamType.pas' {ParamTypeForm},
{$IFNDEF STD}  
  Fetch in 'Loader\Fetch.pas' {FetchForm},
  Loader in 'Loader\Loader.pas', {LoaderFrame}
{$ENDIF}
  Alerter in 'Alerter\Alerter.pas' {AlerterFrame},
  Query in 'Query\Query.pas' {QueryFrame},
  ConnectDialog in 'ConnectDialog\ConnectDialog.pas' {ConnectDialogFrame},
  Arrays in 'Arrays\Arrays.pas' {ArraysFrame},
  CachedUpdates in 'CachedUpdates\CachedUpdates.pas' {CachedUpdates},
  UpdateAction in 'CachedUpdates\UpdateAction.pas' {UpdateActionForm},
  BlobPictures in 'BlobPictures\BlobPictures.pas' {BlobPicturesFrame},
  StoredProc in 'StoredProc\StoredProc.pas' {StoredProcFrame},
  Sql in 'Sql\Sql.pas' {SqlFrame},
  LongStrings in 'LongStrings\LongStrings.pas' {LongStringsFrame},
  MasterDetail in 'MasterDetail\MasterDetail.pas' {MasterDetailFrame},
  UpdateSQL in 'UpdateSQL\UpdateSQL.pas' {UpdateSQLFrame},
  FilterAndIndex in 'FilterAndIndex\FilterAndIndex.pas' {FilterAndIndexFrame},
  Table in 'Table\Table.pas' {TableFrame},
  TextBlob in 'TextBlob\TextBlob.pas' {TextBlobFrame},
  Threads in 'Threads\Threads.pas' {ThreadsFrame},
  ThreadsData in 'Threads\ThreadsData.pas' {ThreadsDataModule},
  DB_Key in 'DB_Key\DB_Key.pas' {DB_KeyFrame};

{$R *.res}

[STAThread]
begin
  Application.Initialize;
  Application.CreateForm(TIbDacForm, IbDacForm);
  Application.Run;
end.

