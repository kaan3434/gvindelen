{*******************************************************}
{                                                       }
{                       EhLib v4.2                      }
{    Register object that sort data in TpFIBDataset     }
{                                                       }
{      Copyright (c) 2006 by Alexandr A. Sal'nikov      }
{ e-mail: alexandr.salnikov@gmail.com                   }
{                                                       }
{*******************************************************}

{*******************************************************}
{ Add this unit to 'uses' clause of any unit of your    }
{ project to allow TDBGridEh to sort data in            }
{ TpFIBDataset automatically after sorting markers      }
{ will be changed.                                      }
{ TFIBDatasetFeaturesEh will sort data locally          }
{ using DoSort procedure of TpFIBDataset                }
{ [+] SortLocal                                         }
{ [+] FilterLocal                                       }
{ [+] SortServer                                        }
{ [+] FilterServer                                      }
{*******************************************************}

unit EhLibFIB;

{$I EhLib.Inc}

interface

uses
  Classes, SysUtils, DB, DbUtilsEh, DBGridEh, pFIBDataSet;

type
  TFIBDatasetFeaturesEh = class(TSQLDatasetFeaturesEh)
  public
    constructor Create; override;
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    procedure ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
  end;

implementation

function DateValueToIBSQLStringProc(DataSet: TDataSet; Value: Variant): String;
begin
  Result := '''' + FormatDateTime('MM"/"DD"/"YYYY', Value) + '''';
end;

constructor TFIBDatasetFeaturesEh.Create;
begin
  DateValueToSQLString := DateValueToIBSQLStringProc;
  SQLPropName := 'SelectSQL';
end;

procedure TFIBDatasetFeaturesEh.ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean);
var
  FLD:  array of TVarRec ;
  Sort: array of boolean;
  i, j: Integer;
  Grid: TCustomDBGridEh;
begin
  if not (Sender is TCustomDBGridEh) then Exit;
  Grid:= TCustomDBGridEh(Sender);
  if Grid.SortLocal then begin
    j:= Grid.SortMarkedColumns.Count;
    SetLength(FLD,  j);
    SetLength(Sort, j);
    for i:=0 to pred(j) do begin
      FLD[i].VInteger:= Grid.SortMarkedColumns[i].Field.Index;
      FLD[i].VType   := vtInteger;
      Sort[i]:= Grid.SortMarkedColumns[i].Title.SortMarker = smDownEh;
    end;
    TpFibDataset(Dataset).DoSort(FLD, Sort);
  end
  else
    ApplySortingForSQLBasedDataSet(Grid, TpFIBDataSet(DataSet), True, IsReopen, SQLPropName);
end;

procedure TFIBDatasetFeaturesEh.ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean);
var
  Grid: TDBGridEh;
begin
  if not (Sender is TCustomDBGridEh) then Exit;
  Grid:= TDBGridEh(Sender); 
  if Grid.STFilter.Local then begin
    DataSet.Filter:= GetExpressionAsFilterString(Grid, GetOneExpressionAsLocalFilterString, nil, False, True);
    DataSet.Filtered:= True;
  end
  else
    ApplyFilterSQLBasedDataSet(Grid, DataSet, DateValueToSQLString, IsReopen, SQLPropName);
end;

initialization
  RegisterDatasetFeaturesEh(TFIBDatasetFeaturesEh, TpFIBDataSet);
end.
