''' <summary>
''' A page that allows a user to add details about his business to his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
Public Class Detail
  Inherits System.Web.UI.Page

#Region "Protected Sub-Routines"
  Protected Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    TrackTraffic()
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Recruitment"
    End If
    Dim strCompanyName As String = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
    lblCompanyNameHeader.Text = strCompanyName
    lblPhoneContact.Text = "Phone:<span style=""font-weight:normal"">" & System.Configuration.ConfigurationManager.AppSettings("PhoneNumber") & "</span>&nbsp;&nbsp;&nbsp;Fax:<span style=""font-weight:normal"">" & System.Configuration.ConfigurationManager.AppSettings("FaxNumber") & "</span>"
    DetermineStage()
    If Not IsPostBack Then
      LoadStates(cbxDLStates)
      LoadResumeAddresses(Master.ResumeID)
      LoadResumePhoneNumbers(Master.ResumeID)
      LoadResumeRates(Master.ResumeID)
      'LoadResumeTimeSlots(Master.ResumeID)
      LoadMonths(cbxMonths)
      LoadEntityTypes()
      LoadResume(Master.ResumeID)
    End If
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

  Private Sub DetermineStage()
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(CType(Master.ResumeID, Long))
    If rsm.BlankContractFileID > 0 Then
      Me.tdResume.Visible = False
      Me.divRedirect.Visible = True
      Response.Redirect("documents.aspx", True)
    End If
  End Sub

  Private Sub SaveResume()
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    Dim sec As New cvCommon.Security
    rsm.Load(Master.ResumeID)
    If txtEIN.Text.Trim.Length > 0 Then
      rsm.EIN = sec.GCypher2(txtEIN.Text.Trim)
    Else
      rsm.EIN = ""
    End If
    If txtSSN.Text.Trim.Length > 0 Then
      rsm.SSN = sec.GCypher2(txtSSN.Text.Trim)
    Else
      rsm.SSN = ""
    End If
    If txtDLNumber.Text.Trim.Length > 0 Then
      rsm.DLNumber = sec.GCypher2(txtDLNumber.Text.Trim)
    Else
      rsm.DLNumber = ""
    End If
    If txtYear.Text.Trim.Length > 0 Then
      rsm.BusinessStartedYear = CType(txtYear.Text, Integer)
    Else
      rsm.BusinessStartedYear = 0
    End If
    rsm.EntityTypeID = CType(cbxEntityTypes.SelectedValue, Long)
    rsm.BusinessStartedMonthID = CType(cbxMonths.SelectedValue, Integer)
    rsm.WebSite = txtWebsite.Text.Trim.Replace("http://", "").Replace("https://", "")
    rsm.DLStateID = cbxDLStates.SelectedValue
    rsm.CompanyName = txtCompanyName.Text
    rsm.EmergencyFirstName = flnEmergencyContact.FirstName
    rsm.EmergencyMiddleName = flnEmergencyContact.MI
    rsm.EmergencyLastName = flnEmergencyContact.LastName
    rsm.EmergencyAreaCode = phnEmergency.AreaCode
    rsm.EmergencyLineNumber = phnEmergency.LineNumber
    rsm.EmergencyExchange = phnEmergency.Exchange
    rsm.EmergencyCountryCode = "1"
    rsm.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(rsm.ConnectionString)
    act.Add(Master.UserID, "web", "web", "web", "web", 23, rsm.ResumeID, strChangeLog)
    DisplaySavedBox()
  End Sub

  Private Sub DisplaySavedBox()
    Dim strHTML As String = ""
    Dim strItems As String = GetNeededItems()
    strHTML = "<div class=""label"">Thank You, Information Saved!</div>"
    If strItems.Trim.Length > 0 Then
      strHTML &= "<div class=""label"">We do, however, need the following information as well...</div>"
      strHTML &= "<ul>"
      strHTML &= strItems
      strHTML &= "</ul>"
    Else
      divForm.Visible = False
      strHTML &= "Your information has been saved and we have all the required information. A representative of "
      strHTML &= System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName")
      strHTML &= " will review your application and will be contacting you soon!"
    End If
    divSaved.InnerHtml = strHTML
    divSaved.Visible = True
  End Sub

  Private Sub LoadResume(ByVal lngResumeID As Long)
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim sec As New cvCommon.Security
    rsm.Load(Master.ResumeID)
    If rsm.EIN.Trim.Length > 0 Then
      txtEIN.Text = sec.GDecypher2(rsm.EIN)
      txtConfirmEIN.Text = sec.GDecypher2(rsm.EIN)
    End If
    If rsm.SSN.Trim.Length > 0 Then
      txtSSN.Text = sec.GDecypher2(rsm.SSN)
      txtConfirmSSN.Text = sec.GDecypher2(rsm.SSN)
    End If
    If rsm.DLNumber.Trim.Length > 0 Then
      txtDLNumber.Text = sec.GDecypher2(rsm.DLNumber)
    End If
    txtWebsite.Text = rsm.WebSite
    txtCompanyName.Text = rsm.CompanyName
    If rsm.BusinessStartedYear > 0 Then
      txtYear.Text = rsm.BusinessStartedYear.ToString
    End If
    cbxMonths.SelectedValue = rsm.BusinessStartedMonthID
    cbxDLStates.SelectedValue = rsm.DLStateID
    cbxEntityTypes.SelectedValue = rsm.EntityTypeID
    flnEmergencyContact.FirstName = rsm.EmergencyFirstName
    flnEmergencyContact.MI = rsm.EmergencyMiddleName
    flnEmergencyContact.LastName = rsm.EmergencyLastName
    phnEmergency.AreaCode = rsm.EmergencyAreaCode
    phnEmergency.Exchange = rsm.EmergencyExchange
    phnEmergency.LineNumber = rsm.EmergencyLineNumber
  End Sub

  Private Sub LoadResumeAddresses(ByVal lngResumeID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListActiveAddressesForResume")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvAddresses.DataSource = ds
    dgvAddresses.DataBind()
    cnn.Close()
  End Sub

  Private Sub LoadResumeRates(ByVal lngResumeID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim rrt As New BridgesInterface.ResumeRateRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListActiveRateTypes")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    While dtr.Read
      rrt.Add(Master.UserID, CType(dtr("RateTypeID"), Long), CType(dtr("DefaultRate"), Long), CType(dtr("Hourly"), Boolean), lngResumeID)
    End While
    cnn.Close()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListResumeRates", "@ResumeID", lngResumeID, dgvRates)
  End Sub

  Private Sub LoadEntityTypes()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListEntityTypes")
    Dim itm As ListItem
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxEntityTypes.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("EntityType")
      itm.Value = dtr("EntityTypeID")
      cbxEntityTypes.Items.Add(itm)
    End While
    cnn.Close()
  End Sub

  'Private Sub LoadResumeTimeSlots(ByVal lngResumeID As Long)
  '  Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  '  Dim cmd As New System.Data.SqlClient.SqlCommand("spListResumeTimeSlotsForDay")
  '  Dim dtr As System.Data.SqlClient.SqlDataReader
  '  Dim strTemp As String = ""
  '  cmd.CommandType = Data.CommandType.StoredProcedure
  '  cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
  '  cmd.Parameters.Add("@WeekDayID", Data.SqlDbType.TinyInt).Value = 1
  '  cnn.Open()
  '  cmd.Connection = cnn
  '  dtr = cmd.ExecuteReader
  '  If dtr.HasRows Then
  '    While dtr.Read
  '      strTemp &= ctype(dtr("StartHour"),Integer).ToString("00") & ":" & ctype(dtr("StartMinute"),Integer).ToString("00") & " - " & ctype(dtr("EndHour"),Integer).ToString("00") & ":" & ctype(dtr("EndMinute"),Integer).ToString("00") & "; "
  '    End While
  '    tdSunday.InnerHtml = strTemp
  '    strTemp = ""
  '  Else
  '    tdSunday.InnerHtml = "Unavailable"
  '  End If
  '  dtr.Close()
  '  cmd = New System.Data.SqlClient.SqlCommand("spListResumeTimeSlotsForDay")
  '  cmd.CommandType = Data.CommandType.StoredProcedure
  '  cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
  '  cmd.Parameters.Add("@WeekDayID", Data.SqlDbType.TinyInt).Value = 2
  '  cmd.Connection = cnn
  '  dtr = cmd.ExecuteReader
  '  If dtr.HasRows Then
  '    While dtr.Read
  '      strTemp &= ctype(dtr("StartHour"),Integer).ToString("00") & ":" & ctype(dtr("StartMinute"),Integer).ToString("00") & " - " & ctype(dtr("EndHour"),Integer).ToString("00") & ":" & ctype(dtr("EndMinute"),Integer).ToString("00") & "; "
  '    End While
  '    tdMonday.InnerHtml = strTemp
  '    strTemp = ""
  '  Else
  '    tdMonday.InnerHtml = "Unavailable"
  '  End If
  '  dtr.Close()
  '  cmd = New System.Data.SqlClient.SqlCommand("spListResumeTimeSlotsForDay")
  '  cmd.CommandType = Data.CommandType.StoredProcedure
  '  cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
  '  cmd.Parameters.Add("@WeekDayID", Data.SqlDbType.TinyInt).Value = 3
  '  cmd.Connection = cnn
  '  dtr = cmd.ExecuteReader
  '  If dtr.HasRows Then
  '    While dtr.Read
  '      strTemp &= ctype(dtr("StartHour"),Integer).ToString("00") & ":" & ctype(dtr("StartMinute"),Integer).ToString("00") & " - " & ctype(dtr("EndHour"),Integer).ToString("00") & ":" & ctype(dtr("EndMinute"),Integer).ToString("00") & "; "
  '    End While
  '    tdTuesday.InnerHtml = strTemp
  '    strTemp = ""
  '  Else
  '    tdTuesday.InnerHtml = "Unavailable"
  '  End If
  '  dtr.Close()
  '  cmd = New System.Data.SqlClient.SqlCommand("spListResumeTimeSlotsForDay")
  '  cmd.CommandType = Data.CommandType.StoredProcedure
  '  cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
  '  cmd.Parameters.Add("@WeekDayID", Data.SqlDbType.TinyInt).Value = 4
  '  cmd.Connection = cnn
  '  dtr = cmd.ExecuteReader
  '  If dtr.HasRows Then
  '    While dtr.Read
  '      strTemp &= ctype(dtr("StartHour"),Integer).ToString("00") & ":" & ctype(dtr("StartMinute"),Integer).ToString("00") & " - " & ctype(dtr("EndHour"),Integer).ToString("00") & ":" & ctype(dtr("EndMinute"),Integer).ToString("00") & "; "
  '    End While
  '    tdWednesday.InnerHtml = strTemp
  '    strTemp = ""
  '  Else
  '    tdWednesday.InnerHtml = "Unavailable"
  '  End If
  '  dtr.Close()
  '  cmd = New System.Data.SqlClient.SqlCommand("spListResumeTimeSlotsForDay")
  '  cmd.CommandType = Data.CommandType.StoredProcedure
  '  cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
  '  cmd.Parameters.Add("@WeekDayID", Data.SqlDbType.TinyInt).Value = 5
  '  cmd.Connection = cnn
  '  dtr = cmd.ExecuteReader
  '  If dtr.HasRows Then
  '    While dtr.Read
  '      strTemp &= ctype(dtr("StartHour"),Integer).ToString("00") & ":" & ctype(dtr("StartMinute"),Integer).ToString("00") & " - " & ctype(dtr("EndHour"),Integer).ToString("00") & ":" & ctype(dtr("EndMinute"),Integer).ToString("00") & "; "
  '    End While
  '    tdThursday.InnerHtml = strTemp
  '    strTemp = ""
  '  Else
  '    tdThursday.InnerHtml = "Unavailable"
  '  End If
  '  dtr.Close()
  '  cmd = New System.Data.SqlClient.SqlCommand("spListResumeTimeSlotsForDay")
  '  cmd.CommandType = Data.CommandType.StoredProcedure
  '  cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
  '  cmd.Parameters.Add("@WeekDayID", Data.SqlDbType.TinyInt).Value = 6
  '  cmd.Connection = cnn
  '  dtr = cmd.ExecuteReader
  '  If dtr.HasRows Then
  '    While dtr.Read
  '      strTemp &= ctype(dtr("StartHour"),Integer).ToString("00") & ":" & ctype(dtr("StartMinute"),Integer).ToString("00") & " - " & ctype(dtr("EndHour"),Integer).ToString("00") & ":" & ctype(dtr("EndMinute"),Integer).ToString("00") & "; "
  '    End While
  '    tdFriday.InnerHtml = strTemp
  '    strTemp = ""
  '  Else
  '    tdFriday.InnerHtml = "Unavailable"
  '  End If
  '  dtr.Close()
  '  cmd = New System.Data.SqlClient.SqlCommand("spListResumeTimeSlotsForDay")
  '  cmd.CommandType = Data.CommandType.StoredProcedure
  '  cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
  '  cmd.Parameters.Add("@WeekDayID", Data.SqlDbType.TinyInt).Value = 7
  '  cmd.Connection = cnn
  '  dtr = cmd.ExecuteReader
  '  If dtr.HasRows Then
  '    While dtr.Read
  '      strTemp &= ctype(dtr("StartHour"),Integer).ToString("00") & ":" & ctype(dtr("StartMinute"),Integer).ToString("00") & " - " & ctype(dtr("EndHour"),Integer).ToString("00") & ":" & ctype(dtr("EndMinute"),Integer).ToString("00") & "; "
  '    End While
  '    tdSaturday.InnerHtml = strTemp
  '    strTemp = ""
  '  Else
  '    tdSaturday.InnerHtml = "Unavailable"
  '  End If
  '  cnn.Close()
  'End Sub

  Private Sub LoadResumePhoneNumbers(ByVal lngResumeID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListActivePhoneNumbersForResume")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = lngResumeID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvPhoneNumbers.DataSource = ds
    dgvPhoneNumbers.DataBind()
    cnn.Close()
  End Sub

  ''' <summary>
  ''' Loads the states into the appropriate combo
  ''' </summary>
  Private Sub LoadMonths(ByRef cbx As System.Web.UI.WebControls.DropDownList)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListMonths")
    Dim itm As ListItem
    Dim lngSelectedValue As Long = 0
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbx.Items.Clear()
    itm = New ListItem
    itm.Text = "[Choose One]"
    itm.Value = 0
    cbx.Items.Add(itm)
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("MonthName")
      itm.Value = dtr("MonthID")
      cbx.Items.Add(itm)
    End While
    cnn.Close()
  End Sub

  ''' <summary>
  ''' Loads the states into the appropriate combo
  ''' </summary>
  Private Sub LoadStates(ByRef cbx As System.Web.UI.WebControls.DropDownList)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListStates")
    Dim itm As ListItem
    Dim lngSelectedValue As Long = 0
    If Long.TryParse(cbx.SelectedValue, lngSelectedValue) Then
      lngSelectedValue = CType(cbx.SelectedValue, Long)
    End If
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbx.Items.Clear()
    itm = New ListItem
    itm.Text = "[Choose One]"
    itm.Value = 0
    cbx.Items.Add(itm)
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("StateName")
      itm.Value = dtr("StateID")
      cbx.Items.Add(itm)
    End While
    If lngSelectedValue > 0 Then
      cbx.SelectedValue = lngSelectedValue.ToString
    End If
    cnn.Close()
  End Sub

#End Region

#Region "Private Functions"
  Private Function GetNeededItems() As String
    Dim strReturn As String = ""
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(Master.ResumeID)
    If dgvPhoneNumbers.Items.Count = 0 Then
      strReturn &= "<li>At Least One Phone Number</li>"
    End If
    If dgvAddresses.Items.Count = 0 Then
      strReturn &= "<li>At Least On Address</li>"
    End If
    If rsm.CompanyName.Trim.Length = 0 Then
      strReturn &= "<li>Company Name</li>"
    End If
    If rsm.BusinessStartedMonthID = 0 Then
      strReturn &= "<li>Business Start Month</li>"
    End If
    If rsm.BusinessStartedYear = 0 Then
      strReturn &= "<li>Business Start Year</li>"
    End If
    If rsm.DLNumber.Trim.Length = 0 Then
      strReturn &= "<li>Drivers License Number</li>"
    End If
    If rsm.DLStateID = 0 Then
      strReturn &= "<li>Drivers License State</li>"
    End If
    If rsm.EIN.Trim.Length = 0 Then
      strReturn &= "<li>EIN</li>"
    End If
    If rsm.SSN.Trim.Length = 0 Then
      strReturn &= "<li>SSN</li>"
    End If
    If rsm.EmergencyAreaCode.Trim.Length = 0 Then
      strReturn &= "<li>Emergency Contact Phone Number Area Code</li>"
    End If
    If rsm.EmergencyExchange.Trim.Length = 0 Then
      strReturn &= "<li>Emergency Contact Phone Number Exchange (First 3 Digits)</li>"
    End If
    If rsm.EmergencyLineNumber.Trim.Length = 0 Then
      strReturn &= "<li>Emergency Contact Phone Number Line Number (Last 4 Digits)</li>"
    End If
    If rsm.EmergencyFirstName.Trim.Length = 0 Then
      strReturn &= "<li>Emergency Contact First Name</li>"
    End If
    If rsm.EmergencyLastName.Trim.Length = 0 Then
      strReturn &= "<li>Emergency Contact Last Name</li>"
    End If
    If rsm.EntityTypeID = 1 Then
      strReturn &= "<li>Entity Type Needs To Be A Business Type (Individuals Should Choose Sole Proprietership)</li>"
    End If
    Return strReturn
  End Function

  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim lngYear As Long = 0
    Dim lngID As Long = 0
    If txtYear.Text.Trim.Length > 0 Then
      If txtYear.Text.Trim.Length <> 4 Then
        strErrors &= "<li>Business Start Year Needs to be in 4 Digit Format</li>"
        blnReturn = False
      End If
      If Not Long.TryParse(txtYear.Text, lngYear) Then
        strErrors &= "<li>Business Start Year Needs to be a Number</li>"
        blnReturn = False
      Else
        If lngYear > DateTime.Now.Year Then
          strErrors &= "<li>Business Start Year Can Not be in the Future</li>"
          blnReturn = False
        End If
      End If
    End If
    If txtEIN.Text.Trim <> txtConfirmEIN.Text.Trim Then
      strErrors &= "<li>EINs Do Not Match</li>"
      blnReturn = False
    End If
    If txtSSN.Text.Trim <> txtConfirmSSN.Text.Trim Then
      strErrors &= "<li>SSNs Do Not Match</li>"
      blnReturn = False
    End If
    If txtEIN.Text.Trim.Length > 0 Then
      If txtEIN.Text.Trim.Length <> 9 Then
        strErrors &= "<li>EIN Must Be 9 Digits</li>"
        blnReturn = False
      End If
      If Not Long.TryParse(txtEIN.Text, lngID) Then
        strErrors &= "<li>EIN Requires Numbers Only</li>"
        blnReturn = False
      End If
    End If
    If txtSSN.Text.Trim.Length > 0 Then
      If txtSSN.Text.Trim.Length <> 9 Then
        strErrors &= "<li>SSN Must Be 9 Digits</li>"
        blnReturn = False
      End If
      If Not Long.TryParse(txtSSN.Text, lngID) Then
        strErrors &= "<li>SSN Requires Numbers Only</li>"
        blnReturn = False
      End If
    End If
    If txtEIN.Text.Trim.Length + txtSSN.Text.Trim.Length > 0 Then
      If txtEIN.Text.Trim.ToLower = txtSSN.Text.Trim.ToLower Then
        strErrors &= "<li>SSN and EIN Can Not Be The Same</li>"
        blnReturn = False
      End If
    End If
    If phnEmergency.AreaCode.Trim.Length + phnEmergency.LineNumber.Trim.Length + phnEmergency.Exchange.Trim.Length > 0 Then
      If phnEmergency.AreaCode.Trim.Length <> 3 Then
        strErrors &= "<li>Emergency Phone Area Code is Invalid</li>"
        blnReturn = False
      End If
      If phnEmergency.Exchange.Trim.Length <> 3 Then
        blnReturn = False
        strErrors &= "<li>Emergency Phone Exchange is Invalid</li>"
      End If
      If phnEmergency.LineNumber.Trim.Length <> 4 Then
        blnReturn = False
        strErrors &= "<li>Emergency Phone Line Number is Invalid</li>"
      End If
      If blnReturn Then
        Dim phn As New BridgesInterface.ResumePhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        phn.Load(phnEmergency.AreaCode, phnEmergency.Exchange, phnEmergency.LineNumber)
        If phn.ResumePhoneNumberID > 0 Then
          strErrors &= "<li>Emergency Phone Can Not Match Existing Phone Numbers</li>"
          blnReturn = False
        End If
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

#End Region

#Region "Event Handlers"
  Protected Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveResume()
    Else
      divErrors.Visible = True
    End If
  End Sub

  Protected Sub btnAddPhoneNumber_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveResume()
      Response.Redirect("addphone.aspx", True)
    Else
      divErrors.Visible = True
    End If
  End Sub

  Protected Sub btnAddAddress_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveResume()
      Response.Redirect("addaddress.aspx", True)
    Else
      divErrors.Visible = True
    End If
  End Sub

  Protected Sub btnEditPhone_Click(ByVal S As Object, ByVal E As DataGridCommandEventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveResume()
      Response.Redirect("editphone.aspx?id=" & E.Item.Cells(0).Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub

  Protected Sub btnEditAddress_Click(ByVal S As Object, ByVal E As DataGridCommandEventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveResume()
      Response.Redirect("editaddress.aspx?id=" & E.Item.Cells(0).Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub

  Protected Sub btnEditRate_Click(ByVal S As Object, ByVal E As DataGridCommandEventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveResume()
      Response.Redirect("editrate.aspx?id=" & E.Item.Cells(0).Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub

#End Region

End Class