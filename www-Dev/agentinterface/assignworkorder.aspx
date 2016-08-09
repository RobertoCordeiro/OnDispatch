<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ Register Assembly="RadCalendar.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

  Private _ID As Long = 0
  Private _CurrentZip As String = ""
  Private _PartnerAgentID As Long = 0
  Private _WorkOrderID As Long = 0
    Private _TicketStreet As String
    Private _TicketZipCode As String
    Private _PartnerStreet As String
    Private _PartnerZipCode As String
    Private _CountryID As Long = 0
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            usr.Load(Master.UserID)
            inf.Load(usr.InfoID)
            _CountryID = inf.CountryID
            
      Master.PageHeaderText = "Assign Work Order"
      Master.PageTitleText = Master.PageHeaderText
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a>"
      Try
        _PartnerAgentID = CType(Request.QueryString("pid"), Long)
      Catch ex As Exception
        _PartnerAgentID = 0
      End Try
      Try        
        _ID = CType(Request.QueryString("id"), Long)
      Catch ex As Exception
        _ID = 0
            End Try
            Try
                _CurrentZip = CType(Request.QueryString("NewZip"), String)
                If _CurrentZip <> "" Then
                    txtNewZip.Text = _CurrentZip
                End If
            Catch ex As Exception
                _CurrentZip = ""
            End Try
      If _ID > 0 Then
        If Not IsPostBack Then
          chkAssignComponents.Checked = True
          RadDatePickerTo.SelectedDate = DateTime.Now.date
          LoadInformation(Weekday(DateTime.Now.date))
                    LoadPaymentIncrements()
                    If _PartnerAgentID > 0 Then
                        btnAssign.Enabled = "true"
                    Else
                        btnAssign.Enabled = "false"
                    End If
                                  
                End If
      End If
    End If
  End Sub
  
  Private Sub LoadInformation(lngWeekDay As long)
    Master.PageSubHeader &= " &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; <a href=""ticket.aspx?id=" & _ID & """>Ticket</a> &gt; Assign Work Order"
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
    Dim zip As New BridgesInterface.ZipCodeRecord(tkt.ConnectionString)
    tkt.Load(_ID)
    Dim str As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        lblTicketID.Text = _ID
        _TicketStreet = tkt.Street
        _TicketZipCode = tkt.ZipCode
    lblZip.Text = tkt.ZipCode
    lblCity.Text = tkt.City
    lnkZipCode.HRef = "findzipcode.aspx?zip=" & tkt.ZipCode & "&id=" & tkt.TicketID
    zip.Load (tkt.ZipCode )
    lblCounty.Text = zip.CountyName 
        str.Load(tkt.StateID)
        btnAssign.Enabled = "false"
        lblState.Text = str.Abbreviation
        If _CurrentZip = "" Then
            _CurrentZip = tkt.ZipCode
           
            LoadClosestPartnerAgents(tkt.ZipCode, 150)
            LoadClosestAssignedPartnerAgents(tkt.ZipCode, 0)
        Else
            zip.Load(_CurrentZip)
            lblCounty.Text = zip.CountyName
            lblCity.Text = zip.City
            str.Load(zip.StateID)
            lblState.Text = str.Abbreviation
            LoadClosestPartnerAgents(_CurrentZip, 150)
            LoadClosestAssignedPartnerAgents(_CurrentZip, 0)
        End If
        'LoadClosestPartnerAgents(tkt.ZipCode, 150)
        'LoadClosestAssignedPartnerAgents(tkt.ZipCode, 0)
        If _PartnerAgentID > 0 Then
            If txtNewZip.Text = tkt.ZipCode Then
                btnAssign.Enabled = True
            End If
            btnAssign.Enabled = "True"
            Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            par.Load(_PartnerAgentID)
            LoadPartnerRates(par.PartnerID)
            LoadCertifications(_PartnerAgentID)
            LoadSkillset(_PartnerAgentID)
            LoadLocations(par.PartnerID)
            lblSelectedTechnician.Text = par.FirstName & " " & par.LastName
            lblPartnerAgentBusinessPhoneNumber.Text = GetPartnerAgentBusinessPhoneNumber(_PartnerAgentID)
            Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            ptr.Load(par.PartnerID)
            Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            rsm.Load(ptr.ResumeID)
            imgICL.ImageUrl = DetermineAppropriateBar(rsm.ConfidenceLevel)
            LoadAssignedPhoneNumbers(par.PartnerAgentID)
            LoadAssignedResumeTypes(par.PartnerAgentID)
            lblDateCreated.Text = par.DateCreated
            lblOpenWorkOrders.Text = ptr.OpenWorkOrderCount
            lblClosedWorkOrders.Text = ptr.ClosedWorkOrderCount
       
            chkSunday.Checked = par.WorkDaySunday
            chkMonday.Checked = par.WorkDayMonday
            chkTuesday.Checked = par.WorkDayTuesday
            chkWednesday.Checked = par.WorkDayWednesday
            chkThursday.Checked = par.WorkDayThursday
            chkFriday.Checked = par.WorkDayFriday
            chkSaturday.Checked = par.WorkDaySaturday
            txtSpecialInstructions.Text = par.SpecialInstructions
            If par.ScheduleZoneTypeID > 0 Then
                LoadAssignedScheduleAvailabilityZones(par.ScheduleZoneTypeID, lngWeekDay)
            End If
            If par.Active Then
                lblStatus.Text = "Active"
            Else
                lblStatus.Text = "Inactive"
            End If
        Else
            imgICL.ImageUrl = DetermineAppropriateBar(0)
            btnAssign.Enabled = False
        End If
     
        'LoadAvailabilityForDay(_PartnerAgentID, DateTime.Now.Date)
        GetTicketInfo(_ID)
    End Sub

  Private Sub LoadAssignedPhoneNumbers(ByVal lngPartnerAgentID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentPhoneNumbers", "@PartnerAgentID", lngPartnerAgentID, dgvAssociatedPhoneNumbers)
    End Sub
    Private Sub LoadAssignedResumeTypes(ByVal lngPartnerAgentID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListAssignedPartnerAgentResumeTypes", "@PartnerAgentID", lngPartnerAgentID, dgvResumeTypes)
        'lblAssociatedCount.Text = dgvAssociatedPhoneNumbers.Items.Count
    End Sub
  
  Private Sub LoadSkillset(ByVal lngPartnerAgentID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerSkillSurveyQuestions", "@PartnerAgentID", lngPartnerAgentID, dgvAverageSkillSet)
    For Each itm As DataGridItem In Me.dgvAverageSkillSet.Items
      If CType(itm.Cells(1).Text, Integer) <= 0 Then
        itm.Visible = False
      End If
    Next
  End Sub
  
  Private Sub LoadPaymentIncrements()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListPayIncrements", "IncrementType", "IncrementTypeID", cbxIncrements)
  End Sub
  
  Private Sub LoadLocations(ByVal lngPartnerID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListActivePartnerShippingLocations", "@PartnerID", lngPartnerID, dgvLocations)
    LoadCounties(Ctype(dgvLocations.Items(0).Cells(0).Text,Long))
  End Sub
  
  Private Sub LoadPartnerRates(ByVal lngPartnerID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerReferenceRates", "@PartnerID", lngPartnerID, dgvRates)
  End Sub
  
  Private Sub LoadCertifications(ByVal lngPartnerAgentID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentCertifications", "@PartnerAgentID", lngPartnerAgentID, dgvCertifications)
  End Sub
  
    Private Sub LoadClosestPartnerAgents(ByVal strZipCode As String, ByVal lngRadius As Long)
        Dim itm As DataGridItem
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        '  ldr.LoadLongStringParameterDataGrid("spListClosestPartnerAgentsToZipCode", "@ZipCode", strZipCode, "@Radius", lngRadius, dgvClosestAgents)
        ldr.LoadTwoLongStringParameterDataGrid("spListClosestPartnerAgentsToZipCode", "@ZipCode", strZipCode, "@Radius", lngRadius, "@CountryID", _CountryID, dgvClosestAgents)

        If dgvClosestAgents.Items.Count = 1 Then
            itm = dgvClosestAgents.Items(0)
            itm.CssClass = "selectedbandbar"
            If _PartnerAgentID = 0 Then
                _PartnerAgentID = CType(itm.Cells(0).Text, Long)
            End If
        Else
            For Each itm In dgvClosestAgents.Items
                If CType(itm.Cells(0).Text, Long) = _PartnerAgentID Then
                    itm.CssClass = "selectedbandbar"
                End If
            Next
        End If
    
    End Sub

    Private Sub LoadClosestAssignedPartnerAgents(ByVal strZipCode As String, ByVal lngRadius As Long)
        Dim itm As DataGridItem
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadLongStringParameterDataGrid("spListClosestPartnerAgentsAssignedToZipCode", "@ZipCode", strZipCode, "@Radius", lngRadius, dgvAssignedTech)
        ldr.LoadTwoLongStringParameterDataGrid("spListClosestPartnerAgentsAssignedToZipCode", "@ZipCode", strZipCode, "@Radius", lngRadius, "@CountryID", _CountryID, dgvAssignedTech)
        
        If dgvAssignedTech.Items.Count = 1 Then
            itm = dgvAssignedTech.Items(0)
            itm.CssClass = "selectedbandbar"
            If _PartnerAgentID = 0 Then
                _PartnerAgentID = CType(itm.Cells(0).Text, Long)
            End If
        Else
            For Each itm In dgvAssignedTech.Items
                If CType(itm.Cells(0).Text, Long) = _PartnerAgentID Then
                    itm.CssClass = "selectedbandbar"
                End If
            Next
        End If
    
    End Sub



  Private Function CurrentID() As Long
    Return _ID
    End Function
    
  
  Private Function CurrentZip() As String
    Return _CurrentZip
  End Function
  
    Private Sub AssignWorkOrder()
        AddVisit()
    End Sub
  
  Private Sub AssignComponents(ByVal lngWorkOrderID As Long)
    Dim strChangeLog As String = ""
    Dim cpt As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListTicketComponents")
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = _ID
    cmd.CommandType = Data.CommandType.StoredProcedure
    cnn.Open()
    cmd.Connection = cnn
    Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
    While dtr.Read
      cpt.Load(CType(dtr("TicketComponentID"), Long))
      cpt.WorkOrderID = lngWorkOrderID
      cpt.Save(strChangeLog)
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID, 35, cpt.TicketComponentID, strChangeLog)
    End While
    cnn.Close()
  End Sub
  
  Private Function DetermineAppropriateBar(ByVal lngLevel As Long) As String
    Dim strReturn As String = ""
    If lngLevel > 0 Then
      strReturn = "/graphics/bar" & CType(Math.Round((lngLevel / 5) * 100, 0), Long).ToString() & ".png"
    Else
      strReturn = "/graphics/bar0.png"
    End If
    Return strReturn
  End Function

  Private Sub btnAssign_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      AssignWorkOrder()
      Response.Redirect("ticket.aspx?id=" & _ID, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dbl As Double = 0
    If txtMinimum.Text.Trim.Length > 0 Then
      If Not Double.TryParse(txtMinimum.Text, dbl) Then
        blnReturn = False
        strErrors &= "<li>Minimum Must Be Numeric</li>"
      End If
    End If
    If txtMaximum.Text.Trim.Length > 0 Then
      If Not Double.TryParse(txtMaximum.Text, dbl) Then
        blnReturn = False
        strErrors &= "<li>Maximum Must Be Numeric</li>"
      End If
    End If
    If txtRate.Text.Trim.Length > 0 Then
      If Not Double.TryParse(txtRate.Text, dbl) Then
        blnReturn = False
        strErrors &= "<li>Rate Must Be Numeric</li>"
      End If
    End If
    If txtAdjust.Text.Trim.Length > 0 Then
      If Not Double.TryParse(txtAdjust.Text, dbl) Then
        blnReturn = False
        strErrors &= "<li>Adjust Must Be Numeric</li>"
      End If
        End If
        
        
        If GetTotalVisitsOnTicket(_ID) <> 0 Then
            If Not IsTicketOpened(_ID) Then
                Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                par.Load(_PartnerAgentID)
                If GetCurrentAssignedPartnetID(_ID) <> par.PartnerID Then
                    blnReturn = False
                    strErrors &= "<li>You cannot assign different Technicians to the same ticket. To continuing service with a different Technician, create a new ticket.</li>"
                End If
                Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tkt.Load(_ID)
                If tkt.CompletedDate <> "12:00:00 AM" Then
        
                    blnReturn = False
                    strErrors &= "<li>This ticket has been invoiced. You cannot create a new visit!.</li>"
        
                End If
            Else
                blnReturn = False
                strErrors &= "<li>There is already an open visit for this ticket. To assign it to a different tech, go to view billing.</li>"
            End If
        End If
        If _PartnerAgentID = 0 Then
            blnReturn = False
            strErrors &= "<li>You must select a technician before you can create a site visit to the ticket.</li>"
        End If
        
        divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
        
        Return blnReturn
    End Function

  Private Function DriveIt(ByVal strDestination As String, ByVal strDZip As String) As String
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    tkt.Load(_ID)
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
    strReturn = ggl.GetDirections(tkt.Street, tkt.ZipCode, strDestination, strDZip)
        Return strReturn
  End Function
  
  Private Function MapIt(ByVal strAddress As String, ByVal strZipCode As String) As String
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
    strReturn = ggl.MapAddress(strAddress, strZipCode)
    Return strReturn
  End Function
  
  Private Sub menu_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu.MenuItemClick
        AgentInfo.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0
                
            Case Is = 1
                
            Case Is = 2
               
            Case Is = 3
                
        End Select
        
    End Sub
    
    Private Sub LoadAssignedScheduleAvailabilityZones(ByVal lngScheduleZoneTypeID as long,ByVal lngWeekday As long)
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr1.LoadThreeLongParameterDataGrid("spListAssignedScheduleAvailabilityForPartnerAgent", "@PartnerAgentID", _PartnerAgentID,"@ScheduleZoneTypeID",lngScheduleZoneTypeID,"WeekDayID",lngWeekDay, dgvAssignedScheduleAvailabilityZones)
        
    End Sub
    Private Sub LoadAvailabilityForDay(lngPartnerAgentID as Long,datScheduleDay as datetime)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadLongDateParameterDataGrid("spGetScheduleForPartnerAgentPerDay", "@PartnerAgentID", _PartnerAgentID,"@ScheduleDay",datScheduleDay,dgvShowAvailabilityforDay)
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(_PartnerAgentID)
        
        Dim lngWeekDay As Long
        If Weekday(datScheduleDay) = 7 Then
            lngWeekDay = 8
        Else
            lngWeekDay = Weekday(datScheduleDay)
        End If
        
        LoadAssignedScheduleAvailabilityZones(CType(par.ScheduleZoneTypeID, Long), lngWeekDay)
        LoadMap(_PartnerAgentID, (RadDatePickerTo.SelectedDate))
        
    End Sub
    Private Sub ShowSchedules(ByVal sender As Object, ByVal e As Telerik.WebControls.SelectedDateChangedEventArgs)
        LoadAvailabilityForDay(_PartnerAgentID, (RadDatePickerTo.SelectedDate))
       
    End Sub
    
    Private Sub SelectOnlyOne(ByVal sender As Object, ByVal e As System.EventArgs)
 
     Dim m_ClientID As String = ""
     Dim rb As New RadioButton
 
     rb = CType(sender, RadioButton)
     m_ClientID = rb.ClientID
 
     For Each i As DataGridItem In dgvAssignedScheduleAvailabilityZones.Items
       rb = CType(i.FindControl("rdbBatchTime"), RadioButton)
       rb.Checked = False
       If (m_ClientID = rb.ClientID) Then
         rb.Checked = True
         RadioSelectID.text = i.Cells(0).text
         
       End If
     Next
 
   End Sub 
    Private Sub btnSetAppointment_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
        Dim sch as New BridgesInterface.ScheduleAvailabilityAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tem as New BridgesInterface.ScheduleZoneTemplateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim nts as New BridgesInterface.TicketNoteRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim scd as New BridgesInterface.ScheduleAvailabilityCodeRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim paa as New BridgesInterface.PartnerAgentAvailabilityRecord (system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
         
         paa.Load(CType(RadioSelectID.Text,Long))
         tem.Load (paa.ScheduleZoneTemplateID)
       If HasOpenWorkOrder (_ID) = 0 then
              assignworkorder()
              deleteScheduleAssignment ( _ID)
       end if   
    
    If _PartnerAgentID > 0 then
      If Not IsDbNull(RadDatePickerTo.SelectedDate) then
            Dim strChangeLog as string
            strChangelog = ""
            'add appt set to ticket
            tkt.Load (_ID)
            if not IsDbNull(tkt.ScheduledDate) then
              deleteScheduleAssignment (_ID)
            end if
            tkt.ScheduledDate = CType(RadDatePickerTo.SelectedDate,String ) + " " + tem.StartScheduleTime.ToShortTimeString
            tkt.ScheduledEndDate = CType(RadDatePickerTo.SelectedDate,String) + " " + tem.EndScheduleTime.ToShortTimeString  
            
                ' Production control
                If tkt.TicketStatusID <> 11 Then
                    Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto Note: Ticket Status has been changed to: Scheduled")
                    tnt.CustomerVisible = False
                    tnt.Acknowledged = False
                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                    tnt.Save(strChangeLog)

                    'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    'usr.Load(Master.LoginID)
                    Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    wbl.Load(Master.WebLoginID)
                    Dim strUserName As String
                    strUserName = wbl.Login
                    Dim tst As New BridgesInterface.TicketStatusRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    tst.Load(tkt.TicketStatusID)
                    Dim OldProductionOrder As Integer
                    Dim newProductionOrder As Integer
                    OldProductionOrder = tst.ProductionOrder
                    tst.Load(tkt.TicketStatusID)
                    newProductionOrder = tst.ProductionOrder
        
                    Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    
                    ' 4 status changed
                    plog.Add(Master.WebLoginID, Now(), 4, "The status has been changed to - Scheduled  - on ticket: " & tkt.TicketID)
                    
                    'If drpTicketStatus.SelectedValue <> CType(17, Long) Then
                    Dim eml1 As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
                    eml1.Subject = "Production from: " & strUserName
                    eml1.Body = "The status has been changed to - Scheduled  - on ticket: " & tkt.TicketID
                    eml1.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
                    eml1.SendFrom = strUserName & "@bestservicers.com"
                    'eml.SendTo = ptr.Email
                    eml1.SendTo = "agentproduction@bestservicers.com"
                    'eml.CC = "nelson.palavesino@centurionvision.com"
                    'eml.cc = "howard.goldman@centurionvision.com"
                    eml1.Send()
                    'End If                        
                End If
                'End Agent production    
                
                tkt.TicketStatusID = 11 'Scheduled
            tkt.Save(strChangeLog)
            'add record to ScheduleAvailabilityAssignments table
                sch.Add(_PartnerAgentID, RadDatePickerTo.SelectedDate, RadioSelectID.Text, 1, _ID)
                
                HandleFolders(tkt.TicketID, 11) 'scheduled    
                
            'add note to the ticket
            Dim  strNota as String
            strNota = "Auto Note: Appointment has been set for " + CType(RadDatePickerTo.SelectedDate,String ) + " from " + tem.StartScheduleTime.ToShortTimeString  + " and " + tem.EndScheduleTime.ToShortTimeString 
                nts.Add(_ID, Master.WebLoginID, Master.UserID, strNota)
                nts.CustomerVisible = True
                nts.PartnerVisible = True
                nts.Acknowledged = True
                nts.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                nts.Save(strChangeLog)
                
            tkt.Load (_ID) 
            Dim zip As New BridgesInterface.ZipCodeRecord(tkt.ConnectionString)
            zip.Load (tkt.ZipCode)
            Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
            Dim pta As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            pta.Load(_partneragentID)
            Dim strBody as String 
               eml.HTMLBody = True
               eml.Subject = "Your Schedule Availability Changed - New Service Scheduled!"
               strBody = "<b>Appointment set for Ticket: " & tkt.TicketID & " - Service Date: "  & CType(RadDatePickerTo.SelectedDate,String ) &  " from " & tem.StartScheduleTime.ToShortTimeString & " - " & tem.EndScheduleTime.ToShortTimeString & "</b><br>"
               strBody = strBody & "Location: " & tkt.City & ", FL " & tkt.ZipCode & " - County: " & zip.countyname & "<br>"
               strBody= strBody & "Customer Name: " & tkt.ContactFirstName & " " & tkt.ContactLastName & "<br>"
               strBody = strBody & "Phone Numbers: " & GetTicketPhoneNumbers(tkt.TicketID) & "<br>"
               strBody = strBody & "Type of Service: " & tkt.Manufacturer & "<br>"
               strBody = strBody & "<br>"
               strBody = strBody & "<br>"
               strBody = strBody & "<br>"
               strBody = strBody & "<br>"
               strBody = strBody & "<br>"
               strBody = strBody & "<br>" & "*** PLEASE DO NOT REPLY DO THIS EMAIL ***"
               eml.Body = strBody
               eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
               eml.SendTo = pta.Email
        
               eml.Send()    
               
               If _WorkOrderID <> 0 then ' dispatching the ticket to the technician
                
                 Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                 wrk.Load(_WorkOrderID)
                 wrk.DispatchDate = DateTime.Now
                 wrk.Save(strChangeLog)
                
               End if
               
               
               
                
            Response.Redirect("ticket.aspx?id=" & _ID, True)
            
      end if
    End if
   
    end sub
  
  Private Sub DeleteScheduleAssignment (lngTicketID as Long)
  
  Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim cmd As New System.Data.SqlClient.SqlCommand("spDeleteScheduleAssignmentByTicketID")
  
  cmd.CommandType = Data.CommandType.StoredProcedure
  cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
  cnn.open        
  cmd.Connection = cnn
  cmd.ExecuteScalar()
  cnn.Close()
   
  end sub
  Private Function HasOpenWorkOrder (lngTicketID as Long) as Long
  
  Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTicketOpenWorkOrders")
  
  cmd.CommandType = Data.CommandType.StoredProcedure
  cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
  cnn.open        
  cmd.Connection = cnn
  HasOpenWorkOrder = cmd.ExecuteScalar()
  cnn.Close()
   
  
  end function
  
  Private Sub btnSendEmail_Click(ByVal S As Object, ByVal E As EventArgs)
 Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
 Dim cst as New BridgesInterface.CustomerRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
 tkt.Load (_ID)
 cst.Load(tkt.CustomerID )
 Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
 Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
 doc.Load(9) 
 Dim strBody As String = doc.DocumentText  
    strBody = strBody.Replace("$firstname", tkt.ContactFirstName )
    strBody = strBody.Replace("$lastname", tkt.ContactLastName )
    strBody = strBody.Replace("$UnitType", tkt.Manufacturer )
    strBody = strBody.Replace("$TicketID",_ID)
    eml.Subject = "Important information regarding your repair"
    eml.SendTo = tkt.Email 
    eml.SendFrom = "welcome@bestservicers.com"
    eml.BCC = "welcome@bestservicers.com"
    eml.Body = strBody
    eml.HTMLBody = True
    eml.Send()

Dim strChangeLog as String = "" 
Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto message: Welcome letter sent to customer")
  tnt.CustomerVisible = False
  tnt.Acknowledged = False
  tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
  tnt.Save(strChangeLog)   
 
 btnSendEmail.Enabled = False

 End Sub
 
 Private Sub btnViewScript_Click(ByVal S As Object, ByVal E As EventArgs)
   if btnview.text = "View Script" then    
            'If txtProgram.Text = "30" Or txtProgram.Text = "32" Or txtProgram.Text = "34" Then
            Electrolux.Visible = True
            Omni.Visible = False
            'End If
            'If txtProgram.Text = "33" Or txtProgram.Text = "26" Or txtProgram.Text = "37" Then
            'Omni.Visible = True
            'Electrolux.Visible = False
            'End If
            btnView.Text = "Hide Script"
        Else
            Electrolux.Visible = False
            Omni.Visible = False
            btnView.Text = "View Script"
        End If
  End Sub
 Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect("ticket.aspx?id=" & _ID, True)
  End Sub
 
 Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    Save()
    Response.Redirect("ticket.aspx?id=" & _ID, True)
  End Sub
 
 Private sub btnApply_Click(sender As Object, e As System.EventArgs)
   Save()
   txtNotes.Text = ""
 end sub
 
 Private Sub Save ()
   Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
   Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
   Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strMsg As String = ""
        
    If IsCompleted() Then
      if chkFirstContact.checked = True Then     
      
         Dim strChangeLog As String = ""
         divErrors.Visible = False
         tkt.Load(_ID)
         tkt.InitialContact = DateTime.Now
         tkt.TicketStatusID = 5
         tkt.model = txtModel.text
         tkt.serialnumber = txtSerial.text
         tkt.PurchaseDate = txtDoP.Text

         
         tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Initial Contact: " & txtNote.Text)
         tnt.CustomerVisible = True
         tnt.PartnerVisible = True
         tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
         tnt.Acknowledged = True
                tnt.Save(strChangeLog)
                'production 
                plog.Add(Master.UserID, Now(), 18, "First Contact Done on ticket: " & tkt.TicketID)
    
         if drpStatusList.selectedvalue <> "Choose One" then
           
                    ' Production control
                    If tkt.TicketStatusID <> CType(drpStatusList.SelectedValue, Long) Then
                        
                        Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                        wbl.Load(Master.WebLoginID)
                        Dim strUserName As String
                        strUserName = wbl.Login
                        Dim tst As New BridgesInterface.TicketStatusRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                        tst.Load(tkt.TicketStatusID)
                        Dim OldProductionOrder As Integer
                        Dim newProductionOrder As Integer
                        OldProductionOrder = tst.ProductionOrder
                        tst.Load(tkt.TicketStatusID)
                        newProductionOrder = tst.ProductionOrder
                
                        ' 4 production
                        strMsg = "The status has been changed to - " & CType(drpStatusList.SelectedValue, Long) & " - on ticket: " & tkt.TicketID
                        plog.Add(Master.WebLoginID, Now(), 4, strMsg)
                        
                        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
                        eml.Subject = "Production from: " & strUserName
                        eml.Body = "The status has been changed to - " & CType(drpStatusList.SelectedValue, Long) & " - on ticket: " & tkt.TicketID
                        eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
                        eml.SendFrom = strUserName & "@bestservicers.com"
                        eml.SendTo = "agentproduction@bestservicers.com"
                        eml.Send()
                    End If
                    'End Agent production            
                    
           tkt.TicketStatusID = CType(drpStatusList.selectedValue,long)
           tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Status Change: Ticket status has been changed from " & lblStatus.Text & " to " & drpStatusList.selectedValue )
           tnt.CustomerVisible = True
           tnt.PartnerVisible = True
           tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
           tnt.Acknowledged = True
           tnt.Save(strChangeLog)
         end if   
         
         tkt.Save(strChangeLog)
         Dim strIp As String = Request.QueryString("REMOTE_ADDR")
         Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
         If IsNothing(strIp) Then
           strIp = "unknown"
         End If
         If IsNothing(strType) Then
           strType = "web"
         End If
         act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID, 33, tkt.TicketID, strChangeLog)
         
   else
      Dim strChangeLog As String = ""
         divErrors.Visible = False
         tkt.Load(_ID)
         'tkt.InitialContact = DateTime.Now
         tkt.model = txtModel.text
         tkt.serialnumber = txtSerial.Text
          
         tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Attempted Contact:" & txtNote.Text)
         tnt.CustomerVisible = True
         tnt.PartnerVisible = True
         tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
         tnt.Acknowledged = True
         
         tnt.Save(strChangeLog)
         if drpStatusList.selectedvalue <> "Choose One" then
            
                    ' 4 production
                    strMsg = "Status Change: Ticket status has been changed from " & lblTicketStatus.Text & " to " & drpStatusList.SelectedItem.Text
                    plog.Add(Master.WebLoginID, Now(), 4, strMsg)
                    
                    
           tkt.TicketStatusID = CType(drpStatusList.selectedValue,long)
           tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Status Change: Ticket status has been changed from " & lblTicketStatus.Text & " to " & drpStatusList.selectedItem.text )
           tnt.CustomerVisible = True
           tnt.PartnerVisible = True
           tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
           tnt.Acknowledged = True
                    tnt.Save(strChangeLog)
                    
                Else
                    '  13  Status Changed
                        
                    plog.Add(Master.WebLoginID, Now(), 13, "Notes have been added to the ticket - " & tkt.TicketID)

                End If
         
         tkt.Save(strChangeLog)
         txtNote.Text = ""
         'Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
         'Dim strIp As String = Request.QueryString("REMOTE_ADDR")
         'Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
         'If IsNothing(strIp) Then
         '  strIp = "unknown"
         'End If
         'If IsNothing(strType) Then
         '  strType = "web"
         'End If
         'act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID, 33, tkt.TicketID, strChangeLog)
         'Response.Redirect("ticket.aspx?id=" & _ID, True)
   end if 
    
Else
      divErrors.Visible = True
    End If
 
 end sub
 
 Private Sub GetTicketInfo (_ID as long)
  Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim tst As New BridgesInterface.TicketStatusRecord(tkt.ConnectionString)  
  Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)  
  Dim svt As New BridgesInterface.ServiceTypeRecord(tkt.ConnectionString)  
  Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)  
  Dim strHtml As String = "" 
  Dim strChangeLog as String = ""  
  tkt.Load(_ID)
  srv.Load(tkt.ServiceID)
  svt.Load(srv.ServiceTypeID)
  tst.Load (tkt.TicketStatusID )
  If tkt.Company.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Company & "</div>"
    End If
    strHtml &= "<div>" & tkt.ContactFirstName & " " & tkt.ContactMiddleName & " " & tkt.ContactLastName & "</div>"
    If tkt.Email.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Email & "</div>"
    End If
    lblContact.Text = strHtml
    strHtml = "<div>" & tkt.Street & "</div>"
    If tkt.Extended.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Extended & "</div>"
    End If
    strHtml &= "<div>" & tkt.City & " " & stt.Abbreviation & ", " & tkt.ZipCode
    lblAddress.Text = strHtml
    LoadPhoneNumbers()
    'lnkAssignWorkOrder.HRef = "assignworkorder.aspx?id=" & tkt.TicketID
    'txtDescription.Text = tkt.Description.Replace("<br />", Environment.NewLine)
    txtNotes.Text = tkt.Notes.Replace("<br />", Environment.NewLine)
    lblTicketNumber.Text = tkt.TicketID
    lblTicketStatus.Text = tst.Status
    lblCreated.Text = tkt.DateCreated.ToString
    txtprogram.text = svt.serviceTypeID
    txtModel.text = tkt.Model
    txtSerial.text = tkt.SerialNumber
        txtServiceType.Text = svt.ServiceType
        txtDOP.Text = tkt.PurchaseDate
    lnkEditTicket.HRef = "editticket.aspx?id=" & _ID & "&returnurl=assignworkorder.aspx?pid=" & _PartnerAgentID & "%26id=" & _ID 
    lnkAddPhone.HRef = "addphone.aspx?id=" & _ID & "&mode=ticket&&returnurl=assignworkorder.aspx?pid=" & _PartnerAgentID & "%26id=" & _ID
    LoadStatusList(tst.ProductionOrder)
    tkt.Save(strChangeLog)
    
  end sub
  
  Private Sub LoadPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListTicketPhoneNumbers", "@TicketID", _ID, dgvPhoneNumbers)
  End Sub
  
  Private Sub LoadCounties(lngPartnerAddressID As long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spGetCountiesPerPartnerAddressID", "@PartnerAddressID",lngPartnerAddressID, dgvCounties)
  End Sub
  
  
  Private Function IsCompleted() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtNote.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Note is Required</li>"
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub LoadStatusList(lngProductionOrderID as long)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDropDownList("spListTicketStatusesByProductionOrder", "@ProductionOrderID",lngProductionOrderID,"Status","TicketStatusID", drpStatusList)
        drpStatusList.Items.Add("Choose One")
        drpStatusList.SelectedValue = "Choose One"
    End Sub
    
  Private Function GetTicketPhoneNumbers (lngTicketID as Long) as string
  
   Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPhoneNumbersForTicket")
        Dim strPhoneNumber As String
        strPhoneNumber = ""
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strPhoneNumber = strPhoneNumber & " / " & dtr("AreaCode") & dtr("Exchange") & dtr("LineNumber") & " - " & dtr("Comment")
        End While
        cnn.Close()
        GetTicketPhoneNumbers = strPhoneNumber
    End Function
    
    Private Function GetPartnerAgentBusinessPhoneNumber(ByVal lngPartnerAgentID As Long) As String
        
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spListPartnerAgentBusinessPhoneNumber")
        Dim strPhoneNumber As String
        strPhoneNumber = ""
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strPhoneNumber = strPhoneNumber & "(" & dtr("AreaCode") & ") " & dtr("Exchange") & "-" & dtr("LineNumber")
        End While
        cnn.Close()
        GetPartnerAgentBusinessPhoneNumber = strPhoneNumber
        
    End Function
    
    Private Sub btnVerifyCoverage_Click(ByVal S As Object, ByVal E As EventArgs)
        
        If Not IsDBNull(txtNewZip.Text) Or txtNewZip.Text <> "" Then
            Dim strzipcode As String
            strzipcode = txtNewZip.Text
            txtNewZip.Text = ""
            
            Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            wbl.Load(Master.WebLoginID)
            Dim strUserName As String
            strUserName = wbl.Login
             
            'production  2  verification of coverage
            Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            plog.Add(Master.WebLoginID, Now(), 2, "Verification of Coverage - Zip Code: " & strzipcode)
            
            'If drpTicketStatus.SelectedValue <> CType(17, Long) Then
            Dim eml1 As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
            eml1.Subject = "Production from: " & strUserName
            eml1.Body = "Verification of Coverage - Zip Code: " & strzipcode
            eml1.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
            eml1.SendFrom = strUserName & "@bestservicers.com"
            'eml.SendTo = ptr.Email
            eml1.SendTo = "agentproduction@bestservicers.com"
            'eml.CC = "nelson.palavesino@centurionvision.com"
            'eml.cc = "howard.goldman@centurionvision.com"
            eml1.Send()
            'End If     
            
            
            Response.Redirect("assignworkorder.aspx?id=" & _ID & "&NewZip=" & strzipcode)
            
        End If
        
    End Sub
    
    Private Sub HandleFolders(ByVal lngTicketID As Long, ByVal lngFolderID As Long)
        Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
               
        Select Case lngFolderID 'Ticket StatusID
           
            Case Is = CType(11, Long)
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(33, Long))
                fdl.Add(6, lngTicketID, CType(2, Long)) ' add to folder open
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(32, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))
                removeTicketFromFolder(lngTicketID, CType(3, Long))

            Case Is = CType(17, Long), CType(19, Long)
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(33, Long))
                fdl.Add(6, lngTicketID, CType(2, Long)) ' add to folder open
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(32, Long))
                removeTicketFromFolder(lngTicketID, CType(17, Long))

           

            Case Else
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeticketfromfolder(lngticketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(32, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))

        End Select

    End Sub
    
    Private Sub removeTicketFromFolder(ByVal lngTicketID As Long, ByVal lngFolderID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spRemoveTicketFromFolder")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cnn.open()
        cmd.Connection = cnn
        
        cmd.ExecuteNonQuery()
        cnn.Close()
    End Sub
    Private Function IsTicketOpened(ByVal lngTicketID As Long) As Boolean
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsticketOpen")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr1.Read
            IsTicketOpened = dtr1("Result")
        End While
        cnn.Close()
    End Function
    Private Function GetTotalVisitsOnTicket(ByVal lngTicketID As Long) As Long
        
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalVisitsOnTicket")
        Dim lngTotal As Long
        lngTotal = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        cnn.Close()
        GetTotalVisitsOnTicket = lngTotal
        
    End Function
    Private Function GetCurrentAssignedPartnetID(ByVal lngTicketID As Long) As Long
        
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPartnerIDAssignedToTicket")
        Dim lngPartnerID As Long
        lngPartnerID = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngPartnerID = dtr("PartnerID")
        End While
        cnn.Close()
        GetCurrentAssignedPartnetID = lngPartnerID
        
    End Function
    Private Sub AddVisit()
        Dim dblMin As Double = 0
        Dim dblMax As Double = 0
        Dim dblRate As Double = 0
        Dim dblAdjust As Double = 0
        Dim strTrash As String = ""
        If txtMinimum.Text.Trim.Length > 0 Then
            dblMin = CType(txtMinimum.Text, Double)
        Else
            dblMin = 0
        End If
        If txtMaximum.Text.Trim.Length > 0 Then
            dblMax = CType(txtMaximum.Text, Double)
        Else
            dblMax = 0
        End If
        If txtRate.Text.Trim.Length > 0 Then
            dblRate = CType(txtRate.Text, Double)
        Else
            dblRate = 0
        End If
        If txtAdjust.Text.Trim.Length > 0 Then
            dblAdjust = CType(txtAdjust.Text, Double)
        Else
            dblAdjust = 0
        End If
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(_ID)
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(_PartnerAgentID)
        Dim pat As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        pat.Load(par.PartnerID)
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        wrk.Add(Master.UserID, 1, tkt.ServiceID, tkt.TicketID, cbxIncrements.SelectedValue, dblMin, dblMax, dblRate, dblAdjust)
        wrk.PartnerID = par.PartnerID
        wrk.PartnerAgentID = par.PartnerAgentID
        _WorkOrderID = wrk.WorkOrderID
        
        Dim pan As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        pan.Load(par.PartnerID)
        tkt.AssignedTo = pan.UserID
        Dim strChangeLog As String
        strChangeLog = ""
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto Note: New Work Order has been assigned to this ticket: Partner ID - : " & pan.ResumeID)
        tnt.CustomerVisible = False
        tnt.Acknowledged = False
        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        tnt.Save(strChangeLog)
    
        'Production -  Assigned Tech to Ticket
        Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        plog.Add(Master.WebLoginID, Now(), 16, "New Work Order has been assigned to this ticket " & _ID & " - PartnerID: " & pan.ResumeID)
        
        If Not IsDBNull(tkt.ScheduledDate) Then
            tkt.ScheduledDate = Nothing
            tkt.ScheduledEndDate = Nothing
        End If
    
        If dgvLocations.Items.Count > 0 Then
            wrk.PartnerAddressID = dgvLocations.Items(0).Cells(0).Text
        End If
        If chkAssignComponents.Checked Then
            AssignComponents(wrk.WorkOrderID)
        End If
        tkt.AssignedTo = pat.UserID
        tkt.Save(strChangeLog)
        wrk.Save(strTrash)
      
    End Sub
    Private Sub ShowMessage(ByVal strMessage As String)
        'Begin building the script 
        Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
        strScript += "alert(""" & strMessage & """)" & vbCrLf
        strScript += "<" & "/" & "SCRIPT" & ">"
        'Register the script for the client side 
        ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript)
    End Sub
    
    Private Sub LoadMap(ByVal lngPartnerAgentID As Long, ByVal datScheduleDay As DateTime)
        'Dim sBuildURL As String = "https://www.google.com/maps/dir"
        Dim sBuildURL As String = "https://www.google.com/maps/embed/v1/directions?key=AIzaSyD0gwGXCl9jydIsL2AfGpKp-gKOx4OwXJE&mode=driving"
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetScheduleAddrForPartnerAgentPerDay")
        Dim intCounter As Integer = 1
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(lngPartnerAgentID)
        LoadPartnerRates(par.PartnerID)
        Dim zhm As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        zhm.Load(GetHomeZipCode(par.PartnerID))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(_ID)
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
        cmd.Parameters.Add("@ScheduleDay", Data.SqlDbType.DateTime, Len(datScheduleDay)).Value = datScheduleDay
        cnn.Open()
        cmd.Connection = cnn
        
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        sBuildURL = AppendToMapURL(sBuildURL, _PartnerStreet, _PartnerZipCode, 0, 1)
        While dtr.Read
            If Not IsDBNull(dtr("ZipCode")) Then
                sBuildURL = AppendToMapURL(sBuildURL, dtr("Street").ToString, dtr("ZipCode").ToString, 1, intCounter)
            End If
            intCounter = intCounter + 1
        End While
        cnn.Close()

        sBuildURL = AppendToMapURL(sBuildURL, tkt.Street, tkt.ZipCode, 2, 1)
        
        MapHolder.Attributes.Add("src", sBuildURL)

    End Sub
    Private Function AppendToMapURL(ByVal sURL As String, ByVal sStreet As String, ByVal sZipCode As String, ByVal intMode As Integer, ByVal intCounter As Integer) As String
        Select Case intMode
            Case Is = 0  'origin
                AppendToMapURL = sURL & "&origin=" & sStreet.Trim().Replace(" ", "+") & "," & sZipCode.Trim()
            Case Is = 1 'waypoints
                If intCounter = 1 Then
                    AppendToMapURL = sURL & "&waypoints=" & sStreet.Trim().Replace(" ", "+") & "," & sZipCode.Trim()
                Else
                    AppendToMapURL = sURL & "|" & sStreet.Trim().Replace(" ", "+") & "," & sZipCode.Trim()

                End If
            Case Is = 2 'destination
                AppendToMapURL = sURL & "&destination=" & sStreet.Trim().Replace(" ", "+") & "," & sZipCode.Trim()
        End Select
        'AppendToMapURL = sURL & "/" & sStreet.Trim().Replace(" ", "+") & "," & sZipCode.Trim()
        
    End Function
    Private Function GetHomeZipCode(ByVal lngPartnerID As Long) As String
  
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPartnerShippingAddressByPartnerID")
        Dim strZipCode As String
        strZipCode = ""
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = lngPartnerID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strZipCode = dtr("ZipCode")
            _PartnerZipCode = dtr("Zipcode")
            _PartnerStreet = dtr("Street")
        End While
        cnn.Close()
        GetHomeZipCode = strZipCode
    End Function
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmAssignWorkOrder" runat="server">
    <div class="inputformsectionheader">Ticket Information</div>
      <table width="100%">
        <tr>
          <td style="width:30%"><div class="inputform">
              <table width="100%">
                <tbody>
                  <tr>
                    <td class="label">Ticket ID</td>
                    <td><asp:Label ID="lblTicketID" runat="server" /></td>
                    <td>&nbsp;</td>
                    <td class="label">City</td>
                    <td><asp:Label ID="lblCity" runat="server" /></td>
                    <td class="label">State</td>
                    <td><asp:Label ID="lblState" runat="server" /></td>
                    <td class="label">Zip</td>
                    <td><a id="lnkZipCode" runat="server"><asp:Label ID="lblZip" runat="server" /></a></td>
                    <td class="label">County</td>
                    <td><asp:Label ID="lblCounty" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox runat="server" ID="txtNewZip" Width ="80px" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnVerifyCoverage" Text="Verify Coverage" runat="server" OnClick="btnVerifyCoverage_Click" /></td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="inputformsectionheader">Work Order Information</div>
            <div class="inputform">
            <div id="divErrors" runat="server" class="errorzone" visible="false" />
            <table>
              <tbody>
                <tr>
                  <td class="label">Flat Rate</td>
                  <td class="label">Hourly Rate</td>
                  <td class="label">MinTimeOnSite</td>
                  <td class="label">Increment</td>
                  <td class="label">Extra Amount</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td><asp:TextBox runat="server" ID="txtMaximum" Width ="80px" /></td>
                  <td><asp:TextBox runat="server" ID="txtRate" Width ="80px" /></td>
                  <td><asp:TextBox runat="server" ID="txtMinimum" Width ="80px" /></td>
                  <td><asp:DropDownList ID="cbxIncrements" runat="server"  /></td>
                  <td><asp:TextBox runat="server" ID="txtAdjust" Width ="80px"/></td>
                  <td><asp:Button ID="btnAssign" Text="Assign" runat="server" OnClick="btnAssign_Click" Enabled ="false"/></td>
                </tr>
                  <tr>
                      <td colspan ="6">
                          <div>Technician: <asp:Label ID="lblSelectedTechnician" runat ="server"  Text="Selected Technician:"/>&nbsp;&nbsp;&nbsp;<asp:Label ID="lblPartnerAgentBusinessPhoneNumber" runat ="server"/></div>
                      </td>
                  </tr>
              </tbody>
            </table>
            <div style="text-align: left;"><asp:CheckBox ID="chkAssignComponents" runat="server" Text="Assign Ticket Components To This Work Order" /></div>
            </div>
            <table style="width: 100%" class="inputform">
              <tr>
                <td>
                   <div class="inputformsectionheader">Agents Assigned to this Zip Code</div>
                  <asp:DataGrid ID="dgvAssignedTech" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false" CssClass="Grid1">
                    <HeaderStyle CssClass="gridheader" />
                    <AlternatingItemStyle CssClass="altrow" />
                    <Columns>
                      <asp:BoundColumn HeaderText="ID" DataField="PartnerAgentID" Visible="False" />
                      <asp:BoundColumn HeaderText="ID" DataField="ResumeID" Visible="false" />
                      <asp:TemplateColumn HeaderText="Agent ID">
                        <ItemTemplate>
                          <a href="assignworkorder.aspx?pid=<%#DataBinder.Eval(Container.DataItem, "PartnerAgentID")%>&id=<%#CurrentID%>&NewZip=<%#CurrentZip%>"><%#DataBinder.Eval(Container.DataItem, "resumeID")%></a>
                        </ItemTemplate>
                      </asp:TemplateColumn>
                      <asp:Templatecolumn HeaderText="Name">
                        <ItemTemplate>
                          <a href="mailto:<%#DataBinder.Eval(Container.DataItem,"Email") %>"><%#DataBinder.Eval(Container.DataItem, "FirstName")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%></a>
                        </ItemTemplate>
                      </asp:Templatecolumn>  
                      <asp:BoundColumn HeaderText="Status" DataField="PartnerAgentStatus" /> 
                      <asp:BoundColumn HeaderText="ResumeType" DataField="ResumeType" />                            
                      <asp:BoundColumn HeaderText="City" DataField="City" />
                      <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />
                      <asp:TemplateColumn>                     
                         <ItemTemplate>
                            <a href="../Maps/<%# Databinder.eval(Container.DataItem,"LocationName") %>.jpg" target="_blank"><%# Databinder.eval(Container.DataItem,"LocationName") %></a>
                         </ItemTemplate>
                      </asp:TemplateColumn> 
                      <asp:TemplateColumn HeaderText="Distance">
                        <ItemTemplate>
                          <a target="_blank" href="<%# DriveIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Distance") %></a>
                        </ItemTemplate>
                      </asp:TemplateColumn>
                    </Columns>
                  </asp:DataGrid>        
        
        
                  <div class="inputformsectionheader">Closest Agents</div>
                  <asp:DataGrid ID="dgvClosestAgents" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false" CssClass="Grid1">
                    <HeaderStyle CssClass="gridheader" />
                    <AlternatingItemStyle CssClass="altrow" />
                    <Columns>
                      <asp:BoundColumn HeaderText="ID" DataField="PartnerAgentID" Visible="False" />
                      <asp:BoundColumn HeaderText="ID" DataField="ResumeID" Visible="false" />
                      <asp:TemplateColumn HeaderText="Agent ID">
                        <ItemTemplate>
                          <a href="assignworkorder.aspx?pid=<%#DataBinder.Eval(Container.DataItem, "PartnerAgentID")%>&id=<%#CurrentID%>&NewZip=<%#CurrentZip%>"><%#DataBinder.Eval(Container.DataItem, "resumeID")%></a>
                        </ItemTemplate>
                      </asp:TemplateColumn>
                      <asp:Templatecolumn HeaderText="Name">
                        <ItemTemplate>
                          <a href="mailto:<%#DataBinder.Eval(Container.DataItem,"Email") %>"><%#DataBinder.Eval(Container.DataItem, "FirstName")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%></a>
                        </ItemTemplate>
                      </asp:Templatecolumn>  
                      <asp:BoundColumn HeaderText="Status" DataField="PartnerAgentStatus" />    
                      <asp:BoundColumn HeaderText="City" DataField="City" />
                      <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />
                      <asp:TemplateColumn>                     
                         <ItemTemplate>
                            <a href="../Maps/<%# Databinder.eval(Container.DataItem,"LocationName") %>.jpg" target="_blank"><%# Databinder.eval(Container.DataItem,"LocationName") %></a>
                         </ItemTemplate>
                      </asp:TemplateColumn> 
                      <asp:TemplateColumn HeaderText="Distance">
                        <ItemTemplate>
                          <a target="_blank" href="<%# DriveIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Distance") %></a>
                        </ItemTemplate>
                      </asp:TemplateColumn>
                    </Columns>
                  </asp:DataGrid>        
                </td>
              </tr>
            </table> 
        </td>
        <td style="width:70%">
          <div id="tab5">
          <asp:Menu ID="menu" runat="server" Orientation="Horizontal" OnMenuItemClick ="menu_MenuItemClick" CssClass="ul">
             <StaticMenuItemStyle CssClass="li" />
             <StaticHoverStyle CssClass="hoverstyle" />
             <StaticSelectedStyle CssClass="current" />
             <Items>
                <asp:MenuItem  value ="0" Text="Labor Networks"></asp:MenuItem>
                <asp:MenuItem value = "1" Text="First Contact"></asp:MenuItem>
                <asp:MenuItem value = "2" Text="Availability"></asp:MenuItem>
                <asp:MenuItem value ="3" Text="Phones & Address"></asp:MenuItem> 
                <asp:MenuItem value = "4" Text="Skill Sets & Certifications"></asp:MenuItem>
                <asp:MenuItem value = "5" Text="Rates"></asp:MenuItem>
             </Items>
           </asp:Menu>
          </div>
          <div id="ratesheader" class="tabbody">
          <div>&nbsp;</div></div>
          <asp:MultiView ID="AgentInfo" runat="server" ActiveViewIndex="0" >
            <asp:View ID="LaborNetworks"  runat="server">
               <div class="inputformsectionheader"><asp:Label ID="lblAssignedResumeTypes" runat="server" />&nbsp;Associated&nbsp;Labor Network(s)</div>
                  <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvResumeTypes" runat="server" CssClass="Grid2">
                    <HeaderStyle CssClass="gridheader" />
                    <AlternatingItemStyle CssClass="altrow" />   
                    <Columns>
                      <asp:BoundColumn DataField="ResumeTypeID" HeaderText="Type" visible= "false"/>
                      <asp:BoundColumn DataField="ResumeType" HeaderText="Labor Network" />
                    </Columns>        
                  </asp:DataGrid>
               <div class="inputformsectionheader">Averages and Metrics</div>          
                  <table>
                     <tbody>
                        <tr>
                           <td class="label">ICL*</td>
                           <td style="vertical-align: middle;"><asp:Image ID="imgICL" runat="server" /></td>
                        </tr>
                        <tr>
                           <td style="text-align: right;" class="smalltext" colspan="2">
                                  *ICL = "Initial Confidence Level"
                           </td>
                        </tr>
                        <tr>
                           <td class="label">Open Work Orders</td>
                           <td><asp:Label ID="lblOpenWorkOrders" runat="server" /></td>
                        </tr>
                     </tbody>
                  </table>
                  <table>
                     <tbody>
                        <tr>
                           <td class="label">Partner Since</td>
                           <td><asp:Label ID="lblDateCreated" runat="server" /></td>
                        </tr>
                        <tr>
                           <td class="label">Status</td>
                           <td><asp:Label ID="lblStatus" runat="server" /></td>
                        </tr>
                        <tr>
                           <td class="label">Closed Work Orders</td>
                           <td><asp:Label ID="lblClosedWorkOrders" runat="server" /></td>
                        </tr>
                     </tbody>
                  </table>
            </asp:View>
            <asp:View ID="FirstContact"  runat="server" >
              <div >
                <table style="width: 100%">
                  <tbody>
                    <tr>
                      <td class="inputform">
                        <div class="inputformsectionheader">Contact Information</div>
                        <div><asp:Label ID="lblContact" runat="server" /></div>
                        <div><a target="_blank" id="lnkMapIt" runat="server"><asp:Label ID="lblAddress" runat="server" /></a></div>
                        <div><a id="lnkEditTicket" runat="server">Edit</a></div> 
                      </td>
                      <td>&nbsp;</td>
                      <td class="inputform">
                        <div class="inputformsectionheader">Phone Numbers</div>
                        <asp:DataGrid style="width:100%; background-color: White;" ID="dgvPhoneNumbers" runat="server" AutoGenerateColumns="false" CssClass="Grid2">
                          <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />   
                          <Columns>
                            <asp:BoundColumn
                              DataField="PhoneType"
                              HeaderText="Type"
                              ItemStyle-Wrap="false"
                              />                    
                            <asp:TemplateColumn
                              HeaderText="EU Phone Number"
                              ItemStyle-Wrap="true"
                              >
                              <ItemTemplate>
                                <%# Databinder.eval(Container.DataItem, "CountryCode") %> (<%# Databinder.eval(Container.DataItem, "AreaCode") %>) <%# Databinder.eval(Container.DataItem, "Exchange") %>-<%# Databinder.eval(Container.DataItem, "LineNumber") %>
                              </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn
                              DataField="Extension"
                              headertext="Extension"
                              ItemStyle-Wrap="true"
                              />
                            <asp:BoundColumn
                              DataField="Pin"
                              headertext="Pin"
                                  ItemStyle-Wrap="true"
                              />
                                                     
                            <asp:TemplateColumn
                              HeaderText="Command"
                              >
                              <Itemtemplate>
                                <a href="editphone.aspx?returnurl=ticket.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>&id=<%# DataBinder.Eval(Container.DataItem,"TicketPhoneNumberID") %>&mode=ticket">Edit</a>
                              </Itemtemplate>
                            </asp:TemplateColumn>                            
                          </Columns>                
                        </asp:DataGrid> 
                        <div><a id="lnkAddPhone" runat="server">Add&nbsp;Phone&nbsp;Number</a></div>
                      </td>
                      <td>&nbsp;</td>
                      <td class="inputform">
                        <div class="inputformsectionheader">Ticket Information</div>
                        <table cellspacing="0">
                          <tr>
                            <td class="label">Ticket ID</td>
                            <td>&nbsp;</td>
                            <td ><asp:Label ID="lblTicketNumber" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Status</td>
                            <td>&nbsp;</td>
                            <td ><asp:Label ID="lblTicketStatus" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Created</td>
                            <td>&nbsp;</td>
                            <td ><asp:Label ID="lblCreated" runat="server" /></td>
                          </tr>
                          <tr>
                            <td class="label">Change Status To:</td>
                            <td>&nbsp;</td>
                            <td ><asp:DropDownList ID="drpStatusList" runat="server" /></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </tbody>
                </table>
            </div>
            <div style="padding-right: 5px"><asp:TextBox runat="server" ID="txtNotes" TextMode="multiLine" ReadOnly="true" style="width: 100%; height: 50px;" /></div>
             <div >&nbsp;</div>
            <div>
                          <div class="label"><b>Model: </b>&nbsp;<asp:TextBox runat="server" ID="txtModel" />&nbsp;&nbsp;<b> Serial: </b>&nbsp;<asp:TextBox runat="server" ID="txtSerial" visible ="True"/>&nbsp;<b>DOP: </b>&nbsp;<asp:TextBox runat="server" ID="txtDOP" />&nbsp;<b>Service Type:</b>&nbsp;<asp:TextBox runat="server" ID="txtServiceType" visible ="true"/><asp:TextBox runat="server" ID="txtProgram" visible ="false"/></div>
                          <div >&nbsp;</div> 
            </div>
                <div class="errorzone" id="div1" runat="server" visible="false" />
                <div class="label">Contact Note</div>
                <div style="padding-right: 3px;"><asp:TextBox ID="txtNote" runat="server" TextMode="multiLine" style="width: 100%; height: 100px;" /></div>
                <div>&nbsp;</div>
                <div style="text-align: left;"><asp:Button OnClick="btnSendEmail_Click" ID="btnSendEmail"  runat="server" Text="Send Welcome Email" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 <asp:CheckBox ID="chkFirstContact" runat="server" Text="First Contact Done"/>&nbsp;&nbsp;
                  <asp:Button OnClick="btnViewScript_Click" ID="btnView" runat="server" Text="View Script" />&nbsp;
                  <asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;
                  <asp:Button ID="btnApply" OnClick="btnApply_Click" Text="Apply" runat="server"  />&nbsp;
                  <asp:Button ID="btnOK" OnClick="btnOK_Click" Text="Submit" runat="server" /></div>
                <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
            
              <div id="Electrolux" runat="server" visible= "False">
                
                <p><span style='font-size:10.0pt;font-family:"Arial","sans-serif";'>
                <ol>
                   <li>Hi, this is &quot;Your Name&quot; from Best Services of America with &quot;Customer Name&quot;</li><br><br/>
                   <li>We have received a work order to service the appliance your are having problems with.(Verify which appliance)</li><br/><br/>
                   <li>To process your order I need to verify some information, do you have few minutes? Thank you.</li><br/><br/>
                   <li>First I need to verify your home address: address, city, state and zip code</li><br/><br/>
                   <li>I also would need to verify the model and serial number of the unit to be repaired. Would you be able to provide me the model number now?</li><br/><br/>
                   <li>Would you be able to explain in details what seems to be the problem that you are having with the unit?</li><br/><br/>
                   <li>Ok, at this point I have verified all the necessary information for service,</li><br/><br/>
                    <li>Let me provide you the technicians information. Do you have a pen?</li><br/><br/>
                    <li>(Provide techs name and number)</li><br/><br/>
                   <li>If you have any question until then, you can please give us a call at 561.886.6699 and your reference number in our system is: (Provide ticketID)</li><br/><br/>
                    <li>I will put you on hold for few minutes so I can try to reach the technician so we can schedule an appt. Is that ok with you? Thanks, one moment please.</li><br/><br/>
                   <li>(conference tech with end user to schedule)</li><br/><br/>
                   <li>Thank you for your time and information, and have a nice day!</li></span></p>
                
               </ol>    
               <div>&nbsp;</div>
             </div>
             <div id="Omni" runat="server" visible= "False">
                
                <p><span style='font-size:10.0pt;font-family:"Arial","sans-serif";'>
                <ol>
                   <li>Hi, this is &quot;Your Name&quot; from Best Service of America with &quot;Customer Name&quot;</li><br/><br/>
                   <li>We have received a work order to service the appliance your are having problems with.(Verify which appliance)</li><br/><br/>
                   <li>Do you have a pen and a paper handy? I would like to give you our information in case you need to get in contact with us.</li><br/><br/>
                   <li>(provide our phone number and ticket ID to end user)</li><br/><br/>
                   <li>And I also would like to give you our fax number so you can fax us the proof of purchase for the unit which is required</li><br/>
                       by the warranty company in order to provide service?</li><br/><br/>
                   <li>(provide fax number to end user)</li><br/><br/>
	               <b>&quot;IF PROOF OF PURCHASE IS AVAILABLE&quot;</b><br/><br/>
                   <li>Would you be able to explain in details what seems to be the problem you are having with the unit?</li><br/><br/>
                   <li>Ok, at this point I have entered all the necessary information for technical support, if they feel they need any extra information<br/>
                      to be able to order your part they should be contacting again.</li><br/><br/>
                   <li>For now, once the part is ordered...can we ship it to your address we have on file? (Yes)</li><br/><br/>
                   <li>Please once, you receive the part give us a call at 866.249.5033.</li><br/><br/>
                   <li>And if you have any question until then, you can please give us a call on that same phone number and refer to the ticket number &quot;ticket ID&quot;.</li><br/><br/>
                   <li>Thank you for your time and information, and have a nice day!</li></span><span ><o:p></o:p></span></p>
                       <B>&quot;IF PROOF OF PURCHASE IS NOT AVAILABLE&quot;</B><br/><br/>
                   <li>Without a proof of purchase, this repair will have to be handled as an out of warranty service. Would that be OK with you?</li><br/><br/>
                   <li>As an out of warranty service, a $85,00 deposit fee is collected in order to send a technician onsite to diagnose the unit.<br/>
                       The Technician will verify what is necessary to fix the unit and we will provide you an estimate for the cost of the repair.</li><br/><br/>
                   <li>At that point, if you decide to go ahead and repair the unit, we will apply the $85.00 deposit towards the total amount of the repair,<br/>
	               and we will need to collect the balance for the repair prior from ordering the parts and continue with the service.</li><br/><br/>
                   <li>If for some reason you decide not to accept our estimate, we will stay with the deposit in order to cover the costs of the visit from the technician.</li><br/><br/>
                   <li>Do you agree with these terms?</li><br/><br/>
                   <li>Please provide me with the credit or debit card, that you would like to make the payment with. (Charge the $50.00 deposit)</li></span><span ></span></p>
                   <li>We will be assigning the ticket to a technician in your area and the technician should be contacting you within 24/48 hours.</li>  
              </ol>    
               <div>&nbsp;</div>
             </div>
                        
            </asp:View>
             <asp:View ID="Availability"  runat="server">
              <table>
                <tr>
                  <td style="width :50%;">
                    <div class="bandheader">Working Days</div>
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
                                  <div>&nbsp;</div>
                                  <div class="label">Special Instructions</div>
                                  <div style="padding-right: 5px"><asp:TextBox runat="server" ID="txtSpecialInstructions" TextMode="multiLine" style="width: 100%; height: 30px;"/> </div>
                                  <div>&nbsp;</div>
                                  <div><asp:TextBox ID="RadioSelectID" runat="server"  Visible ="false"  /></div>
                                  <div><asp:Button ID="btnSetSchedule" Text="Set Appointment" runat="server" OnClick="btnSetAppointment_click"  UseSubmitBehavior="true"  /></div>
                            <div class="inputformsectionheader"><asp:label ID="Label1" runat="server" />&nbsp;Days of Work&nbsp;</div>
                            <asp:DataGrid ID="dgvAssignedScheduleAvailabilityZones" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid2" >
                               <AlternatingItemStyle CssClass="altrow" />
                                  <HeaderStyle CssClass="gridheader" />
                                     <Columns>
                                         <asp:BoundColumn HeaderText="ID" DataField="PartnerAgentAvailabilityID" visible="false" />
                                         <asp:TemplateColumn HeaderText="Select"  >
                                            <ItemTemplate>
                                              <asp:RadioButton id="rdbBatchTime" runat="server" AutoPostBack="True" OnCheckedChanged="SelectOnlyOne"></asp:RadioButton>
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                         <asp:BoundColumn HeaderText="Type" DataField="ZoneName" />                 
                                         <asp:TemplateColumn HeaderText="ZoneName"  >
                                            <ItemTemplate>
                                               <%# CType(DataBinder.Eval(Container.DataItem, "StartScheduleTime"), Date).ToString("HH:mm") %> - <%# CType(DataBinder.Eval(Container.DataItem, "EndScheduleTime"), Date).ToString("HH:mm") %>
                                            </ItemTemplate>
                                         </asp:TemplateColumn>
                                     </Columns>                
                               </asp:DataGrid>  
                  </td> 
                  <td><div>&nbsp;</div></td>
                  <td><div>&nbsp;</div></td>
                  <td >
                     <div><rad:RadDatePicker ID="RadDatePickerTo" runat="server"  DateInput-Font-Size="Medium" Culture="English (United States)"  Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" OnSelectedDateChanged ="ShowSchedules" AutoPostBack="true">
                       <DateInput Font-Size="Medium" Skin="">
                       </DateInput>
                     </rad:RadDatePicker></div>
                      <div>&nbsp;</div>
                       <div>&nbsp;</div>
                       <div>&nbsp;</div>
                       <div class="inputformsectionheader">Current Technician's Schedule</div>
                        <asp:DataGrid style="background-color: White;" ID="dgvShowAvailabilityforDay" runat="server" AutoGenerateColumns="false" CssClass="Grid2">
                          <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />
                          <Columns>
                            <asp:BoundColumn HeaderText="Type" DataField="ZoneName"  />
                            <asp:BoundColumn HeaderText="Schedule Start" DataField="ScheduleStart"  />
                            <asp:BoundColumn HeaderText="Schedule End" DataField="ScheduleEnd" />
                            <asp:BoundColumn HeaderText="Status" DataField="CodeName"  />
                            <asp:BoundColumn HeaderText="Date" DataField="dateSet" visible ="false" />
                            <asp:TemplateColumn HeaderText="TicketID">
                              <ItemTemplate>
                                 <a href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>" target ="_blank"><%# DataBinder.Eval(Container.DataItem,"TicketID")%> </a>
                              </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn HeaderText="City" DataField="City"  />
                            <asp:BoundColumn HeaderText="Zip" DataField="ZipCode" />
                            <asp:BoundColumn HeaderText="County" DataField="County"  />
                              <asp:BoundColumn HeaderText="Street" DataField="Street"  />
                          </Columns>    
                        </asp:DataGrid>

                   </td>
                  </tr>
                  <tr>
                      <td colspan="4">
                          <div style="text-align:center;"><iframe width="97%" height="500" id="MapHolder" runat="server" frameborder ="0"/></div>
                      </td>
                  </tr>
            </table>

            </asp:View>
            <asp:View ID="PhoneNumbers"  runat="server">
                 <div class="inputformsectionheader">Agent Phone Numbers"</div>
                    <asp:DataGrid style="background-color: white; width: 100%" ID="dgvAssociatedPhoneNumbers" runat="server" AutoGenerateColumns="false" CssClass="Grid2">
                         <AlternatingItemStyle CssClass="altrow" />
                           <HeaderStyle CssClass="gridheader" />
                                <Columns>
                                  <asp:BoundColumn
                                    HeaderText="ID"
                                    DataField="AssignmentID"
                                    visible="false"
                                    />                    
                                  <asp:BoundColumn
                                    HeaderText="Type"
                                    DataField="PhoneType"
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
                                </Columns>                
                    </asp:DataGrid>
                 <div>&nbsp;</div> 
                    <div class="inputformsectionheader">Shipping&nbsp;Locations</div>
                          <asp:DataGrid ID="dgvLocations" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false" CssClass="Grid2">
                            <AlternatingItemStyle CssClass="altrow" />
                            <HeaderStyle CssClass="gridheader" />
                            <Columns>
                              <asp:BoundColumn DataField="PartnerAddressID" HeaderText="ID" Visible="false" />
                              <asp:TemplateColumn HeaderText="Address">
                                <ItemTemplate>
                                  <a target="_blank" href="<%# MapIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%></a>
                                </ItemTemplate>
                              </asp:TemplateColumn>
                              <asp:BoundColumn DataField="City" HeaderText="City" />
                              <asp:BoundColumn DataField="Abbreviation" HeaderText="State" />
                              <asp:TemplateColumn HeaderText="Zip Code">
                                <ItemTemplate>
                                  <a target="_blank" href="findzipcode.aspx?zip=<%# DataBinder.Eval(Container.DataItem,"ZipCode") %>&id=<%#CurrentID%>"><%# DataBinder.Eval(Container.DataItem,"ZipCode") %></a>
                                </ItemTemplate>
                              </asp:TemplateColumn>
                            </Columns>
                          </asp:DataGrid>
                          <div>&nbsp;</div> 
                    <div class="inputformsectionheader">Coverage</div>
                          <asp:DataGrid ID="dgvCounties" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false" CssClass="Grid2">
                            <AlternatingItemStyle CssClass="altrow" />
                            <HeaderStyle CssClass="gridheader" />
                            <Columns>
                              <asp:BoundColumn DataField="CountyName" HeaderText="Counties" />
                            </Columns>
                          </asp:DataGrid>              
            </asp:View>
           
            <asp:View ID="SkillSets"  runat="server">
               <div class="inputformsectionheader">Skill Sets</div>
                        <asp:DataGrid style="background-color: White;" ID="dgvAverageSkillSet" runat="server" AutoGenerateColumns="false" CssClass="Grid2">
                          <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />
                          <Columns>
                            <asp:BoundColumn HeaderText="ID" DataField="SkillSetQuestionID" Visible="false" />
                            <asp:BoundColumn HeaderText="SkillLevel" DataField="SkillLevel" Visible="false" />
                            <asp:BoundColumn HeaderText="Skill" DataField="Question" />
                            <asp:TemplateColumn HeaderText="Skill Level">
                              <ItemTemplate>
                                <img src="<%# DetermineAppropriateBar(Databinder.Eval(Container.DataItem,"SkillLevel")) %>" alt="Level <%# Databinder.Eval(Container.DataItem,"SkillLevel") %>" />            
                              </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn HeaderText="YOE*" DataField="YearsExperience" />
                          </Columns>    
                        </asp:DataGrid>
                        <div class="smalltext" style="text-align: right;">*YOE = Years Of Experience</div>
                      <div>&nbsp;</div>
                        <div class="inputformsectionheader">Certifications</div>
                        <asp:DataGrid ID="dgvCertifications" style="background-color: White;" runat="server" AutoGenerateColumns="false" CssClass="Grid2">
                          <AlternatingItemStyle CssClass="altrow" />
                          <HeaderStyle CssClass="gridheader" />
                          <Columns>
                            <asp:BoundColumn HeaderText="Agency" DataField="AgencyName" />
                            <asp:BoundColumn HeaderText="Certification" DataField="CertificationName" />
                          </Columns>
                        </asp:DataGrid>
            </asp:View>
            
            <asp:View ID="Rates"  runat="server">
              <div class="inputformsectionheader">Rates</div>
                  <asp:DataGrid ID="dgvRates" style="width: 100%; background-color: White;" runat="server" AutoGenerateColumns="false"  CssClass="Grid2">
                    <HeaderStyle CssClass="gridheader" />
                    <AlternatingItemStyle CssClass="altrow" />   
                    <Columns>
                      <asp:BoundColumn
                        DataField="PartnerReferenceRateID"
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
                    </Columns>                
                  </asp:DataGrid>
                    
            </asp:View>
          </asp:MultiView> 
        </td>
      </tr>
    </table>        
  </form>  
</asp:Content>