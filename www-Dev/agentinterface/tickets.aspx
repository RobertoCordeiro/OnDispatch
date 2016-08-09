<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

  Private _ID As Long = 1
  Private lngCustID as long = 1
    Private lngIt As Long
    Private _CountryID As Long = 1

  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Ticket Management"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Ticket Management"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Ticket Management"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
      If _ID < 1 Then
        _ID = 1
      End If
    Catch ex As Exception
      _ID = 1
    End Try
    
        If Not Page.IsPostBack Then
            LoadFolders()
            LoadCustomers()
            LoadPartners()
            LoadStates()
            LoadPrograms()
            LoadStatus()
            LoadTickets(_ID)
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
                LoadTickets(_ID)
        End If
   
    End Sub
  
  Private Sub LoadFolders()
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDataGrid("spListTicketFolderStats", "@InfoID", Master.InfoID, dgvFolders)
    For Each itm As DataGridItem In dgvFolders.Items
      If CType(itm.Cells(0).Text, Long) = _ID Then
        itm.CssClass = "selectedbandbar"
      End If
    Next
  End Sub
  
  Private Sub LoadTickets(ByVal lngTicketFolderID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If drpPartners.SelectedValue = "Choose One" Then
            drpCustomers1.Visible = True
            drpStatus.Visible = True
            drpProgram.Visible = True
            drpState.Visible = True
            If drpCustomers1.SelectedValue <> "Filter By Customer" Then
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, status, Program and state
                            ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSPS", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                        
                        Else
                            'Filter by Customer, status and program
                            ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSP", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by customer, Status and State
                            ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSS", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                        Else
                            'Filter by Customer Status
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCS", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                        End If

                    End If
                Else
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, Program and State
                            ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCPS", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                        Else
                            'Filter By Customer, Program
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCP", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)

                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Customer, State
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCState", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)

                        Else
                            'Filter By Customer
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                        End If
                    End If

                End If
            Else
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status, Program and state
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusState", "@TicketFolderID", _ID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)

                        Else
                            'Filter By Status and program
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatus", "@TicketFolderID", _ID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)

                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status and State
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusState", "@TicketFolderID", _ID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)

                        Else
                            'Filter By Status
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatus", "@TicketFolderID", _ID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)

                        End If
                    End If
                Else
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Program and state
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByState", "@TicketFolderID", _ID, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)

                        Else
                            'Filter By Program
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By State
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByState", "@TicketFolderID", _ID, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
                        Else
                            'Dont filter - Show all the tickets in the folder
                            ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolder", "@TicketFolderID", _ID, "CountryID", _CountryID, dgvTickets)
                        End If
                    End If
                End If
            End If
        Else
            drpCustomers1.Visible = False
            drpStatus.Visible = False
            drpProgram.Visible = False
            drpState.Visible = False
            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", _ID, "@PartnerID", CType(drpPartners.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
        End If
        lblTicketCount.Text = " [ " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

  End Sub

    Private Sub LoadTicketsByCustomer(ByVal lngTicketFolderID As Long, ByVal lngCustomerID As Long)
       
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        drpPartnerAgents.SelectedValue = lngCustomerID
        
        ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", _ID, "@CustomerID", CType(drpPartnerAgents.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "

    End Sub

    Private Sub LoadTicketsByPartners(ByVal lngTicketFolderID As Long, ByVal lngPartnerID As Long)
       
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        drpPartners.SelectedValue = lngPartnerID
    
        ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", _ID, "@PartnerID", CType(drpPartners.SelectedValue, Long), "CountryID", _CountryID, dgvTickets)
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
  
  Private Sub btnJump_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim lng As Long = 0
    If txtTicketID.Text.Trim.Length > 0 Then
      If Long.TryParse(txtTicketID.Text, lng) Then
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(lng)
        If tkt.TicketID > 0 Then
          divJumpToError.Visible = False
          Response.Redirect("ticket.aspx?id=" & tkt.TicketID, True)
        Else
          divJumpToError.InnerHtml = "Ticket Not Found"
          divJumpToError.Visible = True
        End If
      Else
        divJumpToError.InnerHtml = "Ticket ID Must Be Numeric"
        divJumpToError.Visible = True
      End If
    End If
  End Sub
  
  Protected Sub dgvTickets_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If lblSortOrder.Text.ToLower = " asc" Then
      lblSortOrder.Text = " desc"
    Else
      lblSortOrder.Text = " asc"
    End If
        Dim ldr1 As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If drpPartners.SelectedValue = "Choose One" Then
            If drpCustomers1.SelectedValue <> "Filter By Customer" Then
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, status, Program and state
                            ldr1.LoadSixLongParameterDataGrid("spListTicketsInFolderByCSPS", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                        Else
                            'Filter by Customer, status and program
                            ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSP", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by customer, Status and State
                            ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCSS", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                        Else
                            'Filter by Customer Status
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCS", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                        End If

                    End If
                Else
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter by Customer, Program and State
                            ldr1.LoadFiveLongParameterDataGrid("spListTicketsInFolderByCPS", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                        Else
                            'Filter By Customer, Program
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCP", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "ServiceTypeID", CType(drpProgram.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)

                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Customer, State
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByCState", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)

                        Else
                            'Filter By Customer
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers1.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                        End If
                    End If

                End If
            Else
                If drpStatus.SelectedValue <> "Filter By Status" Then
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status, Program and state
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusState", "@TicketFolderID", _ID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)

                        Else
                            'Filter By Status and program
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatus", "@TicketFolderID", _ID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)

                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By status and State
                            ldr1.LoadFourLongParameterDataGrid("spListTicketsInFolderByStatusState", "@TicketFolderID", _ID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)

                        Else
                            'Filter By Status
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByStatus", "@TicketFolderID", _ID, "@TicketStatusID", CType(drpStatus.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)

                        End If
                    End If
                Else
                    If drpProgram.SelectedValue <> "Filter By Program" Then
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By Program and state
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByState", "@TicketFolderID", _ID, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)

                        Else
                            'Filter By Program
                        End If
                    Else
                        If drpState.SelectedValue <> "Filter By State" Then
                            'Filter By State
                            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByState", "@TicketFolderID", _ID, "@StateID", CType(drpState.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                        Else
                            'Dont filter - Show all the tickets in the folder
                            ldr1.LoadTwoLongParameterDataGrid("spListTicketsInFolder", "@TicketFolderID", _ID, "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
                        End If
                    End If
                End If
            End If
        Else
            ldr1.LoadThreeLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", _ID, "@PartnerID", CType(drpPartners.SelectedValue, Long), "CountryID", _CountryID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
        End If
  End Sub
 
  Private Sub LoadCustomers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListActiveCustomers", "Company", "CustomerID", drpPartnerAgents)
        drpPartnerAgents.Items.Add("Choose One")
        drpPartnerAgents.SelectedValue = "Choose One"
        
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
    
        'ldr.LoadSimpleDropDownList("spListStates", "StateName", "StateID", drpState)
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
    
    'ldr.LoadSimpleDropDownList("spListActivePartnersWithCalls","ResumeID","PartnerID" , drpPartners)
    ldr.LoadSingleLongParameterDropDownList ("spListPartnersByTicketFolderID","@TicketFolderID",_ID,"ResumeID","PartnerID",drpPartners)
        drpPartners.Items.Add("Choose One")
        drpPartners.SelectedValue = "Choose One"
 End Sub

    Private Sub btnEmail_Click(ByVal S As Object, ByVal E As EventArgs)
        'drpCustomers.selectedValue = "Choose one"
        'LoadTicketsByPartners(CType(Request.QueryString("id"), Long),Ctype(drpPartners.SelectedValue,long) )
    
    End Sub
  

    Protected Sub drpPartnerAgents_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpPartnerAgents.SelectedValue <> "Choose One" Then
            LoadTicketsByCustomer(CType(Request.QueryString("id"), Long), CType(drpPartnerAgents.SelectedValue, Long))
            drpPartners.SelectedValue = "Choose One"
        End If
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
            LoadTicketsByPartners(CType(Request.QueryString("id"), Long), CType(drpPartners.SelectedValue, Long))
            'drpCustomers.SelectedValue = "Choose One"
        End If
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server">
    <table style="width: 100%">
      <tbody>
        <tr>
          <td class="band" style="width: 1%">
            <div class="bandheader">Vendors</div>
            <asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartners_SelectedIndexChanged" />
            
            <div class="bandheader"></div>
            <span style="white-space:nowrap">
            <asp:DropDownList ID="drpPartnerAgents"  Visible="false" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartnerAgents_SelectedIndexChanged" />
            </span>
            
            <div class="bandheader">Folders</div>
            <asp:DataGrid ID="dgvFolders" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
              <ItemStyle CssClass="bandbar" />
              <Columns>
                <asp:BoundColumn DataField="TicketFolderID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" >
                  <ItemTemplate>
                    <a href="tickets.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketFolderID") %>&CustID=<%# drpPartnerAgents.selectedValue %>"><%# DataBinder.Eval(Container.DataItem,"FolderName") %></a>&nbsp;(<%# DataBinder.Eval(Container.DataItem,"TicketCount") %>)
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>              
            </asp:DataGrid>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Commands</div>
            <div class="inputform">
              <div><a href="addticketchoosecustomer.aspx?returnurl=tickets.aspx">Add Ticket</a></div>
              <div><a href="findticket.aspx">Find Ticket</a></div>
            </div>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Jump To</div>
            <div class="inputform">
              <div class="errorzone" id="divJumpToError" runat="server" visible="false" />
              <div class="label">Ticket ID</div>
              <div><asp:TextBox ID="txtTicketID" runat="server" /></div>
              <div style="text-align: right;"><asp:Button ID="btnJump" runat="server" Text="Jump" OnClick="btnJump_Click" /></div>
            </div>
          </td>
          <td style="width: 3px;">&nbsp;</td>
          <td>
            <div class="inputformsectionheader">
                <asp:Label ID="lblTicketCount" runat="server"></asp:Label>
                <asp:DropDownList ID="drpCustomers1" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpStatus" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpProgram" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpState" Runat="server" AutoPostBack="True" />
            </div>
            <div class="inputform">
              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand" CssClass="Grid1">
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
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>