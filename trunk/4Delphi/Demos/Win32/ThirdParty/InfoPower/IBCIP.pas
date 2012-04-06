
//////////////////////////////////////////////////
//  Interbase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  InfoPower compatible components
//  This module contains classes for Woll2Woll InfoPower compatibility
//////////////////////////////////////////////////

unit IBCIP;

interface

uses
  SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  DB,
  dialogs,
  wwFilter,
  wwStr,
  wwSystem,
  wwTable,
  wwTypes,
  IBC,
  IbDacVcl;

type

{ TwwIBCQuery }

  TwwIBCQuery = class (TIBCQuery)
  private
    FControlType: TStrings;
    FPictureMasks: TStrings;
    FUsePictureMask: boolean;
    FOnInvalidValue: TwwInvalidValueEvent;

    function GetControlType: TStrings;
    procedure SetControlType(Sel: TStrings);
    function GetPictureMasks: TStrings;
    procedure SetPictureMasks(Sel: TStrings);

  protected
    procedure DoBeforePost; override; { For picture support }

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property ControlType: TStrings read GetControlType write SetControltype;
    property PictureMasks: TStrings read GetPictureMasks write SetPictureMasks;
    property ValidateWithMask: boolean read FUsePictureMask write FUsePictureMask;
    property OnInvalidValue: TwwInvalidValueEvent read FOnInvalidValue write FOnInvalidValue;
  end;

{ TwwIBCTable }

  TwwIBCTable = class (TIBCTable)
  private
    FControlType: TStrings;
    FPictureMasks: TStrings;
    FUsePictureMask: boolean;
    FOnInvalidValue: TwwInvalidValueEvent;

    function GetControlType: TStrings;
    procedure SetControlType(Sel: TStrings);
    function GetPictureMasks: TStrings;
    procedure SetPictureMasks(Sel: TStrings);

  protected
    procedure DoBeforePost; override; { For picture support }

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property ControlType: TStrings read GetControlType write SetControltype;
    property PictureMasks: TStrings read GetPictureMasks write SetPictureMasks;
    property ValidateWithMask: boolean read FUsePictureMask write FUsePictureMask;
    property OnInvalidValue: TwwInvalidValueEvent read FOnInvalidValue write FOnInvalidValue;
  end;

{ TwwIBCStoredProc }

  TwwIBCStoredProc = class (TIBCStoredProc)
  private
    FControlType: TStrings;
    FPictureMasks: TStrings;
    FUsePictureMask: boolean;
    FOnInvalidValue: TwwInvalidValueEvent;

    function GetControlType: TStrings;
    procedure SetControlType(Sel: TStrings);
    function GetPictureMasks: TStrings;
    procedure SetPictureMasks(Sel: TStrings);

  protected
    procedure DoBeforePost; override; { For picture support }

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property ControlType: TStrings read GetControlType write SetControltype;
    property PictureMasks: TStrings read GetPictureMasks write SetPictureMasks;
    property ValidateWithMask: boolean read FUsePictureMask write FUsePictureMask;
    property OnInvalidValue: TwwInvalidValueEvent read FOnInvalidValue write FOnInvalidValue;
  end;

procedure Register;

implementation
uses
  wwCommon,
  dbConsts;

{ TwwIBCQuery }

constructor TwwIBCQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FControlType := TStringList.Create;
  FPictureMasks := TStringList.Create;
  FUsePictureMask := True;
end;

destructor TwwIBCQuery.Destroy;
begin
  FControlType.Free;
  FPictureMasks.Free;
  FPictureMasks := nil;

  inherited Destroy;
end;

function TwwIBCQuery.GetControlType: TStrings;
begin
  Result := FControlType;
end;

procedure TwwIBCQuery.SetControlType(Sel: TStrings);
begin
  FControlType.Assign(Sel);
end;

function TwwIBCQuery.GetPictureMasks: TStrings;
begin
  Result := FPictureMasks
end;

procedure TwwIBCQuery.SetPictureMasks(Sel: TStrings);
begin
  FPictureMasks.Assign(Sel);
end;

procedure TwwIBCQuery.DoBeforePost;
begin
  inherited DoBeforePost;

  if FUsePictureMask then
    wwValidatePictureFields(Self, FOnInvalidValue);
end;

{ TwwIBCTable }

constructor TwwIBCTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FControlType := TStringList.Create;
  FPictureMasks := TStringList.Create;
  FUsePictureMask := True;
end;

destructor TwwIBCTable.Destroy;
begin
  FControlType.Free;
  FPictureMasks.Free;
  FPictureMasks := nil;

  inherited Destroy;
end;

function TwwIBCTable.GetControlType: TStrings;
begin
  Result := FControlType;
end;

procedure TwwIBCTable.SetControlType(Sel: TStrings);
begin
  FControlType.Assign(Sel);
end;

function TwwIBCTable.GetPictureMasks: TStrings;
begin
  Result := FPictureMasks
end;

procedure TwwIBCTable.SetPictureMasks(Sel: TStrings);
begin
  FPictureMasks.Assign(Sel);
end;

procedure TwwIBCTable.DoBeforePost;
begin
  inherited DoBeforePost;

  if FUsePictureMask then
    wwValidatePictureFields(Self, FOnInvalidValue);
end;

{ TwwIBCStoredProc }

constructor TwwIBCStoredProc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FControlType := TStringList.Create;
  FPictureMasks := TStringList.Create;
  FUsePictureMask := True;
end;

destructor TwwIBCStoredProc.Destroy;
begin
  FControlType.Free;
  FPictureMasks.Free;
  FPictureMasks := nil;

  inherited Destroy;
end;

function TwwIBCStoredProc.GetControlType: TStrings;
begin
  Result := FControlType;
end;

procedure TwwIBCStoredProc.SetControlType(Sel: TStrings);
begin
  FControlType.Assign(Sel);
end;

function TwwIBCStoredProc.GetPictureMasks: TStrings;
begin
  Result := FPictureMasks
end;

procedure TwwIBCStoredProc.SetPictureMasks(Sel: TStrings);
begin
  FPictureMasks.Assign(Sel);
end;

procedure TwwIBCStoredProc.DoBeforePost;
begin
  inherited DoBeforePost;

  if FUsePictureMask then
    wwValidatePictureFields(Self, FOnInvalidValue);
end;

procedure Register;
begin
  RegisterComponents('Interbase Access', [TwwIBCQuery]);
  RegisterComponents('Interbase Access', [TwwIBCTable]);
  RegisterComponents('Interbase Access', [TwwIBCStoredProc]);
end;

{
For IP3

wwCommon.pas

Function wwDataSet(dataSet : TDataSet): boolean;
begin
   if dataset=nil then result:= false
   else
     result:=
     wwIsClass(dataset.classType, 'TwwTable') or
     wwIsClass(dataset.classType, 'TwwQuery') or
     wwIsClass(dataset.classType, 'TwwQBE') or
     wwIsClass(dataset.classType, 'TwwStoredProc') or
     wwIsClass(dataset.classType, 'TwwClientDataSet')
   // IBDAC components
     or
     wwIsClass(dataset.classType, 'TwwIBCQuery') or
     wwIsClass(dataset.classType, 'TwwIBCTable') or
     wwIsClass(dataset.classType, 'TwwIBCStoredProc');
end;
}

end.