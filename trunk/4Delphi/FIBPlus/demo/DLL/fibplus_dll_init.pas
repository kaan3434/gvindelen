{$I fibplus_dll.inc}
unit fibplus_dll_init;

interface

{$IFNDEF BUILD_EXE}
uses
  Windows, Messages, SysUtils, Classes, Forms, Db,
  FIBQuery, pFIBQuery, FIBDatabase, pFIBDatabase,
  FIBDataSet, pFIBDataSet, ibase;

const
  INTERNAL_MESSAGE = WM_USER + 100;

  procedure ShowFormFromDLL(AppHandle: THandle; DBHandle: TISC_DB_HANDLE); StdCall;
  procedure DisconnectInDLL; StdCall;

exports
  ShowFormFromDLL,
  DisconnectInDLL;
{$ENDIF}

implementation

{$IFNDEF BUILD_EXE}
uses datamod_dll, main_dll;

procedure ShowFormFromDLL(AppHandle: THandle; DBHandle: TISC_DB_HANDLE);
begin
  try
    Application.Handle := AppHandle;
    dmMain := TdmMain.Create(Application);
    dmMain.dbDemoDLL.Handle := DBHandle;
    frmMain := TfrmMain.Create(Application);
    frmMain.ShowModal;
  finally
    Application.Handle := 0;
    frmMain.Free;
    dmMain.Free;
  end;
end;

procedure DisconnectInDLL;
begin
  if Assigned (dmMain) then
    dmMain.dbDemoDLL.Connected :=  not dmMain.dbDemoDLL.Connected;
end;

{$ENDIF}

end.
