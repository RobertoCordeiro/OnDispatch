<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Assembly="RadCalendar.Net2" Namespace="Telerik.WebControls" TagPrefix="rad" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Edit Component"
      Master.PageTitleText = " Edit Component"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customers</a> &gt; "
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
        If _ID > 0 Then
            If Not IsPostBack Then
                LoadPartners()
                LoadComponent()
            End If
        Else
            Response.Redirect(lblReturnUrl.Text, True)
        End If
        
  End Sub

  Private Sub LoadComponent()
    Dim com As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(com.ConnectionString)
        Dim inv As New BridgesInterface.InvoiceRecord(com.ConnectionString)
        
    Dim datNothing As Date = Nothing
    com.Load(_ID)
    tkt.Load(com.TicketID)
    Master.PageSubHeader &= "<a href=""customer.aspx?id=" & tkt.CustomerID & """>Customer</a> &gt; <a href=""ticket.aspx?id=" & tkt.TicketID & """>Ticket</a> &gt; Edit Component"
        txtCode.Text = com.Code
        txtComponent.Text = com.Component
        txtInvoiceNumber.Text = com.SerialNumber
        txtRMA.text = com.RMA
        txtQty.Text = com.Qty
        txtPartAmount.Text = com.PartAmount.ToString("C2")
        txtTax.Text = com.Tax.ToString("C2")
        txtShipping.Text = com.Shipping.ToString("C2")
        TxtMarkUp.Text = com.MarkUp.ToString("C2")
        drpPartners.SelectedValue = com.SuppliedBy
        txtNotes.Text = com.Notes
        chkConsumable.Checked = com.Consumable
        ChkBillCustomer.Checked = com.BillCustomer
        ChkBillShipping.Checked = com.BillShipping
        ChkBillTaxes.Checked = com.BillTaxes
        ChkNeedReturned.Checked = com.NeedReturned
        txtCoreCharge.Text = com.CoreCharge.ToString("C2")
        chkChargeForCore.Checked = com.ChargeTechCoreAmount
        
        If Not IsDBNull(com.CoreCharge) Then
            txtCoreCharge.Text = com.CoreCharge.ToString("C2")
        End If
        If com.DateOrdered <> datNothing Then
            TxtDateOrdered.Text = com.DateOrdered.ToString
        End If
        If com.InvoiceID.ToString.Length > 0 Then
            inv.Load(com.InvoiceID)
            lblPartInvoiceNumber.Text = inv.InvoiceNumber
        Else
            lblPartInvoiceNumber.Text = "No Part Invoice Created"
        End If
        If com.Paid = True Then
            lblCreditMessage.text = "Part has been credited by Supplier"
            btnApplyCredit.Enabled = False
            txtPartAmount.Enabled = False
        Else
            btnApplyCredit.Enabled = True
            lblCreditMessage.Text = ""
            txtPartAmount.Enabled = True
        End If
    End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dat As Date = DateTime.Now
    If txtComponent.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Component Name is Required</li>"
    End If
       
        If TxtDateOrdered.Text.Trim.Length > 0 Then
            If Not DateTime.TryParse(TxtDateOrdered.Text, dat) Then
                blnReturn = False
                strErrors &= "<li>Date Ordered is Not a Valid Date Format</li>"
            End If
        End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveComponent()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub SaveComponent()
    Dim strChangeLog As String = ""
    Dim com As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    com.Load(_ID)
        com.Code = txtCode.Text
        com.Component = txtComponent.Text
        com.SerialNumber = txtInvoiceNumber.Text
        com.RMA = txtRMA.text
        com.Notes = txtNotes.Text
        if drpPartners.SelectedValue <> "Customer Providing" then
            com.SuppliedBy = drpPartners.SelectedValue
            
        Else
            com.SuppliedBy = 0
           
        End If
        com.Consumable = chkConsumable.Checked
        com.BillCustomer = ChkBillCustomer.Checked
        com.BillShipping = ChkBillShipping.Checked
        
        com.NeedReturned = ChkNeedReturned.Checked
        com.MarkUp = TxtMarkUp.Text
        com.Qty = txtQty.Text
        com.PartAmount = txtPartAmount.Text
        com.Tax = txtTax.Text
        com.Shipping = txtShipping.Text
        
        com.ChargeTechCoreAmount = chkChargeForCore.Checked
        If txtDateOrdered.Text.Trim.Length > 0 Then
            com.DateOrdered = CType(txtDateOrdered.Text, Date)
        Else
            com.DateOrdered = Nothing
        End If
        
        If com.InvoiceID.ToString = "0" Then
            com.BillTaxes = ChkBillTaxes.Checked
            com.CoreCharge = txtCoreCharge.Text
            com.CoreCharge = txtCoreCharge.Text
        End If
        
        com.Save(strChangeLog)
        Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strIp As String = Request.QueryString("REMOTE_ADDR")
        Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
        If IsNothing(strIp) Then
            strIp = "unknown"
        End If
        If IsNothing(strType) Then
            strType = "web"
        End If
        act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID, 35, com.TicketComponentID, strChangeLog)
    End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
    Private Sub LoadPartners()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListActiveVendors", "Company",  "VendorID", drpPartners)
        drpPartners.Items.Add("Customer Providing")
        drpPartners.SelectedValue = "Customer Providing"
    End Sub
    
    Private Sub chkChargeforCore_Update(ByVal sender As Object, ByVal e As EventArgs)
        Dim com As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        com.Load(_ID)
        If com.InvoiceID.ToString = "0" Then
            
            txtCoreCharge.Text = ((txtPartAmount.Text * txtQty.Text) * 0.3)
        End If
        
    End Sub
    Private Sub btnApplyCredit_Click(ByVal S As Object, ByVal E As EventArgs)
        If btnApplyCredit.Text = "<<< Apply Part Credit" Then
            divPartsCredit.Visible = "false"
            btnApplyCredit.Text = "Apply Part Credit >>>"
            
        Else
            divPartsCredit.Visible = "true"
            btnApplyCredit.Text = "<<< Apply Part Credit"
            RadDatePickerFrom.SelectedDate = Date.Today
            txtAmountCredited.Text = CDbl(txtPartAmount.Text * txtQty.Text)
            
        End If
    End Sub
    Private Sub btnSubmit1_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim com As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(com.ConnectionString)
        com.Load(_ID)
        tkt.Load(com.TicketID)
        If txtCheckNumber.Text <> "" Then
            If txtPartAmount.Text <> "$0.00" Then
                If (txtAmountCredited.Text <> "$0.00") Or (txtAmountCredited.Text <> "0.00") Or (txtAmountCredited.Text <> "0") Or (txtAmountCredited.Text <> "") Then
                    ProcessPartsPayment(CLng(tkt.TicketID))
                Else
                    MsgBox("The Amount Credited cannot be Zero or Null!")
                End If
            Else
                MsgBox("You can't credit a part that has zero amount.")
            End If
        Else
            MsgBox("You must enter a Credit number so we can apply the credit for this part.")
        End If
        
    End Sub
       
    Private Sub ProcessPartsPayment(ByVal lngTicketID As Long)
        Dim com As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim par As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(com.ConnectionString)
        Dim inv As New BridgesInterface.InvoiceRecord(com.ConnectionString)
        Dim pay As New BridgesInterface.PaymentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim strChangeLog As String = ""
                       
        tkt.Load(lngTicketID)
        If tkt.InvoiceID <> 0 And Not IsDBNull(tkt.InvoiceID) Then
            Dim dblTotalAmount As Double
            If txtQty.Text > 1 Then
                dblTotalAmount = CDbl((txtPartAmount.Text) * (txtQty.Text))
            Else
                dblTotalAmount = CDbl(txtPartAmount.Text)
            End If
            txtAmountCredited.Text = dblTotalAmount
            pay.Add(tkt.InvoiceID, 1, 11, txtAmountCredited.Text, RadDatePickerFrom.SelectedDate)
            par.Load(_ID)
            If dblTotalAmount = txtAmountCredited.Text Then
                par.Paid = True
            End If
            par.Save(strChangeLog)
                                   
            pay.CheckNumber = txtCheckNumber.Text.ToString
            pay.TicketComponentID = _ID
            pay.TicketID = tkt.TicketID
            pay.Save(strChangeLog)
           
            tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "Credit for Parts: Payment record has been processed - " & tkt.TicketID & " / CheckNumber: " & txtCheckNumber.Text & " - Amount: $" & dblTotalAmount & " - Part Description: " & txtComponent.Text)
                             
            tnt.CustomerVisible = False
            tnt.PartnerVisible = False
            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
            tnt.Acknowledged = True
            tnt.Save(strChangeLog)
            
            
            divPartsCredit.Visible = False
            btnApplyCredit.Text = "Apply Part Credit >>>"
        End If
        
        'production

        '        'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        '        'usr.Load(Master.LoginID)
        Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wbl.Load(Master.WebLoginID)
        Dim strUserName As String
        strUserName = wbl.Login

        Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        plog.Add(Master.WebLoginID, Now(), 8, "Parts Credit record has been processed - " & tkt.TicketID & " / CheckNumber: " & txtCheckNumber.Text)
        txtCheckNumber.Text = ""
    End Sub
    
    Private Sub MsgBox(ByVal strMessage As String)
        'Begin building the script 
        Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
        strScript += "alert(""" & strMessage & """)" & vbCrLf
        strScript += "<" & "/" & "SCRIPT" & ">"
        'Register the script for the client side 
        ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript)
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <table>
      <tbody>
        <tr>
          <td class="label" style="width:10%">Date Ordered</td>
          <td class="label">Supplied By</td>
          <td class="label">Core Charge Amount</td>
          <td class="label">RMA Number</td>
        </tr>
        <tr>
          <td style="width:10%"><asp:TextBox  ID="txtDateOrdered" runat="server" /></td>
          <td><asp:DropDownList ID="drpPartners" runat="server" /></td>
          <td style="width: 134px"><asp:TextBox ID="txtCoreCharge" runat="server" /></td>
          <td style="width: 134px"><asp:TextBox ID="txtRMA" runat="server" /></td>
        </tr>
        <tr style ="width:100%">
          <td class="label" style="width:10%">Qty</td>
          <td class="label" style="width:20%">Code/SKU</td>
          <td class="label" style="width:50%">Component&nbsp;Name</td>
          <td class="label" style="width:20%">Order Number - Invoice Number</td> 
               
        </tr>
        <tr style ="width:100%">
          <td style="width:10%"><asp:TextBox  ID="txtQty" runat="server" /></td>
          <td style="width:20%"><asp:TextBox   ID="txtCode" runat="server" /></td>
          <td style="width:50%"><asp:TextBox   ID="txtComponent" runat="server" /></td>
          <td style="width:20%"><asp:TextBox  ID="txtInvoiceNumber" runat="server" /></td>
          <td></td>
        </tr>
        <tr>
          <td class="label" >Part Amount</td>
          <td class="label">Taxes</td>
          <td class="label">Shipping Amount</td>
          <td class="label">MarkUp Amount</td>       
        </tr>
        <tr>
          <td ><asp:TextBox  ID="txtPartAmount" runat="server" /></td>
          <td><asp:TextBox  ID="txtTax" runat="server" /></td>
          <td><asp:TextBox  ID="txtShipping" runat="server" /></td>
          <td><asp:TextBox  ID="TxtMarkUp" runat="server" /></td>

        </tr>
        
        <tr>
          <td colspan="4" class="label">Notes/Description (<asp:Label ID="lblPartInvoiceNumber" runat ="server" />) </td>
        </tr>
        <tr>
          <td colspan="4" style="padding-right: 4px;"><asp:TextBox style="width: 100%;" ID="txtNotes" TextMode="multiline" runat="server" /></td>
        </tr>
        <tr>
          
        </tr>
        <tr>
          <td style="text-align: left;"><asp:CheckBox ID="ChkBillCustomer" Text="Bill Customer" runat="server" /></td>
          <td style="text-align: left;"><asp:CheckBox ID="ChkBillShipping" Text="Credit Problems" runat="server" /></td>
          <td colspan="2" style="text-align: left;"><asp:CheckBox ID="ChkBillTaxes" Text="Deduct from Tech" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox ID="chkChargeForCore" Text="Charge for Core" runat="server"  OnCheckedChanged="chkChargeForCore_Update"  AutoPostBack="true"/>&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox ID="ChkNeedReturned" Text="Need Core" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox ID="chkConsumable" Text="Paid Supplier" runat="server" /></td>
          <td  style="text-align: left;"></td>
          <td  style="text-align: left;"></td>
        </tr>
      </tbody>
    </table>    
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Save" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    <div style="text-align: left;">&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button OnClick="btnApplyCredit_Click" ID="btnApplyCredit" runat="server" Text="Apply Part Credit >>" />&nbsp;&nbsp;<asp:Label ID="lblCreditMessage" runat="server"></asp:Label></div>
    <div visible="false" id="divPartsCredit" runat="server"><div>&nbsp;</div>
     <table width="30%" cellspacing="2px" cellpadding="2px" class="bandpanel" >
         <tr>
           <td>&nbsp;</td>
           <td >
             <div>&nbsp;</div>
                 <div class="label">Credit Date:</div>
                 <div><rad:RadDatePicker ID="RadDatePickerFrom" runat="server"  DateInput-Font-Size="Medium" Culture="English (United States)" Skin="" Calendar-Skin="Web20" Calendar-FastNavigationStep="12" Calendar-MonthLayout="Layout_7columns_x_6rows">
                <DateInput Font-Size="Medium" Skin="">
                </DateInput>
                </rad:RadDatePicker></div>
                <div>&nbsp;</div>
                <div class="label">Amount Credited:</div>
                <div><asp:TextBox ID="txtAmountCredited" runat="server" width="95%" /></div>
                <div>&nbsp;</div>
                <div>&nbsp;</div>
                <div class="label">Credit Number:</div>
                <div><asp:TextBox ID="txtCheckNumber" runat="server" width="95%" /></div>
                <div>&nbsp;</div>
                <div style="text-align: left;"><asp:Button ID="btnSubmit1" runat="server" Text="Record" OnClick="btnSubmit1_Click" /></div>
                <div>&nbsp;</div>
           </td>
         </tr>
        </table>
        <div>&nbsp;</div>
    </div>
    
    
    
  </form>
</asp:Content>