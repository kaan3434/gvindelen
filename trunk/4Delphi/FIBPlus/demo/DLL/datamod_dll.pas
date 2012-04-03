{$I fibplus_dll.inc}
unit datamod_dll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase;

type
  TdmMain = class(TDataModule)
    trReadDLL: TpFIBTransaction;
    trWriteDLL: TpFIBTransaction;
    dtCountry: TpFIBDataSet;
    dtCountryID: TFIBIntegerField;
    dtCountryNAME: TFIBStringField;
    dtCountryCAPITAL: TFIBStringField;
    dtCountryCONTINENT: TFIBStringField;
    dtCountryAREA: TFIBFloatField;
    dtCountryPOPULATION: TFIBFloatField;
    dsCountry: TDataSource;
    dbDemoDLL: TpFIBDatabase;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation

{$R *.DFM}

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
{$IFDEF BUILD_EXE}
  dbDemoDLL.Connected := True;
{$ENDIF}
end;

end.



