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
  ScanWSDL in 'ScanWSDL.pas',
  GvStr in 'D:\4Delphi\Gvindln\Source\GvStr.pas',
  uTeachTournirs in 'uTeachTournirs.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
