unit Unit1;

{$I EhLib.Inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, MemTableDataEh, Db, GridsEh, DBGridEh, MemTableEh,
{$IFDEF EH_LIB_7} XPMan, {$ENDIF}
  DBTables, DataDriverEh, StdCtrls, EhLibMTE, DBGridEhGrouping;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DataSource1: TDataSource;
    mtTable1: TMemTableEh;
    DBGridEh1: TDBGridEh;
    mtFish: TMemTableEh;
    mtFishSpeciesNo: TFloatField;
    mtFishCategory: TStringField;
    mtFishCommon_Name: TStringField;
    mtFishSpeciesName: TStringField;
    mtFishLengthcm: TFloatField;
    mtFishLength_In: TFloatField;
    mtFishNotes: TMemoField;
    mtFishGraphic: TGraphicField;
    dsFish: TDataSource;
    gridFish: TDBGridEh;
    ddFish: TDataSetDriverEh;
    tFish: TTable;
    procedure Button1Click(Sender: TObject);
    procedure DBGridEh1ActiveGroupingStructChanged(Sender: TCustomDBGridEh);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//  gridFish.DataGrouping.Active := not gridFish.DataGrouping.Active;
  gridFish.DataGrouping.GroupLevels[0].ParentFont := True; 
end;

procedure TForm1.DBGridEh1ActiveGroupingStructChanged(Sender: TCustomDBGridEh);
var
  BaseColor, NewColor: TColor;
  i: Integer;
begin
  BaseColor := clGradientInactiveCaption;
  for I := 0 to DBGridEh1.DataGrouping.ActiveGroupLevelsCount - 1 do
    DBGridEh1.DataGrouping.ActiveGroupLevels[i].Color :=
      ApproximateColor(BaseColor, DBGridEh1.Color,
        Round(I / DBGridEh1.DataGrouping.ActiveGroupLevelsCount * 255));
end;

initialization
  DBGridEhDefaultStyle.IsDrawFocusRect := False;
  DefFontData.Name := 'Microsoft Sans Serif';
end.
