{*******************************************************}
{                                                       }
{                       EhLib v5.6                      }
{                   DBGridEhGrouping                    }
{                      Build 5.6.08                     }
{                                                       }
{      Copyright (c) 2001-2012 by Dmitry V. Bolshakov   }
{                                                       }
{*******************************************************}

unit DBGridEhGrouping;

{$I EhLib.Inc}

interface

uses Windows, SysUtils, Messages, Classes, Controls, Forms, StdCtrls,
{$IFDEF CIL}
  EhLibVCLNET,
  System.Runtime.InteropServices, System.Reflection,
{$ELSE}
  EhLibVCL,
{$ENDIF}
{$IFDEF EH_LIB_6} Variants, Types, {$ENDIF}
  Graphics, GridsEh, DBCtrls, Db, Menus, Registry, DBSumLst, DBCtrlsEh,
  IniFiles, ToolCtrlsEh, ImgList, StdActns, PropFilerEh, ActnList,
  MemTreeEh;

type
  TGridGroupDataTreeEh = class;
  TGridDataGroupsEh = class;
  TGridDataGroupLevelsEh = class;
  TGroupDataTreeNodeEh = class;

{  TGroupRowPanelInfoEh = class(TPersistent)
  public
  end;}

{ TGridDataGroupLevelEh }

  TGridDataGroupLevelEh = class(TCollectionItem)
  private
//    FBandPositions: TIntegerDynArray;
    FColor: TColor;
    FColumn: TPersistent;
    FFont: TFont;
    FGroupPanelRect: TRect;
    FOnGetKeyValue: TNotifyEvent;
    FOnGetTitleText: TNotifyEvent;
    FParentColor: Boolean;
    FParentFont: Boolean;
    FRowHeight: Integer;
    FRowLines: Integer;
    FSortOrder: TSortOrderEh;
    function GetColor: TColor;
    function GetFont: TFont;
    function IsColorStored: Boolean;
    function IsFontStored: Boolean;
    procedure SetColor(const Value: TColor);
    procedure SetColumn(const Value: TPersistent);
    procedure SetFont(const Value: TFont);
    procedure SetOnGetKeyValue(const Value: TNotifyEvent);
    procedure SetOnGetTitleText(const Value: TNotifyEvent);
    procedure SetParentColor(const Value: Boolean);
    procedure SetParentFont(const Value: Boolean);
    procedure SetRowHeight(const Value: Integer);
    procedure SetRowLines(const Value: Integer);
    procedure SetSortOrder(const Value: TSortOrderEh);
  protected
    function DefaultColor: TColor;
    function DefaultFont: TFont;
    procedure DrawFormatChanged; virtual;
    procedure FontChanged(Sender: TObject);
    procedure RefreshDefaultFont;
    function GridDataGroupLevels: TGridDataGroupLevelsEh;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function GetGroupRowText(GroupDataTreeNode: TGroupDataTreeNodeEh): String; virtual;
    function GetKeyValue: Variant; virtual;
    function GetKeyValueAsText(GroupDataTreeNode: TGroupDataTreeNodeEh): String; virtual;
    procedure CollapseNodes;
    procedure ExtractNodes;
    procedure ExpandNodes;
    property Color: TColor read GetColor write SetColor stored IsColorStored;
    property Column: TPersistent read FColumn write SetColumn;
    property Font: TFont read GetFont write SetFont stored IsFontStored;
    property GroupPanelRect: TRect read FGroupPanelRect write FGroupPanelRect;
    property ParentColor: Boolean read FParentColor write SetParentColor default True;
    property ParentFont: Boolean read FParentFont write SetParentFont default True;
    property RowHeight: Integer read FRowHeight write SetRowHeight default 0;
    property RowLines: Integer read FRowLines write SetRowLines default 0;
    property SortOrder: TSortOrderEh read FSortOrder write SetSortOrder default soAscEh;

    property OnGetKeyValue: TNotifyEvent read FOnGetKeyValue write SetOnGetKeyValue;
    property OnGetTitleText: TNotifyEvent read FOnGetTitleText write SetOnGetTitleText;
//    property BandPositions: TIntegerDynArray read FBandPositions;
//    property RowPanelInfo: TGroupRowPanelInfoEh read FRowPanelInfo write FRowPanelInfo;
  end;

{ TGridDataGroupLevelsEh }

  TGridDataGroupLevelsEh = class(TCollection)
  private
    FDataGroups: TGridDataGroupsEh;
    function GetDataGroup(Index: Integer): TGridDataGroupLevelEh;
    procedure SetDataGroup(Index: Integer; const Value: TGridDataGroupLevelEh);
    function GetGrid: TComponent;
  protected
    procedure Update(Item: TCollectionItem); override;
    function GetOwner: TPersistent; override;
    procedure RefreshDefaultFont;
    procedure OrderChanged(Item: TGridDataGroupLevelEh); virtual;
  public
    constructor Create(DataGroups: TGridDataGroupsEh; ItemClass: TCollectionItemClass);
    function Add: TGridDataGroupLevelEh;
    property Grid: TComponent read GetGrid;
    property Items[Index: Integer]: TGridDataGroupLevelEh read GetDataGroup write SetDataGroup; default;
  end;

{ TGridDataGroupsEh }

  TGridDataGroupsEh = class(TPersistent)
  private
    FActive: Boolean;
    FActiveGroupColumns: TList;
    FActiveGroupLevels: TList;
    FColor: TColor;
    FFont: TFont;
    FGrid: TComponent;
    FGroupDataTree: TGridGroupDataTreeEh;
    FGroupLevels: TGridDataGroupLevelsEh;
    FGroupPanelVisible: Boolean;
    FInsertingKeyValue: Variant;
    FParentColor: Boolean;
    FParentFont: Boolean;
    FDefaultStateExpanded: Boolean;
    function GetActiveGroupLevels(const Index: Integer): TGridDataGroupLevelEh;
    function GetActiveGroupLevelsCount: Integer;
    function GetColor: TColor;
    function GetFont: TFont;
    function IsColorStored: Boolean;
    function IsFontStored: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetColor(const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure SetGroupLevels(const Value: TGridDataGroupLevelsEh);
    procedure SetGroupPanelVisible(const Value: Boolean);
    procedure SetParentColor(const Value: Boolean);
    procedure SetParentFont(const Value: Boolean);
  protected
    function CreateGroupLevels: TGridDataGroupLevelsEh; virtual;
    function DefaultColor: TColor;
    function DefaultFont: TFont;
    function GetOwner: TPersistent; override;
    procedure ActiveChanged; virtual;
    procedure ActiveGroupingStructChanged; virtual;
    procedure CheckActiveGroupLevels;
    procedure DrawFormatChanged; virtual;
    procedure FontChanged(Sender: TObject);
    procedure RebuildActiveGroupLevels; virtual;
    procedure RefreshDefaultFont;
    procedure ResortActiveLevel(LevelIndex: Integer; SortOrder: TSortOrderEh); virtual;
  public
    constructor Create(AGrid: TComponent);
    destructor Destroy; override;
    function GetKeyValueForViewRecNo(ViewRecNo: Integer): Variant;
    function IsGroupingWorks: Boolean; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure SetInsertingKeyValue(KeyValue: Variant);
    property ActiveGroupLevels[const Index: Integer]: TGridDataGroupLevelEh read GetActiveGroupLevels;
    property ActiveGroupLevelsCount: Integer read GetActiveGroupLevelsCount;
    property GroupDataTree: TGridGroupDataTreeEh read FGroupDataTree;
  published
    property Active: Boolean read FActive write SetActive default False;
    property Color: TColor read GetColor write SetColor stored IsColorStored;
    property Font: TFont read GetFont write SetFont stored IsFontStored;
    property GroupLevels: TGridDataGroupLevelsEh read FGroupLevels write SetGroupLevels;
    property GroupPanelVisible: Boolean read FGroupPanelVisible write SetGroupPanelVisible default False;
    property ParentColor: Boolean read FParentColor write SetParentColor default True;
    property ParentFont: Boolean read FParentFont write SetParentFont default True;
    property DefaultStateExpanded: Boolean read FDefaultStateExpanded write FDefaultStateExpanded default False;
  end;

  TGroupDataTreeNodeTypeEh = (dntDataSetRecordEh, dntDataGroupEh);

{ TGroupDataTreeNodeEh }

  TGroupDataTreeNodeEh = class(TBaseTreeNodeEh)
  private
    FDataGroup: TGridDataGroupLevelEh;
    FDataSetRecordViewNo: Integer;
    FFullKey: Variant;
    FGroupDataTreeNodeType: TGroupDataTreeNodeTypeEh;
    FKeyValue: Variant;
    FRowHeight: Integer;
    FRowHeightNeedUpdate: Boolean;
    FDisplayValue: String;
    function GetDataItem(const Index: Integer): TGroupDataTreeNodeEh;
    function GetRowHeight: Integer;
    procedure SetRowHeight(const Value: Integer);
  public
    procedure RowDataChanged;
    procedure UpdateRowHeight;
    property Count;
    property DataGroup: TGridDataGroupLevelEh read FDataGroup;
    property DataSetRecordViewNo: Integer read FDataSetRecordViewNo;
    property Expanded;
    property FullKey: Variant read FFullKey;
    property Items[const Index: Integer]: TGroupDataTreeNodeEh read GetDataItem; default;
    property KeyValue: Variant read FKeyValue;
    property DisplayValue: String read FDisplayValue;
    property Level;
    property NodeType: TGroupDataTreeNodeTypeEh read FGroupDataTreeNodeType;
    property Parent;
    property RowHeight: Integer read GetRowHeight write SetRowHeight;
    property RowHeightNeedUpdate: Boolean read FRowHeightNeedUpdate;
  end;

{ TGridGroupDataTreeEh }

  TGridGroupDataTreeEh = class(TTreeListEh)
  private
    FGridDataGroups: TGridDataGroupsEh;
    FlatVisibleList: TList;
    FUpateCount: Integer;
    function GetFlatVisibleItem(const Index: Integer): TGroupDataTreeNodeEh;
    function GetVisibleCount: Integer;
  protected
    procedure ExpandedChanged(Node: TBaseTreeNodeEh); override;
    procedure CollapseLevel(LevelIndex: Integer);
    procedure ExpandLevel(LevelIndex: Integer);
  public
    constructor Create(AGridDataGroups: TGridDataGroupsEh; ItemClass: TTreeNodeClassEh);
    destructor Destroy; override;
    function AddRecordNodeForKey(AKey: Variant; RecViewNo: Integer): TGroupDataTreeNodeEh;
    function CompareNodes(Node1, Node2: TBaseTreeNodeEh; ParamSort: TObject): Integer;
    function GetFirstNodeAtLevel(Level: Integer): TGroupDataTreeNodeEh;
    function GetNextNodeAtLevel(Node: TGroupDataTreeNodeEh; Level: Integer): TGroupDataTreeNodeEh;
    function GetNodeByRecordViewNo(RecordViewNo: Integer): TGroupDataTreeNodeEh;
    function GetNodeToInsertForKey1(ParentNode: TGroupDataTreeNodeEh; Key1: Variant; SortOrder: TSortOrderEh; var InsertMode: TNodeAttachModeEh): TGroupDataTreeNodeEh;
    function IndexOfVisibleNode(Node: TGroupDataTreeNodeEh): Integer;
    function IndexOfVisibleRecordViewNo(RecordViewNo: Integer): Integer;
    procedure BeginUpdate;
    procedure DeleteEmptyNodes;
    procedure DeleteRecordNode(RecNode: TGroupDataTreeNodeEh);
    procedure DeleteRecordNodes;
    procedure DeleteRecordNodesUpToLevel(Level: Integer);
    procedure EndUpdate;
    procedure ExpandNodePathToView(Node: TGroupDataTreeNodeEh);
    procedure RebuildDataTree(AIntMemTable: IMemTableEh);
    procedure RebuildDataTreeEx(AIntMemTable: IMemTableEh);
    procedure RebuildFlatVisibleList;
    procedure RecordChanged(RecNum: Integer);
    procedure RecordDeleted(RecNum: Integer);
    procedure RecordInserted(RecNum: Integer);
    procedure ResortLevel(LevelIndex: Integer; SortOrder: TSortOrderEh);
    procedure SetDataSetkeyValue;
    procedure UpdateAllDataRowHeights;
    procedure UpdateRecordNodePosInTree(RecNode: TGroupDataTreeNodeEh);
    property FlatVisibleCount: Integer read GetVisibleCount;
    property FlatVisibleItem[const Index: Integer]: TGroupDataTreeNodeEh read GetFlatVisibleItem;
    property GridDataGroups: TGridDataGroupsEh read FGridDataGroups;
    property UpdateCount: Integer read FUpateCount;
  end;

implementation

uses DBGridEh;

type
  TCustomDBGridEhCrack = class(TCustomDBGridEh) end;

{ TGridDataGroupLevelsEh }

function TGridDataGroupLevelsEh.Add: TGridDataGroupLevelEh;
begin
  Result := TGridDataGroupLevelEh(inherited Add);
end;

constructor TGridDataGroupLevelsEh.Create(DataGroups: TGridDataGroupsEh; ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FDataGroups := DataGroups;
end;

function TGridDataGroupLevelsEh.GetDataGroup(Index: Integer): TGridDataGroupLevelEh;
begin
  Result := TGridDataGroupLevelEh(inherited Items[Index]);
end;

function TGridDataGroupLevelsEh.GetGrid: TComponent;
begin
  Result := FDataGroups.FGrid;
end;

function TGridDataGroupLevelsEh.GetOwner: TPersistent;
begin
  Result := FDataGroups;
end;

procedure TGridDataGroupLevelsEh.OrderChanged(Item: TGridDataGroupLevelEh);
var
  ActiveItemIndex: Integer;
begin
  ActiveItemIndex := FDataGroups.FActiveGroupLevels.IndexOf(Item);
  if ActiveItemIndex >= 0 then
    FDataGroups.ResortActiveLevel(ActiveItemIndex, Item.SortOrder);
end;

procedure TGridDataGroupLevelsEh.RefreshDefaultFont;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].RefreshDefaultFont;
end;

procedure TGridDataGroupLevelsEh.SetDataGroup(Index: Integer; const Value: TGridDataGroupLevelEh);
begin
  Items[Index].Assign(Value);
end;

procedure TGridDataGroupLevelsEh.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  FDataGroups.CheckActiveGroupLevels;
  TCustomDBGridEhCrack(Grid).UpdateDesigner;
end;

{ TGridDataGroupsEh }

constructor TGridDataGroupsEh.Create(AGrid: TComponent);
begin
  inherited Create;
  FGrid := AGrid;
  FGroupLevels := CreateGroupLevels;
  FGroupDataTree := TGridGroupDataTreeEh.Create(Self, TGroupDataTreeNodeEh);
  FActiveGroupLevels := TList.Create;
  FActiveGroupColumns := TList.Create;
  FFont := TFont.Create;
  FFont.Assign(DefaultFont);
  FFont.OnChange := FontChanged;
  FColor := clWindow;
  FParentFont := True;
  FParentColor := True;
end;

destructor TGridDataGroupsEh.Destroy;
begin
  FreeAndNil(FGroupLevels);
  FreeAndNil(FGroupDataTree);
  FreeAndNil(FActiveGroupLevels);
  FreeAndNil(FActiveGroupColumns);
  FreeAndNil(FFont);
  inherited Destroy;
end;

function TGridDataGroupsEh.GetActiveGroupLevels(const Index: Integer): TGridDataGroupLevelEh;
begin
  Result := TGridDataGroupLevelEh(FActiveGroupLevels[Index]);
end;

function TGridDataGroupsEh.GetActiveGroupLevelsCount: Integer;
begin
  Result := FActiveGroupLevels.Count;
end;

procedure TGridDataGroupsEh.RebuildActiveGroupLevels;
var
  k: Integer;
begin
  FActiveGroupLevels.Clear;
  FActiveGroupColumns.Clear;
  for k := 0 to GroupLevels.Count-1 do
  begin
    if GroupLevels[k].Column <> nil then
    begin
      FActiveGroupLevels.Add(GroupLevels[k]);
      FActiveGroupColumns.Add(GroupLevels[k].Column);
    end;
  end;
end;

procedure TGridDataGroupsEh.CheckActiveGroupLevels;
var
  k, j: Integer;
  Item: TGridDataGroupLevelEh;
  NeedRebuild: Boolean;
begin
  j := 0;
  NeedRebuild := False;
(*  if GroupLevels.Count < FActiveGroupLevels.Count then
  begin
    NeedRebuild := True;
  end;*)

  for k := 0 to GroupLevels.Count-1 do
  begin
    Item := GroupLevels[k];
    if Item.Column <> nil then
    begin
      if (j >= FActiveGroupLevels.Count) or
         (FActiveGroupLevels[j] <> Item) or
         (FActiveGroupColumns[j] <> Item.Column)then
      begin
        NeedRebuild := True;
        Break;
      end;
      Inc(j);
    end;
  end;

  if NeedRebuild or (FActiveGroupLevels.Count <> j) then
  begin
    GroupDataTree.DeleteRecordNodesUpToLevel(j+1);
    RebuildActiveGroupLevels;
    if Active then
    begin
      ActiveGroupingStructChanged;
    end;
  end;
end;

function TGridDataGroupsEh.GetKeyValueForViewRecNo(ViewRecNo: Integer): Variant;
var
  RecordNoChanged: Boolean;
  i: Integer;
begin
  RecordNoChanged := False;
  if TCustomDBGridEhCrack(FGrid).FIntMemTable.GetInstantReadCurRowNum <> ViewRecNo then
  begin
    TCustomDBGridEhCrack(FGrid).FIntMemTable.InstantReadEnter(ViewRecNo);
    RecordNoChanged := True;
  end;
  try
    Result := VarArrayCreate([0, ActiveGroupLevelsCount], varVariant);
    for i := 0 to ActiveGroupLevelsCount-1 do
      Result[i] := ActiveGroupLevels[i].GetKeyValue;
    Result[ActiveGroupLevelsCount] := ViewRecNo;
  finally
    if RecordNoChanged then
      TCustomDBGridEhCrack(FGrid).FIntMemTable.InstantReadLeave;
  end;
end;

procedure TGridDataGroupsEh.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    ActiveChanged;
  end;
end;

procedure TGridDataGroupsEh.SetGroupPanelVisible(const Value: Boolean);
begin
  if FGroupPanelVisible <> Value then
  begin
    FGroupPanelVisible := Value;
    TCustomDBGridEhCrack(FGrid).GroupPanelVisibleChanged;
  end;
end;

procedure TGridDataGroupsEh.SetInsertingKeyValue(KeyValue: Variant);
begin
  FInsertingKeyValue := KeyValue;
end;

function TGridDataGroupsEh.CreateGroupLevels: TGridDataGroupLevelsEh;
begin
  Result := TGridDataGroupLevelsEh.Create(Self, TGridDataGroupLevelEh);
end;

procedure TGridDataGroupsEh.ActiveChanged;
begin
end;

procedure TGridDataGroupsEh.ActiveGroupingStructChanged;
begin
end;

procedure TGridDataGroupsEh.Assign(Source: TPersistent);
begin
  if Source is TGridDataGroupsEh then
  begin
    Active := TGridDataGroupsEh(Source).Active;
    GroupLevels := TGridDataGroupsEh(Source).GroupLevels;
    GroupPanelVisible := TGridDataGroupsEh(Source).GroupPanelVisible;
  end else
    inherited Assign(Source);
end;

procedure TGridDataGroupsEh.SetGroupLevels(
  const Value: TGridDataGroupLevelsEh);
begin
  FGroupLevels.Assign(Value);
end;

function TGridDataGroupsEh.GetOwner: TPersistent;
begin
  Result := FGrid;
end;

function TGridDataGroupsEh.IsGroupingWorks: Boolean;
begin
  Result := Active;
end;

function TGridDataGroupsEh.GetFont: TFont;
begin
  if ParentFont and (FFont.Handle <> DefaultFont.Handle) then
    RefreshDefaultFont;
  Result := FFont;
end;

procedure TGridDataGroupsEh.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
//  FParentFont := False;
//  Changed(False);
end;

function TGridDataGroupsEh.IsFontStored: Boolean;
begin
  Result := not ParentFont;
end;

procedure TGridDataGroupsEh.SetParentFont(const Value: Boolean);
begin
  if FParentFont <> Value then
  begin
    FParentFont := Value;
    RefreshDefaultFont;
    DrawFormatChanged;
  end;
end;

function TGridDataGroupsEh.DefaultFont: TFont;
begin
  if Assigned(FGrid)
    then Result := TCustomDBGridEhCrack(FGrid).Font
    else Result := FFont;
end;

procedure TGridDataGroupsEh.FontChanged(Sender: TObject);
begin
  FParentFont := False;
  GroupLevels.RefreshDefaultFont;
  DrawFormatChanged;
end;

procedure TGridDataGroupsEh.RefreshDefaultFont;
var
  Save: TNotifyEvent;
begin
  if not ParentFont then Exit;
  Save := FFont.OnChange;
  FFont.OnChange := nil;
  try
    FFont.Assign(DefaultFont);
  finally
    FFont.OnChange := Save;
  end;
  GroupLevels.RefreshDefaultFont;
end;

procedure TGridDataGroupsEh.DrawFormatChanged;
begin
  TCustomDBGridEhCrack(FGrid).Invalidate;
end;

function TGridDataGroupsEh.GetColor: TColor;
begin
  if ParentColor
    then Result := DefaultColor
    else Result := FColor;
end;

function TGridDataGroupsEh.IsColorStored: Boolean;
begin
  Result := not ParentColor;
end;

procedure TGridDataGroupsEh.SetColor(const Value: TColor);
begin
  if not ParentColor and (Value = FColor) then Exit;
  FColor := Value;
  ParentColor := False;
  DrawFormatChanged;
end;

procedure TGridDataGroupsEh.SetParentColor(const Value: Boolean);
begin
  if FParentColor <> Value then
  begin
    FParentColor := Value;
    DrawFormatChanged;
  end;
end;

function TGridDataGroupsEh.DefaultColor: TColor;
begin
  if Assigned(FGrid)
    then Result := TCustomDBGridEhCrack(FGrid).Color
    else Result := FColor;
end;

procedure TGridDataGroupsEh.ResortActiveLevel(LevelIndex: Integer;
  SortOrder: TSortOrderEh);
begin
  GroupDataTree.ResortLevel(LevelIndex, SortOrder);
end;

{ TGridDataGroupLevelEh }

constructor TGridDataGroupLevelEh.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFont := TFont.Create;
  FFont.Assign(DefaultFont);
  FFont.OnChange := FontChanged;
  FColor := clWindow;
  FParentFont := True;
  FParentColor := True;
end;

destructor TGridDataGroupLevelEh.Destroy;
begin
  FreeAndNil(FFont);
  inherited Destroy;
end;

function TGridDataGroupLevelEh.DefaultColor: TColor;
begin
  if Assigned(Collection)
    then Result := TGridDataGroupLevelsEh(Collection).FDataGroups.Color
    else Result := FColor;
end;

function TGridDataGroupLevelEh.DefaultFont: TFont;
begin
  if Assigned(Collection)
    then Result := TGridDataGroupLevelsEh(Collection).FDataGroups.Font
    else Result := FFont;
end;

procedure TGridDataGroupLevelEh.DrawFormatChanged;
begin
  if Assigned(Collection) then
    TCustomDBGridEhCrack(TGridDataGroupLevelsEh(Collection).FDataGroups.FGrid).Invalidate;
end;

procedure TGridDataGroupLevelEh.FontChanged(Sender: TObject);
begin
  FParentFont := False;
  DrawFormatChanged;
end;

function TGridDataGroupLevelEh.GetColor: TColor;
begin
  if ParentColor
    then Result := DefaultColor
    else Result := FColor;
end;

function TGridDataGroupLevelEh.GetFont: TFont;
begin
  if ParentFont and (FFont.Handle <> DefaultFont.Handle) then
    RefreshDefaultFont;
  Result := FFont;
end;

function TGridDataGroupLevelEh.GetGroupRowText(
  GroupDataTreeNode: TGroupDataTreeNodeEh): String;
begin
  Result := '';
end;

function TGridDataGroupLevelEh.GetKeyValue: Variant;
begin
  if Assigned(FOnGetKeyValue) then
    OnGetKeyValue(Self)
  else if Assigned(Column) and Assigned(TColumnEh(Column).Field) and TColumnEh(Column).Field.DataSet.Active then
    Result := TColumnEh(Column).Field.Value;
end;

function TGridDataGroupLevelEh.GetKeyValueAsText(GroupDataTreeNode: TGroupDataTreeNodeEh): String;
begin
  Result := VarToStr(GroupDataTreeNode.KeyValue);
end;

function TGridDataGroupLevelEh.IsColorStored: Boolean;
begin
  Result := not ParentColor;
end;

function TGridDataGroupLevelEh.IsFontStored: Boolean;
begin
  Result := not ParentFont;
end;

procedure TGridDataGroupLevelEh.RefreshDefaultFont;
var
  Save: TNotifyEvent;
begin
  if not ParentFont then Exit;
  Save := FFont.OnChange;
  FFont.OnChange := nil;
  try
    FFont.Assign(DefaultFont);
  finally
    FFont.OnChange := Save;
  end;
end;

procedure TGridDataGroupLevelEh.SetColor(const Value: TColor);
begin
  if not ParentColor and (Value = FColor) then Exit;
  FColor := Value;
  ParentColor := False;
  DrawFormatChanged;
end;

procedure TGridDataGroupLevelEh.SetColumn(const Value: TPersistent);
begin
  if FColumn <> Value then
  begin
    FColumn := Value;
    Changed(False);
  end;
end;

procedure TGridDataGroupLevelEh.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TGridDataGroupLevelEh.SetOnGetKeyValue(const Value: TNotifyEvent);
begin
  FOnGetKeyValue := Value;
end;

procedure TGridDataGroupLevelEh.SetOnGetTitleText(const Value: TNotifyEvent);
begin
  FOnGetTitleText := Value;
end;

procedure TGridDataGroupLevelEh.SetParentColor(const Value: Boolean);
begin
  if FParentColor <> Value then
  begin
    FParentColor := Value;
    DrawFormatChanged;
  end;
end;

procedure TGridDataGroupLevelEh.SetParentFont(const Value: Boolean);
begin
  if FParentFont <> Value then
  begin
    FParentFont := Value;
    RefreshDefaultFont;
    DrawFormatChanged;
  end;
end;

procedure TGridDataGroupLevelEh.SetRowHeight(const Value: Integer);
begin
  if FRowHeight <> Value then
  begin
    FRowHeight := Value;
  end;
end;

procedure TGridDataGroupLevelEh.SetRowLines(const Value: Integer);
begin
  if FRowLines <> Value then
  begin
    FRowLines := Value
  end;
end;

procedure TGridDataGroupLevelEh.SetSortOrder(const Value: TSortOrderEh);
begin
  if FSortOrder <> Value then
  begin
    FSortOrder := Value;
    GridDataGroupLevels.OrderChanged(Self);
//    Changed(False);
  end;
end;

procedure TGridDataGroupLevelEh.CollapseNodes;
var
  GrIndex: Integer;
begin
  GrIndex := TGridDataGroupLevelsEh(Collection).FDataGroups.FActiveGroupLevels.IndexOf(Self);
  if GrIndex >= 0 then
    TGridDataGroupLevelsEh(Collection).FDataGroups.GroupDataTree.CollapseLevel(GrIndex+1);
end;

procedure TGridDataGroupLevelEh.ExtractNodes;
var
  GrIndex: Integer;
begin
  GrIndex := TGridDataGroupLevelsEh(Collection).FDataGroups.FActiveGroupLevels.IndexOf(Self);
  if GrIndex >= 0 then
    TGridDataGroupLevelsEh(Collection).FDataGroups.GroupDataTree.ExpandLevel(GrIndex+1);
end;

procedure TGridDataGroupLevelEh.ExpandNodes;
begin
  ExtractNodes;
end;

function TGridDataGroupLevelEh.GridDataGroupLevels: TGridDataGroupLevelsEh;
begin
  Result := TGridDataGroupLevelsEh(Collection);
end;

{ TGridGroupDataTreeEh }

function TGridGroupDataTreeEh.AddRecordNodeForKey(AKey: Variant; RecViewNo: Integer): TGroupDataTreeNodeEh;
var
  k{, j}: Integer;
  Key1: Variant;
  ParentNode, Node: TGroupDataTreeNodeEh;
  InsertMode: TNodeAttachModeEh;
  TargetNode: TGroupDataTreeNodeEh;
  SortOrder: TSortOrderEh;
begin
  ParentNode := TGroupDataTreeNodeEh(Root);
  TargetNode := ParentNode;
  InsertMode := naAddChildEh;
  for k := 0 to GridDataGroups.ActiveGroupLevelsCount-1 do
  begin
    Key1 := AKey[k];
    SortOrder := GridDataGroups.ActiveGroupLevels[k].SortOrder;
    if (InsertMode = naAddChildEh) and (TargetNode <> nil) then
      TargetNode := GetNodeToInsertForKey1(ParentNode, Key1, SortOrder, InsertMode);
//      naAddEh, naAddChildEh, naInsertEh
    if (InsertMode = naAddChildEh) and (TargetNode <> nil) then
    begin
      ParentNode := TargetNode;
      if ParentNode.FDataSetRecordViewNo = -1 then
        ParentNode.FDataSetRecordViewNo := RecViewNo;
      Continue;
    end else
    begin
      if TargetNode = nil then
        ParentNode := TGroupDataTreeNodeEh(AddChild('', ParentNode, nil))
      else
      begin
        Node := TGroupDataTreeNodeEh(CreateNodeApart('', nil));
        AddNode(Node, TargetNode, InsertMode, True);
        ParentNode := Node;
        TargetNode := nil;
      end;
    end;
    ParentNode.FDataGroup := GridDataGroups.ActiveGroupLevels[k];
    ParentNode.FGroupDataTreeNodeType := dntDataGroupEh;
    ParentNode.FDataSetRecordViewNo := RecViewNo;
    ParentNode.FKeyValue := Key1;
    ParentNode.FDisplayValue := ParentNode.FDataGroup.GetKeyValueAsText(ParentNode);
    ParentNode.Expanded := GridDataGroups.DefaultStateExpanded;
    ParentNode.RowDataChanged;
  end;

  Key1 := AKey[GridDataGroups.ActiveGroupLevelsCount];
  TargetNode := GetNodeToInsertForKey1(ParentNode, Key1, soAscEh, InsertMode);
  if TargetNode = nil then
    Result := TGroupDataTreeNodeEh(AddChild('', ParentNode, nil))
  else
  begin
    Result := TGroupDataTreeNodeEh(CreateNodeApart('', nil));
    if InsertMode = naAddChildEh then
    begin
//      TargetNode := ParentNode;
      InsertMode := naInsertEh;
    end;
    AddNode(Result, TargetNode, InsertMode, True);
  end;
//  Result := TGroupDataTreeNodeEh(AddChild('', ParentNode, nil))
end;

constructor TGridGroupDataTreeEh.Create(AGridDataGroups: TGridDataGroupsEh; ItemClass: TTreeNodeClassEh);
begin
  FGridDataGroups := AGridDataGroups;
  FlatVisibleList := TList.Create;
  inherited Create(ItemClass);
end;

destructor TGridGroupDataTreeEh.Destroy;
begin
  FreeAndNil(FlatVisibleList);
  inherited Destroy;
end;

procedure TGridGroupDataTreeEh.ExpandedChanged(Node: TBaseTreeNodeEh);
begin
  inherited ExpandedChanged(Node);
  if UpdateCount = 0 then
    RebuildFlatVisibleList;
end;

function TGridGroupDataTreeEh.GetFlatVisibleItem(const Index: Integer): TGroupDataTreeNodeEh;
begin
  Result := TGroupDataTreeNodeEh(FlatVisibleList[Index]);
end;

function TGridGroupDataTreeEh.GetNodeByRecordViewNo(RecordViewNo: Integer): TGroupDataTreeNodeEh;
var
  Node: TGroupDataTreeNodeEh;
begin
  Result := nil;
  Node := TGroupDataTreeNodeEh(GetFirst);
  while Node <> nil do
  begin
    if (Node.NodeType = dntDataSetRecordEh) and
       (Node.DataSetRecordViewNo = RecordViewNo) then
    begin
      Result := Node;
      Exit;
    end;  
    Node := TGroupDataTreeNodeEh(GetNext(Node));
  end;
end;

function TGridGroupDataTreeEh.GetNodeToInsertForKey1(
  ParentNode: TGroupDataTreeNodeEh; Key1: Variant; SortOrder: TSortOrderEh;
  var InsertMode: TNodeAttachModeEh): TGroupDataTreeNodeEh;
//BinSearch
var
  CurIndex, NewIndex, AMin, AMax : Integer;
  Relationship: TVariantRelationship;
begin
  if ParentNode.Count = 0 then
  begin
    Result := nil;
    InsertMode := naAddChildEh;
    Exit;
  end;
  Relationship := DBVarCompareValue(ParentNode[0].KeyValue, Key1);
  if (Relationship = vrGreaterThan) and (SortOrder = soAscEh)
   or
     (Relationship = vrLessThan) and (SortOrder = soDescEh) then
  begin
    Result := ParentNode[0];
    InsertMode := naInsertEh;
    Exit;
  end;
  Relationship := DBVarCompareValue(ParentNode[ParentNode.Count-1].KeyValue, Key1);
  if (Relationship = vrLessThan) and (SortOrder = soAscEh)
   or
     (Relationship = vrGreaterThan) and (SortOrder = soDescEh) then
  begin
    Result := ParentNode[ParentNode.Count-1];
    InsertMode := naAddEh;
    Exit;
  end;
  AMin := 0; AMax := ParentNode.Count - 1;
  CurIndex := (AMax - AMin) div 2;
  NewIndex := CurIndex;
  while True do
  begin
    Relationship := DBVarCompareValue(ParentNode[CurIndex].KeyValue, Key1);
    if (Relationship = vrGreaterThan) and (SortOrder = soAscEh)
     or
       (Relationship = vrLessThan) and (SortOrder = soDescEh) then
    begin
      AMax := CurIndex;
      CurIndex := (AMax + AMin) div 2;
    end else if (Relationship = vrLessThan) and (SortOrder = soAscEh)
             or
                (Relationship = vrGreaterThan) and (SortOrder = soDescEh) then
    begin
      AMin := CurIndex;
      CurIndex := (AMax + AMin) div 2;
    end else
    begin
      Result := ParentNode[CurIndex];
      InsertMode := naAddChildEh;
      Exit;
    end;
    if NewIndex = CurIndex then
    begin
      Inc(NewIndex);
      if DBVarCompareValue(ParentNode[NewIndex].KeyValue, Key1) = vrEqual
        then InsertMode := naAddChildEh
        else InsertMode := naInsertEh;
      Result := ParentNode[NewIndex];
      Exit;
    end;
    NewIndex := CurIndex;
  end;
end;

function TGridGroupDataTreeEh.GetVisibleCount: Integer;
begin
  Result := FlatVisibleList.Count;
end;

function TGridGroupDataTreeEh.IndexOfVisibleNode(Node: TGroupDataTreeNodeEh): Integer;
begin
  Result := FlatVisibleList.IndexOf(Node);
end;

procedure TGridGroupDataTreeEh.DeleteEmptyNodes;
var
  Node, DelNode: TGroupDataTreeNodeEh;
begin
//TODO: Optimize
//Not finished if tree deeper than 1.
  Node := TGroupDataTreeNodeEh(GetFirstVisible);
  while Node <> nil do
  begin
    if (Node.NodeType = dntDataGroupEh) and (Node.Count = 0) then
    begin
      DelNode := Node;
      Node := TGroupDataTreeNodeEh(GetPrevious(Node));
      DeleteNode(DelNode, True);
      if Node = nil then
        Node := TGroupDataTreeNodeEh(GetFirstVisible);
    end else
      Node := TGroupDataTreeNodeEh(GetNextVisible(Node, False));
  end;
end;

procedure TGridGroupDataTreeEh.DeleteRecordNodes;
var
  Node, DelNode: TGroupDataTreeNodeEh;
  NodeLevel: Integer;
  GroupLevel: TGridDataGroupLevelEh;
begin
//TODO: Optimize
  Node := TGroupDataTreeNodeEh(GetFirstVisible);
  while Node <> nil do
  begin
    if Node.NodeType = dntDataSetRecordEh
      then DelNode := Node
      else DelNode := nil;
    Node := TGroupDataTreeNodeEh(GetNextVisible(Node, False));
    if DelNode <> nil then
      DeleteNode(DelNode, True);
  end;

//Delete expared nodes
  Node := TGroupDataTreeNodeEh(GetFirstVisible);
  while Node <> nil do
  begin
    Node.FDataSetRecordViewNo := -1;
    DelNode := nil;
    if Node.Count = 0 then
    begin
      NodeLevel := Node.Level;
      if FGridDataGroups.ActiveGroupLevelsCount >= NodeLevel
        then GroupLevel := FGridDataGroups.ActiveGroupLevels[NodeLevel-1]
        else GroupLevel := nil;
      if GroupLevel <> Node.DataGroup then
        DelNode := Node;
    end;
    Node := TGroupDataTreeNodeEh(GetNextVisible(Node, False));
    if DelNode <> nil then
      DeleteNode(DelNode, True);
  end;

end;

procedure TGridGroupDataTreeEh.RebuildDataTreeEx(AIntMemTable: IMemTableEh);
var
  i, j: Integer;
  RecNode: TGroupDataTreeNodeEh;
  KeyValue: Variant;
begin
  BeginUpdate;
  try
    DeleteRecordNodes;
    KeyValue := VarArrayCreate([0, GridDataGroups.ActiveGroupLevelsCount], varVariant);

    for i := 0 to AIntMemTable.InstantReadRowCount-1 do
    begin
      AIntMemTable.InstantReadEnter(i);
      try
        for j := 0 to GridDataGroups.ActiveGroupLevelsCount-1 do
          KeyValue[j] := GridDataGroups.ActiveGroupLevels[j].GetKeyValue;
        KeyValue[GridDataGroups.ActiveGroupLevelsCount] := i;

        RecNode := AddRecordNodeForKey(KeyValue, i);
        RecNode.FDataGroup := nil;
        RecNode.FGroupDataTreeNodeType := dntDataSetRecordEh;
        RecNode.FDataSetRecordViewNo := i;
        RecNode.FFullKey := GridDataGroups.GetKeyValueForViewRecNo(i);
        RecNode.FKeyValue := i;
        RecNode.RowDataChanged;
      finally
        AIntMemTable.InstantReadLeave;
      end;
    end;
    DeleteEmptyNodes;
  finally
    EndUpdate;
  end;
  RebuildFlatVisibleList;
  UpdateAllDataRowHeights;
end;

procedure TGridGroupDataTreeEh.RebuildDataTree(AIntMemTable: IMemTableEh);
var
  i, j: Integer;
//  Nodes: array of TGroupDataTreeNodeEh;
  RecNode: TGroupDataTreeNodeEh;
//  ValueChanged: Boolean;
  KeyValue: Variant;
begin
  Clear;
//  if AIntMemTable.InstantReadRowCount = 0 then Exit;
  KeyValue := VarArrayCreate([0, GridDataGroups.ActiveGroupLevelsCount], varVariant);

  BeginUpdate;
  try
  for i := 0 to AIntMemTable.InstantReadRowCount-1 do
  begin
    AIntMemTable.InstantReadEnter(i);
    try
      for j := 0 to GridDataGroups.ActiveGroupLevelsCount-1 do
        KeyValue[j] := GridDataGroups.ActiveGroupLevels[j].GetKeyValue;
      KeyValue[GridDataGroups.ActiveGroupLevelsCount] := i;

      RecNode := AddRecordNodeForKey(KeyValue, i);
      RecNode.FDataGroup := nil;
      RecNode.FGroupDataTreeNodeType := dntDataSetRecordEh;
      RecNode.FDataSetRecordViewNo := i;
      RecNode.FFullKey := GridDataGroups.GetKeyValueForViewRecNo(i);
      RecNode.FKeyValue := i;
      RecNode.RowDataChanged;
    finally
      AIntMemTable.InstantReadLeave;
    end;
  end;
  finally
    EndUpdate;
  end;
{
  AIntMemTable.InstantReadEnter(0);
  try
  SetLength(Nodes, GridDataGroups.GroupLevels.Count);
  Node := TGroupDataTreeNodeEh(Root);
  for i := 0 to GridDataGroups.GroupLevels.Count-1 do
  begin
    Node := TGroupDataTreeNodeEh(AddChild('', Node, nil));
    Node.FDataGroup := GridDataGroups.GroupLevels[i];
    Node.FGroupDataTreeNodeType := dntDataGroupEh;
    Node.FKeyValue := GridDataGroups.GroupLevels[i].GetKeyValue;
    Nodes[i] := Node;
  end;
  finally
    AIntMemTable.InstantReadLeave;
  end;

  for i := 0 to AIntMemTable.InstantReadRowCount-1 do
  begin
    AIntMemTable.InstantReadEnter(i);
    try
    ValueChanged := False;
    for j := 0 to GridDataGroups.GroupLevels.Count-1 do
    begin
      if not ValueChanged and
         not VarEquals(Nodes[j].KeyValue, GridDataGroups.GroupLevels[j].GetKeyValue) then
      begin
        Node := TGroupDataTreeNodeEh(Nodes[j].Parent);
        ValueChanged := True;
      end;
      if ValueChanged then
      begin
        Node := TGroupDataTreeNodeEh(AddChild('', Node, nil));
        Node.FDataGroup := GridDataGroups.GroupLevels[j];
        Node.FGroupDataTreeNodeType := dntDataGroupEh;
        Node.FKeyValue := GridDataGroups.GroupLevels[j].GetKeyValue;
        Nodes[j] := Node;
      end;
    end;
    finally
      AIntMemTable.InstantReadLeave;
    end;
    //Data record
    Node := TGroupDataTreeNodeEh(AddChild('', Nodes[Length(Nodes)-1], nil));
    Node.FDataGroup := nil;
    Node.FGroupDataTreeNodeType := dntDataSetRecordEh;
    Node.FDataSetRecordViewNo := i;
    Node.FKeyValue := Null;
  end;
}
  RebuildFlatVisibleList;
  UpdateAllDataRowHeights;
end;

procedure TGridGroupDataTreeEh.RebuildFlatVisibleList;
var
  Node: TBaseTreeNodeEh;
begin
  FlatVisibleList.Clear;
  Node := GetFirstVisible;
  while Node <> nil do
  begin
    FlatVisibleList.Add(Node);
    Node := GetNextVisible(Node, True);
  end;
  TCustomDBGridEhCrack(FGridDataGroups.FGrid).DataGroupsVisibleChanged;
end;

procedure TGridGroupDataTreeEh.RecordChanged(RecNum: Integer);
var
  Node: TGroupDataTreeNodeEh;
  GridRowNum: Integer;
  KeyValue: Variant;
begin
  Node := GridDataGroups.GroupDataTree.GetNodeByRecordViewNo(RecNum);
  KeyValue := GridDataGroups.GetKeyValueForViewRecNo(RecNum);
  if DBVarCompareValue(KeyValue, Node.FullKey) <> vrEqual then
  begin
    Node.FFullKey := KeyValue;
    UpdateRecordNodePosInTree(Node);
    RebuildFlatVisibleList;
    TCustomDBGridEhCrack(FGridDataGroups.FGrid).DataGroupsVisibleChanged;
  end else
  begin
    Node := GridDataGroups.GroupDataTree.GetNodeByRecordViewNo(RecNum);
    GridRowNum := GridDataGroups.GroupDataTree.IndexOfVisibleNode(Node);
    if GridRowNum >= 0 then
      TCustomDBGridEhCrack(FGridDataGroups.FGrid).UpdateDataRowHeight(GridRowNum);
  end;
end;

procedure TGridGroupDataTreeEh.RecordDeleted(RecNum: Integer);
var
  Node, Parent: TGroupDataTreeNodeEh;
  k: Integer;
begin
  Node := TGroupDataTreeNodeEh(GetFirst);
  while Node <> nil do
  begin
    if (Node.NodeType = dntDataSetRecordEh) and
       (Node.DataSetRecordViewNo = RecNum)
    then
    begin
      Parent := TGroupDataTreeNodeEh(Node.Parent);
      DeleteNode(Node, True);
      for k := GridDataGroups.ActiveGroupLevelsCount-1 downto 0  do
      begin
        if Parent.Count = 0 then
        begin
          Node := Parent;
          Parent := TGroupDataTreeNodeEh(Node.Parent);
          DeleteNode(Node, True);
        end else
          Break;
      end;
      Break;
    end;
    Node := TGroupDataTreeNodeEh(GetNext(Node));
  end;
  Node := TGroupDataTreeNodeEh(GetFirst);
  while Node <> nil do
  begin
    if Node.DataSetRecordViewNo > RecNum
    then
    begin
      Node.FDataSetRecordViewNo := Node.FDataSetRecordViewNo - 1;
      if Node.NodeType = dntDataSetRecordEh then
      begin
        Node.FKeyValue := Node.FDataSetRecordViewNo;
        Node.FFullKey[GridDataGroups.ActiveGroupLevelsCount] := Node.FKeyValue;
      end;
    end;
    Node := TGroupDataTreeNodeEh(GetNext(Node));
  end;
  RebuildFlatVisibleList;
  TCustomDBGridEhCrack(FGridDataGroups.FGrid).DataGroupsVisibleChanged;
end;

procedure TGridGroupDataTreeEh.SetDataSetkeyValue;
var
//  AGrid: TCustomDBGridEhCrack;
  k: Integer;
begin
//  AGrid := TCustomDBGridEhCrack(FGridDataGroups.FGrid);
  if VarIsEmpty(GridDataGroups.FInsertingKeyValue) then Exit;
  for k := 0 to GridDataGroups.ActiveGroupLevelsCount-1 do
  begin
//    AGrid.DataSource.DataSet.Edit;
    if (GridDataGroups.ActiveGroupLevels[k].Column <> nil) and
        (TColumnEh(GridDataGroups.ActiveGroupLevels[k].Column).Field <> nil) then
    begin
      TColumnEh(GridDataGroups.ActiveGroupLevels[k].Column).Field.Value := GridDataGroups.FInsertingKeyValue[k];
    end;
  end;
end;

procedure TGridGroupDataTreeEh.RecordInserted(RecNum: Integer);
var
  KeyValue: Variant;
  AGrid: TCustomDBGridEhCrack;
  RecNode, Node: TGroupDataTreeNodeEh;
begin
  AGrid := TCustomDBGridEhCrack(FGridDataGroups.FGrid);

  Node := TGroupDataTreeNodeEh(GetFirst);
  while Node <> nil do
  begin
    if Node.DataSetRecordViewNo >= RecNum
    then
    begin
      Node.FDataSetRecordViewNo := Node.FDataSetRecordViewNo + 1;
      if Node.NodeType = dntDataSetRecordEh then
      begin
        Node.FKeyValue := Node.FDataSetRecordViewNo;
        Node.FFullKey[GridDataGroups.ActiveGroupLevelsCount] := Node.FKeyValue;
      end;
    end;
    Node := TGroupDataTreeNodeEh(GetNext(Node));
  end;

  AGrid.FIntMemTable.InstantReadEnter(RecNum);
  try
    KeyValue := GridDataGroups.GetKeyValueForViewRecNo(RecNum);
    if (AGrid.DataSource.DataSet.State = dsInsert) and
       (AGrid.FIntMemTable.InstantReadCurRowNum = RecNum)    then
    begin
      SetDataSetkeyValue;
      if not VarIsEmpty(GridDataGroups.FInsertingKeyValue) then
        KeyValue := FGridDataGroups.FInsertingKeyValue;
      VarClear(FGridDataGroups.FInsertingKeyValue);
    end;
    RecNode := AddRecordNodeForKey(KeyValue, RecNum);
    RecNode.FDataGroup := nil;
    RecNode.FGroupDataTreeNodeType := dntDataSetRecordEh;
    RecNode.FDataSetRecordViewNo := RecNum;
    RecNode.FFullKey := KeyValue;
    RecNode.FKeyValue := RecNum;
    RecNode.RowDataChanged;
  finally
    AGrid.FIntMemTable.InstantReadLeave;
  end;

  if (AGrid.DataSource.DataSet.State = dsInsert) and
     (AGrid.FIntMemTable.InstantReadCurRowNum = RecNum)
  then
    ExpandNodePathToView(RecNode);

  RebuildFlatVisibleList;
  TCustomDBGridEhCrack(FGridDataGroups.FGrid).DataGroupsVisibleChanged;
end;

procedure TGridGroupDataTreeEh.UpdateAllDataRowHeights;
var
  Node: TGroupDataTreeNodeEh;
begin
  Node := TGroupDataTreeNodeEh(GetFirst);
  while Node <> nil do
  begin
    Node.UpdateRowHeight;
    Node := TGroupDataTreeNodeEh(GetNext(Node));
  end;
end;

procedure TGridGroupDataTreeEh.DeleteRecordNode(RecNode: TGroupDataTreeNodeEh);
var
  Node, Parent: TGroupDataTreeNodeEh;
  k: Integer;
begin
  Parent := TGroupDataTreeNodeEh(RecNode.Parent);
  DeleteNode(RecNode, True);
//  ExtractNode(RecNode, True);
  for k := GridDataGroups.ActiveGroupLevelsCount-1 downto 0  do
  begin
    if Parent.Count = 0 then
    begin
      Node := Parent;
      Parent := TGroupDataTreeNodeEh(Node.Parent);
      DeleteNode(Node, True);
    end else
      Break;
  end;
end;

procedure TGridGroupDataTreeEh.UpdateRecordNodePosInTree(RecNode: TGroupDataTreeNodeEh);
var
  KeyValue: Variant;
  RecordViewNo: Integer;
begin
  KeyValue := RecNode.FullKey;
  RecordViewNo := RecNode.DataSetRecordViewNo;
  DeleteRecordNode(RecNode);
  TCustomDBGridEhCrack(FGridDataGroups.FGrid).FIntMemTable.InstantReadEnter(RecNode.DataSetRecordViewNo);
  try
    RecNode := AddRecordNodeForKey(KeyValue, RecordViewNo);
    RecNode.FDataGroup := nil;
    RecNode.FGroupDataTreeNodeType := dntDataSetRecordEh;
    RecNode.FDataSetRecordViewNo := RecordViewNo;
    RecNode.FFullKey := KeyValue;
    RecNode.RowDataChanged;
  finally
    TCustomDBGridEhCrack(FGridDataGroups.FGrid).FIntMemTable.InstantReadLeave;
  end;
end;

procedure TGridGroupDataTreeEh.ExpandNodePathToView(Node: TGroupDataTreeNodeEh);
var
  ParentNode: TGroupDataTreeNodeEh;
begin
  ParentNode := TGroupDataTreeNodeEh(Node.Parent);
  while ParentNode <> Root do
  begin
    ParentNode.Expanded := True;
    ParentNode := TGroupDataTreeNodeEh(ParentNode.Parent);
  end;
end;

procedure TGridGroupDataTreeEh.BeginUpdate;
begin
  Inc(FUpateCount);
end;

procedure TGridGroupDataTreeEh.EndUpdate;
begin
  Dec(FUpateCount);
end;

procedure TGridGroupDataTreeEh.CollapseLevel(LevelIndex: Integer);
var
  Node: TGroupDataTreeNodeEh;
begin
  BeginUpdate;
  try
  Node := TGroupDataTreeNodeEh(GetFirstVisible);
  while Node <> nil do
  begin
    if Node.Level = LevelIndex then
      Node.Expanded := False;
    Node := TGroupDataTreeNodeEh(GetNextVisible(Node, False));
  end;
  finally
    EndUpdate;
  end;
  RebuildFlatVisibleList;
end;

procedure TGridGroupDataTreeEh.ExpandLevel(LevelIndex: Integer);
var
  Node: TGroupDataTreeNodeEh;
begin
  BeginUpdate;
  try
  Node := TGroupDataTreeNodeEh(GetFirstVisible);
  while Node <> nil do
  begin
    if Node.Level = LevelIndex then
      Node.Expanded := True;
    Node := TGroupDataTreeNodeEh(GetNextVisible(Node, False));
  end;
  finally
    EndUpdate;
  end;
  RebuildFlatVisibleList;
end;

procedure TGridGroupDataTreeEh.ResortLevel(LevelIndex: Integer;
  SortOrder: TSortOrderEh);
var
  Node: TGroupDataTreeNodeEh;
begin
  Node := TGroupDataTreeNodeEh(Root);
  if LevelIndex = 0 then
    Node.SortData(CompareNodes, TObject(SortOrder), False)
  else
  begin
    BeginUpdate;
    try
    Node := TGroupDataTreeNodeEh(GetFirstVisible);
    while Node <> nil do
    begin
      if Node.Level = LevelIndex then
        Node.SortData(CompareNodes, TObject(SortOrder), False);
      Node := TGroupDataTreeNodeEh(GetNextVisible(Node, False));
    end;
    finally
      EndUpdate;
    end;
  end;
  RebuildFlatVisibleList;
end;

function TGridGroupDataTreeEh.CompareNodes(Node1, Node2: TBaseTreeNodeEh;
  ParamSort: TObject): Integer;
var
  GroupNode1, GroupNode2: TGroupDataTreeNodeEh;
  Relationship: TVariantRelationship;
  SortOrder: TSortOrderEh;
begin
  GroupNode1 := TGroupDataTreeNodeEh(Node1);
  GroupNode2 := TGroupDataTreeNodeEh(Node2);
  SortOrder := TSortOrderEh(ParamSort);
  Result := 0;
  if GroupNode1.NodeType = dntDataGroupEh then
  begin
    Relationship := DBVarCompareValue(GroupNode1.KeyValue, GroupNode2.KeyValue);
    if Relationship = vrLessThan then
      Result := -1
    else if Relationship = vrGreaterThan then
      Result := 1;
    if SortOrder = soDescEh then
      Result := -Result;
  end;
end;

procedure TGridGroupDataTreeEh.DeleteRecordNodesUpToLevel(Level: Integer);
var
  Node, DelNode, FirstNode: TGroupDataTreeNodeEh;
begin
//TODO: Optimize
//Not finished if tree deeper than 1.
  if Level <= 1 then
  begin
    Clear;
    Exit;
  end;

  Node := GetFirstNodeAtLevel(Level);
  FirstNode := Node;
  while Node <> nil do
  begin
    if (Node.Level = Level) and (Node.NodeType = dntDataGroupEh) then
    begin
      if FirstNode = Node then
      begin
        DeleteNode(Node, True);
        Node := GetFirstNodeAtLevel(Level);
        FirstNode := Node;
      end else
      begin
        DelNode := Node;
        Node := GetNextNodeAtLevel(Node, Level);
        DeleteNode(DelNode, True);
      end;
    end else
    begin
      Node := GetNextNodeAtLevel(Node, Level);
    end;
  end;
end;

function TGridGroupDataTreeEh.GetFirstNodeAtLevel(Level: Integer): TGroupDataTreeNodeEh;
begin
  Result := TGroupDataTreeNodeEh(GetFirstVisible);
  while Result <> nil do
  begin
    if Result.Level = Level then Exit;
    Result := TGroupDataTreeNodeEh(GetNextVisible(Result, False));
  end;
  Result := nil;
end;

function TGridGroupDataTreeEh.GetNextNodeAtLevel(
  Node: TGroupDataTreeNodeEh; Level: Integer): TGroupDataTreeNodeEh;
begin
  Result := Node;
  while Result <> nil do
  begin
    Result := TGroupDataTreeNodeEh(GetNextVisible(Result, False));
    if (Result <> nil) and (Result.Level = Level) then
      Exit;
  end;
  Result := nil;
end;

function TGridGroupDataTreeEh.IndexOfVisibleRecordViewNo(RecordViewNo: Integer): Integer;
var
  i: Integer;
begin
  for i := 0 to FlatVisibleCount-1 do
  begin
    if FlatVisibleItem[i].DataSetRecordViewNo = RecordViewNo then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

{ TGroupDataTreeNodeEh }

function TGroupDataTreeNodeEh.GetDataItem(
  const Index: Integer): TGroupDataTreeNodeEh;
begin
  Result := TGroupDataTreeNodeEh(inherited Items[Index]);
end;

function TGroupDataTreeNodeEh.GetRowHeight: Integer;
begin
  if FRowHeightNeedUpdate then
    UpdateRowHeight;
  Result := FRowHeight;
end;

procedure TGroupDataTreeNodeEh.RowDataChanged;
begin
  FRowHeightNeedUpdate := True;
end;

procedure TGroupDataTreeNodeEh.SetRowHeight(const Value: Integer);
begin
  FRowHeight := Value;
  FRowHeightNeedUpdate := False;
end;

procedure TGroupDataTreeNodeEh.UpdateRowHeight;
var
  AGrid: TCustomDBGridEhCrack;
begin
  AGrid := TCustomDBGridEhCrack(TGridGroupDataTreeEh(Owner).FGridDataGroups.FGrid);
  if NodeType = dntDataGroupEh then
    RowHeight := AGrid.CalcHeightForGroupNode(Self)
  else
  begin
    AGrid.FIntMemTable.InstantReadEnter(DataSetRecordViewNo);
    try
      RowHeight := AGrid.CalcRowForCurRecordHeight;
    finally
      AGrid.FIntMemTable.InstantReadLeave;
    end;
  end;
end;

end.
