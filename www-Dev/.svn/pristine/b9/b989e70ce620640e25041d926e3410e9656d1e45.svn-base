''' <summary>
''' A page that allows a user to add his online resume
''' </summary>
''' <remarks>
'''   Completed: 08/23/2007
'''   Author: Bill Hedge
'''   Modifications: None
''' </remarks>
''' 

Public Class _default
    Inherits System.Web.UI.Page
    Private _UserID As Long = 1
    Private _InfoID As Long = 1
    
#Region "Private Sub Routines"
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

  Private Sub LoadTimeBoxes()
    StuffTimeBox(cbxStart)
    StuffTimeBox(cbxEnd)
  End Sub

  Private Sub StuffTimeBox(ByRef cbx As DropDownList)
    cbx.Items.Clear()
    Dim itm As ListItem
    For X As Integer = 0 To 24
      itm = New ListItem
      itm.Value = X
      itm.Text = X.ToString("00") & ":00"
      cbx.Items.Add(itm)
    Next
  End Sub

  Private Sub LoadReferrers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListResumeReferrers", "Referrer", "ReferrerID", cbxReferrers)
  End Sub

  Private Sub LoadResumeTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListResumeTypes", "ResumeType", "ResumeTypeID", cbxResumeTypes)
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
#End Region

#Region "Protected Sub Routines"
  Protected Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Response.Buffer = True
    If CType(System.Configuration.ConfigurationManager.AppSettings("DownForMaintenance"), Boolean) Then
      Response.Redirect(System.Configuration.ConfigurationManager.AppSettings("MaintenanceUrl"), True)
      Response.Flush()
      Response.End()
    Else
      Dim strCompanyName As String = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
      Dim lngCopyrightStartYear As Integer = CType(System.Configuration.ConfigurationManager.AppSettings("CopyrightStartYear"), Integer)
            'If lngCopyrightStartYear > DateTime.Now.Year Then
            'lblCopyYears.Text = lngCopyrightStartYear.ToString & " - " & DateTime.Now.Year.ToString
            'Else
            '   lblCopyYears.Text = lngCopyrightStartYear.ToString
            'End If
            'lblCopyCompany.Text = strCompanyName
            'lblCompanyName.Text = strCompanyName
            'lblCompanyNameHeader.Text = strCompanyName
            'lblPhoneContact.Text = "Phone:<span style=""font-weight:normal"">" & System.Configuration.ConfigurationManager.AppSettings("PhoneNumber") & "</span>&nbsp;&nbsp;&nbsp;Fax:<span style=""font-weight:normal"">" & System.Configuration.ConfigurationManager.AppSettings("FaxNumber") & "</span>"
            lblPartnerSupportNumber.Text = System.Configuration.ConfigurationManager.AppSettings("PhoneNumber")
            Me.Page.Title = "Join " & strCompanyName
            If Not IsPostBack() Then
                TrackTraffic()
                LoadReferrers()
                LoadEntityTypes()
                LoadTimeBoxes()
                LoadResumeTypes()
            End If
        End If
  End Sub

  Protected Sub SubmitResume(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      If divInput.Visible Then
        Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim rsa As New BridgesInterface.ResumeAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim rsp As New BridgesInterface.ResumePhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

                Dim strChangeLog As String = ""
        Dim WebUserID As Long = CType(System.Configuration.ConfigurationManager.AppSettings("WebUserID"), Long)
        rsm.Load(txtEmail.Text)
        If rsm.ResumeID = 0 Then
          rsm = New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    rsm.Add(WebUserID, CType(cbxEntityTypes.SelectedValue, Long), flnContact.FirstName, flnContact.LastName, txtEmail.Text.Trim, txtResume.Text.Trim, chkMonday.Checked, chkTuesday.Checked, chkWednesday.Checked, chkThursday.Checked, chkFriday.Checked, chkSaturday.Checked, chkSunday.Checked, CType(cbxStart.SelectedValue, Integer), CType(cbxEnd.SelectedValue, Integer), 1, 1)
          rsm.MiddleName = flnContact.MI
          rsm.CompanyName = txtCompanyName.Text
          rsm.Misc = txtCompanyName.Text
          rsm.WebSite = txtWebsite.Text.Trim.Replace("http://", "").Replace("https://", "")
                    rsm.ResumeTypeID = CType(cbxResumeTypes.SelectedValue, Long)
                    rsm.ReferrerID = CType(cbxReferrers.SelectedValue, Long)

                    rsm.ReferrerOther = txtReferrerOther.Text

                    rsm.IPAddress = Request.ServerVariables("REMOTE_ADDR")

                    'Assign Resume to Region Folder
                    AssignResumeToFolder(rsm.ResumeID, CType(addContact.StateID, Long))

                    If GetUserForStateID(CType(addContact.StateID, Long)) <> 1 Then
                        rsm.UserID = GetUserForStateID(CType(addContact.StateID, Long))
                    End If
                    If rsm.Modified Then
                        rsm.Save(strChangeLog)
                    End If

                    rsa.Add(rsm.ResumeID, WebUserID, CType(addContact.StateID, Long), CType(addContact.AddressTypeID, Long), addContact.Street, addContact.City, addContact.Zip)
                    rsa.StateID = CType(addContact.StateID, Long)
                    rsa.Extended = addContact.Extended
                    If rsa.Modified Then
                        rsa.Save(strChangeLog)
                    End If
                    rsp.Add(rsm.ResumeID, phnPrimary.PhoneTypeID, WebUserID, "1", phnPrimary.AreaCode, phnPrimary.Exchange, phnPrimary.LineNumber)
                    rsp.Extension = phnPrimary.Extension
                    rsp.Pin = phnPrimary.Pin
                    If rsp.Modified Then
                        rsp.Save(strChangeLog)
                    End If
                    If phnSecondary.AreaCode.Trim.Length > 0 Then
                        rsp = New BridgesInterface.ResumePhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
                        rsp.Add(rsm.ResumeID, phnSecondary.PhoneTypeID, WebUserID, "1", phnSecondary.AreaCode, phnSecondary.Exchange, phnSecondary.LineNumber)
                        rsp.Extension = phnSecondary.Extension
                        rsp.Pin = phnSecondary.Pin
                        If rsp.Modified Then
                            rsp.Save(strChangeLog)
                        End If
                    End If
                    lblResumeID.Text = rsm.ResumeID.ToString
                    divResult.Visible = True
                    divInput.Visible = False
                Else
                    lblPSResumeID.Text = rsm.ResumeID.ToString
                    divDuplicate.Visible = True
                    divInput.Visible = False
                End If
            Else
                divResult.Visible = True
                divInput.Visible = False
            End If
    Else
      divError.Visible = True
    End If
  End Sub
#End Region

#Region "Private Functions"
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strError As String = "<ul>"
    Dim val As New cvCommon.Validators
    If txtEmail.Text.Trim.Length > 0 Then
      If Not val.IsValidEmail(txtEmail.Text.Trim) Then
        blnReturn = False
        strError &= "<li>Email does not appear to be valid</li>"
      End If
    End If
    If flnContact.FirstName.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "First Name is Required" & "</li>"
    End If
    If flnContact.LastName.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "Last Name is Required" & "</li>"
    End If
    If txtEmail.Text.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "Email is Required" & "</li>"
    End If
    If addContact.Street.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "Street is Required" & "</li>"
    End If
    If addContact.City.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "City is Required" & "</li>"
    End If
    If addContact.Zip.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>" & "Zip is Required" & "</li>"
    Else
      Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      zip.Load(addContact.Zip.Trim)
      If zip.ZipCodeID <= 0 Then
        blnReturn = False
        strError &= "<li>Zip is either invalid or in an improper format</li>"
      End If
    End If
    If phnPrimary.AreaCode.Trim.Length + phnPrimary.LineNumber.Trim.Length + phnPrimary.Exchange.Trim.Length > 0 Then
      If phnPrimary.AreaCode.Trim.Length <> 3 Then
        blnReturn = False
        strError &= "<li>" & "Primary Phone Area Code is Invalid" & "</li>"
      End If
      If phnPrimary.Exchange.Trim.Length <> 3 Then
        blnReturn = False
        strError &= "<li>" & "Primary Phone Exchange is Invalid" & "</li>"
      End If
      If phnPrimary.LineNumber.Trim.Length <> 4 Then
        blnReturn = False
        strError &= "<li>" & "Primary Phone Line Number is Invalid" & "</li>"
      End If
    Else
      blnReturn = False
      strError &= "<li>" & "Primary Phone is Required" & "</li>"
    End If
    If phnSecondary.AreaCode.Trim.Length + phnSecondary.LineNumber.Trim.Length + phnSecondary.Exchange.Trim.Length > 0 Then
      If phnSecondary.AreaCode.Trim.Length <> 3 Then
        strError &= "<li>Secondary Phone Area Code is Invalid</li>"
        blnReturn = False
      End If
      If phnSecondary.Exchange.Trim.Length <> 3 Then
        blnReturn = False
        strError &= "<li>Secondary Phone Exchange is Invalid</li>"
      End If
      If phnSecondary.LineNumber.Trim.Length <> 4 Then
        blnReturn = False
        strError &= "<li>Secondary Phone Line Number is Invalid</li>"
      End If
    End If
    If txtResume.Text.Trim.Length = 0 Then
      blnReturn = False
      strError &= "<li>Resume/Company Information is Required</li>"
    End If
    Dim intDayCount As Integer = 0
    If chkSunday.Checked Then
      intDayCount += 1
    End If
    If chkMonday.Checked Then
      intDayCount += 1
    End If
    If chkTuesday.Checked Then
      intDayCount += 1
    End If
    If chkWednesday.Checked Then
      intDayCount += 1
    End If
    If chkThursday.Checked Then
      intDayCount += 1
    End If
    If chkFriday.Checked Then
      intDayCount += 1
    End If
    If chkSaturday.Checked Then
      intDayCount += 1
    End If
    If intDayCount = 0 Then
      blnReturn = False
      strError &= "<li>You Must Choose at Least One Day That You Are Available For Contact</li>"
    End If
    If CType(cbxStart.SelectedValue, Long) > CType(cbxEnd.SelectedValue, Long) Then
      blnReturn = False
      strError &= "<li>Contact Window Start Must Be Less Than Its End</li>"
    End If
    If CType(cbxStart.SelectedValue, Long) + CType(cbxEnd.SelectedValue, Long) = 0 Then
      blnReturn = False
      strError &= "<li>Contact Window Must Be Set (Please choose two different times)</li>"
    End If
    strError &= "</ul>"
    divError.InnerHtml = strError
    Return blnReturn
  End Function
    Private Sub AssignResumeToFolder(ByVal lngResumeID As Long, ByVal lngStateID As Long)
        Dim fld As New BridgesInterface.ResumeFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        Select Case lngStateID
            Case Is = 1, 10, 11, 25, 34, 41, 43, 52, 53 'South East 9
                fld.Add(lngResumeID, 9)
            Case Is = 7, 8, 9, 20, 21, 22, 30, 31, 33, 39, 40, 46, 47, 49 'North East 10
                fld.Add(lngResumeID, 10)
            Case Is = 14, 15, 16, 18, 23, 24, 26, 36, 50 'Midwest 11
                fld.Add(lngResumeID, 11)
            Case Is = 4, 17, 19, 37, 44 'South Central 25
                fld.Add(lngResumeID, 25)
            Case Is = 27, 28, 35, 42, 51 'North Central 26
                fld.Add(lngResumeID, 26)
            Case Is = 3, 6, 32, 45 'South West 27
                fld.Add(lngResumeID, 27)
            Case Is = 5, 29, 12 'North West  28
                fld.Add(lngResumeID, 28)
            Case Is = 2, 13, 38, 48 'West 29
                fld.Add(lngResumeID, 29)
        End Select

    End Sub

    Private Function GetUserForStateID(ByVal lngStateID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetUserRecruitAssignmentByStateID")
        Dim dtr As System.Data.SqlClient.SqlDataReader
        Dim lngUserID As Long
        lngUserID = 1
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@StateID", Data.SqlDbType.Int).Value = lngStateID

        cnn.Open()
        cmd.Connection = cnn
        dtr = cmd.ExecuteReader
        While dtr.Read
            lngUserID = dtr("UserID")
        End While
        Return lngUserID
        cnn.Close()
    End Function


#End Region

End Class