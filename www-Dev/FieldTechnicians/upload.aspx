<%@ Page Language="vb" masterpagefile="~/masters/FieldTechniciansdialog.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechniciansdialog.master" %>
<script runat="server">  
  Private _Mode As String = ""
  Private _ID As Long = 0
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Upload Signed Work Order"
      Master.PageTitleText = " Upload Signed Work Order"
    End If
    Try
      _Mode = Request.QueryString("mode")
    Catch ex As Exception
      Response.Redirect("default.aspx", True)
    End Try
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _Mode.Trim.Length = 0 Then
      Response.Redirect("default.aspx", True)
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub

  Private Sub btnUpload_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim lng As Long = 0
    If IsComplete() Then
      Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      Dim strChangeLog As String = ""
      Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim pdr As New BridgesInterface.PartnerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      divErrors.Visible = False
      
      Select Case _Mode.ToLower
        Case "wo"
          lng = UploadFile()
          wrk.Load(_ID)
          If wrk.WorkOrderID > 0 Then
            wrk.WorkOrderFileID = lng
            wrk.Save(strChangeLog)
            act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 43, _ID, strChangeLog)
            tkt.Load(wrk.TicketID)
          End If
        Case "w9"
          lng = UploadFile()
          pdr.Load(Master.PartnerID, 1)
          If pdr.PartnerDocumentID > 0 Then
            pdr.FileID = lng
            pdr.Save(strChangeLog)
            act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 41, pdr.PartnerDocumentID, strChangeLog)
          Else
            pdr.Add(Master.UserID, Master.PartnerID, 1, lng)
          End If
        Case "li"
          lng = UploadFile()
          pdr.Load(Master.PartnerID, 2)
          If pdr.PartnerDocumentID > 0 Then
            pdr.FileID = lng
            pdr.Save(strChangeLog)
            act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 41, pdr.PartnerDocumentID, strChangeLog)
          Else
            pdr.Add(Master.UserID, Master.PartnerID, 2, lng)
          End If
        Case "dl"
          If _ID > 0 Then
            lng = UploadFile()
            par.Load(_ID)
            par.DLFileID = lng
            par.Save(strChangeLog)
            act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 42, par.PartnerAgentID, strChangeLog)
          End If
      End Select
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
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
    End Select
    Return blnReturn
  End Function
  
  Private Function UploadFile() As Long
    Dim strPath As String = fup.FileName
    Dim strFileName As String = ""
    Dim strExtension As String = ""
    Dim strChangeLog As String = ""
    Dim lngReturn As Long = 0
    strFileName = System.IO.Path.GetFileName(strPath)
    strExtension = System.IO.Path.GetExtension(strPath)    
    Dim stm As System.IO.Stream
    Dim buf(fup.PostedFile.ContentLength) As Byte
    stm = fup.PostedFile.InputStream
    stm.Read(buf, 0, fup.PostedFile.ContentLength)
    Dim fil As New cvFileLibrary.FileRecord
    Select Case _Mode.ToLower
      Case "wo"
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("WOCnn")
      Case Else
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("FLCnn")
    End Select
    fil.Add(2, strFileName, strExtension.Replace(".", ""), buf)
    lngReturn = fil.FileID
    Return lngReturn
  End Function
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If fup.FileName.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Upload Failed, Either the file doesn't exists or you did not enter a file name</li>"
    Else
      If Not IsAcceptableType(System.IO.Path.GetExtension(fup.FileName.Trim)) Then
        blnReturn = False
        strErrors &= "<li>Invalid File Type. Please Only Upload (JPG, TIF, GIF, PDF, or PNG)</li>"
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" runat="server" id="divErrors" visible="false" />
    <asp:FileUpload ID="fup" runat="server" /><asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" /><asp:Button OnClick="btnUpload_Click" ID="btnUpload" Text="Upload" runat="server" />
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />    
  </form>
</asp:Content>