<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
 
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Add Recruitment Campaign"
      Master.PageTitleText = " Add Recruitment Campaign"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""recruit.aspx"">Recruitment</a> &gt; Add Recruitment Campaign"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtDescription.Text.Trim.Length = 0 Then
      strErrors &= "<li>Campaign Name Is Required</li>"
      blnReturn = False
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub btnOk_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim cmp As New BridgesInterface.RecruitmentCampaignRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cmp.Add(Master.UserID, txtDescription.Text)
      Response.Redirect("recruitmentcampaign.aspx?id=" & cmp.RecruitmentCampaignID, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="label">Campaign Name</div>
    <asp:TextBox ID="txtDescription" runat="server" style="width: 100%" />
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOk" Text="Create" OnClick="btnOK_Click" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>