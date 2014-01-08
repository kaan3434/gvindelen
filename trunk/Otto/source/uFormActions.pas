unit uFormActions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uFrameParams, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DB, GridsEh, DBAxisGridsEh, DBGridEh, FIBDataSet,
  pFIBDataSet, uFrameCriterias, TB2Dock, TB2Toolbar, TBX, FIBDatabase,
  pFIBDatabase, ComCtrls, JvExComCtrls, JvDBTreeView, VirtualTrees, TB2Item;

type
  TNodeKind = (nkRoot, nkObjectCode, nkActionCode);
  PVSTRecord = ^TVSTRecord;
  TVSTRecord = record
    NodeKind: TNodeKind;
    Id: Integer;
    Caption: string;
    ObjectSign: string;
  end;

type
  TfrmActionCodeSetup = class(TForm)
    pnl1: TPanel;
    pnl3: TPanel;
    spl1: TSplitter;
    spl2: TSplitter;
    pnl4: TPanel;
    pnl5: TPanel;
    spl3: TSplitter;
    frmParamActionTree: TFrameParams;
    spl4: TSplitter;
    grdActionTree: TDBGridEh;
    dsActionTree: TDataSource;
    dsActionCodes: TDataSource;
    qryActionCodes: TpFIBDataSet;
    qryActionTree: TpFIBDataSet;
    qryActionCodeParams: TpFIBDataSet;
    spl5: TSplitter;
    frmParamActionCode: TFrameParams;
    dckActionTree: TTBXDock;
    tbActionTree: TTBXToolbar;
    dckActionCode: TTBXDock;
    tbActionCodes: TTBXToolbar;
    qryActionCodeCrit: TpFIBDataSet;
    qryActionTreeCrit: TpFIBDataSet;
    qryActionTreeParams: TpFIBDataSet;
    trnWrite: TpFIBTransaction;
    vsTreeActionCodes: TVirtualStringTree;
    TBXItem1: TTBXItem;
    qryObjects: TpFIBDataSet;
    qryTemp: TpFIBDataSet;
    frmCriteriaActionCode: TFrameCriterias;
    frmCriteriaActionTree: TFrameCriterias;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure qryActionTreeAfterScroll(DataSet: TDataSet);
    procedure grdActionTreeDblClick(Sender: TObject);
    procedure vsTreeActionCodesGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vsTreeActionCodesFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vsTreeActionCodesInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure vsTreeActionCodesInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vsTreeActionCodesFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure qryActionCodeParamsBeforePost(DataSet: TDataSet);
    procedure qryActionCodeCritBeforePost(DataSet: TDataSet);
    procedure qryActionTreeParamsBeforePost(DataSet: TDataSet);
    procedure qryActionTreeCritBeforePost(DataSet: TDataSet);
  private
    procedure CreateObjectChilds(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmActionCodeSetup: TfrmActionCodeSetup;

implementation

uses
  uFormParamEdit, GvStr, uFormCriteriaEdit;

{$R *.dfm}

procedure TfrmActionCodeSetup.FormCreate(Sender: TObject);
begin
  trnWrite.StartTransaction;
  FormParamEdit := TFormParamEdit.Create(Self);
  FormParamEdit.trnWrite := trnWrite;
  FormCriteriaEdit := TFormCriteriaEdit.Create(Self);
  FormCriteriaEdit.trnWrite := trnWrite;


  vsTreeActionCodes.NodeDataSize := SizeOf(TVSTRecord);
//  vsTreeActionCodes.RootNodeCount:= trnWrite.DefaultDatabase.QueryValue(
//    'select count(distinct object_sign) from actioncodes',
//    0, trnWrite);
end;

procedure TfrmActionCodeSetup.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FormParamEdit);
  FreeAndNil(FormCriteriaEdit);
  if trnWrite.Active then
    trnWrite.Rollback;
end;

procedure TfrmActionCodeSetup.CreateObjectChilds(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PVSTRecord;
  ChildNode: PVirtualNode;
begin
  qryObjects.First;
  while not qryObjects.Eof do
  begin
    ChildNode := Sender.AddChild(Node);
    if not (vsInitialized in ChildNode.States) then
      vsTreeActionCodes.ReinitNode(ChildNode, False);
    Data := Sender.GetNodeData(ChildNode);
    Data.NodeKind := nkObjectCode;
    Data.Id := qryObjects['OBJECT_CODE'];
    Data.Caption := qryObjects['OBJECT_NAME'];
    qryObjects.Next;
  end;
end;


procedure TfrmActionCodeSetup.FormActivate(Sender: TObject);
var
  RootNode, ChildNode: PVirtualNode;
  I: Integer;
  Id: Variant;
  Data: PVSTRecord;
  ListObjectCodes: string;
begin
  qryActionCodes.Open;
  qryObjects.Open;
  RootNode := vsTreeActionCodes.AddChild(vsTreeActionCodes.RootNode);

//  if not (vsInitialized in RootNode.States) then
//    vsTreeActionCodes.ReinitNode(RootNode, False);
//  Data := vsTreeActionCodes.GetNodeData(RootNode);
//  Data.NodeKind:= nkRoot;
 // Data.Caption := 'Все действия';
//  Data.Id := 0;
//  CreateObjectChilds(vsTreeActionCodes, RootNode);

//    ListObjectCodes:= trnWrite.DefaultDatabase.QueryValue(
//      'with obj as (select object_code from objects order by object_name) '+
//      'select list(object_code) from obj', 0, trnWrite);
//    while ListObjectCodes <> '' do
//    begin
//      Id:= TakeFront5(ListObjectCodes, ',');
//      ChildNode := vsTreeActionCodes.AddChild(RootNode);
//      if not (vsInitialized in ChildNode.States) then
//        vsTreeActionCodes.ReinitNode(ChildNode, False);
//      Data := vsTreeActionCodes.GetNodeData(ChildNode);
//      Data.Id := Id;
//      Data.ObjectSign := 'OBJECT';
//      Data.ElementName := trnWrite.DefaultDatabase.QueryValue(
//        'select object_name||''(''||object_sign||'')'' from objects where object_code = :object_code',
//        0, [Id], trnWrite);
//    end;
end;

procedure TfrmActionCodeSetup.FormDeactivate(Sender: TObject);
begin
  trnWrite.Commit;
end;

procedure TfrmActionCodeSetup.qryActionTreeAfterScroll(DataSet: TDataSet);
begin
  frmParamActionTree.ObjectId := DataSet['actiontreeitem_id'];
  frmCriteriaActionTree.ObjectId := DataSet['actiontreeitem_id'];
end;

procedure TfrmActionCodeSetup.grdActionTreeDblClick(Sender: TObject);
begin
  qryActionCodes.Locate('Action_Code', qryActionTree['Child_Code'], []);
end;

procedure TfrmActionCodeSetup.vsTreeActionCodesGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
var
  Data: PVSTRecord;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data.Caption
end;

procedure TfrmActionCodeSetup.vsTreeActionCodesFreeNode(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PVSTRecord;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    Finalize(Data^);
end;

procedure TfrmActionCodeSetup.vsTreeActionCodesInitNode(
  Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  Data: PVSTRecord;
begin
  Data := Sender.GetNodeData(Node);
  if ParentNode = nil then
  begin
    Data.NodeKind := nkRoot;
    Data.Caption := 'Все действия';
    Data.Id := 0;
    Include(InitialStates, ivsHasChildren);
  end;
end;

procedure TfrmActionCodeSetup.vsTreeActionCodesInitChildren(
  Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var
  NodeData, ChildData: PVSTRecord;
  ChildNode: PVirtualNode;
begin
  NodeData := Sender.GetNodeData(Node);
  if NodeData.NodeKind = nkRoot then
  begin
    qryTemp.SelectSQL.Text :=
      'select * from objects';
    qryTemp.Open;
    while not qryTemp.Eof do
    begin
      ChildNode := Sender.AddChild(Node);
      ChildData := Sender.GetNodeData(ChildNode);
      ChildData.NodeKind := nkObjectCode;
      ChildData.Id := qryTemp['OBJECT_CODE'];
      ChildData.Caption := 'Объект - "' + qryTemp['OBJECT_NAME'] + '"';
      Include(ChildNode.States, vsHasChildren);
      Sender.ValidateNode(Node, False);
      qryTemp.Next;
    end;
    qryTemp.Close;
    ChildCount := Sender.ChildCount[Node];
//    if ChildCount > 0 then
//      Sender.Sort(Node, 0, TVirtualStringTree(Sender).Header.SortDirection, False);
  end
  else
    if NodeData.NodeKind = nkObjectCode then
    begin
      qryTemp.SelectSQL.Text :=
        'select * from actioncodes where object_code = :object_code';
      qryTemp.OpenWP([NodeData.Id]);
      while not qryTemp.Eof do
      begin
        ChildNode := Sender.AddChild(Node);
        Include(ChildNode.States, vsHasChildren);
        if not (vsInitialized in ChildNode.States) then
          Sender.ReinitNode(ChildNode, False);
        ChildData := Sender.GetNodeData(ChildNode);
        ChildData.NodeKind := nkActionCode;
        ChildData.Id := qryTemp['ACTION_CODE'];
        ChildData.Caption := qryActionCodes.Lookup('ACTION_CODE', ChildData.Id, 'ACTION_NAME');
        Sender.ValidateNode(Node, False);
        qryTemp.Next;
      end;
      qryTemp.Close;
      ChildCount := Sender.ChildCount[Node];
    end
    else
      if NodeData.NodeKind = nkActionCode then
      begin
        qryTemp.SelectSQL.Text :=
          'select * from actiontree where action_code = :action_code';
        qryTemp.OpenWP([NodeData.Id]);
        while not qryTemp.Eof do
        begin
          ChildNode := Sender.AddChild(Node);
          Include(ChildNode.States, vsHasChildren);
          if not (vsInitialized in ChildNode.States) then
            Sender.ReinitNode(ChildNode, False);
          ChildData := Sender.GetNodeData(ChildNode);
          ChildData.NodeKind := nkActionCode;
          ChildData.Id := qryTemp['CHILD_CODE'];
          ChildData.Caption := qryActionCodes.Lookup('ACTION_CODE', ChildData.Id, 'ACTION_NAME');
          Sender.ValidateNode(Node, False);
          qryTemp.Next;
        end;
        qryTemp.Close;
        ChildCount := Sender.ChildCount[Node];
      end;
  if ChildCount = 0 then
    Exclude(Node.States, vsHasChildren);
end;

procedure TfrmActionCodeSetup.vsTreeActionCodesFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PVSTRecord;
  NodeIsAction: Boolean;
begin
  Data := Sender.GetNodeData(Node);
  NodeIsAction := Data.NodeKind = nkActionCode;
  frmParamActionCode.Enabled := NodeIsAction;
  frmCriteriaActionCode.Enabled := NodeIsAction;
  if NodeIsAction then
  begin
    qryActionCodes.Locate('ACTION_CODE', Data.Id, []);
    frmParamActionCode.ObjectId := Data.Id;
    frmCriteriaActionCode.ObjectId := Data.Id;
  end;
end;

procedure TfrmActionCodeSetup.qryActionCodeParamsBeforePost(
  DataSet: TDataSet);
begin
  DataSet['OBJECT_ID'] := qryActionCodes['ACTION_CODE'];
end;

procedure TfrmActionCodeSetup.qryActionCodeCritBeforePost(
  DataSet: TDataSet);
begin
  DataSet['OBJECT_ID'] := qryActionCodes['ACTION_CODE'];
end;

procedure TfrmActionCodeSetup.qryActionTreeParamsBeforePost(
  DataSet: TDataSet);
begin
  DataSet['OBJECT_ID'] := qryActionTree['ACTIONTREEITEM_ID'];
end;

procedure TfrmActionCodeSetup.qryActionTreeCritBeforePost(
  DataSet: TDataSet);
begin
  DataSet['OBJECT_ID'] := qryActionTree['ACTIONTREEITEM_ID'];
end;

end.

