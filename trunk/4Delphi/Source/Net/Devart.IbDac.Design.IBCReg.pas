{$I ..\IbDac.inc}

unit Devart.IbDac.Design.IBCReg;

{$R ..\..\Images\Devart.IbDac.Design.CRIbDacHelpItem.bmp}
{$R ..\..\Images\Devart.IbDac.Design.CRIbDacFAQItem.bmp}
{$R ..\..\Images\Devart.IbDac.Design.CRIbDacHomePageItem.bmp}
{$R ..\..\Images\Devart.IbDac.Design.CRIbDacPageItem.bmp}
{$R ..\..\Images\Devart.IbDac.Design.IbDacDBMonitorItem.bmp}

{$IFDEF VER10P}

{$IFNDEF STD}
{$R ..\..\Images\Devart.Dac.CRBatchMove.TCRBatchMove.bmp}
{$R ..\..\Images\Devart.Dac.CRBatchMove.TCRBatchMove16.bmp}
{$R ..\..\Images\Devart.Dac.CRBatchMove.TCRBatchMove32.bmp}
{$ENDIF}

{$R ..\..\Images\Devart.IbDac.IBC.TIBCConnection.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCQuery.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCSQL.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCStoredProc.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCTable.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCUpdateSQL.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCDataSource.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCMetaData.bmp}
{$R ..\..\Images\Devart.IbDac.IBCScript.TIBCScript.bmp}
{$R ..\..\Images\Devart.IbDac.IBCSQLMonitor.TIBCSQLMonitor.bmp}
{$R ..\..\Images\Devart.IbDac.IbDacVcl.TIBCConnectDialog.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCTransaction.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAlerter.TIBCAlerter.bmp}
{$IFNDEF STD}
{$R ..\..\Images\Devart.IbDac.IBCLoader.TIBCLoader.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCBackupService.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCConfigService.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCLicensingService.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCLogService.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCRestoreService.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCSecurityService.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCServerProperties.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCStatisticalService.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCTraceService.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCValidationService.bmp}
{$ENDIF}

{$R ..\..\Images\Devart.IbDac.IBC.TIBCConnection16.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCQuery16.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCSQL16.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCStoredProc16.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCTable16.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCUpdateSQL16.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCDataSource16.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCMetaData16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCScript.TIBCScript16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCSQLMonitor.TIBCSQLMonitor16.bmp}
{$R ..\..\Images\Devart.IbDac.IbDacVcl.TIBCConnectDialog16.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCTransaction16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAlerter.TIBCAlerter16.bmp}
{$IFNDEF STD}
{$R ..\..\Images\Devart.IbDac.IBCLoader.TIBCLoader16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCBackupService16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCConfigService16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCLicensingService16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCLogService16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCRestoreService16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCSecurityService16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCServerProperties16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCStatisticalService16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCTraceService16.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCValidationService16.bmp}
{$ENDIF}

{$R ..\..\Images\Devart.IbDac.IBC.TIBCConnection32.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCQuery32.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCSQL32.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCStoredProc32.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCTable32.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCUpdateSQL32.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCDataSource32.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCMetaData32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCScript.TIBCScript32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCSQLMonitor.TIBCSQLMonitor32.bmp}
{$R ..\..\Images\Devart.IbDac.IbDacVcl.TIBCConnectDialog32.bmp}
{$R ..\..\Images\Devart.IbDac.IBC.TIBCTransaction32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAlerter.TIBCAlerter32.bmp}
{$IFNDEF STD}
{$R ..\..\Images\Devart.IbDac.IBCLoader.TIBCLoader32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCBackupService32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCConfigService32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCLicensingService32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCLogService32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCRestoreService32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCSecurityService32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCServerProperties32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCStatisticalService32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCTraceService32.bmp}
{$R ..\..\Images\Devart.IbDac.IBCAdmin.TIBCValidationService32.bmp}
{$ENDIF}

{$ELSE}

{$IFNDEF STD}
{$R ..\..\Images\Delphi8\Devart.Dac.CRBatchMove.TCRBatchMove.bmp}
{$ENDIF}

{$R ..\..\Images\Delphi8\Devart.IbDac.IBC.TIBCConnection.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBC.TIBCQuery.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBC.TIBCSQL.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBC.TIBCStoredProc.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBC.TIBCTable.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBC.TIBCUpdateSQL.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBC.TIBCDataSource.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBC.TIBCMetaData.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCScript.TIBCScript.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCSQLMonitor.TIBCSQLMonitor.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IbDacVcl.TIBCConnectDialog.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBC.TIBCTransaction.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAlerter.TIBCAlerter.bmp}
{$IFNDEF STD}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCLoader.TIBCLoader.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCBackupService.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCConfigService.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCLicensingService.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCLogService.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCRestoreService.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCSecurityService.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCServerProperties.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCStatisticalService.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCTraceService.bmp}
{$R ..\..\Images\Delphi8\Devart.IbDac.IBCAdmin.TIBCValidationService.bmp}
{$ENDIF}

{$ENDIF}

{$I ..\Design\IBCReg.pas}
