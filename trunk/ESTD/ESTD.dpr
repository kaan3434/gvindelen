program ESTD;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uEstdClasses in 'uEstdClasses.pas',
  dmFB in 'dmFB.pas' {dmFireBird: TDataModule},
  udmEstd in 'udmEstd.pas' {dmEstd: TDataModule},
  udmEstdNSI in 'udmEstdNSI.pas' {dmEstdNSI: TDataModule},
  uEstdInterfaces in 'uEstdInterfaces.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdmEstdNSI, dmEstdNSI);
  Application.Run;
end.
