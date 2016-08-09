<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Add Ticket"
      Master.PageTitleText = "Add Ticket"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; Add Ticket"
    End If
    lblReturnUrl.Text = Request.QueryString("returnurl")
        If Not IsPostBack Then
                     
            LoadCustomers(Master.InfoID)
        End If
  End Sub
  
    Private Sub LoadCustomers(lngInfoID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
        ldr.LoadSingleLongParameterDropDownList("spListActiveCustomersByInfoID", "@InfoID", Master.InfoID, "Company", "CustomerID", drpCustomers)
        
    End Sub
  
  Private Sub btnNext_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect("addticket.aspx?id=" & drpCustomers.SelectedValue & "&infoID=" & Master.InfoID & "&mode=customer&returnurl=tickets.aspx", True)
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="label">Choose Customer</div>
    <asp:DropDownList ID="drpCustomers" runat="server" />
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnNext" OnClick="btnNext_Click" runat="server" Text="Next" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>