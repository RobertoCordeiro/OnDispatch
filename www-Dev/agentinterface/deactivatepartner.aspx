<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Deactivate Partner"
      Master.PageTitleText = "Deactivate Partner"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""partners.aspx"">Partner Management</a> &gt; "
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      Master.PageSubHeader &= "<a href=""partner.aspx?id=" & _ID & """>Partner</a> &gt; Deactivate Partner</a>"
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtReason.Text.Trim.Length = 0 Then
      strErrors &= "<li>Reason is Required</li>"
      blnReturn = False
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
    
  Private Sub btnOk_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim ptn As New BridgesInterface.PartnerNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      ptr.Load(_ID)
            ptr.Deactivate()
            ptn.Add(_ID, Master.UserID, txtReason.Text)
            ClearAssignments()
      Response.Redirect(lblReturnUrl.Text)
    Else
      divErrors.Visible = True
    End If
  End Sub
  
    Private Sub ClearAssignments()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spPartnerInactiveClearAssignments")
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
        
        
    End Sub
    
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div>&nbsp;</div>
    <p style="width: 400px">Are you sure you wish to deactivate this partner? Doing so will remove all access to the web from this partners agents, deactivate all addresses and deactivate all phone numbers.</p>
    <div>&nbsp;</div>
    <div class="label">Reason for Deactivation</div>
    <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine" style="width: 99%; height: 64px;" />
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="No" />&nbsp;<asp:Button OnClick="btnOk_Click" ID="btnOK" runat="server" Text="Yes" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>