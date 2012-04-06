
{$I IbDac.inc}

{$DEFINE FMX}

unit IbDacFmx;

interface

uses
  Classes, SysUtils, DB, 
{$IFDEF MSWINDOWS}
  Winapi.Windows, System.Win.Registry,
{$ENDIF}
  MemUtils, CRParser, CRTypes, DBAccess, DacFmx,
  IBCConnectFormFmx, IBC, IBCClasses, IBCServices;

{$I IbDacGui.inc}
