unit uFrameBase1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, PngImageList, ActnList, FIBDatabase, pFIBDatabase,
  TBXStatusBars, TB2Dock, TB2Toolbar, TBX,
  ExtCtrls, NativeXml;

type
  TFrameBase1 = class(TForm)
    dckTop: TTBXDock;
    tlBarTop: TTBXToolbar;
    sb: TTBXStatusBar;
    trnRead: TpFIBTransaction;
    trnWrite: TpFIBTransaction;
    actList: TActionList;
    imgList: TPngImageList;
    procedure FormShow(Sender: TObject);
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

var
  FrameBase1: TFrameBase1;

implementation

{$R *.dfm}
uses
  udmOtto;
{ TForm2 }

constructor TFrameBase1.Create(AOwner: TComponent);
begin
  inherited;
  InitData;
end;

destructor TFrameBase1.Destroy;
begin
  FreeData;
  inherited;
end;

procedure TFrameBase1.FreeData;
begin
  trnWrite:= RestoreComponent(trnWrite, FTrnWrite);
  trnRead:= RestoreComponent(trnRead, FTrnRead);
end;

procedure TFrameBase1.InitData;
begin
  trnRead:= StoreComponent(trnRead, FTrnRead);
  trnWrite:= StoreComponent(trnWrite, FTrnWrite);
end;

function TFrameBase1.isValid: Boolean;
begin
  try
    Write;
    Result:= true;
  except
    Result:= false;
  end
end;

procedure TFrameBase1.OpenTables;
begin

end;

function TFrameBase1.RestoreComponent(Component: TComponent;
  var StoredComponent: Pointer): Pointer;
begin
  if StoredComponent = nil then
    Result:= Component
  else
    Result:= StoredComponent;
end;

function TFrameBase1.StoreComponent(Component: TComponent;
  var StoredComponent: Pointer): Pointer;
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

function TFrameBase1.DetectCaption(aNode: TXmlNode;
  aCaption: String): string;
begin
  Result:= aCaption + ' ['+aNode.ReadAttributeString('ID', 'Новый')+']';
end;

procedure TFrameBase1.Read;
begin
  UpdateCaptions;
end;

procedure TFrameBase1.UpdateCaptions;
begin

end;

procedure TFrameBase1.FormShow(Sender: TObject);
begin
  OpenTables;
  Read;
  UpdateCaptions;
end;

end.
