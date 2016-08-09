<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Edit Model"
      Master.PageTitleText = " Edit Model"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""makers.aspx"">Manufacturer Model Control</a> &gt; <a href=""" & lblReturnUrl.Text & """>Models</a> &gt; Edit Model"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadProductTypes()
        LoadModel(_ID)
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub

  Private Sub LoadModel(ByVal lngID As Long)
    Dim mdl As New BridgesInterface.ModelRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    mdl.Load(lngID)
    cbxProductTypes.SelectedValue = mdl.ProductTypeID
    txtModelName.Text = mdl.ModelName
  End Sub
  
  Private Sub LoadProductTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListProductTypes", "ProductType", "ProductTypeID", cbxProductTypes)    
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub

  Private Sub btnEdit_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim strChangeLog As String = ""
    If isComplete() Then
      divErrors.Visible = False
      Dim mdl As New BridgesInterface.ModelRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      mdl.Load(_ID)
      mdl.ModelName = txtModelName.Text
      mdl.ProductTypeID = cbxProductTypes.SelectedValue
      mdl.Save(strChangeLog)
      Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      act.Add(2, "web", strType, strIp, "web", 30, mdl.ModelID, strChangeLog)
      Response.Redirect(lblReturnUrl.Text, True)
    Else
      divErrors.Visible = True
    End If
    
  End Sub
    
  Private Function isComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtModelName.Text.Trim.Length = 0 Then
      strErrors &= "<li>Model Name is Required</li>"
      blnReturn = False
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" runat="server" visible="false" id="divErrors" />
    <div class="label">Model Name</div>    
    <asp:TextBox style="width: 99%" runat="server" ID="txtModelName" />    
    <div class="label">Product Type</div>
    <asp:DropDownList style="width: 99%" ID="cbxProductTypes" runat="server" />
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnEdit" runat="server" OnClick="btnEdit_Click" Text="Submit" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>