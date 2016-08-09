<%@ Page Language="vb" masterpagefile="~/masters/customerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/customerdialog.master" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<script runat="server">
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Address"
      Master.PageTitleText = "Edit Address"
    End If
    Secure()
    lblReturnUrl.Text = Request.QueryString("returnurl")
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try    
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadCustomerAddress()
      End If    
    End If
  End Sub
  
  
  Private Sub LoadCustomerAddress()
    Dim cad As New BridgesInterface.CustomerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cad.Load(_ID)    
    addAddress.AddressTypeID = cad.AddressTypeID
    addAddress.Street = cad.Street
    addAddress.Extended = cad.Extended
    addAddress.City = cad.City
    addAddress.StateID = cad.StateID
    addAddress.Zip = cad.ZipCode
    chkActive.Checked = cad.Active    
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect("account.aspx", True)
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsAddressComplete() Then
      divError.Visible = False
      SaveCustomerAddress()      
      Response.Redirect("account.aspx", True)
    Else
      divError.Visible = True
    End If
  End Sub
  
  Private Sub Secure()
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cag.Load(Master.CustomerAgentID)
    If Not cag.AdminAgent Then
      Response.Redirect("account.aspx", True)
    End If
  End Sub
  
  Private Sub SaveCustomerAddress()
    Dim cad As New BridgesInterface.CustomerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    cad.Load(_ID)
    cad.Street = addAddress.Street
    cad.Extended = addAddress.Extended
    cad.City = addAddress.City
    cad.StateID = addAddress.StateID
    cad.ZipCode = addAddress.Zip
    cad.AddressTypeID = addAddress.AddressTypeID
    cad.Active = chkActive.Checked
    cad.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    act.Add(Master.UserID, "web", "web", "web", "web", 8, cad.CustomerAddressID, strChangeLog)
  End Sub
  
  Private Function IsAddressComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strErrors As String = ""
    If addAddress.AddressTypeID <= 0 Then
      blnReturn = False
      strErrors &= "<li>Address Type is Required</li>"
    End If
    If addAddress.Street.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Street is Required</li>"
    End If
    If addAddress.City.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>City is Required</li>"
    End If
    If addAddress.StateID <= 0 Then
      blnReturn = False
      strErrors &= "<li>State is Required</li>"
    End If
    If addAddress.Zip.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Zip Code is Required</li>"
    Else
      zip.Load(addAddress.Zip.Trim)
      If zip.ZipCodeID <= 0 Then
        blnReturn = False
        strErrors &= "<li>Zip Code is Invalid</li>"
      End If
    End If
    divError.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
      <div id="divError" runat="server" visible="false" class="errorzone" />
      <div><cv:Address ID="addAddress" runat="server" RequireAddressType="true" RequireCity="true" RequireState="true" RequireZip="true" RequireStreet="true" /></div>
      <asp:CheckBox ID="chkActive" runat="server" Text="Active" />
      <div>&nbsp;</div>
      <div style="text-align: right"><asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button ID="btnSubmit" runat="server" Text="Update" OnClick="btnSubmit_Click"/></div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>&nbsp;</div>
      <div class="successtext">Success!</div>
    </div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>