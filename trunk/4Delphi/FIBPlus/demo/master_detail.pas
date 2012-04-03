unit master_detail;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Db, Grids, DBGrids, DBCtrls, Buttons, Spin,
  FIBDataSet, pFIBDataSet;

const
  DATABASE_NAME = 'md_demo.gdb';
    
type
  TfrmMasterDetail = class(TForm)
    dtMaster: TpFIBDataSet;
    dtDetail: TpFIBDataSet;
    dsMaster: TDataSource;
    dsDetail: TDataSource;
    dtSubDetail: TpFIBDataSet;
    dsSubDetail: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    GroupBox1: TGroupBox;
    Bevel5: TBevel;
    Bevel4: TBevel;
    Bevel1: TBevel;
    Label4: TLabel;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    SpinEdit1: TSpinEdit;
    btnReopen: TButton;
    btnInsert: TButton;
    btnDelete: TButton;
    btnScrollMaster: TButton;
    btnScrollDetail: TButton;
    DBNavigator2: TDBNavigator;
    Label5: TLabel;
    DBGrid2: TDBGrid;
    DBNavigator3: TDBNavigator;
    Label6: TLabel;
    DBGrid3: TDBGrid;
    btnClose: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure btnReopenClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnScrollMasterClick(Sender: TObject);
  private
    { Private declarations }
    drc: Integer;
    sdrc: Integer;
    procedure SetDetailConditions(AParam: Integer);
    procedure SetWaitEndMasterScrollInterval(AParam: Integer);
    procedure AfterDetailOpen(DataSet: TDataSet);
    procedure AfterSubDetailOpen(DataSet: TDataSet);
  public
    { Public declarations }
  end;

var
  frmMasterDetail: TfrmMasterDetail;

implementation

uses dm_main, pFIBProps, ActiveX;

{$R *.DFM}

function CreateClassID: string;
var
  ClassID: TCLSID;
  P: PWideChar;
begin
  CoCreateGuid(ClassID);
  StringFromCLSID(ClassID, P);
  Result := P;
  CoTaskMemFree(P);
end;

procedure TfrmMasterDetail.FormCreate(Sender: TObject);
begin
  dtDetail.AfterOpen := AfterDetailOpen;
  dtSubDetail.AfterOpen := AfterSubDetailOpen;
end;

procedure TfrmMasterDetail.SetDetailConditions(AParam: Integer);
begin
  with dtDetail do
  begin
    case AParam of
      1: begin
           if CheckBox1.Checked then
             DetailConditions := DetailConditions + [dcForceOpen]
           else
             DetailConditions := DetailConditions - [dcForceOpen];
         end;
      2: begin
           if CheckBox2.Checked then
             DetailConditions := DetailConditions + [dcForceMasterRefresh]
           else
             DetailConditions := DetailConditions - [dcForceMasterRefresh];
         end;
      3: begin
           if CheckBox3.Checked then
             DetailConditions := DetailConditions + [dcWaitEndMasterScroll]
           else
             DetailConditions := DetailConditions - [dcWaitEndMasterScroll];
         end;
    end;
  end;
  dtSubDetail.DetailConditions := dtDetail.DetailConditions;
end;

procedure TfrmMasterDetail.SetWaitEndMasterScrollInterval(AParam: Integer);
begin
  with dtDetail do
  begin
    case AParam of
      1: WaitEndMasterInterval := 300;
      2: WaitEndMasterInterval := 1000;
      3: WaitEndMasterInterval := 5000;
    end;
  end;
end;

procedure TfrmMasterDetail.CheckBox1Click(Sender: TObject);
begin
  SetDetailConditions((Sender as TCheckBox).Tag);
end;

procedure TfrmMasterDetail.ComboBox1Change(Sender: TObject);
begin
  SetWaitEndMasterScrollInterval(ComboBox1.ItemIndex);
end;

procedure TfrmMasterDetail.AfterDetailOpen(DataSet: TDataSet);
begin
  Inc(drc);
  Label5.Caption := 'Reopen count ' + IntToStr(drc)
end;

procedure TfrmMasterDetail.AfterSubDetailOpen(DataSet: TDataSet);
begin
  Inc(sdrc);
  Label6.Caption := 'Reopen count ' + IntToStr(sdrc)
end;

procedure TfrmMasterDetail.btnReopenClick(Sender: TObject);
begin
  dtMaster.CloseOpen(False);
end;

procedure TfrmMasterDetail.btnInsertClick(Sender: TObject);
begin
  with dtDetail do
  begin
    if IsEmpty then Exit;
    Insert;
    FieldByName('NAME').AsString := CreateClassID;
    Post;
  end;
end;

procedure TfrmMasterDetail.btnDeleteClick(Sender: TObject);
begin
  with dtDetail do
    if not IsEmpty then Delete;
end;

procedure TfrmMasterDetail.btnScrollMasterClick(Sender: TObject);
var
  i: Integer;
  ds: TDataSet;
begin
  drc := 0;
  sdrc := 0;
  Label5.Caption := 'Reopen count '+ IntToStr(drc);
  Label6.Caption := 'Reopen count '+ IntToStr(sdrc);
  if Sender= btnScrollMaster then
    ds := dtMaster
  else
    ds := dtDetail;
  with ds do
    if Active then
      for i := 1 to SpinEdit1.Value do
        if not eof then
          Next
        else
          First;
end;

end.
