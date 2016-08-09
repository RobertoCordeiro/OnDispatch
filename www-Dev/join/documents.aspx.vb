''' <summary>
''' A page that allows a user to add upload and electonically sign documents relating to his contract
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class Documents
  Inherits System.Web.UI.Page

#Region "Protected Sub-Routines"
  Protected Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    TrackTraffic()
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Recruitment Documents"
    End If
    Dim strCompanyName As String = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
    lblCompanyNameHeader.Text = strCompanyName
    lblPhoneContact.Text = "Phone:<span style=""font-weight:normal"">" & System.Configuration.ConfigurationManager.AppSettings("PhoneNumber") & "</span>&nbsp;&nbsp;&nbsp;Fax:<span style=""font-weight:normal"">" & System.Configuration.ConfigurationManager.AppSettings("FaxNumber") & "</span>"
    LoadDocuments()
  End Sub

#End Region

#Region "Private Sub-Routines"
  Private Sub TrackTraffic()
    Dim tm As New cvTrafficMaster.TransactionRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    tm.Add(Request.ServerVariables("SCRIPT_NAME"))
    If Not IsNothing(Request.ServerVariables("HTTP_REFERER")) Then
      tm.Referrer = Request.ServerVariables("HTTP_REFERER")
    End If
    If Not IsNothing(Request.ServerVariables("HTTP_USER_AGENT")) Then
      tm.UserAgent = Request.ServerVariables("HTTP_USER_AGENT")
    End If
    If Not IsNothing(Request.ServerVariables("REMOTE_ADDR")) Then
      tm.RemoteAddress = Request.ServerVariables("REMOTE_ADDR")
    End If
    If Not IsNothing(Request.ServerVariables("QUERY_STRING")) Then
      tm.QueryString = Request.ServerVariables("QUERY_STRING")
    End If
    If Not IsNothing(Request.ServerVariables("SERVER_NAME")) Then
      tm.ServerName = Request.ServerVariables("SERVER_NAME")
    End If
    Dim strChangelog As String = ""
    tm.Save(strChangelog)
  End Sub

  Private Sub LoadDocuments()
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(Master.ResumeID)
    If rsm.ResumeID > 0 Then
      lnkNDA.HRef = "viewfile.aspx?id=" & rsm.BlankNDAFileID
      lnkContract.HRef = "viewfile.aspx?id=" & rsm.BlankContractFileID
      lnkWaiver.HRef = "viewfile.aspx?id=" & rsm.BlankWaiverFileID
      lnkESig.HRef = "viewfile.aspx?id=" & rsm.BlankSignatureFileID
      If rsm.SignatureFileID > 0 Then
        lblESig.Text = "<a href=""viewfile.aspx?id=" & rsm.SignatureFileID & """>Uploaded</a>"
      End If
      If rsm.SignedContractFileID > 0 Then
        lblUploadedContract.Text = "Signed"
        txtConfirmContract.Text = rsm.ContractCode
      End If
      If rsm.SignedNDAFileID > 0 Then
        lblUploadedNDA.Text = "Signed"
        txtConfirmNDA.Text = rsm.NDACode
      End If
      If rsm.SignedWaiverFileID > 0 Then
        lblUploadedWaiver.Text = "Signed"
        txtConfirmWaiver.Text = rsm.WaiverCode
      End If
      If rsm.DLFileID > 0 Then
        lblDL.Text = "<a href=""viewfile.aspx?id=" & rsm.DLFileID & """>Uploaded</a>"
      End If
    End If
    If rsm.SignatureFileID > 0 And rsm.DLFileID > 0 Then
      btnSave.Enabled = True
    Else
      btnSave.Enabled = False
    End If
    If rsm.SignatureFileID > 0 And rsm.SignedContractFileID > 0 And rsm.SignedNDAFileID > 0 And rsm.SignedWaiverFileID > 0 And rsm.DLFileID > 0 Then
      divDone.InnerHtml = "Thank You!, Your documents have been saved and will now be reviewed. A representitive will contact you after the review process is completed."
      divDone.Visible = True
    End If
  End Sub

#End Region

#Region "Private Functions"
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
#End Region

#Region "Event Handlers"
  Protected Sub btnUploadEsig_Click(ByVal S As Object, ByVal E As EventArgs)
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
          rsm.Load(Master.ResumeID)
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
          LoadDocuments()
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

  Protected Sub btnUploadDL_Click(ByVal S As Object, ByVal E As EventArgs)
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
          rsm.Load(Master.ResumeID)
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
          LoadDocuments()
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

  Protected Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strErrors As String = ""
    Dim strTrash As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(Master.ResumeID)
    If txtConfirmNDA.Text.Trim.Length > 0 Then
      If txtConfirmNDA.Text.Trim.ToLower = rsm.NDACode.Trim.ToLower Then
        rsm.SignedNDAFileID = rsm.SignatureFileID
        rsm.NDASignatureDate = DateTime.Now
        rsm.Save(strTrash)
      Else
        strErrors &= "<li>Confidentiality Confirmation Codes Do Not Match</li>"
      End If
    End If
    If txtConfirmWaiver.Text.Trim.Length > 0 Then
      If txtConfirmWaiver.Text.Trim.ToLower = rsm.WaiverCode.Trim.ToLower Then
        rsm.SignedWaiverFileID = rsm.SignatureFileID
        rsm.WaiverSignatureDate = DateTime.Now
        rsm.Save(strTrash)
      Else
        strErrors &= "<li>Waiver Confirmation Codes Do Not Match</li>"
      End If
    End If
    If txtConfirmContract.Text.Trim.Length > 0 Then
      If txtConfirmContract.Text.Trim.ToLower = rsm.ContractCode.Trim.ToLower Then
        rsm.SignedContractFileID = rsm.SignatureFileID
        rsm.ContractSignatureDate = DateTime.Now
        rsm.Save(strTrash)
      Else
        strErrors &= "<li>Contract Confirmation Codes Do Not Match</li>"
      End If
      LoadDocuments()
    End If
    If strErrors.Trim.Length > 0 Then
      divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
      divErrors.Visible = True
    Else
      divErrors.Visible = False
    End If
  End Sub

#End Region

End Class