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
  ndOrders, ndOrder, ndClient, ndAdress, ndOrderItem, ndOrderTaxs, ndOrderTax,
  ndOrderMoneys, ndOrderMoney: TXmlNode;
  St, OrderCode: string;
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
          'CREATEDTM=DATEDO;CLIENT_FIO=FAMILY;BYR2EUR=VALUEEUR;BARCODE=SENDING');
        SetXmlAttr(ndOrder, 'ORDER_CODE', AnsiUpperCase(dbfSendInet['NUMZAK']));
        SetXmlAttr(ndOrder, 'ADRESS_TEXT', dbfSendInet['STREET']+', '+dbfSendInet['HOME']);
        ndOrder.ValueAsString:= '';

        ndClient:= ndOrder.NodeNew('CLIENT');
        St:= dbfSendInet['FAMILY'];
        BatchMoveFields2(ndClient, dbfSendInet,
          'EMAIL');
        SetXmlAttr(ndClient, 'LAST_NAME', TakeFront5(St));
        SetXmlAttr(ndClient, 'FIRST_NAME', TakeFront5(St));
        SetXmlAttr(ndClient, 'MID_NAME', St);
        ndClient.ValueAsString:= '';
      end;
      ndOrderItem:= ndOrder.NodeFindOrCreate('ORDERITEMS').NodeNew('ORDERITEM');
      BatchMoveFields2(ndOrderItem, dbfSendInet,
        'ARTICLE_CODE=ARTICUL;DIMENSION=SIZE;PRICE_EUR=SUMEUR;COST_EUR=SUMEUR;'+
        'KIND_RUS=NAMEZAK;STATUS_NAME=SKLADNAME;STATE_NAME=STATUSNAME');
      ndOrderItem.ValueAsString:= '';

      if dbfSendInet['SBOR'] <> null then
      begin
        ndOrderTaxs:= ndOrder.NodeFindOrCreate('ORDERTAXS');
        ndOrderTax:= ndOrderTaxs.NodeByAttributeValue('ORDERTAX', 'COST_EUR', dbfSendInet['SBOR']);
        if ndOrderTax = nil then
        begin
          ndOrderTax:= ndOrderTaxs.NodeNew('ORDERTAX');
          BatchMoveFields2(ndOrderTax, dbfSendInet,
            'TAXSERVNAME="Сервисный сбор";COST_EUR=SBOR;STATUS_DTM=DATECALC');
          ndOrderTax.ValueAsString:= '';
        end;
      end;

      ndOrderMoney:= ndOrder.NodeFindOrCreate('ORDERMONEYS').NodeFindOrCreate('ORDERMONEY');
      BatchMoveFields2(ndOrderMoney, dbfSendInet,
          'AMOUNT_EUR=SUMRUNEUR;STATUS_DTM=DATEPAY');
      ndOrderMoney.ValueAsString:= '';

      pb.StepIt;
      dbfSendInet.Next;
    end;
    dbfSendInet.Close;
    for i:= 0 to ndOrders.NodeCount-1 do
    begin
      St:= '<?xml version="1.0" encoding="Windows-1251"?><ORDERS>'+ndOrders[i].WriteToString+'</ORDERS>';
      St:= ReplaceAll(St, '><', '>'#13#10'<');
      OrderCode:= GvStr.FilterString(GetXmlAttr(ndOrders[i], 'ORDER_CODE'), '0123456789');
      ForceDirectories(Path['ExportToSite']);
      SaveStringAsFile(St, Format('%s%s.xml', [Path['ExportToSite'], OrderCode]));
    end;
    Xml.XmlFormat:= xfReadable;
    Xml.SaveToFile('ORDERS.xml');
    Xml.Free;
  end;
  Close;
end;

initialization
  Path:= TVarList.Create;
  Path.LoadSectionFromIniFile(ExtractFilePath(ParamStr(0))+'ppz2.ini', 'PATH');
  Path.Text:= ReplaceAll(Path.Text, '=.\', '='+ExtractFilePath(ParamStr(0)));
finalization
  Path.Free;
end.
