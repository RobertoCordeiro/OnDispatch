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
      Dim strHeaderText As String = "Pricing Request"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Master.WebLoginID = lgn.WebLoginID
        Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Pricing Request]"
        Master.PageHeaderText = strHeaderText
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else
      Response.Redirect("/login.aspx", True)
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtTitle.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Request Reason is Required</li>"
    End If
    If txtDetail.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Detail is Required</li>"
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
      Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cag.Load(Master.CustomerAgentID)
      eml.Body = "<div>Part SKU: " & txtPartSKU.Text & " </div>"
      eml.Body &= "<div>Service SKU: " & txtServiceSKU.Text & " </div>"
      eml.Subject = txtTitle.Text
      eml.SendTo = "info@bestservicers.com"
      If cag.Email.Trim.Length > 0 Then
        eml.SendFrom = cag.Email
      Else
        eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("DefaultContactEmail")
      End If
      eml.Send()
      divForm.Visible = False
      divSent.Visible = True
      divErrors.Visible = False
    Else
      divErrors.Visible = True
    End If
  End Sub
  
</script>

<asp:Content ContentPlaceHolderID="headermenucontent" runat="server">
  <a class="selectedclienttablink" href="pricingrequest.aspx" id="lnkRequest" runat="server">[Request Form]</a>
</asp:Content>
<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmRequest" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div id="divForm" runat="server">
      <div class="label">Request Reason</div>
      <asp:TextBox ID="txtTitle" runat="server" Width="99%" />
      <table>
        <tbody>
          <tr>
            <td class="label">Service SKU</td>
            <td>&nbsp;</td>
            <td class="label">Part SKU</td>
          </tr>
          <tr>
            <td><asp:TextBox ID="txtServiceSKU" runat="server" /></td>
            <td>&nbsp;</td>
            <td><asp:TextBox ID="txtPartSKU" runat="server" /></td>
          </tr>
        </tbody>
      </table>
      <div class="label">Request Detail</div>
      <asp:TextBox ID="txtDetail" runat="server" TextMode="MultiLine" Height="400px" Width="99%" />
      <div>&nbsp;</div>
      <div style="text-align: right;"><asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" /></div>
    </div>
    <div id="divSent" runat="server" visible="false" style="text-align: center;">Your request has been sent, an agent will respond to you shortly.</div>
  </form>
</asp:Content>