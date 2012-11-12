unit uFormWizardMoneyBack3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormWizardBase, JvWizard, FIBDatabase, pFIBDatabase, ActnList,
  JvExControls, NativeXml, uFrameMoneyBack3;

type
  TFormWizardBase1 = class(TFormWizardBase)
    wzIPageMoneyBack: TJvWizardInteriorPage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ndClient: TXmlNode;
    ndAccount: TXmlNode;
    frmMoneyBack: TFrameMoneyBack3;
//    function GetObjectId: integer;
//    procedure SetObjectId(const Value: integer);
  public
    { Public declarations }
    procedure BuildXml; override;
    procedure ReadFromDB(aObjectId: Integer); override;
  end;


implementation

uses
  udmOtto, GvNativeXml;

{$R *.dfm}

procedure TFormWizardBase1.BuildXml;
begin
  inherited;
  Root.Name:= 'CLIENT';
  ndClient:= Root;
  ndAccount:= ndClient.NodeFindOrCreate('ACCOUNT');
end;

procedure TFormWizardBase1.ReadFromDB(aObjectId: Integer);
begin
  inherited;
  dmOtto.ObjectGet(ndClient, aObjectId, trnRead);
  trnWrite.StartTransaction;
  dmOtto.ObjectGet(ndAccount, GetXmlAttrValue(ndClient, 'ACCOUNT_ID'), trnWrite);
end;


procedure TFormWizardBase1.FormCreate(Sender: TObject);
begin
  inherited;

  Tag:= 1;

  try
    // FrameMoneyBack
    frmMoneyBack:= TFrameMoneyBack3.Create(Self);
    frmMoneyBack.ndClient:= ndClient;
//    frmMoneyBack.ndAccount:= ndAccount;
    IncludeForm(wzIPageMoneyBack, frmMoneyBack);

    wzForm.ActivePageIndex:= 0;
  finally
    Tag := 0;
  end;
end;

end.
