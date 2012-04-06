{$I IbDac.inc}
unit IbDacClx;

interface

uses
 {$IFDEF MSWINDOWS}
  Windows, Registry,
{$ENDIF}
  SysUtils, Classes, CRTypes, DacClx, DBAccess, IBCConnectForm, IBC,
  IBCCall, CRParser, IBCClasses, IBCServices, DB;

{$I IbDacGui.inc}

