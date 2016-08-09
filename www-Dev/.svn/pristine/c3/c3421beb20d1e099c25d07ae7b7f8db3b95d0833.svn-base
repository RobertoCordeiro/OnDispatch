<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Shipping Addresses With No Agents"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Shipping Addreses With No Agents"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""reports.aspx"">Reports</a> &gt; Shipping Addresses With No Agents"
    End If
    LoadAddresses()
  End Sub
  
  Private Sub LoadAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListShippingAddressesWithNoAgents", dgvAddresses)
  End Sub
    
  Private Sub dgvAddresses_Paged(ByVal S As Object, ByVal E As DataGridPageChangedEventArgs)
    dgvAddresses.CurrentPageIndex = E.NewPageIndex
    LoadAddresses()
  End Sub

  Private Function MapIt(ByVal strAddress As String, ByVal strZipCode As String) As String
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
    strReturn = ggl.MapAddress(strAddress, strZipCode)
    Return strReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmZips" runat="server">
    <asp:DataGrid ID="dgvAddresses" style="width: 100%" runat="server" PagerStyle-Mode="NumericPages" OnPageIndexChanged="dgvAddresses_Paged" AllowPaging="true" PageSize="25"  AutoGenerateColumns="false">
      <HeaderStyle CssClass="gridheader" />
      <AlternatingItemStyle CssClass="altrow" />
      <Columns>
        <asp:TemplateColumn HeaderText="Partner ID">
          <ItemTemplate>
            <a href="partner.aspx?id=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>"><%# DataBinder.Eval(Container.DataItem,"ResumeID") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn
          HeaderText="Address"
          >
          <ItemTemplate>
            <a target="_blank" href="<%# MapIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%></a>
          </ItemTemplate>
        </asp:TemplateColumn>                  
        <asp:BoundColumn
          DataField="City"
          HeaderText="City"
          />
        <asp:BoundColumn
          DataField="Abbreviation"
          HeaderText="State"
          />
        <asp:TemplateColumn
          HeaderText="Zip"
          >
          <ItemTemplate>
            <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn 
          HeaderText="Active"
          >             
          <ItemTemplate>
            <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
          </ItemTemplate>
        </asp:TemplateColumn>                              
        <asp:TemplateColumn
          HeaderText="Command"
          >
          <Itemtemplate>
            <a href="editaddress.aspx?mode=partner&returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerAddressID") %>">Edit</a>&nbsp;<a href="buildterritory.aspx?returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerAddressID") %>">Radius</a>
          </Itemtemplate>
        </asp:TemplateColumn>                                                    
      </Columns>      
    </asp:DataGrid>    
  </form>
</asp:Content>