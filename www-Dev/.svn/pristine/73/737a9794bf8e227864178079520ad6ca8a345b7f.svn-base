<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">  
  Private _Mode As String = ""
  Private _DocID As Long = 0
  Private _FileID as Long = 0
  Private _ID as Long = 0
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = " Upload Customer Documents"
            Master.PageTitleText = " Upload Customer Documents"
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
    
    If _Mode.Trim.Length = 0 Then
      Response.Redirect("default.aspx", True)
    End If
    Dim cus As New BridgesInterface.CustomerRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn") )
    cus.Load(_ID)
    Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    inf.Load(cus.InfoID)
    If inf.CustomerID = _ID then
      lblReturnUrl.Text = "mycompany.aspx?id=" & _ID & "&t=6&infoID=" & inf.infoID
    Else
      lblReturnUrl.Text = Request.QueryString("returnurl")
    end if
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
            Dim cst As New BridgesInterface.CustomerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim tkd as New BridgesInterface.TicketDocumentRecord(system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
      
      divErrors.Visible = False
      
      Select Case _Mode.ToLower
        Case "doc"
          lng = UploadFile()
         'pdr.Add (2, _ID, drpDocTypes.SelectedValue,lng)
         'act.Add(2 ,"web", strType,strIp,Master.WebLoginID.ToString,43, _ID, strChangeLog)
        
         dim ptr as New BridgesInterface.PartnerRecord(system.configuration.configurationmanager.appsettings("DBCnn"))    
         ptr.Load(_ID)
         Dim rnt As New BridgesInterface.ResumeNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    rnt.Add(CType(ptr.ResumeID, Long), Master.UserID, "Auto Note: New Document has been attached to the Customer's Account: " & drpDocTypes.SelectedItem.ToString())
      
     
        Case "doce"
         If _FileID <> 0 then
           If _DocID <> 0 then
              lng = UpdateUploadFile(_FileID)
                            cst.Load(_DocID)
                            cst.CustomerDocumentTypeID = CType(drpDocTypes.SelectedValue, Long)
                            cst.FileID = lng
                            cst.Save(strChangeLog)
              'act.Add(2 ,"web", strType,strIp,Master.WebLoginID.ToString,43, _ID, strChangeLog)
              
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
    Dim strPath As String = Me.fup.FileName
    Dim strFileName As String = ""
    Dim strExtension As String = ""
    Dim strChangeLog As String = ""
    divErrors.Visible = False
    If strPath.Trim.Length > 0 Then
      strFileName = System.IO.Path.GetFileName(strPath)
      strExtension = System.IO.Path.GetExtension(strPath)
      If IsAcceptableType(strExtension) Then
        If fup.PostedFile.ContentLength > 0 Then
          Dim stm As System.IO.Stream
          Dim buf(fup.PostedFile.ContentLength) As Byte
          stm = fup.PostedFile.InputStream
          stm.Read(buf, 0, fup.PostedFile.ContentLength)
          Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
          fil.Add(2, strFileName, strExtension.Replace(".", ""), buf)
                    Dim cst As New BridgesInterface.CustomerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    cst.Add(2, drpDocTypes.SelectedValue, fil.FileID, _ID)
                    
          'Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
          'Dim strIp As String = Request.QueryString("REMOTE_ADDR")
          'Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
          'If IsNothing(strIp) Then
          '  strIp = "unknown"
          'End If
          'If IsNothing(strType) Then
          '  strType = "web"
          'End If
          'act.Add(2, "web", strType, strIp, "web", 23, rsm.PartnerDocumentID, strChangeLog)
          'LoadDocuments(_ID)
          Return fil.FileID 
        Else
          divErrors.InnerHtml = "<ul><li>Empty File or File Does Not Exist, Please Check the File Name and Try Again.</li></ul>"
          divErrors.Visible = True
        End If
      End If
    Else
      divErrors.InnerHtml = "<ul><li>You must provide a path to the file you wish to upload</li></ul>"
      divErrors.Visible = True
    End If
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
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("FLCnn")
      
      Case "doce"
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("FLCnn")
      Case Else
        fil.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("FLCnn")
    End Select
    fil.Load (lngFileID)
    fil.Delete ()
    
    fil.Add(2 , strFileName, strExtension.Replace(".", ""),buf)
    
    dim ptr as New BridgesInterface.PartnerRecord(system.configuration.configurationmanager.appsettings("DBCnn"))    
    ptr.Load(_ID)
    Dim rnt As New BridgesInterface.ResumeNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rnt.Add(CType(ptr.ResumeID, Long), Master.UserID, "Auto Note: A Document has been updated in the Vendor's Account: " & drpDocTypes.SelectedItem.ToString()  )

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
    ldr.LoadSimpleDropDownList("spGetCustomerDocumentTypes","Description","CustomerDocumentTypeID",drpDocTypes)
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