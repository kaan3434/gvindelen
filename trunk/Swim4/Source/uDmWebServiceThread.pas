unit uDmWebServiceThread;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDmSwim, FIBDatabase, pFIBDatabase,
  FIBQuery, pFIBQuery, pFIBStoredProc;

type
  TdmSwimThread = class(TdmSwim)
    spRequestBusyNext: TpFIBStoredProc;
    spRequestAdd: TpFIBStoredProc;
    spRequestCommit: TpFIBStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmSwimThread: TdmSwimThread;

implementation

{$R *.dfm}

{ TdmSwimThread }

{ TdmSwimThread }

end.
