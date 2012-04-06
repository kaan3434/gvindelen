
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBCTable Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCTableEditor;
{$ENDIF}
interface
uses
  SysUtils, Classes,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons,
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DATableEditor, DATableSQLFrame, IBCTableSQLFrame;

type
  TIBCTableEditorForm = class(TDATableEditorForm)
  protected
    function GetSQLFrameClass: TDATableSQLFrameClass; override;
  end;

implementation

{$IFNDEF FPC}
{$R IBCTableEditor.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{ TIBCTableEditorForm }

function TIBCTableEditorForm.GetSQLFrameClass: TDATableSQLFrameClass;
begin
  Result := TIBCTableSQLFrame;
end;

end.
