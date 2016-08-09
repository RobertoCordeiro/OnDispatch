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
      Dim strHeaderText As String = "Surveys"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Master.WebLoginID = lgn.WebLoginID
        Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Surveys]"
        Master.PageHeaderText = strHeaderText
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else
      Response.Redirect("/login.aspx", True)
    End If
  End Sub
  
  
</script>

<asp:Content ContentPlaceHolderID="headermenucontent" runat="server">
  <a class="selectedclienttablink" href="surveys.aspx" id="lnkRequest" runat="server">[Survey Summary]</a>
</asp:Content>
<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmRequest" runat="server">    
    <div>&nbsp;</div>
    <div style="text-align: center;">There are no filled out surveys currently available for this customer.</div>
    <div style="text-align: center;"><a target="_blank" href="samplesurvey.aspx">[Sample Survey]</a></div>
  </form>
</asp:Content>