unit Data;

interface

{$IFNDEF UNIX}
{$IFNDEF POSIX}
{$DEFINE MSWINDOWS}
{$ENDIF}
{$ENDIF}
uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, DB, MemData, DBAccess,
  IBC, MemDS, IbDacVcl, DAScript, IBCScript;

type
  TDM = class(TDataModule)
    Connection: TIBCConnection;
    quDetail: TIBCQuery;
    quMaster: TIBCQuery;
    dsMaster: TDataSource;
    dsDetail: TDataSource;
    UpdateTransaction: TIBCTransaction;
    scCreate: TIBCScript;
    scDrop: TIBCScript;
  private
  public
    procedure KillSession;
    function InTransaction: boolean;
    procedure StartTransaction;
    procedure RollbackTransaction;
    procedure CommitTransaction;
  end;

var
  DM: TDM;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

uses
  Main;

{ TDM }

procedure TDM.KillSession;
var
  KillConnection: TIBCConnection;
  Query: TIBCQuery;
  SQL: TIBCSQL;
begin
  KillConnection := TIBCConnection.Create(nil);
  KillConnection.Server := Connection.Server;
  KillConnection.Username := Connection.Username;
  KillConnection.Password := Connection.Password;
  KillConnection.Database := Connection.Database;

  KillConnection.LoginPrompt := False;

  Query := TIBCQuery.Create(nil);
  Query.Connection := Connection;
  SQL := TIBCSQL.Create(nil);
  SQL.Connection := KillConnection;
  SQL.AutoCommit := True;
  try
    Query.SQL.Text := 'SELECT TMP$ATTACHMENT_ID FROM TMP$ATTACHMENTS WHERE TMP$STATE = ''ACTIVE''';
    Query.Open;
    SQL.SQL.Text := 'UPDATE TMP$ATTACHMENTS SET TMP$STATE = ''SHUTDOWN'' WHERE TMP$ATTACHMENT_ID = :ATTACHMENT_ID';
    SQL.ParamByName('ATTACHMENT_ID').AsInteger := Query.FieldByName('TMP$ATTACHMENT_ID').AsInteger;

    Query.Close;

    SQL.Execute;
    KillConnection.Disconnect;
  finally
    KillConnection.Free;
    Query.Free;
    SQL.Free;
  end;
end;

function TDM.InTransaction: boolean;
begin
  Result := UpdateTransaction.Active;
end;

procedure TDM.StartTransaction;
begin
  UpdateTransaction.StartTransaction;
end;

procedure TDM.CommitTransaction;
begin
  UpdateTransaction.Commit;
end;

procedure TDM.RollbackTransaction;
begin
  UpdateTransaction.Rollback;
end;

end.
