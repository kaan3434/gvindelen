
{*******************************************************}
{                                                       }
{             Copyright (C) 1997 - 2001                 }
{         Dmitriy Kovalenko (ibsysdba@i.com.ua)         }
{                         &                             }
{           Pavel Shibanov (ib_db@i.com.ua)             }
{                   Kiev, Ukraine                       }
{               http://fibplus.com.ua                   }
{                                                       }
{*******************************************************}

// Привет!
// Сие есть вариант использования маневра для поиска как на серваке, так и на клиенте.
// Написан нами при разработке внутренней офисной системы для
// ООО "МОРИОН" http://www.morion.kiev.ua.
// Код может показаться несколько избыточным или на Ваш взгляд просто дебильным :).
// Не расстраивайтесь и не обращайте внимания - у Вас получится намного лучше! :)
// Это просто "snapshot" кусочков рабочего кода из вышеупомянутого проекта
// исключительно для демонстрации одного из вариантов решения проблемы.
// На самом деле этот код (основная часть) у нас "зашит" в одной из базовых форм,
// от которой потом наследуются все остальные. Также используются и "модные" контролы,
// но так как они не входят в стандартную поставку Delphi, пришлось их "выкинуть".
// Тем самым мы "завернули" представленную функциональность во все формы, работающие с наборами данных.
// Спорить как лучше - не будем :) Каждый для себя сделает наиболее "по-правильному".

// ЗЫ
// Не забывайте, что поиск по STARTING WITH должен производится
// по индексированному полю. Т.к. мы в основном используем PXW_CYRL, то такое поле
// ограничивается для нас 84 символами. Поэтому для названий, например, в 120
// символов мы делаем еще одно поле, в которое апперкейсим первые 84 символа.
// Этого с головой хватит для набора юзером в поисковом окне :)))))))))))
// В общем идея такова: если такой поиск закладывается как основной для приложения,
// то для этого понадобится соответствующим образом "подогнать" и ваш *.GDB.
// Поверьте, незначительный прирост файла базы данных,
// окупится сторицей при выигрыше в скорости поиска, который вы достигаете.

// ЗЫЗЫ
// Внимание! При внедрении этого алгоритма мы столкнулись с психологическими трудностями
// у нашего начальства. Это было не смешно :) Однако, через три минуты эксплуатации,
// оные особы перестали себя представлять в это мире без поиска по STARTING WITH/CONTAINING :)))
// Задышали полной грудью старые убогие Пентиумы с 32 метрами памяти...
// Для совместимости со старой психологией в проекте сделан переключатель
// методов поиска, т.е. все оставлено на усмотрение юзера.

// ЗЫЗЫЗЫ
// Данным подходом к проблеме, мы избавили себя от необходимости использования
// клиентского датасета (для организации быстрого поиска по индексу на клиенте).
// Теперь юзер во время поиска при каждом очередном наборе слова видит
// с вероятностью 0.9 самые свежие данные с сервера. ИМХО :)

// Удачи!
// С ув. Дмитрий Коваленко, Павел Шибанов.

unit starting_with;

interface

uses
  common,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ExtCtrls, ComCtrls, ToolWin, StdCtrls, Buttons, Db,
  FIBDatabase, pFIBDatabase, FIBDataSet, pFIBDataSet;

type
  TSearchMethod  = (smServer, smLocate);

  TfrmStartingWith = class(TForm)
    Timer1: TTimer;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    edtSearch: TEdit;
    DBGrid1: TDBGrid;
    btnClose: TBitBtn;
    btnContaining: TButton;
    btnCancelContaining: TButton;
    dtName: TpFIBDataSet;
    dsName: TDataSource;
    Label2: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSearchChange(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure btnContainingClick(Sender: TObject);
    procedure btnCancelContainingClick(Sender: TObject);
  private
    { Private declarations }
    FSelectDataSet: TpFIBDataSet;
    FUpdateDataSet: TpFIBDataSet;
    FSearchMethod: TSearchMethod;
    FSearchFieldServer: string;
    FSearchFieldClient: string;
    FSearchText: string;
    FOldSelectSQL: string;
    FTimeSearchText: string;
    FDBGrid: TDBGrid;

    FOvBeforeOpen: TDataSetNotifyEvent;

    function GetSelectDataSet: TpFIBDataSet;
    procedure SetSelectDataSet(DataSet: TpFIBDataSet);
    function GetUpdateDataSet: TpFIBDataSet;
    procedure SetUpdateDataSet(DataSet: TpFIBDataSet);
    procedure SetDBGrid(Grid: TDBGrid);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;

    procedure BeforeOpen(DataSet: TDataSet);
    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);

    procedure DBGridKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure SetSearchMethod(ASearchMethod: TSearchMethod); virtual;

    procedure SearchOnClient(const FindStr: string; DoContaining: Boolean);
    procedure SearchOnServer(const FindStr: string; DoContaining: Boolean);

    property SelectDataSet: TpFIBDataSet read GetSelectDataSet write SetSelectDataSet;
    property UpdateDataSet: TpFIBDataSet read GetUpdateDataSet write SetUpdateDataSet;
    property SearchMethod: TSearchMethod read FSearchMethod write SetSearchMethod;
    property SearchFieldClient: string read FSearchFieldClient write FSearchFieldClient;
    property SearchFieldServer: string read FSearchFieldServer write FSearchFieldServer;
    property OldSelectSQL: string read FOldSelectSQL write FOldSelectSQL;
    property DBGrid: TDBGrid read FDBGrid write SetDBGrid;
  end;

var
  frmStartingWith: TfrmStartingWith;
  SearchTickCount: Integer = 0;

implementation

uses pFIBProps, SqlTxtRtns, dm_main;

{$R *.DFM}

constructor TfrmStartingWith.Create(AOwner: TComponent); //override
begin
  inherited;
  // Инициализация свойств
  FSelectDataSet     := dtName;
  FUpdateDataSet     := nil;
  FSearchMethod      := smServer;
  FSearchFieldClient := 'NAME';
  FSearchFieldServer := 'NAME_SEARCH';
  FSearchText        := '';
  FOldSelectSQL      := '';
  FDBGrid             := DBGrid1;
  FOvBeforeOpen      := nil;
end;

procedure TfrmStartingWith.BeforeOpen(DataSet: TDataSet);
begin
  if Assigned (FOvBeforeOpen) then FOvBeforeOpen(DataSet);
end;

procedure TfrmStartingWith.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
  function PosCI(const Substr, Str: string): Integer;
  begin
    Result := Pos(AnsiUpperCase(Substr), AnsiUpperCase(Str));
  end;
begin
  Accept := Trim(FSearchText) = '';

  if not Accept then
  begin
    Accept := PosCI(FSearchText, DataSet.FieldByName(SearchFieldClient).AsString) > 0;
  end;
end;

function TfrmStartingWith.GetSelectDataSet: TpFIBDataSet;
begin
  Result := FSelectDataSet;
end;

procedure TfrmStartingWith.SetSelectDataSet(DataSet: TpFIBDataSet);
begin
  FSelectDataSet := DataSet;
  if Assigned(FSelectDataSet) then
  begin
    if Assigned(FSelectDataSet.BeforeOpen) then
      FOvBeforeOpen := FSelectDataSet.BeforeOpen;
    FSelectDataSet.BeforeOpen := BeforeOpen;
    FSelectDataSet.OnFilterRecord := FilterRecord;
  end;
end;

function TfrmStartingWith.GetUpdateDataSet: TpFIBDataSet;
begin
  Result := FUpdateDataSet;
end;

procedure TfrmStartingWith.SetUpdateDataSet(DataSet: TpFIBDataSet);
begin
  FUpdateDataSet := DataSet;
  if Assigned(FUpdateDataSet) then
  begin
    //
  end;
end;

procedure TfrmStartingWith.SetSearchMethod(ASearchMethod: TSearchMethod);
begin
  FSearchMethod := ASearchMethod;

  if Assigned(SelectDataSet) then
  begin
    with SelectDataSet do
    begin
      Close;
      SelectSQL.Text := OldSelectSQL;

      case ASearchMethod of
       smServer:;
       smLocate: begin
                   Open;
                   if not (fsModal in FormState) then FetchAll;
                 end;
      end;
    end;
  end;
end;

procedure TfrmStartingWith.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #8: begin
          if ActiveControl = DBGrid then
           btnCancelContaining.Click
          else
          begin
            if (GetTickCount - SearchTickCount > SEARCH_DELAY) then
              FTimeSearchText := ''
            else
            begin
              FTimeSearchText := Copy(FTimeSearchText, 1, Length(FTimeSearchText) - 1);
              SearchTickCount := GetTickCount;
              if Length(FTimeSearchText) > 0 then edtSearch.Text := FTimeSearchText;
            end;
          end;
        end;
    #13:;
    #27:;
    #32..#255: begin
                 if (GetTickCount - SearchTickCount > SEARCH_DELAY) then FTimeSearchText := '';
                 FTimeSearchText := FTimeSearchText + Key;
                 SearchTickCount := GetTickCount;
                 if Length(FTimeSearchText) > 0 then edtSearch.Text := FTimeSearchText;
               end;
  end;
end;

procedure TfrmStartingWith.SetDBGrid(Grid: TDBGrid);
begin
  FDBGrid := Grid;
  if Assigned(FDBGrid) then
  begin
    FDBGrid.OnKeyPress := DBGridKeyPress;
  end;
end;

(******************************************************************************)
(*  Поиск по LOCATE() на клиенте - совсем неправильный                        *)
(******************************************************************************)
procedure TfrmStartingWith.SearchOnClient(const FindStr: string; DoContaining: Boolean);
var
  SeekBack, SeekNext : Boolean;
  CurruntValue: string;
begin
  SeekBack := False;
  SeekNext := False;

  if FindStr = '' then
  begin
    FSearchText := '';
    Exit;
  end;

  with SelectDataset do
  begin
    if IsEmpty then Exit;

    if FSearchText = '' then
    begin
      SeekBack := not BOF;
      SeekNext := BOF;
      FSearchText := FindStr;
    end
    else
    begin
      CurruntValue := AnsiUpperCase(FieldByName(FSearchFieldClient).AsString);
      SeekBack := CurruntValue > AnsiUpperCase(FindStr);
      SeekNext := CurruntValue < AnsiUpperCase(FindStr);
      FSearchText := FindStr;

      if DoContaining then
      begin
        Filtered := True;
        Exit;
      end;
    end;

    if SeekBack then
      Locate(SearchFieldClient, FSearchText, [loCaseInsensitive, loPartialKey]);

    if SeekNext then
      LocateNext(SearchFieldClient, FSearchText, [loCaseInsensitive, loPartialKey]);
  end;
end;

(******************************************************************************)
(*  Поиск по STARTING WITH на сервере - очень правильный                      *)
(******************************************************************************)
procedure TfrmStartingWith.SearchOnServer(const FindStr: string;  DoContaining: Boolean);
var
  sSQL: string;
begin
  FSearchText := AnsiUpperCase(FindStr);

  sSQL := SearchFieldServer + ' STARTING WITH ' + '''' + FSearchText + '''';

  if DoContaining then
    sSQL := SearchFieldServer + ' CONTAINING ' + '''' + FSearchText + '''';

  with SelectDataSet do
  begin
    if Active then Close;

    if FSearchText <> '' then
    begin
      SelectSQL.Text := AddToWhereClause(OldSelectSQL, sSQL);
      Open;
    end
    else
    begin
      SelectSQL.Text := OldSelectSQL;
    end;
  end;
end;

procedure TfrmStartingWith.Timer1Timer(Sender: TObject);
begin
  if Assigned(SelectDataSet) then
  begin
    try
      case SearchMethod of
        smServer: begin
                    if SearchFieldServer <> '' then
                      SearchOnServer(edtSearch.Text, False)
                    else
                      SearchOnClient(edtSearch.Text, False);
                  end;
        smLocate:  SearchOnClient(edtSearch.Text, False);
      end; //case
    finally
      Timer1.Enabled := False;
    end;
  end;
end;

procedure TfrmStartingWith.FormShow(Sender: TObject);
begin
  SelectDataSet     := dtName;
  DBGrid            := DBGrid1;


  if Assigned(SelectDataSet) and (not SelectDataSet.Active) then
  begin
    OldSelectSQL := SelectDataSet.SelectSQL.Text;

    if (poStartTransaction in SelectDataSet.Options) then
    begin
      case SearchMethod of
        smServer: begin
//                    if (fsModal in FormState) then
//                    begin
//                      SelectDataSet.Open;
//                    end;
                  end;
        smLocate: begin
//                    SelectDataSet.Open;
//                    if not (fsModal in FormState) then SelectDataSet.FetchAll;
                  end;
      end;
    end;
  end;
end;

procedure TfrmStartingWith.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dtName.Close;
  dtName.BeforeOpen := nil;
  dtName.OnFilterRecord := nil;
end;

procedure TfrmStartingWith.edtSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Assigned(DBGrid) and Assigned(SelectDataSet)) then
  begin
    case Key of
      VK_UP, VK_PRIOR:   begin
                 with DBGrid do if CanFocus then SetFocus;
                 if not SelectDataSet.IsEmpty then SelectDataSet.Prior;
               end;
      VK_DOWN, VK_NEXT: begin
                 with DBGrid do if CanFocus then SetFocus;
                 if not SelectDataSet.IsEmpty then SelectDataSet.Next;
               end;
    end;
  end;
end;

procedure TfrmStartingWith.edtSearchChange(Sender: TObject);
begin
  Timer1.Enabled := False;
  Timer1.Enabled := True;
  if edtSearch.Focused then FTimeSearchText := '';
end;

procedure TfrmStartingWith.RadioButton1Click(Sender: TObject);
begin
  SelectDataSet.Close;
  edtSearch.Text := '';
  FSearchText := '';

  case (Sender as TRadioButton).Tag of
    0: SearchMethod := smServer;
    1: SearchMethod := smLocate;
  end;
end;

procedure TfrmStartingWith.btnContainingClick(Sender: TObject);
begin
  if Assigned(SelectDataSet) then
  begin
    if edtSearch.Text <> '' then
    begin
      case SearchMethod of
        smServer: SearchOnServer(edtSearch.Text, True);
        smLocate: SearchOnClient(edtSearch.Text, True);
      end;
    end
    else
    begin
      if not SelectDataSet.Active then
        if (poStartTransaction in SelectDataSet.Options) then
        begin
          try
//            FormBroadcast(START_WAIT_FORM, 0);
            SelectDataSet.Open;
          finally
//            FormBroadcast(CLOSE_WAIT_FORM, 0);
          end;
        end;
    end;
  end;

  if DBGrid <> nil then
    with DBGrid do if CanFocus then SetFocus;
end;

procedure TfrmStartingWith.btnCancelContainingClick(Sender: TObject);
begin
  if Assigned(SelectDataSet) then
  begin
    edtSearch.Text := '';
    FTimeSearchText := '';
    case SearchMethod of
      smServer: SearchOnServer(edtSearch.Text, False);
      smLocate: SelectDataSet.Filtered := False;
    end;
  end;

  if DBGrid <> nil then
    with DBGrid do if CanFocus then SetFocus;
end;

end.
