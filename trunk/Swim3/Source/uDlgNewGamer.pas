unit uDlgNewGamer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Mask, DBCtrlsEh, DB, ExtCtrls, NativeXML,
  GridsEh, DBGridEh, Menus, ComCtrls, DBLookupEh;

type
  TDlgNewGamer = class(TForm)
    ActionList: TActionList;
    actAddGamer: TAction;
    actSkipGamer: TAction;
    actAbsGamerAdd: TAction;
    btnCancel: TButton;
    btnOk: TButton;
    Button1: TButton;
    actSkipSport: TAction;
    actSkipAll: TAction;
    Button2: TButton;
    actCountryAdd: TAction;
    actCopyAbsGamer1: TAction;
    actCopyAbsGamer2: TAction;
    memTournirName: TMemo;
    btnDelEvent: TButton;
    actDeleteEvent: TAction;
    eBookmakerName: TLabeledEdit;
    eSportName: TLabeledEdit;
    btnTournirAdd: TButton;
    actTournirAdd: TAction;
    eEventDate: TLabeledEdit;
    eOpponent: TLabeledEdit;
    actTournirIgnore: TAction;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    actDeleteGamer: TAction;
    N1: TMenuItem;
    lAbstractSport: TLabel;
    cbAbsGamer: TDBComboBoxEh;
    Label2: TLabel;
    cbCountry: TDBComboBoxEh;
    Label3: TLabel;
    cbSex: TDBComboBoxEh;
    btnCopy1: TButton;
    btnCopy2: TButton;
    actAbsGamerDel: TAction;
    cbFoundedGamer: TDBComboBoxEh;
    actAbsGamerFoundedSet: TAction;
    actAbsGamerClear: TAction;
    eFoundedCount: TEdit;
    eGamerName: TDBComboBoxEh;
    Label1: TLabel;
    actFindGamer: TAction;
    pcGamers: TPageControl;
    tsGamerNames: TTabSheet;
    gridTournirs: TDBGridEh;
    tsGamerTournirs: TTabSheet;
    gridGamer: TDBGridEh;
    cbTemporary: TCheckBox;
    tsOpponents: TTabSheet;
    gridOpponents: TDBGridEh;
    lcbAGamers: TDBLookupComboboxEh;
    procedure FormActivate(Sender: TObject);
    procedure actAddGamerUpdate(Sender: TObject);
    procedure actAddGamerExecute(Sender: TObject);
    procedure actAbsGamerAddExecute(Sender: TObject);
    procedure actSkipGamerExecute(Sender: TObject);
    procedure actSkipSportExecute(Sender: TObject);
    procedure actSkipAllExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCountryEditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure cbSexEditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure actDeleteEventExecute(Sender: TObject);
    procedure actTournirAddExecute(Sender: TObject);
    procedure cbAbsGamerChange(Sender: TObject);
    procedure actTournirIgnoreExecute(Sender: TObject);
    procedure actDeleteGamerExecute(Sender: TObject);
    procedure actDeleteGamerUpdate(Sender: TObject);
    procedure actAbsGamerDelExecute(Sender: TObject);
    procedure actAbsGamerFoundedSetExecute(Sender: TObject);
    procedure actAbsGamerClearExecute(Sender: TObject);
    procedure cbFoundedGamerChange(Sender: TObject);
    procedure actFindGamerExecute(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure cbCountryExit(Sender: TObject);
    procedure cbCountryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    BookerId: Integer;
    BSportId: Integer;
    ASportId: Integer;
    ASportName: String;
    BGamerId: Integer;
    BGamerName: String;
    OpponentId: Integer;
    OpponentName: String;
    AGamerId: Integer;
    AGamerName: String;
    CountrySign: String;
    TournirId: Integer;
    TournirName: String;
    AGamer1Name: String;
    AGamer2Name: String;
    CanRefresh: Boolean;
    WordNo: Byte;
  public
    { Public declarations }
    ndEvent: TXmlNode;
    EditGamerNo: Byte;
  end;

var
  DlgNewGamer: TDlgNewGamer;

implementation

uses dm, ADODB, GvinStr, Math;

{$R *.dfm}

procedure TDlgNewGamer.FormActivate(Sender: TObject);
var
  ndSport: TXmlNode;
  ni: Integer;
begin
  WordNo:= 0;
  AGamer1Name:= '';
  AGamer2Name:= '';
  cbAbsGamer.ItemIndex:= -1;
  cbTemporary.Checked:= false;
  ndSport:= ndEvent.Parent.Parent;
  BookerId:= ndSport.ReadAttributeInteger('Bookmaker_Id');
  ASportId:= ndSport.ReadAttributeInteger('AbsSport_Id');
  BSportId:= ndSport.ReadAttributeInteger('Sport_Id');
  ASportName:= dmSwim.ASportName(ASportId);
  TournirName:= ndSport.ValueAsString;
  TournirId:= ndSport.ReadAttributeInteger('Tournir_Id');

  if EditGamerNo=1 then
  begin
    AGamerId:= ndEvent.ReadAttributeInteger('Gamer1', 0);
    OpponentId:= ndEvent.ReadAttributeInteger('Gamer2', 0);
    OpponentName:= ndEvent.NodeByName('Gamer2').ValueAsString;
    BGamerName:= ndEvent.NodeByName('Gamer1').ValueAsString;
  end
  else
  begin
    AGamerId:= ndEvent.ReadAttributeInteger('Gamer2', 0);
    OpponentId:= ndEvent.ReadAttributeInteger('Gamer1', 0);
    OpponentName:= ndEvent.NodeByName('Gamer1').ValueAsString;
    BGamerName:= ndEvent.NodeByName('Gamer2').ValueAsString;
  end;
  memTournirName.Lines.Text:= TournirName;
  CanRefresh:= false;


  eBookmakerName.Text:= dmSwim.BookerName(BookerId);
  eSportName.Text:= dmSwim.ASportName(ASportId);
  eOpponent.Text:= OpponentName;
  eGamerName.Text:= BGamerName;
  eEventDate.Text:= FormatDateTime('YYYY-MM-DD HH:MM',
    ndEvent.NodeByName('Date').ValueAsDateTime);


{  if ndSport.ReadAttributeInteger('Country_Id', 0)>=0 then
  begin
    ni:= cbCountry.KeyItems.IndexOf(ndSport.ReadAttributeString('Country_Id'));
    If cbCountry.ItemIndex<>ni then
    begin
      cbCountry.ItemIndex:= ni;
      CountrySign:= ndSport.ReadAttributeString('Country_Id')
    end
  end
  else
  begin
    cbCountry.ItemIndex:= -1;
    Country_Id:= -1;
  end;
 }

//  FillAbsGamerCombo;
  CanRefresh:= true;

{  if AGamerId<>0 then
    cbAbsGamer.ItemIndex:= cbAbsGamer.KeyItems.IndexOf(IntToStr(AbsGamer_Id));}
{  with dmSwim do
  begin
    if memASports.Locate('AbsSport_Id', AbsSport_Id, []) then
    begin
      actCopyAbsGamer1.Visible:= memASports['Doubles_Flg'];
      actCopyAbsGamer2.Visible:= memASports['Doubles_Flg'];
    end;
  end;
  dmSwim.FillMemTable(dmSwim.memTournirs, Format(
    'SELECT AbsGamer_Id, Tournir_Name, Country_Alpha3, Country_Name, LastUse_Dt, Bookmaker_Name '+
    'FROM swv_GamerTournir  '+
    'WHERE AbsSport_Id=%u '+
    'ORDER BY LastUse_Dt DESC, Tournir_Name', [AbsSport_Id]));
  dmSwim.FillMemTable(dmSwim.memAbsGamer, Format(
    'SELECT AbsGamer_Id, Gamer_Id, Gamer_Name, Bookmaker_Name, LastUse_Dt '+
    'FROM swv_Gamer '+
    'WHERE AbsSport_Id=%u '+
    'ORDER BY LastUse_Dt DESC, Gamer_Name', [AbsSport_Id]));
  cbAbsGamerChange(Self);

  cbFoundedGamer.Visible:= cbFoundedGamer.KeyItems.Count>0;
  eFoundedCount.Visible:= cbFoundedGamer.Visible;
  if (Opponent_Id>0) and (cbFoundedGamer.Visible) then
  begin
    cbFoundedGamer.ItemIndex:= 0;
    eFoundedCount.Text:= IntToStr(cbFoundedGamer.KeyItems.Count);
    cbFoundedGamerChange(self);
  end;
}
  cbAbsGamer.SetFocus;
end;

procedure TDlgNewGamer.actAddGamerUpdate(Sender: TObject);
begin
  actAddGamer.Enabled:= (TournirId>0) and (cbAbsGamer.ItemIndex>=0);
end;

procedure TDlgNewGamer.actAddGamerExecute(Sender: TObject);
begin
{  with dmSwim.sp do
  begin
    AbsGamerId:= StrToInt(cbAbsGamer.KeyItems[cbAbsGamer.ItemIndex]);
    Parameters.Clear;
    ProcedureName:= 'swp_Gamer_iu';
    Parameters.Refresh;
    Parameters.ParamValues['@Bookmaker_Id']:= Bookmaker_Id;
    Parameters.ParamValues['@AbsGamer_Id']:= AbsGamer_Id;
    Parameters.ParamValues['@Gamer_Name']:= Gamer_Name;
    Parameters.ParamValues['@Temporary']:= cbTemporary.checked;
    ExecProc;
    if Parameters.ParamValues['@result']<>0 then
      ShowMessage(Parameters.ParamValues['@resmes'])
    else
    begin
      Gamer_Id:= Parameters.ParamValues['@Gamer_Id'];
      If EditGamerNo=1 then
      begin
        ndEvent.NodeByName('Gamer1').WriteAttributeInteger('Id', AbsGamer_Id);
        ndEvent.WriteAttributeInteger('Gamer1', AbsGamer_Id);
      end
      else
      begin
        ndEvent.NodeByName('Gamer2').WriteAttributeInteger('Id', AbsGamer_Id);
        ndEvent.WriteAttributeInteger('Gamer2', AbsGamer_Id);
      end;
      ModalResult:= mrOk;
    end;
  end;
  }
end;

procedure TDlgNewGamer.actAbsGamerAddExecute(Sender: TObject);
var
  ii: integer;
  sl: TStringList;
begin
{
  with dmSwim.sp do
  begin
    ii:= cbAbsGamer.ItemIndex;
    if ii=-1 then
    begin
      if ((Pos('/', Gamer_Name)>0) or (Pos('-', Gamer_Name)>0))
         and ((AbsGamer1_Name<>'') or (AbsGamer2_Name<>'')) then
        AbsGamer_Name:= AbsGamer1_Name+' / '+AbsGamer2_Name
      else
        AbsGamer_Name:= Gamer_Name;
      AbsGamer_Id:= 0;
    end
    else
    begin
      AbsGamer_Name:= cbAbsGamer.Items[ii];
      AbsGamer_Id:= StrToInt(cbAbsGamer.KeyItems[ii]);
    end;
    if InputQuery('Новый Участник', 'Введите имя участника', AbsGamer_Name) then
    begin
      AbsGamer_Name:= DeleteDoubleSpace(AbsGamer_Name);
      AbsGamer_Name:= ReplaceAll(AbsGamer_Name, '.', '. ');
      AbsGamer_Name:= ReplaceAll(AbsGamer_Name, ',', ', ');
      AbsGamer_Name:= ReplaceAll(AbsGamer_Name, ' ,', ', ');
      AbsGamer_Name:= DeleteDoubleSpace(AbsGamer_Name);
      AbsGamer_Name:= trim(AbsGamer_Name);
      if (cbCountry.ItemIndex>0) And
         (Pos('('+CopyFront4(cbCountry.Text)+')', AbsGamer_Name)=0) then
      begin
        AbsGamer_Name:= AbsGamer_Name + ' ('+CopyFront4(cbCountry.Text)+')';
      end;
      if Length(AbsGamer_Name)<3 then Exit;
      Parameters.Clear;
      ProcedureName:= 'swp_AbsGamer_iu';
      Parameters.Refresh;
      Parameters.ParamValues['@AbsGamer_Id']:= AbsGamer_Id;
      Parameters.ParamValues['@AbsGamer_Name']:= AbsGamer_Name;
      Parameters.ParamValues['@AbsSport_Id']:= AbsSport_Id;
      if cbSex.ItemIndex>=0 then
        Parameters.ParamValues['@AbsGamer_Sex']:= cbSex.Text;
      ExecProc;
      if Parameters.ParamValues['@result']<>0 then
        ShowMessage(Parameters.ParamValues['@resmes'])
      else
      begin
        sl:= TStringList.Create;
        try
          if AbsGamer_Id=Parameters.ParamValues['@AbsGamer_Id'] then
          begin
            cbAbsGamer.KeyItems.Delete(ii);
            cbAbsGamer.Items.Delete(ii);
          end;
          AbsGamer_Id:= Parameters.ParamValues['@AbsGamer_Id'];
          sl.Text:= cbAbsGamer.Items.Text;
          sl.Add(AbsGamer_Name);
          sl.Sort;
          cbAbsGamer.Items.Text:= sl.Text;
          ii:= sl.IndexOf(AbsGamer_Name);
          cbAbsGamer.KeyItems.Insert(ii,IntToStr(AbsGamer_Id));
          cbAbsGamer.ItemIndex:= ii;
        finally
          sl.Free;
        end;
      end;
    end
    else
      AbsGamer_Name:= '';
  end;
}
end;

procedure TDlgNewGamer.actSkipGamerExecute(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TDlgNewGamer.actSkipSportExecute(Sender: TObject);
begin
  ndEvent.Parent.Parent.WriteAttributeString('Action', 'Skip');
  ModalResult:= mrCancel;
end;

procedure TDlgNewGamer.actSkipAllExecute(Sender: TObject);
var
  Root, ndSport: TXmlNode;
  i, ai: integer;
begin
  Root:= ndEvent.Parent.Parent.Parent;
  For i:= 0 to Root.NodeCount-1 do
  begin
    ndSport:= Root.Nodes[i];
    ai:= ndSport.AttributeIndexByname('Action');
    if ai=-1 then
      ndSport.WriteAttributeString('Action', 'Skip');
  end;
  ModalResult:= mrCancel;
end;

procedure TDlgNewGamer.FormCreate(Sender: TObject);
begin
{  dmSwim.FillComboBox(cbCountry,
    'SELECT Country_Id, Country_Alpha3+'' - ''+Country_Name '+
    'FROM swt_AbsCountry '+
    'ORDER BY Country_Alpha3', false);
  pcGamers.ActivePage:= tsGamerNames;
}
end;

procedure TDlgNewGamer.cbCountryEditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
  CountrySign:= '   ';
  CanRefresh:= false;
  cbCountry.ItemIndex:= -1;
  CanRefresh:= true;
//  FillAbsGamerCombo;
end;

procedure TDlgNewGamer.cbSexEditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
//  FillAbsGamerCombo;
end;

procedure TDlgNewGamer.actDeleteEventExecute(Sender: TObject);
begin
  ndEvent.WriteAttributeString('Action', 'Delete');
  ModalResult:= mrCancel;
end;

procedure TDlgNewGamer.actTournirAddExecute(Sender: TObject);
var
  Tournir: String;
begin
{  Tournir:= TournirName;
  if InputQuery('Новый турнир', 'Введите название турнира', Tournir) then
  with dmSwim.sp do
  begin
    Parameters.Clear;
    ProcedureName:= 'swp_Tournir_iu';
    Parameters.Refresh;
    Parameters.ParamValues['@Sport_Id']:= AbsSport_Id;
    Parameters.ParamValues['@Tournir_Name']:= Trim(Tournir);
    Parameters.ParamValues['@Country_Id']:= Country_Id;
    Parameters.ParamValues['@Bookmaker_Id']:= Bookmaker_Id;
    if cbSex.ItemIndex>=0 then
      Parameters.ParamValues['@Tournir_Sex']:= cbSex.Text;
    ExecProc;
    actSkipSport.Execute;
  end;
}
end;

procedure TDlgNewGamer.cbAbsGamerChange(Sender: TObject);
var
  ii: Integer;
  AbsGamer_Id: String;
begin
  if CanRefresh then
  begin
    ii:= cbAbsGamer.ItemIndex;
    if ii>0 then
    begin
      AbsGamer_Id:= cbAbsGamer.KeyItems[ii];
      dmSwim.memAbsGamer.Filter:=
        Format('AbsGamer_Id=%s', [AbsGamer_Id]);
      dmSwim.memTournirs.Filter:=
        Format('AbsGamer_Id=%s', [AbsGamer_Id]);
      dmSwim.FillMemTable(dmSwim.memOpponents,
        Format('select * from swv_OpponentBookmaker '+
               'where AbsGamer_Id = %s '+
               'order by Event_Dt, AbsOpponent_Name', [AbsGamer_Id]));
    end
    else
    begin
      dmSwim.memAbsGamer.Filter:= '1=2';
      dmSwim.memTournirs.Filter:= '1=2';
      dmSwim.memOpponents.EmptyTable;
    end;
    dmSwim.memAbsGamer.Filtered:= true;
    dmSwim.memTournirs.Filtered:= true;
  end;
end;

procedure TDlgNewGamer.actTournirIgnoreExecute(Sender: TObject);
var
  Tournir: String;
begin
{
  Tournir:= TournirName;
  if InputQuery('Новый турнир', 'Введите название игнорируемого турнира', Tournir) then
  with dmSwim.sp do
  begin
    Parameters.Clear;
    ProcedureName:= 'swp_TournirIgnore_i';
    Parameters.Refresh;
    Parameters.ParamValues['@AbsSport_Id']:= AbsSport_Id;
    Parameters.ParamValues['@Tournir_Name']:= Trim(Tournir);
    Parameters.ParamValues['@Bookmaker_Id']:= Bookmaker_Id;
    ExecProc;
    ndEvent.Parent.Parent.WriteAttributeString('Action', 'Delete');
    actSkipSport.Execute;
  end;
}
end;

procedure TDlgNewGamer.actDeleteGamerExecute(Sender: TObject);
var
  Gamer_Id: integer;
begin
{
  Gamer_Id:= dmSwim.memAbsGamer['Gamer_Id'];
  dmSwim.cmd.CommandText:= Format(
    'DELETE FROM swt_Gamer WHERE Gamer_ID=%u',
    [Gamer_Id]);
  dmSwim.cmd.Execute;
  dmSwim.FillMemTable(dmSwim.memAbsGamer, Format(
    'SELECT AbsGamer_Id, Bookmaker_Name, Gamer_Id, Gamer_Name '+
    'FROM swv_Gamer '+
    'WHERE AbsSport_Id=%u '+
    'ORDER BY LastUse_Dt DESC, Gamer_Name', [AbsSport_Id]));
}
end;

procedure TDlgNewGamer.actDeleteGamerUpdate(Sender: TObject);
begin
//  actDeleteGamer.Enabled:= Not gridGamer.DataSource.DataSet.Eof;
end;

procedure TDlgNewGamer.actAbsGamerDelExecute(Sender: TObject);
var
  ii: integer;
  Sex: String[3];
begin
{  ii:= cbAbsGamer.ItemIndex;
  if (ii>0) and
     (MessageDlg('Удалить данного игрока?', mtConfirmation, [mbYes,mbNo], 0)= mrYes) then
  begin
    dmSwim.cmd.CommandText:= Format(
      'DELETE FROM swt_AbsGamer WHERE AbsGamer_ID=%s',
      [cbAbsGamer.KeyItems[ii]]);
    dmSwim.cmd.Execute;
    cbAbsGamer.ItemIndex:= -1;
    cbAbsGamer.KeyItems.Delete(ii);
    cbAbsGamer.Items.Delete(ii);
    Sex:= cbSex.Text+' ';
    dmSwim.WriteComboBoxToStream(cbAbsGamer, ASportId, CountrySign, Sex[1]);
  end;
}
end;

procedure TDlgNewGamer.actAbsGamerFoundedSetExecute(Sender: TObject);
var
  ii: Integer;
begin
  ii := cbFoundedGamer.ItemIndex;
  AGamerId:= StrToInt(cbFoundedGamer.KeyItems[ii]);
  cbAbsGamer.ItemIndex:= cbAbsGamer.KeyItems.IndexOf(cbFoundedGamer.KeyItems[ii]);
  cbAbsGamer.SetFocus;
  actAddGamer.Execute;
end;

procedure TDlgNewGamer.actAbsGamerClearExecute(Sender: TObject);
begin
  cbAbsGamer.ItemIndex:= -1;
end;

procedure TDlgNewGamer.cbFoundedGamerChange(Sender: TObject);
var
  ii: Integer;
begin
  if CanRefresh then
  begin
    ii:= cbFoundedGamer.ItemIndex;
    if ii>0 then
      dmSwim.memAbsGamer.Filter:=
        Format('AbsGamer_Id=%s', [cbFoundedGamer.KeyItems[ii]])
    else
      dmSwim.memAbsGamer.Filter:='1=2';
    dmSwim.memAbsGamer.Filtered:= true;
  end;
end;

procedure TDlgNewGamer.actFindGamerExecute(Sender: TObject);
var
  St: String;
  i, pii, cii: Integer;
begin
  St:= ExtractWord(WordNo, eGamerName.Text, [' ']);
  pii:= -1;
  For i:= 1 to Length(St) do
  begin
    cbAbsGamer.Text:= Copy(St, 1, i);
    cii:= cbAbsGamer.ItemIndex;
    if cii>pii then
      pii:= cii;
  end;
  Inc(WordNo);
end;

procedure TDlgNewGamer.FormDeactivate(Sender: TObject);
begin
//  dmSwim.WriteComboBoxToStream(cbAbsGamer, ASportId, CountrySign, Sex[1]);
end;

procedure TDlgNewGamer.cbCountryExit(Sender: TObject);
begin
{  if cbCountry.ItemIndex < 0 then
    Country_Id:= 0
  else
    Country_Id:= StrToInt(cbCountry.KeyItems[cbCountry.ItemIndex]);
  FillAbsGamerCombo;
}
end;

procedure TDlgNewGamer.cbCountryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then
    cbAbsGamer.SetFocus;
end;

end.



