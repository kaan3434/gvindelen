library GvUDF;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$R *.res}

uses
  GvUDFStrUnicode in 'GvUDFStrUnicode.pas',
  GvUDFMath in 'GvUDFMath.pas';

exports
  CopyFront_WithKey_UTF8,
  CopyFront_WithOutKey_UTF8,
  Copy_Start_End_UTF8,
  Copy_Between_UTF8,
  Recode_UTF8,
  CharCount_UTF8,
  EscapeString_UTF8,
  EscapeStringEx_UTF8,
  UnEscapeString_UTF8,
  UnEscapeStringEx_UTF8,
  StrLen_UTF8,
  StrPos_UTF8,
  StrLenMM_UTF8,
  ToFloat,
  RoundPrecision,
  FormatValue_UTF8;

begin
end.
