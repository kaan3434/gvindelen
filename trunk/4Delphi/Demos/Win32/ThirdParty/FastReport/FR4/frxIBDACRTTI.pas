{******************************************}
{                                          }
{             FastReport v4.0              }
{          IbDAC components RTTI           }
{                                          }

// Created by: Devart
// E-mail: ibdac@devart.com

{                                          }
{******************************************}

unit frxIBDACRTTI;

interface

{$I frx.inc}

implementation

uses
  Windows, Classes, fs_iinterpreter, frxIBDACComponents
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;

{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddClass(TfrxIBDACDatabase, 'TfrxCustomDatabase');
    AddClass(TfrxIBDACTable, 'TfrxCustomTable');
    with AddClass(TfrxIBDACQuery, 'TfrxCustomQuery') do
      AddMethod('procedure ExecSQL', CallMethod);
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;
  if ClassType = TfrxIBDACQuery then
  begin
    if MethodName = 'EXECSQL' then
      TfrxIBDACQuery(Instance).Query.Execute;
  end
end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
