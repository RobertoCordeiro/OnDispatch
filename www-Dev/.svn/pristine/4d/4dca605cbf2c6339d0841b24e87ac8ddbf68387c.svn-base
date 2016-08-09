<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " News Articles"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " News Articles"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; News Articles"
    End If
    LoadArticles()
  End Sub
  
  Private Sub LoadArticles()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()    
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListNewsArticles")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvArticles.DataSource = ds
    dgvArticles.DataBind()
    cnn.Close()
  End Sub

  Private Sub btnAddNewsArticle_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect("newsarticle.aspx?returnurl=newsarticles.aspx", True)
  End Sub
  
  Private Function TypeImage(ByVal lngDuration As Long) As String
    Dim strReturn As String = ""
    If lngDuration > 0 Then
      strReturn = "hourglass.png"
    Else
      strReturn = "infinite.png"
    End If
    Return strReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmNewsArticles" runat="server">
    <asp:DataGrid style="width: 100%" ID="dgvArticles" AutoGenerateColumns="false" runat="server">
       <HeaderStyle CssClass="gridheader" />
       <AlternatingItemStyle CssClass="altrow" />   
       <Columns>
         <asp:BoundColumn
           DataField="NewsArticleID"
           HeaderText="ID"
           visible="false"
           />
         <asp:TemplateColumn
           HeaderText="Article ID"
           >
           <ItemTemplate>
             <a href="newsarticle.aspx?id=<%# Databinder.eval(Container.DataItem, "newsarticleid") %>&returnurl=newsarticles.aspx"><%# Databinder.eval(Container.DataItem, "NewsArticleID") %></a>
           </ItemTemplate>
         </asp:TemplateColumn>
         <asp:TemplateColumn              
           HeaderText="Author"
           >
           <ItemTemplate>
             <a href="mailto:<%# Databinder.eval(Container.DataItem, "email") %>"><%# Databinder.eval(Container.DataItem, "FirstName") %>&nbsp;<%# Databinder.eval(Container.DataItem, "LastName") %></a>
           </ItemTemplate>
         </asp:TemplateColumn>                            
         <asp:BoundColumn
           DataField="ArticleSubject"
           headertext="Subject"
           />
         <asp:BoundColumn
           DataField="ExpiresAfter"
           headertext="Duration"
           />
         <asp:TemplateColumn              
           HeaderText="type"
           >
           <ItemTemplate>
             <img alt="Type" src="/graphics/<%# TypeImage(ctype(Databinder.eval(Container.DataItem, "expiresafter"),long)) %>" />                 
           </ItemTemplate>
         </asp:TemplateColumn>                            
         <asp:TemplateColumn              
           HeaderText="Partner"
           >
           <ItemTemplate>
             <img alt="Partner Viewable" src="/graphics/<%# Databinder.eval(Container.DataItem, "PartnerViewable") %>.png" />                 
           </ItemTemplate>
         </asp:TemplateColumn>                   
         <asp:TemplateColumn              
           HeaderText="Customer"
           >
           <ItemTemplate>
             <img alt="Customer Viewable" src="/graphics/<%# Databinder.eval(Container.DataItem, "CustomerViewable") %>.png" />                 
           </ItemTemplate>
         </asp:TemplateColumn>                   
         <asp:BoundColumn
           DataField="datecreated"
           HeaderText="Date Created"
           />
       </Columns>
    </asp:DataGrid>
    <div style="text-align: right;"><asp:Button ID="btnAddNewsArticle" OnClick="btnAddNewsArticle_Click" runat="server" Text="Add" /></div>
  </form>
</asp:Content>