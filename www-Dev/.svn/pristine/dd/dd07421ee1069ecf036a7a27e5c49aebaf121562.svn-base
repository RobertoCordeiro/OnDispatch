<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">  
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    Dim lng As Long = 0
    Try
      If Long.TryParse(Request.QueryString("id"), lng) Then
        _ID = lng
      Else
        _ID = 0
      End If
    Catch ex As Exception
      _ID = 0
    End Try      
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Reset Password"
      Master.PageTitleText = "Reset Password"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""recruit.aspx"">Recruitment</a> &gt; <a href=""" & Request.QueryString("returnul") & """>Resume</a> &gt; Reset Password"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    DisplayAppropriateForm()
  End Sub
  
  Private Sub DisplayAppropriateForm()
    If _ID > 0 Then
      Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      rsm.Load(_ID)
      If rsm.ResumeID > 0 Then
        If rsm.WebLoginID > 0 Then
          divNoWebLoginNotice.Visible = False
          divResetPassword.Visible = True
        Else
          divNoWebLoginNotice.Visible = True
        End If
      Else
        divNoWebLoginNotice.Visible = True
      End If
    Else
      divNoWebLoginNotice.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim usr As New BridgesInterface.UserRecord(rsm.ConnectionString)
      Dim wbl As New BridgesInterface.WebLoginRecord(rsm.ConnectionString)
      Dim act As New BridgesInterface.ActionRecord(rsm.ConnectionString)
      Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
      Dim doc As New BridgesInterface.DocumentRecord(rsm.ConnectionString)
      Dim rnt As New BridgesInterface.ResumeNoteRecord(rsm.ConnectionString)
      Dim strChangeLog As String = ""
      Dim strEmailFrom As String = System.Configuration.ConfigurationManager.AppSettings("RecruiterEmail")
      Dim strArchiveEmail As String = System.Configuration.ConfigurationManager.AppSettings("ArchiveEmail")
      Dim strEmail As String = ""
      rsm.Load(_ID)
      wbl.Load(rsm.WebLoginID)
      usr.Load(Master.UserID)
      wbl.SetPassword(txtNewPassword.Text.Trim)
      wbl.Save(strChangeLog)
      doc.Load(5) '5 is the password changed document   
      strEmail = doc.DocumentText
      strEmail = strEmail.Replace("$name", rsm.NameTag)
      strEmail = strEmail.Replace("$username", wbl.Login)
      strEmail = strEmail.Replace("$password", txtNewPassword.Text.Trim)
      strEmail = strEmail.Replace("$link", System.Configuration.ConfigurationManager.AppSettings("LoginFormPath"))
      If usr.Signature.Trim.Length > 0 Then
        strEmail = strEmail.Replace("$signature", usr.Signature)
      Else
        strEmail = strEmail.Replace("$signature", usr.FirstName & " " & usr.LastName)
      End If
      eml.BCC = strArchiveEmail
      eml.Subject = "Password Reset"
      eml.SendTo = rsm.Email
      eml.SendFrom = strEmailFrom
      eml.Body = strEmail
      eml.HTMLBody = True
      eml.Send()
      act.Add(Master.UserID, "web", "web", "web", "web", 21, wbl.WebLoginID, strChangeLog)      
      rnt.Add(rsm.ResumeID, Master.UserID, "Password Reset")
      divErrors.Visible = False
      Response.Redirect(lblReturnUrl.Text)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtNewPassword.Text.Trim.Length = 0 Then
      strErrors &= "<li>New Password is Required</li>"
      blnReturn = False
    End If
    If txtConfirmPassword.Text.Trim.Length = 0 Then
      strErrors &= "<li>Confirmation Password is Required</li>"
      blnReturn = False
    End If
    If (txtConfirmPassword.Text.Trim & txtNewPassword.Text.Trim).Length > 0 Then
      If txtConfirmPassword.Text.Trim <> txtNewPassword.Text.Trim Then
        strErrors &= "<li>Password do not Match</li>"
        blnReturn = False
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" runat="server" id="divErrors" visible="false" />
    <div id="divNoWebLoginNotice" visible="false" runat="server">
      This resume has not yet been assigned a log in (sent to phase 2) and as such can not have its password reset.
      <div style="text-align: right;"><asp:Button ID="btnCancelNoID" OnClick="btnCancel_Click" runat="server" /></div>
    </div>
    <div id="divResetPassword" visible="false" runat="server">
      <div class="label">New Password</div>
      <asp:textbox ID="txtNewPassword" runat="server" style="width: 95%" />
      <div class="label">Concirm Password</div>
      <asp:TextBox ID="txtConfirmPassword" runat="server" style="width: 95%" />
      <div style="text-align: right;"><asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button ID="btnSubmit" runat="server" Text="Reset" OnClick="btnSubmit_Click"/></div>
    </div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>