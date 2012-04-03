{$I fibplus_dll.inc}

{$IFDEF BUILD_EXE}
program fibplus_dll;
{$ELSE}
library fibplus_dll;
{$ENDIF}

uses
  Forms,
  main_dll in 'main_dll.pas' {frmMain},
  fibplus_dll_init in 'fibplus_dll_init.pas',
  datamod_dll in 'datamod_dll.pas' {dmMain: TDataModule},
  edit_country in 'edit_country.pas' {frmEditCountry};

{$IFDEF BUILD_EXE}
{$R *.RES}
{$ENDIF}

begin
{$IFDEF BUILD_EXE}
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
{$ENDIF}
end.
