// FastReport 4 demo
unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, 
  Buttons, frxClass, frxIBDACComponents, frxDesgn, frxDACComponents;

type
  TForm1 = class(TForm)
    Button1: TButton;
    BitBtn1: TBitBtn;
    frxDesigner1: TfrxDesigner;
    frxIBDACComponents1: TfrxIBDACComponents;
    frxReport1: TfrxReport;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  frxReport1.DesignReport;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  frxReport1.ShowReport;
end;

end.
