<%@ Page Language="VB" masterpagefile="~/masters/customer.master"%>
<%@ Register Assembly="RadCalendar.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<%@ MasterType VirtualPath="~/masters/customer.master" %>
<script language="VB" runat="server">
  Private _ID As Long = 0
  Private _mode As String = ""
    Private _PaymentAmount As Double = 0
    Private _InvoiceID As Long = 0
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            lgn.Load(CType(User.Identity.Name, Long))
            Master.ActiveMenu = "F"
            
      If lgn.WebLoginID > 0 Then
        If lgn.AccessCoding.Contains("C") Then
          Master.WebLoginID = lgn.WebLoginID
          Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Invoices"
          Master.PageHeaderText = "Invoice Processing" 
          _ID = Master.customerID
           Try
            _Mode = CType(Request.QueryString("mode"), String)
            
           Catch ex As Exception
            _Mode = 0
                    End Try
                    
                    Try
                        _InvoiceID = CType(Request.QueryString("ivid"), String)
            
                    Catch ex As Exception
                        _InvoiceID = 0
                    End Try
                    
                    If Not IsPostBack Then
                        LoadInvoices()
                        RadDatePickerFrom.SelectedDate = DateTime.Now.Date
                        lblPaymentAmount.Text = FormatCurrency(0, 2)
                    Else
                        Dim chkbox As CheckBox
                        Dim dgItem As DataGridItem
                        Dim dblAmount As Double
                        dblAmount = 0
                        lblPaymentAmount.Text = FormatCurrency(0, 2)
                        For Each dgItem In dgvPay.Items
                            chkbox = dgItem.FindControl("chkselected")
                            If chkbox.Checked Then
                                dblAmount = dblAmount + FormatCurrency(dgItem.Cells.Item(14).Text, 2)
                                
                            End If
                        Next
                        lblPaymentAmount.Text = FormatCurrency(dblAmount.ToString, 2)
                        _PaymentAmount = FormatCurrency(dblAmount.ToString, 2)
                        btnAssign.Attributes.Add("onclick", "return confirm('You are about to create a Payment Transaction, do you want to continue?');")

                    End If
                    
        Else
          Response.Redirect("/login.aspx", True)
        End If
      Else
        Response.Redirect(User.Identity.Name, True)
      End If
      Else
      Response.Redirect("/login.aspx", True)
    End If
  End Sub
  
  Private Sub LoadInvoices()
  
  Select Case _mode

  Case = "open"
  lblMessage.Text = "Processing Opened Invoices..."
  Multiview1.ActiveViewIndex = 0
  Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     ldr.LoadTwoLongParameterDataGrid("spOutstandingInvoicesByCustomerStatus", "@CustomerID", _ID, "StatusID",4 ,dgvOpen)
                lblTicketCount.Text = "Total Tickets: ( " & dgvOpen.Items.Count.ToString & " ) "
                
                
  Case = "pay"
  lblMessage.Text = "Paying Approved Invoices..."
   Multiview1.ActiveViewIndex = 1
  Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     ldr.LoadTwoLongParameterDataGrid("spOutstandingInvoicesByCustomerStatus", "@CustomerID", _ID, "StatusID",2 ,dgvPay)
                lblTicketCount.Text = "Total Tickets: ( " & dgvPay.Items.Count.ToString & " ) "
  
  Case = "hold"
  lblMessage.Text = "Reviewing Invoices On Hold..."
   Multiview1.ActiveViewIndex = 0
    Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                ldr.LoadTwoLongParameterDataGrid("spOutstandingInvoicesByCustomerStatus", "@CustomerID", _ID, "StatusID", 3, dgvOpen)
                lblTicketCount.Text = "Total Tickets: ( " & dgvOpen.Items.Count.ToString & " ) "
  Case = "paid"
  lblMessage.Text = "Payment Transactions List..."
    Multiview1.ActiveViewIndex = 2
    LoadPriorInvoices
    
  Case = "rejected"
  lblMessage.Text = "Rejected Invoices List..."
   Multiview1.ActiveViewIndex = 0
    Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                ldr.LoadTwoLongParameterDataGrid("spOutstandingInvoicesByCustomerStatus", "@CustomerID", _ID, "StatusID", 7, dgvOpen)
                lblTicketCount.Text = "Total Tickets: ( " & dgvOpen.Items.Count.ToString & " ) "
  Case = "pt"
                lblMessage.Text = "Paid Invoices..."
   Multiview1.ActiveViewIndex = 3
    Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                ldr.LoadSingleLongParameterDataGrid("spWebPaidInvoicesByInvoiceID", "@InvoiceID", _InvoiceID, dgvPaidTransactions)
                lblTicketCount.Text = "Total Tickets: ( " & dgvPaidTransactions.Items.Count.ToString & " ) "
  Case else
   
  end select
  
  end sub
  
    Protected Sub chkAll_OnCheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim chkbox As CheckBox
        Dim dgItem As DataGridItem
        Dim dblAmount As Double
        dblAmount = 0
        lblPaymentAmount.Text = FormatCurrency(0, 2)
        For Each dgItem In dgvPay.Items
            chkbox = dgItem.FindControl("chkselected")
            If Not chkbox.Checked Then
                chkbox.Checked = True
                dblAmount = dblAmount + FormatCurrency(dgItem.Cells.Item(14).Text, 2)
            Else
                chkbox.Checked = False
            End If
        Next
        lblPaymentAmount.Text = FormatCurrency(dblAmount.ToString, 2)
        _PaymentAmount = FormatCurrency(dblAmount.ToString, 2)
    End Sub
    Function CreateInvoiceNumber(ByVal lngCustomerID As Integer) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCreateCustomerInvoiceNumber")
        Dim strInvoiceNumber As String

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CustomerNumber", Data.SqlDbType.Int).Value = lngCustomerID
        cnn.open()
        cmd.Connection = cnn
        strInvoiceNumber = cmd.ExecuteScalar()
        cnn.Close()
        CreateInvoiceNumber = strInvoiceNumber
    End Function
    Private Sub btnAssign_Click(ByVal S As Object, ByVal E As EventArgs)
   
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim invItem As New BridgesInterface.InvoiceItemRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cad As New BridgesInterface.CustomerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cag As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim strInvoiceNumber As String
        Dim lngInvoiceID As Integer
        Dim strChangeLog As String = ""
        Dim price As Double
        Dim lngCustomerID As Long
        
        btnAssign.Enabled = False
        price = 0
        strInvoiceNumber = 0
        If CheckForErrors = True Then
            strInvoiceNumber = "W" & CreateInvoiceNumber(_ID)
            inv.Add(_ID, 1, "Approved payments via web.")
            inv.InvoiceNumber = strInvoiceNumber
            inv.CustWebInvoice = True
            lngInvoiceID = inv.InvoiceID
            lngCustomerID = inv.CustomerID
            cst.Load(inv.CustomerID)
            inv.BillCompany = cst.Company
            inv.ShipCompany = cst.Company
            cst.Save(strChangeLog)
            'add contacts and address for billing later on
            'add total amount
            lblWebInvoiceNumber.text = strInvoiceNumber
      
            For Each dgItem In dgvPay.Items
                chkbox = dgItem.FindControl("chkselected")
                If chkbox.Checked Then
                    tkt.Load(CType(dgItem.Cells.Item(2).Text, Integer))
                    tkt.WebInvoiceID = lngInvoiceID
                
                    tkt.Save(strChangeLog)
                
                    tnt.Add( CType(dgItem.Cells.Item(2).Text, Integer) , Master.WebLoginID, Master.UserID, "Customer has approved payment via Web - Transaction ID: " & strInvoiceNumber)
                    tnt.CustomerVisible = True
                    tnt.Acknowledged = False
                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                    tnt.Save(strChangeLog)
                    
                    
                    price = _PaymentAmount
                     
                End If
            Next
            invItem.Add(lngInvoiceID, 1, "Customer Approved Payment via Web", 1,  price, 0)
            inv.Notes = "Payment Approved."
            inv.Save(strChangeLog)
            'GetCustomerBillingAgent(lngCustomerID, lngInvoiceID)
            'GetCustomerBillingAddress(lngCustomerID, lngInvoiceID)
            
            'production
           
            'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            'usr.Load(Master.LoginID)
            Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            wbl.Load(Master.WebLoginID)
            Dim strUserName As String
            strUserName = wbl.Login
                        
            Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
            eml.Subject = "Production from: " & strUserName
            eml.Body = "Customer has approved payment via web. Transaction ID: " & strInvoiceNumber
            eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
            eml.SendFrom = strUserName & "@bestservicers.com"
            'eml.SendTo = ptr.Email
            eml.SendTo = "agentproduction@bestservicers.com"
            eml.Send()
        Else
            lblTicketCount.Text = " | ATTENTION! You must verify the totals for the tickets you have checked in. Unable to create invoice."
  
        End If
        
    End Sub
    Function CheckForErrors() As Boolean

        Dim dgItem As DataGridItem
        Dim chkbox As CheckBox
        Dim boolError As Boolean

        boolError = True
 
        For Each dgItem In dgvPay.Items
            chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                If (dgItem.Cells.Item(13).Text) = "" Or (dgItem.Cells.Item(13).Text) = "&nbsp;" Then
                    boolError = False
                    Exit For
                End If
            End If
        Next
        CheckForErrors = boolError
 
    End Function
    
    Private Sub LoadPriorInvoices()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
      ldr.LoadSingleLongParameterDataGrid("spGetCustomerWebPriorInvoices", "@CustomerID", _ID, dgvPriorInvoices)
    
      For Each itm As DataGridItem In dgvPriorInvoices.Items
        If CType(itm.Cells(0).Text, Long) = _ID Then
          itm.CssClass = "selectedbandbar"
        End If
      Next
   
  End Sub
    Private Sub btnSet_Click(ByVal S As Object, ByVal E As EventArgs)
        
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadTwoLongTwoDateParameterDataGrid("spOutstandingInvoicesByCustomerStatusDate", "@CustomerID", _ID, "StatusID", 2, "@Date1", (RadDatePickerFrom.SelectedDate), "Date2", (RadDatePickerFrom.SelectedDate), dgvPay)
        lblTicketCount.Text = "Total Tickets: ( " & dgvPay.Items.Count.ToString & " ) "
    
    End Sub
  

</script>
<asp:Content ContentPlaceHolderID="Headermenucontent" runat="server">

  <a href="invoices.aspx?mode=open" class="selectedheaderlink" id="lnkOpen" runat="server">Open</a> |
  <a href="invoices.aspx?mode=pay" class="unselectedheaderlink" id="lnkPaid" runat="server">Pay</a> |
  <a href="invoices.aspx?mode=hold" class="unselectedheaderlink" id="lnkHold" runat="server">Hold</a> |
  <a href="invoices.aspx?mode=rejected" class="unselectedheaderlink" id="lnkRejected" runat="server">Rejected</a> |
  <a href="invoices.aspx?mode=paid" class="unselectedheaderlink" id="lnkFind" runat="server">Paid</a> 
  
</asp:Content>
<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <div style="text-align: center"><asp:Label ID="lblMessage" runat="server"></asp:Label></div>
  <form id="Form1" runat="server">
  
        <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
           <asp:View ID="vwOpen"  runat="server">
             <div style="text-align:left"><asp:Label ID="lblTicketCount" runat="server"></asp:Label></div>  
            <asp:DataGrid ID="dgvOpen" runat="server" style="background-color: white; width: 100%"  ShowFooter="false" AutoGenerateColumns="false" >
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
              <asp:BoundColumn DataField="InvoiceID" HeaderText="InvoiceID" Visible= "false" />
                 <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                      <a target ="blank" href="Invoicedticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a>&nbsp;&nbsp;&nbsp;<a target="_blank" href="OldSingleInvoiceReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><img style="border: 0" alt="Single Invoices" src="/graphics/printable.png" /></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                <asp:BoundColumn DataField="Age" HeaderText="Age" />
                <asp:BoundColumn DataField="StatusDescription" HeaderText="Claim Status" />
                 <asp:BoundColumn DataField="MonthNames" HeaderText="Month" />
                <asp:BoundColumn DataField="ReferenceNumber2" HeaderText="CustomerPO" />
                <asp:BoundColumn DataField="SerialNumber" HeaderText="SerialNumber" />
                <asp:BoundColumn DataField="Status" HeaderText="Service Status" />
                <asp:BoundColumn DataField="AmountCharged" HeaderText="LaborCharged"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="PartsCharged" HeaderText="PartsCharged"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="TotalCharged" HeaderText="TotalCharged"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="AmountPaid" HeaderText="AmountPaid"  DataFormatString="{0:C}"/>
                <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}"/>
              </Columns>              
            </asp:DataGrid>
            <div>&nbsp;</div> 
            </asp:View>
             <asp:View ID="vwPay"  runat="server">
             <div style="text-align:left"><asp:Label ID="Label1" runat="server"></asp:Label></div>  
             <div>
              <table style="width: 100%">
                <tbody>
                  <tr>
                    <td class="band" rowspan="2" style="width:1%"; height ="100%">
                      <div >
                        <table style="width: 100%">
                          <tbody>
                            <tr>
                              <td style="width: 1%" class="inputformsectionheader">Choose Cutoff Day:</td>
                            </tr>
                            <tr>
                              <td>
                                 <div><rad:RadDatePicker ID="RadDatePickerFrom" runat="server" Width="30%" DateInput-Font-Size="Medium" Culture="English (United States)" SelectedDate="2012-05-15" Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" Calendar-MonthLayout="Layout_7columns_x_6rows">
                                 <DateInput Font-Size="Medium" Skin="">
                                 </DateInput>
                                 </rad:RadDatePicker></div>
                                 <div>&nbsp;</div>
                                 <div><asp:Button ID="btnSet" runat="server" Text="Set Cutt-Off Day" OnClick ="btnSet_click" /></div>
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <div>&nbsp;</div>                            
                                <div>&nbsp;</div>
                                <div class="inputformsectionheader">Payment Amount</div>
                                <div>&nbsp;</div>
                                <div class="inputform">                
                                   <div style="text-align:center;"><asp:Label ID="lblPaymentAmount" runat="server" ForeColor="Red" ></asp:Label></div>
                                   <div>&nbsp;</div>
                                   <div style="text-align: right;"><asp:Button ID="btnAssign" runat="server" Text="Create Payment" OnClick ="btnAssign_click" /></div>
                                </div>
                                <div>&nbsp;</div>
                                <div class="inputform"> 
                                   <div style="text-align:center;"><asp:Label ID="lblWebInvoiceNumber" runat="server" ></asp:Label></div>
                                </div>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                      <div>&nbsp;</div>
                    </td>
                    <td class="" style="vertical-align: top;">
                        <asp:DataGrid ID="dgvPay" runat="server" style="background-color: white; width: 100%"  ShowFooter="false" AutoGenerateColumns="false" >
                          <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />   
                          <Columns>
                          <asp:TemplateColumn>
                            <HeaderTemplate>
                              <asp:CheckBox id="chkAll" runat="server"  OnCheckedChanged ="chkAll_OnCheckedChanged" AutoPostBack = "True"></asp:CheckBox>
                            </HeaderTemplate>
                            <ItemTemplate>
                              <asp:CheckBox ID="chkSelected" runat="server"  AutoPostBack="true"  />
                            </ItemTemplate>
                          </asp:TemplateColumn>
                          <asp:BoundColumn DataField="InvoiceID" HeaderText="InvoiceID" Visible= "false" />
                          <asp:BoundColumn DataField="TicketID" HeaderText="TickID" Visible= "false" />
                             <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                                <ItemTemplate>
                                  <a target ="blank" href="Invoicedticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a>&nbsp;&nbsp;&nbsp;<a target="_blank" href="OldSingleInvoiceReport.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><img style="border: 0" alt="Single Invoices" src="/graphics/printable.png" /></a>
                                </ItemTemplate>
                              </asp:TemplateColumn>
                            <asp:BoundColumn DataField="Age" HeaderText="Age" />
                            <asp:BoundColumn DataField="StatusDescription" HeaderText="Claim Status" />
                             <asp:BoundColumn DataField="MonthNames" HeaderText="Month" />
                            <asp:BoundColumn DataField="ReferenceNumber2" HeaderText="CustomerPO" />
                            <asp:BoundColumn DataField="SerialNumber" HeaderText="SerialNumber" />
                            <asp:BoundColumn DataField="Status" HeaderText="Service Status" />
                            <asp:BoundColumn DataField="AmountCharged" HeaderText="LaborCharged"  DataFormatString="{0:C}"/>
                            <asp:BoundColumn DataField="PartsCharged" HeaderText="PartsCharged"  DataFormatString="{0:C}"/>
                            <asp:BoundColumn DataField="TotalCharged" HeaderText="TotalCharged"  DataFormatString="{0:C}"/>
                            <asp:BoundColumn DataField="AmountPaid" HeaderText="AmountPaid"  DataFormatString="{0:C}"/>
                            <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}"/>
                          </Columns>              
                        </asp:DataGrid>
                     </td>
                   </tr>
                 </tbody>
               </table> 
              </div>
            <div>&nbsp;</div> 
            </asp:View>
            <asp:View ID="vwPaid" runat ="server" >
            <div >&nbsp;</div>
            <div style="text-align:center;">
            <table   width="100%" >
            <tr style="width:100%">
            <td style="width:35%">&nbsp;</td>
            <td style="width:30%">
            <asp:DataGrid ID="dgvPriorInvoices" runat="server" ShowFooter="false" AutoGenerateColumns="false" >
               <HeaderStyle CssClass="gridheader" />
               <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" Visible="false" />
                <asp:BoundColumn DataField="DateCreated" HeaderText="Date"  />
                <asp:TemplateColumn ItemStyle-Wrap="false" HeaderText="Payment Transaction">
                  <ItemTemplate>
                    <a href="invoices.aspx?ivid=<%# DataBinder.Eval(Container.DataItem,"InvoiceID") %>&mode=pt"><%# DataBinder.Eval(Container.DataItem,"InvoiceNumber") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="Total" HeaderText="Amount"  DataFormatString="{0:C}"/>
              </Columns>              
            </asp:DataGrid>
            </td>
            <td style="width:35%">&nbsp;</td>
            </tr>
            </table>
            </div>
            </asp:View>
            <asp:View ID="vwpt" runat ="server">
            <div >&nbsp;</div>
            <asp:DataGrid ID="dgvPaidTransactions" runat="server" style="background-color: white; width: 100%"  ShowFooter="false" AutoGenerateColumns="false" >
                          <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />   
                          <Columns>
                          
                          <asp:BoundColumn DataField="InvoiceID" HeaderText="InvoiceID" Visible= "false" />
                          <asp:BoundColumn DataField="TicketID" HeaderText="TickID" Visible= "false" />
                             <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                                <ItemTemplate>
                                  <a target ="blank" href="Invoicedticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%#DataBinder.Eval(Container.DataItem, "TicketID")%></a>
                                </ItemTemplate>
                              </asp:TemplateColumn>
                            <asp:BoundColumn DataField="Age" HeaderText="Age" />
                            <asp:BoundColumn DataField="StatusDescription" HeaderText="Claim Status" />
                             <asp:BoundColumn DataField="MonthNames" HeaderText="Month" />
                            <asp:BoundColumn DataField="ReferenceNumber2" HeaderText="CustomerPO" />
                            <asp:BoundColumn DataField="SerialNumber" HeaderText="SerialNumber" />
                            <asp:BoundColumn DataField="Status" HeaderText="Service Status" />
                            <asp:BoundColumn DataField="AmountCharged" HeaderText="LaborCharged"  DataFormatString="{0:C}"/>
                            <asp:BoundColumn DataField="PartsCharged" HeaderText="PartsCharged"  DataFormatString="{0:C}"/>
                            <asp:BoundColumn DataField="TotalCharged" HeaderText="TotalCharged"  DataFormatString="{0:C}"/>
                            <asp:BoundColumn DataField="AmountPaid" HeaderText="AmountPaid"  DataFormatString="{0:C}"/>
                            <asp:BoundColumn DataField="Outstanding" HeaderText="Outstanding"  DataFormatString="{0:C}"/>
                          </Columns>              
                        </asp:DataGrid>
            
            </asp:View>
            </asp:MultiView>
            
   </form>
</asp:Content>