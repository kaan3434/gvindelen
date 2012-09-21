unit GvKbd;

interface

uses
  Classes, Windows;

procedure KeyReturn(Sender: TObject; var Key: Word; Shift: TShiftState);

procedure StoreSysKbd;

procedure RestoreSysKbd;

procedure SetRusKbd;

procedure SetEngKbd;


implementation

uses
  Controls, Messages;

var
  StoredSysKbd: HKL;

procedure KeyReturn(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_Return) then
    PostMessage(TWinControl(Sender).Handle,WM_KeyDown,VK_Tab,0);
end;

procedure StoreSysKbd;
begin
  StoredSysKbd:= GetKeyboardLayout(0);
end;

procedure RestoreSysKbd;
begin
  ActivateKeyboardLayout(StoredSysKbd, 0);
end;

procedure SetRusKbd;
begin
  ActivateKeyboardLayout(LoadKeyboardLayout('00000419', 0),0);
end;

procedure SetEngKbd;
begin
  ActivateKeyboardLayout(LoadKeyboardLayout('00000409', 0),0);
end;

initialization
  StoredSysKbd:= GetKeyboardLayout(0);
end.
