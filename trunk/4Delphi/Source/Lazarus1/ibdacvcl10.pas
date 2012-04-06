unit ibdacvcl10; 

interface

uses
  IBCConnectForm, IbDacVcl, LazarusPackageIntf; 

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('ibdacvcl10', @Register); 
end.
