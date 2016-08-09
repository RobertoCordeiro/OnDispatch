<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "User Control"
      Master.PageTitleText = "User Control"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; User Control"
      LoadUsers()
    End If
  End Sub
  
  Private Sub LoadUsers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListAllUsers", dgvUsers)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmUsers" runat="server">
    <asp:DataGrid AutoGenerateColumns="false" style="width: 100%" ID="dgvUsers" runat="server">
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:BoundColumn HeaderText="ID" Visible="false" DataField="UserID" />
        <asp:TemplateColumn HeaderText="User Name">
          <ItemTemplate>
            <a href="user.aspx?id=<%# DataBinder.Eval(Container.DataItem,"UserID") %>&returnurl=users.aspx"><%# DataBinder.Eval(Container.DataItem,"UserName") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:templatecolumn HeaderText="Name">
          <ItemTemplate>
            <a href="mailto:<%# DataBinder.Eval(Container.DataItem,"Email") %>"><%# DataBinder.Eval(Container.DataItem,"Title") %> <%# DataBinder.Eval(Container.DataItem,"FirstName") %> <%# DataBinder.Eval(Container.DataItem,"MiddleName") %> <%# DataBinder.Eval(Container.DataItem,"LastName") %> <%# DataBinder.Eval(Container.DataItem,"Suffix") %></a>
          </ItemTemplate>
        </asp:templatecolumn>
        <asp:BoundColumn HeaderText="Extension" DataField="Extension" />
        <asp:BoundColumn HeaderText="Active" DataField="Active" />
        <asp:BoundColumn HeaderText="Emp. Start" DataField="EmploymentStart" />
        <asp:BoundColumn HeaderText="Emp. End" DataField="EmploymentEnd" />
        <asp:BoundColumn HeaderText="Date Created" DataField="DateCreated" />
      </Columns>
    </asp:DataGrid>
    <div style="text-align: right;"><a href="adduser.aspx?returnurl=users.aspx">Add User</a></div>
  </form>
</asp:Content>