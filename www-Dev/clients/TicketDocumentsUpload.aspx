<%@ Page Language="vb" masterpagefile="~/masters/customerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/customerdialog.master" %>
<script runat="server">  
  Private _Mode As String = ""
  Private _DocID As Long = 0
  Private _FileID as Long = 0
  Private _TicketID as Long = 0
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Upload Ticket Documents"
      Master.PageTitleText = " Upload Ticket Documents"
    End If
    Try
      _Mode = Request.QueryString("mode")
    Catch ex As Exception
      Response.Redirect("default.aspx", True)
    End Try
    Try
      _TicketID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _TicketID = 0
    End Try
    Try
      _DocID = CType(Request.QueryString("fid"), Long)
    Catch ex As Exception
      _DocID = 0
    End Try
    Try
      _FileID = CType(Request.QueryString("updt"), Long)
    Catch ex As Exception
      _FileID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _Mode.Trim.Length = 0 Then
      Response.Redirect("default.aspx", True)
    End If
    if not IsPostBack then
     LoadDocTypes()
    end if
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
      Dim tkd as New BridgesInterface.TicketDocumentRecord(system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
      
      divErrors.Visible = False
      
      Select Case _Mode.ToLower
        Case "doc"
          lng = UploadFile()
         tkd.Add (2, _TicketID, drpDocTypes.SelectedValue,lng)
         act.Add(2 ,"web", strType,strIp,Master.WebLoginID.ToString,43, _TicketID, strChangeLog)
            
        Case "doce"
         If _FileID <> 0 then
           If _DocID <> 0 then
              lng = UpdateUploadFile(_FileID)
              tkd.Load (_DocID)
              tkd.TicketDocumentTypeID = Ctype(drpDocTypes.SelectedValue,Long)
              tkd.FileID= lng
              tkd.Save (strChangeLog)
              act.Add(2 ,"web", strType,strIp,Master.WebLoginID.ToString,43, _TicketID, strChangeLog)

           end if
         end if
        Case else
        
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
    Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
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
      Case "doc"
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("WOCnn")
      Case Else
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("FLCnn")
    End Select
    fil.Add(2 , strFileName, strExtension.Replace(".", ""), buf)
    
    
    Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      tnt.Add(_TicketID, Master.WebLoginID, Master.UserID, "Auto Note: New Attachment has been added to the ticket: " & drpDocTypes.SelectedItem.text )
      tnt.CustomerVisible = False
      tnt.PartnerVisible = False
      tnt.Acknowledged = True
      tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
      tnt.Save(strChangeLog)
    
    lngReturn = fil.FileID
    Return lngReturn
  End Function
  
  Private Function UpdateUploadFile(lngFileID as long) As Long
    Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
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
      Case "doc"
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("WOCnn")
      
      Case "doce"
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("WOCnn")
      Case Else
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("FLCnn")
    End Select
    fil.Load (lngFileID)
    fil.Delete ()
    
    fil.Add(2 , strFileName, strExtension.Replace(".", ""),buf)
    
    
      'Adding note to the ticket.
      Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      tnt.Add(_TicketID, Master.WebLoginID, Master.UserID, "Auto Note: Ticket has been updated with Attachment: " & drpDocTypes.SelectedItem.text )
      tnt.CustomerVisible = False
      tnt.PartnerVisible = False
      tnt.Acknowledged = True
      tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
      tnt.Save(strChangeLog)
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
       else
         If drpDocTypes.SelectedValue = "Choose One" then
          blnReturn = False
          strErrors &= "<li> You MUST choose a Documet Type before you can upload a file.</li>"
          end if 
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub LoadDocTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spGetTicketDocumentTypesForCustomers","Description","TicketDocumentTypeID",drpDocTypes)
     drpDocTypes.Items.Add ("Choose One")
     drpDocTypes.SelectedValue= "Choose One"
  End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" runat="server" id="divErrors" visible="false" />
    <div>&nbsp;</div>
    <div>Document Types</div>
    <asp:DropDownList ID="drpDocTypes" runat="server" AutoPostBack = "true" Width ="100%"/>
    <div>&nbsp;</div>
    <div> Please load only <b>PDF</b> for documents and <b>JPG or TIF</b> for Photo files.</div>
    <asp:FileUpload ID="fup" runat="server" Width ="100%" />
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    <div>&nbsp;</div> 
    <div><b>*** Attention: This page is not used to upload work orders.</b></div> 
    <div>&nbsp;</div><asp:Button OnClick="btnUpload_Click" ID="btnUpload" Text="Upload" runat="server"/>&nbsp;&nbsp;<asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" />
   <div>&nbsp;</div>
  </form>
</asp:Content>