<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Remove Signed Work Order"
            Master.PageTitleText = "Remove Signed Work Order"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; Remove Signed Work Order"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      wrk.Load(_ID)
      If wrk.WorkOrderID = 0 Then
        Response.Redirect(lblReturnUrl.Text, True)
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub btnYes_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim strChangeLog As String = ""
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Load(CType(_ID, Long))
        If wrk.WorkOrderFileID > 0 Then
            Dim exp As New cvCommon.Export
            Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("WOCnn"))
            fil.Load(wrk.WorkOrderFileID)
            'exp.BinaryFileOut(Response, fil, System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection"))
            fil.Delete()
            wrk.WorkOrderFileID = Nothing
            wrk.RPW = False
            wrk.Save(strChangeLog)
        End If
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div>Are you sure you wish to Delete/Remove the Signed Work Order?</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="No" />&nbsp;<asp:Button ID="btnYes" runat="server" Text="Yes" OnClick="btnYes_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>