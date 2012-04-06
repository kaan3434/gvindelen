
{******************************************}
{                                          }
{             FastScript v1.9              }
{        IBDAC classes and functions       }
{                                          }
{          Created by: Devart              }
{         E-mail: ibdac@devart.com         }
{                                          }
{******************************************}

unit fs_iibdacrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_idbrtti, fs_idacrtti, DB,
  MemUtils, IBCClasses, IBC, CRTypes, CRFunctions;

type
  TfsIBDACRTTI = class(TComponent); // fake component

implementation

type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
    procedure SetProp(Instance: TObject; ClassType: TClass;
      const PropName: String; Value: Variant);
  public
    constructor Create(AScript: TfsScript); override;
  end;

{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  
  with AScript do begin
    with AddClass(TIBCConnection, 'TCustomDAConnection') do begin
      AddMethod('procedure ExecProc(Name: string; const Params: array of variant)', CallMethod);
      AddMethod('function ExecSQLEx(Text: string; const Params: array of variant): variant', CallMethod);
      AddMethod('procedure ExecProcEx(Name: string; const Params: array of variant)', CallMethod);
      AddMethod('procedure GetGeneratorNames(List: TStrings)', CallMethod);
      AddMethod('procedure CommitRetaining', CallMethod);
      AddMethod('procedure RollbackRetaining', CallMethod);
      AddMethod('procedure CreateDatabase', CallMethod);
      AddMethod('procedure DropDatabase', CallMethod);

      AddProperty('Handle', 'Pointer', GetProp);
      AddProperty('IsReadOnly', 'Boolean', GetProp);
      AddProperty('DBSQLDialect', 'Integer', GetProp);
      AddProperty('LastError', 'integer', GetProp, SetProp);
    end;
    AddClass(TIBCConnectionOptions, 'TDAConnectionOptions');
    AddEnum('TIBCProtocol', 'TCP, NetBEUI, SPX');

    with AddClass(TCustomIBCDataSet, 'TCustomDADataSet') do begin
      AddMethod('procedure Lock', CallMethod);
      AddMethod('procedure Unlock', CallMethod);
      AddMethod('function QueryKeyFields(TableName: string; List: TStrings): string', CallMethod);
    end;
    AddClass(TIBCParams, 'TDAParams');
    AddEnum('TGeneratorMode', 'gmInsert, gmPost');
    AddEnum('TLockMode', 'lmNone, lmLockImmediate, lmLockDelayed');
    
    AddClass(TIBCQuery, 'TCustomIBCDataSet');
    
    with AddClass(TIBCTable, 'TCustomIBCDataSet') do begin
      AddMethod('procedure PrepareSQL', CallMethod);
      AddMethod('procedure EmptyTable', CallMethod);
      AddMethod('procedure DeleteTable', CallMethod);
      AddProperty('Exists', 'Boolean', GetProp);
    end;

    with AddClass(TIBCStoredProc, 'TCustomIBCDataSet') do begin
      AddMethod('procedure PrepareSQL(IsQuery: boolean)', CallMethod); 
      AddMethod('procedure ExecProc', CallMethod);
    end;
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  List: _TStringList;
begin
  Result := 0;

  if ClassType = TIBCConnection then begin
    if MethodName = 'EXECPROC' then
      TIBCConnection(Instance).ExecProc(Caller.Params[0], [Caller.Params[1]])
    else
    if MethodName = 'EXECSQLEX' then
      Result := TIBCConnection(Instance).ExecSQLEx(Caller.Params[0], [Caller.Params[1]])
    else
    if MethodName = 'EXECPROCEX' then
      TIBCConnection(Instance).ExecProcEx(Caller.Params[0], [Caller.Params[1]])
    else
    if MethodName = 'GETGENERATORNAMES' then begin
      List := _TStringList.Create;
      try
        TIBCConnection(Instance).GetGeneratorNames(List);
        AssignStrings(List, TStrings(Integer(Caller.Params[0])));
      finally
        List.Free;
      end;
    end
    else
    if MethodName = 'COMMITRETAINING' then
      TIBCConnection(Instance).CommitRetaining
    else
    if MethodName = 'ROLLBACKRETAINING' then
      TIBCConnection(Instance).RollbackRetaining
    else
    if MethodName = 'CREATEDATABASE' then
      TIBCConnection(Instance).CreateDatabase
    else
    if MethodName = 'DROPDATABASE' then
      TIBCConnection(Instance).DropDatabase;
  end
  else
  if ClassType = TCustomIBCDataSet then begin
    if MethodName = 'LOCK' then
      TCustomIBCDataSet(Instance).Lock
    else
    if MethodName = 'UNLOCK' then
      TCustomIBCDataSet(Instance).Unlock
    else
    if MethodName = 'QUERYKEYFIELDS' then begin
      List := _TStringList.Create;
      try
        Result := TCustomIBCDataSet(Instance).QueryKeyFields(Caller.Params[0], List);
        AssignStrings(List, TStrings(Integer(Caller.Params[1])));
      finally
        List.Free;
      end;
    end;
  end
  else
  if ClassType = TIBCTable then begin
    if MethodName = 'PREPARESQL' then
      TIBCTable(Instance).PrepareSQL
    else
    if MethodName = 'EMPTYTABLE' then
      TIBCTable(Instance).EmptyTable
    else
    if MethodName = 'DELETETABLE' then
      TIBCTable(Instance).DeleteTable;
  end
  else
  if ClassType = TIBCStoredProc then begin
    if MethodName = 'PREPARESQL' then
      TIBCStoredProc(Instance).PrepareSQL(Caller.Params[0])
    else
    if MethodName = 'EXECPROC' then
      TIBCStoredProc(Instance).ExecProc;
  end;
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TIBCConnection then begin
    if PropName = 'HANDLE' then
      Result := Integer(TIBCConnection(Instance).Handle)
    else
    if PropName = 'ISREADONLY' then
      Result := TIBCConnection(Instance).IsReadOnly
    else
    if PropName = 'DBSQLDIALECT' then
      Result := TIBCConnection(Instance).DBSQLDialect
    else
    if PropName = 'LASTERROR' then
      Result := TIBCConnection(Instance).LastError;
  end
  else
  if ClassType = TIBCTable then begin
    if PropName = 'EXISTS' then
      Result := TIBCTable(Instance).Exists;
  end;
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TIBCConnection then begin
    if PropName = 'LASTERROR' then
      TIBCConnection(Instance).LastError := Value;
  end;
end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.

