<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Priority Lookup"
      Master.PageTitleText = "Priority Lookup"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Priority Lookup"
      Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ldr.LoadSimpleDataGrid("spListPriorities", dgvPriorities)
    End If
  End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <div>&nbsp;</div>
  <div style="text-align: center;">
    <asp:DataGrid AutoGenerateColumns="false" ID="dgvPriorities" style="margin-left: auto; margin-right: auto;" runat="server">
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:BoundColumn DataField="PriorityID" HeaderText="Priority" />
        <asp:BoundColumn DataField="Description" HeaderText="Description" />
        <asp:TemplateColumn HeaderText="Emblem">
          <ItemTemplate>
            <img src="/graphics/level<%# databinder.eval(container.DataItem,"PriorityID") %>.png" alt="emblem" />
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
  </div>
</asp:Content>