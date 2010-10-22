unit uBookGrabber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ComCtrls, GvVars, GvWebScript,
  ActnList;

type
  TForm1 = class(TForm)
    eURL: TEdit;
    Label1: TLabel;
    pages: TButton;
    WebBrowser: TWebBrowser;
    GvWebScript: TGvWebScript;
    sb: TStatusBar;
    pb: TProgressBar;
    stCurUrl: TStaticText;
    Text: TButton;
    ActionList1: TActionList;
    actDownloadPages: TAction;
    actDownloadText: TAction;
    procedure actDownloadTextUpdate(Sender: TObject);
    procedure actDownloadTextExecute(Sender: TObject);
    procedure actDownloadPagesExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Path: TVarList;

implementation

{$R *.dfm}
uses
  GvinFile, IdURI;

procedure TForm1.actDownloadTextUpdate(Sender: TObject);
begin
  actDownloadText.Enabled:= FileExists(Path['Html']+'PageLink.txt');
end;

procedure TForm1.actDownloadTextExecute(Sender: TObject);
var
  LURI : TIdURI;
  sl: TStringList;
  i: Integer;
  Author, Book, FName: String;
  Complete: Boolean;
begin
  LURI:= TIdURI.Create(eURL.Text);
  try
    sl:= TStringList.Create;
    try
      sl.LoadFromFile(Path['Html']+'PageLink.txt');
      repeat
        Complete:= true;
        for i:= 0 to sl.Count-1 do
        begin
          FName:= path['Html']+Format('%3.3u.txt', [i+1]);
          stCurUrl.Caption:= sl[i];
          If Not FileExists(FName) then
          try
            LURI.URI:= sl[i];
            GvWebScript.ScriptFileName:= Path['Script']+LURI.Host+'.xml';
            GvWebScript.Vars.AddStringsAsArea('Path', Path);
            GvWebScript.Vars['Document']:= FName;
            GvWebScript.Vars['URL']:= sl[i];
            GvWebScript.Run('GetText');
          except
            Complete:= false;
          end;
        end;
      until complete;
      GvWebScript.ScriptFileName:= Path['Script']+LURI.Host+'.xml';
      GvWebScript.Vars.AddStringsAsArea('Path', Path);
      GvWebScript.Run('GetAuthor');
      Author:= LoadFileAsString(Path['Html']+'Author.txt');
      Book:= '';
      for i:= 0 to sl.Count-1 do
      begin
        FName:= path['Html']+Format('%3.3u.txt', [i+1]);
        Book:= Book+LoadFileAsString(FName)
      end;
      SaveStringAsFile(Book, Path['Book']+Author+'.html');
      ShowMessageFmt('Закачка книги "%s" завершена', [Author]);
    finally
      sl.Free;
    end;
  finally
    LURI.Free;
  end;
end;

procedure TForm1.actDownloadPagesExecute(Sender: TObject);
var
  LURI : TIdURI;
  ScriptName: String;
begin
  if MessageDlg('Удалить предыдущую закачку книги?', mtWarning, [mbYes, mbNo], 0)=mrYes then
    DeleteFiles(Path['Html']+'*.*')
  else
    exit;
  LURI:= TIdURI.Create(eURL.Text);
  try
    ScriptName:= Path['Script']+LURI.Host+'.xml';
    if FileExists(ScriptName) then
    begin
      SaveStringAsFile(eURL.Text+#$D#$A, Path['Html']+'PageLink.txt');
      GvWebScript.ScriptFileName:= Path['Script']+LURI.Host+'.xml';
      GvWebScript.Vars.AddStringsAsArea('Path', Path);
      GvWebScript.Vars['URL']:= eURL.Text;
      GvWebScript.Run('GetPages');
    end
    else
      ShowMessage('Для данного ресурса нет скрипта закачки');
  finally
    LURI.Free;
  end;
end;

initialization
  Path:= TVarList.Create;
  Path.LoadSectionFromIniFile(ProjectIniFileName, 'Path');
  Path.Text:= StringReplace(Path.Text, '=.\', '='+ExtractFilePath(ParamStr(0)),[rfReplaceAll]);
  Path['Self']:= ExtractFilePath(ParamStr(0));
finalization
  Path.Free;
end.
