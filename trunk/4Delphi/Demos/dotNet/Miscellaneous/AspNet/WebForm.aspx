<%@ Page Language="c#" Codebehind="WebForm.pas" AutoEventWireup="false" Inherits="WebForm.TWebForm"%>
<!doctype HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
  <head>
    <title>WebForm</title>
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5"
      name="vs_targetSchema">
  </head>
  <body style="WIDTH: 813px; HEIGHT: 315px" ms_positioning="GridLayout">
    <form id="Form1" method="post" runat="server">
      <table id="Table1"
        style="Z-INDEX: 104; LEFT: 10px; WIDTH: 807px; POSITION: absolute; TOP: 17px; HEIGHT: 32px"
        cellspacing="5" cellpadding="0" bgcolor="#ccccff">
        <tbody>
          <tr>
            <td>
              <asp:Label id="lbTitle" runat="server" forecolor="Navy" font-bold="True"
                enableviewstate="False" font-size="12pt"
                font-names="Verdana">Using IBDAC .NET with ASP .NET</asp:Label>
            </td>
          </tr>
        </tbody>
      </table>
      <asp:Label id="lbInfo"
        style="Z-INDEX: 111; LEFT: 346px; POSITION: absolute; TOP: 546px"
        runat="server" forecolor="Navy" font-bold="True"
        enableviewstate="False" font-size="10pt" font-names="Verdana"></asp:Label>
      <asp:Button id="btInsertRecord"
        style="Z-INDEX: 110; LEFT: 722px; POSITION: absolute; TOP: 567px"
        runat="server" visible="False" width="100px"
        text="Insert record"></asp:Button>
      <asp:Button id="btUpdate"
        style="Z-INDEX: 109; LEFT: 124px; POSITION: absolute; TOP: 542px"
        runat="server" width="100px" text="Update"></asp:Button>
      <asp:Label id="Label2"
        style="Z-INDEX: 108; LEFT: 14px; POSITION: absolute; TOP: 390px"
        runat="server" forecolor="Navy" font-bold="True"
        enableviewstate="False" font-size="10pt" font-names="Verdana">SQL</asp:Label>
      <asp:Button id="btFill"
        style="Z-INDEX: 103; LEFT: 14px; POSITION: absolute; TOP: 541px"
        runat="server" width="100px" text="Fill"></asp:Button>
      <asp:TextBox id="tbSQL"
        style="Z-INDEX: 101; LEFT: 13px; POSITION: absolute; TOP: 410px"
        runat="server" font-names="Courier New" width="400px"
        textmode="MultiLine" wrap="False" height="121px"></asp:TextBox>
      <asp:Label id="lbResult"
        style="Z-INDEX: 107; LEFT: 14px; POSITION: absolute; TOP: 574px"
        runat="server" forecolor="Navy" font-bold="True"
        enableviewstate="False" font-size="10pt" font-names="Verdana"
        visible="False">Result</asp:Label>
      <asp:Label id="lbError"
        style="Z-INDEX: 105; LEFT: 14px; POSITION: absolute; TOP: 366px"
        runat="server" forecolor="Red" font-bold="True"
        enableviewstate="False" font-size="10pt" font-names="Verdana"></asp:Label><br>
      <br>
      <asp:DataGrid id="dataGrid"
        style="Z-INDEX: 100; LEFT: 13px; POSITION: absolute; TOP: 595px"
        runat="server" font-size="8pt" font-names="Verdana"
        width="807px" cellpadding="3" bordercolor="Black"
        backcolor="#CCCCFF">
        <HeaderStyle backcolor="#AAAADD"></HeaderStyle>
        <Columns>
          <asp:EditCommandColumn buttontype="LinkButton" updatetext="Update" canceltext="Cancel"
            edittext="Edit"></asp:EditCommandColumn>
          <asp:ButtonColumn text="Delete" commandname="Delete">
            <HeaderStyle width="60px"></HeaderStyle>
          </asp:ButtonColumn>
        </Columns>
      </asp:DataGrid>
      <asp:Panel id="pPoolingOptions"
        style="Z-INDEX: 113; LEFT: 406px; POSITION: absolute; TOP: 62px"
        runat="server" width="407px" height="196px">
        <asp:Label id="Label1"
          style="Z-INDEX: 108; LEFT: 0px; POSITION: absolute; TOP: 0px"
          runat="server" forecolor="Navy" font-bold="True"
          enableviewstate="False" font-size="10pt"
          font-names="Verdana">Pooling options</asp:Label>
        <TABLE
          style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; Z-INDEX: 102; LEFT: 0px; FONT: 10pt verdana; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid; POSITION: absolute; TOP: 22px; BACKGROUND-COLOR: lemonchiffon"
          cellspacing="15" cellpadding="0">
          <tbody>
            <tr>
              <td style="WIDTH: 180px">
                <b>Use pooling</b>&nbsp; 
                <asp:CheckBox id="cbUsePooling" runat="server"></asp:CheckBox>
              </td>
              <td style="HEIGHT: 24px"></td>
            </tr>
            <tr>
              <td>
                <b style="MARGIN-LEFT: 24px">MaxPoolSize</b>
              </td>
              <td style="HEIGHT: 16px">
                <asp:TextBox id="tbMaxPoolSize" runat="server"></asp:TextBox>
              </td>
            </tr>
            <tr>
              <td style="HEIGHT: 24px">
                <b style="MARGIN-LEFT: 24px">MinPoolSize</b>
              </td>
              <td style="HEIGHT: 24px">
                <asp:TextBox id="tbMinPoolSize" runat="server"></asp:TextBox>
              </td>
            </tr>
            <tr>
              <td>
                <b style="MARGIN-LEFT: 24px">ConnectionLifeTime</b>
              </td>
              <td>
                <asp:TextBox id="tbConnectionLifeTime" runat="server"></asp:TextBox>
              </td>
            </tr>
          </tbody>
        </TABLE>
      </asp:Panel>
      <asp:Panel id="Panel1"
        style="Z-INDEX: 114; LEFT: 12px; POSITION: absolute; TOP: 62px"
        runat="server" width="373px" height="304px">
        <asp:Label id="Label3"
          style="Z-INDEX: 108; LEFT: 0px; POSITION: absolute; TOP: 0px"
          runat="server" forecolor="Navy" font-bold="True"
          enableviewstate="False" font-size="10pt"
          font-names="Verdana">Connection
  </asp:Label>
        <TABLE
          style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; Z-INDEX: 102; LEFT: 0px; FONT: 10pt verdana; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid; POSITION: absolute; TOP: 22px; BACKGROUND-COLOR: lemonchiffon"
          cellspacing="15" cellpadding="0">
          <tbody>
            <tr>
              <td style="HEIGHT: 24px">
                <b>Username </b>
              </td>
              <td style="HEIGHT: 24px">
                <asp:TextBox id="tbUsername" runat="server"></asp:TextBox>
              </td>
            </tr>
            <tr>
              <td>
                <b>Password </b>
              </td>
              <td>
                <asp:TextBox id="tbPassword" runat="server"></asp:TextBox>
              </td>
            </tr>
            <tr>
              <td style="HEIGHT: 24px">
                <b>Server</b>
              </td>
              <td style="HEIGHT: 24px">
                <asp:TextBox id="tbServer" runat="server"></asp:TextBox>
              </td>
            </tr>
            <tr>
              <td style="HEIGHT: 24px">
                <b>Database</b>
              </td>
              <b></b>
              </b>
              <b></b>
              <td style="HEIGHT: 24px">
                <asp:TextBox id="tbDatabase" runat="server"></asp:TextBox>
              </td>
            </tr>
            <tr>
              <td style="HEIGHT: 1px">
                <b>Disconnected Mode</b>
              </td>
              <td style="HEIGHT: 1px">
                <asp:CheckBox id="cbDisconnectedMode" runat="server" checked="True"></asp:CheckBox>
              </td>
            </tr>
            <tr>
              <td>
                <b>Failover</b>
              </td>
              <td>
                <asp:CheckBox id="cbFailover" runat="server" checked="True"></asp:CheckBox>
              </td>
            </tr>
            <tr>
              <td>
                <asp:Label id="lbState" runat="server" font-bold="True"
                  enableviewstate="False"></asp:Label>
              </td>
              <td align="right">
                <asp:Button id="btTest" runat="server" enableviewstate="False"
                  text="Test connection"></asp:Button>
              </td>
            </tr>
          </tbody>
        </TABLE>
      </asp:Panel>
    </form>
  </body>
</html>
