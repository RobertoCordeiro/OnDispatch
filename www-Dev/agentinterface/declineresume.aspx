<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">  
  Private _ID As Long = 0
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Decline Resume"
      Master.PageTitleText = "Decline Resume"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""recruit.aspx"">Recruitement</a> &gt; <a href=""resume.aspx?resumeid=" & Request.QueryString("id") & """>View Resume</a> &gt; Decline Resume"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    If _ID <= 0 Then
      frmDialog.Visible = False
    End If
    lblResumeID.Text = _ID.ToString
    lblReturnUrl.Text = Request.QueryString("returnurl")
  End Sub
  
  Private Sub btnCancel_Click(ByVal s As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If txtReason.Text.Trim.Length > 0 Then
      Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim act As New BridgesInterface.ActionRecord(rsm.ConnectionString)
      Dim rnt As New BridgesInterface.ResumeNoteRecord(rsm.ConnectionString)
      Dim strChangeLog As String = ""
      rsm.Load(_ID)
      rsm.Declined = True
      
      rsm.RemoveFromFolder(34)
      rsm.RemoveFromFolder(25)
      rsm.RemoveFromFolder(26)
      rsm.RemoveFromFolder(27)
      rsm.RemoveFromFolder(28)
      rsm.RemoveFromFolder(29)
      rsm.Save(strChangeLog)
      rnt.Add(rsm.ResumeID, Master.UserID, "This Resume was Declined Because:" & txtReason.Text.Trim)
      act.Add(Master.UserID, "web", "web", "web", "web", 23, rsm.ResumeID, strChangeLog)
      Response.Redirect(lblReturnUrl.Text)
    Else
      divError.InnerHtml = "<ul><li>Reason is Required</li></ul>"
      divError.Visible = True
    End If
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divError" runat="server" class="errorzone" visible="false"/>
    <div class="label">Reason for declining resume <asp:Label ID="lblResumeID" runat="server" /></div>
    <asp:TextBox ID="txtReason" TextMode="MultiLine" style="width: 99%; height:100px" runat="server" />
    <div style="text-align: right"><asp:Button ID="btnCancel" Text="Cancel" runat="server" OnClick="btnCancel_Click" />&nbsp;<asp:Button ID="btnDecline" Text="Decline" runat="server" OnClick="btnSubmit_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>