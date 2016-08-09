<%@ Page Language="vb" masterpagefile="~/masters/agent.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">  
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Territory"
      Master.PageTitleText = " Territory"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
        'lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadDistances()
        LoadTerritory()
      End If
    Else
            'Response.Redirect(lblReturnUrl.Text, True)
            LoadDistances()
            LoadTerritory()
    End If
  End Sub
  
  Private Sub LoadTerritory()
    Dim add As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    add.Load(_ID)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spFindZipCodesWithinRadius", "@Radius", cbxDistances.SelectedValue, "@ZipCode", add.ZipCode, dgvZips)
  End Sub
  
  Private Sub LoadDistances()
    Dim itm As New ListItem  
    itm.Text = "50 Miles"
    itm.Value = 50
    cbxDistances.Items.Add(itm)
    itm = New ListItem
    itm.Text = "25 Miles"
    itm.Value = 25
    cbxDistances.Items.Add(itm)
  End Sub
  
  Private Sub btnRebuild_Click(ByVal S As Object, ByVal E As EventArgs)
    LoadTerritory()
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="label">Radius (In Miles)</div>
    <asp:DropDownList ID="cbxDistances" runat="server" />
    <asp:DataGrid ID="dgvZips" runat="server" AutoGenerateColumns="false" style="width: 600px;">
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:TemplateColumn>
          <ItemTemplate>
            <a href="findzipcode.aspx?zip=<%# DataBinder.Eval(Container.DataItem,"ZipCode") %>"><%# DataBinder.Eval(Container.DataItem,"ZipCode") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn DataField="City" HeaderText="City" />
        <asp:BoundColumn DataField="Abbreviation" HeaderText="State" />
        <asp:BoundColumn DataField="CountyName" HeaderText="County" />
        <asp:BoundColumn DataField="DistanceInMiles" HeaderText="Distance*" ItemStyle-HorizontalAlign="right" />
        <asp:BoundColumn DataField="Population" HeaderText="Population" ItemStyle-HorizontalAlign="right" />
      </Columns>
    </asp:DataGrid>
    <div style="text-align: right;">* Distance is miles from central zip code of the address.</div>
    <div style="text-align: right"><asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" />&nbsp;<asp:Button ID="btnRebuild" runat="server" Text="Rebuild" OnClick="btnRebuild_Click" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>