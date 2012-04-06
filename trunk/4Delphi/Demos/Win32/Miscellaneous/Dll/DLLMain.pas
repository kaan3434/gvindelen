unit DLLMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, MemDS, IBC, StdCtrls, ExtCtrls, DBCtrls, DBAccess, IbDacVcl;

type
  TfmDllMain = class(TForm)
    IBCQuery: TIBCQuery;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    pnToolBar: TPanel;
    btOpen: TButton;
    btClose: TButton;
    DBNavigator: TDBNavigator;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure AssignConnection(Connection: TIBCConnection); cdecl;
procedure ShowForm; cdecl;
procedure HideForms; cdecl;

implementation
uses
  IBCCall;

{$R *.DFM}

var
  ExternalConnection: TIBCConnection;
  FormList: TList;
  FormCount: integer;

procedure AssignConnection(Connection: TIBCConnection); cdecl;
begin
  ExternalConnection:= Connection;
end;

procedure ShowForm; cdecl;
begin
  InitGDS; // before using of IBDAC components

  with TfmDllMain.Create(Application) do begin
    Inc(FormCount);
    Caption:= IntToStr(FormCount) + '. ' + Caption;
    IBCQuery.Connection := ExternalConnection;
    IBCQuery.Active := True;
    Show;
  end;
end;

procedure HideForms; cdecl;
begin
  while FormList.Count > 0 do begin
    TForm(FormList[0]).Free;
    FormList.Delete(0);
  end;
end;

procedure TfmDllMain.FormShow(Sender: TObject);
begin
  FormList.Add(Self);
end;

procedure TfmDllMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormList.Remove(Self);
  Action := caFree;
end;

procedure TfmDllMain.btOpenClick(Sender: TObject);
begin
  IBCQuery.Open;
end;

procedure TfmDllMain.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
end;

initialization
  FormCount:= 0;
  FormList:= TList.Create;
finalization
  HideForms;
  FormList.Free;
end.
