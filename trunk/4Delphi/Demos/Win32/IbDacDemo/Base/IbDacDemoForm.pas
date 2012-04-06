{$I DacDemo.inc}

unit IbDacDemoForm;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, ToolWin, DBCtrls, Grids, DBGrids, IbDacVcl,
{$IFNDEF CLR}
{$IFNDEF FPC}
  Jpeg,
{$ENDIF}
{$ENDIF}
{$IFNDEF VER130}
  Variants,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DB, DBAccess, IBC,
  IbDacAbout,
  DemoFrame,
  DemoBase,
  DemoForm, DAScript, IBCScript;

type
  TIbDacForm = class(TDemoForm)
    IBCConnection: TIBCConnection;
    IBCTransaction: TIBCTransaction;
    scCreate: TIBCScript;
    scDrop: TIBCScript;
    IBCConnectDialog: TIBCConnectDialog;
    procedure lbAboutClick(Sender: TObject); override;
    procedure cbDebugClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); override;
  public
    function ProductColor: TColor; override;
    procedure ExecCreateScript; override;
    procedure ExecDropScript; override;
  protected
    //Product customization
    function GetConnection: TCustomDAConnection; override;
    function ApplicationTitle: string; override;
    function ProductName: string; override;    
    procedure RegisterDemos; override;
    //Demo selection
  end;

var
  IbDacForm: TIbDacForm;

implementation

uses
  TypInfo,
{$IFDEF MSWINDOWS}
  Alerter,
{$IFDEF CRDBGRID}
  CRDBGrid,
{$ENDIF}
{$ENDIF}
{$IFNDEF STD}
  Loader,
{$ENDIF}
{$IFNDEF FPC}
  Arrays, DB_Key, Threads, BlobPictures,
{$ENDIF}
  StoredProc, Sql, Table, TextBlob,
  VTable, MasterDetail, UpdateSQL, FilterAndIndex,
  ConnectDialog, Query, CachedUpdates, LongStrings;

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

function TIbDacForm.GetConnection: TCustomDAConnection;
begin
  Result := IBCConnection;
end;

function TIbDacForm.ProductColor: TColor;
begin
  Result := TColor($0061328C);
end;

function TIbDacForm.ApplicationTitle: string;
begin
  Result := 'InterBase Data Access Components demos';
end;

function TIbDacForm.ProductName: string;
begin
  Result := 'IBDAC';
end;

procedure TIbDacForm.RegisterDemos;
begin
  Demos.RegisterCategory('IBDAC Demo', 'IbDac Demo');
  Demos.RegisterCategory('Working with components', 'Working with components');
  Demos.RegisterCategory('General demos', 'General demos');
  Demos.RegisterCategory('InterBase specific', 'InterBase specific');
{$IFDEF MSWINDOWS}
  Demos.RegisterDemo('Alerter', 'Using TIBCAlerter component', 'Demonstrates IBDAC advanced support for working with InterBase events. This demo presents an example of how to use events to synchronize several data views for a table being edited by multiple users. ' + 'Shows how to send events with stored procedures and triggers.', 'Working with components', TAlerterFrame, 13);
{$ENDIF}
  Demos.RegisterDemo('ConnectDialog', 'Customizing login dialog', 'Demonstrates how to customize the IBDAC connect dialog. Changes the standard IBDAC connect dialog to two custom connect dialogs. The first customized sample dialog is inherited from the TForm class, ' + 'and the second one is inherited from the default IBDAC connect dialog class.', 'Working with components', TConnectDialogFrame, 4);
{$IFDEF MSWINDOWS}
{$IFDEF CRDBGRID}
  Demos.RegisterDemo('CRDBGrid', 'Using TCRDBGrid component', 'Demonstrates how to work with the TCRDBGrid component. Shows off the main TCRDBGrid features, like filtering, searching, stretching, using compound headers, and more.', 'Working with components',  TCRDBGridFrame, 2);
{$ENDIF}
{$ENDIF}
{$IFNDEF STD}
  Demos.RegisterDemo('Loader', 'Using TIBCLoader component', 'Uses the TIBCLoader component to quickly load data into a server table. This demo also compares the two TIBCLoader data loading handlers: GetColumnData and PutData.', 'Working with components', TLoaderFrame, 16);
{$ENDIF}
  Demos.RegisterDemo('Query', 'Using TIBCQuery component', 'Demonstrates working with TIBCQuery, which is one of the most useful IBDAC components. Includes many TIBCQuery usage scenarios. Demonstrates how to edit data and export it to XML files. Note: This is a very good introductory demo. ' + 'We recommend starting here when first becoming familiar with IBDAC.', 'Working with components', TQueryFrame, 7);
  Demos.RegisterDemo('Sql', 'Using TIBCSQL component', 'Uses TIBCSQL to execute SQL statements, and generate stored procedures calls and execute them. Demonstrates how to work with parameters in SQL.', 'Working with components', TSqlFrame, 8);
  Demos.RegisterDemo('StoredProc', 'Using TIBCStoredProc component', 'Demonstrates working with the TIBCStoredProc component. Lets the user generate and invoke different types of stored procedure calls. Users can choose the type of procedure to be generated, ' + 'specify parameter types, and execute the procedure with different parameter values. Shows how to use the TIBCStoredProc object to get a DataSet from a stored procedure that returns a record set.', 'Working with components', TStoredProcFrame, 9);
  Demos.RegisterDemo('Table', 'Using TIBCTable component', 'Demonstrates how to use TIBCTable to work with data from a single table on the server without manually writing any SQL queries. Performs server-side data sorting and filtering and retrieves results for browsing and editing.', 'Working with components', TTableFrame, 10);
  Demos.RegisterDemo('UpdateSQL', 'Using TIBCUpdateSQL component', 'Demonstrates using the TIBCUpdateSQL component to customize update commands. Lets you optionally use TIBSQuery objects for carrying out insert, delete, query, and update commands.', 'Working with components', TUpdateSQLFrame, 12);
  Demos.RegisterDemo('VirtualTable', 'Using TVirtualTable component', 'Demonstrates working with the TVirtualTable component. This sample shows how to fill virtual dataset with data from other datasets, filter data by a given criteria, locate specified records, perform file operations, and change data and table structure.', 'Working with components', TVirtualTableFrame, 3, 'VTable');

  Demos.RegisterDemo('CachedUpdates', 'Cached updates, transaction control', 'Demonstrates how to perform the most important tasks of working with data in CachedUpdates mode, including highlighting uncommitted changes, managing transactions, and committing changes in a batch.', 'General demos', TCachedUpdatesFrame, 1);
  Demos.RegisterDemo('FilterAndIndex', 'Using Filter and IndexFieldNames', 'Demonstrates IBDAC''s local storage functionality. This sample shows how to perform local filtering, sorting and locating by multiple fields, including by calculated and lookup fields.', 'General demos', TFilterAndIndexFrame ,1);
  Demos.RegisterDemo('MasterDetail', 'Master/detail relationship', 'Uses IBDAC functionality to work with master/detail relationships. This sample shows how to use local master/detail functionality. Demonstrates different kinds of master/detail linking, inluding linking by SQL, by simple fields, and by calculated fields.', 'General demos', TMasterDetailFrame, 1);
{$IFNDEF FPC}
  Demos.RegisterDemo('Threads', 'Using IBDAC in multi-threaded environment', 'Demonstrates how IBDAC can be used in multithreaded applications. This sample allows you to set up several threads and test IBDAC''s performance with multithreading.', 'General demos', TThreadsFrame, 1);
{$ENDIF}

{$IFNDEF FPC}
  Demos.RegisterDemo('Arrays', 'Working with VARRAY type', 'Demonstrates IBDAC advanced support for working with InterBase Arrays. This sample shows how to load an array into a DataSet object, insert and delete values, and restrict read and write operations to array slices.', 'InterBase specific', TArraysFrame, 1);
  Demos.RegisterDemo('BlobPictures', 'Working with BLOB type', 'Uses IBDAC functionality to work with graphics. The sample demonstrates how to retrieve binary data from InterBase database and display it on visual components. Sample also shows how to load and save pictures to files and to the database.', 'InterBase specific', TBlobPicturesFrame, 1);
  Demos.RegisterDemo('DB_key', 'Using DB_KEY (Firebird 2.0 or higher)', 'Demonstrates using the RDB$DB_KEY field for modifying data when working with DataSets. This approach have some advantages: it allows editing tables that do not have primary key fields. ' + 'Also, performing updates in this way reduces server overhead, and gives a certain increase in performance.', 'InterBase specific', TDB_KeyFrame, 1);
{$ENDIF}
  Demos.RegisterDemo('LongStrings', 'Working with string fields', 'Demonstrates IBDAC functionality for working with long string fields (fields that have more than 256 characters). Shows the different ways they can be displayed as memo fields and string fields.', 'InterBase specific', TLongStringsFrame, 1);
  Demos.RegisterDemo('TextBlob', 'Working with blob type', 'Demonstrates working with InterBase BLOB data types. The sample shows how to get a character stream from a table, how to change text BLOB fields using UPDATE statements, and how to save and load data to/from a file. ' + 'It also demonstrates some different ways you can perform BLOB insertion and compression.', 'InterBase specific', TTextBlobFrame, 1);


  Demos.RegisterCategory('Miscellaneous', '', -1, True);
{$IFDEF CLR}
  Demos.RegisterDemo('AspNet', 'AspNet', 'Uses MyDataAdapter to create a simple ASP .NET application. This application creates an ASP.NET application that lets you connect to a database and execute queries.' + '  Shows how to display query results in a DataGrid and send user changes back to the database.', 'Miscellaneous', nil, 1, '', True);
{$ENDIF}
  Demos.RegisterDemo('FailOver', 'FailOver', 'Demonstrates the recommended approach to working with unstable networks. This sample lets you perform transactions and updates in several different modes, simulate a sudden session termination, ' + 'and view what happens to your data state when connections to the server are unexpectedly lost. Shows off CachedUpdates, LocalMasterDetail, FetchAll, Pooling, and different Failover modes.', 'Miscellaneous', nil, 1, '', True);
{$IFNDEF CLR}
  Demos.RegisterDemo('Midas', 'Midas', 'Demonstrates using MIDAS technology with IBDAC.  This project consists of two parts: a MIDAS server that processes requests to the database and a thin MIDAS client that displays an interactive grid.  ' + 'This demo shows how to build thin clients that display interactive components and delegate all database interaction to a server application for processing. ', 'Miscellaneous', nil, 1, '', True);
{$ENDIF}
{$IFDEF CLR}
  Demos.RegisterDemo('WinForms', 'WinForms', 'Shows how to use IBDAC to create a  WinForm application. This demo project creates a simple WinForms application and fills a data grid from an MyDataAdapter data source.', 'Miscellaneous', nil, 1, '', True);
{$ENDIF}
{$IFNDEF CLR}
  Demos.RegisterCategory('', '', -1, True);
{$ENDIF}

{$IFNDEF CLR}
  Demos.RegisterCategory('ThirdParty', '', -1, True);
  Demos.RegisterDemo('FastReport', 'FastReport', 'Demonstrates how IBDAC can be used with FastReport components. This project consists of two parts.  The first part is several packages that integrate IBDAC components into the FastReport editor.' + ' The second part is a demo application that lets you design and preview reports with IBDAC technology in the FastReport editor.', 'ThirdParty', nil, 1, '', True);
  Demos.RegisterDemo('InfoPower', 'InfoPower', 'Uses InfoPower components to display recordsets retrieved with DAC.  This demo project displays an InfoPower grid component and fills it with the result of an IBDAC query.' + '  Shows how to link IBDAC data sources to InfoPower components.', 'ThirdParty', nil, 1, '', True);
  Demos.RegisterDemo('ReportBuilder', 'ReportBuilder', 'Uses IBDAC data sources to create a ReportBuilder report that takes data from a MySQL database. This demo project shows how to set up a ReportBuilder document in design-time and how to integrate ' + 'IBDAC components into the Report Builder editor to perform document design in run-time.', 'ThirdParty', nil, 1, '', True);
  Demos.RegisterCategory('', '', -1, True);
{$ENDIF}
end;

procedure TIbDacForm.lbAboutClick(Sender: TObject);
begin
  inherited;

  with TIbDacAboutForm.Create(nil) do begin
    ShowModal;
    Free;
  end;
end;

procedure TIbDacForm.FormCreate(Sender: TObject);
begin
  inherited;

  scCreate.OnError := OnScriptError;
  scDrop.OnError := OnScriptError;
end;

procedure TIbDacForm.ExecCreateScript;
begin
  scCreate.Execute;
end;

procedure TIbDacForm.ExecDropScript;
begin
  scDrop.Execute;
end;

procedure TIbDacForm.cbDebugClick(Sender: TObject);
begin
  inherited;
  scCreate.Debug := cbDebug.Checked;
  scDrop.Debug := cbDebug.Checked;  
end;

{$IFDEF FPC}
initialization
  {$i IbDacDemoForm.lrs}
{$ENDIF}

end.
