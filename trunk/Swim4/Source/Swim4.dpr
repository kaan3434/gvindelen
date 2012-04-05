program Swim4;

uses
  Vcl.Forms,
  uFormMain in 'uFormMain.pas' {Form1},
  uDmSwim in 'uDmSwim.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
