<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Edit Document"
      Master.PageTitleText = "Edit Document"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Document Editor"
    End If
    Try
      lblReturnUrl.Text = Request.QueryString("returnurl")
      lblDocumentID.Text = Request.QueryString("id")
      If IsNothing(lblDocumentID.Text) Then
        lblDocumentID.Text = "0"
      End If
      If lblDocumentID.Text.Trim.Length = 0 Then
        lblDocumentID.Text = "0"
      End If
    Catch ex As Exception
      lblDocumentID.Text = "0"
    End Try
    If Not IsPostBack Then      
      If CType(lblDocumentID.Text, Long) > 0 Then
        Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        doc.Load(CType(lblDocumentID.Text, Long))
        txtDocumentName.Text = doc.DocumentName
        txtDocumentText.Text = doc.DocumentText
        chkIsHtml.Checked = doc.IsHtml
      End If
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    If lblReturnUrl.Text.Trim.Length > 0 Then
      Response.Redirect(lblReturnUrl.Text)
    Else
      Response.Redirect("default.aspx")
    End If    
  End Sub
  
  Private Sub btnChange_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog As String = ""
    If CType(lblDocumentID.Text, Long) > 0 Then
      doc.Load(CType(lblDocumentID.Text, Long))
      doc.DocumentName = txtDocumentName.Text
      doc.DocumentText = txtDocumentText.Text
      doc.IsHtml = chkIsHtml.Checked
      doc.Save(strChangeLog)
    Else
      doc.Add(Master.UserID, txtDocumentName.Text, txtDocumentText.Text, chkIsHtml.Checked,Master.InfoID)
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
    divPreview.Visible = False
  End Sub
  
  Private Sub btnPreview_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Master.PageHeaderText = txtDocumentName.Text.Trim
      If chkIsHtml.Checked Then
        divHTMLDocument.InnerHtml = txtDocumentText.Text
        divHTMLPreview.Visible = True
        divForm.Visible = False
      Else
        txtPreviewDocument.Text = txtDocumentText.Text
        divPreview.Visible = True
        divForm.Visible = False
      End If
      divError.Visible = False
    Else
      divError.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtDocumentName.Text.Trim.Length = 0 Then
      strErrors &= "<li>Document Name is Required</li>"
      blnReturn = False
    End If
    If txtDocumentText.Text.Trim.Length = 0 Then
      strErrors &= "<li>Document Text is Required</li>"
      blnReturn = False
    End If
    divError.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangeSignature" runat="server">
    <table style="width: 600px;">
      <tbody>
        <tr>
          <td>
            <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <div class="errorzone" id="divError" runat="server" visible="false" />      
              <div><asp:checkbox ID="chkIsHtml" Text="Is HTML" runat="server" /></div>
              <div class="label">Document Name</div>
              <asp:TextBox style="width: 99%" ID="txtDocumentName" MaxLength="255" runat="server" />
              <div class="label">Document Text</div>
              <asp:TextBox ID="txtDocumentText" TextMode="MultiLine" runat="server" style="width: 99%; height: 400px;" />
              <div style="text-align: right"><asp:Button ID="btnCancel" OnClick="btnCancel_Click" Text="Cancel" runat="Server" />&nbsp;<asp:Button ID="btnPreview" OnClick="btnPreview_Click" runat="server" Text="Preview" /></div>     
            </div>
            <div visible="false" id="divHTMLPreview" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <div id="divHTMLDocument" runat="server" />
              <div style="text-align: right"><asp:Button ID="btnBack" OnClick="btnBack_Click" runat="server" Text="Back" />&nbsp;<asp:Button ID="btnSave" OnClick="btnChange_Click" runat="server" Text="Save" /></div>
            </div>
            <div visible="false" id="divPreview" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <asp:TextBox ID="txtPreviewDocument" ReadOnly="true" TextMode="MultiLine" runat="server" style="width: 99%; height: 400px;" />
              <div style="text-align: right"><asp:Button ID="btnPreviewBack" OnClick="btnBack_Click" runat="server" Text="Back" />&nbsp;<asp:Button ID="btnPreviewSave" OnClick="btnChange_Click" runat="server" Text="Save" /></div>
            </div>
            <div id="divResult" visible="false" runat="server">
              <div>&nbsp;</div>
              <div class="successtext">Success! Your password has been changed.</div>
            </div>
            <asp:label ID="lblDocumentID" runat="server" Visible="False" />
            <asp:label id="lblReturnUrl" runat="server" visible="False" />
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</asp:Content>