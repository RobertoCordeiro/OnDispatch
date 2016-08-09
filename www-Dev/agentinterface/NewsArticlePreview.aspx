<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master"  ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "News Article"
      Master.PageTitleText = "News Article"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; News Article Preview"
    End If
    Try
      lblReturnUrl.Text = Request.QueryString("returnurl")
      lblID.Text = Request.QueryString("id")
      If IsNothing(lblID.Text) Then
        lblID.Text = "0"
      End If
      If lblID.Text.Trim.Length = 0 Then
        lblID.Text = "0"
      End If
    Catch ex As Exception
      lblID.Text = "0"
    End Try
    If Not IsPostBack Then      
            If CType(lblID.Text, Long) > 0 Then
                Dim nwa As New BridgesInterface.NewsArticleRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                nwa.Load(CType(lblID.Text, Long))
                Master.PageHeaderText = nwa.ArticleSubject
                divHTMLDocument.InnerHtml = nwa.ArticleText
                
            End If
        End If
  End Sub
 
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangeSignature" runat="server">
    <table style="width: 600px;">
      <tbody>
        <tr>
          <td>
             <div id="divHTMLPreview" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <div id="divHTMLDocument" runat="server" />

            </div>
 
            <asp:label ID="lblID" runat="server" Visible="False" />
            <asp:label id="lblReturnUrl" runat="server" visible="False" />
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</asp:Content>
