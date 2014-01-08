unit uFrameClientEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, DB, GvCustomDataSet, GvListDataSet, GvNodeDataSet, GridsEh,
  DBAxisGridsEh, DBVertGridsEh, StdCtrls, Mask, DBCtrlsEh;

type
  TFrameClientEdit = class(TFrame)
    grBoxClientEdit: TGroupBox;
    dsClientEdit: TDataSource;
    tblNodeClient: TGvNodeDataSet;
    edLastName: TDBEditEh;
    edFirstName: TDBEditEh;
    edMidName: TDBEditEh;
    procedure tblNodeClientBeforeScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrameClientEdit.tblNodeClientBeforeScroll(DataSet: TDataSet);
begin
  Abort;
end;

end.
