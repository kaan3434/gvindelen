unit events;

interface

uses
  common,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmEvents = class(TForm)
    btnEvent1: TButton;
    btnEvent2: TButton;
    btnEvent3: TButton;
    btnClose: TBitBtn;
    procedure btnEvent1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEvents: TfrmEvents;

implementation

uses dm_main;

{$R *.DFM}

procedure TfrmEvents.btnEvent1Click(Sender: TObject);
var
  sSQL: string;
begin
  sSQL := 'EXECUTE PROCEDURE SEND_EVENT(:ID)';
  FastExecSQL(dmMain.sqlSpeedRead, sSQL, [(Sender as TButton).Tag], True);
end;

end.
