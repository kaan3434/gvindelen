program Swim2;

uses
  Fix4GbBug,
  Forms,
  uSwim in 'uSwim.pas' {fSwim},
  dm in 'dm.pas' {dmSwim: TDataModule},
  uRecFavorit in 'uRecFavorit.pas',
  uBaseForm in 'uBaseForm.pas' {frmBaseForm},
  uASports in 'uASports.pas' {frmASports},
  uBSports in 'uBSports.pas' {frmBSports},
  uBTournirs in 'uBTournirs.pas' {frmBTournirs},
  uCountrys in 'uCountrys.pas' {frmCountrys},
  uAGamers in 'uAGamers.pas' {frmAGamers},
  uBGamers in 'uBGamers.pas' {frmBGamers},
  uEvents in 'uEvents.pas' {frmEvents},
  uRecUcon in 'uRecUcon.pas',
  uUnknowns in 'uUnknowns.pas' {frmUnknowns},
  uRecBetCity in 'uRecBetCity.pas',
  uRecParimatch in 'uRecParimatch.pas',
  uRecBWin in 'uRecBWin.pas',
  uRecMarathon in 'uRecMarathon.pas',
  uRecPlusMinus in 'uRecPlusMinus.pas',
  uRecExpekt in 'uRecExpekt.pas',
  uRecBuker in 'uRecBuker.pas',
  uRecBetBy in 'uRecBetBy.pas',
  uRecBetAtHome in 'uRecBetAtHome.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Вилочки';
  Application.CreateForm(TfSwim, fSwim);
  Application.CreateForm(TdmSwim, dmSwim);
  Application.CreateForm(TfrmUnknowns, frmUnknowns);
  Application.Run;
end.
