<%@ Page Language="vb" masterpagefile="~/masters/partner.master" %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>
<script runat="server">
  Private _Act as String = "A"
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " View FAQ"
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " FAQs"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    Try
      _Act = Request.QueryString("act")
    Catch ex As Exception
      _Act = "A"
    End Try
    Master.ActiveMenu = _Act
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
    If faq.PublicFaq Then
      Master.PageTitleText = "FAQ: " & faq.Title
      LoadQuestions(lngFAQID)
    End If
  End Sub

  Private Sub LoadQuestions(ByVal lngFAQID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListFaqQuestions", "@FaqID", lngFAQID, dgvQuestions)
    ldr.LoadSingleLongParameterDataGrid("spListFaqQuestions", "@FaqID", lngFAQID, dgvAnswers)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmFaq" runat="server">

      <div class="bandheader">Questions</div>
      <asp:DataGrid ID="dgvQuestions" GridLines="none" AutoGenerateColumns="false" ShowHeader="false" style="width: 100%" runat="server">
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
        <asp:DataGrid ID="dgvAnswers" GridLines="horizontal" AutoGenerateColumns="false" ShowHeader="false" style="width: 100%" runat="server">
        <AlternatingItemStyle CssClass="altrow" /> 
        <Columns>
          <asp:TemplateColumn>
            <ItemTemplate>              
              <a style="font-weight: bold;" name="<%# databinder.eval(Container.DataItem,"FaqQuestionID") %>">Q:&nbsp;<%# databinder.eval(Container.DataItem,"Question") %></a><br />
              <div>&nbsp;</div>
              <span class="label">A:</span>&nbsp;<%#DataBinder.Eval(Container.DataItem, "Answer")%><br />
              <div>&nbsp;</div>            
            </ItemTemplate>
          </asp:TemplateColumn>
        </Columns>
      </asp:DataGrid>

    <asp:Label ID="lblReturnUrl" runat="server" />
  </form>
</asp:Content>