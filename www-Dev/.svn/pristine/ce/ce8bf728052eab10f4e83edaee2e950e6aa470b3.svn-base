<%@ Page Language="vb" masterpagefile="~/masters/agent.master" MaintainScrollPositionOnPostback = "True" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

    Private _ID As Long = 0
    Private _CustID As Long = 0
    Private lngCustID As Long = 0
  Private lngIt as long 
    Private mListLaborTotal As Double
    Private mListExtraTotal As Double
    Private mListPartTotal As Double
    Private mListTotal As Double
    Private mFocus as Integer
    Private mCheckedTotal as Double
        
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " - Ticket Management"
            Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " - Ticket Management"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Billing Verification"

        End If
        Try
            _ID = CType(Request.QueryString("id"), Long)
        Catch ex As Exception
            _ID = 0
        End Try
        Try
            _CustID = CType(Request.QueryString("CustID"), Long)

        Catch ex As Exception
            _CustID = 0
        End Try
    
        mListLaborTotal = 0
        mListExtraTotal = 0
        mListPartTotal = 0
        mListTotal = 0
        
            If drpCustomers.SelectedValue <> "" Then
                lngCustID = CType(drpCustomers.SelectedValue, Long)
                LoadPriorInvoices(lngCustID)
            Else
            LoadCustomers()    
            drpCustomers.SelectedValue = _CustID
                LoadPriorInvoices(_CustID)
            If _ID <> 0 Then
                LoadTicketsByInvoiceID(_ID, _CustID)
            End If
            End If
        
        
        
        
    End Sub
  
  Private Sub LoadFolders()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListTicketFolderStats", dgvFolders)
    For Each itm As DataGridItem In dgvFolders.Items
      If CType(itm.Cells(0).Text, Long) = _ID Then
        itm.CssClass = "selectedbandbar"
      End If
    Next
  End Sub
  
    Private Sub LoadPriorInvoices(lngCustomerID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDataGrid("spGetCustomerPriorInvoices", "@CustomerID", lngCustomerID, dgvPriorInvoices)
    
        For Each itm As DataGridItem In dgvPriorInvoices.Items
            If CType(itm.Cells(0).Text, Long) = _ID Then
                itm.CssClass = "selectedbandbar"
            End If
        Next
       
        
    End Sub
  
  Private Sub LoadTickets(ByVal lngTicketFolderID As Long, SortField as string)
       
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    LoadCustomers()
    LoadPartners()
    Session("sortOrder")= sortfield     
        If drpCustomers.SelectedValue = "Choose One" And drpPartners.SelectedValue = "Choose One" Then
            'ldr.LoadSingleLongParameterDataGrid("spListTicketsInFolder", "@TicketFolderID", _ID, dgvTickets)
            ldr.LoadSimpleDataGrid("spBillingVerification", dgvTickets)
            lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
            btnJump.Enabled = false
        Else
            If drpCustomers.SelectedValue <> "Choose One" And drpPartners.SelectedValue = "Choose One" Then
                'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers.SelectedValue, Long), dgvTickets)
                ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByCustomer", "@CustomerID", CType(drpCustomers.SelectedValue, Long), dgvTickets)
                lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
                btnjump.Enabled = True
            End If
            If drpPartners.SelectedValue <> "Choose One" And drpCustomers.SelectedValue = "Choose One" Then
                
                'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", _ID, "@PartnerID", CType(drpPartners.SelectedValue, Long), dgvTickets)
            End If

        End If
 
  End Sub

    Private Sub LoadTicketsByCustomer(ByVal lngTicketFolderID As Long, ByVal lngCustomerID As Long)
       
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        drpCustomers.SelectedValue = lngCustomerID
        ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByCustomer", "@CustomerID", CType(drpCustomers.SelectedValue, Long), dgvTickets)
        'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers.SelectedValue, Long), dgvTickets)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
       
    End Sub
    
    Private Sub LoadTicketsByInvoiceID(ByVal lngInvoiceID As Long, ByVal lngCustomerID As Long)
       
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'LoadCustomers()
        'LoadPartners()
        drpPartners.SelectedValue = "Choose One"
        drpCustomers.SelectedValue = lngCustomerID
        ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByInvoiceID", "@InvoiceID", lngInvoiceID, dgvTickets)
        
        'ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByCustomer", "@TicketFolderID", _ID, "@CustomerID", CType(drpCustomers.SelectedValue, Long), dgvTickets)
        lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataSet).Tables(0).Rows.Count & " ) "
       
    End Sub

    Private Sub LoadTicketsByPartners(ByVal lngTicketFolderID As Long, ByVal lngPartnerID As Long)
       
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        drpPartners.SelectedValue = lngPartnerID
    
        ldr.LoadTwoLongParameterDataGrid("spListTicketsInFolderByPartner", "@TicketFolderID", _ID, "@PartnerID", CType(drpPartners.SelectedValue, Long), dgvTickets)
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
   
      Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim inv as New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim invItem As New BridgesInterface.InvoiceItemRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cad As New BridgesInterface.CustomerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cag As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim sta As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
      Dim strInvoiceNumber as String
      Dim lngInvoiceID as Integer
        Dim strChangeLog As String = ""
        Dim price As Double
        Dim lngCustomerID As Long
        
        btnJump.Enabled = False
      price = 0
      strInvoiceNumber = 0
      If CheckForErrors = True then
        strInvoiceNumber = CreateInvoiceNumber(drpCustomers.SelectedValue)
        inv.Add(drpCustomers.selectedValue,1,"Thanks for your business")
        inv.InvoiceNumber = strInvoiceNumber
            lngInvoiceID = inv.InvoiceID
            lngCustomerID = inv.CustomerID
            cst.Load(inv.CustomerID)
            If tkt.CustomerID = 30 Then ' BSA
                inv.BillCompany = "Residence/Business"
                inv.BillName = tkt.ContactFirstName & " " & tkt.ContactLastName
                inv.BillStreet = tkt.Street
                inv.BillCity = tkt.City
                sta.Load(tkt.StateID)
                inv.BillState = sta.Abbreviation
                inv.BillZipCode = tkt.ZipCode
                
                inv.ShipCompany = "Residence/Business"
                inv.ShipName = tkt.ContactFirstName & " " & tkt.ContactLastName
                inv.ShipStreet = tkt.Street
                inv.ShipCity = tkt.City
                inv.ShipState = sta.Abbreviation
                inv.ShipZipCode = tkt.ZipCode
                
            Else
                inv.BillCompany = cst.Company
                inv.ShipCompany = cst.Company
            End If
            cst.Save(strChangeLog)
            'add contacts and address for billing later on
            'add total amount
            lblTicketCount.Text = strInvoiceNumber
      
            For Each dgItem In dgvTickets.Items
                chkbox = dgItem.FindControl("chkselected")
                If chkbox.Checked Then
                    tkt.Load(CType(dgItem.Cells.Item(1).Text, Integer))
                    tkt.InvoiceID = lngInvoiceID
                    tkt.CompletedDate = Now()
                    tkt.TicketClaimApprovalStatusID = 4
                    tkt.Save(strChangeLog)
                
                    tnt.Add(CType(dgItem.Cells.Item(1).Text, Integer), Master.WebLoginID, Master.UserID, "Ticket has been invoiced: " & strInvoiceNumber)
                    tnt.CustomerVisible = False
                    tnt.Acknowledged = False
                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                    tnt.Save(strChangeLog)
                
                    price = price + CDec(dgItem.Cells.Item(11).Text)
                
                    InvoiceNumber.Text = price.ToString("C2")
                    
                End If
            Next
            invItem.Add(lngInvoiceID, 1, "Onsite Service Provided", 1, price, 0)
            inv.Notes = "Thanks for your business."
            inv.Save(strChangeLog)
            If tkt.CustomerID <> 30 Then ' bsa
                GetCustomerBillingAgent(lngCustomerID, lngInvoiceID)
                GetCustomerBillingAddress(lngCustomerID, lngInvoiceID)
            End If
            
            'production
             
            'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            'usr.Load(Master.LoginID)
            Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            wbl.Load(Master.WebLoginID)
            Dim strUserName As String
            strUserName = wbl.Login
            
            'production  3  Invoice  Created          
            Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            plog.Add(Master.WebLoginID, Now(), 3, "Invoice for Customer " & drpCustomers.SelectedItem.Text & " has been created. Invoice Number: " & strInvoiceNumber)
            
            Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
            eml.Subject = "Production from: " & strUserName
            eml.Body = "Invoice for Customer " & drpCustomers.SelectedItem.Text & " has been created. Invoice Number: " & strInvoiceNumber
            eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
            eml.SendFrom = strUserName & "@bestservicers.com"
            'eml.SendTo = ptr.Email
            eml.SendTo = "agentproduction@bestservicers.com"
            eml.Send()
        Else
            lblTicketCount.Text = " | ATTENTION! You must verify the totals for the tickets you have checked in. Unable to create invoice."
  
        End If
        
    End Sub
  
  Protected Sub dgvTickets_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If lblSortOrder.Text.ToLower = " asc" Then
      lblSortOrder.Text = " desc"
    Else
      lblSortOrder.Text = " asc"
    End If
 
        If _ID <> 0 Then
            ldr.LoadSingleLongParameterDataGrid("spBillingVerificationByInvoiceID", "@InvoiceID", _ID, dgvTickets, True, e, e.SortExpression, lblSortOrder.Text)
            lblTicketCount.Text = " ( " & CType(dgvTickets.DataSource, Data.DataView).Count & " ) "
        End If
   
  End Sub
 
  Private Sub LoadCustomers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
    ldr.LoadSimpleDropDownList("spListActiveCustomers","Company" ,"CustomerID" , drpCustomers)
        drpCustomers.Items.Add("Choose One")
        drpCustomers.SelectedValue = "Choose One"
 End Sub
 Private Sub LoadPartners()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
    ldr.LoadSimpleDropDownList("spListActivePartnersWithCalls","ResumeID","PartnerID" , drpPartners)
        drpPartners.Items.Add("Choose One")
        drpPartners.SelectedValue = "Choose One"
 End Sub

    Private Sub btnEmail_Click(ByVal S As Object, ByVal E As EventArgs)
        'drpCustomers.selectedValue = "Choose one"
        'LoadTicketsByPartners(CType(Request.QueryString("id"), Long),Ctype(drpPartners.SelectedValue,long) )
    
    End Sub
  

    Private Sub drpCustomers_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        dgvTickets.DataSource = Nothing
        dgvTickets.DataBind()
    End Sub
    
    
    Protected Sub drpPartners_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If drpPartners.SelectedValue <> "Choose One" Then
            LoadTicketsByPartners(CType(Request.QueryString("id"), Long), CType(drpPartners.SelectedValue, Long))
            drpCustomers.SelectedValue = "Choose One"
        End If
    End Sub
    
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
        Dim datClosingDate as Date 
        Dim lblClosingDate as System.Web.UI.WebControls.Literal
        
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
                lblClosingDate = Ctype(e.Item.FindControl ("lblCloseDate"), System.Web.UI.WebControls.Literal)
                lblClosingDate.text = FormatDateTime(datClosingDate,DateFormat.ShortDate).ToString
                
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
                    
                    If (price > 0) And (strStatus = "Closed - Resolved") and listLaborLabel.Text = 0 Then
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
                    mListTotal += price
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
                GrandTotalLabel.Text = mListTotal.ToString("C2")
                
            Case Else
                'ListItemType.Header, ListItemType.Pager, or ListItemType.Separator
                'no action required
                
        End Select
        
    End Sub  'dgvTickets_ItemDataBound
    
    Private Sub GetCheckBoxValues() 
    'As paging occurs store checkbox values    
    Dim dgItem As DataGridItem
    Dim chkbox As CheckBox
    'Dim chkBxIndex as Integer 
        Dim CheckedItems As ArrayList = New ArrayList
    
  'If Not isnothing (Session("CheckedItems"))then
    'Loop through DataGrid Items    
    For Each dgITem In dgvTickets.Items        
    'Retrieve key value of each record based on DataGrids        
    ' DataKeyField property        
    
      'ChkBxIndex = dgvTickets.DataKeys(1)        
      ChkBox = dgItem.FindControl("chkSelected")        
      'Add ArrayList to Session if it doesnt exist        
      If Not IsNothing(Session ("CheckedItems")) Then            
        CheckedItems = Session ("CheckedItems")        
      End If        
      If ChkBox.Checked Then            
                  
        'Add to Session if it doesnt already exist            
        If Not CheckedItems.Contains(dgitem.Cells.Item(1).text) Then                
          CheckedItems.Add(dgitem.Cells.Item(1).text)            
        End If        
      Else            
        'Remove value from Session when unchecked            
        CheckedItems.Remove(dgitem.Cells.Item(1).text)        
      End If  
     
    Next
    'Update Session with the list of checked items    
    Session ("CheckedItems") = CheckedItems 
 'end if          
    
    End Sub
     
Private Sub RePopulateCheckBoxes ()

        Dim CheckedItems As ArrayList = New ArrayList
    Dim dgItem As DataGridItem
    'Dim chkBxIndex as Integer 
    Dim chkbox As CheckBox
    
    CheckedItems = Session ("CheckedItems")

    If Not IsNothing(CheckedItems) Then

    'Loop through GridView Items                
    For Each dgItem In dgvTickets.Items  

      'ChkBxIndex = dgvTickets.DataKeys(dgitem.Cells.Item(1).text)

      'Repopulate GridView with items found in Session                
      If CheckedItems.Contains(dgitem.Cells.Item(1).text) Then

        ChkBox = CType(dgItem.FindControl("chkSelected"), CheckBox)
        ChkBox.Checked = True
        

      End If
   Next
End If
End Sub

Protected Sub chkSelected_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ck1 As CheckBox = CType(sender, CheckBox)
        Dim CheckedItems As ArrayList = New ArrayList
        Dim dgItem As DataGridItem = CType(ck1.NamingContainer, DataGridItem)
        Dim price As Decimal
        
        
       'now we've got what we need!
        If invoiceNumber.Text = "" then
          invoiceNumber.text = 0
        end if
       
       If Ck1.Checked Then            
         If Not IsNothing(Session ("CheckedItems")) Then            
         CheckedItems = Session ("CheckedItems")
         price = CDec(dgItem.Cells.Item(11).Text)
         invoicenumber.text = price.ToString 
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

Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs)
        'GetCheckBOxValues()
End Sub

Function SortOrder (Field As String) As String
  Dim so As String = Session ("SortOrder")
    If Field = so Then
      SortOrder = Replace (Field,"asc","desc")
    ElseIf Field <> so Then
      SortOrder = Replace (Field,"desc","asc")
    Else
      SortOrder = Replace (Field,"asc","desc")
    End If
   'Maintain persistent sort order 
   Session ("SortOrder") = SortOrder
End Function

Function CreateInvoiceNumber (lngCustomerID as Integer )   as String
  Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim cmd As New System.Data.SqlClient.SqlCommand("spCreateCustomerInvoiceNumber")
  Dim strInvoiceNumber as String

  cmd.CommandType = Data.CommandType.StoredProcedure
  cmd.Parameters.Add("@CustomerNumber", Data.SqlDbType.Int).Value = lngCustomerID
  cnn.open        
  cmd.Connection = cnn
  strInvoiceNumber =  cmd.ExecuteScalar()
  cnn.Close()
   CreateInvoiceNumber = strInvoiceNumber     
End function

Function CheckForErrors() as boolean

Dim dgItem As DataGridItem
Dim chkbox As CheckBox
Dim boolError as Boolean 

boolError = True
 
 For Each dgItem in dgvTickets.Items
     chkbox = dgItem.FindControl("chkselected")
        If chkbox.Checked Then
           If (dgItem.Cells.Item(11).Text) = ""  or (dgItem.Cells.Item(11).Text) = "&nbsp;" then
             boolError = false
             exit for
           end if
        End If
 Next
 CheckForErrors = boolError
 
    End Function
    
    Private Sub GetCustomerBillingAgent(ByVal lngCustomerID As Long, ByVal lngInvoiceID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetCustomerBillingAgent")
        Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim sta As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        Dim strFullName As String
        Dim strChangeLog As String
        strChangeLog = ""
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CustomerID", Data.SqlDbType.Int).Value = lngCustomerID
        cmd.Parameters.Add("@TypeID", Data.SqlDbType.Int).Value = 12 ' 12 Billing/Invoices Type
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strFullName = dtr("FirstName") & " " & dtr("LastName")
            inv.Load(lngInvoiceID)
            inv.BillName = strFullName
            inv.ShipName = strFullName
            inv.Save(strChangeLog)
        End While
        cnn.Close()
        
    End Sub
    
    Private Sub GetCustomerBillingAddress(ByVal lngCustomerID As Long, ByVal lngInvoiceID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetCustomerBillingAddress")
        Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim sta As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        Dim strChangeLog As String
        strChangeLog = ""
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CustomerID", Data.SqlDbType.Int).Value = lngCustomerID
        cmd.Parameters.Add("@AddressTypeID", Data.SqlDbType.Int).Value = 2 ' 2 Billing Address Type
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            sta.Load(dtr("StateID"))
            inv.Load(lngInvoiceID)
            inv.BillStreet = dtr("Street")
            If not isDBnull(dtr("Extended")) then
              inv.BillExtended = dtr("Extended")
            End if
            inv.BillCity = dtr("City")
            inv.BillState = sta.Abbreviation
            inv.BillZipCode = dtr("ZipCode")
            inv.ShipStreet = dtr("Street")
            If not isDBNull(dtr("Extended")) then
              inv.ShipExtended = dtr("Extended")
            End if
            inv.ShipCity = dtr("City")
            inv.ShipState = sta.Abbreviation
            inv.ShipZipCode = dtr("ZipCode")
            inv.Save(strChangeLog)
            sta.Save(strChangeLog)
        End While
        cnn.Close()
        
    End Sub

</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server" >
    <table style="width: 100%">
      <tbody>
        <tr>
          <td class="band" style="width: 1%">
            <div class="bandheader"></div>
            <asp:DropDownList ID="drpPartners" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpPartners_SelectedIndexChanged" visible="False"/>
            
            <div class="bandheader">Customer</div>
            <span style="white-space:nowrap">
            <asp:DropDownList ID="drpCustomers" runat="server" AutoPostBack="true" OnSelectedIndexChanged="drpCustomers_SelectedIndexChanged" />
            </span>
            
            <div class="bandheader" ></div>
            <asp:DataGrid ID="dgvFolders" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" CssClass ="Grid1">
              <ItemStyle CssClass="bandbar" />
              <Columns>
                <asp:BoundColumn DataField="TicketFolderID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" >
                  <ItemTemplate>
                    <a href="tickets.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketFolderID") %>&CustID=<%# drpCustomers.selectedValue %>"><%# DataBinder.Eval(Container.DataItem,"FolderName") %></a>&nbsp;(<%# DataBinder.Eval(Container.DataItem,"TicketCount") %>)
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>              
            </asp:DataGrid>
            <div>&nbsp;</div>
           
            
            <div class="inputformsectionheader"></div>
            <div class="inputform">
              <div class="errorzone" id="divJumpToError" runat="server" visible="false" />
              <div class="label"></div>
              <div><asp:TextBox ID="InvoiceNumber" runat="server" visible="false"/></div>
              <div style="text-align: right;"><asp:Button ID="btnJump" runat="server" Text="Create Invoice" OnClick="btnJump_Click" Visible="false" /></div>
            </div>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Prior Invoices</div>
            <asp:DataGrid ID="dgvPriorInvoices" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
              <ItemStyle CssClass="bandbar" />
              <Columns>
                <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" >
                  <ItemTemplate>
                    <a href="billingverification.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>&CustID=<%# drpCustomers.selectedValue %>"><%# DataBinder.Eval(Container.DataItem,"InvoiceNumber") %></a>&nbsp;<a target="_blank" href="OldInvoicesReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Group Invoices" src="/graphics/printable.png" />&nbsp;</a><a target="_blank" href="OldSingleInvoicesReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Single Invoices" src="/graphics/printable.png" /></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="Total" HeaderText="Total"  DataFormatString="{0:C}"/>
              </Columns>              
            </asp:DataGrid>
            <div>&nbsp;</div>
          </td>
          <td style="width: 3px;">&nbsp;</td>
          <td>
            <div class="inputformsectionheader">
                Tickets - Billing Verification <asp:Label ID="lblTicketCount" runat="server"></asp:Label>
            </div>
            <div class="inputform">
              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" OnSortCommand="dgvTickets_SortCommand" ShowFooter = "True" Cssclass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:TemplateColumn Visible="false">
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected" runat="server"  AutoPostBack ="True" OnCheckedChanged="chkSelected_CheckedChanged" Visible="false" />
                  </ItemTemplate>
                </asp:TemplateColumn>
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
          </td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>