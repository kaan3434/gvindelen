unit midas_simple;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, DBCtrls, Grids, DBGrids, Db, DBClient,
  MConnect, Spin;

type
  TfrmMidas = class(TForm)
    btnClose: TBitBtn;
    dbgCountry: TDBGrid;
    dbnCountry: TDBNavigator;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DCOMConnection1: TDCOMConnection;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ClientDataSet1ID: TIntegerField;
    ClientDataSet1NAME: TStringField;
    ClientDataSet1CAPITAL: TStringField;
    ClientDataSet1CONTINENT: TStringField;
    ClientDataSet1AREA: TFloatField;
    ClientDataSet1POPULATION: TFloatField;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMidas: TfrmMidas;

implementation

{$R *.DFM}

procedure TfrmMidas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClientDataSet1.Close;
end;

procedure TfrmMidas.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMidas.Button1Click(Sender: TObject);
begin
 if not ClientDataSet1.Active then ClientDataSet1.Open;
end;

procedure TfrmMidas.Button2Click(Sender: TObject);
begin
  if ClientDataSet1.Active then
    if (ClientDataSet1.ChangeCount > 0) then
      ClientDataSet1.ApplyUpdates(SpinEdit1.Value);
end;

procedure TfrmMidas.Button3Click(Sender: TObject);
begin
 ClientDataSet1.Close;
 ClientDataSet1.Open;
end;

end.
