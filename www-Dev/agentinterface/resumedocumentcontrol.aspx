<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">  

  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    Try
      _ID = Request.QueryString("id")
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Document Control"
      Master.PageTitleText = "Document Control"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""recruit.aspx"">Recruitment</a> &gt; <a href=""" & lblReturnUrl.Text & """>Resume</a> &gt; Document Control "
    End If
    If _ID > 0 Then
      LoadDocuments(_ID)
      divForm.Visible = True
    Else
      divForm.Visible = False
    End If
  End Sub
  
  Private Function IsAcceptableType(ByVal strExtension As String) As Boolean
    Dim blnReturn As Boolean = True
    Select Case strExtension.ToLower.Replace(".", "")
      Case "tif"
      Case "tiff"
      Case "jpg"
      Case "jpeg"
      Case "gif"
      Case "pdf"
      Case "png"
      Case Else
        blnReturn = False
        divErrors.InnerHtml = "<ul><li>File Type " & strExtension & " is not allowed, please convert the scanned image to an allowed type.</li></ul>"
        divErrors.Visible = True
    End Select
    Return blnReturn
  End Function
  
  Private Sub LoadDocuments(ByVal lngResumeID As Long)
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(lngResumeID)
    If rsm.DocumentsApproved Then
      btnDocumentsApproved.Visible = True
      btnDocumentsNotApproved.Visible = False
      lblApprovalStatus.Text = "Documents have been approved"
    Else
      lblApprovalStatus.Text = "Documents have NOT been approved"
      btnDocumentsNotApproved.Visible = True
      btnDocumentsApproved.Visible = False
    End If
    If rsm.BlankSignatureFileID > 0 Then
      lnkblankesig.href = "viewfile.aspx?id=" & rsm.BlankSignatureFileID
      btnRemoveBlankEsig.Enabled = True
    Else
      lnkBlankEsig.HRef = ""
      btnRemoveBlankEsig.Enabled = False
    End If
    If rsm.BlankNDAFileID > 0 Then
      lnkBlankNDA.HRef = "viewfile.aspx?id=" & rsm.BlankNDAFileID
      btnRemoveBlankNDA.Enabled = True
    Else
      btnRemoveBlankNDA.Enabled = False
      lnkBlankNDA.HRef = ""
    End If
    If rsm.DLFileID > 0 Then
      lnkDL.HRef = "viewfile.aspx?id=" & rsm.DLFileID
      btnRemoveDL.Enabled = True
    Else
      lnkBlankNDA.HRef = ""
      btnRemoveDL.Enabled = False
    End If
    If rsm.BlankWaiverFileID > 0 Then
      lnkBlankWaiver.HRef = "viewfile.aspx?id=" & rsm.BlankWaiverFileID
      btnRemoveBlankWaiver.Enabled = True
    Else
      btnRemoveBlankWaiver.Enabled = False
      lnkBlankWaiver.HRef = ""
    End If
    If rsm.BlankContractFileID > 0 Then
      lnkBlankContract.HRef = "viewfile.aspx?id=" & rsm.BlankContractFileID
      btnRemoveBlankContract.Enabled = True
    Else
      btnRemoveBlankContract.Enabled = False
      lnkBlankContract.HRef = ""
    End If
    If rsm.SignedNDAFileID > 0 Then
      lnkSignedNDA.HRef = "viewfile.aspx?id=" & rsm.SignedNDAFileID
      btnRemoveSignedNDA.Enabled = True
    Else
      btnRemoveSignedNDA.Enabled = False
      lnkSignedNDA.HRef = ""
    End If
    If rsm.SignedWaiverFileID > 0 Then
      lnkSignedWaiver.HRef = "viewfile.aspx?id=" & rsm.SignedWaiverFileID
      btnRemoveSignedWaiver.Enabled = True
    Else
      btnRemoveSignedWaiver.Enabled = False
      lnkSignedWaiver.HRef = ""
    End If
    If rsm.SignedContractFileID > 0 Then
      lnkSignedContract.HRef = "viewfile.aspx?id=" & rsm.SignedContractFileID
      btnRemoveSignedContract.Enabled = True
    Else
      btnRemoveSignedContract.Enabled = False
      lnkSignedContract.HRef = ""
    End If
    If rsm.SignatureFileID > 0 Then
      lnkSignedEsig.HRef = "viewfile.aspx?id=" & rsm.SignatureFileID
      btnRemoveSignedEsig.Enabled = True
    Else
      btnRemoveSignedEsig.Enabled = False
      lnkSignedEsig.HRef = ""
    End If
    If btnRemoveSignedContract.Enabled And btnRemoveSignedNDA.Enabled And btnRemoveSignedWaiver.Enabled And btnRemoveSignedEsig.Enabled Then
      btnDocumentsNotApproved.Enabled = True
    Else
      btnDocumentsNotApproved.Enabled = False
    End If
  End Sub
  
  Private Sub btnRemoveDL_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(_ID)
    rsm.DLFileID = 0
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    LoadDocuments(_ID)
  End Sub

  Private Sub btnRemoveBlankEsig_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(_ID)
    rsm.BlankSignatureFileID = 0
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    LoadDocuments(_ID)
  End Sub
  
  Private Sub btnRemoveBlankNDA_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(_ID)
    rsm.BlankNDAFileID = 0
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    LoadDocuments(_ID)
  End Sub

  Private Sub btnRemoveBlankContract_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(_ID)
    rsm.BlankContractFileID = 0
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    LoadDocuments(_ID)
  End Sub

  Private Sub btnRemoveBlankWaiver_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(_ID)
    rsm.BlankWaiverFileID = 0
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    LoadDocuments(_ID)
  End Sub

  Private Sub btnRemoveSignedNDA_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(_ID)
    rsm.SignedNDAFileID = 0
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    LoadDocuments(_ID)
  End Sub

  Private Sub btnRemoveSignedEsig_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(_ID)
    rsm.SignatureFileID = 0
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    LoadDocuments(_ID)
  End Sub
  
  Private Sub btnRemoveSignedContract_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(_ID)
    rsm.SignedContractFileID = 0
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    LoadDocuments(_ID)
  End Sub

  Private Sub btnRemoveSignedWaiver_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(_ID)
    rsm.SignedWaiverFileID = 0
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    LoadDocuments(_ID)
  End Sub

  Private Sub btnUploadContract_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strPath As String = Me.fupCounterSignedContract.FileName
    Dim strFileName As String = ""
    Dim strExtension As String = ""
    Dim strChangeLog As String = ""
    divErrors.Visible = False
    If strPath.Trim.Length > 0 Then
      strFileName = System.IO.Path.GetFileName(strPath)
      strExtension = System.IO.Path.GetExtension(strPath)
      If IsAcceptableType(strExtension) Then
        If fupCounterSignedContract.PostedFile.ContentLength > 0 Then
          Dim stm As System.IO.Stream
          Dim buf(fupCounterSignedContract.PostedFile.ContentLength) As Byte
          stm = fupCounterSignedContract.PostedFile.InputStream
          stm.Read(buf, 0, fupCounterSignedContract.PostedFile.ContentLength)
          Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
          fil.Add(2, strFileName, strExtension.Replace(".", ""), buf)
          Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          rsm.Load(_ID)
          rsm.SignedContractFileID = fil.FileID
          rsm.Save(strChangeLog)
          Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          Dim strIp As String = Request.QueryString("REMOTE_ADDR")
          Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
          If IsNothing(strIp) Then
            strIp = "unknown"
          End If
          If IsNothing(strType) Then
            strType = "web"
          End If
          act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
          LoadDocuments(_ID)
        Else
          divErrors.InnerHtml = "<ul><li>Empty File or File Does Not Exist, Please Check the File Name and Try Again.</li></ul>"
          divErrors.Visible = True
        End If
      End If
    Else
      divErrors.InnerHtml = "<ul><li>You must provide a path to the file you wish to upload</li></ul>"
      divErrors.Visible = True
    End If
  End Sub

  Private Sub btnUploadEsig_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strPath As String = Me.fupEsig.FileName
    Dim strFileName As String = ""
    Dim strExtension As String = ""
    Dim strChangeLog As String = ""
    divErrors.Visible = False
    If strPath.Trim.Length > 0 Then
      strFileName = System.IO.Path.GetFileName(strPath)
      strExtension = System.IO.Path.GetExtension(strPath)
      If IsAcceptableType(strExtension) Then
        If fupEsig.PostedFile.ContentLength > 0 Then
          Dim stm As System.IO.Stream
          Dim buf(fupEsig.PostedFile.ContentLength) As Byte
          stm = fupEsig.PostedFile.InputStream
          stm.Read(buf, 0, fupEsig.PostedFile.ContentLength)
          Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
          fil.Add(2, strFileName, strExtension.Replace(".", ""), buf)
          Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          rsm.Load(_ID)
          rsm.SignatureFileID = fil.FileID
          rsm.Save(strChangeLog)
          Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          Dim strIp As String = Request.QueryString("REMOTE_ADDR")
          Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
          If IsNothing(strIp) Then
            strIp = "unknown"
          End If
          If IsNothing(strType) Then
            strType = "web"
          End If
          act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
          LoadDocuments(_ID)
        Else
          divErrors.InnerHtml = "<ul><li>Empty File or File Does Not Exist, Please Check the File Name and Try Again.</li></ul>"
          divErrors.Visible = True
        End If
      End If
    Else
      divErrors.InnerHtml = "<ul><li>You must provide a path to the file you wish to upload</li></ul>"
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnUploadDL_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strPath As String = Me.fupDL.FileName
    Dim strFileName As String = ""
    Dim strExtension As String = ""
    Dim strChangeLog As String = ""
    divErrors.Visible = False
    If strPath.Trim.Length > 0 Then
      strFileName = System.IO.Path.GetFileName(strPath)
      strExtension = System.IO.Path.GetExtension(strPath)
      If IsAcceptableType(strExtension) Then
        If fupDL.PostedFile.ContentLength > 0 Then
          Dim stm As System.IO.Stream
          Dim buf(fupDL.PostedFile.ContentLength) As Byte
          stm = fupDL.PostedFile.InputStream
          stm.Read(buf, 0, fupDL.PostedFile.ContentLength)
          Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
          fil.Add(2, strFileName, strExtension.Replace(".", ""), buf)
          Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          rsm.Load(_ID)
          rsm.DLFileID = fil.FileID
          rsm.Save(strChangeLog)
          Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          Dim strIp As String = Request.QueryString("REMOTE_ADDR")
          Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
          If IsNothing(strIp) Then
            strIp = "unknown"
          End If
          If IsNothing(strType) Then
            strType = "web"
          End If
          act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
          LoadDocuments(_ID)
        Else
          divErrors.InnerHtml = "<ul><li>Empty File or File Does Not Exist, Please Check the File Name and Try Again.</li></ul>"
          divErrors.Visible = True
        End If
      End If
    Else
      divErrors.InnerHtml = "<ul><li>You must provide a path to the file you wish to upload</li></ul>"
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnUploadWaiver_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strPath As String = fupCounterSignedWaiver.FileName
    Dim strFileName As String = ""
    Dim strExtension As String = ""
    Dim strChangeLog As String = ""
    divErrors.Visible = False
    If strPath.Trim.Length > 0 Then
      strFileName = System.IO.Path.GetFileName(strPath)
      strExtension = System.IO.Path.GetExtension(strPath)
      If IsAcceptableType(strExtension) Then
        If fupCounterSignedWaiver.PostedFile.ContentLength > 0 Then
          Dim stm As System.IO.Stream
          Dim buf(fupCounterSignedWaiver.PostedFile.ContentLength) As Byte
          stm = fupCounterSignedWaiver.PostedFile.InputStream
          stm.Read(buf, 0, fupCounterSignedWaiver.PostedFile.ContentLength)
          Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
          fil.Add(2, strFileName, strExtension.Replace(".", ""), buf)
          Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          rsm.Load(_ID)
          rsm.SignedWaiverFileID = fil.FileID
          rsm.Save(strChangeLog)
          Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          Dim strIp As String = Request.QueryString("REMOTE_ADDR")
          Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
          If IsNothing(strIp) Then
            strIp = "unknown"
          End If
          If IsNothing(strType) Then
            strType = "web"
          End If
          act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
          LoadDocuments(_ID)
        Else
          divErrors.InnerHtml = "<ul><li>Empty File or File Does Not Exist, Please Check the File Name and Try Again.</li></ul>"
          divErrors.Visible = True
        End If
      End If
    Else
      divErrors.InnerHtml = "<ul><li>You must provide a path to the file you wish to upload</li></ul>"
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnUploadNDA_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strPath As String = fupCounterSignedNDA.FileName
    Dim strFileName As String = ""
    Dim strExtension As String = ""
    Dim strChangeLog As String = ""
    divErrors.Visible = False
    If strPath.Trim.Length > 0 Then
      strFileName = System.IO.Path.GetFileName(strPath)
      strExtension = System.IO.Path.GetExtension(strPath)
      If IsAcceptableType(strExtension) Then
        If fupCounterSignedNDA.PostedFile.ContentLength > 0 Then
          Dim stm As System.IO.Stream
          Dim buf(fupCounterSignedNDA.PostedFile.ContentLength) As Byte
          stm = fupCounterSignedNDA.PostedFile.InputStream
          stm.Read(buf, 0, fupCounterSignedNDA.PostedFile.ContentLength)
          Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
          fil.Add(2, strFileName, strExtension.Replace(".", ""), buf)
          Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          rsm.Load(_ID)
          rsm.SignedNDAFileID = fil.FileID
          rsm.Save(strChangeLog)
          Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          Dim strIp As String = Request.QueryString("REMOTE_ADDR")
          Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
          If IsNothing(strIp) Then
            strIp = "unknown"
          End If
          If IsNothing(strType) Then
            strType = "web"
          End If
          act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
          LoadDocuments(_ID)
        Else
          divErrors.InnerHtml = "<ul><li>Empty File or File Does Not Exist, Please Check the File Name and Try Again.</li></ul>"
          divErrors.Visible = True
        End If
      End If
    Else
      divErrors.InnerHtml = "<ul><li>You must provide a path to the file you wish to upload</li></ul>"
      divErrors.Visible = True
    End If
  End Sub

  Private Sub UpdateDocumentsApproved(ByVal bln As Boolean)
    Dim strChangeLog As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim rnt As New BridgesInterface.ResumeNoteRecord(rsm.ConnectionString)
    rsm.Load(_ID)
    rsm.DocumentsApproved = bln
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If    
    act.Add(2, "web", strType, strIp, "web", 23, rsm.ResumeID, strChangeLog)
    If bln Then
      rnt.Add(_ID, Master.UserID, "Documents Have Been Approved")
    Else
      rnt.Add(_ID, Master.UserID, "Documents Have Been Dis-Approved")
    End If
    LoadDocuments(_ID)
  End Sub
  
  Private Sub btnDocumentsApproved_Click(ByVal S As Object, ByVal E As EventArgs)
    UpdateDocumentsApproved(False)
  End Sub
  
  Private Sub btnDocumentsNotApproved_Click(ByVal S As Object, ByVal E As EventArgs)
    UpdateDocumentsApproved(True)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divForm" runat="server" style="width: 650px">
      <div>This form allows you to control the documents for a resume. You can remove documents, Upload Counter Signed Documents and view documents.</div>
      <div>&nbsp;</div>
      <div style="font-style: italic">NOTE: You should only remove documents that are incorrectly signed or uploaded, and you should always notify the applicant immediatley so that they know to re-upload a correctly filled out and signed document.</div>
      <div>&nbsp;</div>
      <div class="errorzone" id="divErrors" runat="server" visible="false" />
      <table>
        <tr>
          <td class="label" colspan="4">Docuemnts</td>
          <td class="label">Upload</td>
        </tr>
        <tr>
          <td><a id="lnkBlankEsig" runat="server">Blank E-Sig</a></td>
          <td><asp:Button OnClick="btnRemoveBlankEsig_Click" ID="btnRemoveBlankEsig" Text="Remove" runat="server" /></td>
          <td><a id="lnkSignedEsig" runat="server">Signed E-Sig</a></td>
          <td><asp:Button OnClick="btnRemoveSignedEsig_Click" ID="btnRemoveSignedEsig" Text="Remove" runat="server" /></td>
          <td><asp:FileUpload ID="fupEsig" runat="server" /><asp:Button ID="btnUploadEsig" OnClick="btnUploadEsig_Click" Text="Upload" runat="server" /></td>
        </tr>        
        <tr>
          <td><a id="lnkBlankContract" runat="server">UnSigned Contract</a></td>
          <td><asp:Button OnClick="btnRemoveBlankContract_Click" ID="btnRemoveBlankContract" Text="Remove" runat="server" /></td>
          <td><a id="lnkSignedContract" runat="server">Signed Contract</a></td>
          <td><asp:Button OnClick="btnRemoveSignedContract_Click" ID="btnRemoveSignedContract" Text="Remove" runat="server" /></td>
          <td><asp:FileUpload ID="fupCounterSignedContract" runat="server" /><asp:Button ID="btnUploadContract" OnClick="btnUploadContract_Click" Text="Upload" runat="server" /></td>
        </tr>                        
        <tr>
          <td><a id="lnkBlankNDA" runat="server">UnSigned NDA</a></td>
          <td><asp:Button OnClick="btnRemoveBlankNDA_Click" ID="btnRemoveBlankNDA" Text="Remove" runat="server" /></td>
          <td><a id="lnkSignedNDA" runat="server">Signed NDA</a></td>
          <td><asp:Button OnClick="btnRemoveSignedNDA_Click" ID="btnRemoveSignedNDA" Text="Remove" runat="server" /></td>
          <td><asp:FileUpload ID="fupCounterSignedNDA" runat="server" /><asp:Button ID="btnUploadNDA" OnClick="btnUploadNDA_Click" Text="Upload" runat="server" /></td>
        </tr>
        <tr>
          <td><a id="lnkBlankWaiver" runat="server">UnSigned Waiver</a></td>
          <td><asp:Button OnClick="btnRemoveBlankWaiver_Click" ID="btnRemoveBlankWaiver" Text="Remove" runat="server" /></td>
          <td><a id="lnkSignedWaiver" runat="server">Signed Waiver</a></td>
          <td><asp:Button OnClick="btnRemoveSignedWaiver_Click" ID="btnRemoveSignedWaiver" Text="Remove" runat="server" /></td>
          <td><asp:FileUpload ID="fupCounterSignedWaiver" runat="server" /><asp:Button ID="btnUploadWaiver" OnClick="btnUploadWaiver_Click" Text="Upload" runat="server" /></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><a id="lnkDL" runat="server">Drivers License</a></td>
          <td><asp:Button OnClick="btnRemoveDL_Click" ID="btnRemoveDL" Text="Remove" runat="server" /></td>
          <td><asp:FileUpload ID="fupDL" runat="server" /><asp:Button ID="btnUploadDL" OnClick="btnUploadDL_Click" Text="Upload" runat="server" /></td>
        </tr>  
      </table>
      <div class="label"><asp:Label ID="lblApprovalStatus" runat="server" /></div>
      <div><asp:Button ID="btnDocumentsApproved" OnClick="btnDocumentsApproved_Click" runat="server" Text="Un-Approve Documents" /><asp:Button ID="btnDocumentsNotApproved" OnClick="btnDocumentsNotApproved_Click" Text="Approve Documents" runat="server" /></div>
      <div style="font-style: italic">Do not mark documents approved until they are fully reviewed, countersigned, uploaded, and are fully complete.</div>      
      <div style="text-align: right;"><asp:Button ID="btnCancel" Text="Done" runat="server" OnClick="btnCancel_Click" /></div>
    </div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>