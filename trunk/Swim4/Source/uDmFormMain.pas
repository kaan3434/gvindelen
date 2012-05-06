unit uDmFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDmSwim, FIBDatabase, pFIBDatabase,
  FIBQuery, pFIBQuery, pFIBStoredProc, GvXml;

type
  TdmFormMain = class(TdmSwim)
    spRequestAdd: TpFIBStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SportsRequestAdd(aBooker: TGvXmlNode);
  end;

var
  dmFormMain: TdmFormMain;

implementation

{$R *.dfm}

{ TdmFormMain }

procedure TdmFormMain.SportsRequestAdd(aBooker: TGvXmlNode);
var
  Scan_Id: Integer;
  Parts: TStringList;
begin
  trnWrite.StartTransaction;
  try
    // получаем очередной Scan_id
    Scan_Id:= dbSwim.QueryValue(
        'select o_scan_id from scan_new(:i_booker_id)',
        0, [aBooker['Id']], trnWrite);
    with spRequestAdd do
    begin
      Params.ParamByName('I_SCAN_ID').AsInteger:= Scan_Id;
      Params.ParamByName('I_ACTION_SIGN').AsString:= 'getSports';
      Parts:= TStringList.Create;
      try
        Parts.Values['BookerSign']:= aBooker['Sign'];
        Params.ParamByName('I_PARTS').AsString:= Parts.Text;
      finally
        Parts.Free;
      end;
      ExecProc;
    end;
    trnWrite.Commit;
  except
    trnWrite.Rollback;
  end;
end;

end.
