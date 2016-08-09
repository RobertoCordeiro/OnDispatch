<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<script runat="server">
  
  Private _Mode As String = ""
  Private _ReturnUrl As String = ""
  Private _ID As Long = 0
    Private _PartnerID As Long = 0
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Add Address"
            Master.PageTitleText = "Add Address"
            Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            inf.Load(Master.InfoID)
            _PartnerID = inf.PartnerID
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
    _Mode = Request.QueryString("mode")
    _ReturnUrl = Request.QueryString("returnurl")
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
  End Sub
    
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsAddressComplete() Then
      divError.Visible = False
      Select Case _Mode.Trim.ToLower
        Case "resume"
          SaveResumeAddress()
        Case "customer"
          SaveCustomerAddress()
        Case "partner"
          SavePartnerAddress()
      End Select
      Response.Redirect(_ReturnUrl)
    Else
      divError.Visible = True
    End If
  End Sub
  
  Private Sub SavePartnerAddress()
    Dim pad As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
       
        Dim strChangeLog As String = ""
        
        pad.Add(_PartnerID, Master.UserID, addAddress.StateID, addAddress.AddressTypeID, addAddress.Street, addAddress.City, addAddress.Zip)
    pad.Extended = addAddress.Extended
    pad.Save(strChangeLog)    
  End Sub
  
  Private Sub SaveCustomerAddress()
    Dim cad As New BridgesInterface.CustomerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
        cad.Add(_ID, Master.UserID, addAddress.StateID, addAddress.AddressTypeID, addAddress.Street, addAddress.City, addAddress.Zip)
    cad.Extended = addAddress.Extended
    cad.Save(strChangeLog)
  End Sub
  
  Private Sub SaveResumeAddress()
    Dim rad As New BridgesInterface.ResumeAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    rad.Add(_ID, Master.UserID, addAddress.StateID, addAddress.AddressTypeID, addAddress.Street, addAddress.City, addAddress.Zip)
    rad.Extended = addAddress.Extended
    rad.Save(strChangeLog)
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
      <div>&nbsp;</div>
      <div style="text-align: right"><asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button ID="btnSubmit" runat="server" Text="Add" OnClick="btnSubmit_Click"/></div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>&nbsp;</div>
      <div class="successtext">Success!</div>
    </div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>