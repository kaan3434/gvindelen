unit uFrameBase0;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, TBXStatusBars, TB2Dock, TB2Toolbar, TBX, FIBDatabase,
  pFIBDatabase, ImgList, PngImageList, ActnList, NativeXml,
  JvComponentBase, JvEmbeddedForms, ExtCtrls, JvExExtCtrls, JvExtComponent,
  JvPanel;

type
  TFrameBase0 = class(TFrame)
    trnRead: TpFIBTransaction;
    trnWrite: TpFIBTransaction;
    dckTop: TTBXDock;
    tlBarTop: TTBXToolbar;
    sb: TTBXStatusBar;
    actList: TActionList;
    imgList: TPngImageList;
    pnl1: TJvPanel;
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
  private
    { Private declarations }
    FTrnRead: Pointer;
    FTrnWrite: Pointer;
  protected
    function StoreComponent(Component: TComponent; var StoredComponent: Pointer): Pointer;
    function RestoreComponent(Component: TComponent; var StoredComponent: Pointer): Pointer;
    function DetectCaption(aNode: TXmlNode; aCaption: String): string;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitData; virtual;
    procedure FreeData; virtual;
    procedure OpenTables; virtual;
    function isValid: Boolean; virtual;
    procedure Read; virtual;  
    procedure Write; virtual; abstract;
    procedure UpdateCaptions; virtual;
  end;

implementation



{$R *.dfm}

{ TFrame1 }

constructor TFrameBase0.Create(AOwner: TComponent);
begin
  inherited;
  InitData;
end;

destructor TFrameBase0.Destroy;
begin
  FreeData;
  inherited;
end;

procedure TFrameBase0.FreeData;
begin
  trnWrite:= RestoreComponent(trnWrite, FTrnWrite);
  trnRead:= RestoreComponent(trnRead, FTrnRead);
end;

procedure TFrameBase0.InitData;
begin
  trnRead:= StoreComponent(trnRead, FTrnRead);
  trnWrite:= StoreComponent(trnWrite, FTrnWrite);
end;

function TFrameBase0.isValid: Boolean;
begin
  try
    Write;
    Result:= true;
  except
    Result:= false;
  end
end;

function TFrameBase0.RestoreComponent(Component: TComponent;
  var StoredComponent: Pointer): Pointer;
begin
  if StoredComponent = nil then
    Result:= Component
  else
    Result:= StoredComponent;
end;

function TFrameBase0.StoreComponent(Component: TComponent; var StoredComponent: Pointer): Pointer;
var
  p: Pointer;
begin
  p:= Owner.FindComponent(Component.Name);
  if p = nil then
  begin
    Result:= Component;
    StoredComponent:= nil;
  end
  else
  begin
    Result:= p;
    StoredComponent:= Component;
  end;
end;

procedure TFrameBase0.FrameEnter(Sender: TObject);
begin
  OpenTables;
  Read;
  UpdateCaptions;
end;

procedure TFrameBase0.OpenTables;
begin

end;

procedure TFrameBase0.FrameExit(Sender: TObject);
begin
  Write;
  UpdateCaptions;
end;

procedure TFrameBase0.Read;
begin
  UpdateCaptions;
end;

function TFrameBase0.DetectCaption(aNode : TXmlNode; aCaption: String): string;
begin
  Result:= aCaption + ' ['+aNode.ReadAttributeString('ID', 'Новый')+']';
end;

procedure TFrameBase0.UpdateCaptions;
begin

end;

end.
