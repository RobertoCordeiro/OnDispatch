<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>

<script runat="server"> 
  
  Private _ID As Long = 0
  Private _TicketID As Long = 0
  Private Const cstCancelledImageID As Integer = 55
    Private _PartnerAgentID As Long = 0
    Private _WorkOrderID As Long = 0
    Private _PartnerAddressID As Long = 0
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = ""
      Master.PageTitleText = Master.PageHeaderText
      Master.PageHeaderText = ""
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a>"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        txtArrived.Text = DateTime.Now.Month.ToString("00") & "/" & DateTime.Now.Day.ToString("00") & "/" & DateTime.Now.Year.ToString("0000")
        txtDeparted.Text = txtArrived.Text
        chkClosedFromSite.Checked = True
        chkResolved.Checked = True
        LoadStatuses()
        txtTimeOnHold.Text = 0
        txtMileageEnd.Text = 0
        txtMileageStart.Text = 0
        txtTravelTime.Text = 0
        LoadWorkOrder()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadStatuses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListTicketStatuses", "Status", "TicketStatusID", drpTicketStatus)
    ldr.LoadSimpleDropDownList("spListClosingWorkOrderStatuses", "WorkOrderStatus", "WorkOrderStatusID", drpWorkOrderStatus)
  End Sub
  
  Private Sub LoadWorkOrder()
    Dim datNothing As Date = Nothing
    Dim strHTML As String = ""
    Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim stt As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim par as new BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    wrk.Load(_ID)
    
    If wrk.WorkOrderID = 0 Then
      divNotFound.Visible = True
      divCloseForm.Visible = False
    Else
      divCloseForm.Visible = True
      divNotFound.Visible = False
      Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            par.Load(wrk.PartnerAgentID)
            txtTechnician.Text = par.FirstName & " " & par.LastName
      tkt.Load(wrk.TicketID)
      _TicketID = wrk.TicketID
      txtnotes.text = tkt.Notes
      txtQuestions.Text = "1.Time Onsite" & Chr(10) & "2.Issue w/ Unit (New Or Existing)"& Chr(10) & "3.Technical Support Contacted?" & Chr(10) & "4.Resulution & Case Numer" & Chr(10) & "5.What Parts are needed?"
      LoadComponents()
      zip.Load(tkt.ZipCode)
      If zip.ZipCodeID > 0 Then
        lblLocalTime.Text = zip.LocalTime.Hour.ToString("00") & ":" & zip.LocalTime.Minute.ToString("00")
      Else
        lblLocalTime.Text = DateTime.Now.Hour.ToString("00") & ":" & DateTime.Now.Minute.ToString("00")
      End If
      If lblReturnUrl.Text.Trim.Length = 0 Then
        lblReturnUrl.Text = "ticket.aspx?id=" & tkt.TicketID
      End If
      drpTicketStatus.SelectedValue = tkt.TicketStatusID
      txtManufacturer.Text = tkt.Manufacturer
      txtModel.Text = tkt.Model
      txtSerialNumber.Text = tkt.SerialNumber
      If datNothing <> tkt.PurchaseDate Then
        txtPurchaseDate.Text = tkt.PurchaseDate
      End If
      lnkWorkOrder.HRef = "printableworkorder.aspx?id=" & _ID.ToString
      lnkTicket.HRef = "ticket.aspx?id=" & tkt.TicketID
      lblWorkOrderID.Text = _ID
      lblTicketID.Text = tkt.TicketID
      lnkMapIt.HRef = MapIt(tkt.Street, tkt.ZipCode)
      stt.Load(tkt.StateID)
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
      lblAddress.Text = strHTML
      
      if not IsDBNull(wrk.Arrived) then
        txtArrivedTime.Text = Format(TimeValue(wrk.Arrived),"HH:mm")
      end if
    End If 
    LoadWorkOrders()   
  End Sub
 
  Private Function MapIt(ByVal strAddress As String, ByVal strZipCode As String) As String
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
    strReturn = ggl.MapAddress(strAddress, strZipCode)
    Return strReturn
  End Function
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dat As Date = DateTime.Now
    Dim lng As Long = 0
    If txtResolutionNote.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Resolution Note is Required</li>"
    End If
        If (txtArrived.Text.Trim.Length = 0) Or (txtArrivedTime.Text.Trim.Length = 0) Then
            blnReturn = False
            strErrors &= "<li>Arrive On Site is Required</li>"
        Else
            If Not Date.TryParse(txtArrived.Text & " " & txtArrivedTime.Text.Trim, dat) Then
                blnReturn = False
                strErrors &= "<li>Arrive On Site Must be A Date/Time</li>"
            End If
        End If
    If (txtDeparted.Text.Trim.Length = 0) Or (txtDepartedTime.Text.Trim.Length = 0) Then
      blnReturn = False
      strErrors &= "<li>Departed From Site is Required</li>"
    Else
      If Not Date.TryParse(txtDeparted.Text & " " & txtDepartedTime.Text.Trim, dat) Then
        blnReturn = False
        strErrors &= "<li>Departed From Site Must be A Date/Time</li>"
      End If
    End If
    If txtTravelTime.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Travel Time is Required</li>"
    Else
      If Not Long.TryParse(lng, txtTravelTime.Text.Trim) Then
        blnReturn = False
        strErrors &= "<li>Travel Time Must Be A Whole Number</li>"
      End If
    End If
    If txtMileageStart.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Mileage Start is Required</li>"
    Else
      If Not Long.TryParse(lng, txtMileageStart.Text.Trim) Then
        blnReturn = False
        strErrors &= "<li>Mileage Start Must Be A Whole Number<li>"
      End If
    End If
    If txtMileageEnd.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Mileage End is Required</li>"
    Else
      If Not Long.TryParse(lng, txtMileageEnd.Text.Trim) Then
        blnReturn = False
        strErrors &= "<li>Mileage End Must Be A Whole Number</li>"
      End If
    End If
    If txtTimeOnHold.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Time On Hold is Required</li>"
    Else
      If Not Long.TryParse(txtTimeOnHold.Text.Trim, lng) Then
        blnReturn = False
        strErrors &= "<li>Time On Hold Must Be A Whole Number</li>"
      End If
    End If
    If txtPurchaseDate.Text.Trim.Length > 0 Then
      If Not Date.TryParse(txtPurchaseDate.Text.Trim, dat) Then
        blnReturn = False
        strErrors &= "<li>Purchase Date Must Be A Valid Date</li>"
      End If
    End If
    if txtSerialNumber.Text.Trim.Length = 0 Then
       blnReturn = False
       strErrors &= "<li>Serial Number cannot be blank.We need the unit Serial Number to close this ticket.</li>"
    end if
    if txtSerialNumber.Text.Trim.Length = 0 Then
       blnReturn = False
       strErrors &= "<li>Serial Number cannot be blank.We need the unit Serial Number to close this ticket.</li>"
    end if    


    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

    Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngTicket As Long
        Dim lngTStatus As Long
        If IsComplete() Then
            divErrors.Visible = False
            Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim strChangeLog As String = ""
            Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim svt as New BridgesInterface.ServiceTypeRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
            Dim svc as New BridgesInterface.ServiceRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
            Dim pap As New BridgesInterface.PartnerServiceRateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            wrk.Load(_ID)
            tkt.Load(wrk.TicketID)
            svc.Load(tkt.ServiceID)
            svt.Load(svc.ServiceTypeID)
            _TicketID = wrk.TicketID
            _PartnerAgentID = wrk.PartnerAgentID
            _PartnerAddressID = wrk.PartnerAddressID
            tkt.TicketStatusID = drpTicketStatus.SelectedValue
            wrk.WorkOrderStatusID = drpWorkOrderStatus.SelectedValue
            wrk.Arrived = txtArrived.Text & " " & txtArrivedTime.Text
            wrk.ClosingAgent = Master.UserID
            wrk.Departed = txtDeparted.Text & " " & txtDepartedTime.Text
            wrk.TravelTime = txtTravelTime.Text
            wrk.MileageStart = txtMileageStart.Text
            wrk.MileageEnd = txtMileageEnd.Text
            wrk.TimeOnHold = txtTimeOnHold.Text
            wrk.TechSupportAgentName = txtTechSupportAgent.Text
            
            tkt.Manufacturer = txtManufacturer.Text
            tkt.SerialNumber = txtSerialNumber.Text
            tkt.Model = txtModel.Text
            If txtPurchaseDate.Text.Trim.Length > 0 Then
                tkt.PurchaseDate = txtPurchaseDate.Text
            Else
                tkt.PurchaseDate = Nothing
            End If
            wrk.ResolutionNote = txtResolutionNote.Text
            wrk.ClosedFromSite = chkClosedFromSite.Checked
            wrk.Resolved = chkResolved.Checked
            wrk.SurveyAuthorized = chkSurveyAuthorized.Checked
            wrk.SurveyEmail = txtSurveyEmail.Text
            tkt.Email = txtSurveyEmail.Text
            

            If Me.drpWorkOrderStatus.SelectedValue = 5 Then ' (Cancelled) 
                wrk.WorkOrderFileID = cstCancelledImageID
                wrk.RPW = 1
                wrk.MaximumPay = 0
                wrk.PayRate = 0
                wrk.MinimumPay = 0
                wrk.IncrementTypeID = 1
                wrk.Billable = True
                wrk.Payable=False
               
            End If
            If ChkPartReturn.Checked Then
                Dim tfr As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tfr.Add(6, wrk.TicketID, CType(28, Long))
            End If
            
            Dim datNothing As Date = Nothing
            If wrk.DispatchDate = datNothing Then
                wrk.DispatchDate = DateTime.Now
            End If
            Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim strIp As String = Request.QueryString("REMOTE_ADDR")
            Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
            If IsNothing(strIp) Then
                strIp = "unknown"
            End If
            If IsNothing(strType) Then
                strType = "web"
            End If
            lngTicket = tkt.TicketID
            lngTStatus = tkt.TicketStatusID
            If IsDBNull(tkt.InitialContact) Then
                tkt.InitialContact = DateTime.Now
            End If
            
            tkt.Save(strChangeLog)
            act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 33, tkt.TicketID, strChangeLog)
            wrk.Save(strChangeLog)
            act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 43, wrk.WorkOrderID, strChangeLog)
            tkt.Load(wrk.TicketID)
      
            Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "Resolution Notes For " & wrk.WorkOrderID & ":" & Environment.NewLine & Me.txtResolutionNote.Text)
            tnt.CustomerVisible = True
            tnt.PartnerVisible = True
            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
            tnt.Acknowledged = True
            tnt.Save(strChangeLog)
            
            Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
            
            Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            cst.Load(tkt.CustomerID)
            
            
            If Not IsTicketOpened(lngTicket) Then
                Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
                stt.Load(tkt.StateID)
                Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                If (Me.drpWorkOrderStatus.SelectedValue = 3) Or (Me.drpWorkOrderStatus.SelectedValue = 7) Then '(Completed or repaired)
                    wrk.Load(_ID)
                    tkt.TicketStatusID = 8
                    'assigning ticket rate - charging customer
                    tkt.MaximumCharge = svc.FlatRate
                    tkt.MinimumCharge = svc.MinimumCharge
                    tkt.ChargeRate = svc.ChargeRate
                    tkt.IncrementTypeID = svc.PayIncrementID
                    wrk.Billable = True
            
                    'assigning work order rate - paying vendor
                    Try
                        pap.Load(wrk.PartnerID, svc.ServiceID)
            
                        wrk.MaximumPay = pap.FlatRate
                        wrk.PayRate = pap.HourlyRate
                        wrk.MinimumPay = pap.MinTimeOnSite
                        wrk.IncrementTypeID = svc.PayIncrementID
                        wrk.Payable = True
                    Catch ex As Exception
                        wrk.MaximumPay = 0
                        wrk.PayRate = 0
                        wrk.MinimumPay = 0
                        wrk.IncrementTypeID = 1
                    End Try
                    
                    If IsDBNull(tkt.ScheduledEndDate) Or tkt.ScheduledEndDate = "#12:00:00 AM#" Then
                        tkt.ScheduledDate = DateTime.Now
                        tkt.ScheduledEndDate = DateTime.Now
                    End If
                    If tkt.CustomerID = CType(30, Long) Then ' BSA
                        'AssignWorkOrder()
                        tkt.TicketStatusID = 23
                        fdl.Add(6, lngTicket, 37)
                        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "AUTO NOTE: NEED TO FIND OUT FROM END USER IF SERVICE COMPLETED AND COLLECT REMAINING BALANCE, IF APPLICABLE. ONCE DONE CLOSE THE TICKET.")
                        tnt.CustomerVisible = True
                        tnt.PartnerVisible = True
                        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                        tnt.Acknowledged = True
                        tnt.Save(strChangeLog)
                    End If
                    If tkt.CustomerID = CType(32, Long) Then ' LG
                        If wrk.ServiceID >= 405 And wrk.ServiceID <= 410 Then ' LG HEY Program Coverage services
                            'AssignWorkOrder()
                            tkt.TicketStatusID = 23 ' Need Eu Payment
                            fdl.Add(6, lngTicket, 37)
                            tkt.TicketStatusID = 23
                            fdl.Add(6, lngTicket, 37)
                            tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "AUTO NOTE: NEED TO FIND OUT FROM END USER IF SERVICE COMPLETED AND COLLECT REMAINING BALANCE, IF APPLICABLE. ONCE DONE CLOSE THE TICKET.")
                            tnt.CustomerVisible = True
                            tnt.PartnerVisible = True
                            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                            tnt.Acknowledged = True
                            tnt.Save(strChangeLog)
                        End If
                    End If
                    fdl.Add(6, lngTicket, 22) ' add ticket to the Survey folder
                End If
                If Me.drpWorkOrderStatus.SelectedValue = 5 Then ' (Cancelled) 
                    tkt.TicketStatusID = 9
                    fdl.Add(6, lngTicket, 34)
                    'If IsDBNull(tkt.ScheduledEndDate) Or tkt.ScheduledEndDate = "#12:00:00 AM#" Then
                    tkt.ScheduledDate = DateTime.Now
                    tkt.ScheduledEndDate = DateTime.Now
                    wrk.Billable = True
                    'End If
                Else
                    fdl.Add(6, lngTicket, 35)
                End If
                If (Me.drpWorkOrderStatus.SelectedValue = 4) Or (Me.drpWorkOrderStatus.SelectedValue = 6) Or (Me.drpWorkOrderStatus.SelectedValue = 12) Or (Me.drpWorkOrderStatus.SelectedValue = 8) Or (Me.drpWorkOrderStatus.SelectedValue = 10) Then ' (Misdiagnosed or Additional Problem found,diagnose completed or wrong part sent, dead on arrival)
                    tkt.TicketStatusID = 14
                   
                    AssignWorkOrder()
                    Select Case tkt.CustomerID
                        
                        Case Is = CType(30, Long) 'BSA  
                            tkt.TicketStatusID = 23 'Need Eu Payment
                            fdl.Add(6, lngTicket, 37)
                            
                        Case Is = CType(32, Long) ' LG
                            If wrk.ServiceID >= 405 And wrk.ServiceID <= 410 Then ' LG HEY Program Coverage services
                                tkt.TicketStatusID = 23 ' Need Eu Payment
                                fdl.Add(6, lngTicket, 37)
                            Else
                                fdl.Add(6, lngTicket, 29)
                            End If
                        Case Is = CType(51, Long), CType(40, Long) ' Lowes
                            tkt.TicketStatusID = 31 'PONT
                            fdl.Add(6, lngTicket, 39)
                            
                        Case Else
                            fdl.Add(6, lngTicket, 29)
                    End Select
                   
                    If Not IsDBNull(tkt.ScheduledEndDate) Or tkt.ScheduledEndDate = "#12:00:00 AM#" Then
                        tkt.ScheduledDate = Nothing
                        tkt.ScheduledEndDate = Nothing
                        DeleteScheduleAssignment(lngTicket)
                    End If
                    
                    
                    If tkt.CustomerID = CType(33, Long) Then '33 hhgregg
                        eml.SendFrom = "AutoCloseCall@bestservicers.com"
                        eml.SendTo = "mary.mikesell2@hhgregg.com"
                        eml.CC = "darren.jones@hhgregg.com"
                        eml.BCC = "hhgregg@bestservicers.com"
                        eml.Subject = "BSA - Ticket Closed: " & lngTicket & "/" & tkt.ReferenceNumber1 & " Status: " & drpWorkOrderStatus.SelectedItem.Text
                  
                        Dim strBody As String
                        strBody = "TICKET INFORMATION: " & Chr(13) & Chr(10)
                        strBody = strBody & "Customer Name: " & tkt.ContactFirstName & " " & tkt.ContactLastName & Chr(13) & Chr(10)
                        strBody = strBody & "Address: " & tkt.Street & Chr(13) & Chr(10)
                        strBody = strBody & "City,State,Zip: " & tkt.City & "  " & stt.Abbreviation & ", " & tkt.ZipCode & Chr(13) & Chr(10)
                        strBody = strBody & "CustomerNumber: " & tkt.ReferenceNumber1 & Chr(13) & Chr(10)
                        strBody = strBody & "Authorization Number: " & tkt.ReferenceNumber2 & Chr(13) & Chr(10)
                        strBody = strBody & "Type: " & tkt.Manufacturer & Chr(13) & Chr(10)
                        strBody = strBody & "Model: " & tkt.Model & Chr(13) & Chr(10)
                        strBody = strBody & "Serial Number: " & tkt.SerialNumber & Chr(13) & Chr(10)
                        strBody = strBody & Chr(13) & Chr(10) & Chr(13) & Chr(10) & "Resolution Notes: " & Chr(13) & Chr(10) & txtResolutionNote.Text
                        eml.Body = strBody.Replace(Environment.NewLine, "<br>")
                        eml.Send()
                    End If
                End If
                lngTStatus = tkt.TicketStatusID
                tkt.Save(strChangeLog)
                wrk.Save(strChangeLog)
                MaintainProduction(lngTicket, lngTStatus)
            End If
            ''If drpWorkOrderStatus.SelectedValue = 3 Or drpWorkOrderStatus.SelectedValue = 7 Then
            ''eml.Subject = "Closed Ticket: " & tkt.TicketID & " Status: " & drpWorkOrderStatus.SelectedItem.Text
            ''eml.Body = txtResolutionNote.Text
            ''eml.SendFrom = "info@centurionvision.com"
            'eml.SendTo = "MStrollo@GlobalWarrantyGroup.com"
            'eml.Send()
            'End If
            Response.Redirect(lblReturnUrl.Text, True)
        Else
            divErrors.Visible = True
        End If
    End Sub
  
    Private Function CurrentID() As Long
        Return _TicketID
    End Function
  
    Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect(lblReturnUrl.Text)
    End Sub

    Private Sub LoadComponents()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListTicketComponents", "@TicketID", _TicketID, dgvComponents)
        Dim dgv As System.Web.UI.WebControls.DataGrid
        For Each itm As System.Web.UI.WebControls.DataGridItem In dgvComponents.Items
            dgv = itm.FindControl("dgvLabels")
            If Not IsNothing(dgv) Then
                ldr.LoadSingleLongParameterDataGrid("spListTicketComponentShippingLabels", "@TicketComponentID", CType(itm.Cells(0).Text, Long), dgv)
            End If
        Next
    End Sub
    Private Sub MaintainProduction(ByVal lngTicketID As Long, ByVal lngStatusID As Long)
        'If CType(tkt.TicketStatusID,long) <> CType(drpTicketStatus.selectedValue,long) then
        
        'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'usr.Load(Master.LoginID)
        Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wbl.Load(Master.WebLoginID)
        Dim strUserName As String
        strUserName = wbl.Login
              
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        'eml.Subject = "Production from: " & strUserName
        'eml.Body = "The status has been changed to - " & drpTicketStatus.SelectedItem.Text & " - on ticket: " & lngTicketID
        'eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
        'eml.SendFrom = strUserName & "@centurionvision.com"
        'eml.SendTo = ptr.Email
        'eml.SendTo = "CallCenterProduction@centurionvision.com"
        'eml.cc = "Nelson.Palavesino@centurionvision.com"
        'eml.cc = "howard.goldman@centurionvision.c6
        'eml.Send()
        
        Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
        plog.Add(Master.WebLoginID ,Now(),6,"Closed Ticket: " & lngTicketID & " Status: " & drpWorkOrderStatus.SelectedItem.Text)
        
        
        eml.Subject = "Closed Ticket: " & lngTicketID & " Status: " & drpWorkOrderStatus.SelectedItem.Text
        eml.Body = txtResolutionNote.Text
        eml.SendFrom = strUserName & "@bestservicers.com"
        eml.SendTo = "ClosedCalls@bestservicers.com"
        eml.CC = "AgentProduction@bestservicers.com"
        eml.Send()
        
        'end if
        HandleFolders(lngTicketID, lngStatusID)

    End Sub
  
    Private Sub HandleFolders(ByVal lngTicketID As Long, ByVal lngTicketStatusID As Long)
        Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
               
        Select Case lngTicketStatusID 'Ticket StatusID
            Case Is = CType(22, Long) 'Status:Extra work need approval
                'add to folder Extra work need approval
                fdl.Add(6, lngTicketID, CType(32, Long))
                removeTicketFromFolder(lngTicketID, CType(1, Long)) 'Folder New
                removeTicketFromFolder(lngTicketID, CType(2, Long)) 'Folder Open
                removeTicketFromFolder(lngTicketID, CType(3, Long)) 'Folder Awaiting parts
                removeTicketFromFolder(lngTicketID, CType(4, Long)) 'Folder Escalated
                removeTicketFromFolder(lngTicketID, CType(7, Long)) 'Folder Missed Appt
                removeTicketFromFolder(lngTicketID, CType(10, Long)) ' Folder Ready for service
                removeTicketFromFolder(lngTicketID, CType(13, Long)) 'Folder Need appt set
                removeTicketFromFolder(lngTicketID, CType(16, Long)) 'Folder To be Dispatched
                removeTicketFromFolder(lngTicketID, CType(17, Long)) 'Folder FistContact
                removeTicketFromFolder(lngTicketID, CType(18, Long)) 'Folder Has Parts
                removeTicketFromFolder(lngTicketID, CType(20, Long)) 'Folder Labor Only
                removeTicketFromFolder(lngTicketID, CType(23, Long)) 'Folder Need Update
                removeTicketFromFolder(lngTicketID, CType(24, Long)) 'Folder New Notes
                removeTicketFromFolder(lngTicketID, CType(25, Long)) 'Folder Need Tech
                removeTicketFromFolder(lngTicketID, CType(26, Long)) 'Folder Phone support
                removeTicketFromFolder(lngTicketID, CType(29, Long)) 'Folder Ordering parts
                'removeTicketFromFolder(lngTicketID, CType(30, Long)) 'Folder Need Customer Feedback
                removeTicketFromFolder(lngTicketID, CType(31, Long)) 'Folder Part on Backorder
                removeTicketFromFolder(lngTicketID, CType(33, Long)) 'Folder Need Appt set
            Case Is = CType(14, Long) 'Ordering  parts
                fdl.Add(6, lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(1, Long)) 'Folder New
                removeTicketFromFolder(lngTicketID, CType(3, Long)) 'Folder Awaiting parts
                removeTicketFromFolder(lngTicketID, CType(7, Long)) 'Folder Missed Appt
                removeTicketFromFolder(lngTicketID, CType(10, Long)) ' Folder Ready for service
                removeTicketFromFolder(lngTicketID, CType(13, Long)) 'Folder Need appt set
                removeTicketFromFolder(lngTicketID, CType(16, Long)) 'Folder To be Dispatched
                removeTicketFromFolder(lngTicketID, CType(17, Long)) 'Folder FistContact
                removeTicketFromFolder(lngTicketID, CType(18, Long)) 'Folder Has Parts
                removeTicketFromFolder(lngTicketID, CType(20, Long)) 'Folder Labor Only
                removeTicketFromFolder(lngTicketID, CType(23, Long)) 'Folder Need Update
                removeTicketFromFolder(lngTicketID, CType(24, Long)) 'Folder New Notes
                removeTicketFromFolder(lngTicketID, CType(25, Long)) 'Folder Need Tech
                removeTicketFromFolder(lngTicketID, CType(26, Long)) 'Folder Phone support
                'removeTicketFromFolder(lngTicketID, CType(30, Long)) 'Folder Need Customer Feedback
                removeTicketFromFolder(lngTicketID, CType(31, Long)) 'Folder Part on Backorder
                removeTicketFromFolder(lngTicketID, CType(33, Long)) 'Folder Need Appt set
            
            Case Else
                removeTicketFromFolder(lngTicketID, CType(1, Long)) 'Folder New
                removeTicketFromFolder(lngTicketID, CType(2, Long)) 'Folder Open
                removeTicketFromFolder(lngTicketID, CType(3, Long)) 'Folder Awaiting parts
                removeTicketFromFolder(lngTicketID, CType(4, Long)) 'Folder Escalated
                removeTicketFromFolder(lngTicketID, CType(7, Long)) 'Folder Missed Appt
                removeTicketFromFolder(lngTicketID, CType(10, Long)) ' Folder Ready for service
                removeTicketFromFolder(lngTicketID, CType(13, Long)) 'Folder Need appt set
                removeTicketFromFolder(lngTicketID, CType(16, Long)) 'Folder To be Dispatched
                removeTicketFromFolder(lngTicketID, CType(17, Long)) 'Folder FistContact
                removeTicketFromFolder(lngTicketID, CType(18, Long)) 'Folder Has Parts
                removeTicketFromFolder(lngTicketID, CType(20, Long)) 'Folder Labor Only
                removeTicketFromFolder(lngTicketID, CType(23, Long)) 'Folder Need Update
                removeTicketFromFolder(lngTicketID, CType(24, Long)) 'Folder New Notes
                removeTicketFromFolder(lngTicketID, CType(25, Long)) 'Folder Need Tech
                removeTicketFromFolder(lngTicketID, CType(26, Long)) 'Folder Phone support
                removeTicketFromFolder(lngTicketID, CType(29, Long)) 'Folder Ordering parts
                'removeTicketFromFolder(lngTicketID, CType(30, Long)) 'Folder Need Customer Feedback
                removeTicketFromFolder(lngTicketID, CType(31, Long)) 'Folder Part on Backorder
                removeTicketFromFolder(lngTicketID, CType(32, Long)) 'Folder Part on Backorder
                removeTicketFromFolder(lngTicketID, CType(33, Long)) 'Folder Need Appt set

        End Select

    End Sub
    Private Sub removeTicketFromFolder(ByVal lngTicketID As Long, ByVal lngFolderID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spRemoveTicketFromFolder")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cnn.Open()
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
        Return IsTicketOpened
    End Function
    Private Sub DeleteScheduleAssignment(ByVal lngTicketID As Long)
  
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spDeleteScheduleAssignmentByTicketID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
   
    End Sub
    
    Private Sub AssignWorkOrder()
        Dim dblMin As Double = 0
        Dim dblMax As Double = 0
        Dim dblRate As Double = 0
        Dim dblAdjust As Double = 0
        Dim strTrash As String = ""
        
        dblMin = 0
        dblMax = 0
        dblRate = 0
        dblAdjust = 0
       
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(_TicketID)
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(_PartnerAgentID)
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Add(Master.UserID, 1, tkt.ServiceID, tkt.TicketID, 1, dblMin, dblMax, dblRate, dblAdjust)
        wrk.PartnerID = par.PartnerID
        wrk.PartnerAgentID = par.PartnerAgentID
        _WorkOrderID = wrk.WorkOrderID
        Dim pan As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        pan.Load(par.PartnerID)
        Dim strChangeLog As String
        strChangeLog = ""
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto Note: New Work Order has been assigned to this ticket - via closing status: Partner ID - : " & pan.ResumeID)
        tnt.CustomerVisible = False
        tnt.Acknowledged = False
        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        tnt.Save(strChangeLog)
    
        ''Production -  Assigned Tech to Ticket
        'Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'plog.Add(Master.WebLoginID, Now(), 16, "New Work Order has been assigned to this ticket " & _ID & " - PartnerID: " & pan.ResumeID)
        
        
        tkt.ScheduledDate = Nothing
        tkt.ScheduledEndDate = Nothing
       
    
        
        wrk.PartnerAddressID = _PartnerAddressID
       
       
        AssignComponents(wrk.WorkOrderID)
       
        
        tkt.Save(strChangeLog)
        wrk.Save(strTrash)
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
    Private Sub LoadWorkOrders()
    Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListWorkOrders", "@TicketID", _TicketID, dgvWorkOrders)
    
  End Sub
    
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div id="divNotFound" visible="false" runat="server">
      <div style="Text-align: center">Work Order Not Found.</div> 
    </div>
    <div class="inputform" id="divCloseForm" visible="false" runat="server" style="padding-left: 3px; width: 620px">
    <div class="inputformsectionheader">Work Order Information</div>
    <table style="width:100%">
      <tbody>
        <tr>
          <td>
            <table width ="100%">
              <tbody>
                <tr>
                  <td class="label">Ticket ID</td>
                  <td><a target="_blank" id="lnkTicket" runat="server"><asp:Label ID="lblTicketID" runat="server" /></a></td>
                  <td rowspan="2" class="label">End User</td>
                  <td rowspan="2">
                    <div><asp:Label ID="lblContact" runat="server" /></div>
                    <div><a target="_blank" id="lnkMapIt" runat="server"><asp:Label ID="lblAddress" runat="server" /></a></div>
                  </td>                 
                </tr>
                <tr>
                  <td class="label">Work Order ID</td>
                  <td colspan="3"><a target="_blank" id="lnkWorkOrder" runat="server"><asp:Label ID="lblWorkOrderID" runat="server" /></a></td>                  
                </tr>
              </tbody>
            </table>          
          </td>
          <td><div>Technician:<br><asp:TextBox ID="txtTechnician" runat="server" ReadOnly= "True"/></div>
          </td>
          <td style="width: 80px;">
            <table width="100%">
              <tbody>
                <tr>
                  <td class="label">Local Time</td>
                </tr>
                <tr>
                  <td><div class="clock"><asp:Label ID="lblLocalTime" runat="server" /></div></td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      </tbody>
    </table >     
     <table style="width:100%">     
       <tbody>
         <tr>
          <td >
             <div class="inputformsectionheader">Description Of Work&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Closing Questions</div>
             <div style="padding-right: 5px"><asp:TextBox runat="server" ID="txtNotes" TextMode="multiLine" ReadOnly="true" style="width: 50%; height: 80px;"/>&nbsp;<asp:TextBox runat="server" ID="txtQuestions" TextMode="multiLine" ReadOnly="true" style="width: 47%; height: 80px;"/></div>
             <div>&nbsp;</div>
             <div class="inputformsectionheader">Work Orders</div>
             <asp:DataGrid ID="dgvWorkOrders" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false" CssClass="Grid1">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />
                <Columns>
                  <asp:BoundColumn HeaderText="WorkOrderID" DataField="WorkOrderID" Visible="True" />
                  <asp:BoundColumn HeaderText="Status" DataField="WorkOrderStatus" />
                </Columns>      
              </asp:DataGrid>
              <div>&nbsp;</div>
              <table style="width: 100%">
                <tbody>
                   <tr>
                      <td class="inputformsectionheader">Ticket Status</td>
                      <td class="inputformsectionheader">Work Order Status</td>
                   </tr>
                   <tr>
                      <td><asp:DropDownList ID="drpTicketStatus" runat="server" style="width: 100%" /></td>
                      <td><asp:DropDownList ID="drpWorkOrderStatus" runat="server" style="width: 100%" /></td>
                   </tr>
                   <tr>
                      <td>
                          <div class="inputformsectionheader">Times and Support</div>
                          <table style="width: 100%">
                             <tbody>
                                  <tr>
                                      <td class="label width: 1%">Arrived&nbsp;On&nbsp;Site*</td>
                                      <td style="padding-right: 3px;"><asp:TextBox MaxLength="10" style="width: 80px; text-align: center;" ID="txtArrived" runat="server" />&nbsp;<asp:TextBox MaxLength="5" style="width: 40px; text-align: center;" ID="txtArrivedTime" runat="server" /></td>
                                  </tr>
                                  <tr>
                                      <td class="label">Departed&nbsp;From&nbsp;Site*</td>
                                      <td style="padding-right: 3px;"><asp:TextBox MaxLength="10" style="width: 80px; text-align: center;" ID="txtDeparted" runat="server" />&nbsp;<asp:TextBox MaxLength="5" style="width: 40px; text-align: center;" ID="txtDepartedTime" runat="server" /></td>
                                  </tr>
                                  <tr>
                                      <td class="label">Travel&nbsp;Time*</td>
                                      <td style="padding-right: 3px;"><asp:TextBox style="width: 100%; text-align: right;" ID="txtTravelTime" runat="server" /></td>
                                  </tr>
                                  <tr>
                                      <td class="label">Mileage*</td>
                                      <td style="padding-right: 3px;"><asp:TextBox style="width: 100%; text-align: right;" ID="txtMileageStart" runat="server" /></td>
                                  </tr>
                                  <tr>
                                      <td class="label"></td>
                                      <td style="padding-right: 3px;"><asp:TextBox style="width: 100%; text-align: right;" ID="txtMileageEnd" runat="server" visible="false"/></td>
                                  </tr>
                                  <tr>
                                      <td class="label">Time&nbsp;On&nbsp;Hold*</td>
                                      <td style="padding-right: 3px;"><asp:TextBox style="width: 100%; text-align: right;" ID="txtTimeOnHold" runat="server" /></td>
                                  </tr>
                                  <tr>
                                      <td class="label">Technical Support&nbsp;Agent</td>
                                      <td style="padding-right: 3px;"><asp:TextBox style="width: 100%" ID="txtTechSupportAgent" runat="server" /></td>
                                  </tr>          
                              </tbody>
                          </table>
                          <div style="font-style: italic;">Please use <a target="_blank" href="24hourreference.aspx">24 hour time</a> when entering times.</div>
                          <div class="inputformsectionheader">Work Piece</div>
                          <table style="width: 100%">
                              <tbody>
                                  <tr>
                                      <td class="label">Manufacturer</td>
                                      <td style="padding-right: 3px;"><asp:TextBox style="width: 100%" ID="txtManufacturer" runat="server" /></td>
                                  </tr>          
                                  <tr>
                                      <td class="label">Model</td>
                                      <td style="padding-right: 3px;"><asp:TextBox style="width: 100%" ID="txtModel" runat="server" /></td>
                                  </tr>          
                                  <tr>
                                      <td class="label">Serial Number</td>
                                      <td style="padding-right: 3px;"><asp:TextBox style="width: 100%" ID="txtSerialNumber" runat="server" /></td>
                                  </tr>          
                                  <tr>
                                      <td class="label">Purchase Date</td>
                                      <td style="padding-right: 3px"><asp:TextBox style="width: 100%;" ID="txtPurchaseDate" runat="server" /></td>
                                  </tr>
                                  <tr>
                                      <td class="label">Parts Need Returned</td>
                                      <td style="padding-right: 3px"><asp:CheckBox ID="ChkPartReturn" runat="server" Text="Return Parts" /></td>
                                  </tr>
                              </tbody>
                          </table>
                       </td>
                       <td>        
                           <div class="inputformsectionheader">Resolution</div>
                           <div style="padding-right: 3px;"><asp:TextBox ID="txtResolutionNote" runat="server" TextMode="multiLine" style="width: 100%; height: 250px;" /></div>
                           <div style="text-align: right;"><asp:CheckBox ID="chkClosedFromSite" runat="server" Text="Closed From Site" />&nbsp;<asp:CheckBox ID="chkResolved" runat="server" Text="Resolved" /></div>
                           <div class="inputformsectionheader">Survey</div>
                           <asp:CheckBox  ID="chkSurveyAuthorized" runat="server" Text="Survey&nbsp;Authorized" />
                           <div class="label">Survey Email Address</div>
                           <div style="padding-right: 3px;"><asp:TextBox ID="txtSurveyEmail" runat="server" style="width:100%" /></div>
                       </td>
                    </tr>
                  </tbody>
               </table>   
            </td>          
         </tr>
      </tbody>
    </table> </div>
    <table style="width:100%">
      <tbody>
        <tr>
          <td>
              <div class="inputformsectionheader">Components/Parts</div>
              <asp:DataGrid ID="dgvComponents" runat="server" AutoGenerateColumns="false" style="width: 100%; background-color: White;" CssClass ="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />
              <Columns>      
                <asp:BoundColumn DataField="TicketComponentID" Visible="false" />
                <asp:TemplateColumn HeaderText="Command">
                  <ItemTemplate>
                    <a href="editcomponent.aspx?id=<%# Databinder.eval(Container.DataItem,"TicketComponentID") %>&returnurl=ticket.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>">Edit</a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="Code" HeaderText="Code/SKU" />
                <asp:BoundColumn DataField="Component" HeaderText="Component Name" />
                <asp:BoundColumn DataField="Consumable" HeaderText="Consumable" />
                <asp:TemplateColumn HeaderText="Shipping Labels">
                  <ItemTemplate>
                    <asp:DataGrid ID="dgvLabels" style="width: 100%; background-color: White;" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                      <HeaderStyle CssClass="gridheader" />
                      <AlternatingItemStyle CssClass="altrow" />
                      <Columns>
                        <asp:BoundColumn DataField="ShippingLabelID" Visible="false" />
                        <asp:BoundColumn HeaderText="Courier" DataField="Courier" />
                        <asp:BoundColumn DataField="Destination" HeaderText="Destination" />
                        <asp:BoundColumn HeaderText="Method" DataField="Method" />
                        <asp:TemplateColumn HeaderText="Label">
                          <ItemTemplate>
                            <a target="_blank" href="<%# Databinder.eval(Container.DataItem,"TrackingScript").ToString.Replace("$shippinglabel",DataBinder.Eval(Container.DataItem,"ShippingLabel")) %>"><%# DataBinder.Eval(Container.DataItem,"ShippingLabel") %></a>                    
                          </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:TemplateColumn>
                          <ItemTemplate>
                            <a href="editshippinglabel.aspx?id=<%# Databinder.eval(container.dataitem,"ShippingLabelID") %>&returnurl=ticket.aspx%3fid=<%# CurrentID %>">Edit</a>
                          </ItemTemplate>
                        </asp:TemplateColumn>
                      </Columns>
                    </asp:DataGrid>
                    <div style="text-align: right;"><a href="addshippinglabel.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketComponentID") %>&returnurl=ticket.aspx%3fid=<%# Databinder.Eval(Container.DataItem,"TicketID") %>">[Add Shipping Label]</a></div>
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>
            </asp:DataGrid>
           </td>
         </tr>
        </tbody>
      </table>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
    <div style="text-align: right;" class="inputform"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOk" runat="server" Text="Ok" OnClick="btnOK_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>