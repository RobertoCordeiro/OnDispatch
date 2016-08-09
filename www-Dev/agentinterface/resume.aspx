<%@ Page Language="vb" masterpagefile="~/masters/agent.master" ValidateRequest="false" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<script runat="server">
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "View Resume"
      Master.PageTitleText = "View Resume"
      Try
        Dim lngFolderID As Long = CType(Request.QueryString("folder"), Long)
        Dim lngPageNumber As Long = CType(Request.QueryString("page"), Long)
        Dim strOrderBy As String = Request.QueryString("orderby").Trim
        Dim strSortOrder As String = Request.QueryString("sortorder").Trim
        Master.PageSubHeader = "<a href=""/agentinterface"">My Desktop</a> &gt; <a href=""recruit.aspx?folder=" & lngFolderID & "&page=" & lngPageNumber & "&orderby=" & strOrderBy & "&sortorder=" & strSortOrder & """>Recruitment</a> &gt; View Resume"
      Catch ex As Exception
        Master.PageSubHeader = "<a href=""/agentinterface"">My Desktop</a> &gt; <a href=""recruit.aspx?"">Recruitment</a> &gt; View Resume"
      End Try
    End If
    Dim lngResumeID As Long = 0
    Try
            lngResumeID = CType(Request.QueryString("resumeid"), Long)
            Master.PageHeaderText = lngResumeID
            Master.PageTitleText = lngResumeID
    Catch ex As Exception
      lngResumeID = 0
    End Try
    If Not IsPostBack Then      
      LoadResume(lngResumeID)
      LoadResumeAddresses(lngResumeID)
      LoadResumePhoneNumbers(lngResumeID)
      LoadResumeNotes(lngResumeID)
      LoadPersonalFolders()
      LoadFolderMap()
      LoadRemovalFolders()
      LoadResumeRates(lngResumeID)
      LoadLookIn()
    End If
  End Sub
  
  Private Function cboxitem(ByVal strText As String, ByVal strValue As String) As ListItem
    Dim itmReturn As New ListItem
    itmReturn.Text = strText
    itmReturn.Value = strValue
    Return itmReturn
  End Function
     
  Private Sub btnQuickSearch_Click(ByVal S As Object, ByVal E As EventArgs)
    If txtResumeSearch.Text.Trim.Length > 0 Then
      Response.Redirect("resumesearch.aspx?lookin=" & cbxLookIn.SelectedValue & "&criteria=" & Server.UrlEncode(txtResumeSearch.Text.Trim), True)
    Else
      divResumeSearchError.InnerHtml = "Resume ID is required"
      divResumeSearchError.Visible = True
    End If
  End Sub
  
  Private Sub LoadLookIn()
    With cbxLookIn.Items
      .Clear()
      .Add(cboxitem("Resume ID", "resumeid"))
      .Add(cboxitem("Referrer", "referrer"))
      .Add(cboxitem("Company Name", "companyname"))
      .Add(cboxitem("Name", "name"))
      .Add(cboxitem("Email", "email"))
      .Add(cboxitem("WebSite", "website"))
      .Add(cboxitem("IP Address", "ipaddress"))
      .Add(cboxitem("Resume Text", "resume"))
      .Add(cboxitem("Misc", "misc"))
      .Add(cboxitem("Zip Code", "zipcode"))
      .Add(cboxitem("City", "city"))
      .Add(cboxitem("State", "state"))
      .Add(cboxitem("Phone Number", "phone"))
    End With
  End Sub
  
  Private Sub LoadPersonalFolders()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListPersonalResumeFolders")
    Dim itm As ListItem
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("CreatedBy", Data.SqlDbType.Int).Value = Master.UserID    
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxPersonalFolders.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("FolderName").ToString
      itm.Value = dtr("FolderID").ToString
      cbxPersonalFolders.Items.Add(itm)
    End While
    cnn.Close()    
  End Sub
   
  Private Sub LoadResume(ByVal lngResumeID As Long)
    Dim rsm As New BridgesInterface.ResumeRecord(lngResumeID, System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim etr As New BridgesInterface.EntityTypeRecord(rsm.ConnectionString)
    Dim rrr As New BridgesInterface.ResumeReferrerRecord(rsm.ConnectionString)
    Dim mth As New BridgesInterface.MonthRecord(rsm.ConnectionString)
    Dim stt As New BridgesInterface.StateRecord(rsm.ConnectionString)
    Dim rtp As New BridgesInterface.ResumeTypeRecord(rsm.ConnectionString)
    Dim rrt As New BridgesInterface.ResumeRateRecord(rsm.ConnectionString)
    Dim usr As New BridgesInterface.UserRecord(rsm.ConnectionString )
    Dim flg As New cvTrafficMaster.FlagRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    Dim sec As New cvCommon.Security
    Dim datStart As Date = DateTime.Now
    Dim datEnd As Date = DateTime.Now
    Dim strBlank As String = ""
    Dim strSigned As String = ""
    rsm.Load(lngResumeID)
    If rsm.WebLoginID > 0 Then
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
    End If
    rtp.Load(rsm.ResumeTypeID)
    rrr.Load(rsm.ReferrerID)
    etr.Load(rsm.EntityTypeID)
    lblEntityType.Text = etr.EntityType
    lblResumeID.Text = lngResumeID.ToString
    divDeclined.Visible = rsm.Declined
    lblContact.Text = rsm.FirstName
    If rsm.ConfidenceLevel > 0 Then
      Dim x As Double = 0
      x = (rsm.ConfidenceLevel / 5) * 100
      x = Math.Round(x, 0)
      imgICL.ImageUrl = "/graphics/bar" & x.ToString & ".png"
    Else
      imgICL.ImageUrl = "/graphics/bar0.png"
    End If
    If Not IsDBNull(rsm.UserID) then
      usr.Load(rsm.UserID )
      lblCSRAgent.text = usr.UserName
    end if
    If rsm.MiddleName.Trim.Length > 0 Then
      lblContact.Text &= " " & rsm.MiddleName
    End If
    If rsm.LastName.Trim.Length > 0 Then
      lblContact.Text &= " " & rsm.LastName
    End If
    lnkEmail.HRef = "mailto:" & rsm.Email & "?subject=" & System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & "%20ID%3A%20" & rsm.ResumeID
    lnkWebsite.HRef = "http://" & rsm.WebSite
    Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
    strQueryString = strQueryString.Replace("?", "%3f")
    strQueryString = strQueryString.Replace("&", "%26")
    lnkAddAddress.HRef = "addaddress.aspx?id=" & lngResumeID.ToString & "&mode=resume&returnurl=resume.aspx%3f" & strQueryString
    lnkAddPhoneNumber.HRef = "addphone.aspx?id=" & lngResumeID.ToString & "&mode=resume&returnurl=resume.aspx%3f" & strQueryString
    lnkDecline.HRef = "declineresume.aspx?id=" & lngResumeID.ToString & "&returnurl=resume.aspx%3f" & strQueryString
    lnkUnDecline.HRef = "undeclineresume.aspx?id=" & lngResumeID.ToString & "&returnurl=resume.aspx%3f" & strQueryString
    lnkPhase2.HRef = "sendtophase2.aspx?id=" & lngResumeID.ToString & "&returnurl=resume.aspx%3f" & strQueryString
    lnkContract.HRef = "sendcontract.aspx?id=" & lngResumeID.ToString & "&returnurl=resume.aspx%3f" & strQueryString
    lnkResetPassword.HRef = "resetresumepassword.aspx?id=" & lngResumeID.ToString & "&returnurl=resume.aspx%3f" & strQueryString
    lnkDocumentControl.HRef = "resumedocumentcontrol.aspx?id=" & lngResumeID.ToString & "&returnurl=resume.aspx%3f" & strQueryString
    lnkImport.HRef = "importpartner.aspx?id=" & lngResumeID.ToString & "&returnurl=resume.aspx%3f" & strQueryString
    If rsm.IsInFolder(BridgesInterface.ResumeRecord.ResumeSystemFolders.Completed) Then
      divImport.Visible = False
      lnkDecline.HRef = ""
      lnkUnDecline.HRef = ""
      lnkPhase2.HRef = ""
      lnkContract.HRef = ""
      Dim prt As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      prt.LoadByResumeID(rsm.ResumeID)            
      lnkPartner.HRef = "partner.aspx?id=" & prt.PartnerID
      divPartner.Visible = True
    Else
      divPartner.Visible = False
    End If
        If rsm.IsInFolder(BridgesInterface.ResumeRecord.ResumeSystemFolders.ReadyToImport) Then
           
            divImport.Visible = True
        Else
            divImport.Visible = False
        End If
    If rsm.WebLoginID > 0 Then
      divPhase2.Visible = True
      divResetPassword.Visible = True
    Else
      divPhase2.Visible = True
      divResetPassword.Visible = False
    End If
    lblEmail.Text = rsm.Email
    If rsm.DLStateID > 0 Then
      stt.Load(rsm.DLStateID)
      lblDL.Text = stt.StateName
    End If
    lblDL.Text &= " " & sec.GDecypher2(rsm.DLNumber)
    lblEIN.Text = sec.GDecypher2(rsm.EIN)
    lblSSN.Text = sec.GDecypher2(rsm.SSN)
    lblWebsite.Text = rsm.WebSite
    txtResume.Text = rsm.ResumeText
    txtMisc.Text = rsm.Misc
    lblCompanyName.Text = rsm.CompanyName
    If rsm.IPAddress.Trim.Length > 0 Then
      lblIPAddress.Text = "<a target=""_blank"" href=""http://www.whois.sc/" & rsm.IPAddress & """>" & rsm.IPAddress & "</a>"
    Else
      lblIPAddress.Text = ""
    End If
    lblReferrer.Text = rrr.Referrer
    lblReferrerOther.Text = rsm.ReferrerOther
    lblResumeType.Text = rtp.ResumeType
    lblEditResumeLink.Text = "<a href=""editresume.aspx?id=" & lngResumeID.ToString & "&returnurl=resume.aspx%3fresumeid=" & lngResumeID & """>Edit</a>"
    lblDateEntered.Text = rsm.DateCreated.ToString
    lblWindow.Text = rsm.ContactStart.ToString("00") & ":00 -" & rsm.ContactEnd.ToString("00") & ":00"
    lblLocalTime.Text = rsm.LocalTime.Hour.ToString("00") & ":" & rsm.LocalTime.Minute.ToString("00")
    chkSunday.Checked = rsm.ContactSunday
    chkMonday.Checked = rsm.ContactMonday
    chkTuesday.Checked = rsm.ContactTuesday
    chkWednesday.Checked = rsm.ContactWednesday
    chkThursday.Checked = rsm.ContactThursday
    chkFriday.Checked = rsm.ContactFriday
    chkSaturday.Checked = rsm.ContactSaturday
    lblEmergencyPhone.Text = ""
    If rsm.EmergencyCountryCode.Trim.Length > 0 Then
      lblEmergencyPhone.Text = rsm.EmergencyCountryCode
    End If
    If rsm.EmergencyAreaCode.Trim.Length > 0 Then
      lblEmergencyPhone.Text &= "(" & rsm.EmergencyAreaCode & ")"
    End If
    If rsm.EmergencyExchange.Trim.Length > 0 Then
      lblEmergencyPhone.Text &= " " & rsm.EmergencyExchange
    End If
    If rsm.EmergencyLineNumber.Trim.Length > 0 Then
      lblEmergencyPhone.Text &= "-" & rsm.EmergencyLineNumber
    End If
    lblEmergencyContact.Text = ""
    If rsm.EmergencyFirstName.Trim.Length > 0 Then
      lblEmergencyContact.Text = rsm.EmergencyFirstName
    End If
    If rsm.EmergencyMiddleName.Trim.Length > 0 Then
      lblEmergencyContact.Text &= " " & rsm.EmergencyMiddleName
    End If
    If rsm.EmergencyLastName.Trim.Length > 0 Then
      lblEmergencyContact.Text &= " " & rsm.EmergencyLastName
    End If
    If rsm.ContactStart < 24 Then
      datStart = DateTime.Today & " " & rsm.ContactStart.ToString("00") & ":00"
    Else
      datStart = DateTime.Today & " 23:59"
    End If
    If rsm.ContactEnd < 24 Then
      datEnd = DateTime.Today & " " & rsm.ContactEnd.ToString("00") & ":00"
    Else
      datEnd = DateTime.Today & " 23:59"
    End If
    If rsm.BusinessStartedMonthID > 0 Then
      mth.Load(rsm.BusinessStartedMonthID)
      lblBusinessStarted.Text = mth.MonthName
    End If
    If rsm.BusinessStartedYear > 0 Then
      lblBusinessStarted.Text &= " " & rsm.BusinessStartedYear.ToString
    End If
    If rsm.Declined Then
      lnkDecline.Visible = False
      lnkUnDecline.Visible = True
    Else
      lnkDecline.Visible = True
      lnkUnDecline.Visible = False
    End If
    If rsm.DLFileID > 0 Then
      strBlank = "<a href=""viewfile.aspx?id=" & rsm.DLFileID.ToString & """>Available</a>"
    Else
      strBlank = "NA"
    End If
    lblID.Text = strBlank
    If rsm.BlankContractFileID > 0 Then
      strBlank = "<a href=""viewfile.aspx?id=" & rsm.BlankContractFileID.ToString & """>UnSigned</a>"
    Else
      strBlank = "NA"
    End If
    If rsm.SignedContractFileID > 0 Then
      If rsm.SignatureFileID > 0 Then
        strSigned = rsm.ContractSignatureDate.ToString("M/dd/yyyy H:mm")
      Else
        strSigned = "<a href=""viewfile.aspx?id=" & rsm.SignedContractFileID.ToString & """>Signed</a>"
      End If
    Else
      strSigned = "NA"
    End If
    lblContract.Text = strBlank & "&nbsp;|&nbsp;" & strSigned
    If rsm.BlankWaiverFileID > 0 Then
      strBlank = "<a href=""viewfile.aspx?id=" & rsm.BlankWaiverFileID.ToString & """>UnSigned</a>"
    Else
      strBlank = "NA"
    End If
    If rsm.SignedWaiverFileID > 0 Then
      If rsm.SignatureFileID > 0 Then
        strSigned = rsm.WaiverSignatureDate.ToString("M/dd/yyyy H:mm")
      Else
        strSigned = "<a href=""viewfile.aspx?id=" & rsm.SignedWaiverFileID.ToString & """>Signed</a>"
      End If
    Else
      strSigned = "NA"
    End If
    lblWaiver.Text = strBlank & "&nbsp;|&nbsp;" & strSigned
    If rsm.BlankNDAFileID > 0 Then
      strBlank = "<a href=""viewfile.aspx?id=" & rsm.BlankNDAFileID.ToString & """>UnSigned</a>"
    Else
      strBlank = "NA"
    End If
    If rsm.SignedNDAFileID > 0 Then
      If rsm.SignatureFileID > 0 Then
        strSigned = rsm.NDASignatureDate.ToString("M/dd/yyyy H:mm")
      Else
        strSigned = "<a href=""viewfile.aspx?id=" & rsm.SignedNDAFileID.ToString & """>Signed</a>"
      End If
    Else
      strSigned = "NA"
    End If
    lblNDA.Text = strBlank & "&nbsp;|&nbsp;" & strSigned
    If rsm.BlankSignatureFileID > 0 Then
      strBlank = "<a href=""viewfile.aspx?id=" & rsm.BlankSignatureFileID.ToString & """>UnSigned</a>"
    Else
      strBlank = "NA"
    End If
    If rsm.SignatureFileID > 0 Then
      strSigned = "<a href=""viewfile.aspx?id=" & rsm.SignatureFileID.ToString & """>Signed</a>"
    Else
      strSigned = "NA"
    End If
    lblEsig.Text = strBlank & "&nbsp;|&nbsp;" & strSigned
    DetermineContactOkay(datStart, datEnd)
    flg.LoadByRemoteHost(rsm.IPAddress)
    If flg.FlagID > 0 Then
      divFlagged.Visible = True
      lblFlagText.Text = flg.RemoteHost & ", " & flg.Description
    Else
      divFlagged.Visible = False
    End If
  End Sub
  
  Private Sub DetermineContactOkay(ByVal datStart As Date, ByVal datEnd As Date)
    Dim blnContactOk As Boolean = False
    Select Case CType(lblLocalTime.Text, Date).DayOfWeek
      Case DayOfWeek.Sunday
        blnContactOk = chkSunday.Checked
      Case DayOfWeek.Monday
        blnContactOk = chkMonday.Checked
      Case DayOfWeek.Tuesday
        blnContactOk = chkTuesday.Checked
      Case DayOfWeek.Wednesday
        blnContactOk = chkWednesday.Checked
      Case DayOfWeek.Thursday
        blnContactOk = chkThursday.Checked
      Case DayOfWeek.Friday
        blnContactOk = chkFriday.Checked
      Case DayOfWeek.Saturday
        blnContactOk = chkSaturday.Checked
    End Select
    If blnContactOk Then
      If (CType(lblLocalTime.Text, Date).Hour >= datStart.Hour) And (CType(lblLocalTime.Text, Date).Hour <= datEnd.Hour) Then
        blnContactOk = True
      Else
        blnContactOk = False
      End If
    End If
    If blnContactOk Then
      tdLocalTime.Attributes("class") = "okay"
    Else
      tdLocalTime.Attributes("class") = "notokay"
    End If
  End Sub
  
  Private Sub LoadFolderMap()
    LoadSystemFolders()
    LoadPersonalFoldermap()
  End Sub
  
  Private Sub LoadPersonalFoldermap()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListFoldersResumeIsInByPersonal")
    Dim itm As New ListItem
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = CType(lblResumeID.Text, Long)
    cmd.Parameters.Add("@CreatedBY", Data.SqlDbType.Int).Value = Master.UserID
    cmd.Parameters.Add("@Personal", Data.SqlDbType.Bit).Value = True
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    dgvMemberOfPersonal.DataSource = dtr
    dgvMemberOfPersonal.DataBind()
    cbxRemoveFromFolders.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("UserName").ToString & "." & dtr("FolderName").ToString
      itm.Value = dtr("AssignmentID")
      cbxRemoveFromFolders.Items.Add(itm)
    End While
    cnn.Close()
  End Sub
  
  Private Sub LoadSystemFolders()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListFoldersResumeIsInByPersonal")
    Dim itm As New ListItem
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = CType(lblResumeID.Text, Long)
    cmd.Parameters.Add("@CreatedBY", Data.SqlDbType.Int).Value = Master.UserID
    cmd.Parameters.Add("@Personal", Data.SqlDbType.Bit).Value = False
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    dgvMemberOfSystem.DataSource = dtr
    dgvMemberOfSystem.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadRemovalFolders()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListFoldersResumeIsIn")
    Dim itm As New ListItem
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = CType(lblResumeID.Text, Long)
    cmd.Parameters.Add("@CreatedBY", Data.SqlDbType.Int).Value = Master.UserID
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxRemoveFromFolders.Items.Clear()
    While dtr.Read
      If CType(dtr("Personal"), Boolean) Then
        itm = New ListItem
        itm.Text = dtr("UserName").ToString & "." & dtr("FolderName").ToString
        itm.Value = dtr("AssignmentID")
        cbxRemoveFromFolders.Items.Add(itm)
      End If
    End While
    cnn.Close()
  End Sub
  
  Private Sub LoadResumeNotes(ByVal lngResumeID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListResumeNotes")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvNotes.DataSource = ds
    dgvNotes.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub LoadResumeAddresses(ByVal lngResumeID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListAddressesForResume")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvAddresses.DataSource = ds
    dgvAddresses.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub LoadResumePhoneNumbers(ByVal lngResumeID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListPhoneNumbersForResume")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvPhoneNumbers.DataSource = ds
    dgvPhoneNumbers.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub btnAddNote_Click(ByVal S As Object, ByVal E As EventArgs)
    If txtNote.Text.Trim.Length > 0 Then
      Dim rnt As New BridgesInterface.ResumeNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      rnt.Add(CType(lblResumeID.Text, Long), Master.UserID, txtNote.Text)
      LoadResumeNotes(CType(lblResumeID.Text, Long))
      txtNote.Text = ""
    End If
  End Sub

  Private Sub btnRemoveFromFolder_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim rfa As New BridgesInterface.ResumeFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If cbxRemoveFromFolders.Items.Count > 0 Then
      rfa.Load(CType(Me.cbxRemoveFromFolders.SelectedValue, Long))
      rfa.Delete()
      LoadFolderMap()
      LoadRemovalFolders()
    End If
  End Sub
  
  Private Sub btnAddToFolder_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim rfa As New BridgesInterface.ResumeFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rfa.Add(CType(lblResumeID.Text, Long), cbxPersonalFolders.SelectedValue)
    LoadPersonalFolders()
    LoadFolderMap()
    LoadRemovalFolders()
  End Sub
  
  Private Function CurrentResumeID() As Long
    Dim lngReturn As Long = 0
    If Long.TryParse(lblResumeID.Text, lngReturn) Then
    Else
      lngReturn = 0
    End If
    Return lngReturn
  End Function
  
  Private Sub LoadResumeRates(ByVal lngResumeID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListResumeRates")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvRates.DataSource = ds
    dgvRates.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub btnEditRate_Click(ByVal S As Object, ByVal E As DataGridCommandEventArgs)
    Response.Redirect("editrate.aspx?id=" & E.Item.Cells(0).Text, True)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmResume" runat="server" defaultbutton="btnQuickSearch">
    <div>
      <table style="width: 100%">
        <tbody>
          <tr>
            <td class="band" rowspan="2" style="width:1%">
              <div class="bandheader">
                <table style="width: 100%">
                  <tbody>
                    <tr>
                      <td style="width: 1%" class="label">Local&nbsp;Time:</td>
                      <td id="tdLocalTime" runat="server" style="border: solid 1px black; text-align: right;"><asp:Label ID="lblLocalTime" runat="server" /></td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div>&nbsp;</div>                            
              <div class="bandheader">System Folders</div>
              <asp:DataGrid GridLines="none" ID="dgvMemberOfSystem" ShowHeader="false" style="background-color: White; width: 100%" runat="server" AutoGenerateColumns="false">
                <Columns>
                  <asp:TemplateColumn>
                    <ItemTemplate>
                      <a style="white-space: nowrap;" href="recruit.aspx?folder=<%# Databinder.eval(Container.DataItem, "FolderID") %>"><img alt="folder" style="border:0;" src="/graphics/folder.png" /><%# Databinder.eval(Container.DataItem, "UserName") %>.<%# Databinder.eval(Container.DataItem, "FolderName") %></a>                    
                    </ItemTemplate>
                  </asp:TemplateColumn>
                </Columns>
              </asp:DataGrid>
              <div class="bandheader">Personal Folders</div>
              <asp:DataGrid GridLines="none" ID="dgvMemberOfPersonal" ShowHeader="false" style="background-color: White; width: 100%" runat="server" AutoGenerateColumns="false">
                <Columns>
                  <asp:TemplateColumn>
                    <ItemTemplate>
                      <a style="white-space: nowrap;" href="recruit.aspx?folder=<%# Databinder.eval(Container.DataItem, "FolderID") %>"><img alt="folder" style="border:0;" src="/graphics/folder.png" /><%# Databinder.eval(Container.DataItem, "UserName") %>.<%# Databinder.eval(Container.DataItem, "FolderName") %></a>                    
                    </ItemTemplate>
                  </asp:TemplateColumn>
                </Columns>
              </asp:DataGrid>
              <div>&nbsp;</div>
              <div class="inputformsectionheader">Add To Folder</div>
              <div class="inputform">                
                <div><asp:DropDownList style="width: 99%;" ID="cbxPersonalFolders" runat="server" /></div>
                <div style="text-align: right;"><asp:Button ID="btnAddToFolder" OnClick="btnAddToFolder_Click" runat="server" Text="add" /></div>
              </div>
              <div>&nbsp;</div>
              <div class="inputformsectionheader">Remove From Folder</div>
              <div class="inputform">                
                <div><asp:DropDownList style="width: 99%" ID="cbxRemoveFromFolders" runat="server" /></div>
                <div style="text-align: right;"><asp:Button ID="btnRemoveFromFolder" OnClick="btnRemoveFromFolder_Click" runat="server" Text="Remove" /></div>
              </div>
              <div>&nbsp;</div>
              <div class="inputformsectionheader">Search</div> 
              <div class="inputform" style="white-space: nowrap;">Quick Resume Search
                <div id="divResumeSearchError" class="errorzone" visible="false" runat="server" />
                <div style="padding-left: 3px;">
                  <div class="label">Criteria</div>
                  <div><asp:TextBox style="width:95%;" ID="txtResumeSearch" runat="server" /></div>
                  <div class="label">Look In</div>
                  <div><asp:DropDownList ID="cbxLookIn" runat="server" /></div>
                  <div style="text-align: right;"><asp:button ID="btnQuickSearch" OnClick="btnQuickSearch_Click" text="Search" runat="server" /></div>
                </div> 
              </div>
              <div>&nbsp;</div>
              <div class="inputformsectionheader">Commands</div>
              <div class="inputform"><a id="lnkDecline" runat="server">Decline</a>
              <div><a id="lnkUnDecline" runat="server">Un-Decline</a></div>
              <div id="divPhase2" runat="server"><a id="lnkPhase2" runat="server">Send to Phase 2</a></div>
              <div><a id="lnkContract" runat="server">Send Documents</a></div>
              <div id="divResetPassword" runat="server"><a id="lnkResetPassword" runat="server">Reset Password</a></div>
              <div id="divImport" runat="server"><a id="lnkImport" runat="server">Import Partner</a></div>
              <div id="divPartner" runat="server"><a id="lnkPartner" runat="server">View Partner</a></div>
              </div>
            </td>
            <td class="" style="vertical-align: top;">
              <div id="divFlagged" runat="server" class="errorzone" style="font-weight: bold; font-size: 14pt; color: red; text-decoration: underline;">THIS RESUME IS FROM A FLAGGED IP! (<asp:Label ID="lblFlagText" runat="server" />) DO NOT PROCEED WITH ANY OPERATIONS ON THIS RESUME UNTIL YOU HAVE CONSULTED WITH MANAGEMENT!</div>
              <div id="divDeclined" runat="server" style="font-weight: bold; color: Red; font-size: 12pt;">THIS RESUME HAS BEEN DECLINED</div>
              <div class="bandheader">Metrics <asp:Label ID="lblEditResumeLink" runat="server" /></div>
              <table style="width: 100%">
                <tbody>
                  <tr>
                    <td>
                      <table>
                        <tbody>
                          <tr>
                            <td class="label">CSR Agent</td>
                            <td><asp:label ID="lblCSRAgent" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Resume ID</td>
                            <td><asp:Label ID="lblResumeID" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Date Entered</td>
                            <td><asp:label id="lblDateEntered" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Entity Type</td>
                            <td><asp:Label ID="lblEntityType" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Company Name</td>
                            <td><asp:Label ID="lblCompanyName" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Business Started</td>
                            <td><asp:Label ID="lblBusinessStarted" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">EIN</td>
                            <td><asp:Label ID="lblEIN" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Contact</td>
                            <td><asp:Label ID="lblContact" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">SSN</td>
                            <td><asp:Label ID="lblSSN" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Drivers License</td>
                            <td><asp:Label ID="lblDL" runat="Server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Email</td>
                            <td><a id="lnkEmail" runat="server" href="mailto:"><asp:Label ID="lblEmail" runat="server" /></a></td>
                          </tr>
                          <tr>
                            <td class="label">Website</td>
                            <td><a id="lnkWebsite" runat="server" target="_blank"><asp:Label ID="lblWebsite" runat="server" /></a></td>
                          </tr>
                          <tr>
                            <td class="label">Emergency Contact</td>
                            <td><asp:Label ID="lblEmergencyContact" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Emergency Phone</td>
                            <td><asp:Label ID="lblEmergencyPhone" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Applied For</td>                          
                            <td><asp:Label ID="lblResumeType" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">IP</td>
                            <td><asp:Label ID="lblIPAddress" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Referrer</td>
                            <td><asp:label ID="lblReferrer" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">&nbsp;</td>
                            <td><asp:Label ID="lblReferrerOther" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">ICL</td>
                            <td><asp:Image ID="imgICL" runat="server" /></td>
                          </tr>
                          <tr>
                            <td colspan="2" class="bandheader">Documents <a id="lnkDocumentControl" runat="server">Control</a></td>
                          </tr>
                          <tr>
                            <td class="label">E-Signature</td>
                            <td><asp:Label ID="lblEsig" runat="server" /></td>
                          </tr>                          
                          <tr>
                            <td class="label">Contract</td>
                            <td><asp:Label ID="lblContract" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">NDA</td>
                            <td><asp:Label ID="lblNDA" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Waiver</td>
                            <td><asp:Label ID="lblWaiver" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">DL #</td>
                            <td><asp:Label ID="lblID" runat="server" /></td>
                          </tr>                          
                        </tbody>
                      </table>
                    </td>
                    <td>
                      <div class="bandheader">Phone Numbers</div>
                      <asp:DataGrid style="width:100%" ID="dgvPhoneNumbers" runat="server" AutoGenerateColumns="false">
                        <HeaderStyle CssClass="gridheader" />
                        <AlternatingItemStyle CssClass="altrow" />   
                        <Columns>
                          <asp:BoundColumn
                            DataField="PhoneType"
                            HeaderText="Type"
                            ItemStyle-Wrap="false"
                            />                    
                          <asp:TemplateColumn
                            HeaderText="Phone Number"
                            ItemStyle-Wrap="false"
                            >
                            <ItemTemplate>
                              <%# Databinder.eval(Container.DataItem, "CountryCode") %> (<%# Databinder.eval(Container.DataItem, "AreaCode") %>) <%# Databinder.eval(Container.DataItem, "Exchange") %>-<%# Databinder.eval(Container.DataItem, "LineNumber") %>
                            </ItemTemplate>
                          </asp:TemplateColumn>
                          <asp:BoundColumn
                            DataField="Extension"
                            headertext="Extension"
                            />
                          <asp:BoundColumn
                            DataField="Pin"
                            headertext="Pin"
                            />
                          <asp:TemplateColumn 
                            HeaderText="Active"
                            >             
                            <ItemTemplate>
                              <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                            </ItemTemplate>
                          </asp:TemplateColumn>                              
                          <asp:TemplateColumn
                            HeaderText="Command"
                            >
                            <Itemtemplate>
                              <a href="editphone.aspx?returnurl=resume.aspx%3fresumeid=<%# DataBinder.Eval(Container.DataItem,"ResumeID") %>&id=<%# DataBinder.Eval(Container.DataItem,"ResumePhoneNumberID") %>&mode=resume">Edit</a>
                            </Itemtemplate>
                          </asp:TemplateColumn>                            
                        </Columns>                
                      </asp:DataGrid>
                      <div style="text-align:right"><a id="lnkAddPhoneNumber" runat="server">[Add Phone Number]</a></div>
                      <div class="bandheader">Addresses</div>
                      <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvAddresses" runat="server">
                        <HeaderStyle CssClass="gridheader" />
                        <AlternatingItemStyle CssClass="altrow" />   
                        <Columns>
                          <asp:BoundColumn
                            DataField="AddressType"
                            HeaderText="Type"
                            ItemStyle-Wrap="false"
                            />
                          <asp:TemplateColumn
                            HeaderText="Address"
                            >
                            <ItemTemplate>
                              <%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%> 
                            </ItemTemplate>
                          </asp:TemplateColumn> 
                          <asp:BoundColumn
                            DataField="City"
                            HeaderText="City"
                            />
                          <asp:BoundColumn
                            DataField="StateAbbreviation"
                            HeaderText="State"
                            />
                            <asp:BoundColumn
                            DataField="CountyName"
                            HeaderText="County"
                            />
                            
                            <asp:TemplateColumn
                            HeaderText="Location"
                            >
                            <ItemTemplate>
                              <a href="../Maps/<%# Databinder.eval(Container.DataItem,"LocationName") %>.jpg" target="_blank"><%# Databinder.eval(Container.DataItem,"LocationName") %></a>                            </ItemTemplate>
                          </asp:TemplateColumn>
                          <asp:TemplateColumn
                            HeaderText="Zip"
                            >
                            <ItemTemplate>
                              <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
                            </ItemTemplate>
                          </asp:TemplateColumn>
                          <asp:TemplateColumn 
                            HeaderText="Active"
                            >             
                            <ItemTemplate>
                              <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                            </ItemTemplate>
                          </asp:TemplateColumn>                              

                          <asp:TemplateColumn
                            HeaderText="Command"
                            >
                            <Itemtemplate>
                              <a href="editaddress.aspx?returnurl=resume.aspx%3fresumeid=<%# DataBinder.Eval(Container.DataItem,"ResumeID") %>&id=<%# DataBinder.Eval(Container.DataItem,"ResumeAddressID") %>&mode=resume">Edit</a>
                            </Itemtemplate>
                          </asp:TemplateColumn>                                                    
                        </Columns>        
                      </asp:DataGrid>
                      <div style="text-align:right"><a id="lnkAddAddress" runat="server">[Add Address]</a></div>
                      <div class="bandheader">Rates</div>
                      <asp:DataGrid ID="dgvRates" style="width: 100%" OnItemCommand="btnEditRate_Click" runat="server" AutoGenerateColumns="false">
                        <HeaderStyle CssClass="gridheader" />
                        <AlternatingItemStyle CssClass="altrow" />   
                        <Columns>
                          <asp:BoundColumn
                            DataField="ResumeRateID"
                            HeaderText="ID"
                            visible="False"
                          />
                          <asp:BoundColumn
                            DataField="Description"
                            HeaderText="Type"
                            ItemStyle-Wrap="false"
                            />
                          <asp:BoundColumn
                            DataField="Rate"
                            HeaderText="Rate"
                            DataFormatString="{0:C}"
                            />                    
                          <asp:ButtonColumn
                            ButtonType="linkButton"
                            Text="Edit"
                            HeaderText="Command"
                            />
                        </Columns>                
                      </asp:DataGrid>                                  
                    </td>
                  </tr>
                </tbody>
              </table>
              <div class="bandheader">Contact Window</div>
              <div>
                <asp:Label ID="lblWindow" runat="server" /> 
                <asp:CheckBox ID="chkSunday" runat="server" Text="Sun" />
                <asp:CheckBox ID="chkMonday" runat="server" Text="Mon" />
                <asp:CheckBox ID="chkTuesday" runat="server" Text="Tue" />
                <asp:CheckBox ID="chkWednesday" runat="server" Text="Wed" />
                <asp:CheckBox ID="chkThursday" runat="server" Text="Thr" />
                <asp:CheckBox ID="chkFriday" runat="server" Text="Fri" />
                <asp:CheckBox ID="chkSaturday" runat="server" Text="Sat" />                
              </div>
              <div class="bandheader">Resume/Company Information</div>
              <div>
                <asp:TextBox cssclass="resumedisplay" TextMode="multiline" ID="txtResume" ReadOnly="true" runat="server" />
              </div>
              <div class="bandheader">Misc. Information</div>
              <div>
                <asp:TextBox CssClass="resumedisplay" style="height: 75px;" TextMode="multiline" ID="txtMisc" ReadOnly="true" runat="server" />
              </div>              
            </td>
          </tr>
          <tr>
            <td colspan="2">
              <div id="divNoteError" visible="false" runat="server" class="errorzone" />            
              <div class="label">Add Note</div>
              <div><asp:textbox ID="txtNote" runat="server" style="width: 99%; height: 100px;" TextMode="multiLine" /></div>
              <div style="text-align: right;"><asp:Button ID="btnAddNote" OnClick="btnAddNote_Click" runat="server" Text="Add Note" /></div>
              <div class="bandheader">Notes</div>
              <asp:DataGrid ID="dgvNotes" runat="server" ShowHeader="false" AutoGenerateColumns="false" style="width: 100%">
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns>
                  <asp:TemplateColumn ItemStyle-Width="1%" ItemStyle-VerticalAlign="top" >
                    <ItemTemplate>
                      <div style="white-space:nowrap;"><%# Databinder.eval(Container.DataItem, "DateCreated") %></div>
                      <div><a href="mailto:<%# Databinder.eval(Container.DataItem, "Email") %>"><%# Databinder.eval(Container.DataItem, "UserName") %></a></div>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn ItemStyle-Wrap="true">
                    <Itemtemplate>
                    <%# Databinder.eval(Container.DataItem, "NoteBody").ToString.Replace(environment.NewLine,"<br />") %>
                    </Itemtemplate>
                  </asp:TemplateColumn>
                </Columns>
              </asp:DataGrid>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </form>
</asp:Content>