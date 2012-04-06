
unit WebForm;

interface

uses
  SysUtils, Classes, System.Collections, System.ComponentModel,
  System.Data, System.Drawing, System.Web, System.Web.SessionState,
  System.Web.UI, System.Web.UI.WebControls, System.Web.UI.HtmlControls,
  System.Globalization, DB, DBAccess, MemData, IBC, IBCConnectionPool,
  Devart.IbDac.DataAdapter;

type
  TWebForm = class(System.Web.UI.Page)
  {$REGION 'Designer Managed Code'}
  strict private
    procedure InitializeComponent;
    procedure btTest_Click(sender: System.Object; e: System.EventArgs);
    procedure btFill_Click(sender: System.Object; e: System.EventArgs);
    procedure btUpdate_Click(sender: System.Object; e: System.EventArgs);
    procedure btInsertRecord_Click(sender: System.Object; e: System.EventArgs);
    procedure dataGrid_EditCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dataGrid_DeleteCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dataGrid_CancelCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
    procedure dataGrid_UpdateCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
  {$ENDREGION}
  strict private
    procedure Page_Load(sender: System.Object; e: System.EventArgs);
  strict protected
    lbTitle: System.Web.UI.WebControls.Label;
    lbInfo: System.Web.UI.WebControls.Label;
    btInsertRecord: System.Web.UI.WebControls.Button;
    btUpdate: System.Web.UI.WebControls.Button;
    Label2: System.Web.UI.WebControls.Label;
    btFill: System.Web.UI.WebControls.Button;
    tbSQL: System.Web.UI.WebControls.TextBox;
    lbResult: System.Web.UI.WebControls.Label;
    lbError: System.Web.UI.WebControls.Label;
    tbUsername: System.Web.UI.WebControls.TextBox;
    tbPassword: System.Web.UI.WebControls.TextBox;
    tbServer: System.Web.UI.WebControls.TextBox;
    lbState: System.Web.UI.WebControls.Label;
    btTest: System.Web.UI.WebControls.Button;
    dataGrid: System.Web.UI.WebControls.DataGrid;
    IBCDataAdapter: Devart.IbDac.DataAdapter.IBCDataAdapter;
    DataSet: System.Data.DataSet;
    Form1: System.Web.UI.HtmlControls.HtmlForm;
    cbDisconnectedMode: System.Web.UI.WebControls.CheckBox;
    pPoolingOptions: System.Web.UI.WebControls.Panel;
    Label1: System.Web.UI.WebControls.Label;
    tbMaxPoolSize: System.Web.UI.WebControls.TextBox;
    tbMinPoolSize: System.Web.UI.WebControls.TextBox;
    tbConnectionLifeTime: System.Web.UI.WebControls.TextBox;
    Panel2: System.Web.UI.WebControls.Panel;
    Panel3: System.Web.UI.WebControls.Panel;
    cbFailover: System.Web.UI.WebControls.CheckBox;
    TextBox1: System.Web.UI.WebControls.TextBox;
    TextBox2: System.Web.UI.WebControls.TextBox;
    TextBox3: System.Web.UI.WebControls.TextBox;
    TextBox4: System.Web.UI.WebControls.TextBox;
    TextBox5: System.Web.UI.WebControls.TextBox;
    TextBox6: System.Web.UI.WebControls.TextBox;
    TextBox7: System.Web.UI.WebControls.TextBox;
    TextBox8: System.Web.UI.WebControls.TextBox;
    TextBox9: System.Web.UI.WebControls.TextBox;
    TextBox10: System.Web.UI.WebControls.TextBox;
    TextBox11: System.Web.UI.WebControls.TextBox;
    TextBox12: System.Web.UI.WebControls.TextBox;
    TextBox13: System.Web.UI.WebControls.TextBox;
    TextBox14: System.Web.UI.WebControls.TextBox;
    TextBox15: System.Web.UI.WebControls.TextBox;
    TextBox16: System.Web.UI.WebControls.TextBox;
    TextBox17: System.Web.UI.WebControls.TextBox;
    TextBox18: System.Web.UI.WebControls.TextBox;
    TextBox19: System.Web.UI.WebControls.TextBox;
    TextBox20: System.Web.UI.WebControls.TextBox;
    TextBox21: System.Web.UI.WebControls.TextBox;
    TextBox22: System.Web.UI.WebControls.TextBox;
    TextBox23: System.Web.UI.WebControls.TextBox;
    TextBox24: System.Web.UI.WebControls.TextBox;
    TextBox25: System.Web.UI.WebControls.TextBox;
    TextBox26: System.Web.UI.WebControls.TextBox;
    TextBox27: System.Web.UI.WebControls.TextBox;
    TextBox28: System.Web.UI.WebControls.TextBox;
    TextBox29: System.Web.UI.WebControls.TextBox;
    TextBox30: System.Web.UI.WebControls.TextBox;
    TextBox31: System.Web.UI.WebControls.TextBox;
    TextBox32: System.Web.UI.WebControls.TextBox;
    TextBox33: System.Web.UI.WebControls.TextBox;
    TextBox34: System.Web.UI.WebControls.TextBox;
    TextBox35: System.Web.UI.WebControls.TextBox;
    TextBox36: System.Web.UI.WebControls.TextBox;
    TextBox37: System.Web.UI.WebControls.TextBox;
    TextBox38: System.Web.UI.WebControls.TextBox;
    TextBox39: System.Web.UI.WebControls.TextBox;
    TextBox40: System.Web.UI.WebControls.TextBox;
    TextBox41: System.Web.UI.WebControls.TextBox;
    TextBox42: System.Web.UI.WebControls.TextBox;
    TextBox43: System.Web.UI.WebControls.TextBox;
    TextBox44: System.Web.UI.WebControls.TextBox;
    TextBox45: System.Web.UI.WebControls.TextBox;
    Label3: System.Web.UI.WebControls.Label;
    Panel1: System.Web.UI.WebControls.Panel;
    cbUsePooling: System.Web.UI.WebControls.CheckBox;
    tbDatabase: System.Web.UI.WebControls.TextBox;
    Label4: System.Web.UI.WebControls.Label;
    TextBox46: System.Web.UI.WebControls.TextBox;
    TextBox47: System.Web.UI.WebControls.TextBox;
    TextBox48: System.Web.UI.WebControls.TextBox;
    TextBox49: System.Web.UI.WebControls.TextBox;
    CheckBox1: System.Web.UI.WebControls.CheckBox;
    CheckBox2: System.Web.UI.WebControls.CheckBox;
    Label5: System.Web.UI.WebControls.Label;
    Button1: System.Web.UI.WebControls.Button;
  protected
    IBCConnection: TIBCConnection;
    IBCQuery: TIBCQuery;
    procedure OnInit(e: EventArgs); override;
    procedure SetIBCConnectionOptions;
    procedure BindGrid;
    procedure IBCConnectionConnectionLost(Sender: TObject; Component: TComponent;
      ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
  public
    { Public Declarations }
  end;

implementation

{$REGION 'Designer Managed Code'}
/// <summary>
/// Required method for Designer support -- do not modify
/// the contents of this method with the code editor.
/// </summary>
procedure TWebForm.InitializeComponent;
begin
  Self.IBCDataAdapter := Devart.IbDac.DataAdapter.IBCDataAdapter.Create;
  Self.DataSet := System.Data.DataSet.Create;
  (System.ComponentModel.ISupportInitialize(Self.DataSet)).BeginInit;
  Include(Self.btInsertRecord.Click, Self.btInsertRecord_Click);
  Include(Self.btUpdate.Click, Self.btUpdate_Click);
  Include(Self.btFill.Click, Self.btFill_Click);
  Include(Self.dataGrid.CancelCommand, Self.dataGrid_CancelCommand);
  Include(Self.dataGrid.EditCommand, Self.dataGrid_EditCommand);
  Include(Self.dataGrid.UpdateCommand, Self.dataGrid_UpdateCommand);
  Include(Self.dataGrid.DeleteCommand, Self.dataGrid_DeleteCommand);
  Include(Self.btTest.Click, Self.btTest_Click);
  // 
  // IBCDataAdapter
  // 
  Self.IBCDataAdapter.DataSet := nil;
  Self.IBCDataAdapter.Name := '';
  Self.IBCDataAdapter.Tag := nil;
  // 
  // DataSet
  // 
  Self.DataSet.DataSetName := 'NewDataSet';
  Self.DataSet.Locale := System.Globalization.CultureInfo.Create('ru-RU');
  Include(Self.Load, Self.Page_Load);
  (System.ComponentModel.ISupportInitialize(Self.DataSet)).EndInit;
end;
{$ENDREGION}

procedure TWebForm.Page_Load(sender: System.Object; e: System.EventArgs);
begin
  dataSet := System.Data.DataSet(HttpContext.Current.Session['dataset']);
end;

procedure TWebForm.OnInit(e: EventArgs);
begin
  //
  // Required for Designer support
  //
  InitializeComponent;

  IBCConnection := TIBCConnection.Create(nil);
  with IBCConnection do begin
    ConnectPrompt := False;
    Username := 'sysdba';
    Password := 'masterkey';
    Options.DisconnectedMode := True;
    Pooling := True;
    OnConnectionLost := IBCConnectionConnectionLost;
  end;
  IBCQuery := TIBCQuery.Create(nil);
  with IBCQuery do begin
    Connection := IBCConnection;
    SQL.Text := 'select * from dept';
  end;
  IBCDataAdapter.DataSet := IBCQuery;

  tbUsername.Text := IBCConnection.Username;
  tbPassword.Text := IBCConnection.Password;
  tbServer.Text := IBCConnection.Server;
  tbDatabase.Text := IBCConnection.Database;
  cbDisconnectedMode.Checked := IBCConnection.Options.DisconnectedMode;
  tbMaxPoolSize.Text := IntToStr(IBCConnection.PoolingOptions.MaxPoolSize);
  tbMinPoolSize.Text := IntToStr(IBCConnection.PoolingOptions.MinPoolSize);
  tbConnectionLifeTime.Text := IntToStr(IBCConnection.PoolingOptions.ConnectionLifetime);
  cbFailover.Checked := Assigned(IBCConnection.OnConnectionLost);
  tbSQL.Text := IBCQuery.SQL.Text;

  inherited OnInit(e);
end;

procedure TWebForm.SetIBCConnectionOptions;
begin
  IBCConnection.Username := tbUsername.Text;
  IBCConnection.Password := tbPassword.Text;
  IBCConnection.Server := tbServer.Text;
  IBCConnection.Database := tbDatabase.Text;
  IBCConnection.Options.DisconnectedMode := cbDisconnectedMode.Checked;

  IBCConnection.Pooling := cbUsePooling.Checked;
  if IBCConnection.Pooling then begin
    IBCConnection.PoolingOptions.MaxPoolSize := StrToInt(tbMaxPoolSize.Text);
    IBCConnection.PoolingOptions.MinPoolSize := StrToInt(tbMinPoolSize.Text);
    IBCConnection.PoolingOptions.ConnectionLifetime := StrToInt(tbConnectionLifeTime.Text);
  end;

  if cbFailover.Checked then
    IBCConnection.OnConnectionLost := IBCConnectionConnectionLost
  else
    IBCConnection.OnConnectionLost := nil;
end;

procedure TWebForm.BindGrid();
begin
  if dataSet.Tables['Table'] <> Nil then begin
    dataGrid.DataSource := dataSet.Tables['Table'].DefaultView;
    lbResult.Visible := true;
    btInsertRecord.Visible := true;
    if dataSet.Tables['Table'].GetChanges() <> Nil then
      lbInfo.Text := 'Changed'
  end
  else begin
    dataGrid.DataSource := Nil;
    lbResult.Visible := false;
    btInsertRecord.Visible := false;
  end;

  dataGrid.DataBind();
end;

procedure TWebForm.IBCConnectionConnectionLost(Sender: TObject; Component: TComponent;
  ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
end;

procedure TWebForm.dataGrid_UpdateCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
var
 i : integer;
 colValue: string;
begin
  for i := 2 to e.Item.Cells.Count - 1 do begin
    if e.Item.Cells[i].Controls.Count > 0 then begin
      colValue := System.Web.UI.WebControls.TextBox(e.Item.Cells[i].Controls[0]).Text;
      if colValue = '' then
        dataSet.Tables['Table'].Rows[e.Item.ItemIndex][i - 2] := Convert.DBNull
      else
        dataSet.Tables['Table'].Rows[e.Item.ItemIndex][i - 2] := colValue;
    end;
  end;

  dataGrid.EditItemIndex := -1;
  BindGrid();
end;

procedure TWebForm.dataGrid_CancelCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
begin
  dataGrid.EditItemIndex := -1;
  BindGrid();
end;

procedure TWebForm.dataGrid_DeleteCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
begin
  dataSet.Tables['Table'].Rows[e.Item.ItemIndex].Delete();
  BindGrid();
end;

procedure TWebForm.dataGrid_EditCommand(source: System.Object; e: System.Web.UI.WebControls.DataGridCommandEventArgs);
begin
  dataGrid.EditItemIndex := System.Int32(e.Item.ItemIndex);
  BindGrid();
end;

procedure TWebForm.btInsertRecord_Click(sender: System.Object; e: System.EventArgs);
var
  row : DataRow;
begin
  row := dataSet.Tables['Table'].NewRow();
  dataSet.Tables['Table'].Rows.Add(row);
  dataGrid.EditItemIndex := dataSet.Tables['Table'].Rows.Count - 1;
  BindGrid();
end;

procedure TWebForm.btUpdate_Click(sender: System.Object; e: System.EventArgs);
begin
  if dataSet.Tables['Table'] <> Nil then begin
    try try
      SetIBCConnectionOptions;

      IBCQuery.SQL.Text := tbSQL.Text;

      IBCDataAdapter.Update(dataSet, 'Table');

      lbInfo.Text := 'Updated';
    except
      on exception : Exception do begin
        lbError.Text := exception.Message;
      end;
    end;
    finally
       BindGrid();
    end;
  end;
end;

procedure TWebForm.btFill_Click(sender: System.Object; e: System.EventArgs);
var
  i : integer;
  table : DataTable;
begin
  try try
    dataSet.Clear();
    for i := 0 to dataSet.Tables.Count - 1 do begin
      table := dataSet.Tables[i];
      table.Constraints.Clear();
      table.Columns.Clear();
    end;
    dataSet.Tables.Clear();

    SetIBCConnectionOptions;

    IBCQuery.SQL.Text := tbSQL.Text;

    IBCDataAdapter.Fill(dataSet, 'Table');

    lbInfo.Text := 'Filled';
  except
    on exception : Exception do
     lbError.Text := exception.Message;
  end;
  finally
    BindGrid();
  end;
end;

procedure TWebForm.btTest_Click(sender: System.Object; e: System.EventArgs);
begin
  try
    SetIBCConnectionOptions;

    IBCConnection.Open;
    lbState.Text := 'Success';
    lbState.ForeColor := Color.Blue;
    IBCConnection.Close;
  except on exception: Exception do
    begin
      lbState.Text := 'Failed';
      lbState.ForeColor := Color.Red;
      lbError.Text := exception.Message;
    end;
  end;

end;

end.

