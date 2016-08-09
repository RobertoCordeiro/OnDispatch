<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>

<%@ Register Assembly="RadCalendar.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  Private _PartnerID As Long = 0
    Private _InfoID As Long = 0
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Partner Agent"
      Master.PageTitleText = "Edit Partner Agent"
      'Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""partners.aspx"">Partner Management</a> &gt; "
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    If _ID > 0 Then
      Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      par.Load(_ID)
      _PartnerID = par.PartnerID
      Dim prt As New BridgesInterface.PartnerRecord (System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      prt.Load(par.PartnerID)
      Dim inf As New BridgesInterface.CompanyInfoRecord (System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      inf.Load(prt.InfoID)
      If inf.PartnerID = prt.PartnerID then
         Master.PageSubHeader &= "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""mycompany.aspx?id=" & prt.InfoID & """>My Company</a>"
                lblReturnUrl.Text = "mycompany.aspx?id=" & inf.CustomerID & "&t=2&infoID=" & prt.InfoID
                _InfoID = inf.infoID
      Else
         Master.PageSubHeader &= "<a href=""partner.aspx?id=" & par.PartnerID & """>Partner</a> &gt; Edit Partner Agent"
                lblReturnUrl.Text = "partner.aspx?id=" & par.PartnerID
                
      end if
      
      If Not IsPostBack Then
        LoadAgent(_ID)
                menu.Items(0).Selected = True
                RadDatePicker1.SelectedDate = DateTime.Now.Date
                RadDatePicker2.SelectedDate = DateTime.Now.Date
                LoadWeekDays()
                LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)
                lnkAddAddress.HRef = "addaddress.aspx?id=" & par.PartnerID  & "&returnurl=editpartneragent.aspx?id=" & _ID & "&mode=partner"
                lnkAddPhone.HRef = "addphone.aspx?id=" & par.PartnerID  & "&returnurl=editpartneragent.aspx?id=" & _ID & "&mode=partner"
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
    
  Private Sub LoadAgent(ByVal lngID As Long)
    LoadAgentTypes()
    LoadAgentStatuses()
    LoadScheduleZoneTypes()
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    par.Load(lngID)
    
    ptr.Load(par.PartnerID)
    'If lblReturnUrl.Text.Trim.Length = 0 Then
    '  lblReturnUrl.Text = "partner.aspx?id=" & par.PartnerID
    'End If
    lblResumeID.Text = ptr.ResumeID & "."
        chkAdminAgent.Checked = par.AdminAgent
        chkScheduleHisOwnAppt.Checked = par.ScheduleHisOwnAppt
    cbxAgentTypes.SelectedValue = par.AgentTypeID
    cbxStatus.SelectedValue = par.PartnerAgentStatusID 
    txtEmail.Text = par.Email
    fnlAgent.FirstName = par.FirstName
    fnlAgent.MI = par.MiddleName
    fnlAgent.LastName = par.LastName
        chkAgentActive.Checked = par.Active
        chkSunday.Checked = par.WorkDaySunday
        chkMonday.Checked = par.WorkDayMonday
        chkTuesday.Checked = par.WorkDayTuesday
        chkWednesday.Checked = par.WorkDayWednesday
        chkThursday.Checked = par.WorkDayThursday
        chkFriday.Checked = par.WorkDayFriday
        chkSaturday.Checked = par.WorkDaySaturday
        txtSpecialInstructions.Text = par.SpecialInstructions 
        If par.ScheduleZoneTypeID > 0 then
          drpScheduleZoneTypes.SelectedValue = par.ScheduleZoneTypeID 
        end if
    If par.DLFileID > 0 Then
      lnkDL.HRef = "viewfile.aspx?id=" & par.DLFileID
    End If
    If par.WebLoginID > 0 Then
      Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      wbl.Load(par.WebLoginID)
      txtLogin.Text = wbl.Login
      chkCreateLogin.Text = "Change Password"
      txtLogin.ReadOnly = True
      chkActive.Checked = wbl.Active
      lblResumeID.Visible = False
    Else
      chkCreateLogin.Checked = False
      chkActive.Visible = False
    End If
    LoadAssignedPhoneNumbers()
    LoadUnassignedPhoneNumbers()
    LoadAssignedAddresses()
    LoadUnassignedAddresses()
    LoadAssignedResumeTypes()
    LoadUnassignedResumeTypes()
        LoadAttachedDocuments(_ID)
        LoadPartnerAgentCertifications(_ID)
        LoadCertificateAgencies()
        ListScheduleAvailabilityCodes()
        if par.ScheduleZoneTypeID > 0 then
           Dim lngWeekDay As Long
           lngWeekDay = weekday(DateTime.Now.Date)
         
          LoadUnAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,lngWeekDay )
          LoadAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,lngWeekDay )
        End If
        
  End Sub
  
  Private Sub LoadAssignedPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentPhoneNumbers", "@PartnerAgentID", _ID, dgvAssociatedPhoneNumbers)
    lblAssociatedCount.Text = dgvAssociatedPhoneNumbers.Items.Count
  End Sub

  Private Sub LoadAssignedAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentAddresses", "@PartnerAgentID", _ID, Me.dgvAddresses)
        'lblAssignedAddresssCount.Text = dgvAddresses.Items.Count
  End Sub

  Private Sub LoadUnassignedPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListUnassignedPhoneNumbersForPartnerAgent", "@PartnerAgentID", _ID, Me.dgvUnassignedPhoneNumbers)
    lblUnassociatedCount.Text = dgvUnassignedPhoneNumbers.Items.Count
  End Sub

  Private Sub LoadUnassignedAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListUnassignedAddressesForPartnerAgent", "@PartnerAgentID", _ID, Me.dgvUnassignedAddresses)
        'lblUnAssignedAddresssCount.Text = dgvUnassignedAddresses.Items.Count
  End Sub
  'Load Assigned Labor Networks
  Private Sub LoadAssignedResumeTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListAssignedPartnerAgentResumeTypes", "@PartnerAgentID", _ID, dgvResumeTypes)
    lblAssociatedCount.Text = dgvAssociatedPhoneNumbers.Items.Count
  End Sub
  'Load Unassigned Labor Networks
  Private Sub LoadUnAssignedResumeTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListUnassignedPartnerAgentResumeTypes", "@PartnerAgentID", _ID, dgvUnassignedResumeTypes)
    lblAssociatedCount.Text = dgvAssociatedPhoneNumbers.Items.Count
    End Sub
    
    Private Sub LoadCertificateAgencies()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListCertificateAgencies", "AgencyName", "AgencyID", drpCertificateAgencies)
        drpCertificateAgencies.Items.Add("Choose One")
        drpCertificateAgencies.SelectedValue = "Choose One"
        drpCertificateTypes.Items.Add("Choose One")
        drpCertificateTypes.SelectedValue = "Choose One"
    End Sub
  
  Private Sub AssignAddresses()
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chk As System.Web.UI.WebControls.CheckBox
    Dim aaa As New BridgesInterface.PartnerAgentAddressAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvUnassignedAddresses.Items
      chk = itm.FindControl("chkSelectedAddress")      
      If chk.Checked Then    
        aaa.Add(Master.UserID, CType(itm.Cells(0).Text, Long), _ID)
      End If
    Next
  End Sub
  
  Private Sub AssignPhoneNumbers()
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chk As System.Web.UI.WebControls.CheckBox
    Dim apa As New BridgesInterface.PartnerAgentPhoneNumberAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvUnassignedPhoneNumbers.Items
      chk = itm.FindControl("chkSelected")
      If Not IsNothing(chk) Then
        If chk.Checked Then
          apa.Add(Master.UserID, _ID, CType(itm.Cells(0).Text, Long))
        End If
      End If
    Next
  End Sub
  
  Private Sub AssignResumeTypes()
    Dim itm As System.Web.UI.WebControls.DataGridItem
    Dim chk As System.Web.UI.WebControls.CheckBox
    Dim rty As New BridgesInterface.PartnerAgentResumeTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm In dgvUnassignedResumeTypes.Items
      chk = itm.FindControl("chkSelectedResumeType")      
      If chk.Checked Then    
        rty.Add( _ID,CType(itm.Cells(0).Text, Long))
      End If
    Next
  End Sub
  
    
  Private Sub LoadAgentTypes()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListAgentTypes")
    cmd.CommandType = Data.CommandType.StoredProcedure
    Dim itm As ListItem
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxAgentTypes.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("AgentType")
      itm.Value = dtr("AgentTypeID")
      cbxAgentTypes.Items.Add(itm)
    End While
    cnn.Close()
  End Sub
  
  Private Sub LoadAgentStatuses()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListAgentStatuses")
    cmd.CommandType = Data.CommandType.StoredProcedure
    Dim itm As ListItem
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    cbxStatus.Items.Clear()
    While dtr.Read
      itm = New ListItem
      itm.Text = dtr("PartnerAgentStatus")
      itm.Value = dtr("PartnerAgentStatusID")
      cbxStatus.Items.Add(itm)
    End While
    cnn.Close()
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim blnReturn As Boolean = True
    Dim lng As Long = 0
    Dim strErrors As String = ""
    If fnlAgent.FirstName.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>First Name is Required</li>"
    End If
    If fnlAgent.LastName.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Last Name is Required</li>"
    End If
    If chkCreateLogin.Checked Then
      wbl.Load(lblResumeID.Text & txtLogin.Text)
      Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      par.Load(_ID)
      If par.WebLoginID = 0 Then
        If txtLogin.Text.Trim.Length = 0 Then
          blnReturn = False
          strErrors &= "<li>Login is Required</li>"
        End If
        If Not Long.TryParse(txtLogin.Text.Trim, lng) Then
          blnReturn = False
          strErrors &= "<li>Login Must Be Numeric</li>"
        End If
        If wbl.WebLoginID > 0 Then
          blnReturn = False
          strErrors &= "<li>Login already exist, please use another</li>"
        End If
      End If
      If txtPassword.Text.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Password is Required</li>"
      End If
      If txtConfirmPassword.Text.Trim.Length = 0 Then
        blnReturn = False
        strErrors &= "<li>Confirmation Password is Required</li>"
      End If
      If txtPassword.Text.Trim.Length + txtConfirmPassword.Text.Trim.Length > 0 Then
        If txtPassword.Text.Trim <> txtConfirmPassword.Text.Trim Then
          blnReturn = False
          strErrors &= "<li>Passwords do not Match</li>"
        End If
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnApply_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Save()
      LoadAgent(_ID)
      divErrors.Visible = False
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub Save()
    Dim strTrash As String = ""
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
    Dim sta as  New BridgesInterface.WebLoginRecord(system.Configuration.configurationManager.AppSettings ("DBCnn"))
    
    par.Load(_ID)
    par.FirstName = fnlAgent.FirstName
    par.LastName = fnlAgent.LastName
    par.MiddleName = fnlAgent.MI
    par.Email = txtEmail.Text
    par.AdminAgent = chkAdminAgent.Checked
        par.Active = chkAgentActive.Checked
        par.ScheduleHisOwnAppt = chkScheduleHisOwnAppt.Checked
    par.AgentTypeID = CType(cbxAgentTypes.SelectedValue, Long)
    par.Email = txtEmail.Text
        par.PartnerAgentStatusID = cbxStatus.SelectedValue
        par.WorkDayMonday = chkMonday.Checked
        par.WorkDayTuesday = chkTuesday.Checked
        par.WorkDayWednesday = chkWednesday.Checked
        par.WorkDayThursday = chkThursday.Checked
        par.WorkDayFriday = chkFriday.Checked
        par.WorkDaySaturday = chkSaturday.Checked
        par.WorkDaySunday = chkSunday.Checked
    If chkCreateLogin.Checked Then
      If par.WebLoginID > 0 Then
        wbl.Load(par.WebLoginID)
        wbl.SetPassword(txtPassword.Text.Trim)
        wbl.Active = chkActive.Checked
        wbl.Save(strTrash)
            Else
                If _InfoID = 0 Then
                    wbl.Add(Master.UserID, lblResumeID.Text & txtLogin.Text.Trim, txtPassword.Text.Trim, "P")
                Else
                    wbl.Add(Master.UserID, lblResumeID.Text & txtLogin.Text.Trim, txtPassword.Text.Trim, "E")
                End If
                par.WebLoginID = wbl.WebLoginID
      End If
    End If
    par.SpecialInstructions = txtSpecialInstructions.text
    
    AssignPhoneNumbers()
    AssignAddresses()
        AssignResumeTypes()
        If drpWeekDays.SelectedValue = "Week Days" then
             If chkSunday.Checked then
               AssignScheduleZones(1)
             else
               UnAssignScheduleZones(1)
             end if
             If chkMonday.Checked then
               AssignScheduleZones(2)
             Else
              UnAssignScheduleZones(2)
             end if
             If chkTuesday.Checked then
               AssignScheduleZones(3)
             Else
               UnAssignScheduleZones(3)
             end if
             If chkWednesday.Checked then
               AssignScheduleZones(4)
             else
               UnAssignScheduleZones(4)
             end if
             If chkThursday.Checked then
               AssignScheduleZones(5)
             Else
               UnAssignScheduleZones(5)
             end if
             If chkFriday.Checked then
               AssignScheduleZones(6)
             Else
               UnAssignScheduleZones(6)
             end if
             If chkSaturday.Checked then
               AssignScheduleZones(8)
             Else
               UnAssignScheduleZones(8)
             end if
             
             LoadUnAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,1 )
             LoadAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,1 )
        Else
           AssignScheduleZones(Ctype(drpWeekDays.SelectedValue,Long))
            If drpWeekDays.SelectedValue = 1 then
              par.WorkDaySunday = True
            end if
            If drpWeekDays.SelectedValue = 2 then
             par.WorkDayMonday = True
            end if
            If drpWeekDays.SelectedValue = 3 then
             par.WorkDayTuesday = True
            end if
            If drpWeekDays.SelectedValue = 4 then
             par.WorkDayWednesday = True
            end if
            If drpWeekDays.SelectedValue = 5 then
             par.WorkDayThursday = True
            end if
            If drpWeekDays.SelectedValue = 6 then
             par.WorkDayFriday = True
            end if
            If drpWeekDays.SelectedValue = 8 then
             par.WorkDaySaturday = True
            end if
            LoadUnAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,drpWeekDays.SelectedValue)
            LoadAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,drpWeekDays.SelectedValue)

        end if
        par.Save(strTrash)
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
            'Save()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function CurrentID() As Long
    Return _ID
  End Function
  
  Private Function MapIt(ByVal strAddress As String, ByVal strZipCode As String) As String
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
    strReturn = ggl.MapAddress(strAddress, strZipCode)
    Return strReturn
    '<a target="_blank" href="<%# MapIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%></a>
  End Function
 Private Sub menu_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu.MenuItemClick
        Multiview1.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0
                
            Case Is = 1
                
            Case Is = 2
                
            Case Is = 3
                
        End Select
        
    End Sub
    
      Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
        'Response.Redirect("PartnerAgentDocumentsUpload.aspx?fid=" & _PartnerID & "&id=" & _ID & "&returnurl=partner.aspx?id=" & _PartnerID & "&mode=doc&updt=0")
        
    End Sub
    
    Private Sub LoadAttachedDocuments(ByVal lngPartnerAgentID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSingleLongParameterDataGrid("spGetPartnerAgentDocuments", "@PartnerAgentID", lngPartnerAgentID, dgvAttachments)
    End Sub
    
    Private Sub Item_Click(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs)
        Dim strTest As String
        Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
        Dim par As New BridgesInterface.PartnerAgentDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        dim ptr as New BridgesInterface.PartnerAgentRecord(system.configuration.configurationmanager.appsettings("DBCnn"))    
        dim ptn as New BridgesInterface.PartnerRecord(system.configuration.configurationmanager.appsettings("DBCnn"))    
        Dim rnt As New BridgesInterface.ResumeNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        strTest = (CType(e.CommandSource, LinkButton)).CommandName
        Select Case (CType(e.CommandSource, LinkButton)).CommandName
            
            Case "View"
                
            Case "Update"
                
            Case "Remove"

               
        End Select
    End Sub
    
    Private Sub LoadPartnerAgentCertifications(ByVal lngPartnerAgentID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSingleLongParameterDataGrid("spGetPartnerAgentCertifications", "@PartnerAgentID", lngPartnerAgentID, dgvPartnerAgentCertifications)
    End Sub
    
    Protected Sub drpCertificateAgencies_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpCertificateAgencies.SelectedValue <> "Choose One" Then
            LoadCertifications(CType(drpCertificateAgencies.SelectedValue, Long))
        Else
            drpCertificateTypes.SelectedValue = "Choose One"
        End If
    End Sub
    
    Private Sub LoadCertifications(ByVal lngAgencyID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDropDownList("spListCertificationsForAgency", "@AgencyID", lngAgencyID, "CertificationName", "CertificationID", drpCertificateTypes)
        drpCertificateTypes.Items.Add("Choose One")
        drpCertificateTypes.SelectedValue = ("Choose One")
    End Sub
    
    'Protected Sub drpScheduleZones_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
      '  If drpScheduleZones.SelectedValue <> "Choose One" Then
       '     LoadScheduleZones(CType(drpScheduleZones.SelectedValue, Long))
       ' Else
       '     drpScheduleZones.SelectedValue = "Choose One"
        'End If
    'End Sub
    
    Private Sub ListScheduleAvailabilityCodes()
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr1.LoadSimpleDropDownList("spListScheduleAvailabilityCodes",  "CodeName", "ScheduleAvailabilityCodeID", drpScheduleCodes)
        drpScheduleCodes.Items.Add("Choose One")
        drpScheduleCodes.SelectedValue = ("Choose One")
    End Sub
    Private Sub LoadUnAssignedScheduleAvailabilityZones(ByVal lngTicketID As Long, ByVal lngScheduleZoneTypeID as long, ByVal lngWeekDayID As long)
    Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr1.LoadThreeLongParameterDataGrid("spListUnassignedScheduleAvailabilityForPartnerAgent", "@PartnerAgentID", lngTicketID,"@ScheduleZoneTypeID",lngScheduleZoneTypeID,"WeekDayID",lngWeekDayID, dgvUnAssignedScheduleAvailabilityZones)
    lblAssociatedCount.Text = dgvUnAssignedScheduleAvailabilityZones.Items.Count
    End Sub
    Private Sub LoadAssignedScheduleAvailabilityZones(ByVal lngTicketID As Long, ByVal lngScheduleZoneTypeID as long, ByVal lngWeekDayID As long)
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr1.LoadThreeLongParameterDataGrid("spListAssignedScheduleAvailabilityForPartnerAgent", "@PartnerAgentID", lngTicketID,"@ScheduleZoneTypeID",lngScheduleZoneTypeID,"WeekDayID",lngWeekDayID, dgvAssignedScheduleAvailabilityZones)
        lblAssociatedCount.Text = dgvAssignedScheduleAvailabilityZones.Items.Count
    End Sub
    Private Sub AssignScheduleZones(lngWeekdayID As long)
        Dim itm As System.Web.UI.WebControls.DataGridItem
        Dim chk As System.Web.UI.WebControls.CheckBox
        Dim rty As New BridgesInterface.PartnerAgentAvailabilityRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strChangeLog as String = ""
        For Each itm In dgvUnAssignedScheduleAvailabilityZones.Items
            chk = itm.FindControl("chkSelected")
            If chk.Checked Then
                If IsScheduleZoneAssignedToPartnerAgent(_ID,Ctype(itm.Cells(0).Text,Long),lngWeekDayID) = 0 then
                  rty.Add(_ID, CType(itm.Cells(0).Text, Long),lngWeekDayID)
                else
                  rty.Load(GetPartnerAgentAvailabilityIDByTemplateID(_ID,Ctype(itm.Cells(0).Text,Long),lngWeekDayID))
                  rty.Active = True
                  rty.Save(strChangeLog)
                end if
            End If
        Next
        
    End Sub
    
    Private Sub LoadScheduleZoneTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spGetScheduleZoneTypes", "Description","ScheduleZoneTypeID",drpScheduleZoneTypes)
     drpScheduleZoneTypes.Items.Add("Choose One")
        drpScheduleZoneTypes.SelectedValue = "Choose One"   
  End Sub
  Private Sub btnSet_Click(ByVal S As Object, ByVal E As EventArgs)
       if drpScheduleZoneTypes.SelectedValue <> "Choose One" then
         Dim strChangeLog as String = ""
         Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
         par.Load (_ID)
         par.ScheduleZoneTypeID = drpScheduleZoneTypes.SelectedValue
         par.Save (strChangeLog)
         If drpWeekDays.SelectedValue = "Week Days" then
           LoadUnAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,1 )
           LoadAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,1 )
         Else
           LoadUnAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,drpWeekDays.SelectedValue)
           LoadAssignedScheduleAvailabilityZones(_ID,par.ScheduleZoneTypeID,drpWeekDays.SelectedValue)
         end if 
      end if 
    End Sub
    Private Function IsScheduleZoneAssignedToPartnerAgent (ByVal lngPartnerAgentID as Long, Byval lngScheduleZoneTemplateID as Long, ByVal lngWeekDayID As long) as Long
      Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim cmd As New System.Data.SqlClient.SqlCommand("spIsScheduleZoneAssociatedToPartnerAgent")
  
      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
      cmd.Parameters.Add("@ScheduleZoneTemplateID", Data.SqlDbType.Int).Value = lngScheduleZoneTemplateID
      cmd.Parameters.Add("@WeekDayID",Data.SqlDbType.Int).Value = lngWeekDayID
      cnn.open        
      cmd.Connection = cnn
      IsScheduleZoneAssignedToPartnerAgent = cmd.ExecuteScalar()
      cnn.Close()

   end function
   
   Private Function GetPartnerAgentAvailabilityIDByTemplateID (ByVal lngPartnerAgentID as Long, Byval lngScheduleZoneTemplateID as Long, ByVal lngWeekDayID As long) as Long
      Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPartnerAgentAvailabilityIDByTemplateID")
  
      cmd.CommandType = Data.CommandType.StoredProcedure
      cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
      cmd.Parameters.Add("@ScheduleZoneTemplateID", Data.SqlDbType.Int).Value = lngScheduleZoneTemplateID
      cmd.Parameters.Add("@WeekDayID",Data.SqlDbType.Int).Value = lngWeekDayID
      cnn.open        
      cmd.Connection = cnn
      GetPartnerAgentAvailabilityIDByTemplateID = cmd.ExecuteScalar()
      cnn.Close()

    End Function
    
    Private Sub LoadAvailabilityForDay(ByVal lngPartnerAgentID As Long, ByVal datScheduleDay As DateTime)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadLongDateParameterDataGrid("spGetScheduleForPartnerAgentPerDay", "@PartnerAgentID", lngPartnerAgentID, "@ScheduleDay", datScheduleDay, dgvShowAvailabilityforDay)
        
    End Sub
    Private Sub ShowSchedules(ByVal sender As Object, ByVal e As Telerik.WebControls.SelectedDateChangedEventArgs)
        If Not IsDBNull(RadDatePicker1.SelectedDate) Then
            If Not IsDBNull(RadDatePicker2.SelectedDate) Then
                LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)
            Else
                LoadAvailabilityForDay(_ID, (RadDatePicker1.SelectedDate))
            End If
        End If
    End Sub
    
    Private Sub LoadAvailabilityForDayRange(ByVal lngPartnerAgentID As Long, ByVal datScheduleDay As DateTime, ByVal datScheduleDay2 As DateTime)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadLongTwoDateParameterDataGrid("spGetScheduleForPartnerAgentPerDayRange", "@PartnerAgentID", lngPartnerAgentID, "@ScheduleDay", datScheduleDay, "@ScheduleDay2", datScheduleDay2, dgvShowAvailabilityforDay)
        
    End Sub
    
    Private Sub btnSetDayOff_Click(ByVal S As Object, ByVal E As EventArgs)
        If drpScheduleCodes.SelectedValue <> "Choose One" Then
            Dim TotalVacDays As Integer
            Dim CurrD As DateTime
            Dim dgItem As DataGridItem
            Dim chkBox As New CheckBox
            Dim rty As New BridgesInterface.ScheduleAvailabilityAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

            Select Case drpScheduleCodes.SelectedValue
                Case Is = 2, 7 'vacation
                    
                    CurrD = RadDatePicker1.SelectedDate
                    
                    TotalVacDays = DateDiff("d", RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)
                    If TotalVacDays > 0 Then
                        While (CurrD <= RadDatePicker2.SelectedDate)
                            For Each dgItem In dgvAssignedScheduleAvailabilityZones.Items
                                'chkbox = dgItem.FindControl("chkselected")
                                'If chkbox.Checked Then
                                If IsScheduleTimeFrameAvailableForPartnerAgentID(_ID, CType(dgItem.Cells(1).Text, Long), CurrD.Date) = 0 Then
                                   
                                    rty.Add(_ID, CurrD.Date, (CType(dgItem.Cells.Item(1).Text, Integer)), drpScheduleCodes.SelectedValue)
                                Else
                                    'message   
                                    MsgBox("The time-frame Type: " & dgItem.Cells.Item(3).Text & " is already scheduled for something else and it is not available for " & CurrD.ToShortDateString & ". Unable to set time off.")
                                End If
                                'End If
                            Next
                            LoadAssignedScheduleAvailabilityZones(_ID, CType(drpScheduleZoneTypes.SelectedValue, Long), Weekday(CurrD.AddDays(1)))
                            CurrD = CurrD.AddDays(1)
                        End While
                        
                    Else
                        'message  
                        MsgBox("The start date must be prior from end date.")
                    End If
                    LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)
                Case Else
                    CurrD = RadDatePicker1.SelectedDate
                    For Each dgItem In dgvAssignedScheduleAvailabilityZones.Items
                        chkBox = dgItem.FindControl("chkSelect")
                        If chkBox.Checked Then
                            If IsScheduleTimeFrameAvailableForPartnerAgentID(_ID, CType(dgItem.Cells(1).Text, Long), CurrD.Date) = 0 Then
                                   
                                rty.Add(_ID, CurrD.Date, (CType(dgItem.Cells.Item(1).Text, Integer)), drpScheduleCodes.SelectedValue)
                            Else
                                'message   
                                MsgBox("The time-frame Type: " & dgItem.Cells.Item(3).Text & " is already scheduled for something else and it is not available for " & CurrD.ToShortDateString & ". Unable to set time off.")
                            End If
                        End If
                    Next
                    LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)

            End Select
            
            
            Dim strChangeLog As String = ""
            Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            par.Load(_ID)
            par.ScheduleZoneTypeID = drpScheduleZoneTypes.SelectedValue
            par.Save(strChangeLog)
            Dim lngWeekDay As Long
            lngWeekDay = Weekday(RadDatePicker1.SelectedDate )
            
            LoadUnAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,lngWeekday)
            LoadAssignedScheduleAvailabilityZones(_ID, par.ScheduleZoneTypeID,lngWeekDay)
        End If
    End Sub
    Private Sub MsgBox(ByVal strMessage As String)
        'Begin building the script 
        Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
        strScript += "alert(""" & strMessage & """)" & vbCrLf
        strScript += "<" & "/" & "SCRIPT" & ">"
        'Register the script for the client side 
        ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript)
    End Sub
    
    Private Function IsScheduleTimeFrameAvailableForPartnerAgentID(ByVal lngPartnerAgentID As Long, ByVal lngPartnerAgentAvailabilityID As Long, ByVal datSetDate As DateTime) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsScheduleTimeFrameAvailableForPartnerAgentID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
        cmd.Parameters.Add("@PartnerAgentAvailabilityID", Data.SqlDbType.Int).Value = lngPartnerAgentAvailabilityID
        cmd.Parameters.Add("@SetDate", Data.SqlDbType.DateTime).Value = datSetDate
        cnn.Open()
        cmd.Connection = cnn
        IsScheduleTimeFrameAvailableForPartnerAgentID = cmd.ExecuteScalar()
        cnn.Close()

    End Function
    Protected Sub chkAll_OnCheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        
        For Each dgItem In dgvShowAvailabilityforDay.Items
            chkbox = dgItem.FindControl("chkRemove")
            If Not chkbox.Checked Then
                chkbox.Checked = True
            Else
                chkbox.Checked = False
            End If
        Next
    End Sub
    Private Sub btnRemove_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        Dim rty As New BridgesInterface.ScheduleAvailabilityAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        For Each dgItem In dgvShowAvailabilityforDay.Items
            chkbox = dgItem.FindControl("chkRemove")
            If chkbox.Checked Then
                rty.Load(CType(dgItem.Cells.Item(0).Text, Integer))
                If rty.TicketID.ToString.Length < 2 Then
                    rty.Delete()
                Else
                    MsgBox("You have ticket(s) scheduled for the time-frame you are trying to set time off for. Unable to set time off.")
                End If
            End If
        Next
        LoadAvailabilityForDayRange(_ID, RadDatePicker1.SelectedDate, RadDatePicker2.SelectedDate)

    End Sub
    
    Private Sub LoadWeekDays()
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListWeekDays", "DayName","WeekDayID",drpWeekDays)
        drpWeekDays.Items.Add ("Week Days")
        drpWeekDays.SelectedValue = "Week Days"        
    End Sub
    
    Private Sub UnAssignScheduleZones(lngWeekdayID As long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spRemovePartnerAgentAvailabilities2")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = _ID
        cmd.Parameters.Add("WeekDayID", Data.SqlDbType.Int).Value = lngWeekDayID
        cnn.open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()           
        
    End Sub
    Protected Sub drpScheduleZoneTypes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSet.Click
        btnSet_Click(sender, e)
    End Sub
    Protected Sub drpWeekDays_OnSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSet.Click
        btnSet_Click(sender, e)
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div style="padding: 4px 4px 4px 4px">
      <table  width ="100%" >
        <tbody>
          <tr>
            <td>
              <div class="errorzone" id="divErrors" runat="server" visible="false"/>
              <div class="label">Status</div>
              <div><asp:DropDownList ID="cbxStatus" style="width:98%" runat="server" /></div>
              <div class="label">Agent Type</div>
              <div><asp:DropDownList ID="cbxAgentTypes" style="width:98%" runat="server" /></div>
              <cv:FirstLastName ID="fnlAgent" runat="server" />
              <div class="label">Email Address</div>
              <asp:TextBox style="width: 97%" ID="txtEmail" runat="server" />
              <div class="label">Special Instructions</div>
              <div style="padding-right: 5px"><asp:TextBox runat="server" ID="txtSpecialInstructions" TextMode="multiLine" style="width: 100%; height: 30px;"/> </div>
              <div>&nbsp;</div>
              <div><a id="lnkDL" runat="server">Drivers License</a>&nbsp;<a href="upload.aspx?id=<%# currentid %>&mode=dl">[Upload New]</a></div>
              <div style="text-align: right;"><asp:CheckBox ID="chkScheduleHisOwnAppt" runat="server" Text="Schedule His Own Appt" />&nbsp;&nbsp;&nbsp;<asp:CheckBox ID="chkAdminAgent" runat="server" Text="Admin Agent" />&nbsp;<asp:CheckBox ID="chkAgentActive" Text="Active" runat="server" /></div>
              <div>&nbsp;</div>    
            </td>
            <td >
              <div>&nbsp;</div>
              <asp:CheckBox Text="Create Web Login" ID="chkCreateLogin" runat="server" />
              <div class="label">Login</div>
              <asp:Label style="font-weight: bold;" ID="lblResumeID" runat="server" /><asp:TextBox ID="txtLogin" MaxLength="32" runat="server" />
              <div class="label">Password</div>
              <asp:TextBox style="width: 99%" ID="txtPassword" runat="server" />
              <div class="label">Confirm Password</div>
              <asp:TextBox style="width: 99%" ID="txtConfirmPassword" runat="server" />
              <div>&nbsp;</div>
              <div style="text-align: right"><asp:CheckBox ID="chkActive" runat="server" Text="Login Active" /></div>
            </td>
            <td></td>
          </tr>
          <tr>
             <td colspan ="3">
                     <div id="tab5">
                     <asp:Menu ID="menu" runat="server" Orientation="Horizontal" OnMenuItemClick ="menu_MenuItemClick" CssClass="ul">
                         <StaticMenuItemStyle CssClass="li" />
                         <StaticHoverStyle CssClass="hoverstyle" />
                         <StaticSelectedStyle CssClass="current" />
                            <Items>
                                 <asp:MenuItem  value ="0" Text="Assigned Items"></asp:MenuItem>
                                 <asp:MenuItem value ="1" Text="Attached Documents"></asp:MenuItem> 
                                 <asp:MenuItem Value = "2" Text="Certifications"></asp:MenuItem>
                                 <asp:MenuItem Value = "3" Text="Schedule Availability"></asp:MenuItem>
                            </Items>
                     </asp:Menu>
                     </div>
                     <div id="ratesheader" class="tabbody">
                      <div>&nbsp;</div></div>
            </td> 
            <td >
            </td> 
            <td></td>
          </tr> 
          <tr>   
            <td  colspan="3"  class="tabbody">
              <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
                 <asp:View ID="viewNotes"  runat="server">
                   <table  width="100%">
                      <tr>
                         <td colspan ="2">
                            <div class="inputformsectionheader"><asp:label ID="lblAssociatedCount" runat="server" />&nbsp;Associated&nbsp;Phone&nbsp;Number(s)</div>
                            <asp:DataGrid style="width: 100%" ID="dgvAssociatedPhoneNumbers" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                              <AlternatingItemStyle CssClass="altrow" />
                                <HeaderStyle CssClass="gridheader" />
                                  <Columns>
                                     <asp:BoundColumn HeaderText="ID" DataField="AssignmentID" visible="false" />                    
                                     <asp:TemplateColumn>
                                        <ItemTemplate>
                                           <a href="removePartneragentphonenumber.aspx?id=<%# DataBinder.eval(Container.DataItem,"AssignmentID") %>&returnurl=editPartneragent.aspx%3fid=<%# _ID %>">Remove</a>                      
                                        </ItemTemplate>                    
                                     </asp:TemplateColumn>
                                     <asp:BoundColumn HeaderText="Type" DataField="PhoneType" />
                                     <asp:TemplateColumn HeaderText="Phone Number" ItemStyle-Wrap="false" >
                                        <ItemTemplate>
                                           <%# Databinder.eval(Container.DataItem, "CountryCode") %> (<%# Databinder.eval(Container.DataItem, "AreaCode") %>) <%# Databinder.eval(Container.DataItem, "Exchange") %>-<%# Databinder.eval(Container.DataItem, "LineNumber") %>
                                        </ItemTemplate>
                                     </asp:TemplateColumn>
                                     <asp:BoundColumn DataField="Extension" headertext="Extension" />
                                     <asp:BoundColumn DataField="Pin" headertext="Pin" />
                                     <asp:TemplateColumn HeaderText="Active" >             
                                        <ItemTemplate>
                                           <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                                        </ItemTemplate>
                                     </asp:TemplateColumn> 
                                 </Columns>                
                            </asp:DataGrid>
                         </td>
                         <td>&nbsp;</td>
                         <td colspan="2">
                           <div class="inputformsectionheader"> <asp:label ID="lblUnassociatedCount" runat="server" />&nbsp;Un-Associated&nbsp;Phone&nbsp;Number(s)</div>
                           <asp:DataGrid ID="dgvUnassignedPhoneNumbers" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                               <AlternatingItemStyle CssClass="altrow" />
                                  <HeaderStyle CssClass="gridheader" />
                                     <Columns>
                                         <asp:BoundColumn HeaderText="ID" DataField="PartnerPhoneNumberID" visible="false" />
                                         <asp:TemplateColumn HeaderText="Add">
                                            <ItemTemplate>
                                               <asp:CheckBox ID="chkSelected" runat="server" />
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:BoundColumn HeaderText="Type" DataField="PhoneType" />                 
                                         <asp:TemplateColumn HeaderText="Phone Number" ItemStyle-Wrap="false" >
                                            <ItemTemplate>
                                               <%# Databinder.eval(Container.DataItem, "CountryCode") %> (<%# Databinder.eval(Container.DataItem, "AreaCode") %>) <%# Databinder.eval(Container.DataItem, "Exchange") %>-<%# Databinder.eval(Container.DataItem, "LineNumber") %>
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:BoundColumn DataField="Extension" headertext="Extension" />
                                         <asp:BoundColumn DataField="Pin" headertext="Pin" />
                                         <asp:TemplateColumn HeaderText="Active" >             
                                            <ItemTemplate>
                                                <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderText="Command">
                                          <Itemtemplate>
                                            <a href="editphone.aspx?returnurl=editpartneragent.aspx%3fid=<%# _ID %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerPhoneNumberID") %>&mode=Partner">Edit</a>
                                          </Itemtemplate>
                                        </asp:TemplateColumn>                                                 
                                     </Columns>                
                               </asp:DataGrid> 
                               <div style="text-align:right"><a id="lnkAddPhone" runat="server">[Add Phone]</a></div>           
                            </td>
                      </tr>
                      <tr>
                         <td colspan ="2">
                            <div class="inputformsectionheader"><asp:Label ID="lblAssignedAddresssCount" runat="server" />&nbsp;Associated&nbsp;Address(es)</div>
                            <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvAddresses" runat="server" CssClass="Grid1">
                              <HeaderStyle CssClass="gridheader" />
                                 <AlternatingItemStyle CssClass="altrow" />   
                                    <Columns> 
                                       <asp:TemplateColumn>
                                          <Itemtemplate>
                                              <a href="removepartneragentAddress.aspx?id=<%# DataBinder.Eval(Container.DataItem,"PartnerAgentAddressAssignmentID") %>&returnurl=editpartneragent.aspx%3fid=<%# _ID %>">Remove</a>
                                          </Itemtemplate>
                                       </asp:TemplateColumn>                                       
                                       <asp:BoundColumn DataField="AddressType" HeaderText="Type" ItemStyle-Wrap="false" />
                                       <asp:TemplateColumn HeaderText="Address" >
                                          <ItemTemplate>
                                               <a target="_blank" href="<%# MapIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%></a>
                                          </ItemTemplate>
                                       </asp:TemplateColumn>                  
                                       <asp:BoundColumn DataField="City" HeaderText="City" />
                                       <asp:BoundColumn DataField="StateAbbreviation" HeaderText="State" />
                                       <asp:TemplateColumn HeaderText="Zip" >
                                          <ItemTemplate>
                                             <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
                                          </ItemTemplate>
                                       </asp:TemplateColumn>
                                       <asp:TemplateColumn  HeaderText="Active" >             
                                          <ItemTemplate>
                                              <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                                          </ItemTemplate>
                                       </asp:TemplateColumn>                              
                                   </Columns>        
                              </asp:DataGrid>
                        </td>
                        <td>&nbsp;</td>
                        <td colspan ="2">
                           <div class="inputformsectionheader"><asp:Label ID="lblUnAssignedAddresssCount" runat="server" />&nbsp;Un-Associated&nbsp;Address(es)</div>
                           <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvUnassignedAddresses" runat="server" CssClass="Grid1">
                             <HeaderStyle CssClass="gridheader" />
                               <AlternatingItemStyle CssClass="altrow" />   
                                 <Columns> 
                                   <asp:BoundColumn DataField="PartnerAddressID" Visible="false" />
                                   <asp:TemplateColumn HeaderText="Add">
                                     <Itemtemplate>
                                         <asp:CheckBox id="chkSelectedAddress" runat="server" />
                                     </Itemtemplate>
                                   </asp:TemplateColumn>                                       
                                   <asp:BoundColumn DataField="AddressType" HeaderText="Type" ItemStyle-Wrap="false" />
                                   <asp:TemplateColumn HeaderText="Address" >
                                     <ItemTemplate>
                                        <a target="_blank" href="<%# MapIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%></a>
                                     </ItemTemplate>
                                   </asp:TemplateColumn>                  
                                   <asp:BoundColumn DataField="City" HeaderText="City" />
                                   <asp:BoundColumn DataField="StateAbbreviation" HeaderText="State" />
                                   <asp:TemplateColumn  HeaderText="Zip" >
                                      <ItemTemplate>        
                                          <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
                                      </ItemTemplate>
                                   </asp:TemplateColumn>
                                   <asp:TemplateColumn  HeaderText="Active" >             
                                      <ItemTemplate>
                                         <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                                      </ItemTemplate>
                                   </asp:TemplateColumn> 
                                   <asp:TemplateColumn HeaderText="Command">
                                          <Itemtemplate>
                                            <a href="editaddress.aspx?returnurl=editpartneragent.aspx%3fid=<%# _ID %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerAddressID") %>&mode=Partner">Edit</a>
                                          </Itemtemplate>
                                        </asp:TemplateColumn>                              
                               </Columns>        
                           </asp:DataGrid>
                           <div style="text-align:right"><a id="lnkAddAddress" runat="server">[Add Address]</a></div>
                         </td>
                      </tr>
                      <tr>
                         <td colspan = "2">
                            <div class="inputformsectionheader"><asp:Label ID="lblAssignedResumeTypes" runat="server" />&nbsp;Associated&nbsp;Labor Network(s)</div>
                            <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvResumeTypes" runat="server" CssClass="Grid1">
                              <HeaderStyle CssClass="gridheader" />
                                <AlternatingItemStyle CssClass="altrow" />   
                                  <Columns>
                                     <asp:TemplateColumn>
                                        <Itemtemplate>
                                              <a href="removepartneragentresumetype.aspx?id=<%# DataBinder.Eval(Container.DataItem,"PartnerAgentResumeTypeID") %>&returnurl=editpartneragent.aspx%3fid=<%# _ID %>">Remove</a>
                                        </Itemtemplate>
                                     </asp:TemplateColumn>                                       
                                     <asp:BoundColumn DataField="ResumeTypeID" HeaderText="Type" visible= "false"/>
                                     <asp:BoundColumn DataField="ResumeType" HeaderText="Labor Network" />
                                 </Columns>        
                            </asp:DataGrid>
                         </td>
                         <td>&nbsp;</td>
                         <td >
                             <div class="inputformsectionheader"><asp:Label ID="lblUnAssignedResumeTypes" runat="server" />&nbsp;Un-Associated&nbsp;Labor Netowrk(s)</div>
                             <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvUnassignedResumeTypes" runat="server" CssClass="Grid1">
                               <HeaderStyle CssClass="gridheader" />
                                 <AlternatingItemStyle CssClass="altrow" />   
                                   <Columns> 
                                      <asp:BoundColumn DataField="ResumeTypeID" Visible="false" />
                                      <asp:TemplateColumn HeaderText="Add">
                                         <Itemtemplate>
                                             <asp:CheckBox id="chkSelectedResumeType" runat="server" />
                                         </Itemtemplate>
                                      </asp:TemplateColumn>                                       
                                      <asp:BoundColumn DataField="ResumeType" HeaderText="Labor Network" ItemStyle-Wrap="false"/>
                                   </Columns>        
                             </asp:DataGrid>
                          </td>
                      </tr>
                    </table>  
                  </asp:View>
                  <asp:View ID="AttachedDocuments"  runat="server" >
                  <table width ="100%">
                    <tr>
                      <td colspan="2">
                         <div class="inputformsectionheader" style="width:100%">Attachments</div>
                         <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" Width ="30%" />      
                         <asp:DataGrid style="width:100%" ID="dgvAttachments" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="Item_Click" CssClass="Grid1">
                           <ItemStyle CssClass="bandbar" />
                             <Columns>
                                <asp:BoundColumn DataField="PartnerAgentDocumentID" HeaderText="ID" Visible="false" />
                                <asp:BoundColumn DataField="Description" HeaderText="DocType" Visible="True" />
                                <asp:BoundColumn DataField="FileID" HeaderText="FileID" Visible="false" />
                                <asp:ButtonColumn Text="View" CommandName ="View" ></asp:ButtonColumn>  
                                <asp:ButtonColumn Text="Update" CommandName="Update"></asp:ButtonColumn>  
                                <asp:ButtonColumn Text="Remove" CommandName="Remove" ></asp:ButtonColumn> 
                             </Columns>              
                         </asp:DataGrid>
                       </td>
                       <td></td>
                       <td></td>
                     </tr>
                   </table> 
                  </asp:View>
                  <asp:View ID="vwPartnerAgentCertifications"  runat="server" >
                  <table width ="100%">
                    <tr>
                      <td >
                         <div class="inputformsectionheader">
                         <table width="100%">
                           <tr>
                             <td colspan="2">
                                <div class="label">Agency: </div>
                             </td>
                             <td>
                                <div>Certification Types: </div>
                             </td>
                           </tr>
                           <tr>
                             <td colspan="2">
                                <div><asp:DropDownList ID="drpCertificateAgencies"  runat="server" OnSelectedIndexChanged="drpCertificateAgencies_SelectedIndexChanged" AutoPostBack="true" /></div>
                             </td>
                             <td colspan="2">
                               <div><asp:DropDownList ID="drpCertificateTypes"  runat="server" /></div>
                             </td>
                           </tr>
                           <tr>
                             <td colspan ="3">
                                 <div class ="label">Certificate Number</div>
                             </td>
                             <td>
                                <div></div>
                             </td>
                             <td>
                                <div class="label">Certificate Date</div>
                             </td>
                             <td>
                                <div class="label">Expiration Date</div>
                             </td>
                           </tr>
                           <tr>
                             <td colspan ="3">
                                 <div><asp:TextBox  ID="txtCertificationNumber" runat="server" Width ="100%" /></div>
                             </td>
                             <td>
                                <div></div>
                             </td>
                             <td>
                                <div>
                                    <rad:RadDatePicker ID="rdpCertificationDate" runat="server" Height="19" DateInput-Font-Size="Small">
                                    </rad:RadDatePicker>
                                    </div>
                             </td>
                             <td>
                                <div><rad:RadDatePicker ID="rdpExpirationDate" runat="server" Height="19" DateInput-Font-Size="Small">
                                    </rad:RadDatePicker></div>
                             </td>
                             <td> 
                                  <div ><asp:Button ID="btnAddCertification" runat="server" Text="Add" OnClick="btnAdd_Click"  /> </div>    
                              </td>
                           </tr>
                         </table>
                         <div>&nbsp;&nbsp;</div>
                         </div>
                         <div>&nbsp;&nbsp;</div>
                         <div class="inputformsectionheader" style="width:100%">Certifications</div>
                         <asp:DataGrid style="width:100%" ID="dgvPartnerAgentCertifications" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="Item_Click" CssClass="Grid1">
                           <ItemStyle CssClass="bandbar" />
                             <Columns>
                                <asp:BoundColumn DataField="PartnerAgentCertificationID" HeaderText="ID" Visible="false" />
                                <asp:BoundColumn DataField="AgencyName" HeaderText="Agency Name" Visible="True" />
                                <asp:BoundColumn DataField="CertificationName" HeaderText="Certification Name" Visible="True" />
                                <asp:BoundColumn DataField="CertificationNumber" HeaderText="Certification Number" Visible="True" />
                                <asp:BoundColumn DataField="CertificationDate" HeaderText="Certification Date" Visible="True" />
                                <asp:BoundColumn DataField="CertificationExpires" HeaderText="Expiration Date" Visible="True" />
                             </Columns>              
                         </asp:DataGrid>
                       </td>
                       <td></td>
                       <td></td>
                     </tr>
                   </table> 
                  </asp:View>
                  <asp:View ID="ScheduleAvailability"  runat="server">
                  <div class="inputformsectionheader">Schedule Availability</div>
                  <table width ="100%" >
                    <tr>
                      <td >
                         <div class="inputformsectionheader"></div>
                         <table width="100%"  >
                           <tr >
                             <td colspan="2" >
                                <div class="bandheader">Set your Working Days</div>
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
                             </td>
                             <td><div></div>&nbsp;</td>
                             <td><div></div>&nbsp;</td>
                             <td colspan="2">
                                <div class="bandheader">Set Your Days/Times Off</div>
                                <div>Reason for Day/Time Off: </div>
                                <div><asp:DropDownList ID="drpScheduleCodes"  runat="server" /></div>
                             </td>
                           </tr>
                           <tr>
                             <td colspan="3" ><div>&nbsp;</div></td>
                             <td><div></div>&nbsp;</td>
                             <td><div></div>&nbsp;</td>
                             <td><div></div>&nbsp;</td>
                             <td colspan="2">
                             </td>
                           </tr>
                           <tr>
                             <td colspan ="3">
                                <div class="label">Schedule Zone Type (Can only be assigned to one): </div>
                             </td>
                             <td>
                                <div></div>
                             </td>
                             <td>
                                <div class="label">Day Off Start</div>
                             </td>
                             <td>
                                <div class="label">Day Off End</div>
                             </td>
                           </tr>
                           <tr>
                             <td colspan ="3">
                                <div><asp:DropDownList ID="drpScheduleZoneTypes"  runat="server"  AutoPostBack="true" OnSelectedIndexChanged ="drpScheduleZoneTypes_SelectedIndexChanged" />&nbsp;&nbsp;<asp:DropDownList ID="drpWeekDays"  runat="server"  AutoPostBack="true" OnSelectedIndexChanged="drpWeekDays_OnSelectedIndexChanged" />&nbsp;&nbsp;<asp:Button ID="btnSet" runat="server" Text="View" OnClick="btnSet_Click"  /></div>
                             </td>
                             <td>
                                <div></div>
                             </td>
                             <td>
                                <div>
                                    <rad:RadDatePicker ID="RadDatePicker1" runat="server" Height="19"  Width = "180px" DateInput-Font-Size="Small" OnSelectedDateChanged ="ShowSchedules" AutoPostBack="true">
                                    </rad:RadDatePicker>
                                    </div>
                             </td>
                             <td>
                                <div><rad:RadDatePicker ID="RadDatePicker2" runat="server" Height="19" width = "180px" DateInput-Font-Size="Small" OnSelectedDateChanged ="ShowSchedules" AutoPostBack="true">
                                    </rad:RadDatePicker></div>
                             </td>
                             <td> 
                              </td>
                           </tr>
                           <tr>
                             <td ><div >&nbsp;</div></td>
                             <td><div>&nbsp;</div></td>
                             <td><div>&nbsp;</div></td>
                             <td><div>&nbsp;</div></td>
                             <td colspan="2" align="right"><asp:Button ID="btnSetDayOff" runat="server" Text="Set Days Off" OnClick="btnSetDayOff_Click"  />
                             </td>
                           </tr>
                           <tr>
                         <td colspan ="2">
                            <div class="inputformsectionheader"><asp:label ID="Label1" runat="server" />&nbsp;Associated&nbsp;Schedule&nbsp;Zone(s)</div>
                            <asp:DataGrid ID="dgvAssignedScheduleAvailabilityZones" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                               <AlternatingItemStyle CssClass="altrow" />
                                  <HeaderStyle CssClass="gridheader" />
                                     <Columns>
                                         <asp:BoundColumn HeaderText="ID" DataField="ScheduleZoneTemplateID" visible="false" />
                                         <asp:BoundColumn HeaderText="PartnerAgentAvailabilityID" DataField="PartnerAgentAvailabilityID" visible="false" />
                                         <asp:TemplateColumn HeaderText="Remove">
                                            <ItemTemplate>
                                               <a href="removePartnerAgentAvailability.aspx?id=<%# DataBinder.eval(Container.DataItem,"PartnerAgentAvailabilityID") %>&returnurl=editPartneragent.aspx%3fid=<%# _ID %>">Remove</a>     
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:BoundColumn HeaderText="Type" DataField="ZoneName" />                 
                                         <asp:TemplateColumn HeaderText="ZoneName"  >
                                            <ItemTemplate>
                                               <%# CType(DataBinder.Eval(Container.DataItem, "StartScheduleTime"), Date).ToString("HH:mm") %> - <%#CType(DataBinder.Eval(Container.DataItem, "EndScheduleTime"), Date).ToString("HH:mm")%>
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:TemplateColumn HeaderText="Select" >
                                           <ItemTemplate>
                                              <asp:CheckBox ID="chkSelect" runat="server" />
                                           </ItemTemplate>
                                         </asp:TemplateColumn>
                                     </Columns>                
                               </asp:DataGrid>  
                         </td>
                         <td>&nbsp;</td>
                         <td>&nbsp;</td>
                         <td colspan="2">
                           <div class="inputformsectionheader"> <asp:label ID="UnAssignedScheduleZones" runat="server" />&nbsp;Un-Associated&nbsp;Schedule&nbsp;Zone(s)</div>
                           <asp:DataGrid ID="dgvUnAssignedScheduleAvailabilityZones" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                               <AlternatingItemStyle CssClass="altrow" />
                                  <HeaderStyle CssClass="gridheader" />
                                     <Columns>
                                         <asp:BoundColumn HeaderText="ID" DataField="ScheduleZoneTemplateID" visible="false" />
                                         <asp:TemplateColumn HeaderText="Add">
                                            <ItemTemplate>
                                               <asp:CheckBox ID="chkSelected" runat="server" />
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:BoundColumn HeaderText="Type" DataField="ZoneName" />                 
                                         <asp:TemplateColumn HeaderText="ZoneName"  >
                                            <ItemTemplate>
                                               <%# CType(DataBinder.Eval(Container.DataItem, "StartScheduleTime"), Date).ToString("hh:mm") %> - <%# CType(DataBinder.Eval(Container.DataItem, "EndScheduleTime"), Date).ToString("hh:mm") %>
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                     </Columns>                
                               </asp:DataGrid>            
                            </td>
                      </tr>
                         </table>
                         <div>&nbsp;&nbsp;</div>
                         
                         <div><asp:Button OnClick="btnRemove_Click" ID="btnRemove" runat="server" Text="Remove Days Off" /></div>
                         <div class="inputformsectionheader" style="width:100%">List of Schedules & Days Off</div>
                         <asp:DataGrid style="background-color: White;" ID="dgvShowAvailabilityforDay" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                          <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />
                          <Columns>
                            <asp:BoundColumn HeaderText="ID" DataField="ScheduleAvailabilityAssignmentID" Visible="false"  />
                            <asp:TemplateColumn HeaderText="Select" >
                               <HeaderTemplate>
                                 <asp:CheckBox id="chkAll" runat="server"  OnCheckedChanged ="chkAll_OnCheckedChanged" AutoPostBack = "True"></asp:CheckBox>
                               </HeaderTemplate>
                               <ItemTemplate>
                                  <asp:CheckBox ID="chkRemove" runat="server"  />
                               </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn HeaderText="Date" DataField="dateSet" />
                            <asp:BoundColumn HeaderText="Type" DataField="ZoneName"  />
                            <asp:BoundColumn HeaderText="Schedule Start" DataField="ScheduleStart"  />
                            <asp:BoundColumn HeaderText="Schedule End" DataField="ScheduleEnd" />
                            <asp:BoundColumn HeaderText="Status" DataField="CodeName"  />
                            <asp:TemplateColumn HeaderText="TicketID">
                              <ItemTemplate>
                                 <a href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>" target ="_blank"><%# DataBinder.Eval(Container.DataItem,"TicketID")%> </a>
                              </ItemTemplate>
                            </asp:TemplateColumn>
                          </Columns>    
                        </asp:DataGrid>
                       </td>
                       <td></td>
                       <td></td>
                     </tr>
                   </table> 
                  </asp:View>
            </asp:MultiView>
            <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnApply" runat="server" OnClick="btnApply_Click" Text="Apply" />&nbsp;<asp:Button ID="btnSubmit" Text="Close" runat="server" OnClick="btnSubmit_Click" /></div>
          </td>
       </tr>
      </tbody>
    </table> 
    </div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />    
  </form>
</asp:Content>