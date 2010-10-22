program Test;

uses
  Dialogs,
  SysUtils,
  GvUDFStrUnicode;

{$R *.res}

//function Str_Length(CString: PChar): Integer; cdecl; external 'GvUDF.dll';

var
  St, Mask, St1: Widestring;
  len: Integer;
begin

  St:= UTF8Decode(AnsiToUtf8('5бы123.456'));
  len:= StrLenMM_Inner(St, 18);
  ShowMessage(Format('%u', [len]));

end.
