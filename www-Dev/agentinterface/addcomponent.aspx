<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Add Component"
      Master.PageTitleText = " Add Component"
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
        LoadTicket()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    tkt.Load(_ID)
    Master.PageSubHeader &= "<a href=""customer.aspx?id=" & tkt.CustomerID & """>Customer</a> &gt; <a href=""ticket.aspx?id=" & tkt.TicketID & """>Ticket</a> &gt; Add Component"
  End Sub
    
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dat As Date = DateTime.Now
    If txtComponent.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Component Name is Required</li>"
    End If
        If drpPartners.SelectedValue = "Choose Supplier" Then
            blnReturn = False
            strErrors &= "<li>You Must choose a supplier for this part.</li>"
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
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim svt As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim srv As New BridgesInterface.ServiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim air As New BridgesInterface.ShippingLabelRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        com.Add(Master.UserID, _ID, chkConsumable.Checked, txtComponent.Text)
        com.Code = txtCode.Text
        com.SerialNumber = txtInvoiceNumber.Text
        com.Notes = txtNotes.Text
        tkt.Load(com.TicketID)
        if txtQty.Text.Trim.Length > 0 Then
          com.Qty = TxtQty.Text
        else
          if IsDbNull(txtQty.text) then
            com.Qty = Ctype(0,Integer )
          end if
        end if
        if txtPartAmount.Text.Trim.Length > 0 Then
          com.PartAmount = TxtPartAmount.Text
        else
          if IsDbNull(txtPartAmount.text) then
            com.PartAmount = Ctype(0,Double )
          end if
        end if
        if txtTaxes.text.trim.length > 0 then
          com.Tax = Ctype(txtTaxes.Text,Double)
        else
          if IsDbNull(txtTaxes.text) then
            com.Tax = Ctype(0,Double )
          end if
        end if
        if txtShipping.Text.Trim.Length > 0 then
          com.Shipping = Ctype(txtShipping.Text,Double)
        else
          if isdbNull(txtShipping.text) then
            com.Shipping = Ctype(0,Double )
          end if
        end if
        if txtMarkUp.Text.Trim.Length > 0 then
          com.MarkUp  = Ctype(txtMarkUp.Text,Double)
        else
          if IsDbNull(txtMarkUP.text) then
            com.MarkUP = Ctype(0,Double )
          end if
        end if
        If TxtDateOrdered.Text.Trim.Length > 0 Then
            com.DateOrdered = CType(txtDateOrdered.Text, Date)
        Else
            com.DateOrdered = Now()
        End If
        If drpPartners.SelectedValue <> "Choose Supplier" Then
            com.SuppliedBy = drpPartners.SelectedValue
        Else
            com.SuppliedBy = 0
        End If
        If txtCoreCharge.Text.Trim.Length > 0 Then
            com.CoreCharge = CType(txtCoreCharge.Text, Double)
        Else
            com.CoreCharge = 0
        End If
        com.BillCustomer = ChkBillCustomer.Checked
        If (tkt.CustomerID = 51) Or (tkt.CustomerID = 30) Then
            com.BillShipping = True
        Else
            com.BillShipping = ChkBillShipping.Checked
        End If
        
        com.BillTaxes = ChkBillTaxes.Checked
        com.NeedReturned = ChkNeedReturned.Checked
        com.Consumable = chkConsumable.Checked
        com.ChargeTechCoreAmount = chkChargeForCore.Checked
        com.RMA = txtRMA.Text
        If ChkNeedReturned.Checked = True Then
            
            air.Add(Master.UserID, com.TicketComponentID, 1, 4, "CORE NEED RETURNED")
            air.Save(strChangeLog)
        End If
        If ChkBillCustomer.Checked Then
            tkt.Load(com.TicketID)
            srv.Load(tkt.ServiceID)
            svt.Load(srv.ServiceTypeID)
            If svt.ApplyPartMarkup > 0 Then
                If TxtPartAmount.Text <> "" Or Not IsDBNull(TxtPartAmount.Text) Then
                    com.MarkUp = TxtPartAmount.Text * (svt.ApplyPartMarkup / 100)
                End If
            End If
        End If
        'Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
        'plog.Add(Master.WebLoginID ,Now(),20,"Part has been added to the ticket " & _ID)
        
        com.Save(strChangeLog)
        
                
    End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  Private Sub LoadPartners()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListActiveVendors", "Company", "VendorID", drpPartners)
        drpPartners.Items.Add("Choose Supplier")
        drpPartners.SelectedValue = "Choose Supplier"
        txtDateOrdered.Text = now()
        txtQty.Text = 1
        chkBillCustomer.Checked = True
        chkBillTaxes.Checked = False
        chkBillShipping.Checked = False
        chkNeedReturned.Checked = False
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <table>
      <tbody>
        <tr>
          <td class="label">Order Date</td>
          <td class="label">Supplied By</td>
          <td class="label">Core Charge</td>
          <td class="label">RMA Number</td>
        </tr>
        <tr>
          <td><asp:TextBox ID="TxtDateOrdered" runat="server" /></td>
          <td><asp:DropDownList ID="drpPartners" runat="server" /></td>
          <td><asp:TextBox ID="txtCoreCharge" runat="server" /></td> 
          <td><asp:TextBox ID="txtRMA" runat="server" /></td>  
        </tr>
        <tr>  
          <td class="label">Qty</td>
          <td class="label">Code/SKU</td>
          <td class="label">Component Name</td>
          <td class="label">Invoice Number</td>      
        </tr>
        <tr>
          
          <td><asp:TextBox ID="TxtQty" runat="server" /></td>
          <td><asp:TextBox ID="txtCode" runat="server" /></td>
          <td><asp:TextBox ID="txtComponent" runat="server" /></td>
          <td style="padding-right: 4px;"><asp:TextBox ID="txtInvoiceNumber" runat="server" /></td>
        </tr>
        <tr>
          <td class="label">Part Amount</td>
          <td class="label">Taxes</td>
          <td class="label">Shipping Amount</td>
          <td class="label">MarkUp Amount</td>   
        </tr>
        <tr>
          <td><asp:TextBox ID="TxtPartAmount" runat="server" /></td>
          <td><asp:TextBox ID="TxtTaxes" runat="server" /></td>
          <td><asp:TextBox ID="TxtShipping" runat="server" /></td>
          <td><asp:TextBox ID="TxtMarkUp" runat="server" /></td>
        </tr>
        <tr>
          <td colspan="4" class="label">Notes/Description</td>
        </tr>
        <tr>
          <td colspan="4" style="padding-right: 4px;"><asp:TextBox style="width: 100%;" ID="txtNotes" TextMode="multiline" runat="server" /></td>
        </tr>
        <tr>
          
        </tr>
        <tr>
          <td  style="text-align: left;"><asp:CheckBox ID="ChkBillCustomer" Text="Bill Customer" runat="server" /></td>
          <td  style="text-align: left;"><asp:CheckBox ID="ChkBillShipping" Text="Credit Problems" runat="server" /></td>
          <td  style="text-align: left;"><asp:CheckBox ID="ChkBillTaxes" Text="Process Payment" runat="server" /><asp:CheckBox ID="chkChargeForCore" Text="Charge For Core" runat="server" /></td>
          <td  style="text-align: left;"><asp:CheckBox ID="ChkNeedReturned" Text="Need Core" runat="server" />&nbsp;<asp:CheckBox ID="chkConsumable" Text="Paid Supplier" runat="server" /></td>
          <td  style="text-align: left;"></td>
        </tr>
      </tbody>
    </table>    
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Save" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>