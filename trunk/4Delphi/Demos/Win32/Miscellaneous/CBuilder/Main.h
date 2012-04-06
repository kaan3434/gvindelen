//---------------------------------------------------------------------------
#ifndef MainH
#define MainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "MemDS.hpp"
#include "IBC.hpp"
#include <ComCtrls.hpp>
#include <Db.hpp>
#include <DBCtrls.hpp>
#include <DBGrids.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include "DBAccess.hpp"
#include "IBC.hpp"
#include "IbDacVcl.hpp"
#include <DB.hpp>
//---------------------------------------------------------------------------
class TfmMain : public TForm
{
__published:	// IDE-managed Components
    TPanel *ToolBar;
    TButton *btOpen;
    TButton *btClose;
    TButton *btExecute;
    TDBNavigator *DBNavigator;
    TMemo *meSQL;
    TDBGrid *DBGrid;
    TDataSource *DataSource;
    TButton *btDisconnect;
        TSplitter *Splitter1;
        TButton *btConnect;
        TIBCTransaction *IBCTransaction;
        TIBCQuery *IBCQuery;
        TIBCConnectDialog *IBCConnectDialog1;
        TIBCConnection *IBCConnection1;
        TCheckBox *cbDebug;
    void __fastcall btOpenClick(TObject *Sender);
    void __fastcall btCloseClick(TObject *Sender);
    void __fastcall btDisconnectClick(TObject *Sender);
    void __fastcall btExecuteClick(TObject *Sender);
    void __fastcall FormShow(TObject *Sender);
    void __fastcall meSQLExit(TObject *Sender);
        void __fastcall btConnectClick(TObject *Sender);
        void __fastcall cbDebugClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
    __fastcall TfmMain(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfmMain *fmMain;
//---------------------------------------------------------------------------
#endif
