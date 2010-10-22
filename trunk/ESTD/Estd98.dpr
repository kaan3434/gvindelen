program Estd98;

uses
  Forms,
  uEstd98 in 'uEstd98.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
