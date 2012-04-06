program IbDacDemo;

uses
  Interfaces, // this includes the LCL widgetset
  Forms,
  DemoBase in '..\..\..\..\Common\Demos\Win32\DacDemo\Base\DemoBase.pas',
  HtmlConsts in '..\..\..\..\Common\Demos\Win32\DacDemo\Base\HtmlConsts.pas',
  DemoForm in '..\..\..\..\Common\Demos\Win32\DacDemo\Base\DemoForm.pas' {DemoForm},
  DemoFrame in '..\..\..\..\Common\Demos\Win32\DacDemo\Base\DemoFrame.pas' {DemoFrame},
  CategoryFrame in '..\..\..\..\Common\Demos\Win32\DacDemo\Base\CategoryFrame.pas',
  VTable in '..\..\..\..\Common\Demos\Win32\DacDemo\VirtualTable\VTable.pas' {VirtualTableFrame},
  IbDacDemoForm in 'Base\IbDacDemoForm.pas' {IbDacForm},
  IbDacAbout in 'Base\IbDacAbout.pas' {IbDacAboutForm},
  ParamType in 'Base\ParamType.pas' {ParamTypeForm},
{$IFNDEF STD}
  Fetch in 'Loader\Fetch.pas' {FetchForm},
  Loader in 'Loader\Loader.pas', {LoaderFrame}
{$ENDIF}
  Alerter in 'Alerter\Alerter.pas' {AlerterFrame},
  CachedUpdates in 'CachedUpdates\CachedUpdates.pas' {CachedUpdates},
  ConnectDialog in 'ConnectDialog\ConnectDialog.pas' {ConnectDialogFrame},
  FilterAndIndex in 'FilterAndIndex\FilterAndIndex.pas' {FilterAndIndexFrame},
  LongStrings in 'LongStrings\LongStrings.pas' {LongStringsFrame},
  MasterDetail in 'MasterDetail\MasterDetail.pas' {MasterDetailFrame},
  Query in 'Query\Query.pas' {QueryFrame},
  Sql in 'Sql\Sql.pas' {SqlFrame},
  StoredProc in 'StoredProc\StoredProc.pas' {StoredProcFrame},
  Table in 'Table\Table.pas' {TableFrame},
  TextBlob in 'TextBlob\TextBlob.pas' {TextBlobFrame},
  UpdateAction in 'CachedUpdates\UpdateAction.pas' {UpdateActionForm},
  UpdateSQL in 'UpdateSQL\UpdateSQL.pas' {UpdateSQLFrame};

begin
  Application.Initialize;
  Application.CreateForm(TIbDacForm, IbDacForm);
  Application.Run;
end.

