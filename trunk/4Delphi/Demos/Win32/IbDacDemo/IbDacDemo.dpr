{$I Base\DacDemo.inc}

program IbDacDemo;

uses
  Forms,
  DemoBase in 'Base\DemoBase.pas',
  HtmlConsts in 'Base\HtmlConsts.pas',
  DemoForm in 'Base\DemoForm.pas' {DemoForm},
  DemoFrame in 'Base\DemoFrame.pas' {DemoFrame},
  CategoryFrame in 'Base\CategoryFrame.pas',
  VTable in 'VirtualTable\VTable.pas' {VirtualTableFrame},
{$IFDEF CRDBGRID}
  CRDBGrid in 'CRDBGrid\CRDBGrid.pas' {CRDBGridFrame},
{$ENDIF}
{$IFNDEF STD}  
  Fetch in 'Loader\Fetch.pas' {FetchForm},
  Loader in 'Loader\Loader.pas', {LoaderFrame}
{$ENDIF}
  IbDacDemoForm in 'Base\IbDacDemoForm.pas' {IbDacForm},
  IbDacAbout in 'Base\IbDacAbout.pas' {IbDacAboutForm},
  ParamType in 'Base\ParamType.pas' {ParamTypeForm},
  Alerter in 'Alerter\Alerter.pas' {AlerterFrame},
  Arrays in 'Arrays\Arrays.pas' {ArraysFrame},
  BlobPictures in 'BlobPictures\BlobPictures.pas' {BlobPicturesFrame},
  CachedUpdates in 'CachedUpdates\CachedUpdates.pas' {CachedUpdates},
  ConnectDialog in 'ConnectDialog\ConnectDialog.pas' {ConnectDialogFrame},
  DB_Key in 'DB_Key\DB_Key.pas' {DB_KeyFrame},
  FilterAndIndex in 'FilterAndIndex\FilterAndIndex.pas' {FilterAndIndexFrame},
  LongStrings in 'LongStrings\LongStrings.pas' {LongStringsFrame},
  MasterDetail in 'MasterDetail\MasterDetail.pas' {MasterDetailFrame},
  Query in 'Query\Query.pas' {QueryFrame},
  Sql in 'Sql\Sql.pas' {SqlFrame},
  StoredProc in 'StoredProc\StoredProc.pas' {StoredProcFrame},
  Table in 'Table\Table.pas' {TableFrame},
  TextBlob in 'TextBlob\TextBlob.pas' {TextBlobFrame},
  Threads in 'Threads\Threads.pas' {ThreadsFrame},
  ThreadsData in 'Threads\ThreadsData.pas' {ThreadsDataModule},
  UpdateAction in 'CachedUpdates\UpdateAction.pas' {UpdateActionForm},
  UpdateSQL in 'UpdateSQL\UpdateSQL.pas' {UpdateSQLFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TIbDacForm, IbDacForm);
  Application.Run;
end.

