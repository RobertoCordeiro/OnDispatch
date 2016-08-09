<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    _ID = CType(Request.QueryString("id"), Long)
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Send Documents"
      Master.PageTitleText = "Send Documents"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""recruit.aspx"">Recruitment</a> &gt; <a href=""" & lblReturnUrl.Text & """>Resume</a> &gt; Send Documents"
    End If
    If Not IsPostBack Then
      LoadAddresses()
    End If
  End Sub

  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    CreateWaiver()
    CreateEsig()
    CreateNDA()
    CreateContract()
    SendEmail()
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub SendEmail()
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim doc As New BridgesInterface.DocumentRecord(rsm.ConnectionString)
    Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
    Dim usr As New BridgesInterface.UserRecord(rsm.ConnectionString)
    Dim rnt As New BridgesInterface.ResumeNoteRecord(rsm.ConnectionString)
    Dim strBody As String = ""
    Dim strLoginPath As String = System.Configuration.ConfigurationManager.AppSettings("LoginFormPath")
    Dim strEmailFrom As String = System.Configuration.ConfigurationManager.AppSettings("RecruiterEmail")
    Dim strArchiveEmail As String = System.Configuration.ConfigurationManager.AppSettings("ArchiveEmail")
    rsm.Load(_ID)
    doc.Load(6) ' 6 Is the ID to the Send Documents Email
    usr.Load(Master.UserID)
    strBody = doc.DocumentText
    strBody = strBody.Replace("$firstname", rsm.FirstName)
    strBody = strBody.Replace("$lastname", rsm.LastName)
    strBody = strBody.Replace("$resumeid", rsm.ResumeID)
    strBody = strBody.Replace("$password", "The same as your phase 2 password, if you have forgotten your password please contact Partner Support")
    strBody = strBody.Replace("$link", "<a href=""" & strLoginPath & """>" & strLoginPath & "</a>")
    If usr.Signature.Trim.Length > 0 Then
      strBody = strBody.Replace("$signature", usr.Signature)
    Else
      strBody = strBody.Replace("$signature", usr.FirstName & " " & usr.LastName)
    End If
    eml.BCC = strArchiveEmail
    eml.Subject = "Important Documents Are Ready!"
    eml.SendTo = rsm.Email
    eml.SendFrom = strEmailFrom
    eml.Body = strBody
    eml.HTMLBody = True
    eml.Send()
    rnt.Add(_ID, Master.UserID, "Important Documents Have Been Made Available.")
  End Sub

  Private Sub CreateEsig()
    Dim rpt As New cvReporter.Report
    Dim prn As New System.Drawing.Printing.PrintDocument
    Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim rsm As New BridgesInterface.ResumeRecord(doc.ConnectionString)
    Dim add As New BridgesInterface.ResumeAddressRecord(doc.ConnectionString)
    Dim man As New cvCommon.Manipulators
    Dim mon As New BridgesInterface.MonthRecord(doc.ConnectionString)
    Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
    Dim stt As New BridgesInterface.StateRecord(doc.ConnectionString)
    Dim ent As New BridgesInterface.EntityTypeRecord(doc.ConnectionString)
    Dim strFileName As String = man.RandomString(32)
    rsm.Load(_ID)
    mon.Load(DateTime.Now.Month)
    add.Load(CType(cbxAddresses.SelectedValue, Long))
    stt.Load(add.StateID)
    ent.Load(rsm.EntityTypeID)
    Dim strPath As String = System.Configuration.ConfigurationManager.AppSettings("TempFilePath")
    Dim strCompany As String = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
    doc.Load(8) '8 is the ID for the Esig
    rpt.Layout.Width = CType(prn.DefaultPageSettings.PrintableArea.Width, Integer)
    rpt.Layout.Height = CType(prn.DefaultPageSettings.PrintableArea.Height, Integer)
    Dim txtHeader As New cvReporter.Report.TextArea(rpt.Layout.Width, 50, doc.DocumentName)
    Dim txtBody As New cvReporter.Report.TextArea(rpt.Layout.Width, rpt.Layout.Height - txtHeader.Height, doc.DocumentText)
    Dim strTemp As String = DateTime.Now.Month.ToString("00") & "/" & DateTime.Now.Day.ToString("00") & "/" & DateTime.Now.Year.ToString("0000")
    txtBody.Text = txtBody.Text.Replace("$resumestreet1", add.Street)
    txtBody.Text = txtBody.Text.Replace("$resumestreet2", add.Extended)
    txtBody.Text = txtBody.Text.Replace("$resumecity", add.City)
    txtBody.Text = txtBody.Text.Replace("$resumestate", stt.StateName)
    txtBody.Text = txtBody.Text.Replace("$resumezip", add.ZipCode)
    txtBody.Text = txtBody.Text.Replace("$resumeentitytype", ent.EntityType)
    txtBody.Text = txtBody.Text.Replace("$loginid", rsm.ResumeID.ToString)
    strCompany = rsm.CompanyName
    txtBody.Text = txtBody.Text.Replace("$resumecompanyname", strCompany)
    txtHeader.Font = New System.Drawing.Font("Times New Roman", 14, Drawing.FontStyle.Bold)
    txtHeader.VerticalAlignment = cvReporter.Report.VerticalAlignments.Middle
    txtHeader.HorizontalAlignment = cvReporter.Report.HorizontalAlignments.Center
    txtBody.Top = txtHeader.Height
    txtBody.Font = New System.Drawing.Font("Times New Roman", 12, Drawing.FontStyle.Regular)
    rpt.Layout.Body.TextAreas.Add(txtBody)
    rpt.Layout.Body.TextAreas.Add(txtHeader)
    'rpt.SaveAsTiff(strPath & "\" & strFileName)
    rpt.saveAsTiff("c:\dev\cvReporter\cvReporter\" & strFileName)
    fil.Add(Master.UserID, _ID.ToString & "-esig.tif", "tif", "c:\dev\cvReporter\cvReporter"  & "\" & strFileName)
    System.IO.File.Delete(strPath & "\" & strFileName)
    rsm.BlankSignatureFileID = fil.FileID
    rsm.SignatureFileID = 0
    rsm.Save(strFileName)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    act.Add(Master.UserID, "web", "web", strIp, "web", 23, rsm.ResumeID, strFileName)
  End Sub

  Private Sub CreateContract()
    Dim rpt As New cvReporter.Report
    Dim prn As New System.Drawing.Printing.PrintDocument
    Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim rsm As New BridgesInterface.ResumeRecord(doc.ConnectionString)
    Dim add As New BridgesInterface.ResumeAddressRecord(doc.ConnectionString)
    Dim man As New cvCommon.Manipulators
    Dim mon As New BridgesInterface.MonthRecord(doc.ConnectionString)    
    Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
    Dim stt As New BridgesInterface.StateRecord(doc.ConnectionString)
    Dim ent As New BridgesInterface.EntityTypeRecord(doc.ConnectionString)
    Dim rnd As New Random(DateTime.Now.Millisecond * DateTime.Now.Minute)
    Dim strConfirm As String = rnd.Next(100, 9999).ToString("0000")
    Dim strFileName As String = man.RandomString(32)
    rsm.Load(_ID)
    mon.Load(DateTime.Now.Month)
    add.Load(CType(cbxAddresses.SelectedValue, Long))
    stt.Load(add.StateID)
    ent.Load(rsm.EntityTypeID)
    Dim strPath As String = System.Configuration.ConfigurationManager.AppSettings("TempFilePath")
    Dim strCompany As String = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
    Dim strAddress As String = System.Configuration.ConfigurationManager.AppSettings("StreetAddress")
    If System.Configuration.ConfigurationManager.AppSettings("Extended").Trim.Length > 0 Then
      strAddress &= Environment.NewLine
      strAddress &= System.Configuration.ConfigurationManager.AppSettings("Extended")
    End If
    strAddress &= Environment.NewLine
    strAddress &= System.Configuration.ConfigurationManager.AppSettings("City")
    strAddress &= " " & System.Configuration.ConfigurationManager.AppSettings("State") & ","
    strAddress &= " " & System.Configuration.ConfigurationManager.AppSettings("ZipCode")
    Dim strShortCompanyName As String = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName")
    doc.Load(4) '4 is the ID for the Contract
    rpt.Layout.Width = CType(prn.DefaultPageSettings.PrintableArea.Width, Integer)
    rpt.Layout.Height = CType(prn.DefaultPageSettings.PrintableArea.Height, Integer)
    Dim txtHeader As New cvReporter.Report.TextArea(rpt.Layout.Width, 50, doc.DocumentName)
    Dim txtBody As New cvReporter.Report.TextArea(rpt.Layout.Width, rpt.Layout.Height - txtHeader.Height, doc.DocumentText)
    Dim strTemp As String = DateTime.Now.Month.ToString("00") & "/" & DateTime.Now.Day.ToString("00") & "/" & DateTime.Now.Year.ToString("0000")
    txtBody.Text = txtBody.Text.Replace("$shortcompanyname", strShortCompanyName.ToUpper)
    txtBody.Text = txtBody.Text.Replace("$companyname", strCompany)
    txtBody.Text = txtBody.Text.Replace("$address", strAddress)
    txtBody.Text = txtBody.Text.Replace("$date", strTemp)
    txtBody.Text = txtBody.Text.Replace("$day", DateTime.Now.Day.ToString & man.NumberSuffix(DateTime.Now.Day))
    txtBody.Text = txtBody.Text.Replace("$year", DateTime.Now.Year.ToString("0000"))
    txtBody.Text = txtBody.Text.Replace("$monthday", DateTime.Now.Month.ToString & "/" & DateTime.Now.Year.ToString("0000") & "/")
    txtBody.Text = txtBody.Text.Replace("$month", mon.MonthName)
    txtBody.Text = txtBody.Text.Replace("$resumestreet1", add.Street)
    txtBody.Text = txtBody.Text.Replace("$resumestreet2", add.Extended)
    txtBody.Text = txtBody.Text.Replace("$resumecity", add.City)
    txtBody.Text = txtBody.Text.Replace("$resumestate", stt.StateName)
    txtBody.Text = txtBody.Text.Replace("$resumezip", add.ZipCode)
    txtBody.Text = txtBody.Text.Replace("$resumeentitytype", ent.EntityType)
    txtBody.Text = txtBody.Text.Replace("$confirmcode", strConfirm)
    strCompany = rsm.CompanyName
    txtBody.Text = txtBody.Text.Replace("$resumecompanyname", strCompany)
    txtHeader.Font = New System.Drawing.Font("Times New Roman", 14, Drawing.FontStyle.Bold)
    txtHeader.VerticalAlignment = cvReporter.Report.VerticalAlignments.Middle
    txtHeader.HorizontalAlignment = cvReporter.Report.HorizontalAlignments.Center
    txtBody.Top = txtHeader.Height
    txtBody.Font = New System.Drawing.Font("Times New Roman", 12, Drawing.FontStyle.Regular)
    rpt.Layout.Body.TextAreas.Add(txtBody)
    rpt.Layout.Body.TextAreas.Add(txtHeader)
    rpt.SaveAsTiff("c:\dev\cvReporter\cvReporter" & "\" & strFileName) 
    fil.Add(Master.UserID, _ID.ToString & "-contract.tif", "tif", "c:\dev\cvReporter\cvReporter"  & "\" & strFileName)
    System.IO.File.Delete(strPath & "\" & strFileName)
    rsm.BlankContractFileID = fil.FileID
    rsm.SignedContractFileID = 0
    rsm.ContractCode = strConfirm
    rsm.Save(strFileName)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    act.Add(Master.UserID, "web", "web", strIp, "web", 23, rsm.ResumeID, strFileName)
  End Sub
  
  Private Sub CreateNDA()
    Dim rpt As New cvReporter.Report
    Dim prn As New System.Drawing.Printing.PrintDocument
    Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim rsm As New BridgesInterface.ResumeRecord(doc.ConnectionString)
    Dim man As New cvCommon.Manipulators
    Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
    Dim stt As New BridgesInterface.StateRecord(doc.ConnectionString)
    Dim rad As New BridgesInterface.ResumeAddressRecord(doc.ConnectionString)
    Dim strFileName As String = man.RandomString(32)
    Dim rnd As New Random(DateTime.Now.Millisecond * DateTime.Now.Minute)
    Dim strConfirm As String = rnd.Next(100, 9999).ToString("0000")
    rsm.Load(_ID)
    rad.Load(CType(cbxAddresses.SelectedValue, Long))
    stt.Load(rad.StateID)
    Dim strPath As String = System.Configuration.ConfigurationManager.AppSettings("TempFilePath")
    Dim strCompany As String = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
    Dim strAddress As String = System.Configuration.ConfigurationManager.AppSettings("StreetAddress")
    If System.Configuration.ConfigurationManager.AppSettings("Extended").Trim.Length > 0 Then
      strAddress &= Environment.NewLine
      strAddress &= System.Configuration.ConfigurationManager.AppSettings("Extended")
    End If
    strAddress &= Environment.NewLine
    strAddress &= System.Configuration.ConfigurationManager.AppSettings("City")
    strAddress &= " " & System.Configuration.ConfigurationManager.AppSettings("State") & ","
    strAddress &= " " & System.Configuration.ConfigurationManager.AppSettings("ZipCode")
    Dim strShortCompanyName As String = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName")
    doc.Load(3) '3 is the ID for the Confidentiality Agreement
    rpt.Layout.Width = CType(prn.DefaultPageSettings.PrintableArea.Width, Integer)
    rpt.Layout.Height = CType(prn.DefaultPageSettings.PrintableArea.Height, Integer)
    Dim txtHeader As New cvReporter.Report.TextArea(rpt.Layout.Width, 50, "Confidentiality Agreement")
    Dim txtBody As New cvReporter.Report.TextArea(rpt.Layout.Width, rpt.Layout.Height - txtHeader.Height, doc.DocumentText)
    Dim strTemp As String = DateTime.Now.Month.ToString("00") & "/" & DateTime.Now.Day.ToString("00") & "/" & DateTime.Now.Year.ToString("0000")
    txtBody.Text = txtBody.Text.Replace("$shortcompanyname", strShortCompanyName.ToUpper)
    txtBody.Text = txtBody.Text.Replace("$companyname", strCompany)
    txtBody.Text = txtBody.Text.Replace("$address", strAddress)
    txtBody.Text = txtBody.Text.Replace("$date", strTemp)
    txtBody.Text = txtBody.Text.Replace("$resumestreet1", rad.Street)
    txtBody.Text = txtBody.Text.Replace("$resumestreet2", rad.Extended)
    txtBody.Text = txtBody.Text.Replace("$resumecity", rad.City)
    txtBody.Text = txtBody.Text.Replace("$resumestate", stt.StateName)
    txtBody.Text = txtBody.Text.Replace("$resumezip", rad.ZipCode)
    txtBody.Text = txtBody.Text.Replace("$confirmcode", strConfirm)
    strCompany = rsm.CompanyName
    txtBody.Text = txtBody.Text.Replace("$resumecompanyname", strCompany)
    strAddress = rad.Street
    If rad.Extended.Trim.Length > 0 Then
      strAddress &= Environment.NewLine
      strAddress &= rad.Extended
    End If
    strAddress = rad.City & ", " & stt.Abbreviation & ". " & rad.ZipCode
    txtBody.Text = txtBody.Text.Replace("$resumeaddress", strAddress)
    txtHeader.Font = New System.Drawing.Font("Times New Roman", 14, Drawing.FontStyle.Bold)
    txtHeader.VerticalAlignment = cvReporter.Report.VerticalAlignments.Middle
    txtHeader.HorizontalAlignment = cvReporter.Report.HorizontalAlignments.Center
    txtBody.Top = txtHeader.Height
    txtBody.Font = New System.Drawing.Font("Times New Roman", 12)
    rpt.Layout.Body.TextAreas.Add(txtBody)
    rpt.Layout.Body.TextAreas.Add(txtHeader)
    rpt.SaveAsTiff("c:\dev\cvReporter\cvReporter"  & "\" & strFileName)
    fil.Add(Master.UserID, _ID.ToString & "-nda.tif", "tif", "c:\dev\cvReporter\cvReporter\"  & "\" & strFileName)
    System.IO.File.Delete(strPath & "\" & strFileName)
    rsm.BlankNDAFileID = fil.FileID
    rsm.SignedNDAFileID = 0
    rsm.NDACode = strConfirm
    rsm.Save(strFileName)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    act.Add(Master.UserID, "web", "web", strIp, "web", 23, rsm.ResumeID, strFileName)    
  End Sub
  
  Private Sub CreateWaiver()
    Dim rpt As New cvReporter.Report
    Dim prn As New System.Drawing.Printing.PrintDocument
    Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim stt As New BridgesInterface.StateRecord(doc.ConnectionString)
    Dim rsm As New BridgesInterface.ResumeRecord(doc.ConnectionString)
    Dim man As New cvCommon.Manipulators
    Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
    Dim rad As New BridgesInterface.ResumeAddressRecord(doc.ConnectionString)
    Dim strFileName As String = man.RandomString(32)
    Dim strPath As String = System.Configuration.ConfigurationManager.AppSettings("TempFilePath")
    Dim strCompany As String = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
    Dim strAddress As String = ""
    Dim rnd As New Random(DateTime.Now.Millisecond * DateTime.Now.Minute)
    Dim strConfirm As String = rnd.Next(100, 9999).ToString("0000")
    rad.Load(CType(cbxAddresses.SelectedValue, Long))
    stt.Load(rad.StateID)
    rsm.Load(_ID)
    doc.Load(2) '2 is the ID for the workmans comp waiver
    rpt.Layout.Width = CType(prn.DefaultPageSettings.PrintableArea.Width, Integer)
    rpt.Layout.Height = CType(prn.DefaultPageSettings.PrintableArea.Height, Integer)
    Dim txtHeader As New cvReporter.Report.TextArea(rpt.Layout.Width, 50, "Workman's Compensation Disclaimer" & Environment.NewLine & "and Release of Liability")
    Dim txtBody As New cvReporter.Report.TextArea(rpt.Layout.Width, rpt.Layout.Height - txtHeader.Height, doc.DocumentText.Replace("$company", strCompany).Replace("$resumeid", rsm.ResumeID.ToString).Replace("$name", rsm.FirstName & " " & rsm.LastName).Replace("$resumecompanyname", rsm.CompanyName))
    txtBody.Text = txtBody.Text.Replace("$confirmcode", strConfirm)
    txtHeader.Font = New System.Drawing.Font("Times New Roman", 14, Drawing.FontStyle.Bold)
    txtHeader.VerticalAlignment = cvReporter.Report.VerticalAlignments.Middle
    txtHeader.HorizontalAlignment = cvReporter.Report.HorizontalAlignments.Center
    txtBody.Top = txtHeader.Height
    txtBody.Font = New System.Drawing.Font("Times New Roman", 12)
    rpt.Layout.Body.TextAreas.Add(txtBody)
    rpt.Layout.Body.TextAreas.Add(txtHeader)    
    'rpt.SaveAsTiff(strPath & "\" & strFileName)
    rpt.saveAsTiff("c:\dev\cvReporter\cvReporter\" & strFileName)
    fil.Add(Master.UserID, _ID.ToString & "-waiver.tif", "tif","c:\dev\cvReporter\cvReporter\" & "\" & strFileName)
    System.IO.File.Delete(strPath & "\" & strFileName)
    rsm.BlankWaiverFileID = fil.FileID
    rsm.SignedWaiverFileID = 0
    rsm.WaiverCode = strConfirm
    rsm.Save(strFileName)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    act.Add(Master.UserID, "web", "web", strIp, "web", 23, rsm.ResumeID, strFileName)
  End Sub
  
  Private Sub LoadAddresses()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListActiveAddressesForResume")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = _ID
    Dim itm As ListItem
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxAddresses.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("Street")
      itm.Value = dtr("ResumeAddressID")
      cbxAddresses.Items.Add(itm)
    End While
    cnn.Close()
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div style="width: 400px;">
      Are you sure you wish to create and send the following documents?
      <ul>
        <li>Contract</li>
        <li>Workman's Comp Waiver</li>
        <li>Confidentiality Agreement (NDA)</li>
      </ul>
      <div>Once you have created these documents the candidate will no longer be able to edit any of their information from this point forward until they have either completed the process and are made into a full partner or until they have declined to move further.</div>
      <div>&nbsp;</div>      
      <div style="font-style: italic">WARNING, If you Re-Send documents it will REMOVE any documents the applicant has already signed! This is necessary in case of changes in the documents, however, this feature should be used SPARINGLY, and only after or during phone communications with the applicant.</div>
      <div>&nbsp;</div>
      <div class="label">Select Address To Use For Partner's Contract</div>
      <asp:DropDownList style="width: 99%" ID="cbxAddresses" runat="server" />
      <div style="text-align:right;"><asp:Button ID="btnCancel" Text="No" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button ID="btnSubmit" Text="Yes" OnClick="btnSubmit_Click" runat="server" /></div>
    </div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>