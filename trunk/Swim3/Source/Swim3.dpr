program Swim3;

uses
  FastMM4,
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
  uUnknowns in 'uUnknowns.pas' {frmUnknowns},
  uSwimCommon in 'uSwimCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Вилочки';
  Application.CreateForm(TdmSwim, dmSwim);
  Application.CreateForm(TfSwim, fSwim);
  Application.CreateForm(TfrmUnknowns, frmUnknowns);
  dmSwimImpl:= TIDMSwimImplement.Create;
  Application.Run;
  dmSwimImpl:= nil;
end.
