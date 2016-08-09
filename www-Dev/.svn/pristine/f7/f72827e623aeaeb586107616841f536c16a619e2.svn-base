<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Service SKU Detail"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Service SKU Detail"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Tickets</a> &gt; Service SKU Detail"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    LoadDetail()
  End Sub
  
  Private Sub LoadDetail()    
    Dim srv As New BridgesInterface.ServiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    srv.Load(_ID)
    Dim svt As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    svt.Load(srv.ServiceTypeID)
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cst.Load(svt.CustomerID)
    If cst.Company.Trim.Length > 0 Then
      lblCustomer.Text = cst.Company
    Else
      If cst.FirstName.Trim.Length > 0 Then
        lblCustomer.Text = cst.FirstName & " "
      End If
      If cst.LastName.Trim.Length > 0 Then
        lblCustomer.Text = cst.LastName
      End If
    End If
    lblServiceType.Text = svt.ServiceType
    txtServiceTypeNotes.Text = svt.Notes
    lblService.Text = srv.ServiceName
    txtDescription.Text = srv.Description
    txtInstructions.Text = srv.Instructions
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmServiceDetail" runat="server">
    <div style="width: 640px; margin-left: auto; margin-right: auto;" class="inputform">
      <div class="inputformsectionheader">Service SKU Detail</div>
      <table style="width: 100%">
        <tbody>
          <tr>
            <td class="label">Customer</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblCustomer" runat="server" /></td>
          </tr>
          <tr>
            <td class="label">Program</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblServiceType" runat="server" /></td>
          </tr>
          <tr>
            <td class="label">Program Notes</td>
            <td>&nbsp;</td>
            <td style="padding-right: 4px;"><asp:TextBox runat="server" ID="txtServiceTypeNotes" style="width: 100%" ReadOnly="true" TextMode="multiLine" Height="75px" /></td>
          </tr>
          <tr>
            <td class="label">Service SKU</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblService" runat="server" /></td>
          </tr>          
          <tr>
            <td class="label">Description</td>
            <td>&nbsp;</td>
            <td style="padding-right: 4px;"><asp:TextBox runat="server" ID="txtDescription" style="width: 100%" ReadOnly="true" TextMode="multiLine" Height="75px" /></td>
          </tr>
          <tr>
            <td class="label">Instructions</td>
            <td>&nbsp;</td>
            <td style="padding-right: 4px;"><asp:TextBox runat="server" ID="txtInstructions" style="width: 100%" ReadOnly="true" TextMode="multiLine" Height="150px" /></td>
          </tr>
        </tbody>
      </table>      
    </div>
  </form>
</asp:Content>