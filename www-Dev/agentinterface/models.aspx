<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnurl.Text = Request.QueryString("returnurl")
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Models"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Model Control"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""makers.aspx"">Manufacturer Model Control</a>"
    End If
    If _ID > 0 Then
      If Not IsPostBack Then
        LoadAll()
      End If
    Else
      Response.Redirect(lblReturnurl.Text)
    End If
  End Sub
  
  Private Sub LoadAll()
    LoadManufacturer(_ID)
    LoadModels(_ID)
    LoadProductTypes()    
  End Sub
  
  Private Sub LoadProductTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListProductTypes", "ProductType", "ProductTypeID", cbxProductTypes)
  End Sub
  
  Private Sub LoadManufacturer(ByVal lngID As Long)
    Dim man As New BridgesInterface.ManufacturerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    man.Load(lngID)
    Master.PageHeaderText = man.Manufacturer & " Models"
    Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""makers.aspx"">Manufacturer Model Control</a>"
  End Sub
  
  Private Sub LoadModels(ByVal lngID As Long)
    Dim com As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    com.LoadSingleLongParameterDataGrid("spListModels", "@ManufacturerID", lngID, dgvModels)
  End Sub
  
  Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim mdl As New BridgesInterface.ModelRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      mdl.Add(Master.UserID, _ID, cbxProductTypes.SelectedValue, txtModelName.Text.Trim)
      divErrors.Visible = False
      LoadAll()
      txtModelName.Text = ""
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtModelName.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Model Name is Required.</li>"
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmModel" runat="server">
    <asp:DataGrid style="width: 100%" id="dgvModels" runat="server" AutoGenerateColumns="false">
      <HeaderStyle cssclass="gridheader" />
      <AlternatingItemStyle cssclass="altrow" />     
      <Columns>
        <asp:BoundColumn
          HeaderText="ID"
          DataField="ModelID"
          visible="false"
          />
        <asp:TemplateColumn>
          <ItemTemplate>
            <a href="editmodel.aspx?id=<%# DataBinder.Eval(Container.DataItem,"ModelID") %>&returnurl=models.aspx?id=<%# _ID %>">Edit</a>
          </ItemTemplate>
        </asp:TemplateColumn> 
        <asp:BoundColumn
          HeaderText="Product Type"
          DataField="ProductType"
          />
        <asp:BoundColumn
          HeaderText="Model"
          DataField="ModelName"
          />
         <asp:TemplateColumn HeaderText="Author">
           <ItemTemplate>
             <a href="mailto:<%# DataBinder.Eval(Container.DataItem,"Email") %>"><%# DataBinder.Eval(Container.DataItem,"Author") %></a>
           </ItemTemplate>
         </asp:TemplateColumn>        
        <asp:BoundColumn
          HeaderText="Date Created"
          DataField="DateCreated"
          />          
      </Columns>
    </asp:DataGrid>
    <div class="errorzone" runat="server" id="divErrors" visible="false" />
    <div class="bandheader">Quick Add</div>
    <table>
      <tbody>
        <tr>
          <td class="label">Model Name</td>
          <td>&nbsp;</td>
          <td class="label">Product Type</td>          
        </tr>
        <tr>
          <td><asp:TextBox style="width: 100%" ID="txtModelName" runat="server" /></td>
          <td>&nbsp;</td>
          <td><asp:DropDownList style="width: 100%" ID="cbxProductTypes" runat="server"/></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>          
          <td style="text-align: right;"><asp:Button ID="btnAdd" OnClick="btnAdd_Click" Text="Add" runat="server" /></td>
        </tr>
      </tbody>
    </table>
    <asp:Label ID="lblReturnurl" runat="server" Visible="false" />
  </form>
</asp:Content>