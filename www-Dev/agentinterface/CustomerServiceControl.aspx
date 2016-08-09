<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

    Private _ID As Long = 0
    Private _lngCustID As Long = 0
    Private _infoID As Long = 0
  Private lngIt as long 
    Private _lngETA As Long = 0
    Private _lngStatusID As Long = 0
    Private _lngStateID As Long = 0
    Private _lngProgramID As Long = 0
    Private _chkNeedUpdate As Boolean = False
    Private _lngColor As Long = 1
    Private _ParID As Long = 0
    Private _CountryID As Long = 1
    Private _UserID As Long = 0
    Private _Closed As Long = 0
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Customer Service Control"
            Master.PageTitleText = "Customer Service Control"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Customer Service Control"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try        
    Try
      _lngETA = CType(Request.QueryString("eta"), Long)       
    Catch ex As Exception 
      _lngETA = 0
    End Try 
    Try
      _infoID = CType(Request.QueryString ("infoID"),Long)
    Catch ex As Exception 
      _infoID = 0
        End Try
        Try
            _ParID = CType(Request.QueryString("parid"), Long)
        Catch ex As Exception
            _ParID = 0
        End Try
    Try
      _lngCustID = CType(Request.QueryString("CustID"), Long)
    Catch ex As Exception 
     _lngCustID = 0
    End Try         
    Try
      _lngStatusID = CType(Request.QueryString("StatusID"), Long)
    Catch ex As Exception 
     _lngStatusID = 0
    End Try        
    Try
      _lngProgramID = CType(Request.QueryString("ProgID"), Long)
    Catch ex As Exception
     _lngProgramID = 0
    End Try        
    Try
     _lngStateID = CType(Request.QueryString("StateID"), Long)
    Catch ex As Exception
     _lngStateID = 0
    End Try        
    Try
      _chkNeedUpdate = CType(Request.QueryString("NP"), Boolean)
    Catch ex As Exception
     _chkNeedUpdate = 0
    End Try        
    Try
     _lngColor = CType(Request.QueryString("C"), Long)
    Catch ex As Exception
     _lngColor = 0
    End Try        
    Try
     _UserID = CType(Request.QueryString("UserID"), Long)
    Catch ex As Exception
     _UserID = 0
    End Try        
    Try
     _Closed = CType(Request.QueryString("Cl"),Long)
    Catch ex As Exception 
    _Closed = 0
    End Try        

    Dim inf As New BridgesInterface.CompanyInfoRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))      
    inf.Load(_ID)
      
    If Master.InfoID <> _infoID Then
      Response.Redirect("/logout.aspx")
    End If
    If Not Page.IsPostBack Then
            
            LoadCustomers()
            LoadStates()
            LoadPrograms()
            LoadStatus()
            LoadAgents()
            LoadCSRs()
            
            If _lngETA <> 0 Then
                drpCustomers1.SelectedValue = _lngCustID
                drpStatus.SelectedValue = _lngStatusID
                drpState.SelectedValue = _lngStateID
                chkNeedUpdateID.Checked = _chkNeedUpdate
                If drpCustomers1.SelectedValue <> "Assign Customer" And drpProgram.SelectedValue = "Assign Program" Then
                    LoadPrograms1(drpCustomers1.SelectedValue)
                End If
                drpProgram.SelectedValue = _lngProgramID
                drpCSR.SelectedValue = _UserID
                If _lngETA = 1 Then
                    btnETA1.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    drpCSR.SelectedValue = _UserID
                    
                End If
                If _lngETA = 2 Then
                    btnETA2.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    drpCSR.SelectedValue = _UserID
                    
                End If
                If _lngETA = 3 Then
                    btnETA3.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    drpCSR.SelectedValue = _UserID
                    
                End If
                If _lngETA = 4 Then
                    btnAll.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    
                End If
                If _lngETA = 5 Then
                    btnMissed.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = True
                    LoadPartners()
                    If _ParID > 0 Then
                        drpPartners.SelectedValue = _ParID
                    End If
                    
                End If
                
                If _lngETA = 6 Then
                    btnSurvey.BorderColor = Drawing.Color.Blue
                    drpPartners.Visible = False
                    
                End If
                If _lngETA = 7 Then
                    btnNeedApptSet.BorderColor = Drawing.Color.Blue
                    
                    drpPartners.Visible = False
                    Multiview1.ActiveViewIndex = 1
                    Multiview2.ActiveViewIndex = 0
                    chkNeedUpdateID.Visible = False
                    If _chkNeedUpdate <> 0 Then
                        
                        LoadPartners2(_UserID)
                        drpPartners2.SelectedValue = _ParID
                        LoadPartnersList(_UserID)
                        
                        If _ParID <> 0 Then
                            For Each itm As DataGridItem In dgvVendors2.Items
                                If CType(itm.Cells(0).Text, Long) = _ParID Then
                                    itm.CssClass = "selectedbandbar"
                                End If
                            Next
                            'LoadTicketsByPartners2(2, _ParID)
                        End If
                        chkNeedUpdateID.Checked = False
                    Else
                        drpCSR.SelectedValue = _UserID
                        LoadPartners2(_UserID)
                        'drpPartners2.SelectedValue = _ParID
                        LoadPartnersList(_UserID)
                        If _UserID = 14 Then
                            chkNeedUpdateID.Visible = True
                        Else
                            chkNeedUpdateID.Visible = False
                        End If
                        If _ParID <> 0 Then
                            For Each itm As DataGridItem In dgvVendors2.Items
                                If CType(itm.Cells(0).Text, Long) = _ParID Then
                                    itm.CssClass = "selectedbandbar"
                                End If
                            Next
                        End If
                        ' LoadTicketsByPartners2(33, _ParID)
                    End If
                End If
                If _lngETA = 0 Then
                    'btnETA1.BorderColor = Drawing.Color.Black
                    btnETA2.BorderColor = Drawing.Color.Black
                    btnETA3.BorderColor = Drawing.Color.Black
                    btnAll.BorderColor = Drawing.Color.Black
                    drpPartners.Visible = False
                    
                End If
                If _ParID = 0 Then
                    If _Closed = 0 then
                       LoadTickets(2, _lngETA)
                    Else
                        If _lngETA = 6 Then
                            LoadTickets(22, _lngETA)
                        Else
                            LoadTickets(15, _lngETA)
                        End If
                        
                    end if
                Else
                    If _lngETA <> 7 Then
                        LoadTickets(7, _lngETA)
                        Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                        Dim res As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                        par.Load(_ParID)
                        Dim strEmailLink As String

                        strEmailLink = "<a href='mailto:" & par.Email & "'>Send Email</a>"

                        lblSendEmail.Text = strEmailLink
                        res.Load(par.ResumeID)
                    
                        lblTechName.Text = res.FirstName & " " & res.LastName
                    Else
                        If _chkNeedUpdate <> 0 Then
                            LoadTicketsByPartners2(2, _ParID)
                        Else
                            LoadTicketsByPartners2(33, _ParID)
                        End If
                        Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                        Dim res As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                        par.Load(_ParID)
                        Dim strEmailLink As String

                        strEmailLink = "<a href='mailto:" & par.Email & "'>Send Email</a>"
                        lblSendEmail.Text = strEmailLink
                    
                        res.Load(par.ResumeID)
                    
                        lblTechName.Text = res.FirstName & " " & res.LastName
                    End If
                End If
            Else
                drpPartners.Visible = False
            End If
            
        Else
             
            If drpCustomers1.SelectedValue <> "Assign Customer" And drpProgram.SelectedValue = "Assign Program" Then
                LoadPrograms1(drpCustomers1.SelectedValue)
                If _lngETA <> 0 Then
                    LoadTickets(2, _lngETA)
                    
                Else
                    LoadTickets(0, 0)
                    
                End If
                
            Else
                If drpProgram.SelectedValue = "Assign By Program" Then
                    drpProgram.Items.Clear()
                    drpProgram.Items.Add("Assign Program")
                    drpProgram.SelectedValue = "Assign Program"
                Else
                    If _ParID = 0 Then
                        If _lngETA <> 7 Then
                            LoadTickets(2, _lngETA)
                        Else
                            If _lngETA = 6 Then
                               LoadTickets(22, _lngETA)
                            Else
                                LoadTicketsByPartners2(33, _ParID)
                            End If
                           
                        End If
                    Else
                        If _lngETA <> 7 Then
                            LoadTickets(7, _lngETA)
                        Else
                            LoadTicketsByPartners2(33, _ParID)
                        End If
                    End If
                End If
            End If
        End If
       
        
    End Sub
  
    Private Sub LoadTickets(ByVal lngTicketFolderID As Long, ByVal lngETA As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim lngAge1 As Long
        Dim lngAge2 As Long
       
        drpCustomers1.Visible = false
        If drpCustomers1.SelectedValue <> "Assign Customer" then
        _lngCustID = drpCustomers1.SelectedValue 
        end if
        drpStatus.Visible = False
        drpProgram.Visible = false
        If drpProgram.SelectedValue <> "Assign Program" then
        _lngProgramID = drpProgram.SelectedValue 
        end if
        drpState.Visible = false
        If drpState.SelectedValue <> "Filter By State" then
          _lngStateID = drpState.SelectedValue 
        end if
        drpCSR.Visible = True
        If lngETA = 1 Then
            lngAge1 = CType(0, Long)
            lngAge2 = CType(7, Long)
        End If
        If lngETA = 2 Then
            lngAge1 = CType(8, Long)
            lngAge2 = CType(15, Long)
        End If
        If lngETA = 3 Then
            lngAge1 = CType(16, Long)
            lngAge2 = CType(6000, Long)
        End If
        If lngETA = 4 Then
            lngAge1 = 0
            lngAge2 = 6000
        End If
        If _lngETA < 5 Then
            If drpCustomers1.SelectedValue <> "Assign Customer" Then
                If _lngStatusID <> 0 Then
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCSPSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadNineLongParameterDataGrid("spListTicketsInFolderByCSPSETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    'ldr1.LoadNineLongParameterDataGrid("spCountListTicketsInFolderByCSPSETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                    ldr1.LoadEightLongParameterDataGrid("spCountListTicketsInFolderByCPSETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCSPSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    'ldr1.LoadEightLongParameterDataGrid("spCountListTicketsInFolderByCSPSETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                    ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCPSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                            End If
                        Else
                            'Filter by Customer, status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSPETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCSPETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCSPETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    'ldr1.LoadEightLongParameterDataGrid("spCountListTicketsInFolderByCSPETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                    ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCStateETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSPETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    'ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCSPETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCPETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)

                                End If
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by customer, Status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCSSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCSSETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    'ldr1.LoadEightLongParameterDataGrid("spCountListTicketsInFolderByCSSETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                    ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCStateETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSSETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    'ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCSSETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCStateETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                            End If
                        Else
                            'Filter by Customer Status
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    'ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCSETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCustomerETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    'ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCSETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                    ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByCustomerETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)

                                End If
                            End If
                        End If

                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, Program and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCPSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCPSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCPSETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadEightLongParameterDataGrid("spCountListTicketsInFolderByCPSETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCPSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCPSETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                            End If
                        Else
                            'Filter By Customer, Program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCPETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCPETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCPETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCPETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCPETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCPETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Customer, State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCStateETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCStateETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCStateETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByCStateETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCStateETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCStateETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                            End If
                        Else
                            'Filter By Customer
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCustomerETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByCustomerETA1", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCustomerETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByCustomerETA2", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)

                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCustomerETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByCustomerETA", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)

                                End If
                            End If
                        End If
                    End If

                End If
            Else
                If _lngStatusID <> 0 Then
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByStatusStateETA1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByStatusStateETA2", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByStatusStateETA2", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByStatusStateETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                                
                            End If
                        Else
                            'Filter By Status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByStatusETA1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                           
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusETA2", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByStatusETA2", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    If _lngStatusID <> 0 Then
                                        ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByStatusETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                    Else
                                        ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByStatusETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                    End If
                                End If
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByStatusStateETA1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByStatusStateETA2", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSevenLongParameterDataGrid("spCountListTicketsInFolderByStatusStateETA2", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByStatusStateETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                            End If
                        Else
                            'Filter By Status
                            If chkNeedUpdateID.Checked = True Then
                                If drpCSR.SelectedValue <> "CSR All" then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusETA2A", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByETA2A", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)

                                Else
                                   If _Closed = 0 then
                                      ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                     'ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByStatusETA1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                     ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                     ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByETA3", "@TicketFolderID", 15, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses2)

                                   else
                                      ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                     'ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByStatusETA1", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                     ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                     ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByETA3", "@TicketFolderID", 15, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses2)

                                   end if
                                end if

                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusETA2", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByETA2", "@TicketFolderID",2, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByETA3A", "@TicketFolderID", 15, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses2)
                                Else
                                    
                                    If _Closed = 0 then
                                      ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                      ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA", "@TicketFolderID",lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                      ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA3", "@TicketFolderID", 15, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses2)
                                    else
                                      ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA", "@TicketFolderID", lngTicketFolderID, "@TicketStatusID", _lngStatusID, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                      ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA", "@TicketFolderID",2, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                      ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA3", "@TicketFolderID", 15, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses2)

                                    end if

                                End If
                            End If
                        End If
                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA1", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByStateETA1", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStateETA2", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByStateETA2", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByStateETA", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                            End If
                        Else
                            'Filter By Program
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA1", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", "CountryID", _CountryID, lngAge2, dgvTickets)
                                ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByStateETA1", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", "CountryID", _CountryID, lngAge2, dgvStatuses)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStateETA2", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByStateETA2", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByStateETA", "@TicketFolderID", lngTicketFolderID, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                            End If
                        Else
                            'Dont filter - Show all the tickets in the folder
                            If chkNeedUpdateID.Checked = True Then
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByETA2A", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                    ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByETA2A", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID,"@UserID", _UserID, dgvStatuses)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByETA1", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                    ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA1", "@TicketFolderID",lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                End If
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    If _Closed = 0 then
                                        ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByETA2", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                      ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByETA2", "@TicketFolderID",lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                      ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByETA3A", "@TicketFolderID",15, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses2)
                                    else
                                        ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByETA2", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                                      ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByETA2", "@TicketFolderID",lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses)
                                      ldr1.LoadSixLongParameterDataGrid("spCountListTicketsInFolderByETA3A", "@TicketFolderID",15, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvStatuses2)

                                    end if
                                Else
                                    If _Closed = 0 then
                                        ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByETA", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                       ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA3", "@TicketFolderID", 15, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses2)
                                       ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA", "@TicketFolderID",lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)
                                    Else
                                        ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByETA3", "@TicketFolderID", lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets)
                                       ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA3", "@TicketFolderID", 15, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses2)
                                       ldr1.LoadFiveLongParameterDataGrid("spCountListTicketsInFolderByETA", "@TicketFolderID",lngTicketFolderID, "@Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvStatuses)

                                    end if

                                End If
                            End If
                        End If
                    End If
                End If
        
            End If
        Else
            
            If _ParID = 0 Then
                If _lngETA = 5 Then
                    If drpCSR.SelectedValue <> "CSR All" Then
                        ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolder2", "@TicketFolderID", 7, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                    Else
                        ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolder", "@TicketFolderID", 7, "CountryID", _CountryID, dgvTickets)
                    End If
                    
                Else
                    If _lngETA <> 7 Then
                        If drpCSR.SelectedValue <> "CSR All" Then
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolder2", "@TicketFolderID", 22, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                        Else
                            ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolder", "@TicketFolderID", 22, "CountryID", _CountryID, dgvTickets)
                        End If
                    End If
                        If _lngETA = 7 Then
                            If drpCSR.SelectedValue <> "CSR All" Then
                                ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartner2", "@TicketFolderID", 7, "@PartnerID", _ParID, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets2)
                            Else
                                ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 7, "@PartnerID", _ParID, "CountryID", _CountryID, dgvTickets2)
                            End If
                        
                        End If
                    End If
            Else
                
                If _lngETA = 7 Then
                    If drpCSR.SelectedValue <> "CSR All" Then
                        ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartner2", "@TicketFolderID", 7, "@PartnerID", _ParID, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets2)
                    Else
                        ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 7, "@PartnerID", _ParID, "CountryID", _CountryID, dgvTickets2)
                    End If
                   
                Else
                    If drpCSR.SelectedValue <> "CSR All" Then
                        ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartner2", "@TicketFolderID", 7, "@PartnerID", _ParID, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets)
                    Else
                        ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 7, "@PartnerID", _ParID, "CountryID", _CountryID, dgvTickets)
                    End If
                End If
            
            End If
        End If
        If _lngETA < 6 Then
            If _lngStatusID <> 0 Then
                For Each itm As DataGridItem In dgvStatuses.Items
                    If CType(itm.Cells(0).Text, Long) = _lngStatusID Then
                        itm.CssClass = "selectedbandbar"
                    End If
                Next
            End If
        End If
        If _lngETA <> 7 Then
            Dim lngTotal1 As Long
            Dim lngTotal2 As Long
            lblTicketCount.Text = " [ " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "
            
            lngTotal1 = 0
             
            If drpCSR.SelectedValue <> "CSR All" Then
                lblUntouched.Text = " U: " & GetTotalUntouchedTicketsByUser(CType(drpCSR.SelectedValue, Long))
                lngTotal2 = GetTotalTicketsByUser(2, 1, CType(drpCSR.SelectedValue, Long))
                If lngTotal2 <> 0 Then
                    lngTotal1 = ((GetTotalOldTicketsByUser(2, 0, 16, 6000, 1, CType(drpCSR.SelectedValue, Long)) * 100) / lngTotal2)
                End If
                lblOldTickets.Text = " O: " & lngTotal1 & "%"
            Else
                lblUntouched.Text = " U: " & GetTotalUntouchedTickets()
                lngTotal2 = GetTotalTickets(2, 1)
                If lngTotal2 <> 0 Then
                    lngTotal1 = ((GetTotalOldTickets(2, 0, 16, 6000, 1) * 100) / lngTotal2)
                End If
                lblOldTickets.Text = " O: " & lngTotal1 & "%"
            End If
            'lblTicketCount.Text = lngTotal2
        Else
            lblTicketCount.Text = " [ " & CType(dgvTickets2.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

        End If
    End Sub

    Private Sub LoadTicketsByCustomer(ByVal lngTicketFolderID As Long, ByVal lngCustomerID As Long)
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", lngTicketFolderID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "

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
        Dim lngAge1 As Long
        Dim lngAge2 As Long
        
        If lblSortOrder.Text.ToLower = " asc" Then
            lblSortOrder.Text = " desc"
        Else
            lblSortOrder.Text = " asc"
        End If
        
        If _lngETA = 1 Then
            lngAge1 = CType(0, Long)
            lngAge2 = CType(7, Long)
        End If
        If _lngETA = 2 Then
            lngAge1 = CType(8, Long)
            lngAge2 = CType(15, Long)
        End If
        If _lngETA = 3 Then
            lngAge1 = CType(16, Long)
            lngAge2 = CType(6000, Long)
        End If
        If _lngETA = 4 Then
            lngAge1 = 0
            lngAge2 = 6000
        End If
        
        
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If _lngETA < 5 Then
            If drpCustomers1.SelectedValue <> "Assign Customer" Then
                If _lngStatusID <> 0 Then
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCSPSETA1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadNineLongParameterDataGrid("spListTicketsInFolderByCSPSETA2", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCSPSETA", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        Else
                            'Filter by Customer, status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSPETA1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCSPETA2", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSPETA", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by customer, Status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSSETA1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCSSETA2", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", "@UserID", _UserID, _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSSETA", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        Else
                            'Filter by Customer Status
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSETA1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCSETA2", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSETA", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        End If

                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, Program and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCPSETA1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadEightLongParameterDataGrid("spListTicketsInFolderByCPSETA2", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCPSETA", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        Else
                            'Filter By Customer, Program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCPETA1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCPETA2", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCPETA", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Customer, State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCStateETA1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByCStateETA2", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCStateETA", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        Else
                            'Filter By Customer
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCustomerETA1", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCustomerETA2", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCustomerETA", "@TicketFolderID", 2, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        End If
                    End If

                End If
            Else
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status, Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA1", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByStatusStateETA2", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        Else
                            'Filter By Status and program
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA1", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusETA2", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status and State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA1", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSevenLongParameterDataGrid("spListTicketsInFolderByStatusStateETA2", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusStateETA", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        Else
                            'Filter By Status
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA1", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStatusETA2", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStatusETA", "@TicketFolderID", 2, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        End If
                    End If
                Else
                    If drpProgram.SelectedValue <> "Assign Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Program and state
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA1", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStateETA2", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        Else
                            'Filter By Program
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By State
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA1", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByStateETA2", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByStateETA", "@TicketFolderID", 2, "@StateID", CType(drpState.SelectedValue, Long), "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        Else
                            'Dont filter - Show all the tickets in the folder
                            If chkNeedUpdateID.Checked = True Then
                                ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByETA1", "@TicketFolderID", 2, "Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                            Else
                                If drpCSR.SelectedValue <> "CSR All" Then
                                    ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByETA2", "@TicketFolderID", 2, "Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, "@UserID", _UserID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                Else
                                    ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByETA", "@TicketFolderID", 2, "Temp", 0, "@Age1", lngAge1, "@Age2", lngAge2, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                                End If
                            End If
                        End If
                    End If
                End If
            End If
        Else
            ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolder", "@TicketFolderID", 7, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
        End If
    End Sub
 
  Private Sub LoadCustomers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDropDownList ("spListActiveCustomersByInfoID","@InfoID",_infoID,"Company","CustomerID",drpCustomers1)
        drpCustomers1.Items.Add("Assign Customer")
        drpCustomers1.SelectedValue = "Assign Customer"
    End Sub
    Private Sub LoadStates()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListStates", "StateName", "StateID", drpState)
        drpState.Items.Add("Filter By State")
        drpState.SelectedValue = "Filter By State"
        
        
    End Sub
    Private Sub LoadPrograms()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        drpProgram.Items.Add("Assign Program")
        drpProgram.SelectedValue = "Assign Program"
        
    End Sub
    Private Sub LoadStatus()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSingleLongParameterDropDownList ("spListStatusesForCustomerServiceByInfoID","@InfoID",_infoID,"Status","TicketStatusID",drpStatus)
        drpStatus.Items.Add("Filter By Status")
        drpStatus.SelectedValue = "Filter By Status"
        'ldr.LoadSimpleDataGrid("spListStatusesForCustomerService",dgvStatuses )
        
        
    End Sub
 

    Private Sub btnEmail_Click(ByVal S As Object, ByVal E As EventArgs)
        'drpCustomers.selectedValue = "Choose one"
        'LoadTicketsByPartners(CType(Request.QueryString("id"), Long),Ctype(drpPartners.SelectedValue,long) )
    
    End Sub
    Protected Sub drpCustomers1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            LoadPrograms1(drpCustomers1.SelectedValue)
            
        End If
    End Sub
    Private Sub LoadPrograms1(ByVal lngCustomerID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadSimpleDropDownList("spListServiceTypes", "ServiceType", "CustomerID", drpProgram)
        ldr.LoadSingleLongParameterDropDownList("spListServiceTypes", "@CustomerID", lngCustomerID, "ServiceType", "ServiceTypeID", drpProgram)
        
        drpProgram.Items.Add("Assign Program")
        drpProgram.SelectedValue = "Assign Program"
       
        
    End Sub
    Private Sub LoadAgents()
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadTwoLongParameterDropDownList("spListAgentsByPositionIDAndInfoID","@PositionID",CType(9,Long),"@InfoID",_infoID,"UserName","UserID",drpAgents)

        drpAgents.Items.Add("Assign Agent")
        drpAgents.SelectedValue = "Assign Agent"
        
    End Sub
    Private Sub btnETA1_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        Dim lngUserID As Long
        
        _lngETA = 1
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            'lngCustomerID = drpCustomers1.SelectedValue
             lngCustomerID = 0
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            'lngProgramID = drpProgram.SelectedValue
            lngProgramID = 0
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            'lngStatusID = drpStatus.SelectedValue
            lngStatusID = 0
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            'lngStateID = drpState.SelectedValue
            lngStateID = 0
        Else
            lngStateID = 0
        End If
        If drpCSR.SelectedValue <> "CSR All" Then
            lngUserID = drpCSR.SelectedValue
        Else
            lngUserID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            'btnAll.BorderColor = Drawing.Color.Black
        Else
            btnAll.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngETA)
        If drpCSR.SelectedValue = "CSR All" Then
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        Else
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0&UserID=" & lngUserID, True)
        End If
    End Sub
    Private Sub btnETA2_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        Dim lngUserID As Long
        _lngETA = 2
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            'lngCustomerID = drpCustomers1.SelectedValue
            lngCustomerID = 0
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            'lngProgramID = drpProgram.SelectedValue
             lngProgramID = 0
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            'lngStatusID = drpStatus.SelectedValue
            lngStatusID = 0
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            'lngStateID = drpState.SelectedValue
            lngStateID = 0
        Else
            lngStateID = 0
        End If
        If drpCSR.SelectedValue <> "CSR All" Then
            lngUserID = drpCSR.SelectedValue
        Else
            lngUserID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            'btnAll.BorderColor = Drawing.Color.Black
        Else
            btnAll.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngETA)
        If drpCSR.SelectedValue = "CSR All" Then
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        Else
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0&UserID=" & lngUserID, True)
        End If

    End Sub
    Private Sub btnETA3_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        Dim lngUserID As Long
        _lngETA = 3
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            'lngCustomerID = drpCustomers1.SelectedValue
            lngCustomerID = 0
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            'lngProgramID = drpProgram.SelectedValue
            lngProgramID = 0
        Else
            lngProgramID = 0
        End If
        If drpStatus.SelectedValue <> "Filter By Status" Then
            'lngStatusID = drpStatus.SelectedValue
            lngStatusID = 0
        Else
            lngStatusID = 0
        End If
        If drpState.SelectedValue <> "Filter By State" Then
            'lngStateID = drpState.SelectedValue
            lngStateID = 0
        Else
            lngStateID = 0
        End If
        If drpCSR.SelectedValue <> "CSR All" Then
            lngUserID = drpCSR.SelectedValue
        Else
            lngUserID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            'btnAll.BorderColor = Drawing.Color.Black
        Else
            btnAll.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngETA)
        If drpCSR.SelectedValue = "CSR All" Then
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        Else
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0&UserID=" & lngUserID, True)
        End If

    End Sub
    Private Sub btnAll_Click(ByVal S As Object, ByVal E As EventArgs)
        ' Show all tickets for a customer
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        Dim lngUserID As Long
        
        
        _lngETA = 4
        lngStatusID = 0
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            'lngCustomerID = drpCustomers1.SelectedValue
            lngCustomerID = 0
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
            'lngProgramID = drpProgram.SelectedValue
            lngProgramID = 0
        Else
            lngProgramID = 0
        End If
        'If drpStatus.SelectedValue <> "Filter By Status" Then
        '    lngStatusID = drpStatus.SelectedValue
        'Else
         '   lngStatusID = 0
        'End If
        If drpState.SelectedValue <> "Filter By State" Then
            'lngStateID = drpState.SelectedValue
             lngStateID = 0
        Else
            lngStateID = 0
        End If
        If drpCSR.SelectedValue <> "CSR All" Then
            lngUserID = drpCSR.SelectedValue
        Else
            lngUserID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked 
        If _lngColor = 1 Then
            'btnAll.BorderColor = Drawing.Color.Black
        Else
            btnAll.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngETA)
        If drpCSR.SelectedValue = "CSR All" Then
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        Else
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0&UserID=" & lngUserID, True)
        End If

    End Sub
    Private Sub btnMissed_Click(ByVal S As Object, ByVal E As EventArgs)
        ' Show missed appt tickets
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        Dim lngUserID As Long
        
        
        _lngETA = 5
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
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
        If drpCSR.SelectedValue <> "CSR All" Then
            lngUserID = drpCSR.SelectedValue
        Else
            lngUserID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            'btnMissed.BorderColor = Drawing.Color.Black
        Else
            btnMissed.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngETA)
        RunFolderCode()
        Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0&UserID=" & lngUserID, True)
        
    End Sub
    
    Private Sub btnSurvey_Click(ByVal S As Object, ByVal E As EventArgs)
        
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        Dim lngUserID As long
        
        _lngETA = 6
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
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
        If drpCSR.SelectedValue <> "CSR All" Then
            lngUserID = drpCSR.SelectedValue
        Else
            lngUserID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            'btnSurvey.BorderColor = Drawing.Color.Black
        Else
            btnSurvey.BorderColor = Drawing.Color.Blue
        End If
        'LoadTickets(CType(2, Long), _lngETA)
        If drpCSR.SelectedValue <> "CSR All" Then
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0&UserID=" & lngUserID, True)
        Else
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=0", True)
        end if
    End Sub
   
    
    Protected Sub drpPartners_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpPartners.SelectedValue <> "Choose One" Then
            Dim lngCustomerID As Long
            Dim lngProgramID As Long
            Dim lngStatusID As Long
            Dim lngStateID As Long
            Dim boolNeedUpdate As Boolean
            Dim lngUserID As long
        
            _lngETA = 5
        
            If drpCustomers1.SelectedValue <> "Assign Customer" Then
                lngCustomerID = drpCustomers1.SelectedValue
            Else
                lngCustomerID = 0
            End If
            If drpProgram.SelectedValue <> "Assign Program" Then
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
            If drpCSR.SelectedValue <> "CSR All" Then
            lngUserID = drpCSR.SelectedValue
        Else
            lngUserID = 0
        End If
            boolNeedUpdate = 0
            If _lngColor = 1 Then
                'btnMissed.BorderColor = Drawing.Color.Black
            Else
                btnMissed.BorderColor = Drawing.Color.Blue
            End If
            'LoadTickets(CType(2, Long), _lngETA)
            If drpCSR.SelectedValue <> "CSR All" Then
               Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&ParID=" & CType(drpPartners.SelectedValue, Long) & "&C=0&UserID=" & lngUserID, True)
            Else
               Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&ParID=" & CType(drpPartners.SelectedValue, Long) & "&C=0", True)
            end if
            'LoadTicketsByPartners(7, CType(drpPartners.SelectedValue, Long))
            'drpCustomers.SelectedValue = "Choose One"
        End If
    End Sub
    Private Sub LoadPartners()
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If _UserID <> 0 Then
            ldr.LoadTwoLongParameterDropDownList("spListPartnersByTicketFolderAndUserID", "@TicketFolderID", 7, "@UserID", _UserID, "Login", "PartnerID", drpPartners)
        Else
            ldr.LoadTwoLongParameterDropDownList("spListPartnersByTicketFolderAndInfoID", "@TicketFolderID", 7, "@InfoID", _InfoID, "Login", "PartnerID", drpPartners)
           
        End If
            
        drpPartners.Items.Add("Choose One")
        drpPartners.SelectedValue = "Choose One"
    End Sub
    Private Sub LoadCSRs()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSimpleDropDownList("spListUsersCallCenter", "UserName", "UserID", drpCSR)
        drpCSR.Items.Add("CSR All")
        drpCSR.SelectedValue = "CSR All"
    End Sub
    
    Private Sub btnNeedApt_Click(ByVal S As Object, ByVal E As EventArgs)
        Multiview1.ActiveViewIndex = 1
        Multiview2.ActiveViewIndex = 0
        Dim lngCustomerID As Long
        Dim lngProgramID As Long
        Dim lngStatusID As Long
        Dim lngStateID As Long
        Dim boolNeedUpdate As Boolean
        Dim lngUserID As Long
        
        
        _lngETA = 7
        
        btnNeedApptSet.BorderColor = Drawing.Color.Blue
        
        
        If drpCustomers1.SelectedValue <> "Assign Customer" Then
            lngCustomerID = drpCustomers1.SelectedValue
        Else
            lngCustomerID = 0
        End If
        If drpProgram.SelectedValue <> "Assign Program" Then
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
        If drpCSR.SelectedValue <> "CSR All" Then
            lngUserID = drpCSR.SelectedValue
        Else
            lngUserID = 0
        End If
        boolNeedUpdate = chkNeedUpdateID.Checked
        If _lngColor = 1 Then
            'btnNeedApptSet.BorderColor = Drawing.Color.Black
           
        Else
            btnNeedApptSet.BorderColor = Drawing.Color.Blue
            btnAll.BorderColor = Nothing
            btnMissed.BorderColor = Nothing
            drpPartners.Visible = False
        End If
        _UserID = lngUserID
        If drpCSR.SelectedValue <> "CSR All" Then
            LoadPartners2(drpCSR.SelectedValue)
            LoadPartnersList(lngUserID)
        Else
            LoadPartners2(0)
            LoadPartnersList(lngUserID)
        End If
        'LoadTickets(CType(2, Long), _lngETA)
        
        'Response.Redirect("CustomerServiceControl.aspx?id=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=" & boolNeedUpdate & "&C=1&UserID=" & lngUserID, True)
        
    End Sub
    
    Private Sub menu5_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu5.MenuItemClick
        Multiview2.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0
                
            Case Is = 1
                
                LoadNeedPartsReturned()
            Case Is = 2
                LoadWorkOrders()
                
            Case Is = 3
                LoadSurveys(_ParID)
        End Select
        
    End Sub
    Private Sub LoadNeedPartsReturned()
        
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If drpPartners2.SelectedValue = "Choose One" Then
            ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedByPartnerID", "@PartnerID", _ParID, dgvOpenWorkOrders)
            'ldr.LoadSingleLongParameterDataGrid("spListRequireSignatureDispatchedPartnerWorkOrders", "@PartnerID", _ParID, Me.dgvRequireUpload)
        Else
            ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedByPartnerID", "@PartnerID", CType(drpPartners2.SelectedValue, Long), dgvOpenWorkOrders)
        End If
        lblTicketCount1.Text = " [ " & CType(dgvOpenWorkOrders.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

        
    End Sub
    Private Sub btnExport_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Dim ex As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     
        If dgvOpenWorkOrders.Items.Count > 0 Then
            ex.ExportGrid("PartsNotReturned.xls", dgvOpenWorkOrders)
        End If
    End Sub
    Private Sub LoadPartners2(ByVal lngUserID As Long)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        If lngUserID = 0 Then
            ldr.LoadSingleLongParameterDropDownList("spListActivePartnersByInfoID","@InfoID",_infoID,"ResumeID","PartnerID",drpPartners2)
            drpPartners2.Items.Add("Choose One")
            drpPartners2.SelectedValue = "Choose One"
        Else
            ldr.LoadSingleLongParameterDropDownList("spListActivePartnersByUserID", "@UserID", lngUserID, "ResumeID", "PartnerID", drpPartners2)
            drpPartners2.Items.Add("Choose One")
            drpPartners2.SelectedValue = "Choose One"
        End If
    End Sub
    Protected Sub drpPartners2_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpPartners2.SelectedValue <> "Choose One" Then
            
            Dim lngCustomerID As Long
            Dim lngProgramID As Long
            Dim lngStatusID As Long
            Dim lngStateID As Long
            
            _ParID = CType(drpPartners2.SelectedValue, Long)
            
            lngCustomerID = 0
            lngProgramID = 0
            lngStatusID = 0
            lngStateID = 0
            
            Response.Redirect("CustomerServiceControl.aspx?id=" & _ID & "&infoID=" & _infoID & "&eta=" & _lngETA & "&CustID=" & lngCustomerID & "&ProgID=" & lngProgramID & "&StatusID=" & lngStatusID & "&StateID=" & lngStateID & "&NP=1&ParID=" & CType(drpPartners2.SelectedValue, Long) & "&C=0&UserID=" & _UserID, True)

            'LoadTicketsByPartners(CType(2, Long), CType(drpPartners.SelectedValue, Long))
            
        End If
    End Sub
    
    Private Sub LoadPartnersList(ByVal lngUserID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If lngUserID <> 0 Then
            ldr.LoadSingleLongParameterDataGrid("spListActivePartnersWithCallsByUserID", "@UserID", lngUserID, dgvVendors2)
        Else
            ldr.LoadSimpleDataGrid("spListActivePartnersWithCalls2", dgvVendors2)
        End If
    End Sub
    
    Private Sub LoadTicketsByPartners2(ByVal lngTicketFolderID As Long, ByVal lngPartnerID As Long)
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'If drpPartners2.SelectedValue <> "Choose One" Then
        'drpPartners2.SelectedValue = lngPartnerID
        'End If
        
        If lngPartnerID <> 0 Then
                      
            'Dont filter - Show all the tickets in the folder
            
                If drpPartners2.SelectedValue = "Choose One" Then
                
                    ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 33, "@PartnerID", lngPartnerID, "CountryID", _CountryID, dgvTickets2)
                Else
                 ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 2, "@PartnerID", lngPartnerID, "CountryID", _CountryID, dgvTickets2)
                End If
            
            lblTicketCount3.Text = " ( " & CType(dgvTickets2.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
        End If
    End Sub
    Private Sub LoadTicketsByPartners(ByVal lngTicketFolderID As Long, ByVal lngPartnerID As Long)
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                
        If lngPartnerID <> 0 Then
                      
            'Dont filter - Show all the tickets in the folder
             If _lngETA = 5 then
                If drpPartners.SelectedValue = "Choose One" Then
                    If drpCSR.SelectedValue <> "CSR All" then
                      ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 7, "@PartnerID", lngPartnerID, "CountryID", _CountryID,"@UserID",_UserID, dgvTickets)
                    Else
                      ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 7, "@PartnerID", lngPartnerID, "CountryID", _CountryID, dgvTickets)
                    end if
                Else
                 ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 7, "@PartnerID", lngPartnerID, "CountryID", _CountryID, dgvTickets)
                End If
            end if               
            
            lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
        End If
    End Sub
    
    Protected Sub dgvTickets2_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If lblSortOrder.Text.ToLower = " asc" Then
            lblSortOrder.Text = " desc"
        Else
            lblSortOrder.Text = " asc"
        End If
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        If drpPartners2.SelectedValue = "Choose One" Then
            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 33, "@PartnerID", _ParID, "CountryID", _CountryID, dgvTickets2, True, e, e.SortExpression, lblSortOrder.Text)
        Else
            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", 2, "@PartnerID", _ParID, "CountryID", _CountryID, dgvTickets2, True, e, e.SortExpression, lblSortOrder.Text)
        End If
    End Sub
    
    Private Function GetTotalUntouchedTicketsByUser(ByVal lngUserID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalTicketsUntouchedByUser")
        Dim lngTotal As Long = 0
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
    Private Function GetTotalUntouchedTickets() As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalTicketsUntouched")
        Dim lngTotal As Long = 0
       
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
    Private Function GetTotalOldTickets(ByVal lngTicketFolderID As Long, ByVal lngTemp As Long, ByVal lngAge1 As Long, ByVal lngAge2 As Long, ByVal lngCountryID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountListTicketsOld")
        Dim lngTotal As Long = 0
        cmd.Parameters.Add("@TicketFolderID", Data.SqlDbType.Int).Value = lngTicketFolderID
        cmd.Parameters.Add("@Temp", Data.SqlDbType.Int).Value = lngTemp
        cmd.Parameters.Add("@Age1", Data.SqlDbType.Int).Value = lngAge1
        cmd.Parameters.Add("@Age2", Data.SqlDbType.Int).Value = lngAge2
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = lngCountryID

        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
    Private Function GetTotalOldTicketsByUser(ByVal lngTicketFolderID As Long, ByVal lngTemp As Long, ByVal lngAge1 As Long, ByVal lngAge2 As Long, ByVal lngCountryID As Long, ByVal lngUserID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountListTicketsOldByUser")
        Dim lngTotal As Long = 0
        cmd.Parameters.Add("@TicketFolderID", Data.SqlDbType.Int).Value = lngTicketFolderID
        cmd.Parameters.Add("@Temp", Data.SqlDbType.Int).Value = lngTemp
        cmd.Parameters.Add("@Age1", Data.SqlDbType.Int).Value = lngAge1
        cmd.Parameters.Add("@Age2", Data.SqlDbType.Int).Value = lngAge2
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = lngCountryID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
    
    Private Function GetTotalTicketsByUser(ByVal lngTicketFolderID As Long, ByVal lngCountryID As Long, ByVal lngUserID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountListTicketsInFolderByUser")
        Dim lngTotal As Long = 0
        cmd.Parameters.Add("@TicketFolderID", Data.SqlDbType.Int).Value = lngTicketFolderID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = lngCountryID
        cmd.Parameters.Add("@UserID", Data.SqlDbType.Int).Value = lngUserID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
    Private Function GetTotalTickets(ByVal lngTicketFolderID As Long, ByVal lngCountryID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountListTicketsInFolder3")
        Dim lngTotal As Long = 0
        cmd.Parameters.Add("@TicketFolderID", Data.SqlDbType.Int).Value = lngTicketFolderID
        cmd.Parameters.Add("@CountryID", Data.SqlDbType.Int).Value = lngCountryID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTotal = dtr("Total")
        End While
        Return lngTotal
        cnn.Close()
    End Function
    
    Private Sub LoadSurveys(ByVal lngPartnerID As Long)
        Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim res As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim dtLastMonthFirstDay As Date
        Dim dtLastMonthLastDay As Date
        Dim intLastMonth As Integer
        Dim dtStartdate As Date
        Dim dtEndDate As Date
        Dim intDay As Integer
        Dim intlastday As Integer
        Dim lngTotalRecallTickets As Long
        Dim lngTotal As Long
        Dim lngTotalTicketResults As Long
        Dim lngAverage As Long
        Dim lngMultiVisits As Long
        
        dtLastMonthLastDay = DateTime.Today.AddDays(0 - DateTime.Today.Day)
        dtLastMonthFirstDay = dtLastMonthLastDay.AddDays(1 - dtLastMonthLastDay.Day)
        intLastMonth = (DateTime.Today.Month - 1)
   
        dtStartdate = dtLastMonthFirstDay.Date
        dtEndDate = dtLastMonthLastDay.Date
        intDay = DateTime.Today.Day
        intlastday = Day(DateSerial(Year(Now()), Month(Now()) + 1, 0))
        lblMonth.Text = "From " & dtStartdate & " and " & dtEndDate
        
        lngTotalTicketResults = (LoadTotalTickets(dtStartdate, dtEndDate))
        lblTotalTicketsResults.Text = lngTotalTicketResults
        
        lngAverage = LoadAvgDaysToClose(dtStartdate, dtEndDate)
        lblGoalAvgDTC.Text = lngAverage
        If lngAverage <= 7 Then
            lblDaystoCloseGraph.Text = "<img src='/graphics/green.jpg' id='img1' runat ='server' height='50' width='60'/>"
        Else
            If lngAverage >= 8 And lngAverage <= 10 Then
                lblDaystoCloseGraph.Text = "<img src='/graphics/yellow.jpg' id='img1' runat ='server' height='50' width='60'/>"
            Else
                If lngAverage <> 0 Then
                    lblDaystoCloseGraph.Text = "<img src='/graphics/red.jpg' id='img1' runat ='server' height='50' width='60'/>"
                Else
                    'lblDaystoCloseGraph.Text = "<img src='/images/1_w3.gif' id='img1' runat ='server' width='10'/>"
                End If
            End If
        End If
        
        lngMultiVisits = LoadMultipleVisits(dtStartdate, dtEndDate)
        lblMultiVisitResults.Text = lngMultiVisits & " %"
        
        If lngMultiVisits <= 5 Then
            lblMultipleVisitsToClose.Text = "<img src='/graphics/green.jpg' id='img1' runat ='server' height='50' width='60'/>"
        Else
            If lngMultiVisits >= 6 And lngMultiVisits <= 8 Then
                lblMultipleVisitsToClose.Text = "<img src='/graphics/yellow.jpg' id='img1' runat ='server' height='50' width='60'/>"
            Else
                If lngMultiVisits <> 0 Then
                    lblMultipleVisitsToClose.Text = "<img src='/graphics/red.jpg' id='img1' runat ='server' height='50' width='60'/>"
                Else
                    'lblMultipleVisitsToClose.Text = "<img src='/images/1_w3.gif' id='img1' runat ='server' width='10'/>"
                End If
            End If
        End If
        
        lngTotalRecallTickets = LoadRecall(dtStartdate, dtEndDate)
        If CType(lblTotalTicketsResults.Text, Long) > 0 Then
            lngTotal = (lngTotalRecallTickets * 100) / CType(lblTotalTicketsResults.Text, Long)
        Else
            lngTotal = 0
        End If
        lblRecall.Text = lngTotal & " %"
        If lngTotal <= 5 Then
            lblTotalRecall.Text = "<img src='/graphics/green.jpg' id='img1' runat ='server' height='50' width='60'/>"
        Else
            If lngTotal >= 6 And lngTotal <= 8 Then
                lblTotalRecall.Text = "<img src='/graphics/yellow.jpg' id='img1' runat ='server' height='50' width='60'/>"
            Else
                If lngTotal <> 0 Then
                    lblTotalRecall.Text = "<img src='/graphics/red.jpg' id='img1' runat ='server' height='50' width='60'/>"
                Else
                    'lblTotalRecall.Text = "<img src='/images/1_w3.gif' id='img1' runat ='server' width='10'/>"
                End If
            End If
        End If
        par.Load(_ParID)
        res.Load(par.ResumeID )
        lblPerformanceVendor.Text = "Partner's Performance For: " & res.FirstName & " " & res.LastName 
        
        
        'ldr.LoadSingleLongParameterDataGrid("spGetTicketDocumentsForVendors", "@TicketID", lngTicketID, dgvAttachments)
        ldr.LoadTwoLongTwoDateParameterDataGrid("spGetSurveyAnswersByPartnerAndDates", "@SurveyID", 2, "@PartnerID", lngPartnerID, "@StartDate", dtStartdate, "@EndDate", dtEndDate, dgvSurveys)
        If dgvSurveys.Items.Count = 0 Then
            lblSurveyResults.Text = "  Survey Results: Not enough surveys performed to calculate performance at this moment."
            dgvSurveys.Visible = False
        Else
            lblSurveyResults.Visible = False
        End If
    End Sub
    Private Function LoadTotalTickets(ByVal datStartDate As Date, ByVal datEndDate As Date) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticTotalTickets")
        
        Dim lngTotalTickets As Long
        lngTotalTickets = 0
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = _ParID
        cmd.Parameters.Add("@dtStartDate", Data.SqlDbType.DateTime).Value = datStartDate & " 00:00:00"
        cmd.Parameters.Add("@dtEndDate", Data.SqlDbType.VarChar).Value = datEndDate & " 23:59:59"
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            If Not IsDBNull(dtr("TotalTickets")) Then
                lngTotalTickets = dtr("TotalTickets")
            Else
                lngTotalTickets = 0
            End If
        End While
        Return lngTotalTickets
        cnn.Close()
    End Function
    
    Private Function LoadAvgDaysToClose(ByVal datStartDate As Date, ByVal datEndDate As Date) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticDaysToClose")
        
        Dim lngDaysToClose As Long
        lngDaysToClose = 0
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = _ParID
        cmd.Parameters.Add("@dtStartDate", Data.SqlDbType.DateTime).Value = datStartDate & " 00:00:00"
        cmd.Parameters.Add("@dtEndDate", Data.SqlDbType.VarChar).Value = datEndDate & " 23:59:59"
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            If Not IsDBNull(dtr("AvgAgeToClose")) Then
                lngDaysToClose = dtr("AvgAgeToClose")
            Else
                lngDaysToClose = 0
            End If
        End While
        Return lngDaysToClose
        cnn.Close()
    End Function
    
    Private Function LoadMultipleVisits(ByVal datStartDate As Date, ByVal datEndDate As Date) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticMultipleVisits")
        
        Dim lngMultiVisit As Long
        lngMultiVisit = 0
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = _ParID
        cmd.Parameters.Add("@dtStartDate", Data.SqlDbType.DateTime).Value = datStartDate & " 00:00:00"
        cmd.Parameters.Add("@dtEndDate", Data.SqlDbType.VarChar).Value = datEndDate & " 23:59:59"
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            If Not IsDBNull(dtr("Avarage")) Then
                lngMultiVisit = dtr("Avarage")
            Else
                lngMultiVisit = 0
            End If
        End While
        Return lngMultiVisit
        cnn.Close()
    End Function
    
    Private Function LoadRecall(ByVal datStartDate As Date, ByVal datEndDate As Date) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPerformanceStatisticRecallTickets")
        
        Dim lngTotalRecall As Long
        lngTotalRecall = 0
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = _ParID
        cmd.Parameters.Add("@dtStartDate", Data.SqlDbType.DateTime).Value = datStartDate & " 00:00:00"
        cmd.Parameters.Add("@dtEndDate", Data.SqlDbType.VarChar).Value = datEndDate & " 23:59:59"
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            If Not IsDBNull(dtr("TotalRecall")) Then
                lngTotalRecall = dtr("TotalRecall")
            Else
                lngTotalRecall = 0
            End If
        End While
        Return lngTotalRecall
        cnn.Close()
    End Function
    
    Private Sub dgvSurveys_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvSurveys.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim lngTotal As Long
        Dim lngGoal As Long
        Dim lngAvarage As Long
        Dim listlblSurveyPic As System.Web.UI.WebControls.Label
        
        Select (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                lngTotal = (rowData.Item("Total"))
                lngGoal = (rowData.Item("Goal"))
                lngAvarage = (rowData.Item("Avarage"))
                
                If lngAvarage >= lngGoal Then
                    listlblSurveyPic = CType(e.Item.FindControl("lblSurveyPic"), System.Web.UI.WebControls.Label)
                    listlblSurveyPic.Text = "<img src='/graphics/green.jpg' id='img1' runat ='server' height='50' width='60'/>"
                Else
                    If lngAvarage = (lngGoal - 1) Then
                        listlblSurveyPic = CType(e.Item.FindControl("lblSurveyPic"), System.Web.UI.WebControls.Label)
                        listlblSurveyPic.Text = "<img src='/graphics/yellow.jpg' id='img1' runat ='server' height='50' width='60'/>"
                    Else
                        listlblSurveyPic = CType(e.Item.FindControl("lblSurveyPic"), System.Web.UI.WebControls.Label)
                        listlblSurveyPic.Text = "<img src='/graphics/red.jpg' id='img1' runat ='server' height='50' width='60'/>"
                    End If
                End If
        End Select
    End Sub
    Private Sub LoadWorkOrders()
        'If master.AdminAgent Then
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListRequireSignatureDispatchedPartnerWorkOrders", "@PartnerID", _ParID, Me.dgvRequireUpload)
        'Else
        'Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'ldr.LoadSingleLongParameterDataGrid("spListRequireSignatureDispatchedPartnerAgentWorkOrders", "@PartnerAgentID", Master.PartnerAgentID, Me.dgvRequireUpload)
        'End If
        lblTicketCount.Text = " [ " & CType(dgvRequireUpload.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

    End Sub
    Private Sub RunFolderCode()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spTicketFolderCode_OpenTickets")
        
        cmd.Parameters.Add("@InfoID", Data.SqlDbType.Int).Value = Master.InfoID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
       
        
        cnn.Close()
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server">
    <table style="width: 100%">
      <tbody>
        <tr style="width: 100%">
          <td >
            <div class="bandheader"></div>
            <asp:Button ID="btnETA1" runat="server" Text="0 - 7"  OnClick="btnETA1_Click"  />&nbsp;<asp:Button ID="btnETA2" runat="server" Text="8 - 15" OnClick="btnETA2_Click" />&nbsp;<asp:Button ID="btnETA3" runat="server" Text="16 - Over" OnClick="btnETA3_Click"/>&nbsp;<asp:Button ID="btnAll" runat="server" Text="All" OnClick="btnAll_Click" />&nbsp;<asp:CheckBox ID="chkNeedUpdateID" runat="server" Text="NeedUpdate" visible="true"/>&nbsp;<asp:DropDownList ID="drpAgents" runat="server" AutoPostBack="true" visible="False" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnSurvey" runat="server" Text="Survey" OnClick="btnSurvey_Click" />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnMissed" runat="server" Text="Missed Appointments" OnClick="btnMissed_Click" />&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartners_SelectedIndexChanged" />&nbsp;&nbsp;&nbsp;<asp:Button ID="btnNeedApptSet" runat="server" Text="Need Appt Set" OnClick="btnNeedApt_Click" />&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblSendEmail" runat="server" ></asp:Label>
            <div class="bandheader">&nbsp;</div>
          </td>
          </tr>
        <tr>
          <td>
           <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
          <asp:View ID="viewOpenTickets"  runat="server">
            <div class="inputformsectionheader">
                <asp:Label ID="lblTicketCount" runat="server"></asp:Label>
                <asp:DropDownList ID="drpCSR" Runat="server" Visible="True"  />
                <asp:DropDownList ID="drpCustomers1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="drpCustomers1_SelectedIndexChanged" Visible="false" />
                <asp:DropDownList ID="drpCustomers2" Runat="server" Visible="False" />
                <asp:DropDownList ID="drpStatus" Runat="server" AutoPostBack="false" Visible="false" />
                <asp:DropDownList ID="drpProgram" runat="server" AutoPostBack="true" Visible="false" />
                <asp:DropDownList ID="drpProgram2" Runat="server" Visible="False" />
                <asp:DropDownList ID="drpState" Runat="server" AutoPostBack="True" Visible="false"/>
                <asp:Label ID="lblUntouched" runat="server"></asp:Label>
                <asp:Label ID="lblOldTickets" runat="server"></asp:Label>
            </div>
            <div >
            <table width ="100%" >
              <tr>
                <td >
                    <asp:DataGrid ID="dgvStatuses" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" Width ="100%" CssClass="Grid1">
              <AlternatingItemStyle CssClass="altrow"/>
                <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn DataField="TicketStatusID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText ="Filter by Status" >
                  <ItemTemplate>
                    <a href="CustomerServiceControl.aspx?id=<%=_ID%>&infoID=<%=_infoID%>&eta=<%=_lngETA%>&CustID=<%=_lngCustID%>&ProgID=<%=_lngProgramID%>&StatusID=<%# DataBinder.Eval(Container.DataItem,"TicketStatusID") %>&StateID=<%=_lngStateID%>&NP=<%=_chkNeedUpdate%>&parid=0&C=1&UserID=<%=_UserID%>"><%# DataBinder.Eval(Container.DataItem,"Status") %></a>&nbsp;(<%# DataBinder.Eval(Container.DataItem,"Total") %>)
                  </ItemTemplate> 
                </asp:TemplateColumn>
              </Columns> 
            </asp:DataGrid>
            <div class="bandheader">&nbsp;</div>            
            <asp:DataGrid ID="dgvStatuses2" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" Width ="100%" CssClass="Grid1">
              <AlternatingItemStyle CssClass="altrow"/>
                <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn DataField="TicketStatusID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText="Filter by Closed Status" >
                  <ItemTemplate>
                    <a href="CustomerServiceControl.aspx?id=<%=_ID%>&infoID=<%=_infoID%>&eta=<%=_lngETA%>&CustID=<%=_lngCustID%>&ProgID=<%=_lngProgramID%>&StatusID=<%# DataBinder.Eval(Container.DataItem,"TicketStatusID") %>&StateID=<%=_lngStateID%>&NP=0&parid=0&C=1&cl=1&UserID=<%=_UserID%>"><%# DataBinder.Eval(Container.DataItem,"Status") %></a>&nbsp;(<%# DataBinder.Eval(Container.DataItem,"Total") %>)
                  </ItemTemplate> 
                </asp:TemplateColumn>
              </Columns> 
            </asp:DataGrid>
                </td>
                <td >
              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand" CssClass="Grid1">
                <AlternatingItemStyle CssClass="altrow"/>
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
                   </td>
                </tr>
              </table>
              </div>
              </asp:View>
              
              <asp:View ID="viewNeedApptSet"  runat="server">
              <table>
              <tr>
                 <td class="band" style="width: 1%" >
            <div class="bandheader">Vendor</div>
            <asp:DropDownList ID="drpPartners2" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartners2_SelectedIndexChanged" />
            <div class="bandheader">Vendors List</div>
            <asp:DataGrid ID="dgvVendors2" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" Width ="100%" CssClass="Grid1">
              <ItemStyle CssClass="bandbar" />
              <Columns>
                <asp:BoundColumn DataField="PartnerID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText ="Partner" >
                  <ItemTemplate>
                    <a href="CustomerServiceControl.aspx?id=<%# _ID %>&infoID=<%#_infoID %>&eta=7&CustID=0&ProgID=0&StatusID=0&StateID=0&NP=0&parid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&C=1&UserID=<%=_UserID%>"><%# DataBinder.Eval(Container.DataItem,"ResumeID") %></a>&nbsp;(<%# DataBinder.Eval(Container.DataItem,"Total") %>)
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
                <asp:MenuItem Value = "2" Text="Need WO Return"></asp:MenuItem>
                <asp:MenuItem value ="3" Text="Performance"></asp:MenuItem>
             </Items>
           </asp:Menu>
          </div>
            <asp:MultiView ID="Multiview2" runat="server" ActiveViewIndex="0" >
            <asp:View ID="viewTickets"  runat="server" >
            <div id="ratesheader" class="tabbody">&nbsp;</div>
            <div class="inputformsectionheader">
                <asp:Label ID="lblTicketCount3" runat="server" ></asp:Label>&nbsp;&nbsp;<asp:Label ID="lblTechName" runat ="server" ></asp:Label>
                <asp:DropDownList ID="DropDownList1" Runat="server" AutoPostBack="True" OnSelectedIndexChanged="drpCustomers1_SelectedIndexChanged" Visible="false"/>
                
                <asp:DropDownList ID="DropDownList2" Runat="server" AutoPostBack="True" Visible="false"/>
                
                <asp:DropDownList ID="DropDownList3" Runat="server" AutoPostBack="True" Visible="false"/>
                
                <asp:DropDownList ID="DropDownList4" Runat="server" AutoPostBack="True" Visible="false"/>
            </div>
            <div class="inputform">
              <asp:DataGrid AllowSorting="true" ID="dgvTickets2" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets2_SortCommand" CssClass="Grid1">
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
            <div id="ratesheader1" class="tabbody" ></div>
            <div ><asp:ImageButton ID="btnExport" AlternateText ="Export to Excel" ImageUrl ="/images/Excel-16.gif"  ImageAlign="right"  OnClick="btnExport_Click" runat="server"/></div> 
            <div class="inputformsectionheader">&nbsp;</div>
            <div class="inputformsectionheader" ><asp:Label ID="lblTicketCount1" runat="server"></asp:Label> Tickets Needing Part Returned</div>
            <asp:DataGrid ID="dgvOpenWorkOrders" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false" CssClass="Grid1">
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
            <asp:View ID="VwNeedWOReturned"  runat="server">
             <div class="inputformsectionheader"><asp:Label ID="Label1" runat="server"></asp:Label></div>
                    <asp:DataGrid ID="dgvRequireUpload" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false" CssClass="Grid1">
                  <HeaderStyle CssClass="gridheader" />
                  <AlternatingItemStyle CssClass="altrow" />
                  <Columns>
                    <asp:BoundColumn HeaderText="ID" DataField="WorkOrderID" Visible="false" />
                    <asp:TemplateColumn HeaderText="Ticket ID">
                      <ItemTemplate>
                        <a target="_blank" href="ticket.aspx?id=<%# Databinder.Eval(Container.DataItem,"TicketID") %>&returnurl=workorders.aspx&act=H"><%# Databinder.Eval(Container.DataItem,"TicketID") %></a>
                      </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:templatecolumn HeaderText="Work Order ID">
                      <itemtemplate>
                        <a target="_blank" href="printableworkorder.aspx?id=<%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%>"><%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%></a>
                      </itemtemplate>
                    </asp:templatecolumn>
                    <asp:TemplateColumn HeaderText="Upload">
                      <ItemTemplate>
                        <a target="_blank" href="upload.aspx?mode=wo&id=<%# DataBinder.Eval(Container.DataItem, "WorkOrderID") %>&returnurl=workorders.aspx">Upload</a>
                      </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:BoundColumn HeaderText="Status" DataField="WorkOrderStatus" />
                    <asp:BoundColumn HeaderText="Resolved" DataField="Resolved" />
                    <asp:BoundColumn HeaderText="Dispatched" DataField="DispatchDate" />
                    <asp:BoundColumn HeaderText="Date Closed" DataField="Departed" />
                  </Columns>      
                </asp:DataGrid>
            </asp:View>
             <asp:View ID="vwPerformance"  runat="server">
               <div>&nbsp;</div>
                <div class="label" style="text-align: center; font-size: x-large;"><asp:Label ID="lblPerformanceVendor" runat ="server" /></div>
                  <div class="label" style="text-align: center; "><asp:Label ID="lblMonth" runat ="server" /></div>
                  <table cellpadding="10px" cellspacing="0">
                    <tr>
                      <td class="label">&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTickets" runat ="server" Text="Tickets: " /></td>
                      <td style="font-size: x-large;"><asp:Label ID="lblTotalTicketsResults" runat ="server" /></td>
                      <td></td>
                    </tr>
                    <tr class="pageheader" >
                      <td class="label" style="vertical-align:middle;">&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblStatistics" runat ="server" Text="Statistics: " /></td>
                      <td class="label" style="text-align:center;" ><asp:Label ID="lblTotal" runat ="server"  /></td>
                      <td  class="label" align="center" ><asp:Label ID="lblGoal" runat ="server" Text="Goal" /></td>
                      <td class="label" align="center" ><asp:Label ID="lblResults" runat ="server" Text="Results" /></td>
                      <td class="label" align="center" ><asp:Label ID="lblPicture" runat ="server" Text="Graph" /></td>
                    </tr>
                    <tr>
                      <td class="label" style="vertical-align:middle;" >&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblDaystoClose" runat ="server" Text="Avg Days to Close " /> </td>
                      <td></td>
                      <td  style="vertical-align:middle; font-size: x-large;"><asp:Label ID="lblGoalDaysToClose" runat ="server" Text="< 7" /></td>
                      <td  style="vertical-align:middle; font-size: x-large;"><asp:Label ID="lblGoalAvgDTC" runat ="server" Text="6%" /></td> 
                      <td style="vertical-align: bottom; text-align: inherit;"><asp:Label ID="lblDaystoCloseGraph" runat="server"  /></td> 
                    </tr>
                    <tr>
                      <td class="label" style="vertical-align:middle;" >&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblMultipleVisits" runat ="server" Text="Multiple Visits to Close " /></td>
                      <td></td>
                      <td style="vertical-align:middle;font-size: x-large;"><asp:Label ID="Label2" runat ="server" Text="< 5%"/></td>
                      <td style="vertical-align:middle;font-size: x-large;"><asp:Label ID="lblMultiVisitResults" runat ="server" Text="30%" /></td> 
                      <td style="vertical-align:middle;"><asp:Label ID="lblMultipleVisitsToClose" runat="server"  /></td>  
                    </tr>
                    <tr>
                      <td class="label" style="vertical-align:middle;" >&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblRecallTickets" runat ="server" Text="Recall Tickets " /></td>
                      <td></td>
                      <td style="vertical-align:middle;font-size: x-large;"><asp:Label ID="Label3" runat ="server" Text="< 5%"  /></td>
                      <td style="vertical-align:middle;font-size: x-large;"><asp:Label ID="lblRecall" runat ="server" Text="10%" /></td>
                      <td style="vertical-align:middle;"><asp:Label ID="lblTotalRecall" runat="server"  /></td>  
                    </tr>
                    <tr>
                      <td class="label" style="vertical-align:middle;" colspan ="5">
                        <asp:Label ID="lblSurveyResults" runat ="server" Text="Survey Results: " />
                        <asp:DataGrid ID="dgvSurveys" runat ="server" style="width:100%; background-color: White;" AutoGenerateColumns="false" GridLines="None"  CellPadding="15" EditItemStyle-HorizontalAlign="Center" EditItemStyle-VerticalAlign="Middle" CssClass="Grid1" >
                        <HeaderStyle CssClass="pageheader" />
                         
                           <Columns>
                              <asp:BoundColumn DataField="QuestionType" HeaderText="Survey Results:" ItemStyle-Wrap="false" ItemStyle-VerticalAlign="Middle"/> 
                              <asp:BoundColumn DataField="Total" HeaderText="Total" ItemStyle-Wrap="false" ItemStyle-Font-Size="X-Large" ItemStyle-HorizontalAlign="Right" ItemStyle-VerticalAlign="Middle"/> 
                              <asp:BoundColumn DataField="Goal" HeaderText="Goal" ItemStyle-Wrap="false" ItemStyle-Font-Size="X-Large" ItemStyle-HorizontalAlign="Right" ItemStyle-VerticalAlign="Middle" /> 
                              <asp:BoundColumn DataField="Avarage" HeaderText="Results" ItemStyle-Font-Size="X-Large" ItemStyle-HorizontalAlign="Right" ItemStyle-VerticalAlign="Middle"/> 
                              <asp:TemplateColumn HeaderText="Graph" ItemStyle-Wrap="false"  ItemStyle-HorizontalAlign="Right" >
                                 <ItemTemplate>
                                    <asp:Label ID="lblSurveyPic" runat ="server"  />
                                 </ItemTemplate>
                              </asp:TemplateColumn>                  
                           </Columns> 
                        </asp:DataGrid>
                      </td>  
                    </tr>
                    </table>
             </asp:View>
            </asp:MultiView>
            </td>
              </tr>
              </table>
              </asp:View>
              </asp:MultiView>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>