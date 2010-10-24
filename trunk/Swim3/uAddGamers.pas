unit uAddGamers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ExtCtrls, StdCtrls, ActnList;

type
  TdlgAppendGamersEng = class(TForm)
    sp_IU: TADOStoredProc;
    Memo: TMemo;
    eURL: TLabeledEdit;
    btnGetData: TButton;
    ActionList: TActionList;
    actGetData: TAction;
    actOpenData: TAction;
    Button1: TButton;
    OpenDialog: TOpenDialog;
    Button2: TButton;
    actParse: TAction;
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actGetDataExecute(Sender: TObject);
    procedure actOpenDataExecute(Sender: TObject);
    procedure actParseExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgAppendGamersEng: TdlgAppendGamersEng;

implementation

uses
  dm, Math, RegExpr, GvinStr;

{$R *.dfm}

procedure TdlgAppendGamersEng.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actGetData.Enabled:= trim(eURL.Text)<>'';
end;

procedure TdlgAppendGamersEng.actGetDataExecute(Sender: TObject);
begin
  Memo.Lines.Text:= dmSwim.IdHTTP.Get(eURL.Text);
end;

procedure TdlgAppendGamersEng.actOpenDataExecute(Sender: TObject);
begin
  with OpenDialog do
  begin
    InitialDir:= Path['SteveGTennis'];
    If Execute then
      Memo.Lines.LoadFromFile(FileName);
  end;
end;

procedure TdlgAppendGamersEng.actParseExecute(Sender: TObject);
function SkipNonInfoLines(St: String): String;
var
  sl: TStringList;
  i: integer;
begin
  result:= '';
  sl:= TstringList.Create;
  sl.Text:= St;
  try
    For i:= sl.Count-1 downto 0 do
    begin
      St:= sl[i];
      if Pos(' d.', St)=0 then sl.Delete(i);
    end;
    result:= sl.Text;
  finally
    sl.Free;
  end;
end;

function ExtractGamers(St: String): String;
var
  re: TRegExpr;
  sl: TStringList;
  Gamer1,Cntr1,Gamer2,Cntr2,Gamer3,Cntr3,Gamer4,Cntr4: String;
  i: integer;
begin
  result:= '';
  re:= TRegExpr.Create;
  sl:= TstringList.Create;
  sl.Text:= St;
  try
    for i:= 0 to sl.Count-1 do
    begin
      re.Expression:= '((\(.*?\))?(.+?)\((.*?)\)){1}?\sd.\s((\(.*?\))?(.+?)\((.*?)\)){1}?';
      if re.Exec(sl[i]) then
      begin
        Gamer1:= trim(re.Match[3]); Cntr1:= re.Match[4];
        Gamer2:= trim(re.Match[7]); Cntr2:= re.Match[8];
        Gamer3:= ''; Cntr3:= '';
        Gamer4:= ''; Cntr4:= '';
        if Pos('/', Gamer1)>0 then
        begin
          Gamer3:= TakeBack5(Gamer1, ['/']);
          Cntr3:= CopyBack4(Cntr1, ['/']);
          Cntr1:= CopyFront4(Cntr1, ['/']);
        end;
        if Pos('/', Gamer2)>0 then
        begin
          Gamer4:= TakeBack5(Gamer2, ['/']);
          Cntr4:= CopyBack4(Cntr2, ['/']);
          Cntr2:= CopyFront4(Cntr2, ['/']);
        end;
        if Pos('(', Gamer1)=0 then
          result:= result+Format('%s,%s'#13#10, [Gamer1,Cntr1]);
        if Pos('(', Gamer2)=0 then
          result:= result+Format('%s,%s'#13#10, [Gamer2,Cntr2]);
        if Gamer3<>'' then
          result:= result+Format('%s,%s'#13#10, [Gamer3,Cntr3]);
        if Gamer4<>'' then
          result:= result+Format('%s,%s'#13#10, [Gamer4,Cntr4]);
      end;
    end;
  finally
    re.Free;
    sl.Free;
  end;
end;

var
  i, InsCnt: integer;
  St: String;
begin
  Memo.Lines.Text:= SkipNonInfoLines(Memo.Lines.Text);
  Memo.Lines.Text:= ExtractGamers(Memo.Lines.Text);
  sp_IU.ProcedureName:= 'SWP_GamerEng_IU';
  InsCnt:= 0;
  For i:= 0 to Memo.Lines.Count-1 do
  begin
    St:= Memo.Lines[i];
    sp_IU.Parameters.Refresh;
    sp_IU.Parameters.ParamValues['@GamerID']:= -1;
    sp_IU.Parameters.ParamValues['@NameEng']:= TakeFront5(St,[',']);
    sp_IU.Parameters.ParamValues['@Country']:= St;
    sp_IU.ExecProc;
    if sp_IU.Parameters.ParamValues['@Result']=0 then
      Inc(InsCnt);
  end;

  ShowMessage(Format('%u записей вставлено', [InsCnt]));
end;

end.
