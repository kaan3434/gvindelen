unit uFormTableClients;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseNSIForm, DBGridEhGrouping, FIBDatabase, pFIBDatabase,
  ImgList, PngImageList, ActnList, DB, FIBDataSet, pFIBDataSet, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvGroupBox, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, TB2Item, TBX, TB2Dock, TB2Toolbar, ComCtrls;

type
  TFormTableClients = class(TBaseNSIForm)
    pcClientDetail: TPageControl;
    tsClientOrders: TTabSheet;
    tsClientAccountMovements: TTabSheet;
    grdClientOrders: TDBGridEh;
    grdAccountMovements: TDBGridEh;
    qryAccountMovements: TpFIBDataSet;
    dsAccountMovements: TDataSource;
    qryClientOrders: TpFIBDataSet;
    dsClientOrders: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTableClients: TFormTableClients;

implementation

uses
  udmOtto;

{$R *.dfm}

procedure TFormTableClients.FormCreate(Sender: TObject);
begin
  inherited;
  trnNSI.StartTransaction;
  qryMain.Open;
  qryAccountMovements.Open;
  qryClientOrders.Open;
end;

end.
