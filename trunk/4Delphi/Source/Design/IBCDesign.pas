//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBDAC Design
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCDesign;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages, Registry, IBCAlerter,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls,
{$IFDEF CLR}
  Borland.Vcl.Design.DesignEditors, Borland.Vcl.Design.DesignIntf,
  Borland.Vcl.Design.FldLinks,
{$ELSE}
{$IFDEF FPC}
  PropEdits, ComponentEditors,
{$ELSE}
  {$IFDEF VER6P}DesignIntf, DesignEditors,{$ELSE}DsgnIntf,{$ENDIF}
  {$IFNDEF BCB}{$IFDEF VER5P}FldLinks,{$ENDIF} ColnEdit,{$ENDIF}
{$ENDIF}
{$ENDIF}

  SysUtils, Classes, TypInfo,
{$IFNDEF STD}
  IBCLoader, IBCAdmin,
{$ENDIF}
  CRTypes, CRDesign, DADesign, DBAccess, DALoader, DAAlerter, IBC;


{ ------------  IbDac property editors ----------- }
type
  TIBFileNameProperty = class(TStringProperty)
  protected
    procedure GetDialogOptions(Dialog: TOpenDialog); virtual;
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TIBCClientLibraryProperty = class(TStringProperty)
  protected
    procedure GetDialogOptions(Dialog: TOpenDialog); virtual;
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TIBCConnectionOptionsCharsetProperty = class(TStringProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
    function GetAttributes: TPropertyAttributes; override;
    function AutoFill: boolean; override;
  end;

  TIBCTransactionProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TIBCKeyGeneratorProperty = class(TXStringProperty)
  public
    procedure GetValues(Proc: TGetXStrProc); override;
    function GetAttributes: TPropertyAttributes; override;
    function AutoFill: boolean; override;
  end;
{ ------------  IbDac component editors ----------- }
  TIBCConnectionEditor = class(TDAConnectionEditor)
  protected
  {$IFNDEF VER6P}
    procedure ShowDefaultTransactionEditor;
  {$ENDIF}
    procedure InitVerbs; override;
  end;

  TIBCTransactionEditor = class(TDAComponentEditor)
  protected
    procedure InitVerbs; override;
  end;

  TIBCSQLEditor = class(TDASQLEditor)
  protected
    procedure InitVerbs; override;
  end;

  TIBCDataSetEditor = class(TDAComponentEditor);

  TIBCQueryEditor = class(TIBCDataSetEditor)
  protected
    procedure InitVerbs; override;
  end;

  TIBCTableEditor = class(TIBCDataSetEditor)
  protected
    procedure InitVerbs; override;
  end;

  TIBCStoredProcEditor = class(TIBCDataSetEditor)
  protected
    procedure InitVerbs; override;
  end;

  TIBCUpdateSQLEditor = class(TDAUpdateSQLEditor)
  protected
    procedure InitVerbs; override;
  end;

  TIBCScriptEditor = class(TDAScriptEditor)
  protected
    procedure InitVerbs; override;
  end;

{$IFDEF MSWINDOWS}
  TIBCAlerterEditor = class(TDAComponentEditor)
  protected
    procedure InitVerbs; override;
  end;
{$ENDIF}

{$IFNDEF STD}
  TIBCServiceEditor = class(TDAComponentEditor)
  protected
    procedure InitVerbs; override;
  end;
{$ENDIF}

{$IFNDEF FPC}
  TIBCConnectionList = class (TDAConnectionList)
  protected
    function GetConnectionType: TCustomDAConnectionClass; override;
  end;

{$IFDEF VER6P}
  TIBCDesignNotification = class(TDADesignNotification)
  public
    procedure ItemInserted(const ADesigner: IDesigner; AItem: TPersistent); override;
    function CreateConnectionList: TDAConnectionList; override;
    function GetConnectionPropertyName: string; override;
  end;
{$ENDIF}
{$ENDIF}

procedure Register;

implementation

uses
{$IFDEF MSWINDOWS}
{$IFNDEF FPC}
  IBCMenu,
{$ENDIF}
  IBCAlerterEditor,
{$IFDEF CLR}
  WinUtils,
{$ENDIF}
{$ENDIF}
  DB, DAScript, DAScriptEditor,
  IBCConnectionEditor, IBCTransactionEditor, IBCSQLEditor, IBCQueryEditor, IBCTableEditor,
  IBCStoredProcEditor, IBCUpdateSQLEditor, IBCScript, IBCDesignUtils;

{ TIBCCharsetProperty }

procedure TIBCConnectionOptionsCharsetProperty.GetValues(Proc: TGetStrProc);
var
  i: integer;
  List: TStringList;
  Persistent: TPersistent;
begin
  Assert(PropCount > 0, 'PropCount = 0');
  Persistent := GetComponent(0) as TPersistent;
  Assert(Persistent is TIBCConnectionOptions, Persistent.ClassName);
  List := TStringList.Create;
  try
    GetCharsetList(TIBCConnection(TDBAccessUtils.FOwner(Persistent as TIBCConnectionOptions)), List);
    for i := 0 to List.Count - 1 do
      Proc(List.Strings[i]);
  finally
    List.Free;
  end;
end;

function TIBCConnectionOptionsCharsetProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TIBCConnectionOptionsCharsetProperty.AutoFill: boolean;
begin
  Result := False;
end;

{ TIBFileNameProperty }

procedure TIBFileNameProperty.GetDialogOptions(Dialog: TOpenDialog);
begin
{$IFDEF MSWINDOWS}
  Dialog.Filter := 'InterBase Database Files (*.gdb)|*.gdb|Firebird Database Files (*.fdb)|*.fdb|InterBase 7 Database Files (*.ib)|*.ib|All Files (*.*)|*.*';
{$ELSE}
  Dialog.Filter := 'All Files (*)|*';
{$ENDIF}
  Dialog.Options := Dialog.Options + [ofFileMustExist];
end;

procedure TIBFileNameProperty.Edit;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  GetDialogOptions(OpenDialog);
  if OpenDialog.Execute then
    SetValue(OpenDialog.FileName);
  OpenDialog.Free;
end;

function TIBFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paRevertable, paDialog, paMultiSelect];
end;

{ TIBCClientLibraryProperty }

procedure TIBCClientLibraryProperty.GetDialogOptions(Dialog: TOpenDialog);
begin
{$IFDEF MSWINDOWS}
  Dialog.Filter := 'Dynamic link library (*.dll)|*.dll|All Files (*.*)|*.*';
{$ELSE}
  Dialog.Filter := 'All Files (*)|*';
{$ENDIF}
  Dialog.Options := Dialog.Options + [ofFileMustExist];
end;

procedure TIBCClientLibraryProperty.Edit;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  GetDialogOptions(OpenDialog);
  if OpenDialog.Execute then
    SetValue(OpenDialog.FileName);
  OpenDialog.Free;
end;

function TIBCClientLibraryProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paRevertable, paDialog, paMultiSelect];
end;

{ TIBCTransactionProperty }

function TIBCTransactionProperty.GetValue: string;
var
  Component: TComponent;
  Transaction: TDATransaction;
  FTransaction: TDATransaction;
begin
  Component := GetComponent(0) as TComponent;
  FTransaction := nil;
  Transaction := nil;
  if Component is TCustomDADataSet then begin
    FTransaction := TDBAccessUtils.GetFTransaction(TCustomDADataSet(Component));
    Transaction := TDBAccessUtils.GetTransaction(TCustomDADataSet(Component));
  end
  else
  if Component is TCustomDASQL then begin
    FTransaction := TDBAccessUtils.GetFTransaction(TCustomDASQL(Component));
    Transaction := TDBAccessUtils.GetTransaction(TCustomDASQL(Component));
  end
  else
  if Component is TDAMetaData then begin
    FTransaction := TDBAccessUtils.GetFTransaction(TDAMetaData(Component));
    Transaction := TDBAccessUtils.GetTransaction(TDAMetaData(Component));
  end
  else
  if Component is TDAScript then begin
    FTransaction := TDBAccessUtils.GetFTransaction(TDAScriptUtils.GetCommand(TDAScript(Component)));
    Transaction := TDAScriptUtils.GetTransaction(TDAScript(Component));
  end
  else
  if Component is TDALoader then begin
    FTransaction := TDALoaderUtils.GetFTransaction(TDALoader(Component));
    Transaction := TDALoaderUtils.GetTransaction(TDALoader(Component));
  end
  else
  if Component is TDAAlerter then begin
    FTransaction := TDAAlerterUtils.GetFTransaction(TDAAlerter(Component));
    Transaction := TDAAlerterUtils.GetTransaction(TDAAlerter(Component));
  end
  else
  if Component is TCustomDAConnection then
    FTransaction := TDBAccessUtils.GetFDefaultTransaction(TCustomDAConnection(Component))
  else
    Assert(False);

  if (Component is TCustomDAConnection) then begin
    if (FTransaction = nil) then
      Result := '<Default>'
    else
      Result := inherited GetValue;
  end
  else begin
    if (FTransaction = nil) and (Transaction <> nil) then
      Result := '<Default>'
    else
      Result := inherited GetValue;
  end;
end;

procedure TIBCTransactionProperty.SetValue(const Value: string);
var
  Component: TComponent;
begin
  if Value = '<Default>' then begin
    Component := GetComponent(0) as TComponent;
    if Component is TCustomDADataSet then
      TDBAccessUtils.SetTransaction(TCustomDADataSet(Component), nil)
    else
    if Component is TCustomDASQL then
      TDBAccessUtils.SetTransaction(TCustomDASQL(Component), nil)
    else
    if Component is TDAScript then
      TDAScriptUtils.SetTransaction(TDAScript(Component), nil)
    else
    if Component is TDAMetaData then
      TDBAccessUtils.SetTransaction(TDAMetaData(Component), nil)
    else
    if Component is TDALoader then
      TDALoaderUtils.SetTransaction(TDALoader(Component), nil)
    else
    if Component is TDAAlerter then
      TDAAlerterUtils.SetTransaction(TDAAlerter(Component), nil)
    else
    if Component is TCustomDAConnection then
      TDBAccessUtils.SetDefaultTransaction(TCustomDAConnection(Component), nil)
    else
      Assert(False);
    Modified;
  end
  else
    inherited SetValue(Value);
end;

procedure TIBCTransactionProperty.GetValues(Proc: TGetStrProc);
begin
  Proc('<Default>');
  inherited GetValues(Proc);
end;

{ TIBCKeyGeneratorProperty }

procedure TIBCKeyGeneratorProperty.GetValues(Proc: TGetXStrProc);
var
  List: _TStringList;
  Component: TComponent;
  i: Integer;
begin
  Assert(PropCount > 0, 'PropCount = 0');
  Component := GetComponent(0) as TComponent;
  Assert(Component is TCustomIBCDataSet, Component.ClassName);

  if TCustomIBCDataSet(Component).Connection = nil then
    Exit;
  List := _TStringList.Create;
  try
    TCustomIBCDataSet(Component).Connection.GetGeneratorNames(List);
    List.Sort;
    for i := 0 to List.Count - 1 do
      Proc(List[i]);
  finally
    List.Free;
  end;
end;

function TIBCKeyGeneratorProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TIBCKeyGeneratorProperty.AutoFill: boolean;
begin
  Result := False;
end;

{ TIBCConnectionEditor }

procedure TIBCConnectionEditor.InitVerbs;
begin
  inherited;
  AddVerb('Connection Editor...', TIBCConnectionEditorForm, TIBCDesignUtils);
{$IFNDEF VER6P}
  AddVerb('DefaultTransaction Editor...', ShowDefaultTransactionEditor);
end;

procedure TIBCConnectionEditor.ShowDefaultTransactionEditor;
begin
  ShowEditorEx(TIBCTransactionEditorForm, TIBCDesignUtils, (Component as TIBCConnection).DefaultTransaction, Designer);
end;

{$ELSE}
end;
{$ENDIF}

{ TIBCTransactionEditor }

procedure TIBCTransactionEditor.InitVerbs;
begin
  inherited;
  AddVerb('Transaction Editor...', TIBCTransactionEditorForm, TIBCDesignUtils);
end;

{ TIBCSQLEditor }

procedure TIBCSQLEditor.InitVerbs;
begin
  inherited;
  AddVerb('IBCSQL E&ditor...', TIBCSQLEditorForm, TIBCDesignUtils);
end;

{ TIBCQueryEditor }

procedure TIBCQueryEditor.InitVerbs;
begin
  AddVerb('Fields &Editor...', ShowFieldsEditor);
  AddVerb('IBCQuery E&ditor...', TIBCQueryEditorForm, TIBCDesignUtils);
  AddVerb('Data Editor...', ShowDataEditor);

  inherited;
end;

{ TIBCTableEditor }

procedure TIBCTableEditor.InitVerbs;
begin
  AddVerb('Fields &Editor...', ShowFieldsEditor);
  AddVerb('IBCTable E&ditor...', TIBCTableEditorForm, TIBCDesignUtils);
  AddVerb('Data Editor...', ShowDataEditor);

  inherited;
end;

procedure TIBCStoredProcEditor.InitVerbs;
begin
  AddVerb('Fields &Editor...', ShowFieldsEditor);
  AddVerb('IBCStoredProc E&ditor...', TIBCStoredProcEditorForm, TIBCDesignUtils);
  AddVerb('Data Editor...', ShowDataEditor);

  inherited;
end;

procedure TIBCUpdateSQLEditor.InitVerbs;
begin
  inherited;
  AddVerb('IBCUpdateSQL E&ditor...', TIBCUpdateSQLEditorForm, TIBCDesignUtils);
end;

procedure TIBCScriptEditor.InitVerbs;
begin
  inherited;
  AddVerb('IBCScript E&ditor...', TDAScriptEditorForm, TIBCDesignUtils);
end;

{$IFDEF MSWINDOWS}
procedure TIBCAlerterEditor.InitVerbs;
begin
  inherited;
  AddVerb('IBCAlerter E&ditor...', TIBCAlerterEditorForm, TIBCDesignUtils);
end;
{$ENDIF}

{$IFNDEF STD}
procedure TIBCServiceEditor.InitVerbs;
begin
  inherited;
  AddVerb('Service E&ditor...', TIBCConnectionEditorForm, TIBCDesignUtils);
end;
{$ENDIF}

{$IFNDEF FPC}
function TIBCConnectionList.GetConnectionType: TCustomDAConnectionClass;
begin
  Result := TIBCConnection;
end;

{$IFDEF VER6P}
procedure TIBCDesignNotification.ItemInserted(const ADesigner: IDesigner; AItem: TPersistent);
begin
  if (AItem <> nil) and ((AItem is TCustomIBCDataSet) or (AItem is TIBCSQl) or (AItem is TIBCTransaction)
    or (AItem is TIBCScript){$IFDEF MSWINDOWS} or (AItem is TIBCAlerter) {$ENDIF}
    or (AItem is TIBCDataSource) or (AItem is TIBCMetaData)
  {$IFNDEF STD}
    or (AItem is TIBCLoader)
  {$ENDIF}
    )
  then
    FItem := AItem;
end;

function TIBCDesignNotification.CreateConnectionList: TDAConnectionList;
begin
  Result := TIBCConnectionList.Create;
end;

function TIBCDesignNotification.GetConnectionPropertyName: string;
begin
  if (FItem <> nil) and (FItem is TIBCTransaction) then
    Result := 'DefaultConnection'
  else
    Result := 'Connection';
end;
{$ENDIF}
{$ENDIF}

procedure Register;
begin
  // Register property editors
  RegisterPropertyEditor(TypeInfo(String), TIBCConnectionOptions, 'Charset', TIBCConnectionOptionsCharsetProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), TIBCConnection, 'Params', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(String), TIBCConnection, 'Database', TIBFileNameProperty);
{$IFNDEF CLR}
  RegisterPropertyEditor(TypeInfo(String), TIBCConnection, 'ClientLibrary', TIBCClientLibraryProperty);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(TStrings), TIBCTransaction, 'Params', TDAPropertyEditor);

  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCQuery, 'SQL', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCQuery, 'SQLDelete', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCQuery, 'SQLInsert', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCQuery, 'SQLLock', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCQuery, 'SQLRefresh', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCQuery, 'SQLUpdate', TDAPropertyEditor);

  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCSQL, 'SQL', TDAPropertyEditor);

  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCScript, 'SQL', TDAPropertyEditor);

  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCStoredProc, 'SQLDelete', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCStoredProc, 'SQLInsert', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCStoredProc, 'SQLRefresh', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCStoredProc, 'SQLUpdate', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCStoredProc, 'SQLLock', TDAPropertyEditor);

  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCUpdateSQL, 'InsertSQL', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCUpdateSQL, 'ModifySQL', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCUpdateSQL, 'DeleteSQL', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TIBCUpdateSQL, 'RefreshSQL', TDAPropertyEditor);

  RegisterPropertyEditor(TypeInfo(TIBCTransaction), TIBCQuery, 'Transaction', TIBCTransactionProperty);
  RegisterPropertyEditor(TypeInfo(TIBCTransaction), TIBCSQL, 'Transaction', TIBCTransactionProperty);
  RegisterPropertyEditor(TypeInfo(TIBCTransaction), TIBCTable, 'Transaction', TIBCTransactionProperty);
  RegisterPropertyEditor(TypeInfo(TIBCTransaction), TIBCStoredProc, 'Transaction', TIBCTransactionProperty);
  RegisterPropertyEditor(TypeInfo(TIBCTransaction), TIBCScript, 'Transaction', TIBCTransactionProperty);
{$IFNDEF STD}
  RegisterPropertyEditor(TypeInfo(TIBCTransaction), TIBCLoader, 'Transaction', TIBCTransactionProperty);
{$ENDIF}
  RegisterPropertyEditor(TypeInfo(TIBCTransaction), TIBCConnection, 'DefaultTransaction', TIBCTransactionProperty);

  RegisterPropertyEditor(TypeInfo(_string), TCustomIBCDataSet, 'KeyGenerator', TIBCKeyGeneratorProperty);
{$IFDEF MSWINDOWS}
  RegisterPropertyEditor(TypeInfo(TStrings), TIBCAlerter, 'Events', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TIBCTransaction), TIBCAlerter, 'Transaction', TIBCTransactionProperty);
{$ENDIF}
{$IFNDEF STD}
  RegisterPropertyEditor(TypeInfo(_string), TCustomIBCService, 'Password', TDAPasswordProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), TCustomIBCService, 'Params', TDAPropertyEditor);
{$ENDIF}

// Obsolete properties
  RegisterPropertyEditor(TypeInfo(Boolean), TIBCConnection, 'ConnectPrompt', nil);

  // Register component editors
  DARegisterComponentEditor(TIBCConnection, TIBCConnectionEditor, TIBCConnectionEditorForm, TIBCDesignUtils);
  DARegisterComponentEditor(TIBCTransaction, TIBCTransactionEditor, TIBCTransactionEditorForm, TIBCDesignUtils);
  DARegisterComponentEditor(TIBCSQL, TIBCSQLEditor, TIBCSQLEditorForm, TIBCDesignUtils);
  DARegisterComponentEditor(TIBCQuery, TIBCQueryEditor, TIBCQueryEditorForm, TIBCDesignUtils);
  DARegisterComponentEditor(TIBCTable, TIBCTableEditor, TIBCTableEditorForm, TIBCDesignUtils);
  DARegisterComponentEditor(TIBCStoredProc, TIBCStoredProcEditor, TIBCStoredProcEditorForm, TIBCDesignUtils);
  DARegisterComponentEditor(TIBCUpdateSQL, TIBCUpdateSQLEditor, TIBCUpdateSQLEditorForm, TIBCDesignUtils);
  DARegisterComponentEditor(TIBCScript, TIBCScriptEditor, TDAScriptEditorForm, TIBCDesignUtils);
  // DAComponentEditor is needed to display session select dialog with Delphi 5
  DARegisterComponentEditor(TIBCMetaData, TDAComponentEditor, nil, TIBCDesignUtils);
{$IFDEF MSWINDOWS}
  DARegisterComponentEditor(TIBCAlerter, TIBCAlerterEditor, TIBCAlerterEditorForm, TIBCDesignUtils);
{$ENDIF}
{$IFNDEF STD}
  DARegisterComponentEditor(TIBCLoader, TDALoaderEditor, nil, TIBCDesignUtils);
  DARegisterComponentEditor(TCustomIBCService, TIBCServiceEditor, TIBCConnectionEditorForm, TIBCDesignUtils);
{$ENDIF}

{$IFNDEF FPC}
  Menu.AddItems({$IFDEF CLR}WinUtils{$ELSE}SysInit{$ENDIF}.HInstance);
{$ENDIF}

{$IFNDEF FPC}
  DARegisterComponentEditor(TIBCDataSource, TCRDataSourceEditor, nil, TIBCDesignUtils);
{$ENDIF}
end;

{$IFNDEF FPC}
{$IFDEF VER6P}
var
  Notificator: TIBCDesignNotification;
{$ENDIF}  
{$ENDIF}

initialization
{$IFDEF VER6P}
{$IFNDEF FPC}
  Notificator := TIBCDesignNotification.Create;
  RegisterDesignNotification(Notificator);
{$ENDIF}
{$ENDIF}


{$IFDEF VER6P}
{$IFNDEF FPC}
  UnRegisterDesignNotification(Notificator);
{$ENDIF}
{$ENDIF}

end.
