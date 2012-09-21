unit GvCloner;
interface

uses 
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, IniFiles, TypInfo;

type
  TUniqueReader = class(TReader)
    LastRead: TComponent;
    procedure ComponentRead(Component: TComponent);
    procedure SetNameUnique(Reader: TReader; Component: TComponent;
              var Name: string);
  end;

function DuplicateComponents(AComponent: TComponent): TComponent;

implementation

procedure TUniqueReader.ComponentRead(Component: TComponent);
begin
  LastRead := Component;
end;

// Задаем уникальное имя считываемому компоненту, например,
// "Panel2", если "Panel1" уже существует

procedure TUniqueReader.SetNameUnique(Reader: TReader;
                                      Component: TComponent;
                                      var Name: string);
var
  i: Integer;
  tempname: string;
begin
  i := 0;
  tempname := Name;
  while Component.Owner.FindComponent(Name) <> nil do
  begin
    Inc(i);
    Name := Format('%s%d', [tempname, i]);
  end;
end;

function DuplicateComponents(AComponent: TComponent): TComponent;

{procedure RegisterComponentClasses(
  AComponent: TComponent
  );
 var
  i: integer;
 begin
  RegisterClass(TPersistentClass(AComponent.ClassType));
  if AComponent is TWinControl then
  if TWinControl(AComponent).ControlCount > 0 then
  for i := 0 to
   (TWinControl(AComponent).ControlCount - 1) do

   RegisterComponentClasses(TWinControl(AComponent).Controls[i]);
 end;
}
var
  Stream: TMemoryStream;
  UniqueReader: TUniqueReader;
  Writer: TWriter;
begin
  result := nil;
  UniqueReader := nil;
  Writer := nil;

  Stream := TMemoryStream.Create;
  try
//    RegisterComponentClasses(AComponent);
    try
      Writer := TWriter.Create(Stream, 4096);
      Writer.Root := AComponent.Owner;
      Writer.WriteSignature;
      Writer.WriteComponent(AComponent);
      Writer.WriteListEnd;
    finally
      Writer.Free;
    end;

    Stream.Position := 0;
    try
      // создаем поток, перемещающий данные о компоненте в конструктор
      UniqueReader := TUniqueReader.Create(Stream, 4096);
      UniqueReader.OnSetName := UniqueReader.SetNameUnique;
      UniqueReader.LastRead := nil;

      if AComponent is TWinControl then
      // считываем компоненты и суб-компоненты
        UniqueReader.ReadComponents(TWinControl(AComponent).Owner,
          TWinControl(AComponent).Parent, UniqueReader.ComponentRead)
      else
      // читаем компоненты
        UniqueReader.ReadComponents(AComponent.Owner,
          nil, UniqueReader.ComponentRead);
      result := UniqueReader.LastRead;
    finally
      UniqueReader.Free;
    end;
  finally
    Stream.Free;
  end;
end;

end.
