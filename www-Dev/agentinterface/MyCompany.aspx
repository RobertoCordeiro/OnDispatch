<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ Register Assembly="RadCalendar.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ID As Long = 0 'customer ID 
    Private mListTotal As Double
    Private _PartnerID As Long = 0
    Private _infoID As Long = 0
    Private _CustomerInfoID As Long = 0
    Private _tab As Long = 0
    Private _ReturnURL As String = ""
    Private mListTotalCharged As Double
    Private _IvID As Long = 0
    Private mListLaborTotal As Double
    Private mListExtraTotal As Double
    Private mListPartTotal As Double
    Private mListTotal1 As Double
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      
      Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    Try
      _infoID = CType(Request.QueryString("infoID"), Long)
    Catch ex As Exception
      _infoID = 0
    End Try
    Try
      _tab = CType(Request.QueryString("t"), Long)
    Catch ex As Exception
      _tab = 0
        End Try
        Try
            _IvID = CType(Request.QueryString("IvID"), Long) ' Prior invoice ID
        Catch ex As Exception
            _IvID = 0
        End Try
      
            Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Home"
            Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Home"
            Master.PageSubHeader = " <a href=""default.aspx"">My Desktop</a> |"
            Master.PageSubHeader = Master.PageSubHeader & " <a target='_blank' href=""customers.aspx"">Customers</a> |"
            Master.PageSubHeader = Master.PageSubHeader & " <a target='_blank' href=""salesteam.aspx"">Sales Team</a> |"
            Master.PageSubHeader = Master.PageSubHeader & " <a target='_blank' href=""suppliers.aspx"">Suppliers</a> |"
            Master.PageSubHeader = Master.PageSubHeader & " <a target='_blank' href=""partners.aspx"">Partners</a> |"
            Master.PageSubHeader = Master.PageSubHeader & " <a target='_blank' href=""accountsreceivables.aspx?id=" & _infoID & """>Accounts Receivable</a> |"
            Master.PageSubHeader = Master.PageSubHeader & " <a target='_blank' href=""salesteam.aspx"">Inventory</a> |"
            Master.PageSubHeader = Master.PageSubHeader & " <a target='_blank' href=""recruit.aspx"">Recruiting</a> |"
            Master.PageSubHeader = Master.PageSubHeader & " <a target='_blank' href=""customerservicecontrol.aspx"">Manage Tickets</a> |"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
       Dim inf As New BridgesInterface.CompanyInfoRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn") )
       inf.Load(_infoID)
       
       If inf.CustomerID <> _ID Then
                Response.Redirect("/agentinterface/default.aspx")
                If Master.InfoID <> _infoID then
                  Response.Redirect("/logout.aspx")
                end if
       End If
       
      If Not IsPostBack Then
                LoadCustomer()
                menu.Items(_tab).Selected = True
                Multiview1.ActiveViewIndex = _tab
                
                If _tab = 5 Then
                   
                    If _IvID = 0 Then
                        MultiviewPriorInvoices.ActiveViewIndex = 0
                        
                    
                    Else
                        MultiviewPriorInvoices.ActiveViewIndex = 1
                        LoadTicketsByInvoiceID(_IvID, _ID)
                    End If
                End If
           
            End If
           
    End If
    
  End Sub

    Private Sub LoadCustomer()
        Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        cst.Load(_ID)
        _PartnerID = inf.PartnerID
        
        Master.PageHeaderText = cst.Company
        
        If cst.FirstName.Trim.Length > 0 Then
            If cst.Company.Trim.Length > 0 Then
                Master.PageHeaderText &= " : "
            End If
            Master.PageHeaderText &= " " & cst.Title & " " & cst.FirstName & " " & cst.MiddleName & " " & cst.LastName & " " & cst.Suffix
        End If
        lblCompany.Text = cst.Company
        lblName.Text = cst.Title & " " & cst.FirstName & " " & cst.MiddleName & " " & cst.LastName & " " & cst.Suffix
        lnkWebsite.HRef = "http://" & cst.WebSite
        lblWebsite.Text = cst.WebSite
        lnkEmail.HRef = "mailto:" & cst.Email
        lblEmail.Text = cst.Email
        lnkInternalEmail.HRef = "mailto:" & cst.InternalEmail
        lblInternalEmail.Text = cst.InternalEmail
        lblDateCreated.Text = cst.DateCreated.ToString
        lblRef1Label.Text = cst.Ref1Label
        lblRef2Label.Text = cst.Ref2Label
        lblRef3Label.Text = cst.Ref3Label
        lblRef4Label.Text = cst.Ref4Label
        lblTaxExempt.Text = cst.TaxExempt.ToString
        If cst.Active Then
            lblStatus.Text = "Active"
        Else
            lblStatus.Text = "Inactive"
        End If
        lnkEdit.HRef = "editcustomer.aspx?id=" & _ID.ToString
        LoadUsers(_infoID)
        LoadAgents(_infoID)
        LoadAddresses()
        LoadPhoneNumbers()
        LoadServiceTypes()
        
    End Sub

  Private Sub btnAddAgent_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
    strQueryString = strQueryString.Replace("?", "%3f")
    strQueryString = strQueryString.Replace("&", "%26")
        Response.Redirect("adduser.aspx?id=" & _ID & "&returnurl=mycompany.aspx%3f" & strQueryString & "&t=1", True)
  End Sub
  
  Private Sub btnAddServiceType_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
    strQueryString = strQueryString.Replace("?", "%3f")
    strQueryString = strQueryString.Replace("&", "%26")
    Response.Redirect("addservicetype.aspx?id=" & _ID, True)
  End Sub
  
  Private Sub btnAddAddress_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
    strQueryString = strQueryString.Replace("?", "%3f")
    strQueryString = strQueryString.Replace("&", "%26")
    Response.Redirect("addaddress.aspx?id=" & _ID.ToString & "&mode=customer", True)    
  End Sub
  
  Private Sub btnAddPhoneNumber_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
    strQueryString = strQueryString.Replace("?", "%3f")
    strQueryString = strQueryString.Replace("&", "%26")
    Response.Redirect("addphone.aspx?id=" & _ID.ToString & "&mode=customer", True)
  End Sub
  
   
  Private Sub btnAddTicket_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
    strQueryString = strQueryString.Replace("?", "%3f")
    strQueryString = strQueryString.Replace("&", "%26")
    Response.Redirect("addticket.aspx?id=" & _ID.ToString & "&mode=customer&returnurl=customer.aspx%3f" & strQueryString, True)
  End Sub
  
  Private Sub LoadServiceTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListServiceTypes", "@CustomerID", _ID, dgvServiceTypes)
  End Sub
  
  
  
  Private Sub LoadAddresses()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListAddressesForCustomer")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@CustomerID", Data.SqlDbType.Int).Value = _ID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvAddresses.DataSource = ds
    dgvAddresses.DataBind()
    cnn.Close()
  End Sub
  
  Private Sub LoadPhoneNumbers()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListPhoneNumbersForCustomer")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@CustomerID", Data.SqlDbType.Int).Value = _ID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvPhoneNumbers.DataSource = ds
    dgvPhoneNumbers.DataBind()
    cnn.Close()
  End Sub
  
  Private Function BuildEmailHref(ByVal strEmail As String) As String
    Dim strReturn As String = ""
    If strEmail.Trim.Length > 0 Then
      strReturn = "mailto:" & strEmail
    Else
      strReturn = ""
    End If
    Return strReturn
  End Function
  
  Private Sub menu_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu.MenuItemClick
        Multiview1.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0 'programs
                LoadServiceTypes()
            Case Is = 1 'contacts
                LoadUsers(_infoID)
            Case Is = 2 'Field Technicians
                LoadAgents( _infoID)
            Case Is = 3 'phone numbers
                LoadPhoneNumbers()
            Case Is = 4 'addresses
                LoadAddresses()
            Case Is = 5 'prior invoices
                RadDatePickerFrom.SelectedDate = DateTime.Now.Date
                RadDatePickerTo.SelectedDate = DateTime.Now.Date
                LoadPriorInvoices(RadDatePickerFrom.SelectedDate.ToString, RadDatePickerTo.SelectedDate.ToString)
            Case Is = 6 ' Attached documents
                LoadAttachedDocuments(_ID)
        End Select
        
    End Sub
    Private Sub LoadPriorInvoices(ByVal datStartDate As Date, ByVal datEndDate As Date)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim dgv1 As System.Web.UI.WebControls.DataGrid
        'ldr.LoadSingleLongParameterDataGrid("spGetCustomerPriorInvoices", "@CustomerID", _ID, dgvPriorInvoices)
        ldr.LoadLongTwoDateParameterDataGrid("spGetCustomerPriorInvoicesByDate", "@CustomerID", _ID, "@StartDate", datStartDate, "@EndDate", datEndDate, dgvPriorInvoices)
        For Each itm As DataGridItem In dgvPriorInvoices.Items
            If CType(itm.Cells(0).Text, Long) = _ID Then
                itm.CssClass = "selectedbandbar"
            End If
            dgv1 = itm.FindControl("dgvPayments")
            LoadPayments(CType(itm.Cells(0).Text, Long), dgv1)
        Next
    
    End Sub
  Private Sub LoadPayments(lngInvoiceID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spGetInvoiceLaborPaymentsByInvoiceID", "@InvoiceID", lngInvoiceID, dgv)
      End If
  End Sub
  Private Sub LoadPartPayments(lngCustomerID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spPartsNotCreditByCustomer", "@CustomerID", lngCustomerID, dgv)
      End If
  End Sub
  
  Private Sub LoadOutstandingBalance(lngCustomerID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
            ' ldr.LoadSingleLongParameterDataGrid("spOutstandingBalanceByCustomer", "@CustomerID", lngCustomerID, dgvOutstandingBalance)
      End If
  End Sub
    Private Sub LoadAttachedDocuments(ByVal lngCustomerID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDataGrid("spGetCustomerDocuments", "@CustomerID", lngCustomerID, dgvAttachments)
    End Sub

    Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect("CustomerDocumentsUpload.aspx?fid=0" & "&id=" & _ID & "&returnurl=" & _ReturnURL & "&mode=doc&updt=0")
    End Sub
    
    Private Sub Item_Click(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs)
        Dim strTest As String
        
        strTest = (CType(e.CommandSource, LinkButton)).CommandName
        Select Case (CType(e.CommandSource, LinkButton)).CommandName
            
            Case "View"
                Dim exp As New cvCommon.Export
                Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
                Dim lngID As Long
                
                lngID = CType(e.Item.Cells(2).Text, Long)
                strTest = e.Item.Cells(1).Text
                
                fil.Load(lngID)
                exp.BinaryFileOut(Response, fil, System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection"))
                
            Case "Update"
                Dim lngFileID As Long
                lngFileID = CType(e.Item.Cells(2).Text, Long)
                Response.Redirect("CustomerDocumentsUpload.aspx?fid=" & CType(e.Item.Cells(0).Text, Long) & "&id=" & _ID & "&returnurl=" & _ReturnURL & "&mode=doce&updt=" & lngFileID)

            Case "Remove"

                Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
                Dim prt As New BridgesInterface.CustomerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim lngFilID As Long
                Dim DocID As Long
                DocID = CType(e.Item.Cells(0).Text, Long)
                lngFilID = CType(e.Item.Cells(2).Text, Long)
                prt.Load(DocID)
                fil.Load(lngFilID)
                
                Dim strChangelog As String = ""
                Dim ptr As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                ptr.Load(_ID)
                'Dim rnt As New BridgesInterface.ResumeNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'rnt.Add(CType(ptr.ResumeID, Long), Master.UserID, "Auto Note: A Document has been removed from Vendor's Account: " & e.Item.Cells(1).Text)
                fil.Delete()
                prt.Delete()
                Response.Redirect(_ReturnURL & "&returnurl=" & _ReturnURL )
        End Select
    End Sub
    Private Sub LoadUsers(ByVal lngInfoID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListAllUsersByCompanyID", "@InfoID", lngInfoID, dgvUsers)
    End Sub
    Private Sub LoadAgents(ByVal lngInfoID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        inf.Load(lngInfoID)

        ldr.LoadTwoLongParameterDataGrid("spListPartnerAgentsByCompanyInfoID", "@PartnerID", inf.PartnerID, "@InfoID", inf.InfoID, dgvAgents)
    End Sub
    Private Sub btnAddTech_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
        strQueryString = strQueryString.Replace("?", "%3f")
        strQueryString = strQueryString.Replace("&", "%26")
        Response.Redirect("addpartneragent.aspx?id=" & _ID.ToString & "&mode=customer&returnurl=mycompany.aspx%3f" & strQueryString & "&t=2", True)
    End Sub
    Private Sub btnView_Click(ByVal S As Object, ByVal E As EventArgs)
        LoadPriorInvoices(RadDatePickerFrom.SelectedDate.ToString, RadDatePickerTo.SelectedDate.ToString)
    End Sub
    
    Private Sub dgvPriorInvoices_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvPriorInvoices.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim listTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalLabel As System.Web.UI.WebControls.Literal
                
        'check the type of item that was databound and only take action if it 
        'was a row in the datagrid
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)

                'get the value for the Total and add it to the sum
                If Not IsDBNull(rowData.Item("Total")) Then
                    price = CDec(rowData.Item("Total"))
                    mListTotalCharged += price
                End If
                'get the control used to display the total price
                listTotalLabel = CType(e.Item.FindControl("lblTotal"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listTotalLabel.Text = price.ToString("C2")
                
            Case ListItemType.Footer

                GrandTotalLabel = CType(e.Item.FindControl("lblGrandTotalAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalLabel.Text = mListTotalCharged.ToString("C2")

                
        End Select
        
    End Sub  'dgvPriorInvoices_ItemDataBound
    
    Private Sub dgvTickets_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvTickets.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim price As Decimal
        Dim listLaborLabel As System.Web.UI.WebControls.Literal
        Dim listPartLabel As System.Web.UI.WebControls.Literal
        Dim listExtraLabel As System.Web.UI.WebControls.Literal
        Dim listTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandLabortotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandExtraTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandPartTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalLabel As System.Web.UI.WebControls.Literal
        Dim strStatus As String
        Dim datClosingDate As Date
        Dim lblClosingDate As System.Web.UI.WebControls.Literal
        
        'check the type of item that was databound and only take action if it 
        'was a row in the datagrid
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                'get the data for the item being bound
                
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                strStatus = (rowData.Item("Status"))
                If strStatus = "Closed - Canceled" Then
                    e.Item.ForeColor = Drawing.Color.Red
                End If
                
                datClosingDate = (rowData.Item("CloseDate"))
                lblClosingDate = CType(e.Item.FindControl("lblCloseDate"), System.Web.UI.WebControls.Literal)
                lblClosingDate.text = FormatDateTime(datClosingDate, DateFormat.ShortDate).ToString
                
                'get the value for the laboramount and add it to the sum
                price = CDec(rowData.Item("LaborAmount"))
                mListLaborTotal += price
                
                If price = 0 And strStatus <> "Closed - Canceled" Then
                    e.Item.ForeColor = Drawing.Color.RoyalBlue
                End If
                
                
                'get the control used to display the list price
                'NOTE: This can be done by using the FindControl method of the 
                '      passed item because ItemTemplates were used and the anchor
                '      controls in the templates where given IDs.  If a standard
                '      BoundColumn was used, the data would have to be accessed
                '      using the cellscollection (e.g. e.Item.Cells(1).controls(1)
                '      would access the label control in this example.
                listLaborLabel = CType(e.Item.FindControl("lblLaborAmount"), System.Web.UI.WebControls.Literal)
          
                'now format the list price in currency format
                listLaborLabel.Text = price.ToString("C2")

                'get the value for the extra amount and add it to the sum
                price = CDec(rowData.Item("AdjustCharge"))
                mListExtraTotal += price

                'get the control used to display the discounted price
                listExtraLabel = CType(e.Item.FindControl("lblAdjustCharge"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listExtraLabel.Text = price.ToString("C2")
                

                'get the value for the PartAmount and add it to the sum
                If Not IsDBNull(rowData.Item("PartAmount")) Then
                    price = CDec(rowData.Item("PartAmount"))
                    mListPartTotal += price
                    
                    If (price > 0) And (strStatus = "Closed - Resolved") And listLaborLabel.Text = 0 Then
                        e.Item.ForeColor = Drawing.Color.DarkGreen
                    End If
                End If
                'get the control used to display the PartAmount price
                listPartLabel = CType(e.Item.FindControl("lblPartAmount"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listPartLabel.Text = price.ToString("C2")

                'get the value for the Total and add it to the sum
                If Not IsDBNull(rowData.Item("Total")) Then
                    price = CDec(rowData.Item("Total"))
                    mListTotal1 += price
                End If
                'get the control used to display the PartAmount price
                listTotalLabel = CType(e.Item.FindControl("lblTotal"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listTotalLabel.Text = price.ToString("C2")
                
            Case ListItemType.Footer

                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                GrandLabortotalLabel = CType(e.Item.FindControl("lblTotalLaborAmount"), System.Web.UI.WebControls.Literal)
                GrandLabortotalLabel.Text = mListLaborTotal.ToString("C2")
          
                'get the control used to display the total of the extra prices
                'and set its value to the total of the discounted prices
                GrandExtraTotalLabel = CType(e.Item.FindControl("lblTotalAdjustCharge"), System.Web.UI.WebControls.Literal)
                GrandExtraTotalLabel.Text = mListExtraTotal.ToString("C2")
                
                GrandPartTotalLabel = CType(e.Item.FindControl("lblTotalPartAmount"), System.Web.UI.WebControls.Literal)
                GrandPartTotalLabel.Text = mListPartTotal.ToString("C2")
                
                GrandTotalLabel = CType(e.Item.FindControl("lblGrandTotalAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalLabel.Text = mListTotal1.ToString("C2")
                
            Case Else
                'ListItemType.Header, ListItemType.Pager, or ListItemType.Separator
                'no action required
                
        End Select
        
    End Sub  'dgvTickets_ItemDataBound
    
    Private Sub LoadTicketsByInvoiceID(ByVal lngInvoiceID As Long, ByVal lngCustomerID As Long)
       
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByInvoiceID", "@InvoiceID", lngInvoiceID, dgvTickets)
        'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers.SelectedValue, Long), dgvTickets)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
       
    End Sub
    
    Protected Sub dgvTickets_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If lblSortOrder.Text.ToLower = " asc" Then
            lblSortOrder.Text = " desc"
        Else
            lblSortOrder.Text = " asc"
        End If
        ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByCustomer", "@CustomerID", _ID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataView).Count & " ) "
    End Sub
    
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmCustomer" runat="server" >
     <table width="100%">
      <tbody>
        <tr>
           <td rowspan="2" class="band">
            <div class="inputformsectionheader">Commands</div>
            <div class="inputform">
               <div><a id="lnkEdit" runat="server">Edit</a></div>
            </div>
          </td>  
          <td>            
            <table width="50%">
              <tbody>
                <tr>
                  <td class="label">Company</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblCompany" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label">Customer Since</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblDateCreated" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Name</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblName" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label">Status</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblStatus" runat="server" /></td>                  
                </tr>
                <tr>
                  <td class="label">Email</td>
                  <td>&nbsp;</td>                  
                  <td><a id="lnkEmail" runat="server"><asp:Label ID="lblEmail" runat="server" /></a></td>
                  <td>&nbsp;</td>
                  <td class="label">Tax Exempt</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblTaxExempt" runat="server" /></td>                  
                </tr>
                <tr>
                  <td class="label">Internal Email</td>
                  <td>&nbsp;</td>
                  <td colspan="5"><a id="lnkInternalEmail" runat="server"><asp:Label ID="lblInternalEmail" runat="server" /></a></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="label">Website</td>
                  <td>&nbsp;</td>
                  <td colspan="5"><a target="_blank" id="lnkWebsite" runat="server"><asp:Label ID="lblWebsite" runat="server" /></a></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </tbody>
            </table>      
            <div>&nbsp;</div>
            <table>
              <tbody>
                <tr>
                  <td class="label">Ref 1 Label</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef1Label" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label">Ref 2 Label</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef2Label" runat="server" /></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class="label">Ref 3 Label</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef3Label" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label">Ref 4 Label</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef4Label" runat="server" /></td>
                  <td>&nbsp;</td>          
                </tr>
              </tbody>
            </table>
            <div>&nbsp;</div>
            <div id="tab5">
          <asp:Menu ID="menu" runat="server" Orientation="Horizontal" OnMenuItemClick ="menu_MenuItemClick" CssClass="ul">
             <StaticMenuItemStyle CssClass="li" />
             <StaticHoverStyle CssClass="hoverstyle" />
             <StaticSelectedStyle CssClass="current" />
             <Items>
                <asp:MenuItem  value ="0" Text="Programs"></asp:MenuItem>
                <asp:MenuItem value ="1" Text="Contacts / Agents"></asp:MenuItem> 
                <asp:MenuItem value ="2" Text="Field Technicians"></asp:MenuItem> 
                <asp:MenuItem value = "3" Text="Phone Numbers"></asp:MenuItem>
                <asp:MenuItem value = "4" Text="Addresses"></asp:MenuItem>
                <asp:MenuItem value = "5" Text="Prior Invoices"></asp:MenuItem>
                <asp:MenuItem value = "6" Text="Attached Documents"></asp:MenuItem>
             </Items>
           </asp:Menu>
          </div>
          <div id="ratesheader" class="tabbody">
          <div>&nbsp;</div>
          <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
          <asp:View ID="viewPrograms"  runat="server">
          <div class="tabbody" style="text-align :right "><asp:Button ID="btnAddServiceType" runat="server" Text="Add Program" OnClick="btnAddServiceType_Click" /></div>            
            <asp:DataGrid ID="dgvServiceTypes" AutoGenerateColumns="false" style="background-color: white; width: 100%" runat="server" CssClass="Grid1">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn
                  HeaderText="ID"
                  DataField="ServiceTypeID"
                  visible="false"
                  />
                <asp:TemplateColumn>
                  <ItemTemplate>
                    <a href="editservicetype.aspx?id=<%# DataBinder.Eval(Container.DataItem,"ServiceTypeID") %>">[Edit]</a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn
                  HeaderText="Program"
                  DataField="ServiceType"
                  />
                <asp:TemplateColumn
                  HeaderText="Author"
                  >
                  <ItemTemplate>
                    <a href="mailto:<%# DataBinder.Eval(Container.DataItem,"Email") %>"><%#DataBinder.Eval(Container.DataItem, "Author")%></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn 
                  HeaderText="Active"
                  >             
                  <ItemTemplate>
                    <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>         
                <asp:BoundColumn
                  HeaderText="Date&nbsp;Created"
                  DataField="DateCreated"
                  />
              </Columns>      
            </asp:DataGrid>
            </asp:View>
            <asp:View ID="viewContacts"  runat="server">
            <div style="text-align :right "><asp:Button ID="btnAddAgent" runat="server" Text="Add Agent" OnClick="btnAddAgent_Click" /></div>
            <asp:DataGrid AutoGenerateColumns="false" style="background-color: white; width: 100%" ID="dgvUsers" runat="server" Cssclass="Grid1">
                  <AlternatingItemStyle CssClass="altrow" />
                  <HeaderStyle CssClass="gridheader" />
                  <Columns>
                    <asp:BoundColumn HeaderText="ID" Visible="false" DataField="UserID" />
                    <asp:TemplateColumn >
                      <ItemTemplate>
                        <a href="user.aspx?id=<%# DataBinder.Eval(Container.DataItem,"UserID") %>&returnurl=mycompany.aspx%3fid=<%# _ID %>&infoID=<%# _infoID %>">[Edit]</a>
                      </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:BoundColumn HeaderText="Login ID" DataField="UserName" />
                    <asp:templatecolumn HeaderText="Name">
                      <ItemTemplate>
                        <a href="mailto:<%# DataBinder.Eval(Container.DataItem,"Email") %>"><%# DataBinder.Eval(Container.DataItem,"Title") %> <%# DataBinder.Eval(Container.DataItem,"FirstName") %> <%# DataBinder.Eval(Container.DataItem,"MiddleName") %> <%# DataBinder.Eval(Container.DataItem,"LastName") %> <%# DataBinder.Eval(Container.DataItem,"Suffix") %></a>
                      </ItemTemplate>
                    </asp:templatecolumn>
                    <asp:BoundColumn HeaderText="Extension" DataField="Extension" />
                    <asp:BoundColumn HeaderText="Active" DataField="Active" />
                    <asp:BoundColumn HeaderText="Emp. Start" DataField="EmploymentStart" />
                    <asp:BoundColumn HeaderText="Emp. End" DataField="EmploymentEnd" />
                    <asp:BoundColumn HeaderText="Date Created" DataField="DateCreated" />
                  </Columns>
                </asp:DataGrid>
            </asp:View> 
            <asp:View ID="ViewFieldTechnicians"  runat="server">
            <div style="text-align :right "><asp:Button ID="btnAddTech" runat="server" Text="Add Tech" OnClick="btnAddTech_Click" /></div>
            <asp:DataGrid style="background-color: white; width: 100%" ID="dgvAgents" AutoGenerateColumns="false" runat="server" Cssclass="Grid1">
              <HeaderStyle cssclass="gridheader" />
              <AlternatingItemStyle cssclass="altrow" />  
              <Columns>
                <asp:BoundColumn
                  HeaderText="ID"
                  DataField="PartnerAgentID"
                  Visible="false"
                />
                <asp:TemplateColumn
                  HeaderText="Command"
                  >
                  <ItemTemplate>
                    <a href="editpartneragent.aspx?id=<%# DataBinder.Eval(Container.DataItem,"PartnerAgentID") %>&returnurl=mycompany.aspx%3fid=<%# _ID %>&t=2&infoID=<%# _infoID %>">[Open]</a>
                  </ItemTemplate>
                </asp:TemplateColumn>                
                <asp:BoundColumn
                  HeaderText="Type"
                  DataField="AgentType"
                  />
                  <asp:BoundColumn
                  HeaderText="Status"
                  DataField="PartnerAgentStatus"
                  />
                <asp:TemplateColumn
                  HeaderText="Name"
                  >
                  <Itemtemplate>
                    <%# DataBinder.Eval(Container.DataItem,"FirstName") %>&nbsp;<%# DataBinder.Eval(Container.DataItem,"MiddleName") %>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%>                    
                  </Itemtemplate>                  
                </asp:TemplateColumn>
                <asp:TemplateColumn 
                  HeaderText="Admin"
                  >             
                  <ItemTemplate>
                    <img alt="Admin Agent" src="/graphics/<%# Databinder.eval(Container.DataItem, "AdminAgent") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn 
                  HeaderText="Active"
                  >             
                  <ItemTemplate>
                    <img alt="Active" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn
                  DataField="LastLogIn"
                  HeaderText="Last Login"
                  />                
              </Columns>
            </asp:DataGrid>            
            </asp:View>
            <asp:View ID="viewPhoneNumbers"  runat="server">
            <div style="text-align :right "><asp:Button ID="btnAddPhoneNumber" runat="server" OnClick="btnAddPhoneNumber_Click" text="Add Phone Number" /></div>
            <asp:DataGrid style="background-color: white; width:100%" ID="dgvPhoneNumbers" runat="server" AutoGenerateColumns="false" Cssclass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
              <asp:TemplateColumn>          
                  <Itemtemplate>
                    <a href="editphone.aspx?&id=<%# DataBinder.Eval(Container.DataItem,"CustomerPhoneNumberID") %>&mode=customer&returnurl=mycompany.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"CustomerID") %>%26t=3%26infoID=<%# _infoID %>">Edit</a>
                  </Itemtemplate>
                </asp:TemplateColumn>  
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
              </Columns>                
            </asp:DataGrid> 
            </asp:View>  
            <asp:View ID="viewAddresses"  runat="server"> 
            <div style="text-align :right "><asp:Button ID="btnAddAddress" runat="server" OnClick="btnAddAddress_Click" Text="Add Address" /></div> 
            <asp:DataGrid style="background-color: white; width: 100%" AutoGenerateColumns="false" ID="dgvAddresses" runat="server" Cssclass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:TemplateColumn>
                  <Itemtemplate>
                    <a href="editaddress.aspx?id=<%# DataBinder.Eval(Container.DataItem,"CustomerAddressID") %>&mode=customer&returnurl=mycompany.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"CustomerID") %>%26t=4%26infoID=<%# _infoID %>">Edit</a>
                  </Itemtemplate>
                </asp:TemplateColumn>
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
              </Columns>        
            </asp:DataGrid>
            </asp:View>
            <asp:View ID="viewOldInvoices"  runat="server">
              <asp:MultiView ID="MultiviewPriorInvoices" runat="server" ActiveViewIndex="0">
                <asp:View ID="viewInvoices" runat="server">
                       <div style="background-color:#83acca; text-align:center;" class="tabbody">
                    <table >
                      <tr>
                        <td>
                           <div><rad:RadDatePicker ID="RadDatePickerFrom" runat="server"  DateInput-Font-Size="Medium" Culture="English (United States)" SelectedDate="2012-05-15" Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" Calendar-MonthLayout="Layout_7columns_x_6rows">
                               <DateInput Font-Size="Medium" Skin="">
                               </DateInput>
                           </rad:RadDatePicker></div>
                        </td>
                        <td>
                           <div><rad:RadDatePicker ID="RadDatePickerTo" runat="server"  DateInput-Font-Size="Medium" Culture="English (United States)" SelectedDate="2012-05-15" Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" Calendar-MonthLayout="Layout_7columns_x_6rows">
                               <DateInput Font-Size="Medium" Skin="">
                               </DateInput>
                           </rad:RadDatePicker></div>
                        </td>
                        <td>
                           <div><asp:Button ID="btnView" runat="server"  Text="View" OnClick="btnView_Click"/></div>
                        </td>
                      </tr>
                     </table> </div>
                    <asp:DataGrid ID="dgvPriorInvoices" runat="server" style="background-color: white; width: 100%"  AutoGenerateColumns="false" ShowFooter = "True" Cssclass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
                      <HeaderStyle CssClass="gridheader" />
                      <AlternatingItemStyle CssClass="altrow" />   
                      <Columns>
                        <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" Visible="false" />
                        <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText="Invoice Number" >
                          <ItemTemplate>
                            <a href="mycompany.aspx?id=<%#_ID%>&infoID=<%#_InfoID%>&IvID=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>&t=5&dt1=<%=RadDatePickerFrom.SelectedDate%>&dt2=<%=RadDatePickerTo.SelectedDate%>"><%# DataBinder.Eval(Container.DataItem,"InvoiceNumber") %></a>&nbsp;<a target="_blank" href="OldInvoicesReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Group Invoices" src="/graphics/printable.png" />&nbsp;</a><a target="_blank" href="OldSingleInvoicesReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Single Invoices" src="/graphics/printable.png" /></a>
                          </ItemTemplate>
                        </asp:TemplateColumn>
                          <asp:TemplateColumn SortExpression="Total" HeaderText="Total Labor" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Literal id="lblTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Total")%>' />
                            </ItemTemplate>
                            <FooterTemplate >
                            <asp:Literal id="lblGrandTotalAmount" runat="server" />
                          </FooterTemplate>
                          </asp:TemplateColumn>
                        <asp:BoundColumn DataField="Total" HeaderText="Total Labor"  DataFormatString="{0:C}" Visible="false"/>
                        <asp:BoundColumn DataField="TotalPaid" HeaderText="Total Labor Paid"  DataFormatString="{0:C}"/>
                        <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}"/>
                        <asp:TemplateColumn HeaderText ="Payment Records">
                          <ItemTemplate>
                             <asp:DataGrid Visible="True" ID="dgvPayments" style="width: 100%" runat="server" AutoGenerateColumns="false" Cssclass="Grid1">
                                <HeaderStyle CssClass="gridheader" />
                                  <AlternatingItemStyle CssClass="altrow" />   
                                    <Columns>
                                       <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                                       <asp:BoundColumn DataField="checkNumber" HeaderText="CheckNumber" />            
                                       <asp:BoundColumn DataField="Amount" HeaderText="CheckAmount" DataFormatString="{0:C}" />
                                       <asp:BoundColumn DataField="PayDate" HeaderText="PayDate" />
                                       <asp:BoundColumn DataField="PaymentType" HeaderText="Method" />
                                    </Columns>                
                             </asp:DataGrid>    
                          </ItemTemplate>
                        </asp:TemplateColumn>
                      </Columns>              
                    </asp:DataGrid>
                    <div>&nbsp;</div> 
                 </asp:View>
                 <asp:View ID="viewInvoiceDetails" runat="server">
                      <div style="text-align: left;" ><a href="javascript:history.go(-1)">Go back</a>

                        <div class="inputformsectionheader">Invoice Details <asp:Label ID="lblTicketCount" runat="server"></asp:Label>
                        </div>
                        <div class="inputform">
                          <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand" ShowFooter = "True" Cssclass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
                            <AlternatingItemStyle CssClass="altrow" />
                            <HeaderStyle CssClass="gridheader" />
                            <Columns>
                              <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                              <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                                <ItemTemplate>
                                 <a target="_blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="InvoiceSingleTicket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><img style="border: 0" alt="Single Invoices" src="/graphics/printable.png" /></a>
                                </ItemTemplate>
                              </asp:TemplateColumn>
                              <asp:TemplateColumn SortExpression="Company" HeaderText="Customer">
                                <ItemTemplate>
                                   <asp:Literal id="lblCompany" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Company") %>' />
                                </ItemTemplate>
                              </asp:TemplateColumn>
                              <asp:TemplateColumn SortExpression="CustomerPO" HeaderText="CustomerPO">
                                <ItemTemplate>
                                    <asp:Literal id="lblCustomerPO" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CustomerPO") %>' />
                                </ItemTemplate>
                              </asp:TemplateColumn>
                              <asp:TemplateColumn SortExpression="Status" HeaderText="Status">
                                <ItemTemplate>
                                     <asp:Literal id="lblStatus" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Status")%>' />
                                </ItemTemplate>
                              </asp:TemplateColumn>
                              <asp:TemplateColumn SortExpression="CloseDate" HeaderText="CloseDate">
                                <ItemTemplate>
                                     <asp:Literal id="lblCloseDate" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "CloseDate")%>' />
                                </ItemTemplate>
                              </asp:TemplateColumn>
                              <asp:TemplateColumn SortExpression="ServiceType" HeaderText="ServiceType" Footertext="Grand Total:">
                                <ItemTemplate>
                                    <asp:Literal id="lblServiceType" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Servicename")%>' />
                                </ItemTemplate>
                              </asp:TemplateColumn>
                              <asp:TemplateColumn SortExpression="LaborAmount" HeaderText="Labor" ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:Literal id="lblLaborAmount" runat="server"  text='<%#DataBinder.Eval(Container.DataItem, "LaborAmount")%>' />
                                </ItemTemplate>
                                <FooterTemplate  >
                                <asp:Literal id="lblTotalLaborAmount" runat="server" />
                              </FooterTemplate>
                              </asp:TemplateColumn>
                              <asp:TemplateColumn SortExpression="AdjustCharge" HeaderText="Extra" ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:Literal id="lblAdjustCharge" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "AdjustCharge")%>' />
                                </ItemTemplate>
                                <FooterTemplate >
                                <asp:Literal id="lblTotalAdjustCharge" runat="server" />
                              </FooterTemplate>
                              </asp:TemplateColumn>
                              <asp:TemplateColumn SortExpression="PartAmount" HeaderText="Part" ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:Literal id="lblPartAmount" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "PartAmount")%>' />
                                </ItemTemplate>
                                <FooterTemplate >
                                <asp:Literal id="lblTotalPartAmount" runat="server" />
                              </FooterTemplate>
                              </asp:TemplateColumn>
                              <asp:BoundColumn DataField="Total" HeaderText="Total" Visible="false" />
                              <asp:TemplateColumn SortExpression="Total" HeaderText="Total" ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:Literal id="lblTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Total")%>' />
                                </ItemTemplate>
                                <FooterTemplate >
                                <asp:Literal id="lblGrandTotalAmount" runat="server" />
                              </FooterTemplate>
                              </asp:TemplateColumn>
                            </Columns>
                          </asp:DataGrid>
                        </div>
                 </asp:View>
              </asp:MultiView>
              <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
            </asp:View> 
            <asp:View ID="AttachedDocuments"  runat="server">
                <div class="inputformsectionheader">Attachments</div>
                  <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" Width ="30%" />      
                  <asp:DataGrid style="width:100%" ID="dgvAttachments" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="Item_Click" Cssclass="Grid1">
                    <ItemStyle CssClass="bandbar" />
                      <Columns>
                        <asp:BoundColumn DataField="CustomerDocumentID" HeaderText="ID" Visible="false" />
                        <asp:BoundColumn DataField="Description" HeaderText="DocType" Visible="True" />
                        <asp:BoundColumn DataField="FileID" HeaderText="FileID" Visible="false" />
                        <asp:ButtonColumn Text="View" CommandName ="View" ></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Update" CommandName="Update"></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Remove" CommandName="Remove" ></asp:ButtonColumn> 
                     </Columns>              
                  </asp:DataGrid> 
              </asp:View>
            </asp:MultiView></div>        
          </td>
        </tr>
      </tbody>
    </table>
    <div>&nbsp;</div>
    <div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnAddTicket" runat="server" Text="Add Ticket" OnClick="btnAddTicket_Click" visible="False"/></div>
    <asp:Label ID="lblReturnUrl" runat="server" Visible="false" />
  </form>
</asp:Content>