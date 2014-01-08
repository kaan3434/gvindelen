unit uFrameClientView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, StdCtrls, GvXml;

type
  TFrameClientView = class(TFrame)
    grBoxClient: TGroupBox;
    vsTreeClient: TVirtualStringTree;
  private
    FXmlNode: TGvXmlNode;
    FXPaths: TStringList;
    procedure SeTGvXmlNode(const Value: TGvXmlNode);
    procedure SetXPaths(const Value: TStringList);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property XmlNode: TGvXmlNode read FXmlNode write SeTGvXmlNode;
    property XPaths: TStringList read FXPaths write SetXPaths;
  end;

implementation

{$R *.dfm}

{ TFrameClientView }

constructor TFrameClientView.Create(AOwner: TComponent);
begin
  inherited;
  FXPaths := TSTringList.Create;
end;

destructor TFrameClientView.Destroy;
begin
  FXPaths.Free;
  inherited;
end;

procedure TFrameClientView.SeTGvXmlNode(const Value: TGvXmlNode);
begin
  FXmlNode := Value;
end;

procedure TFrameClientView.SetXPaths(const Value: TStringList);
begin
  FXPaths.Assign(Value);
end;

end.


