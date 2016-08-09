<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  Private _FID as Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Add Shipping Label"
      Master.PageTitleText = " Add Shipping Label"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customers</a> &gt; "
    End If
    
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    Try
      _FID = CType(Request.QueryString("fid"), Long)
    Catch ex As Exception
      _FID = 0
    End Try
    
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadDestinations()
        LoadCouriers()
        LoadTicketComponent()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadTicketComponent()    
    Dim com As New BridgesInterface.TicketComponentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim mtd As New BridgesInterface.CourierMethodRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim crr As New BridgesInterface.CourierRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    tkt.Load(_ID)
    Master.PageSubHeader &= "<a href=""customer.aspx?id=" & tkt.CustomerID & """>Customer</a> &gt; <a href=""ticket.aspx?id=" & tkt.TicketID & """>Ticket</a> &gt; "
    Master.PageSubHeader &= "<a href=""editcomponent.aspx?id=" & com.TicketComponentID & """>Component</a> &gt; Add Shipping Label"
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
    Dim par as New BridgesInterface.TicketComponentRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
        Dim fld As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim nts As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim lngTicketID as long
    
        lbl.Add(Master.UserID, _ID, cbxMethod.SelectedValue, cbxDestinations.SelectedValue, txtShippingLabel.Text)
    If txtDateDelivered.Text.Trim.Length > 0 Then
      lbl.Delivered = CType(txtDateDelivered.Text, Date)
    Else
      lbl.Delivered = Nothing
    End If
    par.Load (lbl.TicketComponentID)
    lngTicketID = par.ticketID
    if cbxDestinations.SelectedValue = 5 then
     par.DateDelivered = Now()
           
            lbl.CourierMethodID = 2
    end if
    lbl.Save(strChangeLog)
    If chkAdd.checked = True then
      fld.Add (1,lngTicketID,28)
      fld.Save (strChangeLog)
    end if
    If chkRemove.Checked = True then
      fld.RemoveTicketFromFolder (lngTicketID,28)
        End If
        
        nts.Add(lngTicketID, Master.WebLoginID, Master.UserID, "Auto Note: Label has been added to the part:" & par.Code & " - " & cbxDestinations.SelectedItem.Text.ToString & ": " & txtShippingLabel.Text)
        nts.CustomerVisible = False
        nts.PartnerVisible = False
        nts.Acknowledged = True
        nts.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        nts.Save(strChangeLog)
        
        par.Save(strChangeLog)
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
  Private Function IsTicketInFolder(intTicketID as Integer ) as Boolean 
  
  End Function
  
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
          <td colspan="3" class="label">Date Delivered</td>          
        </tr>
        <tr>
          <td colspan="3"><asp:TextBox ID="txtDateDelivered" runat="Server" /><asp:CheckBox ID="chkAdd" Text="Add to Need Part Returned Folder" runat="Server" /><asp:CheckBox ID="chkRemove" Text="Remove from Need Part Returned Folder" runat="Server" /></td>
        </tr>
      </tbody>      
    </table>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOK" Text="Save" runat="server" OnClick="btnOK_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>