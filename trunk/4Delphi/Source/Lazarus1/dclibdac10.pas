unit dclibdac10; 

interface

uses
  IBCReg, IBCDesign, IBCAlerterEditor, IBCConnectionEditor, 
    IBCTransactionEditor, IBCQueryEditor, IBCSQLEditor, IBCTableEditor, 
    IBCTableSQLFrame, IBCStoredProcEditor, IBCParamsFrame, IBCSPCallFrame, 
    IBCUpdateSQLEditor, IBCSQLGeneratorFrame, IBCDesignUtils, 
    LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('IBCReg', @IBCReg.Register); 
  RegisterUnit('IBCDesign', @IBCDesign.Register); 
end; 

initialization
  RegisterPackage('dclibdac10', @Register); 
end.
