{$I DacDemo.inc}

unit ParamType;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids, IbDacVcl,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DB, DBAccess, IBC, DemoFrame;

type
  TParamTypeForm = class(TForm)
    lbParams: TListBox;
    btClose: TButton;
    rgTypes: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    edParamValue: TEdit;
    lbValue: TLabel;
    Label3: TLabel;
    lbParameterType: TLabel;
    procedure btCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbParamsClick(Sender: TObject);
    procedure rgTypesClick(Sender: TObject);
    procedure edParamValueExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Params: TParams;

  end;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TParamTypeForm.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TParamTypeForm.FormShow(Sender: TObject);
var
  i:integer;
begin
  if Params <> nil then begin
    lbParams.Items.Clear;
    for i := 0 to Params.Count - 1 do
      lbParams.Items.Add(Params[i].Name);
    if Params.Count > 0 then
      lbParams.ItemIndex:= 0;

    lbParamsClick(nil);
  end;
end;

procedure TParamTypeForm.lbParamsClick(Sender: TObject);
begin
  if lbParams.ItemIndex >= 0 then begin
    case Params[lbParams.ItemIndex].ParamType of
      ptUnknown: lbParameterType.Caption := 'Unknown';
      ptInput: lbParameterType.Caption := 'Input';
      ptOutput: lbParameterType.Caption := 'Output';
      ptInputOutput: lbParameterType.Caption := 'InputOutput';
      ptResult: lbParameterType.Caption := 'Result';
    end;

    edParamValue.Text := Params[lbParams.ItemIndex].AsString;


{    edParamValue.Enabled := Params[lbParams.ItemIndex].ParamType
      in [ptInput, ptInputOutput];
    lbValue.Enabled := edParamValue.Enabled;
    edParamValue.Text := Params[lbParams.ItemIndex].AsString;
 }
    case Params[lbParams.ItemIndex].DataType of
      ftString:
        rgTypes.ItemIndex:= 0;
      ftInteger:
        rgTypes.ItemIndex:= 1;
      ftFloat:
        rgTypes.ItemIndex:= 2;
      ftDate:
        rgTypes.ItemIndex:= 3;
    else
      rgTypes.ItemIndex:= -1;
    end;
  end;
end;

procedure TParamTypeForm.rgTypesClick(Sender: TObject);
var
  DataType: TFieldType;
begin
  if lbParams.ItemIndex >= 0 then begin
    case rgTypes.ItemIndex of
      0: DataType:= ftString;
      1: DataType:= ftInteger;
      2: DataType:= ftFloat;
      3: DataType:= ftDate;
    else
      DataType:= ftUnknown;
    end;
    Params[lbParams.ItemIndex].DataType:= DataType;
  end;
end;

procedure TParamTypeForm.edParamValueExit(Sender: TObject);
begin
  Params[lbParams.ItemIndex].AsString := edParamValue.Text;
end;

{$IFDEF FPC}
initialization
  {$i ParamType.lrs}
{$ENDIF}

end.
