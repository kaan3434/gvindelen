unit GvColor;

interface

uses Graphics, Windows;

function Darker(Color:TColor; Percent:Byte):TColor;
function Dark25(Color:TColor):TColor;
function Dark50(Color:TColor):TColor;
function Dark75(Color:TColor):TColor;

function Lighter(Color:TColor; Percent:Byte):TColor;
function Light25(Color:TColor):TColor;
function Light50(Color:TColor):TColor;
function Light75(Color:TColor):TColor;

implementation

function Darker(Color:TColor; Percent:Byte):TColor;
var
  r,g,b:Byte;
begin
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r-muldiv(r,Percent,100);  //процент% уменьшени€ €ркости
  g:=g-muldiv(g,Percent,100);
  b:=b-muldiv(b,Percent,100);
  result:=RGB(r,g,b);  
end;  

function Lighter(Color:TColor; Percent:Byte):TColor;  
var  
  r,g,b:Byte;  
begin  
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r+muldiv(255-r,Percent,100); //процент% увеличени€ €ркости
  g:=g+muldiv(255-g,Percent,100);
  b:=b+muldiv(255-b,Percent,100);
  result:=RGB(r,g,b);
end;

function Dark25(Color:TColor):TColor;
begin
  Result := Darker(Color,25);
end;

function Dark50(Color:TColor):TColor;
begin
  Result := Darker(Color,50);
end;

function Dark75(Color:TColor):TColor;
begin
  Result := Darker(Color,75);
end;

function Light25(Color:TColor):TColor;
begin
  Result := Lighter(Color,25);
end;

function Light50(Color:TColor):TColor;
begin
  Result := Lighter(Color,50);
end;

function Light75(Color:TColor):TColor;
begin
  Result := Lighter(Color,75);
end;


end.
 