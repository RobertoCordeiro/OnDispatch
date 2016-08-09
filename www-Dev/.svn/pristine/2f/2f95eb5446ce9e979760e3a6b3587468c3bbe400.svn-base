<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Remove Manufacturer"
      Master.PageTitleText = " Remove Manufacturer"
      Master.PageSubHeader = ""
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      LoadAssignment()
    Else
      Response.Redirect("default.aspx", True)
    End If
  End Sub

  Private Sub LoadServiceType(ByVal lngID As Long)
    Dim stp As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    stp.load(lngID)
    If lblReturnUrl.Text.Trim.Length = 0 Then
      lblReturnUrl.Text = "editservicetype.aspx?id=" & stp.ServiceTypeID
    End If
  End Sub
  
  Private Sub LoadAssignment()
    Dim sma As New BridgesInterface.ServiceTypeManufacturerAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    sma.Load(_ID)    
    LoadServiceType(sma.ServiceTypeID)
    Dim man As New BridgesInterface.ManufacturerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    man.Load(sma.ManufacturerID)
    lblManufacturer.Text = man.Manufacturer
  End Sub
    
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim sma As New BridgesInterface.ServiceTypeManufacturerAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    sma.Load(_ID)
    sma.Delete()
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div>&nbsp;</div>
    <div>Are you sure you wish to disassociate <asp:Label ID="lblManufacturer" runat="server" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOk" OnClick="btnOK_Click" Text="Yes" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>