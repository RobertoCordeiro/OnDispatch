<%@ Page Language="VB" masterpagefile="~/masters/agent.master"%>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<%@ Register Src="~/controls/ticket.ascx" TagName="Ticket" TagPrefix="cv" %>
<script language="VB" runat="server">
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strMode As String = ""
      If CType(Request.QueryString("mode"), String) <> "" Then
        strMode = Request.QueryString("mode")
      End If
      Dim strHeaderText As String = "Coverage"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Master.WebLoginID = lgn.WebLoginID
                Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Coverage"
        Master.PageHeaderText = strHeaderText
        lblCompanyName.Text = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
        LoadCount()
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else
      Response.Redirect("/login.aspx", True)
    End If
  End Sub
  
  Private Sub LoadCount()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTodaysNewResumeCount")
    cmd.CommandType = Data.CommandType.StoredProcedure
    Dim lng As Long = 0
    cnn.Open()
    cmd.Connection = cnn
    lng = CType(cmd.ExecuteScalar, Long)
    cnn.Close()
    lblNewCount.Text = lng
  End Sub
  
</script>

<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmCoverage" runat="server">    
  <div style="text-align: center;" class="ticketsectionheader">Coverage Map</div>
  <div style="text-align: center"><img src="/graphics/currentmap.png" alt="coverage" /></div>
  <div style="text-align: center;"><asp:Label ID="lblCompanyName" runat="server" />'s Network is growing EVERY DAY! <asp:label ID="lblNewCount" runat="server" /> new member(s) have signed up today!</div>
  </form>
</asp:Content>