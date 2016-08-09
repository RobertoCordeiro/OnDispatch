<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Manufacturer Model Control"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Manufacturer Model Control"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Manufacturer Model Control"
    End If
    LoadManufacturers()
    LoadProductTypes()    
  End Sub
  
  Private Sub LoadManufacturers()
    Dim com As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    com.LoadSimpleDataGrid("spListManufacturers", dgvManufacturers)    
  End Sub
  
  Private Sub LoadProductTypes()
    Dim com As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    com.LoadSimpleDataGrid("spListProductTypes", dgvProductTypes)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
   <form id="frmMake" runat="server">
     <div class="bandheader">Manufacturers</div>
     <asp:DataGrid style="width: 100%" ID="dgvManufacturers" runat="server" AutoGenerateColumns="false">
      <HeaderStyle cssclass="gridheader" />
      <AlternatingItemStyle cssclass="altrow" />       
       <Columns>
         <asp:BoundColumn
           HeaderText="ID"
           DataField="ManufacturerID"
           visible="False"
           />
         <asp:TemplateColumn>
           <Itemtemplate>
             <a href="editmanufacturer.aspx?id=<%# Databinder.eval(Container.DataItem,"ManufacturerID") %>&returnurl=makers.aspx">Edit</a>&nbsp;<a href="models.aspx?id=<%# Databinder.eval(Container.DataItem,"ManufacturerID") %>&returnurl=makers.aspx">Open</a>             
           </Itemtemplate>           
         </asp:TemplateColumn>
         <asp:BoundColumn
           HeaderText="Manufacturer"
           DataField="Manufacturer"
           />
         <asp:BoundColumn
           HeaderText="Models"
           DataField="ModelCount"
           />
         <asp:TemplateColumn HeaderText="Author">
           <ItemTemplate>
             <a href="mailto:<%# DataBinder.Eval(Container.DataItem,"Email") %>"><%# DataBinder.Eval(Container.DataItem,"Author") %></a>
           </ItemTemplate>
         </asp:TemplateColumn>
         <asp:BoundColumn
           HeaderText="Date Created"
           DataField="DateCreated"
           />                      
       </Columns>
     </asp:DataGrid>
     <div style="text-align: right"><a href="addmanufacturer.aspx?returnurl=makers.aspx">Add Manufacturer</a></div>
     <div class="bandheader">Product Types</div>
     <asp:DataGrid style="width: 100%" ID="dgvProductTypes" runat="server" AutoGenerateColumns="false">
      <HeaderStyle cssclass="gridheader" />
      <AlternatingItemStyle cssclass="altrow" />       
       <Columns>
         <asp:BoundColumn
           HeaderText="ID"
           DataField="ProductTypeID"
           visible="False"
           />
         <asp:TemplateColumn>
           <Itemtemplate>
             <a href="editproducttype.aspx?id=<%# Databinder.eval(Container.DataItem,"ProductTypeID") %>&returnurl=makers.aspx">Edit</a>
           </Itemtemplate>           
         </asp:TemplateColumn>
         <asp:BoundColumn
           HeaderText="Product Type"
           DataField="ProductType"
           />
         <asp:TemplateColumn HeaderText="Author">
           <ItemTemplate>
             <a href="mailto:<%# DataBinder.Eval(Container.DataItem,"Email") %>"><%# DataBinder.Eval(Container.DataItem,"Author") %></a>
           </ItemTemplate>
         </asp:TemplateColumn>
         <asp:BoundColumn
           HeaderText="Date Created"
           DataField="DateCreated"
           />                      
       </Columns>       
     </asp:DataGrid>     
     <div style="text-align: right"><a href="addproducttype.aspx?returnurl=makers.aspx">Add Product Type</a></div>
   </form>
</asp:Content>