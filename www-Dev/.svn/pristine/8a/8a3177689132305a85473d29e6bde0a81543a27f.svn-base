<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Create Layers"
      Master.PageTitleText = " Create Layers"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      'LoadResumeType()
    Else
      'Response.Redirect(lblReturnUrl.Text, True)
      LoadLayers()
    End If
  End Sub

    
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
    Dim lay As New BridgesInterface.LayerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim strChangeLog as String
    strChangeLog = ""
    If txtNewLayerName.Text <> "" or Not IsDBNull(txtNewLayerName.Text) then
            lay.Add(txtNewLayerName.Text, Master.InfoID)
      lay.Save (strChangeLog)
      txtNewLayerName.Text = ""
    End if
    'Response.Redirect(lblReturnUrl.Text)
    
    LoadLayers()
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  Private Sub LoadLayers()
    Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim da As New System.Data.SqlClient.SqlDataAdapter
    Dim ds As New System.Data.DataSet
    cnn.Open()
    Dim cmd As New System.Data.SqlClient.SqlCommand("spListLayers")
    cmd.CommandType = Data.CommandType.StoredProcedure
    cmd.Connection = cnn
    da.SelectCommand = cmd
    da.Fill(ds)
    dgvLayers.DataSource = ds
    dgvLayers.DataBind()
    cnn.Close()
  End Sub
  
  
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <asp:DataGrid style="width: 100%" ID="dgvLayers" AutoGenerateColumns="false" runat="server">
      <HeaderStyle cssclass="gridheader" />
      <AlternatingItemStyle cssclass="altrow" />  
      <Columns>
         <asp:BoundColumn HeaderText="ID" DataField="LayerID" visible="True" />
         <asp:BoundColumn HeaderText="Layer Name" DataField="LayerName" />
      </Columns>
    </asp:DataGrid>
    <div>&nbsp;</div>
    <asp:Label ID="lblLayerName"  Font-Bold= "True" Text="Enter New Layer Name:" Visible="True" runat="server" />
    <div><asp:TextBox ID="txtNewLayerName"  Width ="100%" runat="server" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnOk" OnClick="btnOK_Click" Text="Yes" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>