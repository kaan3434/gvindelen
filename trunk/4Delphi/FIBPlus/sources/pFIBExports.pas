unit pFIBExports;

interface

{$I FIBPlus.inc}

 uses SysUtils,{$IFDEF D7+}Types,{$ELSE}Windows,{$ENDIF}Classes, pFIBInterfaces,FIBDatabase,FIBQuery,FIBDataSet,pFIBDataSet,pFIBQuery,
      StrUtil,pFIBDatabase;

 type




       TFIBStringer= class(TComponent, IFIBStringer)
       private
         function  FormatIdentifier(Dialect: Integer; const Value: string): string;
         procedure DispositionFromClause(const SQLText:string;var X,Y:integer);
         function  PosCh(aCh:Char; const s:string):integer;
         function  PosCh1(aCh:Char; const s:string; StartPos:integer):integer;
         function  PosCI(const Substr,Str:string):integer;
         function  EmptyStrings(SL:TStrings):boolean;
         function  EquelStrings(const s,s1:string; CaseSensitive:boolean):boolean;
         procedure DeleteEmptyStr(Src:TStrings);//
         procedure AllTables(const SQLText:string;aTables:TStrings; WithSP:boolean =False
           ;WithAliases:boolean =False
         );
         function WordCount(const S: string; const WordDelims: TCharSet): Integer;         
         function ExtractWord(Num:integer;const Str: string;const  WordDelims:TCharSet):string;
         function PosInRight(const substr,Str:string;BeginPos:integer):integer;
         function LastChar(const Str:string):Char;
         function TableByAlias(const SQLText,Alias:string):string;
         function  AliasForTable(const SQLText,TableName:string):string;

         function SetOrderClause(const SQLText,Order:string):string;
         function AddToMainWhereClause(const SQLText,Condition:string):string;

       end;

       TMetaDataExtractor=class(TComponent, IFIBMetaDataExtractor)
       private
          function DBPrimaryKeys(const TableName:string;Transaction:TObject):string;
       end;

       TFIBClassesExporter =class (TComponent, IFIBClassesExporter,IFIBStringer,IFIBMetaDataExtractor)
       private
         FStringer:TFIBStringer;
         FMetaDataExtractor:TMetaDataExtractor;
         function iGetStringer:IFIBStringer;
         function iGetMetaExtractor:IFIBMetaDataExtractor;


       public
         constructor Create(AOwner:TComponent); override;
         destructor  Destroy; override;
         property  Stringer:TFIBStringer read FStringer implements IFIBStringer;
         property  MetaDataExtractor:TMetaDataExtractor read FMetaDataExtractor implements IFIBMetaDataExtractor;
       end
       ;





implementation

uses SqlTxtRtns, pFIBDataInfo,IB_Services;

var  vFIBClassesExporter:TFIBClassesExporter;




{ TFIBClassesExporter }



constructor TFIBClassesExporter.Create(AOwner: TComponent);
begin
  inherited;
  FIBClassesExporter:=Self;
  FStringer:=TFIBStringer.Create(Self);
  FMetaDataExtractor:=TMetaDataExtractor.Create(Self);
end;

destructor TFIBClassesExporter.Destroy;
begin
  if Self= vFIBClassesExporter then
   vFIBClassesExporter:=nil;
  inherited;
end;


function TFIBClassesExporter.iGetMetaExtractor: IFIBMetaDataExtractor;
begin
 Result:=FMetaDataExtractor
end;


function TFIBClassesExporter.iGetStringer: IFIBStringer;
begin
 Result:=FStringer;
end;





procedure CreateExporter;
begin
{ if Application<>nil then}
 begin
   vFIBClassesExporter:=TFIBClassesExporter.Create(nil);
   with vFIBClassesExporter do
   begin
     Name:='FIBClassesExporter'
   end;
 end
end;

{ TFIBStringer }

function TFIBStringer.AddToMainWhereClause(const SQLText,
  Condition: string): string;
begin
  Result:=SqlTxtRtns.AddToWhereClause(SQLText,Condition)
end;

function TFIBStringer.AliasForTable(const SQLText,
  TableName: string): string;
begin
 Result:=SqlTxtRtns.AliasForTable(SQLText,TableName)
end;

procedure TFIBStringer.AllTables(const SQLText: string; aTables: TStrings;
  WithSP, WithAliases: boolean);
begin
  SqlTxtRtns.AllTables(SQLText,aTables,WithSP,WithAliases);
end;

procedure TFIBStringer.DeleteEmptyStr(Src: TStrings);
begin
 StrUtil.DeleteEmptyStr(Src);
end;

procedure TFIBStringer.DispositionFromClause(const SQLText:string;var X,Y:integer);
var
   p:TPoint;
begin
  p:=SqlTxtRtns.DispositionFrom(SQLText);
  X:=P.X;
  Y:=P.Y
end;

function TFIBStringer.EmptyStrings(SL: TStrings): boolean;
begin
 Result:=StrUtil.EmptyStrings(SL)
end;

function TFIBStringer.EquelStrings(const s, s1: string;
  CaseSensitive: boolean): boolean;
begin
 Result:=StrUtil.EquelStrings(s, s1,  CaseSensitive)
end;

function TFIBStringer.ExtractWord(Num: integer; const Str: string;
  const WordDelims: TCharSet): string;
begin
  Result:=StrUtil.ExtractWord(Num, Str,WordDelims)
end;

function TFIBStringer.FormatIdentifier(Dialect: Integer;
  const Value: string): string;
begin
  Result:=StrUtil.FormatIdentifier(Dialect,Value)
end;

function TFIBStringer.LastChar(const Str: string): Char;
begin
 Result:=StrUtil.LastChar(Str)
end;

function TFIBStringer.PosCh(aCh: Char; const s: string): integer;
begin
  Result:=StrUtil.PosCh(aCh,s)
end;

function TFIBStringer.PosCh1(aCh: Char; const s: string;
  StartPos: integer): integer;
begin
   Result:=StrUtil.PosCh1(aCh,s,StartPos)
end;

function TFIBStringer.PosCI(const Substr, Str: string): integer;
begin
 Result:=StrUtil.PosCI(Substr, Str)
end;

function TFIBStringer.PosInRight(const substr, Str: string;
  BeginPos: integer): integer;
begin
 Result:=StrUtil.PosInRight(substr, Str, BeginPos)
end;

function TFIBStringer.SetOrderClause(const SQLText, Order: string): string;
begin
 Result:=SqlTxtRtns.SetOrderClause(SQLText,Order)
end;

function TFIBStringer.TableByAlias(const SQLText, Alias: string): string;
begin
 Result:=SqlTxtRtns.TableByAlias(SQLText,Alias)
end;

function TFIBStringer.WordCount(const S: string;
  const WordDelims: TCharSet): Integer;
begin
 Result:=StrUtil.WordCount(S,WordDelims)
end;

{ TMetaDataExtractor }

function TMetaDataExtractor.DBPrimaryKeys(const TableName: string;
  Transaction: TObject): string;
begin
 Result:=pFIBDataInfo.DBPrimaryKeyFields(TableName,TFIBTransaction(Transaction))
end;

initialization

 CreateExporter;

finalization
 FIBClassesExporter:=nil;
 if vFIBClassesExporter<>nil then
  vFIBClassesExporter.Free
end.
