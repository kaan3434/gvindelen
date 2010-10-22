unit uEstdInterfaces;

interface

uses
  MemTableDataEh, MemTableEh, udmEstd;

type
  IdmEstd = interface['{117CA37E-6DBA-470B-A092-B45F7411C566}']
    procedure LoadDocument(admEstd: TdmEstd; aDocumentLabel: WideString);
  end;

type
  IdmEstdNSI = interface['{4A55698C-B8CA-4396-896A-98BA7708A0E1}']
    procedure LoadObjTypes(aDataSet: TMemTableEh);
    procedure LoadKEIGroups(aKEIGroupDataSet: TMemTableEh);
    procedure LoadKEIs(aKEIDataSet: TMemTableEh);
  end;

var
  EstdDataModule: IdmEstd;
  EstdNSIDataModule: IdmEstdNSI;

implementation

end.
