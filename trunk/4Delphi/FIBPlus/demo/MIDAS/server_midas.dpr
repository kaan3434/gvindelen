program server_midas;

uses
  Forms,
  server_midas_main in 'server_midas_main.pas' {Form1},
  server_midas_TLB in 'server_midas_TLB.pas',
  server_midas_dm in 'server_midas_dm.pas' {FIBPlusDemoServer: TRemoteDataModule} {FIBPlusDemoServer: CoClass};

{$R *.TLB}

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
