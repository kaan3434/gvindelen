unit GvHtml;

interface

function HtmlEncode(St: String): String;
function HtmlDecode(St: String): String;

function TagPresent(Html, Tag:String): Boolean;

function ExtractAllTags(Html, Tag: String; Devider:String=#$D#$A): string;

function DeleteAllTags(Html, Tag: String): string;

function ExtractTagProperty(HTML, Tag, Prop: String): String;

function ExtractHostName(URL: String): String;

function ExtractLinkParams(URL: String): String;

function ExtractLinkParamValue(URL, Param: String): String;

function NumberingTag(Html, TagName: String): String;

function ExtractTagNo(Html, TagName: String): String;

function TakeTagWithNo(var Html: String; TagName, TagNo: String): String;

function ClearNumbering(html: String; TagName: String=''): String;

function TakeNumberedTagContains(var Html: String; TagName, Contain1: String;
  Contain2: String=''; Contain3: String=''): String;

implementation

uses
  RegExpr, SysUtils, GvinStr;

function HtmlEncode(St: String): String;
var
  i: Integer;
begin
  result:= '';
  For i:= 1 to Length(St) do
  If St[i] in [#$20..#$2F, #$3A..#$3F, #$5B..#$5F, #128..#255] then
    result:= result+'%'+StrToHex(St[i])
  else
    result:= result+St[i];
end;

function HtmlDecode(St: String): String;
var
  L, i: Integer;
begin
  result:= '';
  L:= Length(St);
  i:= 1;
  while i<=L do
  begin
    if St[i] ='%' then
    begin
      result:= result+HexToStr(Copy(St, i+1, 2));
      Inc(i, 3);
    end
    else
    begin
      result:= result+St[i];
      Inc(i);
    end;
  end;
end;


function ExtractTagProperty(HTML, Tag, Prop: String): String;
var
  r: TRegExpr;
  St,Expr: String;
begin
  result:= '';
  r:= TRegExpr.Create;
  try
    r.ModifierI:= true;
    r.ModifierG:= false;
    r.Expression:= Format('<%s.*?>', [Tag]);
    if r.Exec(Html) then
      St:= r.Match[0]
    else
      exit;
    r.ModifierI:= true;
    r.ModifierG:= false;
    Expr:= Format(' %s="(.+?)"', [prop]);
    r.Expression:= Expr;
    if r.Exec(St) then
    begin
      Result:= r.Match[1];
      exit;
    end;
    Expr:= Format(' %s=''(.+?)''', [prop]);
    r.Expression:= Expr;
    if r.Exec(St) then
    begin
      Result:= r.Match[1];
      exit;
    end;
    Expr:= Format(' %s=(.+?)[ |>]', [prop]);
    r.Expression:= Expr;
    if r.Exec(St) then
    begin
      Result:= r.Match[1];
      exit;
    end;
  finally
    r.Free;
  end;
end;

function ExtractAllTags(Html, Tag: String; Devider:String=#$D#$A): string;
var
  r : TRegExpr;
begin
  r := TRegExpr.Create;
  try
    r.ModifierI:= true;
    r.ModifierG:= false;
    r.Expression:= Tag;
    if r.Exec(Html) then
    Repeat
      Result := Result + r.Match[0]+Devider;
    Until not r.ExecNext;
  finally
    r.Free;
  end;
end;

function DeleteAllTags(Html, Tag: String): string;
var
  r : TRegExpr;
begin
  r := TRegExpr.Create;
  try
    r.ModifierI:= true;
    r.ModifierG:= false;
    r.Expression:= Tag;
    result:= Html;
    while r.Exec(result) do
      Delete(result, r.MatchPos[0], r.MatchLen[0]);
  finally
    r.Free;
  end;
end;

function TagPresent(Html, Tag:String): Boolean;
var
  r : TRegExpr;
begin
  r:= TRegExpr.Create;
  try
    r.ModifierG:= false;
    r.Expression:= Tag;
    result:= r.Exec(Html);
  finally
    r.Free;
  end;
end;

function ExtractHostName(URL: String): String;
begin
  result:= TakeFront3(URL, ':/');
  result:= result+CopyFront4(URL, '/');
end;

function ExtractLinkParams(URL: String): String;
begin
  TakeFront5(URL, '?');
  result:= URL;
end;

function ExtractLinkParamValue(URL, Param: String): String;
var
  St, Nm: String;
begin
  result:= '';
  TakeFront5(URL, '?');
  while URL<>'' do
  begin
    St:= TakeFront5(URL, '&');
    Nm:= TakeFront5(St, '=');
    if Nm=Param then
    begin
      result:= St;
      break;
    end;
  end;
end;

function NumberingTag(Html, TagName: String): String;
var
  St1, St2, SNumber: String;
  P1, P2, L1, L2, LSt, Number: Integer;
begin
  Number:= 0;
  repeat
    Inc(Number);
    SNumber:= Format(#9'TagNo="%s%u"',[TagName, Number]);
    LSt:= Length(Html);
    P1:= 0;
    St1:= CopyBE(Html, '<'+TagName+' ', '>', '', '', '</'+TagName+'>', P1);
    if St1 = '' then break;
    L1:= Length(St1);
    St2:= CopyBE(St1, '<'+TagName+'>', '</'+TagName+'>');
    if St2<>'' then
      St1:= ReplaceAll(St1, '<'+TagName+'>', '<'+TagName+SNumber+'>')
    else
      St1:= ReplaceAll(St1, '<'+TagName+' ', '<'+TagName+SNumber+' ');
    St1:= ReplaceAll(St1, '</'+TagName+'>', '</'+TagName+SNumber+'>');
    Html:=Copy(Html, 1, P1-1)+St1+Copy(Html, P1+L1, LSt);
  until false;
  repeat
    Inc(Number);
    SNumber:= Format(#9'TagNo="%s%u"',[TagName, Number]);
    LSt:= Length(Html);
    P1:= 0;
    St1:= CopyBE(Html, '<'+TagName+'>', '', '', '', '</'+TagName+'>', P1);
    if St1 = '' then break;
    L1:= Length(St1);
    St1:= ReplaceAll(St1, '<'+TagName+'>', '<'+TagName+SNumber+'>');
    St1:= ReplaceAll(St1, '</'+TagName+'>', '</'+TagName+SNumber+'>');
    Html:=Copy(Html, 1, P1-1)+St1+Copy(Html, P1+L1, LSt);
  until false;
  result:= Html;
end;

function ExtractTagNo(Html, TagName: String): String;
begin
  result:= CopyBE(Html, '<'+TagName+#9, '>');
  result:= CopyBE(result, #9'TagNo="', '"');
end;

function TakeTagWithNo(var Html: String; TagName, TagNo: String): String;
begin
  result:= TakeBE(Html, '<'+TagName+TagNo, '</'+TagName+TagNo+'>');
end;

function ClearNumbering(html: String; TagName: String=''): String;
begin
  result:= DeleteAllBE(Html, #9'TagNo="'+TagName, '"');
end;

function TakeNumberedTagContains(var Html: String; TagName, Contain1: String;
  Contain2: String=''; Contain3: String=''): String;
var
  Number: Integer;
  SNumber, StB, StE: String;
begin
  result:= '';
  Number:= 0;
  repeat
    Inc(Number);
    SNumber:= Format(#9'TagNo="%s%u"',[TagName, Number]);
    StB:= LowerCase('<'+TagName+SNumber);
    StE:= '</'+TagName+SNumber+'>';
    result:= TakeBE(Html, StB, Contain1, Contain2, Contain3, StE, false);
    if result<>'' then
      Exit;
  until Pos(StB, AnsiLowerCase(Html))=0;
end;

end.
