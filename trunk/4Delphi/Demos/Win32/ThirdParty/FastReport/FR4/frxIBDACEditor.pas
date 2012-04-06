
{******************************************}
{                                          }
{             FastReport v4.0              }
{      IbDAC components design editors     }
{                                          }

// Created by: Devart
// E-mail: ibdac@devart.com

{                                          }
{******************************************}

unit frxIBDACEditor;

interface

{$I frx.inc}

implementation

uses
  Windows, Classes, SysUtils, Forms, Dialogs, frxCustomDB, frxDsgnIntf, frxRes, 
  IBC, MemUtils, frxIBDACComponents, frxDACEditor, CRTypes, CRFunctions
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxIBDatabaseProperty = class(TfrxComponentProperty)
  public
    function GetValue: String; override;
  end;

  TfrxIBTableNameProperty = class(TfrxTableNameProperty)
  public
    procedure GetValues; override;
  end;

{ TfrxIBDatabaseProperty }

function TfrxIBDatabaseProperty.GetValue: String;
var
  db: TfrxIBDACDatabase;
begin
  db := TfrxIBDACDatabase(GetOrdValue);
  if db = nil then begin
    if (IBDACComponents <> nil) and (IBDACComponents.DefaultDatabase <> nil) then
      Result := IBDACComponents.DefaultDatabase.Name
    else
      Result := frxResources.Get('prNotAssigned');
  end
  else
    Result := inherited GetValue;
end;

{ TfrxIbTableNameProperty }

procedure TfrxIBTableNameProperty.GetValues;
var
  List: _TStringList;
begin
  inherited;
  with TfrxIBDACTable(Component).Table do
    if Connection <> nil then begin
      List := _TStringList.Create;
      try
        Connection.GetTableNames(List);
        AssignStrings(List, Values);
      finally
        List.Free;
      end;
    end;
end;

initialization
  frxPropertyEditors.Register(TypeInfo(TfrxIBDACDatabase), TfrxIBDACTable, 'Database',
    TfrxIBDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(TfrxIBDACDatabase), TfrxIBDACQuery, 'Database',
    TfrxIBDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxIBDACTable, 'TableName',
    TfrxIBTableNameProperty);

end.
