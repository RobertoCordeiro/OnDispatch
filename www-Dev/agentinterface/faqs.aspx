<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " FAQ Control"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " FAQ Control"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; FAQ Control"
    End If
    LoadFaqs()
  End Sub
  
  Private Sub LoadFaqs()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListFaqs")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvFaqs.DataSource = ds
    dgvFaqs.DataBind()
    cnn.Close()
  End Sub

  Private Sub btnAddFaq_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect("addfaq.aspx?returnurl=faqs.aspx", True)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmFAQS" runat="server">
    <asp:DataGrid style="width: 100%" ID="dgvFaqs" AutoGenerateColumns="false" runat="server">
       <HeaderStyle CssClass="gridheader" />
       <AlternatingItemStyle CssClass="altrow" />   
      <Columns>
        <asp:TemplateColumn
          HeaderText="Faq ID"
          >
          <ItemTemplate>
            <a href="editfaq.aspx?id=<%# Databinder.eval(container.dataitem,"FaqID") %>&returnul=faqs.aspx"><%# Databinder.eval(container.dataitem,"FaqID") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn
          HeaderText="Title"
          DataField="Title"
          />
        <asp:BoundColumn
          HeaderText="Size"
          DataField="QuestionCount"
          />
        <asp:TemplateColumn HeaderText="Author">
          <ItemTemplate>
            <a href="mailto:<%# Databinder.eval(container.dataitem,"email") %>"><%# Databinder.eval(container.dataitem,"FirstName") %>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Public">
          <ItemTemplate>
            <img alt="public" src="/graphics/<%# Databinder.eval(Container.DataItem, "PublicFaq") %>.png" />                 
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn
          HeaderText="Date Created"
          DataField="DateCreated"
          />
      </Columns>
    </asp:DataGrid>
    <div style="text-align: right;"><asp:Button OnClick="btnAddFAQ_Click" ID="btnAddFaq" runat="server" Text="Add FAQ" /></div>
  </form>
</asp:Content>