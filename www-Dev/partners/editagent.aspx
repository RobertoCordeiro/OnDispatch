<%@ Page Language="vb" masterpagefile="~/masters/partnerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/partnerdialog.master" %>
<script runat="server">  

  Dim _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = ""
      Master.PageTitleText = ""
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If HasClearance() Then
    Else
      Response.Redirect(lblReturnUrl.Text)
    End If
  End Sub
  
  Private Sub LoadAgent(ByVal lngAgentID As Long)
    Dim pta As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    pta.Load(lngAgentID)
    
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Function HasClearance() As Boolean
    Dim blnReturn As Boolean = True
    Dim pta As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim ptacompare As New BridgesInterface.PartnerAgentRecord(pta.ConnectionString)
    ptacompare.Load(ID)
    pta.Load(Master.PartnerAgentID)
    If pta.AdminAgent = False Then
      blnReturn = False
    End If
    If Not pta.PartnerID = ptacompare.PartnerID Then
      blnReturn = False
    End If
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>