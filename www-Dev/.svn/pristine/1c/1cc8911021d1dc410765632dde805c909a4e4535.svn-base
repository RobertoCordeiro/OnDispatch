<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server">
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageTitleText = "Edit Rate"
      Master.PageHeaderText = "Edit Rate"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try    
    If _ID > 0 Then
      Dim rrt As New BridgesInterface.ResumeRateRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      rrt.Load(_ID)
      lblReturnUrl.Text = "regularrates.aspx?id=9&returnurl=settings.aspx"
            If Not IsPostBack Then
        LoadResumeRate()
      End If
    Else
      divForm.Visible = False
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadResumeRate()
    Dim rrt As New BridgesInterface.ResumeRateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim rtt As New BridgesInterface.RateTypeRecord(rrt.ConnectionString)
    rrt.Load(_ID)
    rtt.Load(rrt.RateTypeID)
    lblRateType.Text = rtt.Description
    txtRate.Text = rrt.Rate.ToString
  End Sub
  
  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      SaveResumeRate()
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divError.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text, True)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dbl As Double = 0
    If Not Double.TryParse(txtRate.Text, dbl) Then
      strErrors = "<li>Rate must be Numeric</li>"
    End If
    strErrors = "<ul>" & strErrors & "</ul>"
    divError.InnerHtml = strErrors
    Return blnReturn
  End Function
      
  Private Sub SaveResumeRate()
    Dim rrt As New BridgesInterface.ResumeRateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim act As New BridgesInterface.ActionRecord(rrt.ConnectionString)
    Dim strChangeLog As String = ""
    rrt.Load(_ID)
    rrt.Rate = CType(txtRate.Text, Double)
    rrt.Save(strChangeLog)
    act.Add(Master.UserID, "web", "web", "web", "web", 25, rrt.ResumeRateID, strChangeLog)
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangePass" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
      <div style="width: 150px; margin-left: auto; margin-right: auto;">
        <div id="divError" runat="server" visible="false" class="errorzone" />
        <div class="label"><asp:Label ID="lblRateType" runat="server" /></div>
         <div><asp:TextBox ID="txtRate" runat="server" /></div>
        <div>&nbsp;</div>
        <div style="text-align: right"><asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button ID="btnSubmit" runat="server" Text="Update" OnClick="btnSubmit_Click"/></div>
      </div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>&nbsp;</div>
      <div class="successtext">Success!</div>
    </div>
    <asp:label ID="lblReturnUrl" runat="server" Visible="False" />
  </form>
</asp:Content>