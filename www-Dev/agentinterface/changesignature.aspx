<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" ValidateRequest="false" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Change Signature"
      Master.PageTitleText = "Change Signature"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Change Signature"
    End If
    
    If Not IsPostBack Then      
      Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      usr.Load(CType(Master.UserID, Long))
      txtSignature.Text = usr.Signature
    End If
  End Sub
  
  Private Sub btnChange_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    usr.Load(CType(Master.UserID, Long))
    usr.Signature = txtSignature.Text
    usr.Save(strChangeLog)
    Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strIp As String = Request.QueryString("REMOTE_ADDR")
    Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
    If IsNothing(strIp) Then
      strIp = "unknown"
    End If
    If IsNothing(strType) Then
      strType = "web"
    End If
    act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, 1, usr.UserID, strChangeLog)
    Response.Redirect("settings.aspx")
  End Sub

  Private Sub btnBack_Click(ByVal S As Object, ByVal E As EventArgs)
    divForm.Visible = True
    divPreview.Visible = False
  End Sub
  
  Private Sub btnPreview_Click(ByVal S As Object, ByVal E As EventArgs)
    divSignature.InnerHtml = txtSignature.Text
    divPreview.Visible = True
    divForm.Visible = False
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangeSignature" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
      <div class="errorzone" id="divError" runat="server" visible="false" />
      <div class="label">Signature Source</div>
      <asp:TextBox ID="txtSignature" TextMode="MultiLine" runat="server" style="width: 99%; height: 200px;" />
      <div style="text-align: right"><asp:Button ID="btnPreview" OnClick="btnPreview_Click" runat="server" Text="Preview" /></div>     
    </div>
    <div visible="false" id="divPreview" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
      <div id="divSignature" runat="server" />
      <div style="text-align: right"><asp:Button ID="btnBack" OnClick="btnBack_Click" runat="server" Text="Back" />&nbsp;<asp:Button ID="btnChange" OnClick="btnChange_Click" runat="server" Text="Update" /></div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>&nbsp;</div>
      <div class="successtext">Success! Your password has been changed.</div>
    </div>
  </form>
</asp:Content>