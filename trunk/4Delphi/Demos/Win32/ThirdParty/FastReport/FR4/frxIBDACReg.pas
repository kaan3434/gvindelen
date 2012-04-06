
{******************************************}
{                                          }
{             FastReport v4.0              }
{       IBDAC components registration      }
{                                          }

// Created by: Devart
// E-mail: ibdac@devart.com

{                                          }
{******************************************}

unit frxIBDACReg;

interface

{$I frx.inc}

procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes
{$IFNDEF Delphi6}
, DsgnIntf
{$ELSE}
, DesignIntf, DesignEditors
{$ENDIF}
, frxIBDACComponents;

procedure Register;
begin
  RegisterComponents('FastReport 4.0', [TfrxIBDACComponents]);
end;

end.
