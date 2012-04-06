
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  InterBase Stored Proc Call Generator Frame
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCSPCallFrame;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons,
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Classes, SysUtils, DBAccess, CRFrame, CRTabEditor,
  DASPCallFrame;

type
  TIBCSPCallFrame = class(TDASPCallFrame)
    cbIsQuery: TCheckBox;
    procedure cbIsQueryClick(Sender: TObject);
  protected
    procedure DoActivate; override;
    function GetSPIsQuery: boolean; override;
    function GetIsQuery: boolean;
  end;

implementation

{$IFNDEF FPC}
{$R IBCSPCallFrame.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  DAConsts, IBC;

{ TIBCSPCallFrame }

procedure TIBCSPCallFrame.DoActivate;
begin
  inherited;

  cbIsQuery.Checked := GetIsQuery;
  if Mode = spQuerySP then
    if (LocalComponentSQL.Count = 0) and (GetSPName <> '') and (UsedConnection <> nil) then
      CreateProcedureCall;
end;

function TIBCSPCallFrame.GetSPIsQuery: boolean;
begin
  case Mode of
    spQuery, spQuerySP:
      Result := FStatementType in [stQuery, stRefresh];
    spSQLSP:
      Result := cbIsQuery.Checked;
  else
    Result := False;
  end;
end;

function TIBCSPCallFrame.GetIsQuery: boolean;
begin
  Result := Pos('SELECT', LocalComponentSQL.Text) = 1;
end;

procedure TIBCSPCallFrame.cbIsQueryClick(Sender: TObject);
begin
  if (UsedConnection <> nil) and (GetIsQuery <> cbIsQuery.Checked) then
    CreateProcedureCall;
end;

end.

