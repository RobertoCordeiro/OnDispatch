<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " View FAQ"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " View FAQ"
      Master.PageSubHeader = ""
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then      
      LoadFaq(_ID)
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadFaq(ByVal lngFAQID As Long)
    Dim faq As New BridgesInterface.FaqRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    faq.Load(lngFAQID)
    Master.PageHeaderText = "FAQ: " & faq.Title
    Master.PageTitleText = Master.PageHeaderText
    LoadQuestions(lngFAQID)
  End Sub

  Private Sub LoadQuestions(ByVal lngFAQID As Long)
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListFaqQuestions")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Parameters.Add("@FaqID", Data.SqlDbType.Int).Value = lngFAQID
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvQuestions.DataSource = ds
    dgvQuestions.DataBind()
    dgvAnswers.DataSource = ds
    dgvAnswers.DataBind()
    cnn.Close()
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmFaq" runat="server">
    <div class="bandheader">Questions</div>
    <asp:DataGrid ID="dgvQuestions" ItemStyle-BorderStyle="None" AlternatingItemStyle-BorderStyle="none" GridLines="none" AutoGenerateColumns="false" ShowHeader="false"  BorderStyle="None" style="width: 100%" runat="server">
      <AlternatingItemStyle CssClass="altrow" /> 
      <Columns>
        <asp:TemplateColumn>
          <ItemTemplate>
            <a href="#<%# databinder.eval(Container.DataItem,"FaqQuestionID") %>"><%# databinder.eval(Container.DataItem,"Question") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
    <div class="bandheader">Answers</div>
      <asp:DataGrid ID="dgvAnswers" GridLines="horizontal" AutoGenerateColumns="false" ShowHeader="false" BorderStyle="None" style="width: 100%" runat="server">
      <AlternatingItemStyle CssClass="altrow" /> 
      <Columns>
        <asp:TemplateColumn>
          <ItemTemplate>
            <a name="<%# databinder.eval(Container.DataItem,"FaqQuestionID") %>" />
            <div class="label">Q:&nbsp;<%# databinder.eval(Container.DataItem,"Question") %></div>
            <div>&nbsp;</div>
            <div><span class="label">A:&nbsp;</span><%#DataBinder.Eval(Container.DataItem, "Answer")%></div>
            <div>&nbsp;</div>            
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
    <asp:Label ID="lblReturnUrl" runat="server" />
  </form>
</asp:Content>