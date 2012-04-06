{$IFNDEF CLR}
{$I IbDac.inc}
unit IbDacVcl;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Registry,
{$ENDIF}
  SysUtils, Classes, DacVcl, DBAccess, IBCConnectForm, IBC,
  IBCCall, CRTypes, CRParser, IBCClasses, IBCServices, DB;

{$I IbDacGui.inc}



