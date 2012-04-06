
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBCStoredProc Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCStoredProcEditor;
{$ENDIF}
interface
uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons,
{$IFDEF FPC}
  LResources,
{$ENDIF}
  SysUtils, DB, Classes, DAStoredProcEditor, CRFrame;

type
  TIBCStoredProcEditorForm = class(TDAStoredProcEditorForm)
  protected
    procedure DoInit; override;
    function GetFrameByInitProp: TCRFrame; override;    
  public
    property StoredProc;
  end;

implementation

{$IFNDEF FPC}
{$R IBCStoredProcEditor.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  DASQLFrame, DAPAramsFrame, DAMacrosFrame, DAUpdateSQLFrame, DASQLGeneratorFrame,
  DASPCallFrame, IBCParamsFrame, IBCSPCallFrame, DBAccess;

{ TIBCStoredProcEditorForm }

procedure TIBCStoredProcEditorForm.DoInit;
begin
  FSQLFrame := AddTab(TIBCSPCallFrame, shSQL) as TDASQLFrame;
  FParamsFrame := AddTab(TIBCParamsFrame, shParameters) as TDAParamsFrame;
  FMacrosFrame := AddTab(TDAMacrosFrame, shMacros) as TDAMacrosFrame;
  FSPCallFrame := AddTab(TIBCSPCallFrame, shGeneratorSPC) as TDASPCallFrame;
  FUpdateSQLFrame := AddTab(TDAUpdateSQLFrame, shEditSQL) as TDAUpdateSQLFrame;
  FSQLGeneratorFrame := AddTab(TDASQLGeneratorFrame, shGenerator) as TDASQLGeneratorFrame;
  shGenerator.TabVisible := False;

  inherited;
end;

function TIBCStoredProcEditorForm.GetFrameByInitProp: TCRFrame;
begin
  if InitialProperty = 'SQLLock' then begin
    FUpdateSQLFrame.SetStatementType(stLock);
    Result := FUpdateSQLFrame;
  end
  else
    Result := inherited GetFrameByInitProp;
end;

end.
