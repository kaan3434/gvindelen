unit uFrameClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameBase1, ImgList, PngImageList, ActnList, FIBDatabase,
  pFIBDatabase, ExtCtrls, JvExExtCtrls, JvPanel,
  TBXStatusBars, TB2Dock, TB2Toolbar, TBX, DB,
  FIBDataSet, pFIBDataSet, StdCtrls, DBCtrlsEh, Mask, JvExMask, JvToolEdit,
  JvMaskEdit, JvExStdCtrls, JvGroupBox, GridsEh, DBGridEh,
  JvNetscapeSplitter, GvXml, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DBAxisGridsEh;

type
  TFrameClient = class(TFrameBase1)
    pnlCenterOnClient: TPanel;
    splitClient: TJvNetscapeSplitter;
    grdClient: TDBGridEh;
    grdClientOrders: TDBGridEh;
    grdClientOrderItems: TDBGridEh;
    pnlRightOnClient: TPanel;
    grBoxClient: TJvGroupBox;
    lblLastName: TLabel;
    lblFirstName: TLabel;
    lblMidName: TLabel;
    lblMobilePhone: TLabel;
    lbl1: TLabel;
    lblStacionarPhone: TLabel;
    dedLastName: TDBEditEh;
    dedFirstName: TDBEditEh;
    dedMidName: TDBEditEh;
    dedEmail: TDBEditEh;
    dedStaticPhone: TDBEditEh;
    grBoxAdress: TJvGroupBox;
    txtAdress: TStaticText;
    qryClient: TpFIBDataSet;
    fldClientCLIENT_ID: TFIBIntegerField;
    fldClientFIO_TEXT: TFIBStringField;
    fldClientLAST_NAME: TFIBStringField;
    fldClientFIRST_NAME: TFIBStringField;
    fldClientMID_NAME: TFIBStringField;
    fldClientSTATUS_ID: TFIBIntegerField;
    fldClientMOBILE_PHONE: TFIBStringField;
    fldClientEMAIL: TFIBStringField;
    fldClientPLACE_ID: TFIBIntegerField;
    fldClientPLACE_TEXT: TFIBStringField;
    fldClientADRESS_ID: TFIBIntegerField;
    fldClientADRESS_TEXT: TFIBStringField;
    fldClientSTATUS_NAME: TFIBStringField;
    dsClients: TDataSource;
    qryClientOrders: TpFIBDataSet;
    dsClientOrders: TDataSource;
    qryClientOrderItems: TpFIBDataSet;
    dsClientOrderItems: TDataSource;
    actClientSearch: TAction;
    dedMobilPhone: TDBEditEh;
    procedure actClientSearchExecute(Sender: TObject);
    procedure EditEnter(Sender: TObject);
    procedure dedLastNameExit(Sender: TObject);
    procedure NameExit(Sender: TObject);
    procedure grdClientDblClick(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dedEmailExit(Sender: TObject);
    procedure dedLastNameKeyPress(Sender: TObject; var Key: Char);
  private
    function GetOrderId: Integer;
//    function FullAdress: String;
    function GetClientId: Integer;
    function GetAccountId: Integer;
    { Private declarations }
  public
    { Public declarations }
    ndOrder: TGvXmlNode;
    ndClient: TGvXmlNode;
    ndAdress: TGvXmlNode;
    ndPlace: TGvXmlNode;
    ndAccount: TGvXmlNode;
//    procedure ClearClient;
    property OrderId: Integer read GetOrderId;
    property ClientId: Integer read GetClientId;
    property AccountId: Integer read GetAccountId;
  end;

var
  FrameClient: TFrameClient;

implementation

uses
  udmOtto, GvXmlUtils, GvStr, GvKbd;

{$R *.dfm}

{ TFrameClient }

function TFrameClient.GetOrderId: Integer;
begin
  Result:= ndOrder.Attr['ID'].AsIntegerDef(0);
end;

function TFrameClient.GetClientId: Integer;
begin
  Result:= ndClient.Attr['ID'].AsIntegerDef(0);
end;

function TFrameClient.GetAccountId: Integer;
begin
  Result:= ndAccount.Attr['ID'].AsIntegerDef(0);
end;


{function TFrameClient.FullAdress: String;
begin
  result:= GetXmlAttr(ndAdress, 'POSTINDEX', '', '. ') +
    GetXmlAttr(ndPlace, 'PLACE_NAME', ' '+ndPlace.ReadAttributeString('PLACETYPE_SIGN', 'г')+'. ') +
    GetXmlAttr(ndPlace, 'AREA_NAME', ' ', ' р-н. ') +
    GetXmlAttr(ndPlace, 'REGION_NAME', ' ', ' обл.') +
    GetXmlAttr(ndAdress, 'STREET_NAME', ndAdress.ReadAttributeString('STREETTYPE_SIGN', ', ул.')+' ')+
    GetXmlAttr(ndAdress, 'HOUSE', ', ')+
    GetXmlAttr(ndAdress, 'BUILDING', ', корп. ')+
    GetXmlAttr(ndAdress, 'FLAT', ', кв. ');
  result:= ReplaceAll(Result, '  ', ' ');
end;}

{procedure TFrameClient.Read;
begin
  txtAdress.Caption:= FullAdress;
  dedLastName.Text:= GetXmlAttr(ndClient, 'LAST_NAME');
  dedFirstName.Text:= GetXmlAttr(ndClient, 'FIRST_NAME');
  dedMidName.Text:= GetXmlAttr(ndClient, 'MID_NAME');
  dedMobilPhone.Text:= GetXmlAttr(ndClient, 'MOBILE_PHONE');
  dedStaticPhone.Text:= GetXmlAttr(ndClient, 'STATIC_PHONE');
  dedEmail.Text:= GetXmlAttr(ndClient, 'EMAIL');
  actClientSearch.Execute;
end;}

{procedure TFrameClient.Write;
begin
  inherited;
  SetXmlAttr(ndClient, 'LAST_NAME', dedLastName.Text);
  SetXmlAttr(ndClient, 'FIRST_NAME', dedFirstName.Text);
  SetXmlAttr(ndClient, 'MID_NAME', dedMidName.Text);
  SetXmlAttr(ndClient, 'MOBILE_PHONE', dedMobilPhone.Text);
  SetXmlAttr(ndClient, 'STATIC_PHONE', dedStaticPhone.Text);
  SetXmlAttr(ndClient, 'EMAIL', dedEmail.Text);
  if ClientId = 0 then
  begin
    if MessageDlg(Format('Зарегистрировать клиента %s %s %s?',
                  [dedLastName.Text, dedFirstName.Text, dedMidName.Text]),
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      SetXmlAttr(ndClient, 'ID', dmOtto.GetNewObjectId('CLIENT'));
      SetXmlAttr(ndAccount, 'ID', dmOtto.GetNewObjectId('ACCOUNT'));
      SetXmlAttr(ndAdress, 'CLIENT_ID', ClientId);
      BatchMoveFields2(ndClient, ndAccount, 'ACCOUNT_ID=ID');
      dmOtto.ActionExecute(trnWrite, 'ACCOUNT_CREATE', ndAccount);
      dmOtto.ActionExecute(trnWrite, 'CLIENT_CREATE', ndClient);
    end
    else
      Exit;
  end
  else
    dmOtto.ActionExecute(trnWrite, ndClient);
  BatchMoveFields2(ndOrder, ndClient, 'CLIENT_ID=ID;ACCOUNT_ID;LAST_NAME', true);
  dmOtto.ActionExecute(trnWrite, ndOrder);
  dmOtto.ObjectGet(ndAccount, AccountId, trnWrite);
  dmOtto.ObjectGet(ndClient, ClientId, trnWrite);
  UpdateCaptions;
end;}

procedure TFrameClient.actClientSearchExecute(Sender: TObject);
begin
  if ndClient.HasAttribute('LAST_NAME') then
  begin
    qryClient.DisableControls;
    qryClientOrders.DisableControls;
    try
      if qryClient.Active then qryClient.Close;
      qryClient.OpenWP([dedLastName.Text]);
      qryClientOrders.CloseOpen(True);
      qryClientOrderItems.CloseOpen(True);
    finally
      qryClient.EnableControls;
      qryClientOrders.EnableControls;
    end;
  end;
end;

procedure TFrameClient.EditEnter(Sender: TObject);
begin
  dmOtto.SetKeyLayout(TControl(Sender).Tag);
end;

procedure TFrameClient.dedLastNameExit(Sender: TObject);
begin
  TDBEditEh(Sender).Text:= UpCaseWord(TDBEditEh(Sender).Text);
  actClientSearch.Execute;
end;

procedure TFrameClient.NameExit(Sender: TObject);
begin
  TDBEditEh(Sender).Text:= UpCaseWord(TDBEditEh(Sender).Text);
end;

procedure TFrameClient.grdClientDblClick(Sender: TObject);
begin
  if ndOrder.Attr['STATUS_SIGN'].ValueIn(['NEW','DRAFT']) then
  begin
//    ClearClient;
    dmOtto.ClientRead(ndClient, qryClient['CLIENT_ID'], trnRead);
    dmOtto.AdressReadByClient(ndAdress, qryClient['CLIENT_ID'], trnRead);
    Read;
    ndOrder['CLIENT_ID']:= ClientId;
  end;
end;

{procedure TFrameClient.OpenTables;
begin
  inherited;
  qryClient.Open;
  qryClientOrders.Open;
  qryClientOrderItems.Open;
end;
}

procedure TFrameClient.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  KeyReturn(Sender, Key, Shift);
end;

procedure TFrameClient.dedEmailExit(Sender: TObject);
begin
  dedEmail.Text:= LowerCase(dedEmail.Text);
end;

{procedure TFrameClient.UpdateCaptions;
begin
  grBoxClient.Caption:= DetectCaption(ndClient, 'Клиент');
  grBoxAdress.Caption:= DetectCaption(ndAdress, 'Адрес');
end;
}

procedure TFrameClient.dedLastNameKeyPress(Sender: TObject; var Key: Char);
begin
  if ndOrder.Attr['STATUS_SIGN'].ValueIn(['NEW','DRAFT']) then
  begin
    if ndClient.HasAttribute('ID') and
       (MessageDlg('Вы хотите заменить клиента?', mtWarning, [mbYes,mbNo], 0) = mrYes) then
//      ClearClient;
//    UpdateCaptions;
  end;
end;

{procedure TFrameClient.ClearClient;
begin
  SetXmlAttr(ndClient, 'ID', null);
  SetXmlAttr(ndOrder, 'CLIENT_ID', null);
  SetXmlAttr(ndAccount, 'ID', null);
  SetXmlAttr(ndOrder, 'ACCOUNT_ID', null);
  SetXmlAttr(ndClient, 'ACCOUNT_ID', null);
  SetXmlAttr(ndAdress, 'ID', null);
  SetXmlAttr(ndOrder, 'ADRESS_ID', null);
  ndAdress.AttributesClear;
  ndPlace.AttributesClear;
end;
}
end.
