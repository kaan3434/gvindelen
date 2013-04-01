unit GvVars;

interface

uses
  Classes, IniFiles, SysUtils, GvStr;

type
  TVarList = class(TStringList)
  private
    function  ExtractSingleValue(var Values: string): String;
  public
    procedure LoadSectionFromIniFile(IniFileName, Section: String; AreaName: String='');
    procedure LoadFromIniFile(IniFile: TIniFile; Section: String; AreaName: String='');
    procedure SaveSectionToIniFile(IniFileName, Section: String);
    procedure SaveToIniFile(IniFile: TIniFile; Section: String);
    procedure SaveToFile(const FileName: string); override;
    procedure LoadFromFile(const FileName: string); override;
    function  IsNull(VarName: String): Boolean;
    function  IsNotNull(VarName: String): Boolean;
    procedure FreeVars(VarNames: String);
    function  CopyAreas(AreaNames: String): TVarList;
    function  CutAreas(AreaNames: String): TVarList;
    procedure FreeAreas(AreaNames: String; ExcludeAreas: String='');
    procedure ClearAreas(AreaNames: String);
    function  GetValueInFormat(VarName, VFormat: String): String;
    function  GetAsString(VarName: String): String;
    function  ValueAsMacro(Value: String): String;
    function  GetAsMacro(VarName: String): String;
    procedure SetAsString(VarName, Value: String);
    function  GetAsFloat(const VarName: String): Extended;
    procedure SetAsFloat(const VarName: String; Value: Extended);
    function  GetAsInteger(const VarName: String): Longint;
    procedure SetAsInteger(const VarName: String; Value: Longint);
    function  GetAsBoolean(const VarName: String): Boolean;
    procedure SetAsBoolean(const VarName: String; Value: Boolean);
    function  GetAsDate(const VarName: String): TDateTime;
    procedure SetAsDate(const VarName: String; Value: TDateTime);
    function  GetAsDateTime(const VarName: String): TDateTime;
    procedure SetAsDateTime(const VarName: String; Value: TDateTime);
    function  GetAsList(VarNames: String): String;
    procedure SetAsList(VarNames, Values: String);
    function  FindVar(VarName: String; var Position: integer): Boolean;
    procedure RenameArea(OldName,NewName: String);
    procedure UnpackArea(AreaName,Values: String);
    procedure UnpackAreas(AreaNames: String);
    procedure VarValueToArray(VarName, PropName: String);
    procedure ArrayToVarValue(VarName, PropName: String);
    procedure AddStringsAsArea(AreaName: String; List: TStringList);
    procedure AddStrings(Strings: TStrings); override;
    procedure Inc(VarName: String; Value: LongInt=1);
    function  VarNamesToStr(Delimiter: string=','): String;
    procedure Push(VarName, Value: String; Delimiter: Char=';');
    function  Pop(VarName: String; KeyChars: String=';'): String;
    property AsMacro[VarName: String]: String
             read GetAsMacro;
    property AsString[VarName: String]: String
             read GetAsString write SetAsString; default;
    property AsFloat[const VarName: String]: Extended
             read GetAsFloat write SetAsFloat;
    property AsInteger[const VarName: String]: LongInt
             read GetAsInteger write SetAsInteger;
    property AsBoolean[const VarName: String]: Boolean
             read GetAsBoolean write SetAsBoolean;
    property AsDate[const VarName: String]: TDateTime
             read GetAsDate write SetAsDate;
    property AsDateTime[const VarName: String]: TDateTime
             read GetAsDateTime write SetAsDateTime;
    property AsList[VarNames: String]: String
             read GetAsList write SetAsList;
  end;

function ExtractName(var St: String): String;
procedure ExplodePair(St: String; var Name, Value: String);
function Area(VarName: String; Level:Integer = 1): String;
function SubArea(VarName:String; Level:Integer = 2): String;
function Prop(VarName: String; Level:Integer = 1):String;
//function IsVarName(Value: String): Boolean;
function IsInteger(Value: String): Boolean;
function IsFloat(Value: String): Boolean;
function VarNameLevel(VarName: String):integer;

function FillPattern(aPattern: string; aValues: TVarList;
  aClearUnknown: Boolean = true): String; overload;
function FillPattern(aPattern, aValues: string;
  aClearUnknown: Boolean = true): String; overload;

implementation

uses
  GvDtTm, StrUtils, GvMath;

function ExtractName(var St: String): String;
begin
  Result:= Trim(TakeFront4(St, '='));
  Delete(St,1,1);
end;

procedure ExplodePair(St: String; var Name, Value: String);
begin
  Name:= Trim(TakeFront4(St, '='));
  Delete(St,1,1);
  Value:= St;
end;

function VarNameLevel(VarName: String):integer;
begin
  result:= WordCount(VarName, '.');
end;

function Area(VarName: String; Level:Integer = 1): String;
begin
  result:= Copy(VarName, 1, NPos('.', VarName, Level));
  if LastChar(result)='.' then TakeLastChar(result);
end;

function SubArea(VarName:String; Level:Integer = 2): String;
begin
  result:= ExtractWord(Level, VarName, '.');
end;

function Prop(VarName: String; Level:Integer = 1):String;
begin
  result:= Copy(VarName, NPos('.', VarName, Level)+1, Length(VarName));
end;

{function IsVarName(Value: String): Boolean;
begin
  result:= true;
  result:= (Value<>'') and
           (SkipFront(Value,['A'..'Z','a'..'z','0'..'9','.','_','À'..'ß','à'..'ÿ'])='') and
           (Value[1] in ['A'..'Z','a'..'z','_','À'..'ß','à'..'ÿ']);
end;
}
function IsInteger(Value: String): Boolean;
var
  V, Cd: Integer;
begin
  Value:= TrimLeft(Value);
  if Value<>'' then
  begin
    Val(Value, V, Cd);
    result:= Cd=0;
  end
  else
    result:= false;
end;

function IsFloat(Value: String): Boolean;
begin
  Value:= TrimLeft(Value);
  result:= (Value<>'') and (SkipFront(Value, '0123456789-.+eE')='');
end;

//------------------------------------------------------------

procedure TVarList.LoadSectionFromIniFile(IniFileName, Section: String; AreaName: String='');
var
  sl: TStringList;
  St,Nm: String;
  i: Integer;
begin
  sl:=  TStringList.Create;
  try
    sl.LoadFromFile(IniFileName);
    repeat
      St:= UpperCase(sl.Text);
      sl.Text:= Copy(sl.Text, Pos('['+UpperCase(Section)+']', St), Length(St));
      if sl.Count=0 then Exit;
      if UpperCase(Trim(sl[0]))='['+UpperCase(Section)+']' then
        Break
      else
        sl.Delete(0);
    until false;
    if sl.Count=0 then Exit;
    sl.Delete(0);
    For i:= 0 to sl.Count-1 do
    begin
      st:= sl[i];
      if st='' then continue;
      if st[1]=';' then continue;
      if st[1]='[' then break;
      Nm:= Trim(TakeFront4(St, '='));
      if AreaName<>'' then
        Nm:= AreaName+'.'+Nm;
      AsString[Nm]:=Trim(Copy(St,2, Length(st)));
    end;
  finally
    sl.Free;
  end;
end;

procedure TVarList.LoadFromIniFile(IniFile: TIniFile; Section: String;
  AreaName: String='');
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  IniFile.ReadSectionValues(Section, sl);
  AddStringsAsArea(AreaName, sl);
  sl.Free;
end;

procedure TVarList.SaveSectionToIniFile(IniFileName, Section: String);
var
  Ini: TIniFile;
begin
  Ini:= TIniFile.Create(IniFileName);
  try
    SaveToIniFile(Ini, Section);
  finally
    Ini.Free;
  end;
end;

procedure TVarList.SaveToIniFile(IniFile: TIniFile; Section: String);
var
  i: Integer;
  Name, Value: String;
begin
  For i:= 0 to Count-1 do
  begin
    Value:= Strings[i];
    Name:= GvVars.ExtractName(Value);
    IniFile.WriteString(Section, Name, Value);
  end;
end;

procedure TVarList.SaveToFile(const FileName: string);
begin
  ForceDirectories(ExtractFilePath(FileName));
  inherited;
end;


procedure TVarList.LoadFromFile(const FileName: String);
var
  sl: TStringList;
  i: integer;
begin
  sl:= TStringList.Create;
  sl.LoadFromFile(FileName);
  For i:= sl.count-1 downto 0 do
  begin
    sl[i]:= trim(sl[i]);
    if sl[i]='' then sl.Delete(i);
  end;
  AddStrings(sl);
  sl.Free;
end;

function TVarList.FindVar(VarName: String; var Position: integer): Boolean;
var
  TPos,LPos: Integer;
  FindedName: String;
begin
  VarName:= AnsiUpperCase(VarName);
  if Count=0 then
  begin
    result:= false;
    Position:= 0;
    Exit;
  end;
  LPos:= 0;
  Position:= LPos;
  FindedName:= Names[Position];
  result:= FindedName=VarName;
  if FindedName>=VarName then exit;
  TPos:= Count-1;
  Position:= TPos;
  FindedName:= Names[Position];
  result:= FindedName=VarName;
  if FindedName=VarName then exit;
  if FindedName<VarName then begin System.Inc(Position); exit; end;
  while LPos+1<>TPos do
  begin
    Position:= (LPos+TPos) div 2;
    FindedName:= Names[Position];
    result:= FindedName=VarName;
    if result then exit;
    if FindedName>VarName then
      TPos:= Position
    else
      LPos:= Position;
  end;
  Position:= LPos;
  FindedName:= Names[Position];
  result:= FindedName=VarName;
  if FindedName>=VarName  then exit;
  Position:=TPos;
  FindedName:= Names[Position];
  result:= FindedName=VarName;
  if FindedName>=VarName then exit;
end;

function TVarList.IsNull(VarName: String): Boolean;
var
  Pos: Integer;
begin
  result:= (Not FindVar(VarName, Pos)) or (AsString[VarName]='');
end;

function TVarList.IsNotNull(VarName: String): Boolean;
begin
  result:= AsString[VarName]<>'';
end;

procedure TVarList.Push(VarName, Value: String; Delimiter: Char=';');
var
  St: String;
begin
  St:= GetAsString(VarName);
  if St <> '' then St:= St+Delimiter;
  SetAsString(VarName, St+Value);
end;

function  TVarList.Pop(VarName: String; KeyChars: String=';'): String;
var
  St: String;
begin
  St:= GetAsString(VarName);
  result:= TakeBack5(St, KeyChars);
  SetAsString(VarName, St);
end;

function TVarList.GetAsString(VarName: String): String;
var
  Position: integer;
begin
  VarName:= AnsiUpperCase(VarName);
  if FindVar(VarName, Position) then
  begin
    result:=  Strings[Position];
    System.Delete(result,1,Pos('=', Result));
  end
  else
    result:= '';
end;

function TVarList.VarNamesToStr(Delimiter: string=','): String;
var
  i: Integer;
begin
  result:= '';
  For i:= 1 to Count do
  begin
    result:= result+Names[i]+Delimiter
  end;
end;


function TVarList.GetValueInFormat(VarName, VFormat: String): String;
var
  FmtCh: Char;
  ChPos: Integer;
begin
  result:= '';
  if IsNull(VarName) then Exit;
  if VFormat='' then VFormat:= '%s';
  FmtCh:= ExtractFormatChar(VFormat, ChPos);
  if (FmtCh='Y') then vFormat[ChPos]:= 'S';
  Case FmtCh of
    'S','Y': result:= Format(VFormat, [GetAsString(VarName)]);
    'D','U': result:= Format(VFormat, [GetAsInteger(VarName)])
  else
    result:= Format(VFormat, [GetAsFloat(VarName)]);
  end;
end;

function TVarList.ValueAsMacro(Value: String): String;
var
  VFormat, VName:String;
  St1: String;
begin
  Result:= Value;
  while (Pos('[',Result)<>0) and (Pos(']',Result)<>0) do
  begin
    St1:= TakeFront5(Result, ']');
    VFormat:= TakeBack5(St1, '[');
    VName:= TakeFront4(VFormat, '%');
    Result:= St1+GetValueInFormat(VName,VFormat)+Result;
  end;
end;

function TVarList.GetAsMacro(VarName: String): String;
begin
  Result:= GetAsString(ValueAsMacro(VarName));
end;

procedure TVarList.SetAsString(VarName, Value: String);
var
  Position: integer;
begin
  VarName:= AnsiUpperCase(VarName);
  if FindVar(VarName, Position) then
    Strings[Position]:= VarName+'='+Value
  else
    Insert(Position, VarName+'='+Value);
end;

function TVarList.GetAsFloat(const VarName: String): Extended;
var
  St: String;
begin
  St:= Trim(AsString[VarName]);
  if St <> '' then result:= StrToFloat(St) else result:= 0;
end;

procedure TVarList.SetAsFloat(const VarName: String; Value: Extended);
begin
  AsString[VarName]:= FloatToStr(Value);
end;

function TVarList.GetAsDate(const VarName: String): TDateTime;
var
  St: String;
begin
  St:= Trim(AsString[VarName]);
  if St <> '' then result:= StrToDate(St) else result:= 0;
end;

procedure TVarList.SetAsDate(const VarName: String; Value: TDateTime);
begin
  AsString[VarName]:= DateToStr(Value);
end;

function TVarList.GetAsDateTime(const VarName: String): TDateTime;
var
  St: String;
begin
  St:= AsString[VarName];
  if St <> '' then result:= DtTmToDateTime(St) else result:= 0;
end;

procedure TVarList.SetAsDateTime(const VarName: String; Value: TDateTime);
begin
  AsString[VarName]:= DateTimeToDtTm(Value);
end;

function TVarList.GetAsInteger(const VarName: String): Longint;
var
  St: String;
begin
  St:= AsString[VarName];
  if St <> '' then result:= StrToInt(St) else result:= 0;
end;

procedure TVarList.SetAsInteger(const VarName: String; Value: Longint);
begin
  AsString[VarName]:= IntToStr(Value);
end;

function TVarList.GetAsList(VarNames: String): String;
begin
  Result:= '';
  While VarNames<>'' do
    Result:= Result+AsString[TakeFront5(VarNames, ',')]+',';
  if Result<>'' then TakeLastChar(Result);
end;

procedure TVarList.SetAsList(VarNames, Values: String);
begin
  While VarNames<>'' do
    Asstring[TakeFront5(VarNames, ',;')]:= TakeFront5(Values, ',;');
end;

procedure TVarList.Inc(VarName: String; Value: LongInt=1);
begin
  AsInteger[VarName]:= AsInteger[VarName]+Value;
end;

function TVarList.GetAsBoolean(const VarName: String): Boolean;
var
  St: String;
begin
  St:= Trim(AsString[VarName]);
  result:= (St<>'0') and (St<>'');
end;

procedure TVarList.SetAsBoolean(const VarName: String; Value: Boolean);
begin
  AsInteger[VarName]:= Byte(Value);
end;

procedure TVarList.FreeVars(VarNames: String);
var
  VarName: String;
  Position: Integer;
begin
  while VarNames<>'' do
  begin
    VarName:= TakeFront5(VarNames, ',; ');
    if FindVar(VarName, Position) then Delete(Position);
  end;
end;

function TVarList.CopyAreas(AreaNames: String): TVarList;
var
  AreaName, FrontMask, BackMask, St, Value, Name: String;
  Pos, LenAreaName: integer;
begin
  AreaNames:= AnsiUpperCase(AreaNames);
  result:= TVarList.Create;
  while AreaNames<> '' do
  begin
    AreaName:= TakeFront5(AreaNames, ';, ');
    if System.Pos('*', AreaName)=0 then
    begin
      FrontMask:= AreaName;
      BackMask:= '';
    end
    else
    begin
      FrontMask:= CopyFront4(AreaName, '*');
      BackMask:= CopyBack4(AreaName, '*');
    end;
    LenAreaName:= Length(FrontMask);
    FindVar(FrontMask+'/', Pos);
    while Pos > 0 do
    begin
      Dec(Pos);
      St:= Strings[Pos];
      ExplodePair(St, Name, Value);
      if Copy(Name, 1, LenAreaName)<FrontMask then break;
      if (BackMask<>'') And not (IsWild(Name,FrontMask+'*'+BackMask, true)) then continue;
      result.Add(St);
    end;
  end;
end;

function TVarList.CutAreas(AreaNames: String): TVarList;
var
  AreaName, St, StName: String;
  Pos, LenAreaName: integer;
begin
  AreaNames:= AnsiUpperCase(AreaNames);
  result:= TVarList.Create;
  while AreaNames<> '' do
  begin
    AreaName:= TakeFront5(AreaNames, ';, ');
    Pos:= Count-1;
    LenAreaName:= Length(AreaName);
    while Pos >= 0 do
    begin
      St:= Strings[Pos];
      StName:= Copy(St, 1, LenAreaName);
      if StName<AreaName then break;
      if (StName=AreaName) and (St[LenAreaName+1] in ['.','=',#32]) then
      begin
        result.Add(St);
        Delete(Pos)
      end;
      Dec(Pos);
    end;
  end;
end;

procedure TVarList.ClearAreas(AreaNames: String);
var
  AreaName, St, StName: String;
  Pos, LenAreaName: integer;
begin
  AreaNames:= AnsiUpperCase(AreaNames);
  while AreaNames<> '' do
  begin
    AreaName:= TakeFront5(AreaNames, ';, ');
    Pos:= Count-1;
    LenAreaName:= Length(AreaName);
    while Pos >= 0 do
    begin
      St:= Strings[Pos];
      StName:= Copy(St, 1, LenAreaName);
      if StName<AreaName then break;
      if (StName=AreaName) and (St[LenAreaName+1] in ['.','=',#32]) then
        Strings[Pos]:= GvVars.ExtractName(St)+'=';
      Dec(Pos);
    end;
  end;
end;

procedure TVarList.FreeAreas(AreaNames: String; ExcludeAreas: String='');
var
  vl: TVarList;
begin
  if ExcludeAreas<>'' then
  begin
    vl:= CutAreas(ExcludeAreas);
    CutAreas(AreaNames).Free;
    AddStrings(vl);
    vl.Free;
  end
  else
    CutAreas(AreaNames).Free;
end;

procedure TVarList.RenameArea(OldName,NewName: String);
var
  i, LenOldName: Integer;
  St: String;
  Cutted: TStringList;
begin
  Cutted:= CutAreas(OldName);
  NewName:= AnsiUpperCase(NewName);
  LenOldName:= Length(OldName);
  for i:= 0 to Cutted.Count-1 do
  begin
    St:= Cutted[i];
    System.Delete(St, 1, LenOldName);
    Cutted[i]:= CopyFront4(NewName, '*')+St;
  end;
  AddStrings(Cutted);
  Cutted.Free;
end;

function TVarList.ExtractSingleValue(var Values: string): String;
begin
  if FirstChar(Values) = '"' then
  begin
    TakeFirstChar(Values);
    Result:= TakeFront5(Values, '"');
    Result:= StringReplace(Result, '~','"', [rfReplaceAll]);
  end
  else
  if FirstChar(Values) = '{' then
  begin
    TakeFirstChar(Values);
    Result:=TakeFront5(Values, '}');
  end
  else Result:= TakeFront4(Values, ',');
  if Values<>'' then System.Delete(Values,1,1);
end;

procedure TVarList.UnpackArea(AreaName,Values: String);
var
  PropName,ResultValue,Value: String;
  FChar: Char;
  ValueCnt: Integer;
begin
  Values:= trim(Values);
  if (Pos('=',Values)=0) or (Values[1]='"') then
    AsString[AreaName]:= Values
  else
  begin
    while Values<>'' do
    begin
      PropName:= GvVars.ExtractName(Values);
      ResultValue:='';
      ValueCnt:= 0;
      while (Values<>'') and (FirstChar(Values)<>#32) do
      begin
        system.Inc(ValueCnt);
        FChar:= FirstChar(Values);
        if FChar = '"' then
        begin
          TakeFirstChar(Values);
          Value:= TakeFront5(Values, '"');
        end
        else
        if FChar = '{' then
        begin
          TakeFirstChar(Values);
          Value:=TakeFront5(Values, '}');
        end
        else Value:= TakeFront4(Values);
        Values:= Trim(Values);
        if (FirstChar(Values)<>',') and (ValueCnt=1) then
        begin
          ResultValue:= Value+',';
          break;
        end
        else
        if FChar='"' then
          ResultValue:=ResultValue+'"'+Value+'",'
        else
        if FChar='{' then
          ResultValue:= ResultValue+'{'+Value+'},'
        else
          ResultValue:= ResultValue+Value+',';
      end;
      TakeLastChar(ResultValue);
      AsString[AreaName+'.'+PropName]:= ResultValue;
    end;
    FreeVars(AreaName);
  end;
end;

procedure TVarList.AddStrings(Strings: TStrings);
var
  i: Integer;
  St, Name: String;
begin
  For i:= 0 to Strings.Count-1 do
  begin
    St:= Strings[i];
    Name:= GvVars.ExtractName(St);
    AsString[Name]:= St;
  end;
end;

procedure TVarList.AddStringsAsArea(AreaName: String; List: TStringList);
var
  i: Integer;
  PropName, St: String;
begin
  AreaName:= AnsiUpperCase(AreaName);
  For i:= 0 to List.Count-1 do
  begin
    St:= List[i];
    if AreaName='' then
      PropName:= GvVars.ExtractName(St)
    else
      PropName:= AreaName+'.'+GvVars.ExtractName(St);
    AsString[PropName]:= St;
  end;
end;

procedure TVarList.VarValueToArray(VarName,PropName: String);
var
  VarCount: Integer;
  SubVarName, VarValue: String;
begin
  VarValue:= AsString[VarName];
  VarCount:= AsInteger[VarName+'.Count'];
  while VarValue<>'' do
  begin
    System.Inc(VarCount);
    AsInteger[VarName+'.Count']:= VarCount;
    SubVarName:= VarName+'.'+IntToStr(VarCount)+'.'+PropName;
    AsString[SubVarName]:= ExtractSingleValue(VarValue);
  end;
end;

procedure TVarList.ArrayToVarValue(VarName, PropName: String);
var
  i, VarCount: Integer;
  Value, ResultValue: String;
begin
  ResultValue:= '';
  VarCount:= AsInteger[VarName+'.Count'];
  For i:= 1 to VarCount do
  begin
    Value:= AsString[VarName+'.'+IntToStr(i)+'.'+PropName];
    Value:= StringReplace(Value, '"', '~', [rfReplaceAll]);
    if (Pos('^', Value)<>0) Or (Pos('&', Value)<>0) Or (Pos('=', Value)<>0) Or
       (Pos('>', Value)<>0) Or (Pos('<', Value)<>0) Or (Pos(';', Value)<>0) Then
      Value:= '{'+Value+'}'
    else
    if (Pos(',', Value)<>0) Or (Pos(#32, Value)<>0) then
      Value:= '"'+Value+'"';
    ResultValue:= ResultValue+Value+',';
  end;
  if LastChar(Value)=',' then TakeLastChar(Value);
  AsString[VarName]:= Value;
end;

procedure TVarList.UnpackAreas(AreaNames: String);
var
  sl: TStringList;
  St, VarName, PropName, AreaName: String;
  i: Integer;
begin
  sl:= CopyAreas(AreaNames);
  For i:= 0 to sl.Count-1 do
  begin
    St:= sl[i];
    VarName:= GvVars.ExtractName(St);
    AsString[VarName]:= St;
    PropName:= Prop(VarName);
    if IsInteger(PropName) then
    begin
      AreaName:= VarName;
      TakeBack5(AreaName, '.');
      AsInteger[AreaName+'.Count']:= MaxInt(AsInteger[AreaName+'.Count'], StrToInt(PropName));
    end;
    UnpackArea(VarName, St);
  end;
  sl.Free;
end;

function FillPattern(aPattern: string; aValues: TVarList;
  aClearUnknown: Boolean = true): String; overload;
var
  i: Integer;
begin
  Result:= aPattern;
  for i:= 0 to aValues.Count-1 do
    Result:= ReplaceAll(Result, '['+aValues.Names[i]+']', aValues.ValueFromIndex[i]);
  if aClearUnknown then
    Result:= DeleteAllBE(Result, '[', ']');
end;

function FillPattern(aPattern, aValues: string;
  aClearUnknown: Boolean = true): String; overload;
var
  vl: TVarList;
begin
  vl:= TVarList.Create;
  try
    vl.Text:= aValues;
    Result:= FillPattern(aPattern, vl, aClearUnknown);
  finally
    vl.Free;
  end;
end;

end.
