unit dmFB;

interface

uses
  SysUtils, Classes, MemTableDataEh, Db, FIBDataSet, pFIBDataSet,
  FIBDatabase, pFIBDatabase, MemTableEh, Variants;

type  
  TdmFireBird = class(TDataModule)
    dbData: TpFIBDatabase;
    trnUpdate: TpFIBTransaction;
    trnRead: TpFIBTransaction;
    tblTemp: TpFIBDataSet;
    memQueries: TMemTableEh;
    wsfldQueries_query_sign: TWideStringField;
    wsfldQueries_query_text: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  public
    { Public declarations }
    procedure LoadDataFromQuery(aDataSet: TMemTableEh;
      aSQL: WideString); overload;
    procedure LoadDataFromQuery(aDataSet: TMemTableEh;
      aSQL, aParamNames: WideString; aParamValues: array of variant;
      aMode: TLoadMode=lmCopy); overload;
    procedure LoadDataFromQueryStorage(aDataSet: TMemTableEh;
      aQuerySign, aParamNames: WideString; aParamValues: array of variant;
      aMode: TLoadMode=lmCopy);
  end;

implementation

uses
  uEstdInterfaces, udmEstd;

{$R *.dfm}

type
  TIdmEstdFireBird = class(TInterfacedObject, IdmEstd)
    procedure LoadDocument(admEstd: TdmEstd; aDocumentLabel: WideString);
    function GetDocumentId(aDocumentLabel: WideString): integer;
    procedure GetDocuments(aDataSet: TMemTableEh; aDocumentId: integer);
    procedure LoadDocOpers(aDataSet: TMemTableEh; aDocumentId: integer);
    procedure LoadDocSets(aDataSet: TMemTableEh; aDocumentId: Integer);
    procedure LoadDetInSet(aDetInSet, aObjects: TMemTableEh; aDocumentId: Integer);
    procedure LoadObject(aDataset: TMemTableEh; aObjectId: Integer);
    procedure LoadAllObjects(aDataSet: TMemTableEh; aDocumentLabel: WideString; var aDocumentId: Integer);
  private
    procedure LoadObjects(aDataSet: TMemTableEh; aDocumentId: Integer);
  end;

  TIdmEstdNSIFireBird = class(TInterfacedObject, IdmEstdNSI)
    procedure LoadObjTypes(aDataSet: TMemTableEh);
    procedure LoadKEIGroups(aKEIGroupDataSet: TMemTableEh);
    procedure LoadKEIs(aKEIDataSet: TMemTableEh);
  end;


var
  dmFireBird: TdmFireBird;

{ TdmFireBird }

procedure TdmFireBird.DataModuleCreate(Sender: TObject);
begin
  dbData.Open(True);
  LoadDataFromQuery(memQueries,
    'select query_sign, query_text from queries');
end;

procedure TdmFireBird.LoadDataFromQuery(aDataSet: TMemTableEh; aSQL,
  aParamNames: WideString; aParamValues: array of variant; aMode: TLoadMode=lmCopy);
begin
  tblTemp.SQLs.SelectSQL.Text:= aSQL;
  tblTemp.OpenWP(aParamNames, aParamValues);
  try
    aDataSet.LoadFromDataSet(tblTemp, -1, aMode, false);
  finally
    tblTemp.Close;
  end;
end;

procedure TdmFireBird.LoadDataFromQuery(aDataSet: TMemTableEh;
  aSQL: WideString);
begin
  LoadDataFromQuery(aDataSet, aSQL, '', []);
end;

procedure TdmFireBird.LoadDataFromQueryStorage(aDataSet: TMemTableEh;
  aQuerySign, aParamNames: WideString; aParamValues: array of variant;
  aMode: TLoadMode);
begin
  if memQueries.Locate('query_sign', aQuerySign, [loCaseInsensitive]) then
    LoadDataFromQuery(aDataSet, memQueries['query_text'], aParamNames, aParamValues, aMode)
  else
    raise Exception.CreateFmt('Query Template "%s" not found', [aQuerySign]);
end;


{ TIdmEstdFireBird. }

procedure TIdmEstdFireBird.LoadDetInSet(aDetInSet, aObjects: TMemTableEh;
  aDocumentId: Integer);
begin

end;

procedure TIdmEstdFireBird.LoadDocOpers(aDataSet: TMemTableEh;
  aDocumentId: integer);
begin
  dmFireBird.LoadDataFromQueryStorage(aDataSet, 'all_docopers_by_document',
    'document_id', [aDocumentId]);
end;

procedure TIdmEstdFireBird.LoadDocSets(aDataSet: TMemTableEh;
  aDocumentId: Integer);
begin
  dmFireBird.LoadDataFromQueryStorage(aDataSet, 'all_docsets_by_document',
    'document_id', [aDocumentId]);
end;

function TIdmEstdFireBird.GetDocumentId(aDocumentLabel: WideString): integer;
begin
  with dmFireBird do
  begin
    Result:= dbData.QueryValue(
      'select obj_id from objects where obj_label = :obj_label', 0,
      [aDocumentLabel], trnRead);
  end;
end;

procedure TIdmEstdFireBird.GetDocuments(aDataSet: TMemTableEh; aDocumentId: integer);
begin
  dmFireBird.LoadDataFromQuery(aDataSet,
      'select d.document_id, d.refdoc_id, o.obj_label, o.obj_name, o.obj_code'+
      ' from documents d'+
      '  inner join objects o on (o.obj_id = d.document_id'+
      ' where d.document_id = :document_id',
      'document_id', [aDocumentId]);
end;

procedure TIdmEstdFireBird.LoadObjects(aDataSet: TMemTableEh;
  aDocumentId: Integer);
begin
end;

{ TIdmEstdNSIFireBird }

procedure TIdmEstdNSIFireBird.LoadKEIGroups(aKEIGroupDataSet: TMemTableEh);
begin
  dmFireBird.LoadDataFromQuery(aKEIGroupDataSet,
      'select groupkei_code, groupkei_name from keigroup_ref');
end;

procedure TIdmEstdNSIFireBird.LoadKEIs(aKEIDataSet: TMemTableEh);
begin
  dmFireBird.LoadDataFromQuery(aKEIDataSet,
    'select kei, groupkei_code, kei_name, kei_short, master_kei'+
    ' from kei_okp');
end;

procedure TIdmEstdNSIFireBird.LoadObjTypes(aDataSet: TMemTableEh);
begin
  dmFireBird.LoadDataFromQuery(aDataSet,
    'select objtype, objtype_name from objtype_ref');
end;


procedure TIdmEstdFireBird.LoadAllObjects(aDataSet: TMemTableEh;
  aDocumentLabel: WideString; var aDocumentId: Integer);
begin
end;

procedure TIdmEstdFireBird.LoadObject(aDataset: TMemTableEh;
  aObjectId: Integer);
begin

end;

procedure TIdmEstdFireBird.LoadDocument(admEstd: TdmEstd;
  aDocumentLabel: WideString);
var
  DocumentId: Integer;
begin
  DocumentId:= GetDocumentId(aDocumentLabel);
  with dmFireBird do
  begin
    LoadDataFromQueryStorage(admEstd.memObjects, 'all_objects_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memDocuments, 'all_documents_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memDocOpers, 'all_docopers_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memDocSets, 'all_docsets_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memDetails, 'all_details_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memDetIsSet, 'all_detinsets_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memHalfs, 'all_halfs_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memMaterials, 'all_materials_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memEquips, 'all_equipments_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memInstrs, 'all_instruments_by_document',
      'document_id', [DocumentId], lmCopy);
    LoadDataFromQueryStorage(admEstd.memProfs, 'all_professions_by_document',
      'document_id', [DocumentId], lmCopy);
  end

end;

initialization
  dmFireBird:= TdmFireBird.Create(nil);
  EstdDataModule:= TIdmEstdFireBird.Create;
  EstdNSIDataModule:= TIdmEstdNsiFireBird.Create;
finalization
  EstdDataModule:= nil;
  EstdNSIDataModule:= nil;
  dmFireBird.Free;
end.
