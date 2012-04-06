
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBCQuery Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCQueryEditor;
{$ENDIF}

interface

uses
  SysUtils, Classes,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, DBCtrls,
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DASQLComponentEditor, DASQLFrame, DAParamsFrame, DAMacrosFrame, DASPCallFrame, IBCSPCallFrame,
  IBC, IBCError, Db, DBAccess, {$IFNDEF FPC}MemDS{$ELSE}MemDataSet{$ENDIF},
  IBCParamsFrame, CRFrame, DAQueryEditor;

type
  TIBCQueryEditorForm = class(TDAQueryEditorForm)
  protected
    procedure DoInit; override;
    procedure DoError(E: Exception); override;

    function GetFrameByInitProp: TCRFrame; override;
  public
    property Query;

  end;

implementation

{$IFNDEF FPC}
{$R IBCQueryEditor.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  IBCSQLEditor, DAUpdateSQLFrame, DASQLGeneratorFrame, IBCSQLGeneratorFrame;

{ TIBCQueryEditorForm }

procedure TIBCQueryEditorForm.DoInit;
begin
  FSQLFrame := AddTab(TDASQLFrame, shSQL) as TDASQLFrame;
  FParamsFrame := AddTab(TIBCParamsFrame, shParameters) as TDAParamsFrame;
  FMacrosFrame := AddTab(TDAMacrosFrame, shMacros) as TDAMacrosFrame;
  FSPCallFrame := AddTab(TIBCSPCallFrame, shGeneratorSPC) as TDASPCallFrame;
  FUpdateSQLFrame := AddTab(TDAUpdateSQLFrame, shEditSQL) as TDAUpdateSQLFrame;
  FSQLGeneratorFrame := AddTab(TIBCSQLGeneratorFrame, shGenerator) as TDASQLGeneratorFrame;

  inherited;
end;

procedure TIBCQueryEditorForm.DoError(E: Exception);
begin
  if E is EIBCError then
    IBCSQLEditor.DoError(Self, EIBCError(E))
  else
    inherited;
end;

function TIBCQueryEditorForm.GetFrameByInitProp: TCRFrame;
begin
  if InitialProperty = 'SQLLock' then begin
    FUpdateSQLFrame.SetStatementType(stLock);
    Result := FUpdateSQLFrame;
  end
  else
    Result := inherited GetFrameByInitProp;
end;

end.

