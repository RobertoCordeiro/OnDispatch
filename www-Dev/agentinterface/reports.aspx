<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Reports"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Reports"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Reports"
    End If
  End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <div class="label">Resumes</div>
  <ul>
    <li><a href="resumesinzipreport.aspx">Resumes In Zip Code</a></li>
    <li><a href="resumetypestatistics.aspx">Type Statistics</a></li>
  </ul>
  <div class="label">Partners</div>
  <ul>
    <li><a href="noagentshippingaddresses.aspx">Shipping Locations With No Agents Assigned</a></li>
    <li><a href="skillsetreport.aspx">Skill Sets</a></li>
  </ul>
  <div class="label">Geographic Area</div>
  <ul>
    <li><a href="noagentshippingaddresses.aspx">List of Geographic Areas</a></li>
    <li><a href="skillsetreport.aspx">Counties Not Assigned</a></li>
  </ul>
</asp:Content>