program Swim4;

uses
  Vcl.Forms,
  uFormMain in 'uFormMain.pas' {Form1},
  uDmSwim in 'uDmSwim.pas' {dmSwim: TDataModule},
  uWebServiceThread in 'uWebServiceThread.pas',
  uDmWebServiceThread in 'uDmWebServiceThread.pas' {dmSwimThread: TDataModule},
  Xml.VerySimple in 'D:\4Delphi\VerySimpleXml\Source\Xml.VerySimple.pas',
  uSettings in 'uSettings.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdmSwim, dmSwim);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
