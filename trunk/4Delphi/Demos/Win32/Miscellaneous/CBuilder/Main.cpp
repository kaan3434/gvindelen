//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "MemDS"
#pragma link "DBAccess"
#pragma link "IBC"
#pragma link "Ibdacvcl"
#pragma resource "*.dfm"
TfmMain *fmMain;
//---------------------------------------------------------------------------
__fastcall TfmMain::TfmMain(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfmMain::btOpenClick(TObject *Sender)
{
  IBCQuery->Open();
}
//---------------------------------------------------------------------------
void __fastcall TfmMain::btCloseClick(TObject *Sender)
{
  IBCQuery->Close();
}
//---------------------------------------------------------------------------
void __fastcall TfmMain::btDisconnectClick(TObject *Sender)
{
  IBCConnection1->Disconnect();
}
//---------------------------------------------------------------------------

void __fastcall TfmMain::btExecuteClick(TObject *Sender)
{
  IBCQuery->Execute();
}
//---------------------------------------------------------------------------

void __fastcall TfmMain::FormShow(TObject *Sender)
{
  meSQL->Lines->Assign(IBCQuery->SQL);
  IBCQuery->Debug = cbDebug->Checked;
}
//---------------------------------------------------------------------------

void __fastcall TfmMain::meSQLExit(TObject *Sender)
{
  if (meSQL->Lines->Text != IBCQuery->SQL->Text)
    IBCQuery->SQL->Assign(meSQL->Lines);
}
//---------------------------------------------------------------------------

void __fastcall TfmMain::btConnectClick(TObject *Sender)
{
  IBCConnection1->Connect();
}
//---------------------------------------------------------------------------

void __fastcall TfmMain::cbDebugClick(TObject *Sender)
{
  IBCQuery->Debug = cbDebug->Checked;        
}
//---------------------------------------------------------------------------


