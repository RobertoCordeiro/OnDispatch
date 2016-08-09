<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

    Private _ID As Long = 0
    Private _lngCustID As Long = 1
   Private lngIt as long 
    Private _lngRegionID As Long
    Private _lngStatusID As Long = 0
    Private _lngStateID As Long = 0
    Private _lngProgramID As Long = 0
    Private _lngColor As Long = 1
    Private _chkNeedUpdate1 As Boolean = False
    Private _AllActive As Boolean = False
    Private _CountryID As Long = 1
    
    
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Vendor Admin Control"
            Master.PageTitleText = "Vendor Admin Control"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Ticket Management"
    End If
    Try
            _ID = CType(Request.QueryString("id"), Long)
            _lngRegionID = CType(Request.QueryString("RID"), Long)
            _lngCustID = CType(Request.QueryString("CustID"), Long)
            _lngStatusID = CType(Request.QueryString("StatusID"), Long)
            _lngProgramID = CType(Request.QueryString("ProgID"), Long)
            _lngStateID = CType(Request.QueryString("StateID"), Long)
            If Request.QueryString("NP") <> "" Then
                _chkNeedUpdate1 = CType(Request.QueryString("NP"), Boolean)
            Else
                _chkNeedUpdate1 = False
            End If
            If Request.QueryString("AA") <> "" Then
                _AllActive = CType(Request.QueryString("AA"), Boolean)
            Else
                _AllActive = False
            End If
            
            _lngColor = CType(Request.QueryString("C"), Long)
            If _ID < 1 Then
                _ID = 0
                
            End If
            If _lngRegionID < 1 Then
                _lngRegionID = 0
            End If
        Catch ex As Exception
            _ID = 0
            _chkNeedUpdate1 = False
            _AllActive = False
        End Try
    
        If Not Page.IsPostBack Then
            LoadCustomers()
            LoadPartners()
            LoadPrograms()
            LoadStatus()
            LoadStates()
            drpCustomers1.SelectedValue = _lngCustID
            drpStatus.SelectedValue = _lngStatusID
            drpState.SelectedValue = _lngStateID
            chkNeedUpdateID.Checked = _chkNeedUpdate1
            chkAllActive.Checked = _AllActive
            If chkSendEmail.Checked = True Then
                rowSendEmail.visible = True
            Else
                rowSendEmail.visible = False
            End If
            If _lngRegionID > 0 Then
                LoadPartnersList(_lngRegionID)
                
                If _ID <> 0 Then
                    LoadTicketsByPartners(2, _ID)
                    Dim par As New BridgesInterface.PartnerRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    Dim res As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    par.Load(_ID)
                    Dim strEmailLink As String

                    strEmailLink = "<a href='mailto:" & par.Email & "'>Launch Email</a>"
                    lblLaunchEmail.Text = strEmailLink
                    
                    
                    res.Load(par.ResumeID)
                    
                    lblTechName.Text = res.FirstName & " " & res.LastName
                End If
                drpPartners.SelectedValue = "Choose One"
            Else
                If _ID <> 0 Then
                    drpPartners.SelectedValue = CType(_ID, String)
                    LoadTicketsByPartners(2, _ID)
                     Dim par As New BridgesInterface.PartnerRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    par.Load(_ID)
                    Dim strEmailLink As String

                    strEmailLink = "<a href='mailto:" & par.Email & "'>Launch Email</a>"
                    lblLaunchEmail.Text = strEmaillink
                Else
                    drpPartners.SelectedValue = "Choose One"
                End If
            End If
            menu5.Items(0).Selected = True
            Multiview1.ActiveViewIndex = 0
            'If drpCustomers1.SelectedValue <> "Assign Customer" And drpProgram.SelectedValue = "Assign Program" Then
            'LoadPrograms1(drpCustomers1.SelectedValue)
            'End If
            'drpProgram.SelectedValue = _lngProgramID
            If _lngRegionID = 1 Then
                btnSER.BorderColor = Drawing.Color.Blue
            End If
            If _lngRegionID = 2 Then
                btnNER.BorderColor = Drawing.Color.Blue
            End If
            If _lngRegionID = 3 Then
                btnMWR.BorderColor = Drawing.Color.Blue
            End If
            If _lngRegionID = 4 Then
                btnSCR.BorderColor = Drawing.Color.Blue
            End If
            If _lngRegionID = 5 Then
                btnNCR.BorderColor = Drawing.Color.Blue
            End If
            If _lngRegionID = 6 Then
                btnSWR.BorderColor = Drawing.Color.Blue
            End If
            If _lngRegionID = 7 Then
                btnNWR.BorderColor = Drawing.Color.Blue
            End If
            If _lngRegionID = 8 Then
                btnWR.BorderColor = Drawing.Color.Blue
            End If
            If _lngRegionID = 9 Then
                btnAll.BorderColor = Drawing.Color.Blue
            End If
        Else
            If drpCustomers1.SelectedValue <> "Filter By Customer" And drpProgram.SelectedValue = "Filter By Program" Then
                LoadPrograms1(drpCustomers1.SelectedValue)
            Else
                If drpProgram.SelectedValue = "Filter By Program" Then
                    drpProgram.Items.Clear()
                    drpProgram.Items.Add("Filter By Program")
                    drpProgram.SelectedValue = "Filter By Program"
                End If
            End If
            If _ID > 0 Then
                LoadTicketsByPartners(2, _ID)
                 Dim par As New BridgesInterface.PartnerRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                    par.Load(_ID)
                    Dim strEmailLink As String

                    strEmailLink = "<a href='mailto:" & par.Email & "'>Launch Email</a>"
                    lblLaunchEmail.Text = strEmaillink
            End If
        End If
   
    End Sub
  
    Private Sub LoadPartnersList(ByVal lngRegionID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If _AllActive = False Then
            If lngRegionID <> 9 Then
                ldr.LoadSingleLongParameterDataGrid("spListActivePartnersWithCallsByRegion", "@RegionID", lngRegionID, dgvVendors)
            Else
                ldr.LoadSimpleDataGrid("spListActivePartnersWithCalls1", dgvVendors)
            End If
        Else
            If lngRegionID <> 9 Then
                ldr.LoadSingleLongParameterDataGrid("spListActivePartnersByRegion", "@RegionID", lngRegionID, dgvVendors)
            Else
                ldr.LoadSimpleDataGrid("spListActivePartners1", dgvVendors)
            End If
        End If
        If _ID <> 0 Then
            For Each itm As DataGridItem In dgvVendors.Items
                If CType(itm.Cells(1).Text, Long) = _ID Then
                    itm.CssClass = "selectedbandbar"
                End If
            Next
        End If
    End Sub

    Private Sub LoadTicketsByPartners(ByVal lngTicketFolderID As Long, ByVal lngPartnerID As Long)
       
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If drpPartners.SelectedValue <> "Choose One" Then
            drpPartners.SelectedValue = lngPartnerID
        End If
        If _ID <> 0 Then
            If drpCustomers1.SelectedValue <> "Filter By Customer" Then
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByPartnerCSPS1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByPartnerCSPS1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByPartnerCSPS", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByPartnerCSPS", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        Else
                            'Filter by Customer, status and program
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSP1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSP1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSP", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSP", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by customer, Status and State
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSS1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSS1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSS", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSS", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        Else
                            'Filter by Customer Status
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCS1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCS1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCS", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCS", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        End If

                    End If
                Else
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, Program and State
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCPS1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCPS1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCPS", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCPS", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        Else
                            'Filter By Customer, Program
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCP1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCP1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCP", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCP", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Customer, State
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCState1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCState1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCState", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCState", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        Else
                            'Filter By Customer
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerCustomer1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerCustomer1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerCustomer", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerCustomer", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                                
                            End If
                        End If
                    End If

                End If
            Else
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState1", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState1", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        Else
                            'Filter By Status and program
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatus1", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatus1", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatus", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatus", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status and State
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState1", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState1", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        Else
                            'Filter By Status
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus1", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus1", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        End If
                    End If
                Else
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Program and state
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerPS1", "@TicketFolderID", 33, "@PartnerID", _ID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerPS1", "@TicketFolderID", 2, "@PartnerID", _ID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerPS", "@TicketFolderID", 33, "@PartnerID", _ID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerPS", "@TicketFolderID", 2, "@PartnerID", _ID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        Else
                            'Filter By Program
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By State
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerState1", "@TicketFolderID", 33, "@PartnerID", _ID, "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerState1", "@TicketFolderID", 2, "@PartnerID", _ID, "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerState", "@TicketFolderID", 33, "@PartnerID", _ID, "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerState", "@TicketFolderID", 2, "@PartnerID", _ID, "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        Else
                            'Dont filter - Show all the tickets in the folder
                            If chkNeedUpdateID.Checked = True Then
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner1", "@TicketFolderID", 33, "@PartnerID", _ID, "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner1", "@TicketFolderID", 2, "@PartnerID", _ID, "CountryID", _CountryID, dgvTickets)
                                End If
                            Else
                                If drpPartners.SelectedValue = "Choose One" Then
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 33, "@PartnerID", _ID, "CountryID", _CountryID, dgvTickets)
                                Else
                                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 2, "@PartnerID", _ID, "CountryID", _CountryID, dgvTickets)
                                End If
                            End If
                        End If
                    End If
                End If
            End If
            
            lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
        End If
    End Sub


  Private Function DetermineCustomerLabel(ByRef strCompanyName As String, ByRef strCompanyContact As String) As String
    Dim strReturn As String = ""
    If Not IsNothing(strCompanyName) Then
      If strCompanyName.Trim.Length > 0 Then
        strReturn = strCompanyName
      Else
        If Not IsNothing(strCompanyContact) Then
          If strCompanyContact.Trim.Length > 0 Then
            strReturn = strCompanyContact
          Else
            strReturn = "Unknown"
          End If
        End If
      End If
    Else
      If Not IsNothing(strCompanyContact) Then
        If strCompanyContact.Trim.Length > 0 Then
          strReturn = strCompanyContact
        Else
          strReturn = "Unknown"
        End If
      End If
    End If
    Return strCompanyName
  End Function
  
   
  Protected Sub dgvTickets_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If lblSortOrder.Text.ToLower = " asc" Then
      lblSortOrder.Text = " desc"
    Else
      lblSortOrder.Text = " asc"
    End If
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'If drpPartners.SelectedValue = "Choose One" Then
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            If drpStatus.SelectedValue <> "Filter By Status" Then
                If drpProgram.SelectedValue <> "Filter By Program" Then
                    If drpState.SelectedValue <> "Filter By State" Then
                        'Filter by Customer, status, Program and state
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByPartnerCSPS1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByPartnerCSPS1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByPartnerCSPS", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByPartnerCSPS", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        'Filter by Customer, status and program
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSP1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSP1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSP", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSP", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    End If
                Else
                    If drpState.SelectedValue <> "Filter By State" Then
                        'Filter by customer, Status and State
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSS1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSS1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSS", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCSS", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        'Filter by Customer Status
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCS1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCS1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCS", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCS", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    End If

                End If
            Else
                If drpProgram.SelectedValue <> "Filter By Program" Then
                    If drpState.SelectedValue <> "Filter By State" Then
                        'Filter by Customer, Program and State
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCPS1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCPS1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCPS", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerCPS", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        'Filter By Customer, Program
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCP1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCP1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCP", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCP", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    End If
                Else
                    If drpState.SelectedValue <> "Filter By State" Then
                        'Filter By Customer, State
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCState1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCState1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCState", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerCState", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        'Filter By Customer
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerCustomer1", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerCustomer1", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerCustomer", "@TicketFolderID", 33, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerCustomer", "@TicketFolderID", 2, "@PartnerID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                                
                        End If
                    End If
                End If

            End If
        Else
            If drpStatus.SelectedValue <> "Filter By Status" Then
                If drpProgram.SelectedValue <> "Filter By Program" Then
                    If drpState.SelectedValue <> "Filter By State" Then
                        'Filter By status, Program and state
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState1", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState1", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        'Filter By Status and program
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatus1", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatus1", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    End If
                Else
                    If drpState.SelectedValue <> "Filter By State" Then
                        'Filter By status and State
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState1", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState1", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerStatusState", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        'Filter By Status
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus1", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus1", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus", "@TicketFolderID", 33, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerStatus", "@TicketFolderID", 2, "@PartnerID", _ID, "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    End If
                End If
            Else
                If drpProgram.SelectedValue <> "Filter By Program" Then
                    If drpState.SelectedValue <> "Filter By State" Then
                        'Filter By Program and state
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerPS1", "@TicketFolderID", 33, "@PartnerID", _ID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerPS1", "@TicketFolderID", 2, "@PartnerID", _ID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerPS", "@TicketFolderID", 33, "@PartnerID", _ID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByPartnerPS", "@TicketFolderID", 2, "@PartnerID", _ID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        'Filter By Program
                    End If
                Else
                    If drpState.SelectedValue <> "Filter By State" Then
                        'Filter By State
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerState1", "@TicketFolderID", 33, "@PartnerID", _ID, "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerState1", "@TicketFolderID", 2, "@PartnerID", _ID, "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerState", "@TicketFolderID", 33, "@PartnerID", _ID, "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartnerState", "@TicketFolderID", 2, "@PartnerID", _ID, "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    Else
                        'Dont filter - Show all the tickets in the folder
                        If chkNeedUpdateID.Checked = True Then
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner1", "@TicketFolderID", 33, "@PartnerID", _ID, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner1", "@TicketFolderID", 2, "@PartnerID", _ID, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        Else
                            If drpPartners.SelectedValue = "Choose One" Then
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 33, "@PartnerID", _ID, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 2, "@PartnerID", _ID, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            End If
                        End If
                    End If
                End If
            End If
        End If
        'Else
        'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 2, "@PartnerID", CType(drpPartners.SelectedValue, Long), dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
        'End If
    End Sub
 
  Private Sub LoadCustomers()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        'ldr.LoadSimpleDropDownList("spListActiveCustomers", "Company", "CustomerID", drpPartnerAgents)
        'drpPartnerAgents.Items.Add("Choose One")
        'drpPartnerAgents.SelectedValue = "Choose One"
        
        ldr.LoadSimpleDropDownList("spListActiveCustomers", "Company", "CustomerID", drpCustomers1)
        drpCustomers1.Items.Add("Filter By Customer")
        drpCustomers1.SelectedValue = "Filter By Customer"
    End Sub
    Private Sub LoadStates()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListStates", "StateName", "StateID", drpState)
        drpState.Items.Add("Filter By State")
        drpState.SelectedValue = "Filter By State"
        
        
    End Sub
    Private Sub LoadPrograms()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListStates", "StateName", "StateID", drpState)
        drpProgram.Items.Add("Filter By Program")
        drpProgram.SelectedValue = "Filter By Program"
        
        
    End Sub
    Private Sub LoadStatus()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListStatuses", "Status", "TicketStatusID", drpStatus)
        drpStatus.Items.Add("Filter By Status")
        drpStatus.SelectedValue = "Filter By Status"
        
        
    End Sub
 Private Sub LoadPartners()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListActivePartnersWithCalls", "ResumeID", "PartnerID", drpPartners)
        drpPartners.Items.Add("Choose One")
        drpPartners.SelectedValue = "Choose One"
 End Sub

    Private Sub btnEmail_Click(ByVal S As Object, ByVal E As EventArgs)
        'drpCustomers.selectedValue = "Choose one"
        'LoadTicketsByPartners(CType(Request.QueryString("id"), Long),Ctype(drpPartners.SelectedValue,long) )
    
    End Sub
  

    Protected Sub drpPartnerAgents_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'If drpPartnerAgents.SelectedValue <> "Choose One" Then
        'LoadTicketsByCustomer(CType(Request.QueryString("id"), Long), CType(drpPartnerAgents.SelectedValue, Long))
        'drpPartners.SelectedValue = "Choose One"
        'End If
    End Sub
    Protected Sub drpCustomers1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            LoadPrograms1(drpCustomers1.SelectedValue)
            
        End If
    End Sub
    Private Sub LoadPrograms1(ByVal lngCustomerID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadSimpleDropDownList("spListServiceTypes", "ServiceType", "CustomerID", drpProgram)
        ldr.LoadSingleLongParameterDropDownList("spListServiceTypes", "@CustomerID", lngCustomerID, "ServiceType", "ServiceTypeID", drpProgram)
        
        drpProgram.Items.Add("Filter By Program")
        drpProgram.SelectedValue = "Filter By Program"
    End Sub
    Protected Sub drpPartners_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpPartners.SelectedValue <> "Choose One" Then
            _lngRegionID = 0
            Dim lngCustomerID As Long
            Dim lngProgramID As Long
            Dim lngStatusID As Long
            Dim lngStateID As Long
            
            _ID = CType(drpPartners.SelectedValue, Long)
            
            If drpCustomers1.SelectedValue <> "Filter By Customer" Then
                lngCustomerID = drpCustomers1.SelectedValue
            Else
                lngCustomerID = 0
            End If
            If drpProgram.SelectedValue <> "Filter By Program" Then
                lngProgramID = drpProgram.SelectedValue
            Else
                lngProgramID = 0
            End If
            If drpStatus.SelectedValue <> "Filter By Status" Then
                lngStatusID = drpStatus.SelectedValue
            Else
                lngStatusID = 0
            End If
            If drpState.SelectedValue <> "Filter By State" Then
                lngStateID = drpState.SelectedValue
            Else
                lngStateID = 0
            End If
            _chkNeedUpdate1 = chkNeedUpdateID.Checked
            _AllActive = chkAllActive.Checked
            
            Response.Redirect("VendorAdministrationControl.aspx?id=" & _ID & "&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&C=0", True)

            'LoadTicketsByPartners(CType(2, Long), CType(drpPartners.SelectedValue, Long))
            
        End If
    End Sub
    Private Sub btnSER_Click(ByVal S As Object, ByVal E As EventArgs)
        _lngRegionID = 1
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        
        
        drpPartners.SelectedValue = "Choose One"
        
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Filter By Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
        _AllActive = chkAllActive.Checked
        
        If _lngColor = 1 Then
            btnSER.BorderColor = Drawing.Color.Black
        Else
            btnSER.BorderColor = Drawing.Color.Blue
        End If
        
        Response.Redirect("VendorAdministrationControl.aspx?id=0&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&AA=" & _AllActive & "&C=0", True)
        
        
    End Sub
    Private Sub btnNER_Click(ByVal S As Object, ByVal E As EventArgs)
        _lngRegionID = 2
        
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        
        
        drpPartners.SelectedValue = "Choose One"
        
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Filter By Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
        _AllActive = chkAllActive.Checked
        
        If _lngColor = 1 Then
            btnNER.BorderColor = Drawing.Color.Black
        Else
            btnNER.BorderColor = Drawing.Color.Blue
        End If
        
        Response.Redirect("VendorAdministrationControl.aspx?id=0&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&AA=" & _AllActive & "&C=0", True)
        

        
    End Sub
    Private Sub btnMWR_Click(ByVal S As Object, ByVal E As EventArgs)
        _lngRegionID = 3
        
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        
        
        drpPartners.SelectedValue = "Choose One"
        
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Filter By Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
        _AllActive = chkAllActive.Checked
        
        If _lngColor = 1 Then
            btnMWR.BorderColor = Drawing.Color.Black
        Else
            btnMWR.BorderColor = Drawing.Color.Blue
        End If
        
        Response.Redirect("VendorAdministrationControl.aspx?id=0&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&AA=" & _AllActive & "&C=0", True)
        
        
    End Sub
    Private Sub btnSCR_Click(ByVal S As Object, ByVal E As EventArgs)
        _lngRegionID = 4
        
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        
        
        drpPartners.SelectedValue = "Choose One"
        
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Filter By Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
        _AllActive = chkAllActive.Checked
        
        If _lngColor = 1 Then
            btnSCR.BorderColor = Drawing.Color.Black
        Else
            btnSCR.BorderColor = Drawing.Color.Blue
        End If
        
        Response.Redirect("VendorAdministrationControl.aspx?id=0&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&AA=" & _AllActive & "&C=0", True)
        
        
    End Sub
    Private Sub btnNCR_Click(ByVal S As Object, ByVal E As EventArgs)
        _lngRegionID = 5
        
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        
        
        drpPartners.SelectedValue = "Choose One"
        
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Filter By Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
        _AllActive = chkAllActive.Checked
        
        If _lngColor = 1 Then
            btnNCR.BorderColor = Drawing.Color.Black
        Else
            btnNCR.BorderColor = Drawing.Color.Blue
        End If
        
        Response.Redirect("VendorAdministrationControl.aspx?id=0&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&AA=" & _AllActive & "&C=0", True)
        
    End Sub
    Private Sub btnSWR_Click(ByVal S As Object, ByVal E As EventArgs)
        _lngRegionID = 6
        
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        
        
        drpPartners.SelectedValue = "Choose One"
        
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Filter By Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
        _AllActive = chkAllActive.Checked
        
        If _lngColor = 1 Then
            btnSWR.BorderColor = Drawing.Color.Black
        Else
            btnSWR.BorderColor = Drawing.Color.Blue
        End If
        
        Response.Redirect("VendorAdministrationControl.aspx?id=0&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&AA=" & _AllActive & "&C=0", True)
        

        
    End Sub
    Private Sub btnNWR_Click(ByVal S As Object, ByVal E As EventArgs)
        _lngRegionID = 7
        
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        
        
        drpPartners.SelectedValue = "Choose One"
        
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Filter By Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
        _AllActive = chkAllActive.Checked
        If _lngColor = 1 Then
            btnNWR.BorderColor = Drawing.Color.Black
        Else
            btnNWR.BorderColor = Drawing.Color.Blue
        End If
        
        Response.Redirect("VendorAdministrationControl.aspx?id=0&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&AA=" & _AllActive & "&C=0", True)
        
    End Sub
    Private Sub btnWR_Click(ByVal S As Object, ByVal E As EventArgs)
        _lngRegionID = 8
        
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        
        
        drpPartners.SelectedValue = "Choose One"
        
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Filter By Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
        _AllActive = chkAllActive.Checked
        If _lngColor = 1 Then
            btnWR.BorderColor = Drawing.Color.Black
        Else
            btnWR.BorderColor = Drawing.Color.Blue
        End If
        
        Response.Redirect("VendorAdministrationControl.aspx?id=0&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&AA=" & _AllActive & "&C=0", True)
        

        
    End Sub
    Private Sub btnAll_Click(ByVal S As Object, ByVal E As EventArgs)
        _lngRegionID = 9
        
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        
        
        drpPartners.SelectedValue = "Choose One"
        
        If drpCustomers1.SelectedValue <> "Filter By Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Filter By Program" Then
            lngProgramID = drpProgram.SelectedValue
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            lngStatusID = drpStatus.SelectedValue
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            lngStateID = drpState.SelectedValue
        Else
            lngStateID = 0
        End If
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
        _AllActive = chkAllActive.Checked
        If _lngColor = 1 Then
            btnAll.BorderColor = Drawing.Color.Black
        Else
            btnAll.BorderColor = Drawing.Color.Blue
        End If
        
        Response.Redirect("VendorAdministrationControl.aspx?id=0&RID=" & _lngRegionID & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & _chkNeedUpdate1 & "&AA=" & _AllActive & "&C=0", True)
        

        
    End Sub
    Protected Sub chkAll_OnCheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        
        For Each dgItem In dgvVendors.Items
            chkbox = dgItem.FindControl("chkselected")
            If Not chkbox.Checked Then
                chkbox.Checked = True
            Else
                chkbox.Checked = False
            End If
        Next
    End Sub
    Protected Sub chkNeedUpdateID_OnCheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        _chkNeedUpdate1 = chkNeedUpdateID.Checked
    End Sub
    Protected Sub chkSendEmail_OnCheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If chkSendEmail.Checked = True Then
            rowSendEmail.visible = True
        Else
            rowSendEmail.visible = False
        End If
    End Sub
    Protected Sub chkAllActive_OnCheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        _AllActive = chkAllActive.Checked
    End Sub
    Protected Sub chkSelected_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ck1 As CheckBox = CType(sender, CheckBox)
        Dim CheckedItems As ArrayList = New ArrayList
        Dim dgItem As DataGridItem = CType(ck1.NamingContainer, DataGridItem)
                             
        If Ck1.Checked Then
            If Not IsNothing(Session("CheckedItems")) Then
                CheckedItems = Session("CheckedItems")
            End If
            'Add to Session if it doesnt already exist            
            If Not CheckedItems.Contains(dgitem.Cells.Item(1).text) Then
                CheckedItems.Add(dgItem.Cells.Item(1).text)
            End If
         
        Else
            'Remove value from Session when unchecked            
            CheckedItems.Remove(dgItem.Cells.Item(1).text)
        End If
    End Sub
    Private Sub btnSendEmail_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        Dim intCount As Integer
        Dim strEmailAddress As String
        
        Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wbl.Load(Master.WebLoginID)
        Dim strUserName As String
        strUserName = wbl.Login

        intCount = 0
        
        For Each dgItem In dgvVendors.Items
            chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                
                strEmailAddress = dgItem.Cells(3).Text
                
                eml.SendFrom = strUserName & "@bestservicers.com"
                eml.Subject = txtSubject.Text
                eml.Body = txtEmailBody.Text.Replace(Environment.NewLine, "<br>")
                eml.SendTo = strEmailAddress
                eml.Send()
                
                intCount = intCount + 1
            End If
        Next
        txtSubject.Text = ""
        txtEmailBody.Text = "The total of " & intCount & " email(s) have been sent out."
        
        
    End Sub

    Private Sub menu5_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu5.MenuItemClick
        Multiview1.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0
                
            Case Is = 1
                LoadNeedPartsReturned()
            
                
                
        End Select
        
    End Sub
    Private Sub LoadNeedPartsReturned()
        
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If drpPartners.SelectedValue = "Choose One" Then
            ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedByPartnerID", "@PartnerID", _ID, dgvOpenWorkOrders)
            'ldr.LoadSingleLongParameterDataGrid("spListRequireSignatureDispatchedPartnerWorkOrders", "@PartnerID", Master.PartnerID, Me.dgvRequireUpload)
        Else
            ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedByPartnerID", "@PartnerID", CType(drpPartners.SelectedValue, Long), dgvOpenWorkOrders)
        End If
        lblTicketCount1.Text = " [ " & CType(dgvOpenWorkOrders.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

        
    End Sub
    Private Sub btnExport_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Dim ex As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     
        If dgvOpenWorkOrders.Items.Count > 0 Then
            ex.ExportGrid("PartsNotReturned.xls", dgvOpenWorkOrders)
        End If
    End Sub
   
    
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server">
    <table style="width: 100%;border:2px">
      <tbody>
        <tr style="width: 100%" >
          <td class="band" colspan="2">
            <div class="bandheader">Select Region</div>
            <asp:Button ID="btnSER" runat="server" Text="S.East" OnClick="btnSER_Click" />&nbsp;<asp:Button ID="btnNER" runat="server" Text="N.East" OnClick="btnNER_Click"/>&nbsp;<asp:Button ID="btnMWR" runat="server" Text="Midwest" OnClick="btnMWR_Click" />&nbsp;<asp:Button ID="btnSCR" runat="server" Text="S.Central" OnClick="btnSCR_Click"/>&nbsp;<asp:Button ID="btnNCR"  runat="server" Text="N.Central" OnClick="btnNCR_Click" />&nbsp;<asp:Button ID="btnSWR" runat="server" Text="S.West" OnClick="btnSWR_Click" />&nbsp;<asp:Button ID="btnNWR" runat="server" Text="N.West" OnClick="btnNWR_Click" />&nbsp;<asp:Button ID="btnWR" runat="server" Text="West" OnClick="btnWR_Click" />&nbsp;<asp:Button ID="btnAll" runat="server" Text="All" OnClick="btnAll_Click" />&nbsp;<asp:CheckBox ID="chkNeedUpdateID" runat="server" Text="NeedUpdate" AutoPostBack="True" OnCheckedChanged ="chkNeedUpdateID_OnCheckedChanged"/>&nbsp;<asp:CheckBox ID="chkSendEmail" runat="server" Text="Email"  AutoPostBack = "True" OnCheckedChanged ="chkSendEmail_OnCheckedChanged" />&nbsp;<asp:CheckBox ID="chkAllActive" runat="server" Text="AllActive" AutoPostBack="True" OnCheckedChanged ="chkAllActive_OnCheckedChanged" />&nbsp;<asp:DropDownList ID="drpAgents" runat="server" AutoPostBack="true" visible="False" />&nbsp;&nbsp;<asp:Label ID="lblLaunchEmail" runat ="server" ></asp:Label>
            <div class="bandheader">&nbsp;</div>
          </td>
        </tr>
        <tr id="rowSendEmail"  runat="server" visible="false">
            <td colspan = "2" align="right"><asp:TextBox ID="txtSubject" runat="server" ToolTip="Enter Email Subject"  Width="98%"/><asp:TextBox ID="txtEmailBody" runat="server" TextMode="MultiLine" style="width: 100%" Height="75px" /><asp:Button ID="btnSendEmail" Text="Send Email" OnClick="btnSendEmail_Click" runat="server" /></td>
        </tr>
        <tr style="width: 20%">
          <td class="band" style="width: 1%" >
            <div class="bandheader">Vendor</div>
            <asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartners_SelectedIndexChanged" />
            <div class="bandheader">Vendors List</div>
            <asp:DataGrid ID="dgvVendors" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" Width ="100%">
              <ItemStyle CssClass="bandbar" />
              <Columns>
              <asp:TemplateColumn>
               <HeaderTemplate>
               <asp:CheckBox id="chkAll" runat="server"  OnCheckedChanged ="chkAll_OnCheckedChanged" AutoPostBack = "True"></asp:CheckBox>
               </HeaderTemplate>
               <ItemTemplate>
            <asp:CheckBox ID="chkSelected" runat="server" AutoPostBack ="False" OnCheckedChanged="chkSelected_CheckedChanged" visible="True"/>
              </ItemTemplate>
              </asp:TemplateColumn>
                <asp:BoundColumn DataField="PartnerID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText ="Partner" >
                  <ItemTemplate>
                    <a href="VendorAdministrationControl.aspx?RID=<%=_lngRegionID%>&NP=<%=_chkNeedUpdate1%>&AA=<%=_AllActive%>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>"><%# DataBinder.Eval(Container.DataItem,"ResumeID") %></a>&nbsp;(<%# DataBinder.Eval(Container.DataItem,"Total") %>)
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="Email" HeaderText="Email" Visible="false" />      
              </Columns> 
            </asp:DataGrid>
          </td>
          <td>
          <div id="tab5">
          <asp:Menu ID="menu5" runat="server" Orientation="Horizontal" OnMenuItemClick ="menu5_MenuItemClick" CssClass="ul">
             <StaticMenuItemStyle CssClass="li" />
             <StaticHoverStyle CssClass="hoverstyle" />
             <StaticSelectedStyle CssClass="current" />
             <Items>
                <asp:MenuItem  value ="0" Text="Tickets"></asp:MenuItem>
                <asp:MenuItem value ="1" Text="Need Parts Returned"></asp:MenuItem> 
             </Items>
           </asp:Menu>
          </div>
            <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
            <asp:View ID="viewTickets"  runat="server" >
            <div id="ratesheader" class="tabbody">&nbsp;</div>
            <div class="inputformsectionheader">
                <asp:Label ID="lblTicketCount" runat="server" ></asp:Label>
                <asp:DropDownList ID="drpCustomers1" Runat="server" AutoPostBack="True" OnSelectedIndexChanged="drpCustomers1_SelectedIndexChanged"/>
                
                <asp:DropDownList ID="drpStatus" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpProgram" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpState" Runat="server" AutoPostBack="True" />&nbsp;&nbsp;<asp:Label ID="lblTechName" runat ="server"></asp:Label>
            </div>
            <div class="inputform">
              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand">
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                  <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                      <a target="_blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><img style="border: 0" alt="Printable Version" src="/graphics/printable.png" /></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
		            <asp:BoundColumn SortExpression="Age" HeaderText="Age" DataField="Age" />
                  <asp:TemplateColumn SortExpression="CustomerID" HeaderText="Customer">
                    <ItemTemplate>
                      <a href="customer.aspx?id=<%# DataBinder.Eval(Container.DataItem,"CustomerID") %>"><%#DetermineCustomerLabel(DataBinder.Eval(Container.DataItem, "Company"), DataBinder.Eval(Container.DataItem, "CompanyContact"))%></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn SortExpression="Status" HeaderText="Status" DataField="Status" />
                  <asp:BoundColumn SortExpression="ContactLastName" HeaderText="EULastName" DataField="ContactLastName" />
                  <asp:BoundColumn SortExpression="ServiceType" HeaderText="Program" DataField="ServiceType" />
                  <asp:TemplateColumn SortExpression="ServiceID" HeaderText="Service SKU">
                    <ItemTemplate>
                      <a target="_blank" href="servicedetail.aspx?id=<%# DataBinder.Eval(Container.DataItem,"ServiceID") %>"><%# DataBinder.Eval(Container.DataItem,"ServiceName") %></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  
                  <asp:TemplateColumn
                    SortExpression="CustomerPrioritySetting"
                    HeaderText="C&nbsp;Priority"
                    >
                  <ItemTemplate>
                    <img alt="Internal Priority" src="../graphics/level<%# Databinder.eval(Container.DataItem,"CustomerPrioritySetting") %>.png" />          
                  </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn SortExpression="City" DataField="City" HeaderText="City" />
                  <asp:BoundColumn SortExpression="County" DataField="County" HeaderText="County" />
                  <asp:BoundColumn SortExpression="Abbreviation" DataField="Abbreviation" HeaderText="State" />                  
                  <asp:TemplateColumn
                    SortExpression="ZipCode"
                    HeaderText="Zip"
                    >
                    <ItemTemplate>
                      <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>&id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %> " target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>                  
                  <asp:BoundColumn SortExpression="ETA" HeaderText="ETA" DataField="ETA" Visible="True" />        
                  <asp:BoundColumn SortExpression="ScheduledEndDate" HeaderText="Schedule Date" DataField="ScheduledEndDate" />        
                </Columns>
              </asp:DataGrid>
            </div>
            </asp:View>
            <asp:View ID="NeedReturnParts"  runat="server">
            <div id="ratesheader1" class="tabbody" >&nbsp;</div>
            <div ><asp:ImageButton ID="btnExport" AlternateText ="Export to Excel" ImageUrl ="/images/Excel-16.gif"  ImageAlign="right"  OnClick="btnExport_Click" runat="server"/></div> 
            <div class="inputformsectionheader">&nbsp;</div>
            <div class="inputformsectionheader" ><asp:Label ID="lblTicketCount1" runat="server"></asp:Label> Tickets Needing Part Returned</div>
            <asp:DataGrid ID="dgvOpenWorkOrders" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false">
              <HeaderStyle CssClass="gridheader" />
               <AlternatingItemStyle CssClass="altrow" />
                 <Columns>
                   <asp:TemplateColumn HeaderText="Ticket ID">
                     <ItemTemplate>
                        <a target="_blank" href="ticket.aspx?id=<%# Databinder.Eval(Container.DataItem,"TicketID") %>&returnurl=workoders.aspx&act=G"><%# Databinder.Eval(Container.DataItem,"TicketID") %></a>
                     </ItemTemplate>
                   </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="Age" DataField="Age" />
                  <asp:BoundColumn HeaderText="Customer" DataField="Company" />
                  <asp:BoundColumn HeaderText="TypeOfService" DataField="ServiceName" />
                  <asp:BoundColumn HeaderText="Status" DataField="Status" />
                  <asp:BoundColumn HeaderText="PartNumber" DataField="Code" />
                  <asp:BoundColumn HeaderText="Description" DataField="Component" />
                  <asp:BoundColumn HeaderText="PartCost" DataField="PartCost" DataFormatString="{0:c}"/>
                  <asp:BoundColumn HeaderText="ReturnType" DataField="Destination" />
                  <asp:TemplateColumn HeaderText="TrackingNumber">
                          <ItemTemplate>
                            <a target="_blank" href="<%# Databinder.eval(Container.DataItem,"TrackingScript").ToString.Replace("$shippinglabel",DataBinder.Eval(Container.DataItem,"ShippingLabel")) %>"><%# DataBinder.Eval(Container.DataItem,"ShippingLabel") %></a>                    
                          </ItemTemplate>
                        </asp:TemplateColumn>
               </Columns>      
            </asp:DataGrid>
           </asp:View>
            </asp:MultiView>
            </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>