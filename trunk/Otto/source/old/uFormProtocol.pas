unit uFormProtocol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, FIBDatabase, pFIBDatabase, FIBDataSet,
  pFIBDataSet, GridsEh, DBGridEh, PrnDbgeh, ImgList, PngImageList,
  DBGridEhGrouping;

type
  TFormProtocol = class(TForm)
    grdProtocol: TDBGridEh;
    qryProtocol: TpFIBDataSet;
    dsProtocol: TDataSource;
    prnGridProtocol: TPrintDBGridEh;
    trnRead: TpFIBTransaction;
    imgListNotifyClass: TPngImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FMessageId: Integer;
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; aMessageId: Integer);
    property MessageId: Integer read FMessageId write FMessageId;
  end;

implementation

uses
  udmOtto;

{$R *.dfm}

constructor TFormProtocol.Create(AOwner: TComponent; aMessageId: Integer);
begin
  inherited Create(AOwner);
  FMessageId:= aMessageId;
  Caption:= 'Протокол: ' + trnRead.DefaultDatabase.QueryValue(
    'select m.file_name from messages m where m.message_id = :message_id',
    0, [aMessageId], trnRead);
  qryProtocol.OpenWP([aMessageId]);
end;

procedure TFormProtocol.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

end.
