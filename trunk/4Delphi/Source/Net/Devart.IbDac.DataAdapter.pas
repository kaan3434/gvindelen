unit Devart.IbDac.DataAdapter;

interface

uses DB, System.Data.Common, System.Data, Devart.Dac.DataAdapter,
  Variants, System.ComponentModel;

type
  IBCDataAdapter = class (DADataAdapter)
  protected
    function CanLocateField(Field: TField): boolean; override;
    function GetItemType(Field: TField): System.Type; override;
    function GetItemValue(Field: TField): TObject; override;
    procedure SetItemValue(Field: TField; Value: TObject); override;
    function ItemToVariant(Field: TField; Value: TObject): Variant; override;

  published
    property DataSet;
  end;

implementation

uses Classes, SysUtils, MemDS, DBAccess, IBC;

function IBCDataAdapter.CanLocateField(Field: TField): boolean;
begin
  case Field.DataType of
    ftBlob, ftMemo, ftArray:
      Result := False;
  else
    Result := inherited CanLocateField(Field);
  end;
end;


function IBCDataAdapter.GetItemType(Field: TField): System.Type;
begin
  case Field.DataType of
    TFieldType(ftFixedWideChar): Result := typeof(String);
  else
    Result := inherited GetItemType(Field);
  end;
end;

function IBCDataAdapter.GetItemValue(Field: TField): TObject;
begin
  Result := inherited GetItemValue(Field);
end;

procedure IBCDataAdapter.SetItemValue(Field: TField; Value: TObject);
begin
  inherited SetItemValue(Field, Value);
end;

function IBCDataAdapter.ItemToVariant(Field: TField; Value: TObject): Variant;
begin
  Result := inherited ItemToVariant(Field, Value);
end;

end.
