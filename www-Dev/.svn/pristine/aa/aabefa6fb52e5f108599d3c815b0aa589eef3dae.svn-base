<%@ Page Language="vb" masterpagefile="~/masters/customerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/customerdialog.master" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<script runat="server">
  
  Private _Mode As String = ""
  Private _ReturnUrl As String = ""
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Add Phone Number"
      Master.PageTitleText = "Add Phone Number"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    _Mode = Request.QueryString("mode")
    _ReturnUrl = Request.QueryString("returnurl")
    If IsNothing(_Mode) Then
      divForm.Visible = False
    End If
  End Sub
    
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divError.Visible = False
      Select Case _Mode.Trim.ToLower
        Case "customer"
          SaveCustomerPhone()
        Case "ticket"
          SaveTicketPhone()
      End Select
      Response.Redirect(_ReturnUrl)
    Else
      divError.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(_ReturnUrl)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If phn.AreaCode.Trim.Length = 0 Then
      strErrors &= "<li>Area Code is Required</li>"
      blnReturn = False
    End If
    If phn.Exchange.Trim.Length = 0 Then
      strErrors &= "<li>Exchange is Required</li>"
      blnReturn = False
    End If
    If phn.LineNumber.Trim.Length = 0 Then
      strErrors &= "<li>Line Number is Required</li>"
      blnReturn = False
    End If
    strErrors = "<ul>" & strErrors & "</ul>"
    divError.InnerHtml = strErrors
    Return blnReturn
  End Function

  Private Sub SaveCustomerPhone()
    Dim cpn As New BridgesInterface.CustomerPhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    cpn.Add(Master.CustomerID, phn.PhoneTypeID, Master.UserID, "1", phn.AreaCode, phn.Exchange, phn.LineNumber)
    cpn.Extension = phn.Extension
    cpn.Pin = phn.Pin
    cpn.PhoneTypeID = phn.PhoneTypeID
    cpn.Save(strChangeLog)
  End Sub
  
  Private Sub SaveTicketPhone()
    Dim tpn As New BridgesInterface.TicketPhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    tpn.Add(_ID, phn.PhoneTypeID, Master.UserID, "1", phn.AreaCode, phn.Exchange, phn.LineNumber, True)
    tpn.Extension = phn.Extension
    tpn.Pin = phn.Pin
    tpn.PhoneTypeID = phn.PhoneTypeID
    tpn.Save(strChangeLog)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangePass" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
      <div id="divError" runat="server" visible="false" class="errorzone" />
      <div><cv:Phone Text="Phone Number" RequirePhone="true" ID="phn" runat="server" /></div>
      <div>&nbsp;</div>
      <div style="text-align: right"><asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button ID="btnSubmit" runat="server" Text="Add" OnClick="btnSubmit_Click"/></div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>&nbsp;</div>
      <div class="successtext">Success!</div>
    </div>
  </form>
</asp:Content>