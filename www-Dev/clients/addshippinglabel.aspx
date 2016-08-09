<%@ Page Language="vb" masterpagefile="~/masters/customerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/customerdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Add Shipping Label"
      Master.PageTitleText = " Add Shipping Label"
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
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
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
    lbl.Add(Master.UserID, _ID, cbxMethod.SelectedValue, cbxDestinations.SelectedValue, txtShippingLabel.Text)
    If txtDateDelivered.Text.Trim.Length > 0 Then
      lbl.Delivered = CType(txtDateDelivered.Text, Date)
    Else
      lbl.Delivered = Nothing
    End If
    lbl.Save(strChangeLog)
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
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <table style="width: 100%">
      <tbody>
        <tr>
          <td style="width: 64px;" class="label">Courier</td>
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
          <td colspan="3"><asp:TextBox ID="txtDateDelivered" runat="Server" /></td>
        </tr>
      </tbody>      
    </table>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOK" Text="Save" runat="server" OnClick="btnOK_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>