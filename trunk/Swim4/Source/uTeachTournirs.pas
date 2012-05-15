unit uTeachTournirs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  FIBDatabase, pFIBDatabase, GridsEh, DBGridEh, Vcl.StdCtrls, Data.DB,
  FIBDataSet, pFIBDataSet, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, DBCtrlsEh;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    DBGridEh1: TDBGridEh;
    trnWrite: TpFIBTransaction;
    qryBTournirs: TpFIBDataSet;
    dsBTournirs: TDataSource;
    qryASports: TpFIBDataSet;
    qryATournirs: TpFIBDataSet;
    qryCountries: TpFIBDataSet;
    dsASports: TDataSource;
    dsATournirs: TDataSource;
    dsCountries: TDataSource;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGridEh2: TDBGridEh;
    Splitter2: TSplitter;
    Panel1: TPanel;
    edTournirName: TDBEditEh;
    DBEditEh2: TDBEditEh;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses uDmFormMain;

end.
