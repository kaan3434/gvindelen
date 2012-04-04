unit MAIN;

{$I EhLib.Inc}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
{$IFDEF EH_LIB_7} XPMan, {$ENDIF}
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, DB, ADODB, EhLibMTE, DataDriverEh, DBGridEh,
  PrnDbgeh;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    FileNew1: TAction;
    FileSave1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ImageList1: TImageList;
    Forms1: TMenuItem;
    Customers1: TMenuItem;
    Employees1: TMenuItem;
    Vendors1: TMenuItem;
    ADOConnection1: TADOConnection;
    PrintDBGridEh1: TPrintDBGridEh;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Customers1Click(Sender: TObject);
    procedure Employees1Click(Sender: TObject);
    procedure Vendors1Click(Sender: TObject);
  private
    { Private declarations }
    procedure CreateMDIChild(const Name: string);
    procedure CreateGridIndicatorTitleMenu(Grid: TCustomDBGridEh; var PopupMenu: TPopupMenu);
    procedure MenuEditClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses CHILDWIN, about, Customers, Employee, Vendors;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DefaultSQLDataDriverResolver.ServerSpecOperations := TMSAccessSpecOperationsEh.Create;

  DBGridEhCenter.OnBuildIndicatorTitleMenu := CreateGridIndicatorTitleMenu;

  ADOConnection1.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;'+
    'Data Source='+ExtractFileDir(ParamStr(0))+ '\dbdemos.mdb;'+
    'Mode=Share Deny None;Jet OLEDB:System database="";Jet OLEDB:Registry Path="";'+
    'Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;'+
    'Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;'+
    'Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="";'+
    'Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;'+
    'Jet OLEDB:Don''t Copy Locale on Compact=False;'+
    'Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False;';
  ADOConnection1.Open;
end;

procedure TMainForm.CreateMDIChild(const Name: string);
var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  Child.Caption := Name;
  if FileExists(Name) then Child.Memo1.Lines.LoadFromFile(Name);
end;

procedure TMainForm.FileNew1Execute(Sender: TObject);
begin
  CreateMDIChild('NONAME' + IntToStr(MDIChildCount + 1));
end;

procedure TMainForm.FileOpen1Execute(Sender: TObject);
begin
  if OpenDialog.Execute then
    CreateMDIChild(OpenDialog.FileName);
end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Customers1Click(Sender: TObject);
begin
  if fCustomers = nil
    then fCustomers := TfCustomers.Create(Application)
    else fCustomers.BringToFront;
end;

procedure TMainForm.Employees1Click(Sender: TObject);
begin
  if fEmployee = nil
    then fEmployee := TfEmployee.Create(Application)
    else fEmployee.BringToFront;
end;

procedure TMainForm.Vendors1Click(Sender: TObject);
begin
  if fVendors = nil
    then fVendors := TfVendors.Create(Application)
    else fVendors.BringToFront;
end;

var
  DBGridEhPrintIndicatorMenuItem: TDBGridEhMenuItem;
  DBGridEhSeparatorMenuItem: TDBGridEhMenuItem;

procedure TMainForm.CreateGridIndicatorTitleMenu(Grid: TCustomDBGridEh;
  var PopupMenu: TPopupMenu);
begin
  DBGridEhCenter.DefaultBuildIndicatorTitleMenu(Grid, PopupMenu);

  if DBGridEhSeparatorMenuItem = nil then
    DBGridEhSeparatorMenuItem := TDBGridEhMenuItem.Create(Screen);

  DBGridEhSeparatorMenuItem.Caption := '-';
  PopupMenu.Items.Add(DBGridEhSeparatorMenuItem);

  if DBGridEhPrintIndicatorMenuItem = nil then
    DBGridEhPrintIndicatorMenuItem := TDBGridEhMenuItem.Create(Screen);

  DBGridEhPrintIndicatorMenuItem.Caption := 'Print preview';
  DBGridEhPrintIndicatorMenuItem.OnClick := MenuEditClick;
  DBGridEhPrintIndicatorMenuItem.Enabled := True;
  DBGridEhPrintIndicatorMenuItem.TitleMenu := itmCut;
  DBGridEhPrintIndicatorMenuItem.Grid := Grid;
  PopupMenu.Items.Add(DBGridEhPrintIndicatorMenuItem);
end;

procedure TMainForm.MenuEditClick(Sender: TObject);
begin
  PrintDBGridEh1.DBGridEh := TDBGridEh((Sender as TDBGridEhMenuItem).Grid); 
  PrintDBGridEh1.Preview;
end;

initialization
  DBGridEhDefaultStyle.IsDrawFocusRect := False;
  DefFontData.Name := 'Microsoft Sans Serif';
end.
