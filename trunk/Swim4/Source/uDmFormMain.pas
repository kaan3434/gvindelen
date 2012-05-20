unit uDmFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDmSwim, FIBDatabase, pFIBDatabase,
  FIBQuery, pFIBQuery, pFIBStoredProc, GvXml;

type
  TdmFormMain = class(TdmSwim)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SportsRequestAdd(aBooker: TGvXmlNode);
  end;

implementation

{$R *.dfm}

uses
  GvVars;

{ TdmFormMain }

procedure TdmFormMain.SportsRequestAdd(aBooker: TGvXmlNode);
var
  ScanId: Integer;
  Node: TGvXmlNode;
begin
  Node:= TGvXmlNode.Create;
  Node.NodeName:= 'getSport';
  try
    trnWrite.StartTransaction;
    try
      // получаем очередной Scan_id
      ScanId := dbSwim.QueryValue('select o_scan_id from scan_new(:i_booker_id)',
        0, [aBooker['Id']], trnWrite);
      Node['Booker_Sign']:= aBooker['Sign'];
      Node['Booker_Id']:= aBooker['Id'];
      Node['Booker_Title']:= aBooker['Title'];
      RequestAdd(ScanId, 'getSports', Node.WriteToString);
      trnWrite.Commit;
    except
      trnWrite.Rollback;
    end;
  finally
    Node.Free;
  end;
end;

end.
