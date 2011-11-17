program ppz2;

uses
  FastMM4,
  SysUtils,
  Forms,
  uMain in 'uMain.pas' {MainForm},
  udmOtto in 'udmOtto.pas' {dmOtto: TDataModule},
  uParseLiefer in 'uParseLiefer.pas',
  uFormWizardBase in 'uFormWizardBase.pas' {FormWizardBase},
  uOttoArticleUpdate in 'uOttoArticleUpdate.pas',
  uWzOrderOtto in 'uWzOrderOtto.pas' {WzOrderOtto},
  GvNativeXml in 'GvNativeXml.pas',
  uWzrdArticles in 'uWzrdArticles.pas' {WzArticlesOtto},
  uParseMagazine in 'uParseMagazine.pas',
  uBaseNSIForm in 'uBaseNSIForm.pas' {BaseNSIForm},
  uFormTableOrder in 'uFormTableOrder.pas' {FormTableOrders},
  uFormTableClients in 'uFormTableClients.pas' {FormTableClients},
  uFormProtocol in 'uFormProtocol.pas' {FormProtocol},
  uParsePayments in 'uParsePayments.pas',
  uParseConsignment in 'uParseConsignment.pas',
  uFrameBase0 in 'uFrameBase0.pas' {FrameBase0: TFrame},
  uFrameOrderItems in 'uFrameOrderItems.pas' {FrameOrderItems: TFrame},
  uFrameOrder in 'uFrameOrder.pas' {FrameOrder: TFrame},
  uBaseWizardForm in 'uBaseWizardForm.pas' {BaseWizardForm},
  uFormWizardOrder in 'uFormWizardOrder.pas' {FormWizardOrder},
  uFrameBase1 in 'uFrameBase1.pas' {FrameBase1},
  uFrameClient in 'uFrameClient.pas' {FrameClient: TFrame},
  uFrameAdress in 'uFrameAdress.pas' {FrameAdress: TFrame},
  uFrameOrderSummary in 'uFrameOrderSummary.pas' {FrameOrderSummary: TFrame},
  uParseOrder in 'uParseOrder.pas',
  uFormWizardReturn in 'uFormWizardReturn.pas' {FormWizardReturn},
  uExportOrders in 'uExportOrders.pas',
  uSetByr2Eur in 'uSetByr2Eur.pas' {FormSetByr2Eur},
  uExportSMSReject in 'uExportSMSReject.pas',
  uExportCancellation in 'uExportCancellation.pas',
  uExportOrder in 'uExportOrder.pas',
  uParseProtocol in 'uParseProtocol.pas',
  uExportInvoices in 'uExportInvoices.pas',
  uExportPackList in 'uExportPackList.pas';

{$R *.res}

var
  BackupFileName: String;
begin
  DecimalSeparator:= '.';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TdmOtto, dmOtto);
  Application.Run;
end.
