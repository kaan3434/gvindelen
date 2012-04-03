
{*******************************************************}
{                                                       }
{             Copyright (C) 2000 - 2001                 }
{         Dmitriy Kovalenko (ibsysdba@i.com.ua)         }
{                         &                             }
{           Pavel Shibanov (ib_db@i.com.ua)             }
{                   Kiev, Ukraine                       }
{                                                       }
{*******************************************************}

unit common;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Dbctrls, IniFiles, StdCtrls,
  FIBDatabase, pFIBDatabase, pFIBDataSet, FIBQuery, pFIBQuery;

{$I const.inc}
                              
  procedure UnderConstruction;
  procedure SetGlobalConst;
  function GetExePath: string;

  {Quick Dialogs}
  procedure MsgError(const AMsg: string);
  procedure MsgWarning(const AMsg: string);
  procedure MsgInformation(const AMsg: string);
  function  MsgConfirmation(const AMsg: string): Boolean;

  {IniFile}
  function ReadInteger_Ini(const AFileName, ASection, AIndent: string; ADefault: Integer): Integer;
  function ReadString_Ini(const AFileName, ASection, AIndent: string; ADefault: string): string;
  procedure WriteInteger_Ini(const AFileName, ASection, AIndent: string; AValue: Integer);
  procedure WriteString_Ini(const AFileName, ASection, AIndent: string; AValue: string);

  {DB}
  procedure TransactionStart(const AIBTransaction: TpFIBTransaction);
  procedure TransactionCommit(const AIBTransaction: TpFIBTransaction);
  procedure TransactionsCommit(const AIBTransactions: array of TpFIBTransaction);
  procedure TransactionCommitRetaining(const AIBTransaction: TpFIBTransaction);
  procedure TransactionRollback(const AIBTransaction: TpFIBTransaction);
  procedure TransactionRollbackRetaining(const AIBTransaction: TpFIBTransaction);
  procedure OpenDataSets(const ADataSets: array of TDataSet);
  procedure CloseDataSets(const ADataSets: array of TDataSet);

  procedure FastExecSQL(ASQL: TpFIBQuery; SQLText: string; const AParams: array of Variant;
                        AutoCommit: Boolean); overload;


implementation

procedure UnderConstruction;
begin
  MsgWarning(UNDER_CONSTRUCTION);
end;

procedure SetGlobalConst;
begin
  DecimalSeparator := ',';
  DateSeparator    := '.';
  ShortDateFormat  := 'dd.mm.yyyy';
  ShortTimeFormat  := 'hh:mm:ss';
end;

function GetExePath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

////////////////////////////////////////////////////////////////////////////////
procedure MsgError(const AMsg: string);
begin
  MessageDlg(AMsg, mtError, [mbOk], 0);
end;

procedure MsgWarning(const AMsg: string);
begin
  MessageDlg(AMsg, mtWarning, [mbOk], 0);
end;

procedure MsgInformation(const AMsg: string);
begin
  MessageDlg(AMsg, mtInformation, [mbOk], 0);
end;

function MsgConfirmation(const AMsg: string): Boolean;
begin
  Result :=  MessageDlg(AMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

////////////////////////////////////////////////////////////////////////////////
function ReadInteger_Ini(const AFileName, ASection, AIndent: string; ADefault: Integer): Integer;
var
  IniFile: TIniFile;
begin
  IniFile:=TIniFile.Create(AFileName);
  try
    Result:=IniFile.ReadInteger(ASection, AIndent, ADefault);
  finally
    IniFile.Free;
  end;
end;

function ReadString_Ini(const AFileName, ASection, AIndent: string; ADefault: string): string;
var
  IniFile: TIniFile;
begin
  IniFile:=TIniFile.Create(AFileName);
  try
    Result:=IniFile.ReadString(ASection, AIndent, ADefault);
  finally
    IniFile.Free;
  end;
end;

procedure WriteInteger_Ini(const AFileName, ASection, AIndent: string; AValue: Integer);
var
  IniFile: TIniFile;
begin
  IniFile:=TIniFile.Create(AFileName);
  try
    IniFile.WriteInteger(ASection, AIndent, AValue);
  finally
    IniFile.Free;
  end;
end;

procedure WriteString_Ini(const AFileName, ASection, AIndent: string; AValue: string);
var
  IniFile: TIniFile;
begin
  IniFile:=TIniFile.Create(AFileName);
  try
    IniFile.WriteString(ASection, AIndent, AValue);
  finally
    IniFile.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TransactionStart(const AIBTransaction: TpFIBTransaction);
begin
  if not AIBTransaction.InTransaction then AIBTransaction.StartTransaction;
end;

procedure TransactionCommit(const AIBTransaction: TpFIBTransaction);
begin
  if AIBTransaction.InTransaction then AIBTransaction.Commit;
end;

procedure TransactionsCommit(const AIBTransactions: array of TpFIBTransaction);
var
  i: Integer;
begin
  for i := 0 to High(AIBTransactions) do
    if AIBTransactions[i].InTransaction then AIBTransactions[i].Commit;
end;

procedure TransactionCommitRetaining(const AIBTransaction: TpFIBTransaction);
begin
  if AIBTransaction.InTransaction then AIBTransaction.CommitRetaining;
end;

procedure TransactionRollback(const AIBTransaction: TpFIBTransaction);
begin
  if AIBTransaction.InTransaction then AIBTransaction.Rollback;
end;

procedure TransactionRollbackRetaining(const AIBTransaction: TpFIBTransaction);
begin
  if AIBTransaction.InTransaction then AIBTransaction.RollbackRetaining;
end;

procedure OpenDataSets(const ADataSets: array of TDataSet);
var
  i: Integer;
begin
  for i := 0 to High(ADataSets) do ADataSets[i].Open;
end;

procedure CloseDataSets(const ADataSets: array of TDataSet);
var
  i: Integer;
begin
  for i := 0 to High(ADataSets) do ADataSets[i].Close;
end;

procedure FastExecSQL(ASQL: TpFIBQuery; SQLText: string; const AParams: array of Variant;
AutoCommit: Boolean);
var
  i: Integer;
begin
  with ASQL do
  begin
    if Open then Close;
    SQL.Clear;
    Params.Count:=0;
    SQL.Text := SQLText;
    TransactionStart(TpFIBTransaction(Transaction));
    Prepare;
    if (Params.Count - 1 > High(AParams)) then
      raise Exception.Create('Переданное количество параметров меньше требуемого.');
    if Length(AParams) > 0 then
    begin
      for i := 0 to Params.Count - 1 do
      Params[i].AsVariant := AParams[i];
    end;

    ExecQuery;

    if AutoCommit then
    begin
      Close;
      TransactionCommit(TpFIBTransaction(Transaction));
    end;
  end;
end;

end.
