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
      lnkTrainingEmail.HRef = "mailto:" & System.Configuration.ConfigurationManager.AppSettings("TrainingEmail")
      lblTrainingEmail.Text = System.Configuration.ConfigurationManager.AppSettings("TrainingEmail")
      Dim strHeaderText As String = "Training Documents"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Master.WebLoginID = lgn.WebLoginID
        Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Training Documents]"
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
  <a class="selectedclienttablink" href="" id="lnkRequest" runat="server">[Document Summary]</a>
</asp:Content>
<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmRequest" runat="server">    
    <div style="text-align: center">There are no current documents associated with this customer. If you would like to submit documents please email them to <a id="lnkTrainingEmail" runat="server"><asp:Label ID="lblTrainingEmail" runat="server" /></a>.</div>
    
  </form>
</asp:Content>