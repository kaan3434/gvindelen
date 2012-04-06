
{******************************************}
{                                          }
{             FastReport v3.0              }
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
  IBC, frxIBDACComponents, frxDACEditor
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxIBTableNameProperty = class(TfrxTableNameProperty)
  public
    procedure GetValues; override;
  end;

{ TfrxIbTableNameProperty }

procedure TfrxIBTableNameProperty.GetValues;
begin
  inherited;
  with TfrxIBDACTable(Component).Table do
    if Connection <> nil then
      Connection.GetTableNames(Values);
end;

initialization
  frxPropertyEditors.Register(TypeInfo(TfrxIBDACDatabase), TfrxIBDACTable, 'Database',
    TfrxDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(TfrxIbDACDatabase), TfrxIbDACQuery, 'Database',
    TfrxDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxIbDACTable, 'TableName',
    TfrxTableNameProperty);

end.
