program ESTD2010;

uses
  Forms,
  uEstdFrm in 'uEstdFrm.pas' {Form1},
  udmEstd in 'udmEstd.pas' {dmEstd: TDataModule},
  dmFB in 'dmFB.pas' {dmFireBird: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdmEstd, dmEstd);
  Application.Run;
end.
