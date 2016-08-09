<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Resume Type Statistics"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Resume Type Statistics"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""reports.aspx"">Reports</a> &gt; Resume Type Statistics"
    End If
    LoadStats()
  End Sub
  
  Private Sub LoadStats()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListResumeTypeStats", dgvTypeStatistics)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <asp:DataGrid ID="dgvTypeStatistics" runat="server" AutoGenerateColumns="false">
    <HeaderStyle CssClass="gridheader" />
    <AlternatingItemStyle CssClass="altrow" />
    <Columns>
      <asp:BoundColumn DataField="ResumeTypeID" HeaderText="ID" Visible="false" />
      <asp:BoundColumn DataField="ResumeType" HeaderText="Type" />
      <asp:BoundColumn DataField="ResumeCount" HeaderText="Count" />
    </Columns>
  </asp:DataGrid>
  
</asp:Content>