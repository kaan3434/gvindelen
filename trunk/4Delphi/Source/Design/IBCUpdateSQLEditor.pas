
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBCUpdateSQL Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCUpdateSQLEditor;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls,
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Classes, SysUtils, DBAccess,
  DAUpdateSQLEditor;

type
  TIBCUpdateSQLEditorForm = class(TDAUpdateSQLEditorForm)
  protected
    procedure DoInit; override;
//    class function GetDataSetClass: TCustomDADataSetClass; override;
  end;

implementation

{$IFNDEF FPC}
{$R IBCUpdateSQLEditor.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  DAUpdateSQLFrame, IBCSQLGeneratorFrame, IBC;

{ TIBCUpdateSQLEditorForm }

procedure TIBCUpdateSQLEditorForm.DoInit;
begin
  FUpdateSQLFrame := AddTab(TDAUpdateSQLFrame, shEditSQL) as TDAUpdateSQLFrame;
  FSQLGeneratorFrame := AddTab(TIBCSQLGeneratorFrame, shGenerator) as TIBCSQLGeneratorFrame;
  inherited;
end;

{class function TIBCUpdateSQLEditorForm.GetDataSetClass: TCustomDADataSetClass;
begin
  Result := TCustomIBCDataSet;
end;}

end.
