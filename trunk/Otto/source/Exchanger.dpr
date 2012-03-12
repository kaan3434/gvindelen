program Exchanger;

uses
  Forms,
  udmExch in 'udmExch.pas' {dmExch: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmExch, dmExch);
  Application.Run;
end.
