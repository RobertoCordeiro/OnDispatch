<%@ Page Language="vb" masterpagefile="~/masters/partner.master" %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>

<script runat="server">
    Private _ID As Long = 0
    Public swfFileName As String = ""
    Public _somedata As String = ""
    
    Public ReadOnly Property SomeData() As String
        Get
            Return _somedata
        End Get
    End Property
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
        If User.Identity.IsAuthenticated Then
            Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Training Videos"
            Master.PageTitleText = "Training Videos"
            _ID = Master.PartnerAgentID
            Master.ActiveMenu = "N"
            If Not Page.IsPostBack Then
                Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                ldr.LoadSingleLongParameterDataGrid("spGetTrainingVideoByGroupID", "@GroupID", 9, dgvVideos)
            End If
        Else
            Response.Redirect("/login.aspx", True)
        End If
  End Sub
    
    Private Sub btnLinkView_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim m_ClientID As String = ""
        Dim bt As New LinkButton
        Dim rb As New LinkButton
        bt = CType(S, LinkButton)
        m_ClientID = bt.ClientID
        For Each i As DataGridItem In dgvVideos.Items
            rb = CType(i.FindControl("LinkView"), LinkButton)
            If (rb.ClientID = bt.ClientID) Then
                swfFileName = i.Cells(4).Text
                _somedata = i.Cells(3).Text
                'Response.Redirect("ViewVideo.aspx?Url=" & swfFileName)
                Server.Transfer("ViewVideo.aspx?Url=" & swfFileName)
                
                
            End If
        Next
        
    End Sub
</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTrainingVideo" runat="server"> 
  <table>
    <tr>
      <td>
        <div>
           <div class ="label"></div>
           <asp:DataGrid ID="dgvVideos" runat="server" AutoGenerateColumns="false" style="width: 600px;">
           <AlternatingItemStyle CssClass="altrow" />
           <HeaderStyle CssClass="gridheader" />
              <Columns>
                 <asp:BoundColumn DataField="TrainingVideoID" HeaderText="TrainingVideoID" Visible="false" />
                 <asp:TemplateColumn>
                    <ItemTemplate>
                      <asp:LinkButton id="LinkView" OnClick="btnLinkView_Click" runat="server" OnClientClick="aspnetForm.target ='_blank';"></asp:LinkButton>
                    </ItemTemplate>
               </asp:TemplateColumn>
           <asp:BoundColumn DataField="Title" HeaderText="Title" />
           <asp:BoundColumn DataField="Subject" HeaderText="Subject" />
           <asp:BoundColumn DataField="FilePath" HeaderText="FilePath" Visible="false" />
      </Columns>
    </asp:DataGrid>
  </div>
      </td>
    </tr>
  </table>
  </form>
</asp:Content>

