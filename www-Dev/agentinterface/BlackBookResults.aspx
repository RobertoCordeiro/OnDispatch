<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

  Private _ID As Long = 1
  Private lngCustID as long = 1
    Private lngIt As Long
    Private _CountryID As Long = 1

  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Ticket Management"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Ticket Management"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Ticket Management"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
      If _ID < 1 Then
        _ID = 1
      End If
    Catch ex As Exception
      _ID = 1
    End Try
    
        If Not Page.IsPostBack Then
            LoadBlackBookResults()
        End If
    End Sub
    Private Sub LoadBlackBookResults()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDataGrid("spGetBlackBookResultsByUserID", dgvEmployees)
        For Each itm As DataGridItem In dgvEmployees.Items
            If CType(itm.Cells(0).Text, Long) = _ID Then
                itm.CssClass = "selectedbandbar"
            End If
        Next
    End Sub

</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server">
    <table style="width: 100%">
      <tbody>
        <tr>
          <td class="band" style="width: 1%">
            <div class="inputformsectionheader">Employees</div>
            <asp:DataGrid ID="dgvEmployees" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
              <ItemStyle CssClass="bandbar" />
              <Columns>
                <asp:BoundColumn DataField="UserID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" >
                  <ItemTemplate>
                    <a href="blackbookresults.aspx?id=<%# DataBinder.Eval(Container.DataItem,"UserID") %>"><%# DataBinder.Eval(Container.DataItem,"Name") %></a>&nbsp;(<%#DataBinder.Eval(Container.DataItem, "Total")%>)
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>              
            </asp:DataGrid>
            <div>&nbsp;</div>
          </td>
          <td style="width: 3px;">&nbsp;</td>
          <td>
            <div class="inputformsectionheader">
                <asp:Label ID="lblTicketCount" runat="server"></asp:Label>
            </div>
            <div class="inputform">
              <asp:DataGrid AllowSorting="true" ID="dgvBlackBookResults" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" CssClass="Grid1">
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:BoundColumn DataField="BlackBookID" HeaderText="ID" Visible="false" />
                  <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                      <a target="_blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
		            <asp:BoundColumn SortExpression="Created" HeaderText="Created" DataField="Created" />
                    <asp:BoundColumn SortExpression="BlackBookType" HeaderText="Type" DataField="BlackBookType" />
                    <asp:BoundColumn SortExpression="BlackBookIssue" HeaderText="Issue" DataField="BlackBookIssue" />
                    <asp:BoundColumn SortExpression="EnteredBy" HeaderText="EnteredBy" DataField="EnteredBy" />
                </Columns>
              </asp:DataGrid>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>