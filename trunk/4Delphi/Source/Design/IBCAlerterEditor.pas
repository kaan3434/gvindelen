//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBCAlerter Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCAlerterEditor;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, Buttons,
{$IFDEF FPC}
  LResources, LCLType,
{$ENDIF}
  IBC, IBCAlerter, CREditor, Grids;

type
  TIBCAlerterEditorForm = class(TCREditorForm)
    pnlClient: TPanel;
    cbAutoRegister: TCheckBox;
    lbEvents: TLabel;
    GroupBox: TGroupBox;
    EventList: TStringGrid;
    procedure EventListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbAutoRegisterClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EventListSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  protected
    FAlerter: TIBCAlerter;
    FAutoRegister: Boolean;

    function GetComponent: TComponent; override;
    procedure SetComponent(Value: TComponent); override;

    procedure DoInit; override;
    procedure DoFinish; override;
    procedure DoSave; override;

    function AddRow(const Value: string): Integer;
    procedure DeleteRow(ARow: Integer);
    function IsEmptyRow: Boolean;
  public
    property Alerter: TIBCAlerter read FAlerter write FAlerter;
  end;

var
  IBCAlerterEditorForm: TIBCAlerterEditorForm;

implementation

{$IFNDEF FPC}
{$R IBCAlerterEditor.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

function TIBCAlerterEditorForm.GetComponent: TComponent;
begin
  Result := FAlerter;
end;

procedure TIBCAlerterEditorForm.SetComponent(Value: TComponent);
begin
  FAlerter := Value as TIBCAlerter;
end;

procedure TIBCAlerterEditorForm.DoInit;
var
  i: Integer;
begin
  inherited;

  FAutoRegister := FAlerter.AutoRegister;
  cbAutoRegister.Checked := FAutoRegister;
  if FAlerter.Events.Count > 0 then
    EventList.RowCount := FAlerter.Events.Count
  else
    EventList.RowCount := 1;
  for i := 0 to EventList.RowCount - 1 do begin
    EventList.Cells[0, i] := IntToStr(i + 1);
    if FAlerter.Events.Count >= (i + 1) then
      EventList.Cells[1, i] := FAlerter.Events[i]
    else
      EventList.Cells[1, i] := '';
  end;
  
  Modified := False;
end;

procedure TIBCAlerterEditorForm.DoFinish;
begin
  inherited;
end;

procedure TIBCAlerterEditorForm.DoSave;
var
  i: integer;
begin
  FAlerter.Events.Clear;
  for i := 0 to EventList.RowCount - 1 do
    FAlerter.Events.Add(EventList.Cells[1, i]);
  FAlerter.AutoRegister := FAutoRegister;
  inherited;
end;

procedure TIBCAlerterEditorForm.EventListKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  i: integer;

  function InsertOK: Boolean;
  begin
    Result := (Length(EventList.Cells[1, EventList.Row]) > 0)
  end;

  procedure SetRow(NewRow: Integer);
  begin
    EventList.Row := NewRow;
  end;

begin
  case Key of
    VK_DOWN:
      if Shift = [ssCtrl] then
        SetRow(EventList.RowCount - 1)
      else
      if (Shift = []) and (EventList.Row = EventList.RowCount - 1) and InsertOK then
        SetRow(AddRow(''));
    VK_UP: begin
      if Shift = [ssCtrl] then
        SetRow(EventList.FixedRows);
    end;
    VK_DELETE:
      if Shift = [ssCtrl] then begin
        Modified := EventList.Cells[1, EventList.Row] <> '';
        if EventList.RowCount > 1 then begin
          for i := EventList.Row to EventList.RowCount - 2 do begin
            EventList.Rows[i] := EventList.Rows[i + 1];
            EventList.Cells[0, i] := IntTostr(i + 1);
          end;
          if EventList.Row > EventList.RowCount - 2 then
            EventList.Row := EventList.RowCount - 2;
          EventList.RowCount := EventList.RowCount - 1;
        end
        else
          EventList.Cells[1, 0] := ''
      end;
  end;
end;

function TIBCAlerterEditorForm.AddRow(const Value: string): Integer;
begin
  Result := EventList.Row;
  if not IsEmptyRow then begin
    EventList.RowCount := EventList.RowCount + 1;
    Result := EventList.RowCount - 1;
    EventList.Cells[0, Result] := IntToStr(Result + 1);
    EventList.Cells[1, Result] := Value;
  end
  else begin
    EventList.Cells[0, Result] := IntToStr(Result + 1);
    EventList.Cells[1, Result] := Value;
  end;
end;

procedure TIBCAlerterEditorForm.DeleteRow(ARow: Integer);
begin
  if (EventList.Row >= EventList.RowCount - 1) then
    EventList.RowCount := EventList.RowCount - 1;
end;

function TIBCAlerterEditorForm.IsEmptyRow: Boolean;
begin
  Result :=  EventList.Cells[1, EventList.Row] = '';
end;

procedure TIBCAlerterEditorForm.cbAutoRegisterClick(Sender: TObject);
begin
  FAutoRegister := cbAutoRegister.Checked;
end;

procedure TIBCAlerterEditorForm.FormResize(Sender: TObject);
begin
  if EventList.HandleAllocated and
    ((EventList.ColWidths[0] + EventList.ColWidths[1]) <> (EventList.ClientWidth - 2)) then
    EventList.ColWidths[1] := EventList.ClientWidth - EventList.ColWidths[0] - 2;
end;

procedure TIBCAlerterEditorForm.EventListSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  Modified := True;
end;

end.
