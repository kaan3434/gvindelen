unit udmEstd;

interface

uses
  SysUtils, Classes, MemTableDataEh, Db, MemTableEh;

type
  TdmEstd = class(TDataModule)
    memDocuments: TMemTableEh;
    memDocOpers: TMemTableEh;
    dsDocuments: TDataSource;
    dsDocOpers: TDataSource;
    fldiDocuments_document_id: TIntegerField;
    fldiDocumentsrefdoc_id: TIntegerField;
    fldiOpersdocoper_id: TIntegerField;
    fldiDocOpersdocument_id: TIntegerField;
    fldiDocOpersoper_num: TIntegerField;
    wsfldDocOpersoper_name: TWideStringField;
    memDocSets: TMemTableEh;
    fldiDocSetsDocSet_Id: TIntegerField;
    fldiDocSetsdocument_id: TIntegerField;
    wsfldDocSetsdocset_name: TWideStringField;
    dsDocSets: TDataSource;
    dsObjects: TDataSource;
    memObjects: TMemTableEh;
    fldiObjectsobj_id: TIntegerField;
    wsfldObjectsobj_label: TWideStringField;
    wsfldObjectsobj_name: TWideStringField;
    wsfldObjects_objtype: TWideStringField;
    fldiObjects_kei: TIntegerField;
    wsfldObjects_obj_code: TWideStringField;
    wsfldObjects_obj_gost: TWideStringField;
    wsfldObjectsobjtype_name: TWideStringField;
    memDetIsSet: TMemTableEh;
    dsDetInSet: TDataSource;
    fldiDetIsSet_docset_id: TIntegerField;
    fldiDetIsSet_detail_id: TIntegerField;
    wsfldDetIsSetdetail_label: TWideStringField;
    wsfldDetIsSet_detail_name: TWideStringField;
    dsDetails: TDataSource;
    dsMaterials: TDataSource;
    dsEquips: TDataSource;
    memDetails: TMemTableEh;
    memMaterials: TMemTableEh;
    memEquips: TMemTableEh;
    memInstrs: TMemTableEh;
    memProfs: TMemTableEh;
    dsInstrs: TDataSource;
    dsProfs: TDataSource;
    fldiDetails_detail_id: TIntegerField;
    fldiMaterials_material_id: TIntegerField;
    fldiEquips_equip_id: TIntegerField;
    fldiEquips_orgunit_id: TIntegerField;
    fldiInstrs_instr_id: TIntegerField;
    fldiProfs_prof_id: TIntegerField;
    fldiProfs_prof_code: TIntegerField;
    wsfldProfs_prof_name: TWideStringField;
    fldiProfs_prof_okr_code: TIntegerField;
    dsHalfs: TDataSource;
    memHalfs: TMemTableEh;
  private
    { Private declarations }
    FDocumentLabel: WideString;
    FDocumentId: Integer;
    procedure LoadFromDB(DocumentLabel: WideString);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; aDocumentLabel: WideString);
    property DocumentLabel: WideString read FDocumentLabel;
    procedure LoadObject(aObjectId: Integer);
    procedure LoadDocument(aDocumentId: Integer);
    procedure LoadDetail(aDetailId: Integer);
    procedure MakeLookupField(aDataSet: TDataSet; aFieldName, aKeyFields: string;
                              aLookupDataSet: TDataSet; aLookupKeyFields, aLookupResult: string);
  end;


var
  dmEstd: TdmEstd;

implementation

uses
  dmFB, uEstdInterfaces, udmEstdNSI, GvCloner;

{$R *.dfm}

{ TdmEstd }

constructor TdmEstd.Create(AOwner: TComponent; aDocumentLabel: WideString);
begin
  inherited Create(AOwner);
  FDocumentLabel:= aDocumentLabel;
  EstdDataModule.LoadDocument(Self, aDocumentLabel);
end;

procedure TdmEstd.LoadDetail(aDetailId: Integer);
begin

end;

procedure TdmEstd.LoadDocument(aDocumentId: Integer);
begin
end;

procedure TdmEstd.LoadFromDB(DocumentLabel: WideString);
begin

end;

procedure TdmEstd.LoadObject(aObjectId: Integer);
begin

end;


procedure TdmEstd.MakeLookupField(aDataSet: TDataSet; aFieldName,
  aKeyFields: string; aLookupDataSet: TDataSet; aLookupKeyFields,
  aLookupResult: string);
var
  LookupField: TField;
  LookupResult: TField;
begin
  LookupField:= TField(DuplicateComponents(aLookupDataSet.FieldByName(aLookupResult)));
  aDataSet.InsertComponent(LookupField);
  with LookupField do
  begin
    FieldName := aFieldName;
    FieldKind := fkLookup;
    DataSet := aDataSet;
    Name := DataSet.Name + '_'+FieldName;
    KeyFields := aKeyFields;
    LookupDataSet := aLookupDataSet;
    LookupKeyFields := aLookupKeyFields;
    LookupResultField := aLookupResult;
    aDataSet.FieldDefs.Add(FieldName, DataType, Size, False);
  end;
end;

end.
