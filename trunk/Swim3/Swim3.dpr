program Swim3;

uses
  Forms,
  uSwim in 'uSwim.pas' {fSwim},
  dm in 'dm.pas' {dmSwim: TDataModule},
  uBaseForm in 'uBaseForm.pas' {frmBaseForm},
  uASports in 'uASports.pas' {frmASports},
  uBSports in 'uBSports.pas' {frmBSports},
  uBTournirs in 'uBTournirs.pas' {frmBTournirs},
  uCountrys in 'uCountrys.pas' {frmCountrys},
  uAGamers in 'uAGamers.pas' {frmAGamers},
  uBGamers in 'uBGamers.pas' {frmBGamers},
  uEvents in 'uEvents.pas' {frmEvents},
  uUnknowns in 'uUnknowns.pas' {frmUnknowns};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Вилочки';
  Application.CreateForm(TfSwim, fSwim);
  Application.CreateForm(TdmSwim, dmSwim);
  Application.CreateForm(TfrmUnknowns, frmUnknowns);
  Application.Run;
end.
