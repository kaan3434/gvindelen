
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBDAC registration
//////////////////////////////////////////////////

{$IFNDEF CLR}
{$I IbDac.inc}

unit IBCReg;
{$ENDIF}
interface
uses
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Classes, IBC, IBCScript, IBCSQLMonitor,
{$IFDEF MSWINDOWS}
  IBCAlerter,
{$ENDIF}
  IbDacVcl
  {$IFDEF VER16P}, IbDacFmx{$ENDIF};

procedure Register;

implementation

{$IFNDEF FPC}
{$IFNDEF CLR}
  {$IFDEF VER9}
    {$R IBCDesign9.res}
  {$ELSE}
    {$R IBCDesign.res}
  {$ENDIF}
  {$IFDEF VER10P}
    {$R IBCDesign10p.res}
  {$ENDIF}
{$ENDIF}
{$ENDIF}

uses
{$IFNDEF STD}
  IBCLoader, IBCAdmin,
{$ENDIF}
  DB, DBAccess, DacReg;

procedure Register;
begin
{$IFNDEF STD}
  RegisterCRBatchMove;
{$ENDIF}

  RegisterComponents('InterBase Access', [TIBCConnection]);
  RegisterComponents('InterBase Access', [TIBCTransaction]);
  RegisterComponents('InterBase Access', [TIBCQuery]);
  RegisterComponents('InterBase Access', [TIBCTable]);
  RegisterComponents('InterBase Access', [TIBCStoredProc]);
  RegisterComponents('InterBase Access', [TIBCSQL]);
  RegisterComponents('InterBase Access', [TIBCScript]);
  RegisterComponents('InterBase Access', [TIBCUpdateSQL]);
  RegisterComponents('InterBase Access', [TIBCDataSource]);
{$IFDEF MSWINDOWS}
  RegisterComponents('InterBase Access', [TIBCAlerter]);
{$ENDIF}
{$IFNDEF STD}
  RegisterComponents('InterBase Access', [TIBCLoader]);
{$ENDIF}
  RegisterComponents('InterBase Access', [TIBCMetaData]);
  RegisterComponents('InterBase Access', [TIBCSQLMonitor]);
  RegisterComponents('InterBase Access', [TIBCConnectDialog]);
{$IFDEF VER16P}
  RegisterComponents('InterBase Access', [TIBCConnectDialogFmx]);
{$ENDIF}

{$IFNDEF STD}
  RegisterComponents('InterBase Services', [TIBCConfigService]);
  RegisterComponents('InterBase Services', [TIBCBackupService]);
  RegisterComponents('InterBase Services', [TIBCRestoreService]);
  RegisterComponents('InterBase Services', [TIBCValidationService]);
  RegisterComponents('InterBase Services', [TIBCStatisticalService]);
  RegisterComponents('InterBase Services', [TIBCLogService]);
  RegisterComponents('InterBase Services', [TIBCSecurityService]);
  RegisterComponents('InterBase Services', [TIBCServerProperties]);
  RegisterComponents('InterBase Services', [TIBCLicensingService]);
  RegisterComponents('InterBase Services', [TIBCTraceService]);
{$ENDIF}
end;

initialization
{$IFDEF FPC}
{$I IBCDesign.lrs}
{$ENDIF}

end.

