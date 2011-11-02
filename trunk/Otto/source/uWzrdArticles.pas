unit uWzrdArticles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseWizardForm, DBGridEhGrouping, GridsEh, DBGridEh, StdCtrls,
  JvExStdCtrls, JvGroupBox, ExtCtrls, JvExExtCtrls, JvExtComponent,
  JvPanel, JvWizard, ActnList, JvExControls, DB, FIBDataSet, pFIBDataSet,
  Mask, DBCtrlsEh, JvExMask, JvToolEdit, MemTableDataEh, MemTableEh,
  NativeXml, JvBaseDlg, JvProgressDialog, JvComponentBase,
  JvProgressComponent, JvButton, JvCtrls, JvValidators, JvErrorIndicator,
  FIBDatabase, pFIBDatabase, FIBQuery, pFIBQuery;

type
  TWzArticlesOtto = class(TBaseWizardForm)
    wzIPageMagazines: TJvWizardInteriorPage;
    pnlCenterOnMagazines: TJvPanel;
    grBoxMagazines: TJvGroupBox;
    grdMagazines: TDBGridEh;
    pnlLeftOnMagazines: TJvPanel;
    grBoxMagazineOnMagazines: TJvGroupBox;
    qryMagazines: TpFIBDataSet;
    cbCatalog: TDBComboBoxEh;
    lblCatalog: TLabel;
    dsMagazines: TDataSource;
    fldMagazinesMAGAZINE_ID: TFIBIntegerField;
    fldMagazinesCATALOG_ID: TFIBIntegerField;
    fldMagazinesCATALOG_NAME: TFIBStringField;
    fldMagazinesVALID_DATE: TFIBDateField;
    fldMagazinesSTATUS_ID: TFIBIntegerField;
    fldMagazinesSTATUS_NAME: TFIBStringField;
    lblValidDate: TLabel;
    dtedValidDate: TDBDateTimeEditEh;
    actLoadMagazine: TAction;
    wzIPageImport: TJvWizardInteriorPage;
    pnlCenterOnImport: TJvPanel;
    grBoxMagazineOnImport: TJvGroupBox;
    edtFileName: TJvFilenameEdit;
    lblMagazineFileName: TLabel;
    wzIPageFinal: TJvWizardInteriorPage;
    pnl1: TJvPanel;
    grBoxMagazineOnFinal: TJvGroupBox;
    lbl1: TLabel;
    lbl3: TLabel;
    dtedValidDateOnFinal: TDBDateTimeEditEh;
    txtAtricleCounts: TStaticText;
    lbl4: TLabel;
    vldEdits: TJvValidators;
    vldIndEdits: TJvErrorIndicator;
    vldCustomValidDate: TJvCustomValidator;
    vldRequiredCatalog: TJvRequiredFieldValidator;
    vldRequiredFileName: TJvRequiredFieldValidator;
    txtCatalogNameOnFinal: TStaticText;
    wzWPage1: TJvWizardWelcomePage;
    dedMagazineName: TDBEditEh;
    lblMagazineName: TLabel;
    qryTmpOttoArticle: TpFIBDataSet;
    procedure wzIPageMagazinesEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure wzIPageImportNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure wzIPageFinalEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure wzIPageMagazinesNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure vldCustomValidDateValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
    procedure wzFormFinishButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure grdMagazinesDblClick(Sender: TObject);
    procedure dedMagazineNameEnter(Sender: TObject);
    procedure edtFileNameChange(Sender: TObject);
  private
    { Private declarations }
    ndMagazine: TXmlNode;
    slArticles: TStringList;
    function Magazine2Xml: Boolean;
  public
    { Public declarations }
    procedure BuildXml; override;
    procedure UpdateCaptions; override;
  end;

var
  WzArticlesOtto: TWzArticlesOtto;

implementation

uses
  udmOtto, uParseMagazine, GvNativeXml, gvStr;

{$R *.dfm}

procedure TWzArticlesOtto.UpdateCaptions;
var
  CaptionText: string;
  Clr: TColor;
begin
  CaptionText:= DetectCaption(ndMagazine, 'Каталог');
  grBoxMagazineOnMagazines.Caption:= CaptionText;
  grBoxMagazineOnImport.Caption:= CaptionText;
  grBoxMagazineOnFinal.Caption:= CaptionText;
end;

procedure TWzArticlesOtto.wzIPageMagazinesEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
  dmOtto.FillComboStrings(cbCatalog.KeyItems, cbCatalog.Items,
    'select catalog_id, catalog_name from catalogs order by catalog_name', trnRead);
  qryMagazines.Open;
  if AttrExists(ndMagazine, 'CATALOG_ID') then
    cbCatalog.ItemIndex:= GetXmlAttrValue(ndMagazine, 'CATALOG_ID');
  if AttrExists(ndMagazine, 'VALID_DATE') then
    dtedValidDate.Value:= GetXmlAttrValue(ndMagazine, 'VALID_DATE');
  dedMagazineName.Text:= GetXmlAttr(ndMagazine, 'MAGAZINE_NAME');
end;

procedure TWzArticlesOtto.BuildXml;
begin
  inherited;
  ndMagazine:= Root;
end;

procedure TWzArticlesOtto.wzIPageImportNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  Stop:= not (vldEdits.Validate('Import'));
end;

procedure TWzArticlesOtto.wzIPageFinalEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
  slArticles.LoadFromFile(edtFileName.Text);
  txtCatalogNameOnFinal.Caption:= GetXmlAttrValue(ndMagazine, 'MAGAZINE_NAME');
  dtedValidDateOnFinal.Value:= GetXmlAttrValue(ndMagazine, 'VALID_DATE');
  txtAtricleCounts.Caption:= Format('%u артикулов', [slArticles.Count]);
end;

function TWzArticlesOtto.Magazine2Xml: Boolean;
begin
  Result:= False;
  try
    Combo2XmlAttr(cbCatalog, ndMagazine, 'CATALOG_ID', 'CATALOG_NAME');
    SetXmlAttr(ndMagazine, 'VALID_DATE', dtedValidDate.Value);
    SetXmlAttr(ndMagazine, 'MAGAZINE_NAME', dedMagazineName.Text);
    begin
      if not AttrExists(ndMagazine, 'ID') then
        if MessageDlg(Format('Зарегистрировать каталог %s до %s?',
                      [cbCatalog.Text, FormatDateTime('DD.MM.YYYY', dtedValidDate.Value)]),
                      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          SetXmlAttr(ndMagazine, 'ID', dmOtto.GetNewObjectId('MAGAZINE'));
          UpdateCaptions;
        end
        else
          Exit;
    end;
    Result:= true;
  except
  end;
end;

procedure TWzArticlesOtto.wzIPageMagazinesNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  Stop:= not (vldEdits.Validate('Magazine') and Magazine2Xml);
end;

procedure TWzArticlesOtto.vldCustomValidDateValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
begin
  Valid:= not VarIsNull(dtedValidDate.Value);
end;

procedure TWzArticlesOtto.wzFormFinishButtonClick(Sender: TObject);
var
  ndArticle: TXmlNode;
  i, ArticleId: Integer;
begin
  trnWrite.StartTransaction;
  try
    dmOtto.ActionExecute(trnWrite, ndMagazine);
    if (edtFileName.Text <> '') and FileExists(edtFileName.Text) then
    begin
      ParseArticles(trnWrite, slArticles, ndMagazine);
      trnWrite.ExecSQLImmediate('execute procedure articles_pump');
      dmOtto.ActionExecute(trnWrite, ndMagazine, 0, 'LOADED');
    end;
    trnWrite.Commit;
    ShowMessage(Format('Каталог "%s" успещно загружен.',
                [GetXmlAttrValue(ndMagazine, 'MAGAZINE_NAME')]));
    Close;
  except
    trnWrite.Rollback;
    raise;
  end;
end;

procedure TWzArticlesOtto.FormCreate(Sender: TObject);
begin
  inherited;
  slArticles:= TStringList.Create;
end;

procedure TWzArticlesOtto.FormDestroy(Sender: TObject);
begin
  inherited;
  slArticles.Free;
end;

procedure TWzArticlesOtto.grdMagazinesDblClick(Sender: TObject);
begin
  dmOtto.MagazineRead(ndMagazine, qryMagazines['MAGAZINE_ID'], trnRead);
  wzForm.SelectNextPage;
  UpdateCaptions;
end;

procedure TWzArticlesOtto.dedMagazineNameEnter(Sender: TObject);
begin
  if (dedMagazineName.Text = '') and
     (cbCatalog.ItemIndex >= 1) and
     not VarIsNull(dtedValidDate.Value) then
  begin
    dedMagazineName.Text:= Format('%s до %s', [
      cbCatalog.Text,
      FormatDateTime('YYYY-MM-DD', dtedValidDate.Value)]);
  end;
end;

procedure TWzArticlesOtto.edtFileNameChange(Sender: TObject);
begin
  if edtFileName.Text[1] = '"' then
    edtFileName.Text:= Copy(edtFileName.Text, 2, Length(edtFileName.Text)-2);
end;

end.
