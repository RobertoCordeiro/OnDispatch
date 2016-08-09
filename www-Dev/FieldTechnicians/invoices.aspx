<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Invoices"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Invoices"
      Master.ActiveMenu = "J"
    End If
  End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
 <form id="invoices1" runat="server">
  <div class="empty">&nbsp;</div>
  <div class="payschedule">
  <h1>Payment Schedule</h1>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Jan 1st - Jan 31st:</b> <br />You should be receiving the payment on Feb 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Feb 1st - Feb 29th:</b> <br />You should be receiving the payment on Mar 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Mar 1st - Mar 31st:</b> <br />You should be receiving the payment on Apr 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Apr 1st - Apr 31st:</b> <br />You should be receiving the payment on May 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between May 1st - May 31st:</b> <br />You should be receiving the payment on Jun 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Jun 1st - Jun 31st:</b> <br />You should be receiving the payment on Jul 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Jul 1st - Jul 31st:</b> <br />You should be receiving the payment on Aug 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Aug 1st - Aug 31st:</b> <br />You should be receiving the payment on Sep 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Sep 1st - Sep 31st:</b> <br />You should be receiving the payment on Oct 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Oct 1st - Oct 31st:</b> <br />You should be receiving the payment on Nov 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Nov 1st - Nov 31st:</b> <br />You should be receiving the payment on Dec 20th</div>
  <div>&nbsp;</div>
  <div><b>All tickets completed between Dec 1st - Dec 31st:</b> <br />You should be receiving the payment on Jan 20th</div>
  </div>
  
  
  
  
  
  
  
  
  
  
  
 </form>
</asp:Content>