
{******************************************}
{                                          }
{             FastScript v1.9              }
{         IBDAC Registration unit          }
{                                          }
{          Created by: Devart              }
{         E-mail: ibdac@devart.com         }
{                                          }
{******************************************}

unit fs_iibdacreg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  Classes
{$IFNDEF Delphi6}
, DsgnIntf
{$ELSE}
, DesignIntf
{$ENDIF}
, fs_iibdacrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('FastScript', [TfsIBDACRTTI]);
end;

end.
