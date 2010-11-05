program Test;

uses
  Dialogs,
  SysUtils,
  GvUDFStr;

{$R *.res}

//function Str_Length(CString: PChar): Integer; cdecl; external 'GvUDF.dll';

var
  St, St1: PChar;
  f, t, l: Integer;
begin
  St:= 'Привет, Всем!';
  f:= 2; t:= 5;
  St1:= CopyFront_WithKey(St, ',');
  ShowMessage('"'+St1+'"');

end.
