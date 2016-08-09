<%@ Page Language="VB" masterpagefile="~/masters/customer.master"%>
<%@ MasterType VirtualPath="~/masters/customer.master" %>
<%@ Register Src="~/controls/ticket.ascx" TagName="Ticket" TagPrefix="cv" %>
<script language="VB" runat="server">
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strMode As String = ""
      If CType(Request.QueryString("mode"), String) <> "" Then
        strMode = Request.QueryString("mode")
      End If
      Dim strHeaderText As String = "Logistics / Inventory"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Master.WebLoginID = lgn.WebLoginID
        Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Logistics / Inventory]"
        Master.PageHeaderText = strHeaderText
        LoadInventory()
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else
      Response.Redirect("/login.aspx", True)
    End If
  End Sub

  Private Sub LoadInventory()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListInventory", dgvInventory)
  End Sub
  
  
</script>

<asp:Content ContentPlaceHolderID="headermenucontent" runat="server">
  <a class="selectedclienttablink" href="logistics.aspx" id="lnkRequest" runat="server">[Inventory]</a>
</asp:Content>
<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmRequest" runat="server">    
    <asp:DataGrid ID="dgvInventory" Width="100%" runat="server" AutoGenerateColumns="false">
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:BoundColumn HeaderText="ID" DataField="InventoryID" Visible="false" />
        <asp:BoundColumn HeaderText="SKU" DataField="SKU" />
        <asp:BoundColumn DataField="Description" Headertext="Description" />
        <asp:BoundColumn HeaderText="BarCode Type" DataField="BType" />
        <asp:BoundColumn HeaderText="Stock" datafield="InStock" />
        <asp:BoundColumn HeaderText="Ordered" DataField="OnOrder" />
        <asp:BoundColumn HeaderText="Back Ordered" DataField="BackOrdered" />
        <asp:BoundColumn HeaderText="Reserved" DataField="Reserved" />
        <asp:BoundColumn HeaderText="Price" DataField="PricePerUnit" />        
      </Columns>
    </asp:DataGrid>
    
  </form>
</asp:Content>