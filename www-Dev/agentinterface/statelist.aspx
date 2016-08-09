<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "State List"
      Master.PageTitleText = "State List"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; State List"
    End If
    LoadStates()
  End Sub
  
  Private Sub LoadStates()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListStatesWithAllInformation", dgvStates)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmStateList" runat="server">
    <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvStates" runat="server">
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:BoundColumn ItemStyle-Width="1%" HeaderText="Abbreviation" DataField="Abbreviation" />
        <asp:BoundColumn HeaderText="State Name" DataField="StateName" />
      </Columns>
    </asp:DataGrid>    
  </form>
</asp:Content>