unit about;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  jpeg, ExtCtrls, StdCtrls;

type
  TfrmAbout = class(TForm)
    Bevel1: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label3: TLabel;
    Label1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Label8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

uses ShellAPI;

{$R *.DFM}

procedure TfrmAbout.Label8Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar((Sender as TLabel).Caption), nil, nil, 0);
end;

end.
