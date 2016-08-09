<%@ Page Language="vb" masterpagefile="~/masters/customerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/customerdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Add Component"
      Master.PageTitleText = " Add Component"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadTicket()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    tkt.Load(_ID)
  End Sub
    
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dat As Date = DateTime.Now
    If txtComponent.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Component Name is Required</li>"
    End If
    If txtDateDelivered.Text.Trim.Length > 0 Then
      If Not DateTime.TryParse(txtDateDelivered.Text, dat) Then
        blnReturn = False
        strErrors &= "<li>Delivery Date is Not a Valid Date Format</li>"
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
    com.Add(Master.UserID, _ID, chkConsumable.Checked, txtComponent.Text)
    com.Code = txtCode.Text
    com.SerialNumber = txtSerialNumber.Text
    com.Notes = txtNotes.Text
    If txtDateDelivered.Text.Trim.Length > 0 Then
      com.DateDelivered = CType(txtDateDelivered.Text, Date)
    Else
      com.DateDelivered = Nothing
    End If
    com.Save(strChangeLog)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <table>
      <tbody>
        <tr>
          <td class="label">Part SKU</td>
          <td class="label">Component&nbsp;Name</td>
          <td class="label">Serial Number</td>      
        </tr>
        <tr>
          <td><asp:TextBox style="width: 100%" ID="txtCode" runat="server" /></td>
          <td><asp:TextBox style="width: 100%" ID="txtComponent" runat="server" /></td>
          <td style="padding-right: 4px;"><asp:TextBox style="width: 100%" ID="txtSerialNumber" runat="server" /></td>
        </tr>
        <tr>
          <td colspan="3" class="label">Notes/Description</td>
        </tr>
        <tr>
          <td colspan="3" style="padding-right: 4px;"><asp:TextBox style="width: 100%;" ID="txtNotes" TextMode="multiline" runat="server" /></td>
        </tr>
        <tr>
          <td colspan="3" class="label">Date Delivered</td>
        </tr>
        <tr>
          <td><asp:TextBox ID="txtDateDelivered" runat="server" /></td>
          <td colspan="2" style="text-align: right;"><asp:CheckBox ID="chkConsumable" Text="Consumable" runat="server" /></td>
        </tr>
      </tbody>
    </table>    
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Save" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>