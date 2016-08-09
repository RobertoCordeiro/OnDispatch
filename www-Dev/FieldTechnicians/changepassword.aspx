<%@ Page Language="vb" masterpagefile="~/masters/FieldTechniciansdialog.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechniciansdialog.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Change Password"
      Master.PageTitleText = "Change Password"
    End If    
  End Sub
  
  Private Sub btnChange_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      wbl.Load(Master.WebLoginID)
      wbl.SetPassword(txtNewPassword.Text)
      divForm.Visible = False
      divResult.Visible = True
      Response.Redirect("settings.aspx")
    Else
      divError.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim strErrors As String = ""
    Dim blnReturn As Boolean = True
    Dim sec As New cvCommon.Validators
    If txtNewPassword.Text.Trim.Length = 0 Then
      strErrors &= "<li>New Password is Required</li>"
      blnReturn = False
    End If
    If txtOldPassword.Text.Trim.Length = 0 Then
      strErrors &= "<li>Old Password is Required</li>"
      blnReturn = False
    End If
    If txtConfirmPassword.Text.Trim.Length = 0 Then
      strErrors &= "<li>Confirm Password is Required</li>"
      blnReturn = False
    End If
    If txtOldPassword.Text.Trim = txtNewPassword.Text.Trim Then
      strErrors &= "<li>Old and New Passwords Can Not Match</li>"
      blnReturn = False
    End If
    If txtNewPassword.Text.Trim <> txtConfirmPassword.Text.Trim Then
      strErrors &= "<li>New Password and Confirm Password Do Not Match</li>"
      blnReturn = False
    End If
    If txtNewPassword.Text.Trim.Length > 0 And txtConfirmPassword.Text.Trim.Length > 0 Then
      If Not sec.IsValidPasswordFormat(txtNewPassword.Text.Trim) Then
        strErrors &= "<li>Password does not meet security policy requirements. Password must be at least 8 characters long, have both Upper and Lower case letters, and must contain at least one number</li>"
        blnReturn = False
      End If
    End If
    divError.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangePass" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
      <div class="errorzone" id="divError" runat="server" visible="false" />
      <div class="label">Old Password</div>
      <div><asp:TextBox style="width: 99%" ID="txtOldPassword" TextMode="password" runat="server" /></div>
      <div class="label">New Password</div>
      <div><asp:TextBox style="width: 99%" ID="txtNewPassword" TextMode="password" runat="server" /></div>
      <div class="label">Confirm Password</div>
      <div><asp:TextBox style="width:99%;" ID="txtConfirmPassword" TextMode="password" runat="server" /></div>
      <div style="font-style: italic">Passwords are CASE SENSITIVE</div>
      <div style="text-align: right"><asp:Button ID="btnChange" OnClick="btnChange_Click" runat="server" Text="Commit Change" /></div>     
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>&nbsp;</div>
      <div class="successtext">Success! Your password has been changed.</div>
    </div>
  </form>
</asp:Content>