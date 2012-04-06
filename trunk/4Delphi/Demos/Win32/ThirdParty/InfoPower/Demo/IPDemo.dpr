program IPDemo;

uses
  Forms,
  Main in 'Main.pas' {fmMain},
  IBCIP in '..\IBCIP.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
