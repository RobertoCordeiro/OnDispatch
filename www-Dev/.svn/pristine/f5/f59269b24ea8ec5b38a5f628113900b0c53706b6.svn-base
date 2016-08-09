<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>

<%@ Register Assembly="RadCalendar.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ID As Long = 0
    Private mListTotal As Double
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Customer"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Customer Control"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customer Management</a> &gt; Customer"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    If _ID > 0 Then
            If Not IsPostBack Then
                Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                inf.Load(Master.InfoID)
                Dim com As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                com.Load(_ID)
                If inf.InfoID <> com.InfoID Then
                    Response.Redirect("/logout.aspx")
                Else
                    LoadCustomer(_ID)
                End If
               
            End If
    End If
    if (page.IsPostBack =False) then
        menu.Items(0).Selected= true
      end if
  End Sub

  Private Sub LoadCustomer(ByVal lngCustomerID As Long)
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cst.Load(lngCustomerID)
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
    LoadCustomerAgents()
    LoadAddresses()
    LoadPhoneNumbers()
        LoadServiceTypes()
        RadDatePickerFrom.SelectedDate = DateTime.Now.Date
        RadDatePickerTo.SelectedDate = DateTime.Now.Date
  End Sub

  Private Sub btnAddAgent_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
    strQueryString = strQueryString.Replace("?", "%3f")
    strQueryString = strQueryString.Replace("&", "%26")
    Response.Redirect("addcustomeragent.aspx?id=" & _ID & "&returnurl=customer.aspx%3f" & strQueryString, True)
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
    Response.Redirect("addaddress.aspx?id=" & _ID.ToString & "&mode=customer&returnurl=customer.aspx%3f" & strQueryString, True)    
  End Sub
  
  Private Sub btnAddPhoneNumber_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strQueryString As String = Request.ServerVariables("QUERY_STRING")
    strQueryString = strQueryString.Replace("?", "%3f")
    strQueryString = strQueryString.Replace("&", "%26")
    Response.Redirect("addphone.aspx?id=" & _ID.ToString & "&mode=customer&returnurl=customer.aspx%3f" & strQueryString, True)
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
  
  Private Sub LoadCustomerAgents()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListCustomerAgents")
    cmd.Parameters.Add("@CustomerID", Data.SqlDbType.Int).Value = _ID
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvAgents.DataSource = ds
    dgvAgents.DataBind()
    cnn.Close()
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
                LoadCustomerAgents()
            Case Is = 2 'phone numbers
                LoadPhoneNumbers()
            Case Is = 3 'addresses
                LoadAddresses()
            Case Is = 4 'prior invoices
                LoadPriorInvoices()
            case Is = 5 ' parts/credits
                loadPriorPartInvoices(_ID,dgvPriorPartInvoices)
            Case Is = 6  'Outstanding balance
                LoadOutstandingBalance (_ID,dgvOutstandingBalance)
                GetStatuses()
            Case Is = 7 ' Attached documents
                LoadAttachedDocuments (_ID)
        End Select
        
    End Sub
    Private Sub LoadPriorInvoices()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim dgv1 As System.Web.UI.WebControls.DataGrid
      ldr.LoadSingleLongParameterDataGrid("spGetCustomerPriorInvoices", "@CustomerID", _ID, dgvPriorInvoices)
    
      For Each itm As DataGridItem In dgvPriorInvoices.Items
        If CType(itm.Cells(0).Text, Long) = _ID Then
          itm.CssClass = "selectedbandbar"
        End If
        dgv1 = itm.FindControl ("dgvPayments")
      LoadPayments (CType(itm.Cells(0).Text, Long),dgv1)
      Next
    
  End Sub
  Private Sub LoadPayments(lngInvoiceID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spGetInvoiceLaborPaymentsByInvoiceID", "@InvoiceID", lngInvoiceID, dgv)
      End If
  End Sub
  
  Private Sub LoadPriorPartInvoices(lngCustomerID as long, dgv as System.Web.UI.WebControls.DataGrid)
   Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spPartsNotCreditedByCustomer", "@CustomerID", lngCustomerID, dgvPriorPartInvoices)
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
  
  Private Sub btnExport_Click(sender As Object, e As System.Web.UI.ImageClickEventArgs)
      Dim ex As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     
      If dgvOutstandingBalance.Items.Count > 0 then
          ex.ExportGrid("OutstandingBalance.xls",dgvOutstandingBalance)
      end if   
    End Sub
    
    Private Sub btnExportParts_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Dim ex As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     
        If dgvPriorPartInvoices.Items.Count > 0 Then
            ex.ExportGrid("PartsNotCredit.xls", dgvPriorPartInvoices)
        End If
    End Sub
    Private Sub btnView_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If Not IsNothing(dgvOutstandingBalance) Then
            If drpStatus.SelectedValue = "Filter By Status" Then
                ldr.LoadLongTwoDateParameterDataGrid("spOutstandingBalanceByCustomerByDate", "@CustomerID", _ID, "@FromDate", (RadDatePickerFrom.SelectedDate), "@ToDate", (RadDatePickerTo.SelectedDate), dgvOutstandingBalance)
                lblTicketCount.Text = "Total Tickets: ( " & dgvOutstandingBalance.Items.Count.ToString & " ) "
            Else
                ldr.LoadTwoLongTwoDateParameterDataGrid("spOutstandingBalanceByCustomerDateStatus", "@CustomerID", _ID, "@StatusID", CType(drpStatus.SelectedValue, Long), "@FromDate", (RadDatePickerFrom.SelectedDate), "@ToDate", (RadDatePickerTo.SelectedDate), dgvOutstandingBalance)
                lblTicketCount.Text = "Total Tickets: ( " & dgvOutstandingBalance.Items.Count.ToString & " ) "
            End If
            
        End If
    End Sub
    
    Private Sub GetStatuses()
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListTicketClaimApprovalStatuses", "StatusDescription", "TicketClaimApprovalStatusID", drpStatus)
        drpStatus.Items.Add("Filter By Status")
        drpStatus.SelectedValue = "Filter By Status"
    End Sub
    
    Private Sub dgvOutstandingBalance_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgvOutstandingBalance.ItemDataBound
        Dim rowData As Data.DataRowView
        Dim decLaborCharge As Decimal
        Dim decOutstanding As Decimal
        Dim strStatus As String
        Dim price As Decimal
        Dim listTotalLabel As System.Web.UI.WebControls.Literal
        Dim GrandTotalLabel As System.Web.UI.WebControls.Literal
        Select Case (e.Item.ItemType)
            Case ListItemType.AlternatingItem, ListItemType.EditItem, ListItemType.Item, ListItemType.SelectedItem
                rowData = CType(e.Item.DataItem, Data.DataRowView)
                decLaborCharge = (rowData.Item("AmountCharged"))
                decOutstanding = (rowData.Item("Outstanding"))
                If Not IsDBNull((rowData.Item("StatusDescription"))) Then
                    strStatus = (rowData.Item("StatusDescription"))
                Else
                    strStatus = ""
                End If
                If decLaborCharge <> decOutstanding Then
                    If strStatus <> "Processing" And strStatus <> "" Then
                        e.Item.ForeColor = Drawing.Color.Red
                    Else
                        e.Item.ForeColor = Drawing.Color.Blue
                    End If
                Else
                    If strStatus = "" Then
                        e.Item.ForeColor = Drawing.Color.Blue
                    End If
                End If
                'get the value for the Total and add it to the sum
                If Not IsDBNull(rowData.Item("Outstanding")) Then
                    price = CDec(rowData.Item("Outstanding"))
                    mListTotal += price
                End If
                'get the control used to display the PartAmount price
                listTotalLabel = CType(e.Item.FindControl("lblTotal"), System.Web.UI.WebControls.Literal)
          
                'now format the discounted price in currency format
                listTotalLabel.Text = price.ToString("C2")
            Case ListItemType.Footer

                'get the control used to display the total of the list prices
                'and set its value to the total of the list prices
                
                GrandTotalLabel = CType(e.Item.FindControl("lblGrandTotalAmount"), System.Web.UI.WebControls.Literal)
                GrandTotalLabel.Text = mListTotal.ToString("C2")
                
                
        End Select
    End Sub
    
    Private Sub LoadAttachedDocuments(ByVal lngCustomerID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDataGrid("spGetCustomerDocuments", "@CustomerID", lngCustomerID, dgvAttachments)
    End Sub

    Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect("CustomerDocumentsUpload.aspx?fid=0" & "&id=" & _ID & "&returnurl=customer.aspx?id=" & _ID & "&mode=doc&updt=0")
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
                Response.Redirect("CustomerDocumentsUpload.aspx?fid=" & CType(e.Item.Cells(0).Text, Long) & "&id=" & _ID & "&returnurl=Customer.aspx?id=" & _ID & "&mode=doce&updt=" & lngFileID)

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
                Response.Redirect("customer.aspx?id=" & _ID & "&returnurl=customer.aspx?id=" & _ID)
        End Select
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
            <div ></div>
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
                <asp:MenuItem value = "2" Text="Phone Numbers"></asp:MenuItem>
                <asp:MenuItem value = "3" Text="Addresses"></asp:MenuItem>
                <asp:MenuItem value = "4" Text="Prior Invoices"></asp:MenuItem>
                <asp:MenuItem value = "5" Text="Parts Charges/Credits"></asp:MenuItem>
                <asp:MenuItem value = "6" Text="Outstanding Balance"></asp:MenuItem>
                <asp:MenuItem value = "7" Text="Attached Documents"></asp:MenuItem>
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
                    <a href="editservicetype.aspx?id=<%# DataBinder.Eval(Container.DataItem,"ServiceTypeID") %>&returnurl=customer.aspx%3fid=<%# _ID %>">Open</a>
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
            <asp:DataGrid style="background-color: white; width: 100%" ID="dgvAgents" AutoGenerateColumns="false" runat="server" CssClass="Grid1">
              <HeaderStyle cssclass="gridheader" />
              <AlternatingItemStyle cssclass="altrow" />  
              <Columns>
                <asp:BoundColumn
                  HeaderText="ID"
                  DataField="CustomerAgentID"
                  Visible="false"
                />
                <asp:TemplateColumn
                  HeaderText="Command"
                  >
                  <ItemTemplate>
                    <a href="editcustomeragent.aspx?id=<%# DataBinder.Eval(Container.DataItem,"CustomerAgentID") %>&returnurl=customer.aspx%3fid=<%# _ID %>">Open</a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn
                  HeaderText="Type"
                  DataField="AgentType"
                  />
                <asp:TemplateColumn
                  HeaderText="Name"
                  >
                  <Itemtemplate>
                    <a href="<%# buildemailhref(DataBinder.Eval(Container.DataItem,"Email")) %>"><%# DataBinder.Eval(Container.DataItem,"FirstName") %>&nbsp;<%# DataBinder.Eval(Container.DataItem,"MiddleName") %>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%></a>                    
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
                  DataField="DateCreated"
                  HeaderText="Date&nbsp;Created"
                  />                
              </Columns>
            </asp:DataGrid> 
            </asp:View> 
            <asp:View ID="viewPhoneNumbers"  runat="server">
            <div style="text-align :right "><asp:Button ID="btnAddPhoneNumber" runat="server" OnClick="btnAddPhoneNumber_Click" text="Add Phone Number" /></div>
            <asp:DataGrid style="background-color: white; width:100%" ID="dgvPhoneNumbers" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
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
                    <a href="editphone.aspx?returnurl=customer.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"CustomerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"CustomerPhoneNumberID") %>&mode=customer">Edit</a>
                  </Itemtemplate>
                </asp:TemplateColumn>                            
              </Columns>                
            </asp:DataGrid> 
            </asp:View>  
            <asp:View ID="viewAddresses"  runat="server"> 
            <div style="text-align :right "><asp:Button ID="btnAddAddress" runat="server" OnClick="btnAddAddress_Click" Text="Add Address" /></div> 
            <asp:DataGrid style="background-color: white; width: 100%" AutoGenerateColumns="false" ID="dgvAddresses" runat="server" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
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
                <asp:TemplateColumn
                  HeaderText="Command"
                  >
                  <Itemtemplate>
                    <a href="editaddress.aspx?id=<%# DataBinder.Eval(Container.DataItem,"CustomerAddressID") %>&mode=customer&returnurl=customer.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"CustomerID") %>">Edit</a>
                  </Itemtemplate>
                </asp:TemplateColumn>                                                    
              </Columns>        
            </asp:DataGrid>
            </asp:View>
            <asp:View ID="viewOldInvoices"  runat="server"> 
            <asp:DataGrid ID="dgvPriorInvoices" runat="server" style="background-color: white; width: 100%"  ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1" >
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText="Invoice Number" >
                  <ItemTemplate>
                    <a href="billingverification.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>&CustID=<%# _ID %>"><%# DataBinder.Eval(Container.DataItem,"InvoiceNumber") %></a>&nbsp;<a target="_blank" href="OldInvoicesReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Group Invoices" src="/graphics/printable.png" />&nbsp;</a><a target="_blank" href="OldSingleInvoicesReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Single Invoices" src="/graphics/printable.png" /></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="Total" HeaderText="Total Labor"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="TotalPaid" HeaderText="Total Labor Paid"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}"/>
                <asp:TemplateColumn HeaderText ="Payment Records">
                  <ItemTemplate>
                     <asp:DataGrid Visible="True" ID="dgvPayments" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
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
            <asp:View ID="viewParts"  runat="server"> <div>&nbsp;</div>
             <div ><asp:ImageButton ID="btnExportParts" AlternateText ="Export to Excel" ImageUrl ="/images/Excel-16.gif"  ImageAlign="right"  OnClick="btnExportParts_Click" runat="server"/></div> 
            <div>&nbsp;</div>
            <asp:DataGrid ID="dgvPriorPartInvoices" runat="server" style="background-color: white; width: 100%"  ShowFooter="false" AutoGenerateColumns="false" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
              <asp:BoundColumn DataField="InvoiceID" HeaderText="InvoiceID" Visible= "false" />
                 <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                      <a target ="blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText="Invoice Number" >
                  <ItemTemplate>
                    <a  target ="blank" href="billingverification.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>&CustID=<%# _ID %>"><%# DataBinder.Eval(Container.DataItem,"InvoiceNumber") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                 <asp:BoundColumn DataField="Age" HeaderText="Age" />
                 <asp:BoundColumn DataField="MonthNames" HeaderText="Month" />
                <asp:BoundColumn DataField="UnitSerial" HeaderText="UnitSerial" />
                <asp:BoundColumn DataField="ChargedAmount" HeaderText="ChargedAmount"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="AmountPaid" HeaderText="AmountCredited"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}"/>
              </Columns>              
            </asp:DataGrid>
            <div>&nbsp;</div> 
            </asp:View>
             <asp:View ID="viewOutstandingBalance"  runat="server">
            <table>
              <tr>
                <td>
                <div>
                   <asp:DropDownList ID="drpStatus" runat="server" ></asp:DropDownList>
                </div>
              </td>
                <td>
                   <div><rad:RadDatePicker ID="RadDatePickerFrom" runat="server" Width="30%" DateInput-Font-Size="Medium" Culture="English (United States)" SelectedDate="2012-05-15" Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" Calendar-MonthLayout="Layout_7columns_x_6rows">
                       <DateInput Font-Size="Medium" Skin="">
                       </DateInput>
                   </rad:RadDatePicker></div>
                </td>
                <td>
                   <div><rad:RadDatePicker ID="RadDatePickerTo" runat="server" Width="30%" DateInput-Font-Size="Medium" Culture="English (United States)" SelectedDate="2012-05-15" Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" >
                       <DateInput Font-Size="Medium" Skin="">
                       </DateInput>
                   </rad:RadDatePicker></div>
                </td>
                <td>
                   <div><asp:Button ID="btnView" runat="server"  Text="View" OnClick="btnView_Click"/></div>
                </td>
                <td>
                   <div><asp:ImageButton ID="btnExport" AlternateText ="Export to Excel" ImageUrl ="/images/Excel-16.gif"  ImageAlign="right"  OnClick="btnExport_Click" runat="server"/></div> 
                </td>
              </tr>
             </table> 
             <div style="text-align:left"><asp:Label ID="lblTicketCount" runat="server"></asp:Label></div>  
            <asp:DataGrid ID="dgvOutstandingBalance" runat="server" style="background-color: white; width: 100%"  ShowFooter="True" AutoGenerateColumns="false" CssClass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
              <asp:BoundColumn DataField="InvoiceID" HeaderText="InvoiceID" Visible= "false" />
                 <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                      <a target ="blank" href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText="Invoice Number" >
                  <ItemTemplate>
                    <a  target ="blank" href="billingverification.aspx?id=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>&CustID=<%# _ID %>"><%# DataBinder.Eval(Container.DataItem,"InvoiceNumber") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="Age" HeaderText="Age" />
                <asp:BoundColumn DataField="StatusDescription" HeaderText="Status" />
                 <asp:BoundColumn DataField="DateApproved" HeaderText="Approval Date" />
                 <asp:BoundColumn DataField="MonthNames" HeaderText="Month" />
                <asp:BoundColumn DataField="ReferenceNumber2" HeaderText="CustomerPO" />
                <asp:BoundColumn DataField="SerialNumber" HeaderText="SerialNumber" />
                <asp:BoundColumn DataField="Status" HeaderText="Status" />
                <asp:BoundColumn DataField="AmountCharged" HeaderText="LaborCharged"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="PartsCharged" HeaderText="PartsCharged"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="TotalCharged" HeaderText="TotalCharged"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="AmountPaid" HeaderText="AmountPaid"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}" Visible="false"/>
                 <asp:TemplateColumn SortExpression="Outstanding" HeaderText="Outstanding" ItemStyle-HorizontalAlign="Right">
                    <ItemTemplate>
                        <asp:Literal id="lblTotal" runat="server" text='<%#DataBinder.Eval(Container.DataItem, "Outstanding")%>' />
                    </ItemTemplate>
                    <FooterTemplate >
                    <asp:Literal id="lblGrandTotalAmount" runat="server" />
                  </FooterTemplate>

                  </asp:TemplateColumn>
              </Columns>              
            </asp:DataGrid>
            <div>&nbsp;</div> 
            </asp:View>
             <asp:View ID="AttachedDocuments"  runat="server">
            <div class="inputformsectionheader">Attachments</div>
                  <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" Width ="30%" />      
                  <asp:DataGrid style="width:100%" ID="dgvAttachments" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="Item_Click" CssClass="Grid1">
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