unit fishfact;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, Grids, DBGrids, Buttons, ExtCtrls, Db, FIBDataSet,
  pFIBDataSet;

type
  TfrmFishFact = class(TForm)
    Panel1: TPanel;
    DBImage1: TDBImage;
    DBLabel1: TDBText;
    Panel2: TPanel;
    Label1: TLabel;
    DBLabel2: TDBText;
    Panel3: TPanel;
    DBMemo1: TDBMemo;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    dtFishfact: TpFIBDataSet;
    dtFishfactID: TFIBIntegerField;
    dtFishfactCATEGORY: TFIBStringField;
    dtFishfactNAME_COMMON: TFIBStringField;
    dtFishfactNAME_SPECIES: TFIBStringField;
    dtFishfactLENGTH_CM: TFIBIntegerField;
    dtFishfactLENGTH_IN: TFIBFloatField;
    dtFishfactNOTES: TMemoField;
    dtFishfactGRAPHIC: TBlobField;
    dsFishfact: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFishFact: TfrmFishFact;

implementation

uses dm_main;

{$R *.DFM}

procedure TfrmFishFact.FormShow(Sender: TObject);
begin
  dtFishfact.Open;
end;

procedure TfrmFishFact.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  dtFishfact.Close;
end;

end.
