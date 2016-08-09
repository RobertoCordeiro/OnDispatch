<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" ValidateRequest="false"%>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">  
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Edit Shipping Label"
      Master.PageTitleText = " Edit Shipping Label"
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
        LoadDestinations()
        LoadCouriers()
        LoadShippingLabel()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadShippingLabel()
    Dim lbl As New BridgesInterface.ShippingLabelRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim com As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim mtd As New BridgesInterface.CourierMethodRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim crr As New BridgesInterface.CourierRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    lbl.Load(_ID)
    com.Load(lbl.TicketComponentID)
    mtd.Load(lbl.CourierMethodID)
    crr.Load(mtd.CourierID)
    tkt.Load(com.TicketID)
    Master.PageSubHeader &= "<a href=""customer.aspx?id=" & tkt.CustomerID & """>Customer</a> &gt; <a href=""ticket.aspx?id=" & tkt.TicketID & """>Ticket</a> &gt; "
    Master.PageSubHeader &= "<a href=""editcomponent.aspx?id=" & com.TicketComponentID & """>Component</a> &gt; Edit Shipping Label"
    If crr.CourierID <> cbxCourier.SelectedValue Then      
      cbxCourier.SelectedValue = crr.CourierID
      LoadMethod(crr.CourierID)
        End If
        txtTrackingInfo.Text = lbl.TrackInformation
        chkTracked.Checked = lbl.Tracked
        txtDateDelivered.Text = lbl.Delivered
    cbxMethod.SelectedValue = lbl.CourierMethodID
    cbxDestinations.SelectedValue = lbl.ShippingDestinationID
    txtShippingLabel.Text = lbl.ShippingLabel
  End Sub

  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      SaveShippingLabel()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub SaveShippingLabel()
        Dim strChangeLog As String = ""
        Dim lbl As New BridgesInterface.ShippingLabelRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim par As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim fld As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim lngTicketID As Long
        lbl.Load(_ID)
    lbl.CourierMethodID = cbxMethod.SelectedValue
    lbl.ShippingDestinationID = cbxDestinations.SelectedValue
        lbl.ShippingLabel = txtShippingLabel.Text
        lbl.Tracked = chkTracked.Checked
        lbl.TrackInformation = txtTrackingInfo.Text
        
    If txtDateDelivered.Text.Trim.Length > 0 Then
      lbl.Delivered = CType(txtDateDelivered.Text, Date)
    Else
      lbl.Delivered = Nothing
    End If
        par.Load(lbl.TicketComponentID)
        lngTicketID = par.ticketID
        lbl.Save(strChangeLog)
        If chkAdd.Checked = True Then
            fld.Add(1, lngTicketID, 28)
            fld.Save(strChangeLog)
        End If
        If chkRemove.Checked = True Then
            fld.RemoveTicketFromFolder(lngTicketID, 28)
        End If
    
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(2, "web", strType, strIp, "web", 36, lbl.ShippingLabelID, strChangeLog)
  End Sub

  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dat As Date = DateTime.Now
    If txtShippingLabel.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Shipping Label is Required</li>"
    End If
    If txtDateDelivered.Text.Trim.Length > 0 Then
      If Not DateTime.TryParse(txtDateDelivered.Text, dat) Then
        blnReturn = False
        strErrors &= "<li>Date Delivered is Not a Properly Formatted Date</li>"
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub LoadDestinations()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListShippingDestinations", "Destination", "ShippingDestinationID", cbxDestinations)
  End Sub
  
  Private Sub LoadCouriers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListCouriers", "Courier", "CourierID", cbxCourier)
    If cbxCourier.Items.Count > 0 Then
      LoadMethod(CType(cbxCourier.SelectedValue, Long))
    End If
  End Sub
  
  Private Sub CourierChanged(ByVal S As Object, ByVal E As EventArgs)
    If cbxCourier.Items.Count > 0 Then
      LoadMethod(CType(cbxCourier.SelectedValue, Long))
    End If
  End Sub
  
  Private Sub LoadMethod(ByVal lngID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDropDownList("spListCourierMethods", "@CourierID", lngID, "Method", "CourierMethodID", cbxMethod)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
    End Sub
    
    Private Sub btnViewHTML_Click(ByVal S As Object, ByVal E As EventArgs)
        
        
        Master.PageHeaderText = "Tracking information"
        divHTMLDocument.InnerHtml = txtTrackingInfo.Text
        divHTMLPreview.Visible = True
     
            
        

    End Sub
    
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <table style="width: 100%">
      <tbody>
        <tr>
          <td class="label">Courier</td>
          <td class="label">Destination</td>
          <td class="label">Method</td>
          <td class="label">Shipping&nbsp;Label</td>
        </tr>
        <tr>
          <td><asp:DropDownList style="width: 100%" ID="cbxCourier" runat="server" AutoPostBack="true" OnSelectedIndexChanged="CourierChanged" /></td>
          <td><asp:DropDownList style="width: 100%" ID="cbxDestinations" runat="server" /></td>      
          <td><asp:DropDownList style="width: 100%" ID="cbxMethod" runat="server" /></td>
          <td style="padding-right: 4px;"><asp:TextBox ID="txtShippingLabel" style="width: 100%" runat="server" /></td>
        </tr>
        <tr>
          <td class="label">Date Delivered</td>
          <td class="label">Tracked</td> 
          <td></td>  
          <td></td>       
        </tr>
        <tr>
          <td ><asp:TextBox ID="txtDateDelivered" runat="Server" /></td>
          <td style="padding-right:4px;"><asp:CheckBox ID="chkTracked" runat ="server" /></td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td colspan="4"><asp:CheckBox ID="chkAdd" Text="Add to Need Part Returned Folder" runat="Server" /><asp:CheckBox ID="chkRemove" Text="Remove from Need Part Returned Folder" runat="Server" />
          </td>
        </tr>
        <tr>
          <td colspan="3" class="label">Tracking&nbsp;Info</td>
          <td></td>
          
        </tr>
        <tr>
         <td colspan="4" style="padding-right: 4px;"><asp:TextBox style="width: 100%;" ID="txtTrackingInfo" TextMode="multiline" runat="server" /></td>
         <td></td>
         
        </tr>
      </tbody>      
    </table>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOK" Text="Save" runat="server" OnClick="btnOK_Click" /></div>
    <div style="text-align:left;"><asp:Button ID="btnViewHTML" Text="ViewHTML" runat="server" OnClick="btnViewHTML_Click" /></div>
     <div visible="false" id="divHTMLPreview" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <div id="divHTMLDocument" runat="server" />
             
            </div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>