unit uFrameCriterias;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, GridsEh,
  DBAxisGridsEh, DBGridEh, TB2Dock, TB2Toolbar, TBX, DB, FIBDataSet,
  pFIBDataSet;

type
  TFrame1 = class(TFrame)
    dckTop: TTBXDock;
    tb1: TTBXToolbar;
    grdCriterias: TDBGridEh;
    dsCriterias: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
