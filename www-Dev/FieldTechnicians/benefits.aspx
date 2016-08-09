<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Benefits"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Benefits"
      Master.ActiveMenu = "TA"
    End If
  End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
 <form id="benefits1" runat="server">
  <div class="bandheader">List of Benefits</div>
  <div><asp:Label ID="lblCompanyName" runat="server" /> benefits are products and services that our partners can take advantage of through their membership in the partner network.</div>
  <div>
    <table style="width: 100%" cellpadding="0" cellspacing="0">
      <tbody>
        
        <tr class="altrow">
          <td class="label" colspan="3">RingCentral.com</td>
        </tr>
        <tr class="altrow">
          <td class="label">Type</td>
          <td>&nbsp;</td>
          <td>Get your own Toll Free or Local Number for as low as $9.99 per month.</td>
        </tr>
        <tr class="altrow">
          <td class="label">URL</td>
          <td>&nbsp;</td>
          <td><a href="http://www.kqzyfj.com/click-2417860-9823399" target="_blank" onmouseover="window.status='http://www.ringcentral.com';return true;" onmouseout="window.status=' ';return true;">www.RingCentral.com</a></td>
        </tr>        
      </tbody>
    </table>
  </div>
  </form>
</asp:Content>