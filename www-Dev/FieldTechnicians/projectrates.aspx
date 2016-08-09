<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Closed Tickets List"
      Master.PageTitleText = " Closed Tickets List"
      Master.ActiveMenu = "Q"
    End If
    LoadReferenceRates()
  End Sub
  
  Private Sub LoadReferenceRates()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerServiceRates", "@PartnerID", Master.PartnerID, dgvRates)
  End Sub
  
  Private Sub btnEditRate_Click(ByVal S As Object, ByVal E As System.Web.UI.WebControls.DataGridCommandEventArgs)
    
  End Sub
    
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmWorkOrders" runat="server">
   <div id="tabs5">
      <ul>
        <li><a href="regularrates.aspx"><span>Regular Rates</span></a></li>
        <li id="current"><a href="projectrates.aspx"><span>Contract Rates</span></a></li>
      </ul>
   <div>&nbsp;</div>
    <div id="ratesheader" class="tabbody">
    <div>&nbsp;</div>
    <div>** These are Pre-Determined Flat Rates based on Contracts with BSA Customers ** </div>
    <div>&nbsp;</div>
    </div>
    <div id="divRates" class="inputformsectionheader" runat="server"></div>
            <asp:DataGrid  ID="dgvRates" style="width: 100%" OnItemCommand="btnEditRate_Click" runat="server" AutoGenerateColumns="false">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn
                  DataField="PartnerServiceRateID"
                  HeaderText="ID"
                  visible="False"
                />
                <asp:BoundColumn
                  DataField="Customer"
                  HeaderText="Customer"
                  ItemStyle-Wrap="false"
                  />
                  <asp:BoundColumn
                  DataField="Program"
                  HeaderText="Program"
                  ItemStyle-Wrap="false"
                  />
                  <asp:BoundColumn
                  DataField="ServiceName"
                  HeaderText="Service Name"
                  ItemStyle-Wrap="false"
                  />
                <asp:BoundColumn
                  DataField="FlatRate"
                  HeaderText="Repair Rate"
                  DataFormatString="{0:C}"
                  />
              </Columns>                
            </asp:DataGrid>            
    </div>
  </form>
</asp:Content>