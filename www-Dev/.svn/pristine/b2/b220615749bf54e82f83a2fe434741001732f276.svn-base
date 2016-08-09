<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">  
  
  Private Const Phase2EmailDocument As Integer = 1
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Send to Phase 2"
      Master.PageTitleText = "Send to Phase 2"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""recruit.aspx"">Recruitment</a> &gt; Send to Phase 2"
    End If
    Try
      _ID = Request.QueryString("id")
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal e As EventArgs)
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim rsm As New BridgesInterface.ResumeRecord(wbl.ConnectionString)
    Dim doc As New BridgesInterface.DocumentRecord(wbl.ConnectionString)
    Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
    Dim usr As New BridgesInterface.UserRecord(wbl.ConnectionString)
    Dim act As New BridgesInterface.ActionRecord(wbl.ConnectionString)
    Dim rnt As New BridgesInterface.ResumeNoteRecord(wbl.ConnectionString)
    Dim rrt As New BridgesInterface.ResumeRateRecord(wbl.ConnectionString)
    usr.Load(Master.UserID)
    Dim cvs As New cvCommon.Security
    rsm.Load(_ID)
    doc.Load(Phase2EmailDocument)
    Dim strLoginPath As String = System.Configuration.ConfigurationManager.AppSettings("LoginFormPath")
    Dim strEmailFrom As String = System.Configuration.ConfigurationManager.AppSettings("RecruiterEmail")
    Dim strArchiveEmail As String = System.Configuration.ConfigurationManager.AppSettings("ArchiveEmail")
    Dim dblRate As Double = CType(System.Configuration.ConfigurationManager.AppSettings("DefaultRecruitmentRate"), Double)
    Dim strChangeLog As String = ""
    Dim strBody As String = doc.DocumentText
    Dim strPassword As String = cvs.RandomPassword
    wbl.Load(_ID.ToString)
    If wbl.WebLoginID <= 0 Then
      wbl.Add(Master.UserID, _ID.ToString, strPassword, "R")
      Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim cmd As New System.Data.SqlClient.SqlCommand("spListActiveRateTypes")
      cmd.CommandType = Data.CommandType.StoredProcedure
      cnn.Open()
      cmd.Connection = cnn
      Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
      While dtr.Read
        rrt.Add(Master.UserID, CType(dtr("RateTypeID"), Long), CType(dtr("DefaultRate"), Long), CType(dtr("Hourly"), Boolean), rsm.ResumeID)
      End While
      cnn.Close()
    Else
      wbl.AccessCoding = "R"
      wbl.SetPassword(strPassword)
      wbl.Save(strChangeLog)
      act.Add(Master.UserID, "web", "web", "web", "web", 21, wbl.WebLoginID, strChangeLog)
    End If
    rsm.WebLoginID = wbl.WebLoginID
    rsm.Save(strChangeLog)
    act.Add(Master.UserID, "web", "web", "web", "web", 23, rsm.ResumeID, strChangeLog)
    strBody = strBody.Replace("$firstname", rsm.FirstName)
    strBody = strBody.Replace("$lastname", rsm.LastName)
    strBody = strBody.Replace("$link", "<a href=""" & strLoginPath & """>" & strLoginPath & "</a>")
    strBody = strBody.Replace("$resumeid", rsm.ResumeID.ToString)
    strBody = strBody.Replace("$password", strPassword)
    If usr.Signature.Trim.Length > 0 Then
      strBody = strBody.Replace("$signature", usr.Signature)
    Else
      strBody = strBody.Replace("$signature", usr.FirstName & " " & usr.LastName)
    End If
    eml.BCC = strArchiveEmail
        eml.Subject = "Welcome - First Step in the process...!"
    eml.SendTo = rsm.Email
    eml.SendFrom = strEmailFrom
    eml.Body = strBody
    eml.HTMLBody = True
    eml.Send()
    rnt.Add(rsm.ResumeID, Master.UserID, "This Resume Has Been Sent to Phase 2")
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div style="width: 300px;">
      <p>By sending this resume to Phase 2 you are creating a user name and password for this resume. An email will be sent to the email on file with instructions on how to log in to the system. If this resume has already been sent to phase 2 the password will be reset and a new email will be sent.</p>
      <div>Are you sure you wish to continue</div>
      <div style="text-align:right;"><asp:Button ID="btnCancel" Text="No" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button ID="btnSubmit" Text="Yes" OnClick="btnSubmit_Click" runat="server" /></div>
      <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    </div>
  </form>
</asp:Content>