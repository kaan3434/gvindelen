// *****************************************************************************
// *                                                                           *
// * Компонент TStages                                                         *
// * Copyright (c) Колпиков М. Е.                                              *
// *                                                                           *
// *****************************************************************************


unit GvStages;

interface

uses Classes, Controls, StdCtrls, Windows, Messages, Graphics,
     Forms;

type

  TStage = (stgWaiting, stgRunning, stgCompleted);

  TCustomStages = class(TGraphicControl)
  private
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FWordWrap: Boolean;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FTransparentSet: Boolean;
    FItems: TStringList; //TStrings;
    FItemsTops: TList;
    FReading: Boolean;
    FInterspace: integer; // расстояние между строками
    FSpacing: Integer;    // расстояние между иконкой и началом строки
    FRunningIndex: integer;
    //StagesGlyphs: array[TStage] of TBitmap;
    FGlyphList: TImageList;
    GlyphVertAligning: integer;
    FWaitingColor: TColor;
    FRunningColor: TColor;
    FCompletedColor: TColor;
    function GetTransparent: Boolean;
    procedure SetAlignment(Value: TAlignment);
    procedure SetTransparent(Value: Boolean);
    procedure SetWordWrap(Value: Boolean);
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure ItemsChange(Sender: TObject);
    procedure SetItems(Value: TStringList{TStrings});
    procedure SetInterspace(AInterspace: integer);
    procedure SetSpacing(ASpacing: integer);
    procedure SetWaitingColor(AWaitingColor: TColor);
    procedure SetRunningColor(ARunningColor: TColor);
    procedure SetCompletedColor(ACompletedColor: TColor);
    procedure SetRunningIndex(ARunningIndex: integer);
  protected
    procedure AdjustBounds;
    procedure DoDrawItem(ItemIndex: integer; var Rect: TRect; Flags: Longint; StageState: integer);
    procedure DoDrawItems(var Rect: TRect; Flags: Longint);
    procedure Loaded; override;
    procedure Paint; override;
    procedure SetAutoSize(Value: Boolean); 
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default True;
    property Transparent: Boolean read GetTransparent write SetTransparent stored FTransparentSet;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property Items: TStringList{TStrings} read FItems write SetItems;
    procedure ReadState(Reader: TReader); override;
    property Interspace: integer read FInterspace write SetInterspace;
    property Spacing: Integer read FSpacing write SetSpacing;
    property WaitingColor: TColor read FWaitingColor write SetWaitingColor;
    property RunningColor: TColor read FRunningColor write SetRunningColor;
    property CompletedColor: TColor read FCompletedColor write SetCompletedColor;
    property Position: integer read FRunningIndex write SetRunningIndex;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //property Caption;
    property Canvas;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    procedure Reset;
    procedure StepIt(Step: Integer=1);
  end;

  TGvStages = class(TCustomStages)
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color nodefault;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Transparent;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnStartDock;
    property OnStartDrag;

    property Items;
    property Interspace;
    property Spacing;
    property WaitingColor;
    property RunningColor;
    property CompletedColor;
    property Position; 
  end;


procedure Register;  

implementation

uses CommCtrl;

{ TCustomStages }

{$R GvStages.res}

const
  GlyphWidth = 16;
  GlyphHeight = 16;



constructor TCustomStages.Create(AOwner: TComponent);
var
  TmpImage: TBitmap;
begin
  inherited Create(AOwner);
  ControlStyle:= ControlStyle + [csReplicatable];
  Width:= 65;
  Height:= 17;
  FAutoSize := True;
  FItems:= TStringList.Create;
  FItemsTops:= TList.Create;
  FItems.OnChange := ItemsChange;
  FInterspace:= 8;
  FSpacing:= 4;
  FRunningIndex:= -1;
  FWaitingColor:= clWindowText;
  FRunningColor:= clWindowText;
  FCompletedColor:= clWindowText;

  FGlyphList:= TImageList.Create(Self);
  TmpImage:= TBitmap.Create;
  try
    TmpImage.LoadFromResourceName(HInstance, 'STGWAITING');
    FGlyphList.AddMasked(TmpImage, clDefault);
    TmpImage.LoadFromResourceName(HInstance, 'STGRUNNING');
    FGlyphList.AddMasked(TmpImage, clDefault);
    TmpImage.LoadFromResourceName(HInstance, 'STGCOMPLETED');
    FGlyphList.AddMasked(TmpImage, clDefault);
  finally
    TmpImage.Free;
  end;

  { The "default" value for the Transparent property depends on
    if you have Themes available and enabled or not. If you have
    ever explicitly set it, that will override the default value. }
{  if ThemeServices.ThemesEnabled then
    ControlStyle := ControlStyle - [csOpaque]
  else}
  ControlStyle := ControlStyle + [csOpaque];
end;


destructor TCustomStages.Destroy;
begin
  FItems.OnChange := nil;
  FItems.Free;
  FItemsTops.Free;
  //FGlyphList.Free;
  inherited Destroy;
end;




procedure TCustomStages.DoDrawItem(ItemIndex: integer; var Rect: TRect; Flags: Longint; StageState: integer);
var
  Text: string;
  TextRect: TRect;
  //GlyphPoint: TPoint;
  H, GlyphX, GlyphY: integer;
begin
  GlyphX:= Rect.Left;
  GlyphY:= Rect.Top + GlyphVertAligning;
  TextRect:= Rect;
  inc(TextRect.Left, GlyphWidth + FSpacing);

  if Flags and DT_CALCRECT = 0 then
    ImageList_DrawEx(FGlyphList.Handle, StageState, Canvas.Handle, GlyphX, GlyphY, 0, 0, clNone, clNone, ILD_Transparent);

  Text:= FItems[ItemIndex];
  if (Flags and DT_CALCRECT <> 0) and (Text = '') then Text:= ' ';
  if not Enabled then
    begin
      OffsetRect(TextRect, 1, 1);
      Canvas.Font.Color := clBtnHighlight;
      DrawText(Canvas.Handle, PChar(Text), Length(Text), TextRect, Flags);
      OffsetRect(TextRect, -1, -1);
      Canvas.Font.Color := clBtnShadow;
    end;
  H:= DrawText(Canvas.Handle, PChar(Text), Length(Text), TextRect, Flags);
  if not Enabled then
    begin
     inc(H);
     inc(TextRect.Right);
    end;
  TextRect.Bottom:= TextRect.Top + H;
  Rect:= TextRect;
  Rect.Left:= GlyphX;
end;



procedure TCustomStages.DoDrawItems(var Rect: TRect; Flags: Longint);
var
  i, StageState: integer;
  ItemsRect, ItemRect, NewRect: TRect;
begin
  ItemsRect:= Rect;
  NewRect:= Classes.Rect(0, 0, 0, 0);
  if Flags and DT_CALCRECT = 0 then NewRect:= Rect;

  Flags := DrawTextBiDiModeFlags(Flags) or DT_NOPREFIX;
  Canvas.Font:= Font;
  for i:= 0 to FItems.Count - 1 do
    begin
      ItemRect:= ItemsRect;
      with Canvas.Font do
        begin
          if i > FRunningIndex then
            begin
              Color:= FWaitingColor;
              StageState:= 0;
            end
          else if i = FRunningIndex then
            begin
              Color:= FRunningColor;
              StageState:= 1;
            end
          else
            begin
              Color:= FCompletedColor;
              StageState:= 2;
            end;
          if (Flags and DT_CALCRECT <> 0) or (i = FRunningIndex) then Style:= [fsBold]
          else Style:= [];
        end;
      DoDrawItem(i, ItemRect, Flags, StageState);

      if Flags and DT_CALCRECT <> 0 then
        begin
          //здесь записывать в объект текущей строки номер позиции, с которой рисовать строку
          FItemsTops[i]:= pointer(ItemRect.Bottom + 1);
        end;
      //inc(ItemsRect.Top, ItemRect.Bottom - ItemRect.Top + FInterspace);
      if FAutoSize and (Flags and DT_CALCRECT <> 0) then
        begin
          UnionRect(NewRect, NewRect, ItemRect);
          UnionRect(ItemsRect, NewRect, Rect);
        end
      else
        ItemsRect:= Rect;
      ItemsRect.Top:= integer(FItemsTops[i]) + FInterspace;
    end;
  if FAutoSize and (Flags and DT_CALCRECT <> 0) then
    begin
      NewRect.Bottom:= ItemsRect.Top;
      Rect:= NewRect;
    end;
end;




procedure TCustomStages.Paint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  Rect: TRect;
  DrawStyle: Longint;
begin
  with Canvas do
    begin
      if not Transparent then
        begin
          Brush.Color:= Self.Color;
          Brush.Style:= bsSolid;
          FillRect(ClientRect);
        end;
      Brush.Style:= bsClear;
      Rect:= ClientRect;
      { DoDrawItem takes care of BiDi alignments }
      DrawStyle:= DT_EXPANDTABS or WordWraps[FWordWrap] or Alignments[FAlignment];
      DoDrawItems(Rect, DrawStyle);
    end;
end;

procedure TCustomStages.AdjustBounds;
const
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  DC: HDC;
  X: Integer;
  Rect: TRect;
  AAlignment: TAlignment;
begin
  if not (csReading in ComponentState) and (FAutoSize or FWordWrap) then
    begin
      //FItemsTops.Count:= FItems.Count;
      Rect := ClientRect;
      DC := GetDC(0);
      Canvas.Handle := DC;
      DoDrawItems(Rect, (DT_EXPANDTABS or DT_CALCRECT) or WordWraps[FWordWrap]);
      Canvas.Handle := 0;
      ReleaseDC(0, DC);
      X:= Left;
      AAlignment := FAlignment;
      if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);
      if AAlignment = taRightJustify then Inc(X, Width - Rect.Right);
      SetBounds(X, Top, Rect.Right, Rect.Bottom);
    end;
end;


procedure TCustomStages.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;


procedure TCustomStages.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TCustomStages.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    AdjustBounds;
  end;
end;

function TCustomStages.GetTransparent: Boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;


procedure TCustomStages.SetTransparent(Value: Boolean);
begin
  if Transparent <> Value then
  begin
    if Value then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
  FTransparentSet := True;
end;


procedure TCustomStages.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap:= Value;
    AdjustBounds;
    Invalidate;
  end;
end;


procedure TCustomStages.CMTextChanged(var Message: TMessage);
begin
  AdjustBounds;
  Invalidate;
end;

procedure TCustomStages.CMFontChanged(var Message: TMessage);
begin
  inherited;
  GlyphVertAligning:= (Canvas.TextHeight(' ') - GlyphHeight) div 2;
  AdjustBounds;
end;

procedure TCustomStages.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TCustomStages.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;




procedure TCustomStages.ItemsChange(Sender: TObject);
begin
  FItemsTops.Count:= FItems.Count;
  if not FReading then
    begin
      AdjustBounds;
      Invalidate;
    end;
end;

procedure TCustomStages.ReadState(Reader: TReader);
begin
  FReading := True;
  inherited ReadState(Reader);
  FReading := False;
  AdjustBounds;
end;

procedure TCustomStages.SetItems(Value: TStringList{TStrings});
begin
  FItems.Assign(Value);
end;

procedure TCustomStages.SetInterspace(AInterspace: integer);
begin
  if FInterspace <> AInterspace then
    begin
      FInterspace:= AInterspace;
      if FInterspace < 0 then FInterspace:= 0;
      AdjustBounds;
      Invalidate;
    end;
end;

procedure TCustomStages.SetSpacing(ASpacing: integer);
begin
  if FSpacing <> ASpacing then
    begin
      FSpacing:= ASpacing;
      if FSpacing < 0 then FSpacing:= 0;
      AdjustBounds;
      Invalidate;
    end;
end;

procedure TCustomStages.Reset;
begin
  FRunningIndex:= -1;
  Invalidate;
end;

procedure TCustomStages.SetWaitingColor(AWaitingColor: TColor);
begin
  if FWaitingColor <> AWaitingColor then
    begin
      FWaitingColor:= AWaitingColor;
      Invalidate;
    end;
end;

procedure TCustomStages.SetRunningColor(ARunningColor: TColor);
begin
  if FRunningColor <> ARunningColor then
    begin
      FRunningColor:= ARunningColor;
      Invalidate;
    end;
end;

procedure TCustomStages.SetCompletedColor(ACompletedColor: TColor);
begin
  if FCompletedColor <> ACompletedColor then
    begin
      FCompletedColor:= ACompletedColor;
      Invalidate;
    end;
end;

procedure TCustomStages.SetRunningIndex(ARunningIndex: integer);
begin
  if FRunningIndex <> ARunningIndex then
    begin
      FRunningIndex:= ARunningIndex;
      AdjustBounds;
      Invalidate;
    end;
end;

procedure TCustomStages.StepIt(Step: Integer=1);
begin
  Position:= Position+Step;
  Refresh;
end;

procedure Register;
begin
  RegisterComponents('Gvindelen', [TGvStages]);
end;

end.

