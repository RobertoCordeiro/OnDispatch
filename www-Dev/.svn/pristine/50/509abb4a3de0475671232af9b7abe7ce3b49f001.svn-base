<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
    Private _LayerID As Long
    
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = " Edit Layers"
            Master.PageTitleText = " Edit Layers"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""CreateLayer.aspx"">Add / Edit Layer</a> &gt; "

    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
        lblReturnUrl.Text = Request.QueryString("returnurl")
        If _ID > 0 Then
            
            If (Not Page.IsPostBack) Then
                LoadLayer(_ID)
            
            End If
            
        End If
  End Sub
  
    Private Sub LoadLayer(ByVal LayerID As Integer)
        Dim lay As New BridgesInterface.LayerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        lay.Load(LayerID)
        lblLayerName.Text = "Layer Name: " & lay.LayerName
        LoadUnAssignedResumeTypes()
        LoadAssignedResumeTypes(_ID)
    End Sub
    
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect(lblReturnUrl.Text)
  End Sub
    'Load Unassigned Labor Networks
    Private Sub LoadUnAssignedResumeTypes()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListUnassignedResumeTypesInLayer", "@LayerID", _ID, dgvUnassignedResumeTypes)
        'lblAssociatedCount.Text = dgvAssociatedPhoneNumbers.Items.Count
    End Sub
    'Load Assigned Labor Networks
    Private Sub LoadAssignedResumeTypes(ByVal intLayerID As Integer)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListAssignedLayerResumeTypes", "@LayerID", _ID, dgvResumeTypes)
        'lblAssociatedCount.Text = dgvAssociatedPhoneNumbers.Items.Count
    End Sub
    
    Private Sub AssignResumeTypes()
        Dim itm As System.Web.UI.WebControls.DataGridItem
        Dim chk As System.Web.UI.WebControls.CheckBox
        Dim rty As New BridgesInterface.LayerResumeTypeAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        For Each itm In dgvUnassignedResumeTypes.Items
            chk = itm.FindControl("chkSelected")
            If chk.Checked Then
                rty.Add(_ID, CType(itm.Cells(0).Text, Long))
            End If
        Next
    End Sub
    Private Sub btnApply_Click(ByVal S As Object, ByVal E As EventArgs)
        
        AssignResumeTypes()
        LoadAssignedResumeTypes(_ID)
        LoadUnAssignedResumeTypes()
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
  <div  style="font-size:medium" style="font-weight:bold">
    <asp:Label ID="lblLayerName" Visible="True"  runat="server" />
  </div> 
  <div>&nbsp;</div> 
    <table>
      <tbody>
           <tr>
            <td>
              <div class="inputformsectionheader"><asp:Label ID="lblAssignedResumeTypes" runat="server" />&nbsp;Associated&nbsp;Labor Network(s)</div>
              <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvResumeTypes" runat="server">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns>
                  <asp:TemplateColumn>
                    <Itemtemplate>
                      <a href="removeResumeTypeInLayer.aspx?id=<%# DataBinder.Eval(Container.DataItem,"LayerResumeTypeAssignmentID") %>&returnurl=EditLayers.aspx%3fid=<%# _ID %>">Remove</a>
                    </Itemtemplate>
                  </asp:TemplateColumn>                                       
                  <asp:BoundColumn DataField="ResumeTypeID" HeaderText="Type" visible= "false"/>
                  <asp:BoundColumn DataField="ResumeType" HeaderText="Labor Network" />
                </Columns>        
              </asp:DataGrid>
            </td>
            <td>&nbsp;</td>
            <td>
              <div class="inputformsectionheader"><asp:Label ID="lblUnAssignedResumeTypes" runat="server" />&nbsp;Un-Associated&nbsp;Labor Netowrk(s)</div>
              <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvUnassignedResumeTypes" runat="server">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns> 
                  <asp:BoundColumn DataField="ResumeTypeID" Visible="false" />
                  <asp:TemplateColumn HeaderText="Add">
                    <Itemtemplate>
                      <asp:CheckBox id="chkSelected" runat="server" />
                    </Itemtemplate>
                  </asp:TemplateColumn>                                       
                  <asp:BoundColumn DataField="ResumeType" HeaderText="Labor Network" ItemStyle-Wrap="false"/>
                </Columns>        
              </asp:DataGrid>
            </td>
          </tr>
        </tbody>
      </table>
      <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnApply" runat="server" OnClick="btnApply_Click" Text="Apply" /></div>
        <asp:Label ID="lblLayerID" Visible="false" runat="server" />
      </div>
      <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    
  </form>
</asp:Content>