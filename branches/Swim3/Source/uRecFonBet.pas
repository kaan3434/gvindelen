unit uRecLeonBet;

interface
uses
  Classes, NativeXML, ComCtrls;

const
  LeonBet_Name= 'LeonBet';
  LeonBet_Id=11;

procedure RecognizeLeonBetLine(Html: String; Line: TNativeXML; StatusBar: TStatusBar);

implementation

uses
  dm, GvinStr, GvHtml, SysUtils, Masks, Math, DateUtils, 
  GvinFile, GvinMath;

procedure RecognizeLeonBetLine(Html: String; Line: TNativeXML; StatusBar: TStatusBar);
var
  Sport_Name, Tournir_Name: String;
  ndSport, ndEvents, ndEvent, ndBets: TXmlNode;
  AbsSport_Id, Bookmaker_Id: Integer;
  Tournir_Sex: String;
  Country_Id, Sport_Id, Tournir_Id, Ways_Cnt: Integer;

function KillDate(Tournir_Name: String): String;
var
  PosMonth: Integer;
begin
  PosMonth:= Pos('January', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('February', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('March', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('April', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('May', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('June', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('July', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('August', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('September', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('October', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('November', Tournir_Name);
  if PosMonth = 0 then
    PosMonth:= Pos('December', Tournir_Name);
  result:= Trim(Copy(Tournir_Name, 1, PosMonth-1));
  TakeBack5(result);
  if LastChar(result)='-' then
    TakeBack5(result);
end;

procedure ExtractTournir(Html: String);
var
  sl: TStringList;
  St: String;
  i: Integer;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= ReplaceAll(Html, '><hr>', '>'#$D#$A'<hr>');
    For i:= 0 to sl.Count - 1 do
    begin
      St:= sl[i];
      if LowerCase(copy(St, 1, 4)) <> '<hr>' then continue;
      Tournir_Name:= PrepareTournirName(CopyBetween(St, '<hr>', '</table>'));
      Sport_Name:= TakeFront5(Tournir_Name, [',', '.']);
      Tournir_Name:= KillDate(Tournir_Name);
      Tournir_Name:= PrepareTournirName(Trim(Tournir_Name));
      StatusBar.SimpleText:= Tournir_Name;

      AbsSport_Id:= dmSwim.GetAbsSportId(Bookmaker_ID, Sport_Name, Tournir_Name,
        Country_Id, Tournir_Sex, Sport_Id, Tournir_Id, Ways_Cnt);
      if AbsSport_Id >=0 then
      begin
        ndSport:= Line.Root.NodeNew(nnSport);
        ndSport.ValueAsString:= Tournir_Name;
        ndSport.WriteAttributeString(attSport_Name, Sport_Name);
        ndSport.WriteAttributeInteger(attBookmaker_Id, Bookmaker_Id);
        ndSport.WriteAttributeInteger(attAbsSport_Id, AbsSport_Id);
        ndSport.WriteAttributeInteger(attSport_Id, Sport_Id);
        ndSport.WriteAttributeInteger(attTournir_Id, Tournir_Id);
        if Country_Id>0 then
          ndSport.WriteAttributeInteger(attCountry_Id, Country_Id);
        if trim(Tournir_Sex)<>'' then
          ndSport.WriteAttributeString(attSex, Tournir_Sex);
        ndSport.WriteAttributeInteger(attWays, Ways_Cnt);
        ndEvents:= ndSport.NodeNew(nnEvents);

        St:= CopyBE(St, '<table', '</table>');
        try
//          ExtractLineEvent(St);
          if ndSport.NodeFindOrCreate(nnEvents).NodeCount = 0 then
            ndSport.Delete;
        except
          ndSport.NodeNew(nnHtml).ValueAsString:= St;
        end;
      end
    end;
  finally
    sl.Free;
  end;
end;

begin
  Bookmaker_Id:= LeonBet_Id;
  ExtractTournir(Html);
  StatusBar.SimpleText:= '';
end;

end.
