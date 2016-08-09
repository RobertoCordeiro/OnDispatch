<%@ Page Language="VB" masterpagefile="~/masters/cust.master"%>
<%@ MasterType VirtualPath="~/masters/cust.master" %>
<script language="VB" runat="server">

  Private _TicketFolderID As Long = 0
  Private _ServiceTypeID As Long = 0

  Private Sub btnExport_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect("ticketfolderexport.aspx?id=" & _TicketFolderID & "&sid=" & _ServiceTypeID, True)
  End Sub
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strMode As String = ""
      Dim strHeaderText As String = "Tickets In Folder"
      Try
        _TicketFolderID = CType(Request.QueryString("id"), Long)
        _ServiceTypeID = CType(Request.QueryString("sid"), Long)
      Catch ex As Exception
        _TicketFolderID = 0
        _ServiceTypeID = 0
      End Try
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        If lgn.AccessCoding.Contains("C") Then
          Master.WebLoginID = lgn.WebLoginID
          'Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Tickets In Folder]"
          'Master.PageHeaderText = strHeaderText
          If Not IsPostBack Then
            Secure()
            LoadList()
            'LoadLabel()
          End If
        Else
          Response.Redirect("/login.aspx", True)
        End If
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else      
      Response.Redirect("/login.aspx", True)
    End If
  End Sub

  Private Sub Secure()
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cag.Load(Master.CustomerAgentID)
    divList.Visible = cag.AssignedToServiceType(_ServiceTypeID)
    divNoAccess.Visible = Not divList.Visible
  End Sub
  
  Private Sub LoadList()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadTwoLongParameterDataGrid("spListTicketsForServiceTypeAndFolder", "@TicketFolderID", _TicketFolderID, "@ServiceTypeID", _ServiceTypeID, dgvList)
  End Sub
  
  Private Sub dgvList_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvList.ItemDataBound
    If e.Item.ItemType = ListItemType.Header Then
      Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cst.Load(Master.CustomerID)
      For Each cel As System.Web.UI.WebControls.TableCell In e.Item.Cells
        If cel.Text = "RefLabel1" Then
          cel.Text = cst.Ref1Label
        End If
      Next
    End If
  End Sub
  
  Private Sub LoadLabel()
    Dim stp As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    stp.Load(_ServiceTypeID)
    lblServiceType.Text = stp.ServiceType & " - Total Calls: [ " & CType(dgvList.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "
   
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmList" runat="server">
    <div id="divList" runat="server" visible="True">
      <div class="ticketformsectionheader" style="width:99%; text-align:center;"><asp:Label ID="lblServiceType" runat="server" /></div>
      <asp:DataGrid ID="dgvList"  runat="server" style="width: 99%" AutoGenerateColumns="false">
        <AlternatingItemStyle CssClass="altrow" />
        <HeaderStyle CssClass="gridheader" />
        <Columns>
          <asp:BoundColumn HeaderText="Ticket ID" DataField="TicketID" Visible="false" />
          <asp:TemplateColumn HeaderText="Ticket ID">
            <ItemTemplate>
              <a href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:BoundColumn headertext="Status" DataField="Status" visible="False"/>
          <asp:TemplateColumn HeaderText="CustomerPO">
            <ItemTemplate>
              <%#DataBinder.Eval(Container.DataItem, "ReferenceNumber2")%>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:TemplateColumn HeaderText="CustomerNumber">
            <ItemTemplate>
              <%#DataBinder.Eval(Container.DataItem, "ReferenceNumber1")%>
            </ItemTemplate>
          </asp:TemplateColumn>              
          <asp:TemplateColumn HeaderText="End User">
            <ItemTemplate>
              <%# DataBinder.Eval(Container.DataItem,"ContactFirstName") %> <%# DataBinder.Eval(Container.DataItem,"ContactMiddleName") %> <%# DataBinder.Eval(Container.DataItem,"ContactLastName") %>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:BoundColumn HeaderText="Service SKU" DataField="ServiceName" />
          <asp:TemplateColumn HeaderText="Priority" >
          <ItemTemplate>
            <img alt="Priority" src="../graphics/level<%# Databinder.eval(Container.DataItem,"CustomerPrioritySetting") %>.png" />          
          </ItemTemplate>
          </asp:TemplateColumn>
          <asp:BoundColumn HeaderText="Schedule Start" DataField="ScheduledDate" />
          <asp:BoundColumn HeaderText="Schedule End" DataField="ScheduledEndDate" />        
          <asp:BoundColumn HeaderText="Date Created" DataField="DateCreated" />
        </Columns>    
      </asp:DataGrid>
    </div>
    <div style="text-align: right;"><asp:Button ID="btnExport" runat="server" Text="export" OnClick="btnExport_Click" visible = "False" /></div>
    <div id="divNoAccess" runat="server" visible="false">
      <div style="text-align: center;">We're sorry your account does not have sufficient access to use this feature. Please see your account administrator for more information.</div>
    </div>
  </form>
  </asp:Content>
