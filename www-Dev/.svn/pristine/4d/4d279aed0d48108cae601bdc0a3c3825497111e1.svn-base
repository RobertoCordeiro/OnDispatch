<%@ Page Language="VB" masterpagefile="~/masters/customer.master"%>
<%@ MasterType VirtualPath="~/masters/customer.master" %>
<%@ Register Src="~/controls/ticket.ascx" TagName="Ticket" TagPrefix="cv" %>
<script language="VB" runat="server">
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strMode As String = ""
      Master.ActiveMenu = "C"
      If CType(Request.QueryString("mode"), String) <> "" Then
        strMode = Request.QueryString("mode")
      End If
      Dim strHeaderText As String = "Coverage"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Master.WebLoginID = lgn.WebLoginID
        Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Coverage]"
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
  Private Sub btnCheck_Click(ByVal S As Object, ByVal E As EventArgs)
    If txtZipCode.Text.Trim.Length > 0 Then
      trErrors.Visible = False
      'DisplayZip(txtZipCode.Text)
      fraticket.Attributes ("src") = "coveragedetail.aspx?zip=" & txtZipCode.text
      'divForm.Visible = False
    Else
      divErrors.InnerHtml = "<ul><li>Zip Code is Required</li></ul>"
      trErrors.Visible = True
    End If
  End Sub
</script>


<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmCoverage" runat="server">
  <div id="divForm" runat="server" class="minHeight" style="width:28%;">
    
      <table class="inputform" style="margin-right: auto; margin-left: auto;">
        <tbody>
          <tr>
            <td class="inputformsectionheader">Zip Code Coverage Look Up</td>
          </tr>
          <tr>
            <td class="label">Zip Code</td>            
          </tr>
          <tr>
            <td style="padding-right: 4px"><asp:TextBox width="100%" MaxLength="16" ID="txtZipCode" runat="server" /></td>
          </tr>
          <tr>
            <td style="text-align: right;"><asp:Button ID="btnCheck" OnClick="btnCheck_Click" Text="Check" runat="server" /></td>
          </tr>
          <tr id="trErrors" runat="server" visible="false">
            <td class="errorzone"><div id="divErrors" runat="server" /></td>
          </tr>
        </tbody>        
      </table>
    </div> 
    
  <div><iframe id="fraticket" runat="server" src="/images/Full_coverage_florida1.jpg" width="72%" height="750px"  marginwidth="0" marginheight="0" frameborder="0"  ></iframe></div>
  <div style="text-align: center;"><asp:Label ID="lblCompanyName" runat="server" visible="False"/><asp:label ID="lblNewCount" runat="server" Visible="false" /> </div>
  </form>
</asp:Content>