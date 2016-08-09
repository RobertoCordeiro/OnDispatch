<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
    Private _Mode As String = ""
    Private _infoID As Long = 0
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Customer Management"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Customer Management"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Customer Management"
        End If
        Try
            _Mode = Request.QueryString("mode")
            If _Mode.Trim.Length = 0 Then
                _Mode = "active"
            End If
        Catch ex As Exception
            _Mode = "active"
        End Try
        
        divActiveBar.Attributes("class") = "bandbar"
        divInactiveBar.Attributes("class") = "bandbar"
        
       
        Select Case _Mode
            Case "active"
                divActiveBar.Attributes("class") = "selectedbandbar"
                LoadActiveCustomersByInfoID(Master.InfoID)
            Case "inactive"
                divInactiveBar.Attributes("class") = "selectedbandbar"
                LoadInactiveCustomersByInfoID(Master.InfoID)
            
        End Select

    End Sub
  
    Private Sub LoadActiveCustomersByInfoID(lngInfoID As Long)
        Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        inf.Load(Master.InfoID)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadTwoLongParameterDataGrid("spListActiveCustomersByInfoIDAndCustomerID", "@InfoID", lngInfoID, "@CustomerID", inf.CustomerID, dgvCustomers)
        
    End Sub
    Private Sub LoadInactiveCustomersByInfoID(lngInfoID As Long)
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListInactiveCustomersByInfoID", "@InfoID", lngInfoID, dgvCustomers)
    End Sub
  
</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmCustomerList" runat="server">
   <table width ="100%">
       <tr>
           <td style="width: 10%" class="band">
               <div class="bandheader">Lists</div>            
               <div id="divActiveBar" runat="server"><a href="customers.aspx?mode=active">Active</a></div>
               <div id="divInactiveBar" runat="server"><a href="customers.aspx?mode=inactive">Inactive</a></div>
               <div class="bandheader">Command</div>
               <a href="addcustomer.aspx">Add Customer</a>
               <div>&nbsp;</div>
               <a href="CreateLayer.aspx?returnurl=customers.aspx">Add/Edit Layer</a>
               <div>&nbsp;</div>
           </td>
           <td>
               <div>
               <asp:DataGrid style="width: 100%" ID="dgvCustomers" AutoGenerateColumns="false" runat="server" Cssclass="Grid1">
                  <HeaderStyle cssclass="gridheader" />
                  <AlternatingItemStyle cssclass="altrow" />  
                  <Columns>
                    <asp:BoundColumn HeaderText="ID" DataField="CustomerID" visible="false" />
                    <asp:TemplateColumn>
                      <Itemtemplate>
                        <a href="customer.aspx?id=<%# DataBinder.Eval(Container.DataItem,"CustomerID") %>&returnurl=customers.aspx">Open</a>
                      </Itemtemplate>
                    </asp:TemplateColumn>
                    <asp:BoundColumn
                      HeaderText="Company Name"
                      DataField="Company"
                      />
                    <asp:TemplateColumn
                      HeaderText="Name"
                      >
                      <ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem,"Title") %> <%# DataBinder.Eval(Container.DataItem,"FirstName") %> <%# DataBinder.Eval(Container.DataItem,"LastName") %> <%# DataBinder.Eval(Container.DataItem,"Suffix") %>
                      </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn
                      HeaderText="Email"
                      >
                      <Itemtemplate>
                        <a href="mailto:<%# DataBinder.Eval(Container.DataItem,"email") %>"><%# DataBinder.Eval(Container.DataItem,"Email") %></a>
                      </Itemtemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn
                      HeaderText="Web Site"
                      >
                      <Itemtemplate>
                        <a target="_blank" href="<%# DataBinder.Eval(Container.DataItem,"WebSite") %>"><%# DataBinder.Eval(Container.DataItem,"WebSite") %></a>
                      </Itemtemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn 
                      HeaderText="Tax Exempt"
                      SortExpression="TaxExempt">             
                      <ItemTemplate>
                        <img alt="Contact Friday" src="/graphics/<%# Databinder.eval(Container.DataItem, "TaxExempt") %>.png" />                 
                      </ItemTemplate>
                    </asp:TemplateColumn> 
                    <asp:TemplateColumn 
                      HeaderText="Active"
                      SortExpression="Active">             
                      <ItemTemplate>
                        <img alt="Contact Friday" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                      </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:BoundColumn
                      HeaderText="Date Created"
                      DataField="DateCreated"
                      />
                  </Columns>
                </asp:DataGrid></div>

           </td>
           </tr>
   </table>
  </form>
</asp:Content>