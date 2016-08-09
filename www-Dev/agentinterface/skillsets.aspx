<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Skill Sets"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Skill Sets"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Skill Sets"
    End If
  End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmSkillSets" runat="server">
    <asp:DataGrid ID="dgvSkillSets" runat="server" AutoGenerateColumns="false">
      <Columns>
        <asp:BoundColumn
          DataField="SkillSetID"
          HeaderText="ID"
          Visible="False"
          />
        <asp:BoundColumn
          ItemStyle-VerticalAlign="top"
          DataField="SkillSetName"
          HeaderText="Name"
          />
        <asp:TemplateColumn 
          ItemStyle-Wrap="true"
          HeaderText="Description"
          >
          <Itemtemplate>
            <%#DataBinder.Eval(Container.DataItem, "Description").ToString.Replace(Environment.NewLine, "<br />")%>
          </Itemtemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
  </form>
</asp:Content>