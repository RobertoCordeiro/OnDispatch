<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Web Transaction Tracking"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Web Transaction Tracking"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Web Transaction Tracking"
    End If
    If Not IsPostBack Then
      calChooseDate.SelectedDate = Today
      lblDate.Text = calChooseDate.SelectedDate
      LoadTransactions(Today)
      LoadFlaggedTransactions(Today)
      LoadStats()
      LoadTopIPs()      
    End If    
  End Sub
  
  Private Sub LoadStats()
    Dim tm As New cvTrafficMaster.Transactions(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    lblTransactions.Text = tm.GetTransactionCount.ToString
    lblTransactionsToday.Text = tm.GetTransactionCountForDay(calChooseDate.SelectedDate).ToString
    lblDistinct.Text = tm.GetDistinctRemoteAddressCount
    lblDistinctForDay.Text = tm.GetDistinctRemoteAddressCountForDay(calChooseDate.SelectedDate).ToString
  End Sub
  
  Private Sub LoadTransactions(ByVal datDay As Date)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTransactionsForDay")
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@Day", Data.SqlDbType.DateTime).Value = datDay
    cnn.Open()
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    Try
      dgvTransactions.DataSource = ds
      dgvTransactions.DataBind()
    Catch ex As Exception
      dgvTransactions.DataSource = Nothing
      dgvTransactions.DataBind()
    End Try
    cnn.Close()
  End Sub
  
  Private Sub LoadFlaggedTransactions(ByVal datDay As Date)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetFlaggedTransactionsForDay")
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@Day", Data.SqlDbType.DateTime).Value = datDay
    cnn.Open()
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    Try
      dgvFlaggedTransactions.DataSource = ds
      dgvFlaggedTransactions.DataBind()
    Catch ex As Exception
      dgvFlaggedTransactions.DataSource = Nothing
      dgvFlaggedTransactions.DataBind()
    End Try
    cnn.Close()
  End Sub
  
  Private Sub LoadTopIPs()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTopRemoteAddresses")
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    Try
      dgvTopIps.DataSource = ds
      dgvTopIps.DataBind()
    Catch ex As Exception
      dgvTopIps.DataSource = Nothing
      dgvTopIps.DataBind()
    End Try
    cnn.Close()
  End Sub
  
  Private Sub dgvFlaggedTransactions_Paged(ByVal S As Object, ByVal E As DataGridPageChangedEventArgs)
    dgvFlaggedTransactions.CurrentPageIndex = E.NewPageIndex
    LoadTransactions(calChooseDate.SelectedDate)
    LoadFlaggedTransactions(calChooseDate.SelectedDate)
    LoadStats()
  End Sub
  
  Private Sub dgvTransactions_Paged(ByVal S As Object, ByVal E As DataGridPageChangedEventArgs)
    dgvTransactions.CurrentPageIndex = E.NewPageIndex
    LoadTransactions(calChooseDate.SelectedDate)
    LoadFlaggedTransactions(calChooseDate.SelectedDate)
    LoadStats()
    LoadTopIPs()
  End Sub

  Private Sub dgvTopIPs_Paged(ByVal S As Object, ByVal E As DataGridPageChangedEventArgs)
    dgvTopIps.CurrentPageIndex = E.NewPageIndex
    LoadTransactions(calChooseDate.SelectedDate)
    LoadFlaggedTransactions(calChooseDate.SelectedDate)
    LoadStats()
    LoadTopIPs()
  End Sub

  Private Sub calChooseDate_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
    lblDate.Text = calChooseDate.SelectedDate
    LoadTransactions(calChooseDate.SelectedDate)
    LoadFlaggedTransactions(calChooseDate.SelectedDate)
    LoadStats()
    LoadTopIPs()
  End Sub
  
  Private Sub btnAddFlag_Click(ByVal S As Object, ByVal E As EventArgs)
    If FlagComplete() Then
      Dim flg As New cvTrafficMaster.FlagRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
      flg.Add(txtFlagDescription.Text.Trim, txtFlagIp.Text.Trim)
      txtFlagIp.Text = ""
      txtFlagDescription.Text = ""
      LoadTransactions(calChooseDate.SelectedDate)
      LoadFlaggedTransactions(calChooseDate.SelectedDate)
      LoadStats()
    Else
      divFlagErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnAddExclude_Click(ByVal S As Object, ByVal E As EventArgs)
    If ExcludeComplete() Then
      Dim exc As New cvTrafficMaster.ExcludeRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
      exc.Add(txtExcludeIP.Text.Trim, txtReason.Text.Trim)
      txtExcludeIP.Text = ""
      txtReason.Text = ""
      LoadTransactions(calChooseDate.SelectedDate)
      LoadFlaggedTransactions(calChooseDate.SelectedDate)
      LoadStats()
    Else
      divExcludeErrors.Visible = True
    End If
  End Sub
  
  Private Function FlagComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtFlagIp.Text.Trim.Length = 0 Then
      strErrors &= "<li>IP is Required</li>"
      blnReturn = False
    End If
    If txtFlagDescription.Text.Trim.Length = 0 Then
      strErrors &= "<li>Description is Required</li>"
      blnReturn = False
    End If
    divFlagErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Function ExcludeComplete() As Boolean    
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtExcludeIP.Text.Trim.Length = 0 Then
      strErrors &= "<li>IP is Required</li>"
      blnReturn = False
    End If
    If txtReason.Text.Trim.Length = 0 Then
      strErrors &= "<li>Reason is Required</li>"
      blnReturn = False
    End If
    divExcludeErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub btnExport_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim exp As New cvCommon.Export
    dgvTransactions.AllowPaging = False
    LoadTransactions(calChooseDate.SelectedDate)
    Dim blnRequireSecure As Boolean = System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection")
    exp.DataGridToExcel(Response, dgvTransactions, "Transactions.xls", "Sheet1", blnRequireSecure)
    dgvTransactions.AllowPaging = True
    LoadTransactions(calChooseDate.SelectedDate)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmWebStats" runat="server">
    <table>
      <tbody>
        <tr>
          <td><asp:Calendar ID="calChooseDate" runat="server" OnSelectionChanged="calChooseDate_SelectionChanged" /></td>
          <td>
            <div class="bandheader">Statistics</div>
            <table>
              <tbody>
                <tr>
                  <td class="label">Transactions</td>
                  <td><asp:Label ID="lblTransactions" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Distinct IPs</td>
                  <td><asp:Label ID="lblDistinct" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Transactions for Day</td>
                  <td><asp:Label ID="lblTransactionsToday" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Distinct IPs for Day</td>
                  <td><asp:Label ID="lblDistinctForDay" runat="server" /></td>
                </tr>
              </tbody>
            </table>
          </td>
          <td style="width: 150px;">
            <div class="bandheader">Flags</div>
            <div class="errorzone" id="divFlagErrors" visible="false" runat="server" />
            <div class="label">IP Address</div>
            <div><asp:TextBox style="width: 148px" ID="txtFlagIp" MaxLength="32" runat="server" /></div>
            <div class="label">Description</div>
            <div><asp:TextBox style="width: 148px" ID="txtFlagDescription" MaxLength="255" runat="server" /></div>
            <div style="text-align: right;"><asp:Button ID="btnAddFlag" Text="Add Flag" runat="server" OnClick="btnAddFlag_Click" /></div>
          </td>
          <td style="width: 150px;">
            <div class="bandheader">Excludes</div>
            <div class="errorzone" id="divExcludeErrors" visible="false" runat="server" />
            <div class="label">IP Address</div>
            <div><asp:TextBox style="width: 148px" ID="txtExcludeIP" MaxLength="32" runat="server" /></div>
            <div class="label">Reason</div>
            <div><asp:TextBox style="width: 148px" ID="txtReason" MaxLength="255" runat="server" /></div>
            <div style="text-align: right;"><asp:Button ID="btnAddExclude" Text="Add Exclude" runat="server" OnClick="btnAddExclude_Click" /></div>
          </td>
          <td style="width: 150px;">
            <div class="bandheader">Graphs</div>
            <div><a href="graphs/webstatsgraph.aspx">Last 30 Day</a></div>
          </td>
          <td style="width: 150px;">
            <div class="bandheader">Top IPs</div>
            <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" AllowPaging="true" PageSize="5" pagerstyle-mode="NumericPages" OnPageIndexChanged="dgvTopIps_Paged" runat="server" ID="dgvTopIps">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:HyperLinkColumn
                  HeaderText="IP"
                  DataNavigateUrlField="RemoteAddress"
                  DataNavigateUrlFormatString="http://whois.domaintools.com/{0}"
                  DataTextField="RemoteAddress"
                  />
                <asp:BoundColumn
                  HeaderText="Hits"
                  Datafield="TransactionCount"
                  />                                
              </Columns>                          
            </asp:DataGrid>
          </td>
        </tr>
      </tbody>
    </table>
    <div class="bandheader">Transactions for <asp:Label ID="lblDate" runat="server" /><asp:Button ID="btnExport" runat="server" Text="Export" OnClick="btnExport_Click" /></div>
    <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" AllowPaging="true" PageSize="20" PagerStyle-Mode="NumericPages" OnPageIndexChanged="dgvTransactions_Paged" ID="dgvTransactions" runat="server">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />   
      <Columns>
        <asp:HyperLinkColumn
         HeaderText="IP"
         DataNavigateUrlField="RemoteAddress"
         DataNavigateUrlFormatString="http://whois.domaintools.com/{0}"
         DataTextField="RemoteAddress"
         />
        <asp:BoundColumn
          HeaderText="Page"
          DataFIeld="ScriptName"
          />
        <asp:BoundColumn
          HeaderText="Query"
          DataField="QueryString"
          />
        <asp:HyperLinkColumn
          HeaderText="Referrer"
          DataNavigateUrlField="Referrer"
          DataTextField="Referrer" 
          ItemStyle-Wrap="true"
          ItemStyle-CssClass="forcebreakfield"
        />
        <asp:BoundColumn
          HeaderText="Agent/Browser"
          DataField="UserAgent"
        />
        <asp:BoundColumn
          HeaderText="Server"
          DataField="ServerName"
          />
        <asp:BoundColumn
          HeaderText="Date"
          DataField="TransactionDate"
          />          
      </Columns>
    </asp:DataGrid>
    <div class="bandheader">Flagged Transactions</div>    
    <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" AllowPaging="true" PageSize="20" PagerStyle-Mode="NumericPages" OnPageIndexChanged="dgvFlaggedTransactions_Paged" ID="dgvFlaggedTransactions" runat="server">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />   
      <Columns>
        <asp:BoundColumn
          HeaderText="Flag Description"
          DataField="Description"
          />
        <asp:BoundColumn 
          HeaderText="ID"
          DataField="TransactionID"
          />
        <asp:HyperLinkColumn
         HeaderText="IP"
         DataNavigateUrlField="RemoteAddress"
         DataNavigateUrlFormatString="http://whois.domaintools.com/{0}"
          DataTextField="RemoteAddress"
         />
        <asp:BoundColumn
          HeaderText="Page"
          DataFIeld="ScriptName"
          />
        <asp:BoundColumn
          HeaderText="Query"
          DataField="QueryString"
          />
        <asp:HyperLinkColumn
          HeaderText="Referrer"
          DataNavigateUrlField="Referrer"
          DataTextField="Referrer" 
        />
        <asp:BoundColumn
          HeaderText="Server"
          DataField="ServerName"
          />
        <asp:BoundColumn
          HeaderText="Date"
          DataField="TransactionDate"
          />          
      </Columns>
    </asp:DataGrid>    
  </form>
</asp:Content>