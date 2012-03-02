unit uParseSendItet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GvVars, ComCtrls, DB, dbf;

type
  TForm1 = class(TForm)
    dlgOpen: TOpenDialog;
    pb: TProgressBar;
    dbfSendInet: TDbf;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Path: TVarList;

implementation

{$R *.dfm}

uses
  NativeXml, GvNativeXml, GvStr, GvFile;


procedure TForm1.FormActivate(Sender: TObject);
var
  Xml: TNativeXml;
  ndOrders, ndOrder, ndClient, ndAdress, ndOrderItem, ndOrderTax : TXmlNode;
  St: string;
  i: integer;
begin
  dlgOpen.InitialDir:= 'd:\otto\';
  if dlgOpen.Execute then
  begin
    dbfSendInet.FilePath:= ExtractFilePath(dlgOpen.FileName);
    dbfSendInet.TableName:= ExtractFileName(dlgOpen.FileName);
    dbfSendInet.Open;
    Xml:= TNativeXml.CreateName('ORDERS');
    ndOrders:= Xml.Root;
    pb.Max:= dbfSendInet.RecordCount;
    while not dbfSendInet.Eof do
    begin
      ndOrder:= ndOrders.NodeByAttributeValue('ORDER', 'ORDER_CODE', dbfSendInet['NUMZAK']);
      if ndOrder = nil then
      begin
        ndOrder:= ndOrders.NodeNew('ORDER');
        BatchMoveFields2(ndOrder, dbfSendInet,
          'ORDER_CODE=NUMZAK;CREATEDTM=DATEDO;CLIENT_FIO=FAMILY;BYR2EUR=VALUEEUR;BAR_CODE=SENDING');
        SetXmlAttr(ndOrder, 'ADRESS_TEXT', dbfSendInet['STREET']+','+dbfSendInet['HOME']);
        ndClient:= ndOrder.NodeNew('CLIENT');
        St:= dbfSendInet['FAMILY'];
        BatchMoveFields2(ndClient, dbfSendInet,
          'EMAIL');
        SetXmlAttr(ndClient, 'LAST_NAME', TakeFront5(St));
        SetXmlAttr(ndClient, 'FIRST_NAME', TakeFront5(St));
        SetXmlAttr(ndClient, 'MID_NAME', St);
      end;
      ndOrderItem:= ndOrder.NodeFindOrCreate('ORDERITEMS').NodeNew('ORDERITEM');
      BatchMoveFields2(ndOrderItem, dbfSendInet,
        'ARTICLE_CODE=ARTICUL;DIMNENSION=SIZE;PRICE_EUR=SUMEUR;KIND_RUS=NAMEZAK');
      ndOrderTax:= ndOrder.NodeFindOrCreate('ORDERTAXS').NodeFindOrCreate('ORDERTAX');
      BatchMoveFields2(ndOrderTax, dbfSendInet,
        'COST_EUR=SBOR');
      pb.StepIt;
      dbfSendInet.Next;
    end;
    dbfSendInet.Close;
    for i:= 0 to ndOrders.NodeCount-1 do
    begin
      St:= '<?xml version="1.0" encoding="Windows-1251"?>'+ndOrders[i].WriteToString;
      SaveStringAsFile(St, GetXmlAttr(ndOrders[i], 'ORDER_CODE','d:\otto\messages\out\','.xml'));
    end;
    Xml.XmlFormat:= xfReadable;
    Xml.SaveToFile('ORDERS.xml');
    Xml.Free;
  end;
end;

end.
