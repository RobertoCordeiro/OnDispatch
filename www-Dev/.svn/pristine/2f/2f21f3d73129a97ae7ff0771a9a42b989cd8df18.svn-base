<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Assign Ticket Components"
      Master.PageTitleText = "Assign Ticket Components"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; <a href=""ticket.aspx?id=" & _ID & """>Ticket</a> &gt; Assign Ticket Components"
    End If
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadTicketComponents(_ID)
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadTicketComponents(ByVal lngTicketID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListTicketComponents", "@TicketID", lngTicketID, dgvComponents)
    Dim drp As New System.Web.UI.WebControls.DropDownList
    dim cpt as New BridgesInterface.TicketComponentRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm As DataGridItem In dgvComponents.Items
      cpt.Load(CType(itm.Cells(0).Text, Long))
      drp = itm.FindControl("drpWorkOrder")
      LoadWorkOrders(cpt.TicketID, drp)
      drp.SelectedValue = cpt.WorkOrderID
    Next
  End Sub
  
  Private Sub LoadWorkOrders(ByVal lngTicketID As Long, ByVal drp As System.Web.UI.WebControls.DropDownList)
    Dim itm As New ListItem
    itm.Text = "None"
    itm.Value = 0
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListWorkOrders", "@TicketID", lngTicketID, "WorkOrderID", "WorkOrderID", drp)
    drp.Items.Add(itm)
  End Sub
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim drp As System.Web.UI.WebControls.DropDownList
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cpt As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    For Each itm As DataGridItem In dgvComponents.Items
      cpt.Load(CType(itm.Cells(0).Text, Long))
      drp = itm.FindControl("drpWorkOrder")
      cpt.WorkOrderID = drp.SelectedValue
      cpt.Save(strChangeLog)
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID, 35, cpt.TicketComponentID, strChangeLog)
    Next
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <asp:DataGrid ID="dgvComponents" runat="server" AutoGenerateColumns="false" style="width: 100%; background-color: White;">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />
      <Columns>      
        <asp:BoundColumn DataField="TicketComponentID" Visible="false" />
        <asp:BoundColumn DataField="Code" HeaderText="Code/SKU" />
        <asp:BoundColumn DataField="Component" HeaderText="Component Name" />
        <asp:BoundColumn DataField="SerialNumber" HeaderText="Serial Number" />
        <asp:BoundColumn DataField="Notes" HeaderText="Notes" />
        <asp:BoundColumn DataField="DateDelivered" HeaderText="Delivered" />
        <asp:BoundColumn DataField="Consumable" HeaderText="Consumable" />
        <asp:TemplateColumn HeaderText="Work Order">
          <ItemTemplate>
            <asp:DropDownList ID="drpWorkOrder" runat="server" />
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>    
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOK" runat="server" Text="OK" OnClick="btnOK_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>