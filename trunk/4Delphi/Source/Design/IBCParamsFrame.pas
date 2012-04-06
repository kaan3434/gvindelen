
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBDAC Params Frame
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCParamsFrame;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Classes, SysUtils, DB,
  CRFrame, CRTabEditor, DAParamsFrame, DBAccess;

type
  TIBCParamsFrame = class(TDAParamsFrame)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$IFNDEF FPC}
{$R IBCParamsFrame.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  IBC;

{ TIBCParamsFrame }

constructor TIBCParamsFrame.Create(AOwner: TComponent);
begin
  inherited;
  
  AddDataType('Unknown',    ftUnknown,    True,  False, False, '');
  AddDataType('String',     ftString,     False, True,  True,  '');
  AddDataType('WideString', ftWideString, False, True,  True,  '');
  AddDataType('Smallint',   ftSmallint,   True,  True,  False, '0');
  AddDataType('Integer',    ftInteger,    True,  True,  False, '0');
  AddDataType('LargeInt',   ftLargeInt,   True,  True,  False, '0');
  AddDataType('Float',      ftFloat,      True,  True,  False, '0');
  AddDataType('BCD',        ftBCD,        True,  True,  False, '0');
{$IFDEF VER6P}
  AddDataType('FMTBcd',     ftFMTBcd,     True,  True,  False, '0');
{$ENDIF}
  AddDataType('Date',       ftDate,       True,  True,  False, '');
  AddDataType('Time',       ftTime,       True,  True,  False, '');
  AddDataType('DateTime',   ftDateTime,   True,  True,  False, '');
  AddDataType('FixedChar',  ftFixedChar,  False, True,  True,  '');
  AddDataType('Blob',       ftBlob,       False, True,  False, '');
  AddDataType('Memo',       ftMemo,       False, True,  False, '');
{$IFDEF VER10P}
  AddDataType('WideMemo',   ftWideMemo,   False, True,  False, '');
{$ENDIF}
  AddDataType('Array',      ftArray,      False, False, True,  '');
  AddDataType('Boolean',    ftBoolean,    False, True,  True,  'False');

  AddParamType('Unknown', ptUnknown);
  AddParamType('IN', ptInput);
  AddParamType('OUT', ptOutput);
end;

end.
