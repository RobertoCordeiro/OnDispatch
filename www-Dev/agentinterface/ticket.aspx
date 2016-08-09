<%@ Page Language="vb" masterpagefile="~/masters/agent.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ID As Long = 0
  Private _IsInvoiced as boolean = 0
    Private mListPartsTotal As Double
    Private _mnu As Long = 0
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
        End Try
        
        Try
            _mnu = CType(Request.QueryString("mnu"), Long)
        Catch ex As Exception
            _mnu = 0
        End Try
        
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If User.Identity.IsAuthenticated Then      
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " View Ticket"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " View Ticket"
    End If
    If _ID > 0 Then
      If Not IsPostBack Then
                menu.Items(_mnu).Selected = True
                Multiview1.ActiveViewIndex = _mnu
                LoadTicket()
                Master.PageHeaderText = _ID
                Master.PageTitleText = _ID
                LoadSearchFields()
                LoadTicketFolders()
                LoadBlackBookIssues()
      else
                menu.Items(_mnu).Selected = True
                Multiview1.ActiveViewIndex = _mnu
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadReferenceLabels(ByVal lngID As Long)
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cst.Load(lngID)
    If cst.Ref1Label.Trim.Length > 0 Then
      lblRef1Label.Text = cst.Ref1Label
    Else
      lblRef1Label.Text = "Reference # 1"
    End If
    If cst.Ref2Label.Trim.Length > 0 Then
      lblRef2Label.Text = cst.Ref2Label
    Else
      lblRef2Label.Text = "Reference # 2"
    End If
    If cst.Ref3Label.Trim.Length > 0 Then
      lblRef3Label.Text = cst.Ref3Label
    Else
      lblRef3Label.Text = "Reference # 3"
    End If
    If cst.Ref4Label.Trim.Length > 0 Then
      lblRef4Label.Text = cst.Ref4Label
    Else
      lblRef4Label.Text = "Reference # 4"
    End If
  End Sub
  
  Private Function MapIt(ByVal strAddress As String, ByVal strZipCode As String) As String
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
        strReturn = ggl.MapAddress(strAddress, strZipCode)
        
       
        
    Return strReturn
  End Function
  
  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim tst As New BridgesInterface.TicketStatusRecord(tkt.ConnectionString)
    Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
    Dim svt As New BridgesInterface.ServiceTypeRecord(tkt.ConnectionString)
    Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
    Dim zip As New BridgesInterface.ZipCodeRecord(tkt.ConnectionString)
        Dim wtm As New BridgesInterface.WarrantyTermRecord(tkt.ConnectionString)
        Dim agt As New BridgesInterface.UserRecord(tkt.ConnectionString)
    Dim strBlankDateSpacer As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    Dim datNothing As Date = Nothing
    Dim strHtml As String = ""    
    tkt.Load(_ID)
    LoadReferenceLabels(tkt.CustomerID)
    tst.Load(tkt.TicketStatusID)
    stt.Load(tkt.StateID)
    srv.Load(tkt.ServiceID)
    svt.Load(srv.ServiceTypeID)
    wtm.Load(tkt.WarrantyTermID)
    zip.Load(tkt.ZipCode)
    If zip.ZipCodeID > 0 Then
      lblLocalTime.Text = zip.LocalTime.Hour.ToString("00") & ":" & zip.LocalTime.Minute.ToString("00")
    Else
      lblLocalTime.Text = DateTime.Now.Hour.ToString("00") & ":" & DateTime.Now.Minute.ToString("00")
    End If
    Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; "
        'Master.PageSubHeader &= "<a href=""tickets.aspx"">Ticket Management</a> &gt; Ticket "
    If lblReturnUrl.Text.Trim.Length = 0 Then
      lblReturnUrl.Text = "customer.aspx?id=" & tkt.CustomerID
    End If
        'if tkt.CompletedDate = datNothing then
        'lnkAppt.HRef = "editticketappointment.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
        'end if
        If tkt.WorkOrderCount = 0 Then
            If tkt.CompletedDate = datNothing Then
                divCancel.Visible = True
                lnkCancel.HRef = "cancelticket.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
            Else
                divCancel.Visible = False
            End If
        Else
       
            divCancel.Visible = False
            
        End If
        lnkPayment.HRef = "PaymentLink.aspx"
        lnkMapIt.HRef = MapIt(tkt.Street, tkt.ZipCode)
        divInitialContact.Visible = tkt.InitialContact = datNothing
        lnkInitialContact.HRef = "initialcontact.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
        if tkt.InitialContact = datNothing then
        btnsendemail.Visible = False
        else
        btnsendemail.Visible = true
        end if
        imgPostNet.ImageUrl = "barcode.aspx?value=" & tkt.ZipCode & "&height=5&type=PostNet"
        imgPriority.ImageUrl = "/graphics/level" & tkt.CustomerPrioritySetting & ".png"
        lblPriority.Text = tkt.CustomerPrioritySetting
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
        strHtml &= "<div>" & tkt.City & " " & stt.Abbreviation & " " & tkt.ZipCode
        lblAddress.Text = strHtml
        lblCountyName.Text = zip.CountyName 
        lblLocationName.Text = GetLocation(tkt.ZipCode)
        LoadPhoneNumbers()
    
        'If tkt.CompletedDate = datNothing Then
        'lnkAssignWorkOrder.HRef = "assignworkorder.aspx?id=" & tkt.TicketID
        'End If
    
        txtDescription.Text = tkt.Description.Replace("<br />", Environment.NewLine)
        txtNotes.Text = tkt.Notes.Replace("<br />", Environment.NewLine)
        lblTicketID.Text = tkt.TicketID
        lblStatus.Text = tst.Status
        lblDateCreated.Text = tkt.DateCreated.ToString
        If tkt.ReferenceNumber1.Trim.Length > 0 Then
            lblRef1.Text = tkt.ReferenceNumber1
        Else
            lblRef1.Text = "&nbsp;"
        End If
        If tkt.ReferenceNumber2.Trim.Length > 0 Then
            lblRef2.Text = tkt.ReferenceNumber2
        Else
            lblRef2.Text = "&nbsp;"
        End If
        If tkt.ReferenceNumber3.Trim.Length > 0 Then
            lblRef3.Text = tkt.ReferenceNumber3
        Else
            lblRef3.Text = "&nbsp;"
        End If
        If tkt.ReferenceNumber4.Trim.Length > 0 Then
            lblRef4.Text = tkt.ReferenceNumber4
        Else
            lblRef4.Text = "&nbsp;"
        End If
        lblRequestedStartDate.Text = tkt.RequestedStartDate
        lblRequestedEndDate.Text = tkt.RequestedEndDate
        lblServiceType.Text = svt.ServiceType
        lblService.Text = "<a target=""_blank"" href=""servicedetail.aspx?id=" & srv.ServiceID & """>" & srv.ServiceName & "</a>"
        lblManufacturer.Text = tkt.Manufacturer
        lblModel.Text = "<a target=""_blank"" href=""Manuals.aspx?id=" & tkt.Model & """>" & tkt.Model.ToUpper  & "</a>"
        lblSerialNumber.Text = tkt.SerialNumber.ToUpper
        
        'Getting LG serial number date
        If tkt.CustomerID = 32 Then
            
            Dim strTemp1 As String
            Dim strTemp3 As String
            Dim strTemp4 As String
            Dim thisyear As Integer
            Dim lastyear As Integer
            Dim strSerialYear As String
            If Len(lblSerialNumber.Text) = 12 Then
                strTemp1 = Left(tkt.SerialNumber, 3)
                strTemp3 = Left(tkt.SerialNumber, 1) ' year
                strTemp4 = Right(strTemp1, 2) 'month
                strSerialYear = "????"
                If IsNumeric(strTemp3) Then
                    thisyear = Year(DateAndTime.Today)
                    lastyear = thisyear - 1
                    
                    Select Case Int(Left(thisyear, 3) & strTemp3)
                        Case Is = thisyear
                            strSerialYear = thisyear
                        Case Is > thisyear
                            strSerialYear = Int(Left(thisyear, 3) & strTemp3) - 10
                        Case Is < thisyear
                            strSerialYear = Int(Left(thisyear, 3) & strTemp3)
                            
                    End Select
                   
                End If
                
                Select Case strTemp4
                    Case Is = "01"
                        lblWeekDay.Text = "JAN 1," & strSerialYear
                    Case Is = "02"
                        lblWeekDay.Text = "FEB 1," & strSerialYear
                    Case Is = "03"
                        lblWeekDay.Text = "MAR 1," & strSerialYear
                    Case Is = "04"
                        lblWeekDay.Text = "APR " & strSerialYear
                    Case Is = "05"
                        lblWeekDay.Text = "MAY 1," & strSerialYear
                    Case Is = "06"
                        lblWeekDay.Text = "JUN 1," & strSerialYear
                    Case Is = "07"
                        lblWeekDay.Text = "JUL 1," & strSerialYear
                    Case Is = "08"
                        lblWeekDay.Text = "AUG 1," & strSerialYear
                    Case Is = "09"
                        lblWeekDay.Text = "SEP 1," & strSerialYear
                    Case Is = "10"
                        lblWeekDay.Text = "OCT 1," & strSerialYear
                    Case Is = "11"
                        lblWeekDay.Text = "NOV 1," & strSerialYear
                    Case Is = "12"
                        lblWeekDay.Text = "DEC 1," & strSerialYear
                End Select
                If IsDate(tkt.PurchaseDate) Then
                    If DateDiff(DateInterval.Day, CDate(lblWeekDay.Text), CDate(tkt.DateCreated)) > 365 Then
                        lblWeekDay.Text = "[" & lblWeekDay.Text & "]" & " ** Need POP **"
                    Else
                        lblWeekDay.Text = "[" & lblWeekDay.Text & "]"
                    End If
                Else
                    lblWeekDay.Text = "[" & lblWeekDay.Text & "]" & " ** Need POP **"
                End If
            Else
                lblWeekDay.Text = "[????]- Need 12 Digits"
                
            End If
            
        End If
        'Getting electrolux serial number dates
        If tkt.CustomerID = 53 Then
            Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim intWeek As Integer
            Dim intYear As Integer
            Dim strTemp As String
            Dim strTemp2 As String
            If Len(lblSerialNumber.Text) = 10 Then
                strTemp = Left(tkt.SerialNumber, 5)
                strTemp = Right(strTemp, 3)
                strTemp2 = Left(strTemp, 1)
                If IsNumeric(strTemp2) Then
                    intYear = CType(strTemp2, Integer)
                Else
                    intYear = 0
                End If
                strTemp = Right(strTemp, 2)
                If IsNumeric(strTemp) Then
                    intWeek = CType(strTemp, Integer)
                Else
                    intWeek = 0
                End If
                If intWeek <> 0 Or intYear <> 0 Then
                    lblWeekDay.Text = ldr.FirstDateOfWeek(intYear, intWeek)
                End If
                If IsDate(tkt.PurchaseDate) Then
                    If DateDiff(DateInterval.Day, CDate(lblWeekDay.Text), CDate(tkt.DateCreated)) > 365 Then
                        lblWeekDay.Text = "[" & lblWeekDay.Text & "]" & " ** Need POP **"
                    Else
                        lblWeekDay.Text = "[" & lblWeekDay.Text & "]"
                    End If
                Else
                    lblWeekDay.Text = "[" & lblWeekDay.Text & "]" & " ** Need POP **"
                End If
            Else
                lblWeekDay.Text = "[?????]- Need 10 Digits"
            End If
        End If
        'Get GE serial number dates
        If tkt.CustomerID = 54 Then
            'Getting Month from GE serial number
            If Len(lblSerialNumber.Text) = 9 Then
                Select Case Left(tkt.SerialNumber, 1)
                    Case Is = "A"
                        lblWeekDay.Text = "JAN 1,"
                    Case Is = "D"
                        lblWeekDay.Text = "FEB 1,"
                    Case Is = "F"
                        lblWeekDay.Text = "MAR 1,"
                    Case Is = "G"
                        lblWeekDay.Text = "APR 1,"
                    Case Is = "H"
                        lblWeekDay.Text = "MAY 1,"
                    Case Is = "L"
                        lblWeekDay.Text = "JUN 1,"
                    Case Is = "M"
                        lblWeekDay.Text = "JUL 1,"
                    Case Is = "R"
                        lblWeekDay.Text = "AUG 1,"
                    Case Is = "S"
                        lblWeekDay.Text = "SEP 1,"
                    Case Is = "T"
                        lblWeekDay.Text = "OCT 1,"
                    Case Is = "V"
                        lblWeekDay.Text = "NOV 1,"
                    Case Is = "Z"
                        lblWeekDay.Text = "DEC 1,"
                    
                End Select
                'Getting year from GE serial number
                Dim strTemp3 As String
                strTemp3 = Left(tkt.SerialNumber, 2)
                strTemp3 = Right(strTemp3, 1)
                Select Case strTemp3
                    Case Is = "A"
                        lblWeekDay.Text = lblWeekDay.Text & " 2013"
                    Case Is = "D"
                        lblWeekDay.Text = lblWeekDay.Text & " 2014"
                    Case Is = "F"
                        lblWeekDay.Text = lblWeekDay.Text & " 2015"
                    Case Is = "G"
                        lblWeekDay.Text = lblWeekDay.Text & " 2016"
                    Case Is = "H"
                        lblWeekDay.Text = lblWeekDay.Text & " 2017"
                    Case Is = "L"
                        lblWeekDay.Text = lblWeekDay.Text & " 2006"
                    Case Is = "M"
                        lblWeekDay.Text = lblWeekDay.Text & " 2007"
                    Case Is = "R"
                        lblWeekDay.Text = lblWeekDay.Text & " 2008"
                    Case Is = "S"
                        lblWeekDay.Text = lblWeekDay.Text & " 2009"
                    Case Is = "T"
                        lblWeekDay.Text = lblWeekDay.Text & " 2010"
                    Case Is = "V"
                        lblWeekDay.Text = lblWeekDay.Text & " 2011"
                    Case Is = "Z"
                        lblWeekDay.Text = lblWeekDay.Text & " 2012"
                    
                End Select
                If IsDate(tkt.PurchaseDate) Then
                    If DateDiff(DateInterval.Day, CDate(lblWeekDay.Text), CDate(tkt.DateCreated)) > 365 Then
                        lblWeekDay.Text = "[" & lblWeekDay.Text & "]" & " ** Need POP **"
                    Else
                        lblWeekDay.Text = "[" & lblWeekDay.Text & "]"
                    End If
                Else
                    lblWeekDay.Text = "[" & lblWeekDay.Text & "]" & " ** Need POP **"
                End If
            Else
                lblWeekDay.Text = "[?????]- Need 9 Digits"
            End If
        End If
        
        
        If Not IsNothing(tkt.WarrantyStart) Then
            If tkt.WarrantyStart <> datNothing Then
                lblWarrantyStart.Text = tkt.WarrantyStart.ToString
            Else
                lblWarrantyStart.Text = strBlankDateSpacer
            End If
        Else
            lblWarrantyStart.Text = strBlankDateSpacer
        End If
        If Not IsNothing(tkt.WarrantyEnd) Then
            If tkt.WarrantyEnd <> datNothing Then
                lblWarrantyEnd.Text = tkt.WarrantyEnd.ToString
            Else
                lblWarrantyEnd.Text = strBlankDateSpacer
            End If
        Else
            lblWarrantyEnd.Text = strBlankDateSpacer
        End If
        If Not IsNothing(tkt.PurchaseDate) Then
            If tkt.PurchaseDate <> datNothing Then
                lblPurchaseDate.Text = FormatDateTime(tkt.PurchaseDate.ToString, DateFormat.ShortDate)
            Else
                lblPurchaseDate.Text = strBlankDateSpacer
            End If
        Else
            lblPurchaseDate.Text = strBlankDateSpacer
        End If
        If tkt.ScheduledDate <> datNothing Then
            lblScheduledDate.Text = tkt.ScheduledDate.ToString
        Else
            lblScheduledDate.Text = strBlankDateSpacer
        End If
        If tkt.ScheduledEndDate <> datNothing Then
            lblScheduledDateEnd.Text = tkt.ScheduledEndDate.ToString
        Else
            lblScheduledDateEnd.Text = strBlankDateSpacer
        End If
        If tkt.ServiceStartDate <> datNothing Then
            lblServiceStartDate.Text = tkt.ServiceStartDate.ToString
        Else
            lblServiceStartDate.Text = strBlankDateSpacer
        End If
        If tkt.ServiceEndDate <> datNothing Then
            lblServiceEndDate.Text = tkt.ServiceEndDate.ToString
        Else
            lblServiceEndDate.Text = strBlankDateSpacer
        End If
        If tkt.CompletedDate <> datNothing Then
            lblCompletedDate.Text = tkt.CompletedDate.ToString
        Else
            lblCompletedDate.Text = strBlankDateSpacer
        End If
        If tkt.AssignedTo <> 0 Or Not IsDBNull(tkt.AssignedTo) Then
            agt.Load(tkt.AssignedTo)
            lblSupportAgent.Text = agt.UserName
        Else
            lblSupportAgent.Text = strBlankDateSpacer
        End If
        lblWarrantyTerm.Text = wtm.Term
        LoadFolders()
        LoadComponents()
        LoadNotes()
        LoadWorkOrders()
        LoadPriorTickets(tkt.ReferenceNumber1, tkt.CustomerID, tkt.TicketID, tkt.ContactLastName, tkt.ZipCode)
        LoadSerialHistory(tkt.SerialNumber, tkt.CustomerID, tkt.TicketID)
        LoadAttachedDocuments(tkt.TicketID)
        lblAge.Text = DateDiff(DateInterval.Day, tkt.DateCreated, Now())
        If IsTicketOpen(tkt.TicketID) = True Then
            lnkPrintable.Target = "_blank"
            lnkPrintable.HRef = "printableticket.aspx?id=" & tkt.TicketID
            lnkTicketBilling.HRef = "ticketbilling.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
            lnkAddPhone.HRef = "addphone.aspx?id=" & tkt.TicketID & "&mode=ticket&returnurl=ticket.aspx%3fid=" & tkt.TicketID
            lnkAddComponent.HRef = "addcomponent.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
            lnkEditTicket.HRef = "editticket.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
            'lnkAppt.HRef = "editticketappointment.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
            lnkAssignComponents.HRef = "assignticketcomponents.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
            lnkAssignWorkOrder.HRef = "assignworkorder.aspx?id=" & tkt.TicketID
            divNewTicket.Visible = False
            btnSendEmail.Visible = True
        Else
            lnkPrintable.Target = "_blank"
            lnkPrintable.HRef = "printableticket.aspx?id=" & tkt.TicketID
            lnkAddPhone.HRef = "addphone.aspx?id=" & tkt.TicketID & "&mode=ticket&returnurl=ticket.aspx%3fid=" & tkt.TicketID
            btnSendEmail.Visible = False
            If Not IsDBNull(tkt.ScheduledEndDate) Then
                lblAge.Text = DateDiff(DateInterval.Day, tkt.DateCreated, tkt.ScheduledEndDate)
            Else
                If Not IsDBNull(tkt.CompletedDate) Then
                    lblAge.Text = DateDiff(DateInterval.Day, tkt.DateCreated, tkt.CompletedDate)
                Else
                    lblAge.Text = DateDiff(DateInterval.Day, tkt.DateCreated, Now())
                End If
            End If
            '1652 - rcordeiro
            '1654 - npalavesino
            '4659 - dparra
            '4833 - awilkin
            '5066 - Frederico
            '5056 - cpalanvesino
            '5152 - tbarrett
            '5219 - Gabriel
            '5227 - Keneasha
            
            If CType(User.Identity.Name, Long) = 1652 Or CType(User.Identity.Name, Long) = 1654 Then
                btnClearAppt.Visible = True
            Else
                btnClearAppt.Visible = False
            End If
            If IsTicketInvoiced(tkt.TicketID) = True Then
                If CType(User.Identity.Name, Long) = 1652 Or CType(User.Identity.Name, Long) = 1654 Or CType(User.Identity.Name, Long) = 4833 Or CType(User.Identity.Name, Long) = 5065 Or CType(User.Identity.Name, Long) = 5219 Or CType(User.Identity.Name, Long) = 5066 Then
                    lnkAddComponent.HRef = "addcomponent.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
                    lnkTicketBilling.HRef = "ticketbilling.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
                    lnkEditTicket.HRef = "editticket.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
                
                    'If tkt.TicketStatusID <> 9 Then
                    lnkAssignWorkOrder.HRef = "assignworkorder.aspx?id=" & tkt.TicketID
                    'End If
                
                    divNewTicket.Visible = True
                    lnkNewTicket.HRef = "addticket.aspx?id=" & tkt.CustomerID & "&infoID=" & Master.InfoID & "&tid=" & tkt.TicketID & "&mode=customer&returnurl=ticket.aspx?id=" & tkt.TicketID
                Else
                    lnkEditTicket.HRef = "editticket.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
                    divNewTicket.Visible = True
                    lnkNewTicket.HRef = "addticket.aspx?id=" & tkt.CustomerID & "&infoID=" & Master.InfoID & "&tid=" & tkt.TicketID & "&mode=customer&returnurl=ticket.aspx?id=" & tkt.TicketID
                End If
            Else
                If CType(User.Identity.Name, Long) = 5065 Or CType(User.Identity.Name, Long) = 1652 Or CType(User.Identity.Name, Long) = 1654 Or CType(User.Identity.Name, Long) = 5152 Or CType(User.Identity.Name, Long) = 5157 Or CType(User.Identity.Name, Long) = 5762 Or CType(User.Identity.Name, Long) = 5763 Or CType(User.Identity.Name, Long) = 5227 Or CType(User.Identity.Name, Long) = 4659 Or CType(User.Identity.Name, Long) = 5219 Or CType(User.Identity.Name, Long) = 5066 Then
                    lnkAddComponent.HRef = "addcomponent.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
                    lnkEditTicket.HRef = "editticket.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
                    lnkAssignWorkOrder.HRef = "assignworkorder.aspx?id=" & tkt.TicketID
                    divNewTicket.Visible = True
                    lnkNewTicket.HRef = "addticket.aspx?id=" & tkt.CustomerID & "&infoID=" & Master.InfoID & "&tid=" & tkt.TicketID & "&mode=customer&returnurl=ticket.aspx?id=" & tkt.TicketID
                End If
                If CType(User.Identity.Name, Long) = 1652 Or CType(User.Identity.Name, Long) = 1654 Or CType(User.Identity.Name, Long) = 5227 Or CType(User.Identity.Name, Long) = 5065 Or CType(User.Identity.Name, Long) = 5219 Then
                    lnkTicketBilling.HRef = "ticketbilling.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
                End If
            End If
        End If
        'if IsTicketInFolder(_ID, 30) > 0 Then
        'btnAssign.Enabled = False
            
        'If Master.UserID = 14 Or Master.UserID = 15 Or Master.UserID = 115 Then
        'btnAssign.Visible = False
        'btnRemove.Visible = True
        'End If
        'Else
        'btnAssign.Visible = True
        'btnRemove.Visible = False
        'End If
    End Sub
  
  Private Sub LoadComponents()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListTicketComponents", "@TicketID", _ID, dgvComponents)
    Dim dgv As System.Web.UI.WebControls.DataGrid
    For Each itm As System.Web.UI.WebControls.DataGridItem In dgvComponents.Items
      dgv = itm.FindControl("dgvLabels")
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spListTicketComponentShippingLabels", "@TicketComponentID", CType(itm.Cells(0).Text, Long), dgv)
      End If
    Next
  End Sub
  
  Private Sub LoadWorkOrders()
    Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListWorkOrders", "@TicketID", _ID, dgvWorkOrders)
        Dim btn As System.Web.UI.WebControls.ImageButton
        'Dim btn1 As System.Web.UI.WebControls.ImageButton
    Dim lbl As System.Web.UI.WebControls.Label
    Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("WOCnn"))
    Dim tec as New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim adr as New BridgesInterface.PartnerAddressRecord(system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
    Dim dgv1 As System.Web.UI.WebControls.DataGrid
    For Each itm As DataGridItem In dgvWorkOrders.Items
      
      wrk.Load(CType(itm.Cells(0).Text, Long))  
            '_isInvoiced = wrk.Invoiced    
            btn = itm.FindControl("btnWorkOrder")
            lbl = itm.FindControl("lblWorkOrderUploaded")
      If wrk.WorkOrderFileID > 0 Then
                btn.ImageUrl = "/graphics/enabledimageicon.png"
                btn.AlternateText = wrk.WorkOrderID
                
        fil.Load(wrk.WorkOrderFileID)
        lbl.Text = wrk.DateCreated
      Else
                btn.ImageUrl = "/graphics/disabledimageicon.png"
                btn.Enabled = False
              
                btn.AlternateText = wrk.WorkOrderID
      End If
      dgv1 = itm.FindControl ("dgvAddresses")
      LoadAddresses (wrk.PartnerAgentID,dgv1)
      dgv1 = itm.FindControl ("dgvAssociatedPhoneNumbers")
      LoadAgentPhoneNumbers(wrk.PartnerAgentID,dgv1)
      
      tec.Load(wrk.PartnerAgentID)
            If tec.ScheduleHisOwnAppt Then
                dgv1.Caption = tec.FirstName & " " & tec.LastName & " - *** Schedule His Own Appts ***"
            Else
                dgv1.Caption = tec.FirstName & " " & tec.LastName
            End If
            
            
        
      Next
  End Sub
  
  
  
    Private Sub btnWorkOrder_Click(ByVal S As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs)
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Load(CType(e.Item.Cells(0).Text, Long))
        If wrk.WorkOrderFileID > 0 Then
            Dim exp As New cvCommon.Export
            Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("WOCnn"))
            fil.Load(wrk.WorkOrderFileID)
            exp.BinaryFileOut(Response, fil, System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection"))
        End If
    End Sub
   
    Private Sub LoadNotes()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListTicketNotes", "@TicketID", _ID, dgvNotes)
        For Each itm As DataGridItem In dgvNotes.Items
            If Not CType(itm.Cells(1).Text, Boolean) Then
                itm.CssClass = "selectedbandbar"
            End If
        Next
    End Sub

    Private Sub btnAddNote_Click(ByVal S As Object, ByVal E As EventArgs)
        If IsNoteComplete() Then
            Dim strChangeLog As String = ""
            Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            tnt.Add(_ID, Master.WebLoginID, Master.UserID, txtTicketNote.Text)
            tnt.CustomerVisible = chkCustomerVisible.Checked
            tnt.PartnerVisible = chkPartnerVisible.Checked
            tnt.Acknowledged = True
            wbl.Load(Master.WebLoginID)
            If wbl.AccessCoding.Trim.ToLower = "a" Then
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
            Else
                If wbl.AccessCoding.Trim.ToLower = "e" Then
                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Employee
                End If
            End If
       
            tnt.Save(strChangeLog)
            txtTicketNote.Text = ""
            LoadTicket()
            chkPartnerVisible.Checked = False
            chkCustomerVisible.Checked = False
            
            'production
            Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            plog.Add(Master.WebLoginID, Now(), 14, "A Note has been entered into the ticket " & _ID)
        End If
    End Sub
  
    Private Sub btnClearAppt_Click(ByVal S As Object, ByVal E As EventArgs)
       
        Dim strChangeLog As String = ""
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(_ID)
        tkt.ScheduledDate = Nothing
        tkt.ScheduledEndDate = Nothing
        tkt.Save(strChangeLog)
        tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Auto Note: Appointment has been cleared so new one can be set.")
        tnt.CustomerVisible = False
        tnt.PartnerVisible = False
        tnt.Acknowledged = True
        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        tnt.Save(strChangeLog)
        LoadTicket()
        chkPartnerVisible.Checked = False
        chkCustomerVisible.Checked = False
        DeleteScheduleAssignment(_ID)
    End Sub
    
    Private Function IsNoteComplete() As Boolean
        Dim blnReturn As Boolean = True
        Dim strErrors As String = ""
        If txtTicketNote.Text.Trim.Length = 0 Then
            blnReturn = False
            strErrors &= "<li>Note must contain text</li>"
        End If
        divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
        Return blnReturn
    End Function
  
    Private Sub LoadFolders()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListFoldersTicketIsIn", "@TicketID", _ID, dgvFolders)
    End Sub
  
    Private Sub LoadPriorTickets(ByVal strCustomerNumber As String, ByVal lngCustomerID As Long, ByVal lngTicketID As Long,ByVal strLastName As String, ByVal strZipCode As string)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        'ldr.LoadLongStringParameterDataGrid("spGetPriorTickets", "@CustomerID", lngCustomerID, "@CustomerNumber", strCustomerNumber, dgvPriorTickets)
        ldr.LoadLongThreeStringParameterDataGrid ("spGetPriorTickets","@CustomerID",lngCustomerID,"@CustomerNumber",strCustomerNumber,"@LastName",strLastName,"@ZipCode", strZipCode,dgvPriorTickets)
    End Sub
    
    Private Sub LoadSerialHistory(ByVal strSerialNumber As String, ByVal lngCustomerID As Long, ByVal lngTicketID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If (strSerialNumber <> "") And (strSerialNumber <> "na") And (strSerialNumber <> "need") Then
         
            ldr.LoadLongStringParameterDataGrid("spGetPriorTicketsBySerial", "@CustomerID", lngCustomerID, "@SerialNumber", strSerialNumber, dgvPriorTicketsBySerial)
        End If
    End Sub
    
    Private Sub LoadAttachedDocuments(ByVal lngTicketID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSingleLongParameterDataGrid("spGetTicketDocuments", "@TicketID", lngTicketID, dgvAttachments)
    End Sub
  
    Private Sub LoadPhoneNumbers()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListTicketPhoneNumbers", "@TicketID", _ID, dgvPhoneNumbers)
    End Sub

    Private Function MergeTrackingScript(ByVal strTrackingScript As String, ByVal strShippingLabel As String) As String
        Dim strReturn As String = strTrackingScript.Replace("$shippinglabel", strShippingLabel)
        Return strReturn
    End Function

    Private Function CreateDispatchText(ByRef datDispatched As Object, ByVal lngWorkOrderID As Long) As String
        Dim strReturn As String = ""
        If Not IsDBNull(datDispatched) Then
            strReturn = datDispatched.ToString
        Else
            strReturn = "<a href=""Dispatchworkorder.aspx?id=" & lngWorkOrderID.ToString & "&returnurl=ticket.aspx%3fid=" & _ID.ToString & """>Dispatch</a>"
        End If
        Return strReturn
    End Function
  
    Private Function CurrentID() As Long
        Return _ID
    End Function
  
    Private Function TaskText(ByVal lngWorkOrderID As Long) As String
        Dim strReturn As String = ""
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Load(lngWorkOrderID)
        If wrk.ClosingAgent = 0 Then
            strReturn &= "<a href=""closeworkorder.aspx?id=" & lngWorkOrderID & "&returnurl=ticket.aspx%3fid=" & _ID & """>[Close]</a>"
        Else
            strReturn &= "&nbsp;"
        End If
        Return strReturn
    End Function
    
    
    
  
    Private Function UploadText(ByVal lngWorkOrderID As Long) As String
        Dim strReturn As String = ""
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Load(lngWorkOrderID)
        If wrk.ClosingAgent <> 0 Then
            strReturn &= "<a href=""upload.aspx?id=" & lngWorkOrderID & "&returnurl=ticket.aspx%3fid=" & _ID & "&mode=wo"">[Upload]</a>"
        Else
            strReturn &= "&nbsp;"
        End If
        Return strReturn
    End Function
    
    Private Function RemoveWo(ByVal lngWorkOrderID As Long) As String
        Dim strReturn As String = ""
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Load(lngWorkOrderID)
        If wrk.WorkOrderFileID > 0 Then
            'If Master.WebLoginID = 1652 then
              strReturn &= "<a href=""RemoveSignedWO.aspx?id=" & lngWorkOrderID & "&returnurl=ticket.aspx%3fid=" & _ID & "&mode=wo"">[Remove]</a>"
            'Else
              'strReturn &= "&nbsp;"
            'end if
        Else
            strReturn &= "&nbsp;"
        End If
        Return strReturn
    End Function
  
    Private Function ShipToText(ByVal lngWorkOrderID As Object) As String
        Dim lngID As Long = 0
        If Not IsDBNull(lngWorkOrderID) Then
            lngID = lngWorkOrderID
        Else
            lngID = 0
        End If
        Dim strReturn As String = ""
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Load(lngID)
        If wrk.WorkOrderID > 0 Then
            Dim pad As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            pad.Load(wrk.PartnerAddressID)
            strReturn = "<div>" & pad.Street & "</div>"
            If pad.Extended.Trim.Length > 0 Then
                strReturn &= "<div>" & pad.Extended & "</div>"
            End If
            Dim stt As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            stt.Load(pad.StateID)
            strReturn &= "<div>" & pad.City & ", " & stt.Abbreviation & ". " & pad.ZipCode & "</div>"
        End If
        Return strReturn
    End Function
  
    Private Function PartnerEmailAddress(ByRef lngPartnerID As Object) As String
        Dim strReturn As String = ""
        Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
        tkt.Load(_ID)
        stt.Load(tkt.StateID)
        If Not IsDBNull(lngPartnerID) Then
            ptr.Load(CType(lngPartnerID, Long))
            Dim strBody As String
            strBody = "TICKET INFORMATION: " & "%0D%0A"
            strBody = strBody & "Customer Name: " & tkt.ContactFirstName & " " & tkt.ContactLastName & "%0D%0A"
            strBody = strBody & "Address: " & tkt.Street & "%0D%0A"
            strBody = strBody & "City,State,Zip: " & tkt.City & "  " & stt.Abbreviation & ", " & tkt.ZipCode & "%0D%0A"
            strBody = strBody & "CustomerNumber: " & tkt.ReferenceNumber1 & "%0D%0A"
            strBody = strBody & "Authorization Number: " & tkt.ReferenceNumber2 & "%0D%0A"
            strBody = strBody & "Type: " & tkt.Manufacturer & "%0D%0A"
            strBody = strBody & "Model Number: " & tkt.Model & "%0D%0A"
            strBody = strBody & "Serial Number: " & tkt.SerialNumber & "%0D%0A"

            strReturn = "<a href=""mailto:" & ptr.Email & "?Subject= " & tkt.TicketID & " / " & tkt.ContactFirstName & " " & tkt.ContactLastName & " / " & tkt.ReferenceNumber2 & "&body= " & strBody & """>[Email]</a>"
        Else
            strReturn = "&nbsp;"
        End If
        Return strReturn
    End Function
  

  
    Private Sub btnJump_Click(ByVal S As Object, ByVal E As EventArgs)
        If txtCriteria.Text.Trim.Length > 0 Then
            divJumpToError.Visible = False
            'production
            Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            plog.Add(Master.WebLoginID, Now(), 14, "Info Lookup: " & txtCriteria.Text.Trim & "(" & drpFields.SelectedValue & ")")
                     
            Response.Redirect("findticket.aspx?cid=0&crit=" & txtCriteria.Text.Trim & "&in=" & drpFields.SelectedValue)
            
           
        Else
            divJumpToError.InnerHtml = "Criteria Can Not Be Blank"
            divJumpToError.Visible = True
        End If
        Dim lng As Long = 0
    End Sub
  
    Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect("TicketDocumentsUpload.aspx?fid=0" & "&id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID & "&mode=doc&updt=0")
    End Sub
    
    Private Function CreateItem(ByVal strValue As String, ByVal strText As String) As System.Web.UI.WebControls.ListItem
        Dim itmReturn As New System.Web.UI.WebControls.ListItem(strText, strValue)
        Return itmReturn
    End Function
    Private Sub LoadSearchFields()
        With drpFields.Items
            .Clear()
            .Add(CreateItem("ticketid", "Ticket ID"))
            .Add(CreateItem("workorderid", "Work Order ID"))
            .Add(CreateItem("phone", "Phone Number"))
            .Add(CreateItem("lastname", "Last Name"))
            .Add(CreateItem("label", "Shipping Label"))
            .Add(CreateItem("city", "City"))
            .Add(CreateItem("state", "State"))
            .Add(CreateItem("zip", "Zip Code"))
            .Add(CreateItem("serial", "Serial Number"))
            .Add(CreateItem("ref1", "Reference 1"))
            .Add(CreateItem("ref2", "Reference 2"))
            .Add(CreateItem("ref3", "Reference 3"))
            .Add(CreateItem("ref4", "Reference 4"))
            .Add(CreateItem("serialnumber", "Part Invoice"))
            .Add(CreateItem("RMA", "RMA Number"))
        End With
    End Sub
    Private Function IsTicketOpen(ByVal lngTicketID As Long) As Boolean
    
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsTicketOpen")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            IsTicketOpen = dtr("Result")
        End While
        cnn.Close()
        Return IsTicketOpen
    End Function
    
    Private Function IsTicketInvoiced(ByVal lngTicketID As Long) As Boolean
    
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsTicketInvoiced")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            IsTicketInvoiced = dtr("Result")
        End While
        cnn.Close()
        Return IsTicketInvoiced
    End Function
    
    
    Private Sub Item_Click(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs)
        Dim strTest As String
        
        strTest = (CType(e.CommandSource, LinkButton)).CommandName
        Select Case (CType(e.CommandSource, LinkButton)).CommandName
            
            Case "View"
                Dim exp As New cvCommon.Export
                Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("WOCnn"))
                Dim lngID As Long
                
                lngID = CType(e.Item.Cells(2).Text, Long)
                strTest = e.Item.Cells(2).Text
                fil.Load(lngID)
                exp.BinaryFileOut(Response, fil, System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection"))
            Case "Update"
                Dim lngFileID As Long
                lngFileID = CType(e.Item.Cells(2).Text, Long)
                Response.Redirect("TicketDocumentsUpload.aspx?fid=" & CType(e.Item.Cells(0).Text, Long) & "&id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID & "&mode=doce&updt=" & lngFileID)

            Case "Remove"

                Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("WOCnn"))
                Dim tkd As New BridgesInterface.TicketDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim lngFilID As Long
                Dim DocID As Long
                DocID = CType(e.Item.Cells(0).Text, Long)
                lngFilID = CType(e.Item.Cells(2).Text, Long)
                tkd.Load(DocID)
                fil.Load(lngFilID)
                fil.Delete()
                tkd.Delete()
                Dim strChangelog As String = ""
                Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Auto Note: Attachment has been removed from this ticket: " & e.Item.Cells(1).Text)
                tnt.CustomerVisible = False
                tnt.PartnerVisible = False
                tnt.Acknowledged = True
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Save(strChangelog)
                Response.Redirect("Ticket.aspx?id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID)

        End Select
    End Sub
    
    Private Sub LoadAddresses(ByVal lngPartnerAgentID As Long, ByVal dgv As System.Web.UI.WebControls.DataGrid)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadSingleLongParameterDataGrid("spListPartnerAddresses", "@PartnerID", _ID, dgvAddresses)
    
        'For Each itm As System.Web.UI.WebControls.DataGridItem In dgvWorkOrders.Items
        '  dgv = itm.FindControl("dgvAddresses")
        If Not IsNothing(dgv) Then
            'ldr.LoadSingleLongParameterDataGrid("spListTicketComponentShippingLabels", "@TicketComponentID", CType(itm.Cells(0).Text, Long), dgv)
            ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentShippingAddresses", "@PartnerAgentID", lngPartnerAgentID, dgv)
        End If
        'Next
    End Sub
    Private Sub LoadAgentPhoneNumbers(ByVal lngPartnerAgentID As Long, ByVal dgv As System.Web.UI.WebControls.DataGrid)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
    
        'For Each itm As System.Web.UI.WebControls.DataGridItem In dgvWorkOrders.Items
        'dgv = itm.FindControl("dgvAssociatedPhoneNumbers")
        If Not IsNothing(dgv) Then
            ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentBusinessPhoneNumber", "@PartnerAgentID", lngPartnerAgentID, dgv)
            'ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentShippingAddresses", "@PartnerAgentID", lngPartnerAgentID, dgv)
        End If
        ' Next
    End Sub
  
    Private Sub btnSendEmail_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(_ID)
        cst.Load(tkt.CustomerID)
        Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        doc.Load(9)
        Dim strBody As String = doc.DocumentText
        strBody = strBody.Replace("$firstname", tkt.ContactFirstName)
        strBody = strBody.Replace("$lastname", tkt.ContactLastName)
        strBody = strBody.Replace("$UnitType", tkt.Manufacturer)
        strBody = strBody.Replace("$TicketID", _ID)
        eml.Subject = "Important information regarding your repair"
        eml.SendTo = tkt.Email
        eml.SendFrom = "welcome@bestservicers.com"
        eml.BCC = "welcome@bestservicers.com"
        eml.Body = strBody
        eml.HTMLBody = True
        eml.Send()

        Dim strChangeLog As String = ""
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto message: Welcome letter sent to customer")
        tnt.CustomerVisible = False
        tnt.Acknowledged = False
        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        tnt.Save(strChangeLog)
 
        btnSendEmail.Enabled = False
        Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        plog.Add(Master.WebLoginID, Now(), 13, "Welcome letter sent to customer. Ticket - " & _ID)
        
    End Sub
    
    Private Function SetAppointment(ByVal lngWorkOrderID As Object, ByRef lngPartnerID As Object) As String
        Dim strReturn As String = ""
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Load(lngWorkOrderID)
        If wrk.ClosingAgent = 0 Then
            strReturn &= "<a target='_blank' href=""editticketappointment2.aspx?id=" & _ID & "&pid=" & lngPartnerID & "&wid=" & lngWorkOrderID & "&returnurl=ticket.aspx%3fid=" & _ID & """>[Set Appt]</a>"
                                   
        Else
            strReturn &= "&nbsp;"
        End If
        Return strReturn
       
    End Function
    Private Sub DeleteScheduleAssignment(ByVal lngTicketID As Long)
  
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spDeleteScheduleAssignmentByTicketID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
   
    End Sub
    Private Function Survey(ByVal lngWorkOrderID As Object) As String
        Dim strReturn As String = ""
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Load(lngWorkOrderID)
        If wrk.ClosingAgent > 0 Then
            If IsSurveyCompleted(lngWorkOrderID) > 0 Then
                strReturn &= "<a target=""_blank"" href=""SurveyAnswers.aspx?id=" & lngWorkOrderID & "&returnurl=ticket.aspx%3fid=" & _ID & "&c=1"">[View Survey]</a>"
                btnSurveyEmail.Visible = False
            Else
                strReturn &= "<a target=""_blank"" href=""Survey.aspx?id=" & lngWorkOrderID & "&returnurl=ticket.aspx%3fid=" & _ID & "&c=0"">[Survey]</a>"
                btnSurveyEmail.Visible = True
            End If
        End If
        Return strReturn
       
    End Function
    
    Private Function IsSurveyCompleted(ByVal lngWorkOrderID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountSurveyAnswerByWorkOrderID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@WorkOrderID", Data.SqlDbType.Int).Value = lngWorkOrderID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            IsSurveyCompleted = dtr("Total")
        End While
        cnn.Close()
        Return IsSurveyCompleted
    End Function
    
    Private Sub btnSurveyEmail_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(_ID)
        cst.Load(tkt.CustomerID)
        Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        doc.Load(10)
        Dim strBody As String = doc.DocumentText
        strBody = strBody.Replace("$firstname", tkt.ContactFirstName)
        strBody = strBody.Replace("$lastname", tkt.ContactLastName)
        strBody = strBody.Replace("$UnitType", tkt.Manufacturer)
        strBody = strBody.Replace("$TicketID", _ID)
        strBody = strBody.Replace("$WorkOrderID", GetWorkOrderID(_ID))
        strBody = strBody & "<br><div> Please start the survey by <a href='https://www.bestservicers.com/eu/survey.aspx?id=" & GetWorkOrderID(_ID) & "&c=0&s=y' > clicking here </a>.</div>"
        
        strBody = strBody & "<br><br>Thank you,<br><br>"
        strBody = strBody & "<b>Best Servicers of America Team</b><br />"
        strBody = strBody & "<i>'Your best choice in repair and installation services'</i><br><br>"
        strBody = strBody & "www.bestservicers.com<br>"
        strBody = strBody & "Email: services@bestservicers.com<br />"
        strBody = strBody & "Phone: 561.886.6699<br />"
        strBody = strBody & "Fax: 561.886.6690<br />"

        
        eml.Subject = "Best Servicers - Service Survey"
        eml.SendTo = tkt.Email
        eml.SendFrom = "services@bestservicers.com"
        eml.Body = strBody
        eml.HTMLBody = True
        eml.Send()

        Dim strChangeLog As String = ""
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto message: Survey Email sent to End User")
        tnt.CustomerVisible = False
        tnt.Acknowledged = False
        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        tnt.Save(strChangeLog)
 
        btnSurveyEmail.Enabled = False
        Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        plog.Add(Master.WebLoginID, Now(), 12, "Survey Email sent to End User. Ticket - " & _ID)
    End Sub
    
    Private Function GetWorkOrderID(ByVal lngTicketID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetWorkOrderIDByTicketID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            GetWorkOrderID = dtr("WorkOrderID")
        End While
        cnn.Close()
        Return GetWorkOrderID
    End Function
    
    Private Sub dgvComponents_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvComponents.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim listPartLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalLabel As System.Web.UI.WebControls.Literal
        
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                rowData = CType(e.Item.DataItem, Data.DataRowView)
        
                price = CDec(rowData.Item("SubTotal"))
                mListPartsTotal += price
                
                listPartLabel = CType(e.Item.FindControl("lblSubTotal"), System.Web.UI.WebControls.Literal)
                
                listPartLabel.Text = price.ToString("C2")
                
            Case ListItemType.Footer
                
                GrandTotalLabel = CType(e.Item.FindControl("lblGrandTotalAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalLabel.Text = mListPartsTotal.ToString("C2")
                
        End Select
    End Sub
    Private Sub btnAssign_Click(ByVal S As Object, ByVal e As EventArgs)
        Dim strChangeLog As String = ""
        Dim lngTicketFolderID As Long
        If drpfolders.SelectedValue <> "Choose One" Then
            Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            fdl.Add(1, _ID, CType(drpfolders.SelectedValue, Long))
            lngTicketFolderID = fdl.TicketFolderAssignmentID
            Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            If drpfolders.SelectedValue = 30 Then
                tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Ticket has been placed in Need Customer Authorization folder")
            Else
                If drpfolders.SelectedValue = 25 Then
                    tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Ticket has been placed in RA / Invoice Issue folder")
                Else
                    tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Ticket has been placed in Need Parts Researched folder")
                End If
                   
            End If
            tnt.CustomerVisible = False
            tnt.PartnerVisible = False
            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
            tnt.Acknowledged = True
            tnt.Save(strChangeLog)
            Response.Redirect("Ticket.aspx?id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID)
        End If
        
        
    End Sub
    
    Private Sub LoadTicketFolders()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        'ldr.LoadSimpleDropDownList("spListActivePartnersWithCalls","ResumeID","PartnerID" , drpPartners)
      
        ldr.LoadSimpleDropDownList("spGetTicketFolders", "FolderName", "TicketFolderID", drpfolders)
        drpfolders.Items.Add("Choose One")
        drpfolders.SelectedValue = "Choose One"
        
        
    End Sub
    
    Private Sub btnRemove_Click(ByVal S As Object, ByVal e As EventArgs)
        Dim strChangeLog As String = ""
        If drpfolders.SelectedValue <> "Choose One" Then
            Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            'fdl.Add(1, _ID, 30)
            fdl.RemoveTicketFromFolder(_ID, CType(drpfolders.SelectedValue, Long))
            
            Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            If drpfolders.SelectedValue = 30 Then
                tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Ticket has been removed from Need Customer Authorization folder")
            Else
                If drpfolders.SelectedValue = 25 Then
                    tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Ticket has been removed from RA/Invoice Issue folder")
                Else
                    tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Ticket has been removed from Need Parts Researched folder")
                End If
            End If
                
            tnt.CustomerVisible = False
            tnt.PartnerVisible = False
            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
            tnt.Acknowledged = True
            tnt.Save(strChangeLog)
            Response.Redirect("Ticket.aspx?id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID)
        End If
        
        
    End Sub
    Private Function IsTicketInFolder(ByVal lngTicketID As Long, ByVal lngTicketFolderID As Long) As Long
        
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsTicketInFolder")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cmd.Parameters.Add("@TicketFolderID", Data.SqlDbType.Int).Value = lngTicketFolderID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            IsTicketInFolder = dtr("FolderCount")
        End While
        cnn.Close()
        Return IsTicketInFolder
    End Function
    Private Sub menu_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu.MenuItemClick
        Multiview1.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0
                
            Case Is = 1
               
        End Select
        
    End Sub
    
    Private Function GetLocation(ByVal strZipCode As String) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetLocationByZipCodeID")
        Dim zic As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        zic.Load(strZipCode)
        Dim lngZipCodeID As Long
        lngZipCodeID = zic.ZipCodeID
        Dim strLocationName As String
        strLocationName = ""
        cmd.Parameters.Add("@ZipCodeID", Data.SqlDbType.VarChar).Value = lngZipCodeID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strLocationName = dtr("LocationName")
        End While
        Return strLocationName
        cnn.Close()
    End Function
    Private Sub btnAddComplaint_Click(ByVal S As Object, ByVal E As EventArgs)
        'Response.Redirect("TicketDocumentsUpload.aspx?fid=0" & "&id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID & "&mode=doc&updt=0")
        'Response.Redirect("Complaints.aspx?id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID & "&mode=doc&updt=0")
         Response.Redirect("BlackBook.aspx?id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID)
    End Sub
    Private Sub dgvPriorTickets_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvPriorTickets.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim listPriorTicketLabel As System.Web.UI.WebControls.Image
        
        'check the type of item that was databound and only take action if it 
        'was a row in the datagrid
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                
                If IsTicketOpen(rowData.Item("TicketID")) Then
                    listPriorTicketLabel = CType(e.Item.FindControl("imgStatus"),System.Web.UI.WebControls.Image) 
                    listPriorTicketLabel.ImageUrl = ("/graphics/green_small.png")
                   
                Else
                    listPriorTicketLabel = CType(e.Item.FindControl("imgStatus"),System.Web.UI.WebControls.image) 
                    listPriorTicketLabel.ImageUrl = ("/graphics/red_small.png")

                End If
                
            Case ListItemType.Footer
                
            Case Else
                
        End Select
        
    End Sub  'dgvPriorTickets_ItemDataBound
    
    Private Sub LoadBlackBookIssues()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spGetBlackBookIssueByTicketID", "@TicketID", _ID, dgvBlackBook)
    End Sub
    Private Sub BBItem_Click(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs)
        Dim strTest As String
        
        strTest = (CType(e.CommandSource, LinkButton)).CommandName
        Select Case (CType(e.CommandSource, LinkButton)).CommandName
            
            Case "BBView"
               Dim lngID As Long
               lngID = CType(e.Item.Cells(0).Text, Long)
               Response.Redirect("BlackBook.aspx?id=" & _ID & "&mode=1&BBID=" & lngID & "&returnurl=ticket.aspx?id=" & _ID)

        End Select
    End Sub
   
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTicket" runat="server">
    <div id="divErrors" runat="server" class="errorzone" visible="false" />
    <table style="width: 100%; " >
      <tbody>
        <tr>
          <td class="band" style="width: 1%">
            <div class="bandheader">Priority</div>            
            <div style="background-color: white; border: inset 2px grey; text-align: center">
              <table style="width: 100%">
                <tbody>
                  <tr>
                    <td><a target="_blank" href="prioritylookup.aspx"><asp:Label ID="lblPriority" runat="server" /></a></td>
                    <td><asp:Image ID="imgPriority" runat="server" /></td>
                  </tr>
                </tbody>
              </table>              
            </div>
            <div class="bandheader">Local&nbsp;Time</div>
            <div class="clock"><asp:Label ID="lblLocalTime" runat="server" /></div>
            <div class="bandheader">Folders</div>
            <asp:DataGrid style="width:100%" ID="dgvFolders" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
              <ItemStyle CssClass="bandbar" />
              <Columns>
                <asp:BoundColumn DataField="TicketFolderID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" >
                  <ItemTemplate>
                    <a href="tickets.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketFolderID") %>"><%# DataBinder.Eval(Container.DataItem,"FolderName") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>              
            </asp:DataGrid>            
            <div class="inputformsectionheader">Commands</div>
            <div class="inputform">
              <div><a id="lnkPrintable" runat="server">Printable&nbsp;Version</a></div>
              <div><a id="lnkTicketBilling" runat="server">View&nbsp;Billing</a></div>
              <div><a id="lnkEditTicket" runat="server">Edit</a></div>
              <div><a id="lnkAppt" runat="server">Set/Edit&nbsp;Appt</a></div>
              <div><a id="lnkAddPhone" runat="server">Add&nbsp;Phone&nbsp;Number</a></div>
              <div><a id="lnkAddComponent" runat="server">Add&nbsp;Component</a></div>
              <div><a id="lnkAssignComponents" runat="server">Assign&nbsp;Components</a></div>
              <div><a id="lnkAssignWorkOrder" runat="server">Assign&nbsp;Work&nbsp;Order</a></div>
              <div id="divNewTicket" runat="server"><a target ="_blank" id="lnkNewTicket" runat="server">New&nbsp;-Same&nbsp;End&nbsp;User</a></div>
              <div id="divInitialContact" runat="server"><a id="lnkInitialContact" runat="server">Initial&nbsp;Contact</a></div>
              <div id="divCancel" runat="server"><a id="lnkCancel" runat="server">Cancel&nbsp;Ticket</a></div>
            </div>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Assign to Folder</div>
              <div class="inputform">                
                <div><asp:DropDownList style="width: 99%;" ID="drpfolders" runat="server" /></div>
                <div style="text-align: right;"><asp:Button ID="btnRemove" runat="server" Text="Remove" OnClick="btnRemove_Click"/>&nbsp;<asp:Button ID="btnAssign" runat="server" Text="Assign" OnClick="btnAssign_Click"/></div>
              </div>
              <div>&nbsp;</div>
              <div class="inputformsectionheader">Pay Out of Warranty</div>
              <div class="inputform">
              <div id="divPaymentLink" runat="server"><a target ="_blank" id="lnkPayment" runat="server">Make&nbsp;Payment</a></div>
              </div>
              <div>&nbsp;</div>
            <div class="inputformsectionheader">Search&nbsp;Tickets</div>
            <div class="inputform">
              <div class="errorzone" id="divJumpToError" runat="server" visible="false"></div>
              <div class="label">Criteria</div>
              <div><asp:TextBox ID="txtCriteria" runat="server" /></div>
              <div><asp:DropDownList ID="drpFields" runat="server" /></div>
              <div style="text-align: right;"><asp:Button ID="btnJump" runat="server" Text="Jump" OnClick="btnJump_Click" /></div>
            </div>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Prior Tickets</div>
            <asp:DataGrid style="width:100%" ID="dgvPriorTickets" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
              <ItemStyle CssClass="bandbar" />
              <Columns>
                <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" >
                  <ItemTemplate>
                    <a href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>" target ="_blank"><%# DataBinder.Eval(Container.DataItem,"TicketID")%> </a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn ItemStyle-Wrap="false" >
                  <ItemTemplate>
                    <asp:Image ID="imgStatus" runat="server" />
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>              
            </asp:DataGrid>   
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Serial History</div>
            <asp:DataGrid style="width:100%" ID="dgvPriorTicketsBySerial" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
              <ItemStyle CssClass="bandbar" />
              <Columns>
                <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" >
                  <ItemTemplate>
                    <a href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>" target ="_blank"><%# DataBinder.Eval(Container.DataItem,"TicketID")%> </a>
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>              
            </asp:DataGrid>           
          </td>
          <td>
            <div class="inputform">
            <table style="width: 100%">
              <tbody>
                <tr>
                  <td class="inputform" >
                    <div class="inputformsectionheader">Contact Information</div>
                    <div><asp:Label ID="lblContact" runat="server" /></div>
                    <div><a target="_blank" id="lnkMapIt" runat="server"><asp:Label ID="lblAddress" runat="server" /></a></div>
                    <div style="text-align: left;"><asp:Image ID="imgPostNet" runat="server" /></div>
		            <div>&nbsp;</div>
		            <div>County: <asp:Label ID="lblCountyName" runat="server" /></div>
		            <div>Location: <asp:Label ID="lblLocationName" runat="server" /></div>
		            <div><asp:Button OnClick="btnSendEmail_Click" ID="btnSendEmail"  runat="server" Text="Send Welcome Email" /></div>
                    <div>&nbsp;</div>
                    <div><asp:Button OnClick="btnSurveyEmail_Click" ID="btnSurveyEmail"  runat="server" Text="Send Survey Email" /></div>
		            
		            
                  </td>
                  <td>&nbsp;</td>
                  <td class="inputform">
                    <div class="inputformsectionheader">Phone Numbers</div>
                    <asp:DataGrid style="width:100%; background-color: White;" ID="dgvPhoneNumbers" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
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
                            <a href="editphone.aspx?returnurl=ticket.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>&id=<%# DataBinder.Eval(Container.DataItem,"TicketPhoneNumberID") %>&mode=ticket">Edit</a>
                          </Itemtemplate>
                        </asp:TemplateColumn>                            
                      </Columns>                
                    </asp:DataGrid>                    
                  </td>
                  <td>&nbsp;</td>
                  <td class="inputform">
                    <div class="inputformsectionheader">Ticket Information</div>
                    <table cellspacing="0">
                      <tr>
                        <td class="label">Ticket ID</td>
                        <td>&nbsp;</td>
                        <td ><asp:Label ID="lblTicketID" runat="server" /></td>
                      </tr>
                      <tr>
                        <td class="label">Status</td>
                        <td>&nbsp;</td>
                        <td ><asp:Label ID="lblStatus" runat="server" /></td>
                      </tr>
                      <tr>
                        <td class="label">Created</td>
                        <td>&nbsp;</td>
                        <td ><asp:Label ID="lblDateCreated" runat="server" /></td>
                      </tr>
                      <tr>
                        <td class="label">Start By</td>
                        <td>&nbsp;</td>
                        <td ><asp:Label ID="lblRequestedStartDate" runat="server" /></td>
                      </tr>              
                      <tr>
                        <td class="label">End By</td>
                        <td>&nbsp;</td>
                        <td><asp:Label ID="lblRequestedEndDate" runat="server" /></td>
                      </tr>
                      <tr>
                        <td class="label">Age (days)</td>
                        <td>&nbsp;</td>
                        <td><asp:Label ID="lblAge" runat="server" Font-Bold="true" Font-Size="XX-Large"    /></td>
                      </tr>
                      <tr>
                        <td class="label">Responsible Agent</td>
                        <td>&nbsp;</td>
                        <td ><asp:Label ID="lblSupportAgent" runat="server" /></td> 
                      </tr>
                      <tr>
                        <td class="label">Date Invoiced</td>
                        <td>&nbsp;</td>
                        <td ><asp:Label ID="lblCompletedDate" runat="server" /></td> 
                      </tr>
                    </table>
                   </td>
                </tr>        
              </tbody>
            </table>
            </div>
            
            <div class="inputformsectionheader">Reference Numbers</div>
            <table style="width: 100%" class="inputform">
              <tbody>
                <tr>
                  <td class="label"><asp:Label ID="lblRef1Label" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td ><asp:Label ID="lblRef1" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label"><asp:Label ID="lblRef2Label" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td ><asp:Label ID="lblRef2" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label"><asp:Label ID="lblRef3Label" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td ><asp:Label ID="lblRef3" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label"><asp:Label ID="lblRef4Label" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td ><asp:Label ID="lblRef4" runat="server" /></td>
                </tr>      
              </tbody>
            </table>
            <table width ="100%">
              <tr>
                <td style="width:65%"><div class="inputformsectionheader">Scheduling</div>
            <table width="100%">
              <tbody>
                <tr>
                  <td class="label">Appt. Start</td>
                  <td ><asp:label ID="lblScheduledDate" runat="server" /></td>
                  <td class="label">Appt. End</td>
                  <td ><asp:Label ID="lblScheduledDateEnd" runat="server" /></td>
                </tr>
                <tr>
                  <td><asp:Button ID="btnClearAppt" runat="server" Text="Clear" OnClick="btnClearAppt_Click" Width ="80%" /></td>
                </tr>
               
              </tbody>
            </table>    
            <div class="inputformsectionheader">Service Information</div>
            <table>
              <tbody>
                <tr>
                  <td class="label">Program</td>
                  <td ><asp:Label ID="lblServiceType" runat="server" /></td>
                  <td><div>&nbsp;</div></td>
                  <td class="label">Service SKU</td>
                  <td ><asp:label ID="lblService" runat="server" /></td>
                  <td ><asp:Label ID="lblServiceStartDate" runat="server" Visible ="false"/></td>
                  <td ><asp:Label ID="lblServiceEndDate" runat="server" Visible ="false" /></td>
                </tr>
              </tbody>
            </table>
            <table>
              <tbody>
                <tr>
                  <td class="label">Unit Type</td>
                  <td ><asp:Label ID="lblManufacturer" runat="server" /></td>
                  <td><div>&nbsp;</div></td>
                  <td class="label">Model</td>
                  <td ><asp:label ID="lblModel" runat="server" /></td>
                 </tr>
                 <tr>
                  <td class="label">Purchase Date</td>
                  <td ><asp:Label ID="lblPurchaseDate" runat="server" /></td>
                  <td><div>&nbsp;</div></td>
                  <td class="label">Serial Number</td>
                  <td ><asp:Label ID="lblSerialNumber" runat="server" />&nbsp;&nbsp;<asp:Label ID="lblWeekDay" runat="server" /></td>
                  <td ><asp:label ID="lblWarrantyTerm" runat="server" Visible ="false"/></td>
                  <td ><asp:Label ID="lblWarrantyStart" runat="server" Visible ="false"/></td>
                  <td ><asp:Label ID="lblWarrantyEnd" runat="server" Visible ="false"/></td>
                </tr>
              </tbody>
            </table>
               </td>
               <td>
                 <div class="inputformsectionheader" >Black Book (Complaints/Compliments)</div>
                 <asp:Button ID="btnAddComplaint" runat="server" Text="Create" OnClick="btnAddComplaint_Click" Width ="30%" OnClientClick="aspnetForm.target ='_blank'" />   
                  <asp:DataGrid style="width:100%" ID="dgvBlackBook" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="BBItem_Click" CssClass="Grid1">
                    <ItemStyle CssClass="bandbar" />
                    <HeaderStyle CssClass="gridheader" />
                    <AlternatingItemStyle CssClass="altrow" />
                      <Columns>
                        <asp:BoundColumn DataField="BlackBookID" HeaderText="ID" Visible="false" />
                        <asp:BoundColumn DataField="BlackBookType" HeaderText="Type" Visible="True" />
                        <asp:BoundColumn DataField="DepartmentName" HeaderText="Department" Visible="True" />
                        <asp:BoundColumn DataField="Closed" HeaderText="Closed" Visible="True" />
                        <asp:ButtonColumn Text="View" CommandName ="BBView"  ></asp:ButtonColumn> 
                         
                     </Columns>              
                  </asp:DataGrid> 
               </td>
             </tr>
            </table>
            <table width="100%">
              <tr >
                <td style="width:65%">
                  <div class="inputformsectionheader" >On Site Instructions</div>
                  <div style="padding-right: 5px"><asp:TextBox runat="server" ID="txtDescription" TextMode="multiLine" ReadOnly="true" style="width: 100%; height: 50px;" /></div>
               </td>
               <td rowspan ="2">
                  <div class="inputformsectionheader">Attachments</div>
                  <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" Width ="30%" />      
                  <asp:DataGrid style="width:100%" ID="dgvAttachments" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="Item_Click" CssClass="Grid1">
                    <ItemStyle CssClass="bandbar" />
                    <HeaderStyle CssClass="gridheader" />
                    <AlternatingItemStyle CssClass="altrow" />
                      <Columns>
                        <asp:BoundColumn DataField="TicketDocumentID" HeaderText="ID" Visible="false" />
                        <asp:BoundColumn DataField="Description" HeaderText="DocType" Visible="True" />
                        <asp:BoundColumn DataField="FileID" HeaderText="FileID" Visible="false" />
                        <asp:ButtonColumn Text="View" CommandName ="View" ></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Update" CommandName="Update"></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Remove" CommandName="Remove" ></asp:ButtonColumn> 
                     </Columns>              
                  </asp:DataGrid> 
               </td>
              </tr>
              <tr>
                <td>
                  <div class="inputformsectionheader">Problem Description</div>
                  <div style="padding-right: 5px"><asp:TextBox runat="server" ID="txtNotes" TextMode="multiLine" ReadOnly="true"  Wrap="true" style="width: 100%; height: 50px; overflow:hidden;"/> </div>
                </td>
             </tr>
            </table>
            <div class="inputformsectionheader">Parts</div>
            <div>&nbsp;</div>
             <asp:Menu ID="menu" runat="server" Orientation="Horizontal" OnMenuItemClick ="menu_MenuItemClick" CssClass="ul">
             <StaticMenuItemStyle CssClass="li" />
             <StaticHoverStyle CssClass="hoverstyle" />
             <StaticSelectedStyle CssClass="current" />
             <Items>
                <asp:MenuItem  value ="0" Text="Parts"></asp:MenuItem>
                <asp:MenuItem value ="1" Text="Estimate"></asp:MenuItem> 
             </Items>
           </asp:Menu>
           
           <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
           <asp:View ID="viewParts"  runat="server">
           <div>&nbsp;</div>
            <div>&nbsp;</div><div id="ratesheader" >
             <div>&nbsp;</div></div>
            <asp:DataGrid ID="dgvComponents" runat="server" AutoGenerateColumns="false" style="width: 100%; background-color: White;" ShowFooter = "True" Cssclass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" 
             BackColor="#C0C0C0" />
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />
              <Columns>      
                <asp:BoundColumn DataField="TicketComponentID" Visible="false" />
                <asp:TemplateColumn HeaderText="Command">
                  <ItemTemplate>
                    <a href="editcomponent.aspx?id=<%# Databinder.eval(Container.DataItem,"TicketComponentID") %>&returnurl=ticket.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>">Edit</a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="Qty" HeaderText="Qty" />
                <asp:BoundColumn DataField="Code" HeaderText="Code/SKU" />
                <asp:BoundColumn DataField="Component" HeaderText="Component Name" />
                <asp:BoundColumn DataField="SerialNumber" HeaderText="Invoice Number" />
                <asp:BoundColumn DataField="TotalPartAmount" HeaderText="$Amount" DataFormatString="{0:c}" />
                <asp:BoundColumn DataField="Tax" HeaderText="$Tax" DataFormatString="{0:c}" />
                <asp:BoundColumn DataField="Shipping" HeaderText="$Ship" DataFormatString="{0:c}"/>
                <asp:BoundColumn DataField="SubTotal" HeaderText="$Total" DataFormatString="{0:c}" Visible="false" />
                <asp:TemplateColumn SortExpression="SubTotal" HeaderText="$Total" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblSubTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "SubTotal")%>' />
                   </ItemTemplate>
                  <FooterTemplate >
                    <asp:Literal id="lblGrandTotalAmount" runat="server" />
                  </FooterTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Shipping Labels">
                  <ItemTemplate>
                    <asp:DataGrid ID="dgvLabels" style="width: 100%; background-color: White;" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                      <HeaderStyle CssClass="gridheader" />
                      <AlternatingItemStyle CssClass="altrow" />
                      <Columns>
                        <asp:BoundColumn DataField="ShippingLabelID" Visible="false" />
                        <asp:BoundColumn HeaderText="Tracked" DataField="Tracked" />
                        <asp:BoundColumn HeaderText="Courier" DataField="Courier" />
                        <asp:BoundColumn DataField="Destination" HeaderText="Destination" />
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
               <div class="inputformsectionheader">Work Orders</div>
            <asp:DataGrid ID="dgvWorkOrders" OnItemCommand="btnWorkOrder_Click" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="WorkOrderID" Visible="false" />
                <asp:templatecolumn HeaderText="Work Order ID">
                  <itemtemplate>
                   <%#RemoveWo(DataBinder.Eval(Container.DataItem, "WorkOrderID"))%> &nbsp;<a href="printableworkorder.aspx?id=<%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%>"><%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%></a>
                    <asp:ImageButton ID="btnWorkOrder" runat="server" /> <asp:Label ID="lblWorkOrderUploaded" runat="server" /> <%#UploadText(Databinder.Eval(Container.DataItem, "WorkOrderID"))%> 
                              
                  </itemtemplate>
                </asp:templatecolumn>
                <asp:TemplateColumn headertext="Build Estimate">
                  <Itemtemplate >
                  <a target="_blank" href="estimatetemplate.aspx?id=<%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%>" >Estimate</a> 
                  </Itemtemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Tasks">
                  <ItemTemplate>
                    <%#Survey(Databinder.Eval(Container.DataItem, "WorkOrderID"))%>
                    <%#TaskText(Databinder.Eval(Container.DataItem, "WorkOrderID"))%><br />
                    <%#PartnerEmailAddress(DataBinder.Eval(Container.DataItem, "PartnerID"))%><br />
                    <%#SetAppointment(DataBinder.Eval(Container.DataItem, "WorkOrderID"), DataBinder.Eval(Container.DataItem, "PartnerAgentID"))%>                
                   
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn HeaderText="Status" DataField="WorkOrderStatus" />
                <asp:TemplateColumn HeaderText="Partner">
                  <ItemTemplate>
                    <a href="partner.aspx?id=<%# Databinder.Eval(Container.DataItem,"PartnerID") %>"><%# Databinder.Eval(Container.DataItem,"PartnerIDLabel") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Agent">
                  <ItemTemplate>
                    <a href="editpartneragent.aspx?id=<%#Databinder.eval(Container.DataItem,"PartnerAgentID") %>"><%#Databinder.eval(Container.DataItem,"Login") %> </a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn  HeaderText="Technician's Quick Info"  >
                  <ItemTemplate>
                       <asp:DataGrid style="width: 100%" ID="dgvAssociatedPhoneNumbers"  CaptionAlign="Left"  ShowHeader = "False" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                        <AlternatingItemStyle CssClass="altrow" />
                        <HeaderStyle CssClass="gridheader" />
                        <Columns>
                          <asp:BoundColumn HeaderText="ID" DataField="AssignmentID" visible="false" />                    
                          <asp:BoundColumn DataField="PhoneType" />
                          <asp:TemplateColumn ItemStyle-Wrap="false" >
                          <ItemTemplate>
                            <%# Databinder.eval(Container.DataItem, "CountryCode") %> (<%# Databinder.eval(Container.DataItem, "AreaCode") %>) <%# Databinder.eval(Container.DataItem, "Exchange") %>-<%# Databinder.eval(Container.DataItem, "LineNumber") %>
                          </ItemTemplate>
                          </asp:TemplateColumn>
                          <asp:BoundColumn DataField="Extension" headertext="Extension" />
                        </Columns>                
                      </asp:DataGrid>
                       <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvAddresses"  ShowHeader = "false" runat="server" CssClass="Grid1">
                          <HeaderStyle CssClass="gridheader"  />
                          <AlternatingItemStyle CssClass="altrow" />   
                          <Columns>
                            <asp:BoundColumn
                              DataField="AddressType"
                              
                              ItemStyle-Wrap="false"
                              />
                            <asp:TemplateColumn
                              
                              >
                              <ItemTemplate>
                                <a target="_blank" href="<%# MapIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%></a>
                              </ItemTemplate>
                            </asp:TemplateColumn>                  
                            <asp:BoundColumn
                              DataField="City"
                              
                              />
                            <asp:BoundColumn
                              DataField="StateAbbreviation"
                              
                              />
                            <asp:TemplateColumn
                              
                              >
                              <ItemTemplate>
                                <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
                              </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn>                     
                              <ItemTemplate>
                                 <a href="../Maps/<%# Databinder.eval(Container.DataItem,"LocationName") %>.pdf" target="_blank"><%# Databinder.eval(Container.DataItem,"LocationName") %></a>
                              </ItemTemplate>
                            </asp:TemplateColumn> 
                            <asp:TemplateColumn 
                             
                              >             
                              <ItemTemplate>
                                <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                              </ItemTemplate>
                            </asp:TemplateColumn>                              
                          </Columns>        
                        </asp:DataGrid>
                   </ItemTemplate>     
                </asp:TemplateColumn>
                <asp:BoundColumn HeaderText="Resolved" DataField="Resolved" Visible="False" />
                <asp:BoundColumn HeaderText="RPW" DataField="RPW" />
                <asp:TemplateColumn HeaderText="Dispatched">
                  <ItemTemplate>
                    <%#CreateDispatchText(DataBinder.Eval(Container.DataItem, "DispatchDate"), DataBinder.Eval(Container.DataItem, "WorkOrderID"))%>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn HeaderText="Created" DataField="DateCreated" />
              </Columns>      
            </asp:DataGrid>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Activity Notes</div>
            <asp:TextBox ID="txtTicketNote" runat="server" TextMode="MultiLine" style="width: 100%; " Height="75px"   wrap="true" />
            <div style="text-align: right;"><asp:CheckBox ID="chkPartnerVisible" Text="Partner Visible" runat="server" />&nbsp;<asp:CheckBox ID="chkCustomerVisible" runat="server" Text="Customer Visible" /></div>
            <div style="text-align: right;"><asp:Button ID="btnAddNote" Text="Add Note" OnClick="btnAddNote_Click" runat="server" /></div>
            <div style="overflow-wrap:break-word;">
              <asp:DataGrid ID="dgvNotes" runat="server" ShowHeader="false" AutoGenerateColumns="false" style="width: 100%; background-color: White; " CssClass="Grid2">
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="TicketNoteID" Visible="false" />
                <asp:BoundColumn HeaderText="Acknowledged" DataField="Acknowledged" Visible="false" />
                <asp:TemplateColumn ItemStyle-Width="16%" ItemStyle-VerticalAlign="top" ItemStyle-Wrap="false" >
                  <ItemTemplate>
                    <div style="white-space:nowrap;">NoteID:<%#DataBinder.Eval(Container.DataItem, "TicketNoteID")%></div>
                    <div style="white-space:nowrap;"><%# Databinder.eval(Container.DataItem, "DateCreated") %></div>
                    <div><a href="mailto:<%# Databinder.eval(Container.DataItem, "Email") %>"><%# Databinder.eval(Container.DataItem, "Author") %></a></div>
                    <div>C-Visible: <%# Databinder.eval(Container.DataItem, "CustomerVisible") %></div>
                    <div>P-Visible: <%#DataBinder.Eval(Container.DataItem, "PartnerVisible")%></div>
                    <div><a href="editticketnote.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketNoteID") %>&returnurl=ticket.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>">Edit</a></div>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn ItemStyle-Wrap="true" >
                  <Itemtemplate>
                  <%# Databinder.eval(Container.DataItem, "NoteBody").ToString.Replace(environment.NewLine,"<br />") %>
                  </Itemtemplate>
                </asp:TemplateColumn>
              </Columns>
            </asp:DataGrid>    
            </div>

             </asp:View>
           <asp:View ID="viewEstimate"  runat="server">
           <div >&nbsp;
           <div>&nbsp;</div>
             <div class="tabbody">
             <div>&nbsp;</div></div>
            <table >
              <tbody>
 
               <tr style ="width:100%">
                <td>
                  <table>
                    <tr>
                      <td class="label">Choose Supplier</td>
                      <td class="label" >Qty</td>
                      <td class="label" >Part Number</td>
                      <td class="label" >Description</td>
                      <td class="label" >Cost</td> 
                      <td class="label" >Retail</td>
                      <td></td>
                    </tr>
                    <tr style ="width:100%">
                        <td><asp:DropDownList ID="drpVendors" runat="server" /></td>
                      <td style="width:5%;"><asp:TextBox  ID="txtQty" runat="server" /></td>
                      <td ><asp:TextBox   ID="txtCode" runat="server" /></td>
                      <td ><asp:TextBox   ID="txtComponent" runat="server" /></td>
                      <td ><asp:TextBox  ID="txtInvoiceNumber" runat="server" /></td>
                      <td ><asp:TextBox  ID="TextBox1" runat="server" /></td>
                      <td><asp:Button  ID="btnCANCEL" runat="server" Text="ADD" /></td>   
                    </tr>
                  </table>
                  <div>&nbsp;</div>
                  
                  <table>
                  <tr>
                  <td>
                    <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="false" style="width: 100%; background-color: White;" ShowFooter = "True" Cssclass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" 
                      BackColor="#C0C0C0"  />
                      <HeaderStyle CssClass="gridheader" />
                      <AlternatingItemStyle CssClass="altrow" />
                      <Columns>      
                         <asp:BoundColumn DataField="TicketComponentID" Visible="false" />
                         <asp:TemplateColumn HeaderText="Command">
                           <ItemTemplate>
                            <a href="editcomponent.aspx?id=<%# Databinder.eval(Container.DataItem,"TicketComponentID") %>&returnurl=ticket.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>">Edit</a>
                           </ItemTemplate>
                         </asp:TemplateColumn>
                        <asp:BoundColumn DataField="Qty" HeaderText="Qty" />
                        <asp:BoundColumn DataField="Code" HeaderText="Code/SKU" />
                        <asp:BoundColumn DataField="Component" HeaderText="Component Name" />
                        <asp:BoundColumn DataField="SerialNumber" HeaderText="Invoice Number" />
                        <asp:BoundColumn DataField="TotalPartAmount" HeaderText="$Amount" DataFormatString="{0:c}" />
                        <asp:BoundColumn DataField="Tax" HeaderText="$Tax" DataFormatString="{0:c}" />
                        <asp:BoundColumn DataField="Shipping" HeaderText="$Ship" DataFormatString="{0:c}"/>
                        <asp:BoundColumn DataField="SubTotal" HeaderText="$Total" DataFormatString="{0:c}" Visible="false" />
                        <asp:TemplateColumn SortExpression="SubTotal" HeaderText="$Total" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Literal id="lblSubTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "SubTotal")%>' />
                           </ItemTemplate>
                           <FooterTemplate >
                                <asp:Literal id="lblGrandTotalAmount" runat="server" />
                           </FooterTemplate>
                      </asp:TemplateColumn>
                      </Columns> 
                    </asp:DataGrid>
                    </td>
                   </tr>
                  </table>
                 </td>
               </tr>
              </tbody>
            </table>  </div>  
           </asp:View>
           </asp:MultiView>  
            
            
            
        </td>
        </tr>
      </tbody>
    </table>
    
    <asp:Label id="lblReturnUrl" runat="server" Visible="false" />
  </form>
</asp:Content>