unit uFrameBase1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, PngImageList, ActnList, FIBDatabase, pFIBDatabase,
  TBXStatusBars, TB2Dock, TB2Toolbar, TBX, JvComponentBase, JvEmbeddedForms;

type
  TFrameBase1 = class(TForm)
    dckTop: TTBXDock;
    tlBarTop: TTBXToolbar;
    sb: TTBXStatusBar;
    trnRead: TpFIBTransaction;
    trnWrite: TpFIBTransaction;
    actlstList: TActionList;
    imgList: TPngImageList;
  private
    { Private declarations }
    FTrnRead: Pointer;
    FTrnWrite: Pointer;
  protected
    function StoreComponent(Component: TComponent; var StoredComponent: Pointer): Pointer;
    function RestoreComponent(Component: TComponent; var StoredComponent: Pointer): Pointer;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitData; virtual;
    procedure FreeData; virtual;
    function isValid: Boolean; virtual;
    procedure Read; virtual; abstract;
    procedure Write; virtual; abstract;
  end;

var
  FrameBase1: TFrameBase1;

implementation

{$R *.dfm}

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

end.
