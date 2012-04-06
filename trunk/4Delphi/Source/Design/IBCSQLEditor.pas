
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBCSQL Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCSQLEditor;
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
  Db, DBAccess, IBC, IBCError, IBCParamsFrame;

type
  TIBCSQLEditorForm = class(TDASQLEditorForm)
  protected
    procedure DoInit; override;
    procedure DoError(E: Exception); override;

  public
    property SQL;

  end;

procedure DoError(Sender: TDASQLEditorForm; E: EIBCError);

implementation

{$IFNDEF FPC}
{$R IBCSQLEditor.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{ TIBCSQLEditorForm }

procedure TIBCSQLEditorForm.DoInit;
begin
  FSQLFrame := AddTab(TDASQLFrame, shSQL) as TDASQLFrame;
  FParamsFrame := AddTab(TIBCParamsFrame, shParameters) as TDAParamsFrame;
  FMacrosFrame := AddTab(TDAMacrosFrame, shMacros) as TDAMacrosFrame;
  FSPCallFrame := AddTab(TIBCSPCallFrame, shGeneratorSPC) as TDASPCallFrame;

  inherited;
end;

procedure TIBCSQLEditorForm.DoError(E: Exception);
begin
  if E is EIBCError then
    {$IFDEF CLR}Devart.IbDac.Design.{$ENDIF}IBCSQLEditor.DoError(Self, EIBCError(E))
  else
    inherited;
end;

procedure DoError(Sender: TDASQLEditorForm; E: EIBCError);
begin
  Sender.ActivateFrame(Sender.SQLFrame);
  Sender.ActiveControl := Sender.SQLFrame.meSQL;
end;

end.

