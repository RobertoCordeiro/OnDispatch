<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master"  ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "News Article"
      Master.PageTitleText = "News Article"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; News Article Editor"
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
        LoadArticle(CType(lblID.Text, Long))     
      End If
            txtDuration.Text = "30"
            LoadCountries()
            
            
        End If
  End Sub
  
  Private Sub LoadArticle(ByVal lngNewsArticleID As Long)
    Dim nwa As New BridgesInterface.NewsArticleRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    nwa.Load(lngNewsArticleID)
    txtArticleSubject.Text = nwa.ArticleSubject
    txtArticleText.Text = nwa.ArticleText
    chkPartnerViewable.Checked = nwa.PartnerViewable
        chkCustomerViewable.Checked = nwa.CustomerViewable
        drpCountry.SelectedValue = nwa.CountryID
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    If lblReturnUrl.Text.Trim.Length > 0 Then
      Response.Redirect(lblReturnUrl.Text)
    Else
      Response.Redirect("default.aspx")
    End If    
  End Sub
  
  Private Sub btnChange_Click(ByVal S As Object, ByVal E As EventArgs)    
    Dim strChangeLog As String = ""
    Dim nwa As New BridgesInterface.NewsArticleRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    If CType(lblID.Text, Long) > 0 Then
      nwa.Load(CType(lblID.Text, Long))
      nwa.ArticleText = txtArticleText.Text
      nwa.ArticleSubject = txtArticleSubject.Text
      nwa.CustomerViewable = chkCustomerViewable.Checked
            nwa.PartnerViewable = chkPartnerViewable.Checked
            nwa.CountryID = drpCountry.SelectedValue
      nwa.Save(strChangeLog)
    Else
            nwa.Add(Master.UserID, txtArticleSubject.Text, txtArticleText.Text, CType(txtDuration.Text, Long), chkCustomerViewable.Checked, chkPartnerViewable.Checked, CType(drpCountry.SelectedValue, Long), Master.InfoID)
    End If
    If lblReturnUrl.Text.Trim.Length > 0 Then
      Response.Redirect(lblReturnUrl.Text)
    Else
      Response.Redirect("default.aspx")
    End If
  End Sub
  
  Private Sub btnBack_Click(ByVal S As Object, ByVal E As EventArgs)
    divForm.Visible = True
    divHTMLPreview.Visible = False
  End Sub
  
  Private Sub btnPreview_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Master.PageHeaderText = txtArticleSubject.Text.Trim
      divHTMLDocument.InnerHtml = txtArticleText.Text
      divHTMLPreview.Visible = True
      divForm.Visible = False
      divError.Visible = False
    Else
    divError.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim lng As Long = 0
    If txtArticleSubject.Text.Trim.Length = 0 Then
      strErrors &= "<li>Article Subject is Required</li>"
      blnReturn = False
    End If
    If txtarticletext.Text.Trim.Length = 0 Then
      strErrors &= "<li>Article Text is Required</li>"
      blnReturn = False
    End If
    If txtDuration.Text.Trim.Length = 0 Then
      strErrors &= "<li>Duration Is Required</li>"
      blnReturn = False
    Else
      If Not Long.TryParse(txtDuration.Text, lng) Then
        strErrors &= "<li>Duration Must Be A Whole Number</li>"
        blnReturn = False
      End If
    End If
    divError.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
    Private Sub LoadCountries()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListCountries", "CountryName", "CountryID", drpCountry)
        drpCountry.Items.Add("Choose One")
        drpCountry.SelectedValue = "Choose One"
        
        
    End Sub
    
    
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangeSignature" runat="server">
    <table style="width: 600px;">
      <tbody>
        <tr>
          <td>
            <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <div class="errorzone" id="divError" runat="server" visible="false" />
              <div class="label">Choose Country </div>
              <asp:DropDownList ID="drpCountry" runat="server"  />     
              <div class="label">Article Subject</div>
              <asp:TextBox style="width: 99%" ID="txtArticleSubject" MaxLength="255" runat="server" />
              <div class="label">Article Text (HTML)</div>
              <asp:TextBox ID="txtArticleText" TextMode="MultiLine" runat="server" style="width: 99%; height: 400px;" />
              <div><asp:CheckBox id="chkPartnerViewable" Text="Partner Viewable" runat="server" /><asp:CheckBox id="chkCustomerViewable" Text="Customer Viewable" runat="server" /></div>
              <div>Expires after <asp:TextBox ID="txtDuration" runat="server" /> days (Enter 0 (Zero) for never expires)</div>
              <div style="text-align: right"><asp:Button ID="btnCancel" OnClick="btnCancel_Click" Text="Cancel" runat="Server" />&nbsp;<asp:Button ID="btnPreview" OnClick="btnPreview_Click" runat="server" Text="Preview" /></div>     
            </div>
            <div visible="false" id="divHTMLPreview" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <div id="divHTMLDocument" runat="server" />
              <div style="text-align: right"><asp:Button ID="btnBack" OnClick="btnBack_Click" runat="server" Text="Back" />&nbsp;<asp:Button ID="btnSave" OnClick="btnChange_Click" runat="server" Text="Save" /></div>
            </div>
            <div id="divResult" visible="false" runat="server">
              <div>&nbsp;</div>
              <div class="successtext">Success! Your password has been changed.</div>
            </div>
            <asp:label ID="lblID" runat="server" Visible="False" />
            <asp:label id="lblReturnUrl" runat="server" visible="False" />
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</asp:Content>