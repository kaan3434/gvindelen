program Swim4;

uses
  Vcl.Forms,
  uFormMain in 'uFormMain.pas' {Form1},
  uDmSwim in 'uDmSwim.pas' {dmSwim: TDataModule},
  uWebServiceThread in 'uWebServiceThread.pas',
  uDmWebServiceThread in 'uDmWebServiceThread.pas' {dmSwimThread: TDataModule},
  uSettings in 'uSettings.pas' {Form2},
  GvXml in 'D:\4Delphi\Gvindln\Source\GvXml.pas',
  uDmFormMain in 'uDmFormMain.pas' {dmFormMain: TDataModule},
  GvStr in 'D:\4Delphi\Gvindln\Source\GvStr.pas',
  uTeachTournirs in 'uTeachTournirs.pas' {frmTeachTournirs},
  GvVariant in 'D:\4Delphi\Gvindln\Source\GvVariant.pas',
  GvFile in 'D:\4Delphi\Gvindln\Source\GvFile.pas',
  uTeachGamers in 'uTeachGamers.pas' {frmTeachGamers},
  EhLibFIB in 'D:\4Delphi\EhLib\DataService\Others\EhLibFIB.pas',
  ScanWSDL in 'ScanWSDL.pas',
  GvXmlUtils in 'D:\4Delphi\Gvindln\Source\GvXmlUtils.pas',
  GvRibbon in 'GvRibbon.pas',
  GvSoapClient in 'GvSoapClient.pas',
  GvMath in 'D:\4Delphi\Gvindln\Source\GvMath.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
