<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Edit Certification"
      Master.PageTitleText = " Edit Certification"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""settings.aspx"">Settings</a> &gt; Edit Certification"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadCert()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadCert()
    Dim crt As New BridgesInterface.CertificationRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    crt.Load(_ID)
    txtCertificationName.Text = crt.CertificationName
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtCertificationName.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Certification Name is Required</li>"
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim crt As New BridgesInterface.CertificationRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      crt.Load(_ID)
      Dim strTrash As String = ""
      crt.CertificationName = txtCertificationName.Text
      crt.Save(strTrash)
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div>&nbsp;</div>
    <div class="label">Certification Name</div>
    <asp:TextBox ID="txtCertificationName" runat="server" style="width: 100%" />
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>