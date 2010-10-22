unit uEstd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FIBDatabase, pFIBDatabase, StdCtrls, frxClass, frxFIBComponents,
  frxDBSet, frxExportPDF;

type
  TForm1 = class(TForm)
    btn1: TButton;
    pFIBDatabase1: TpFIBDatabase;
    frxrprt1: TfrxReport;
    frxfbcmpnts1: TfrxFIBComponents;
    btn2: TButton;
    frxdbdtst1: TfrxDBDataset;
    frxpdfxprt1: TfrxPDFExport;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  FIBdb: TfrxFIBDatabase;
begin
   FIBdb:= (frxrprt1.FindObject('FIBDatabase1') as TfrxFIBDatabase);
   FIBdb.SetLogin('SYSDBA', 'masterkey');
   FIBdb.DatabaseName:= 'd:/gost/estd.fdb';
   FIBdb.Connected:= True;
   if FIBdb.Connected then
     ShowMessage('Connected');
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  frxrprt1.Script.Variables['Document_ID']:= '18';
  frxrprt1.ShowReport(true);
end;

end.
