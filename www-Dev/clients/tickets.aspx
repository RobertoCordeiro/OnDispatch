<%@ Page Language="VB" masterpagefile="~/masters/customer.master"%>
<%@ MasterType VirtualPath="~/masters/customer.master" %>
<%@ Register Src="~/controls/ticket.ascx" TagName="Ticket" TagPrefix="cv" %>
<script language="VB" runat="server">
    
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    
    
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strMode As String = ""
      If CType(Request.QueryString("mode"), String) <> "" Then
        strMode = Request.QueryString("mode")
      End If
      Master.ActiveMenu = "B"
      Dim strHeaderText As String = "Ticket Summary"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Master.WebLoginID = lgn.WebLoginID
        Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Ticket Summary]"
        Master.PageHeaderText = strHeaderText
        If Not IsPostBack Then
          LoadSummary()
          'Dim frame1 as HtmlControl = Ctype(Me.FindControl ("fraticket"),HtmlControl)
          'frame1.Attributes["src"] = "<img src
        End If
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else
      Response.Redirect("/login.aspx", True)
    End If
  End Sub
   
  Private Sub LoadSummary()
    Dim dgv As DataGrid
        'Dim img As System.Web.UI.WebControls.Image
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListCustomerAgentServiceTypes", "@CustomerAgentID", Master.CustomerAgentID, dgvServiceTypes)
    Dim strTemp As String = ""
    For Each itm As DataGridItem In dgvServiceTypes.Items
      dgv = itm.FindControl("dgvFolderSummary")
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spListCustomerServiceTypeSummary", "@ServiceTypeID", CType(itm.Cells(0).Text, Long), dgv)
        strTemp = ""
        For Each sitm As DataGridItem In dgv.Items
          strTemp &= sitm.Cells(2).Text & "D"
        Next
        If strTemp.Trim.Length > 0 Then
          strTemp = strTemp.Substring(0, strTemp.Length - 1)
        End If
        'img = itm.FindControl("imgGraph")
        'If Not IsNothing(img) Then
        '  img.ImageUrl = "piegraph.aspx?values=" & strTemp
        'End If
      End If
    Next
    
  End Sub
  
</script>


<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmSummary" runat="server">
  <div class="minHeight" id="bodypage"><img src="/graphics/minheight.png" alt="Client Interface" /></div>
    <div class="bandheader" style=" height:445px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a target="fratickets" href="findticket.aspx" runat="server">Find Ticket</a><br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a target="fratickets" href="addticket.aspx" runat="server">Add Ticket</a><br /> Available Projects...
    <asp:DataGrid ID="dgvServiceTypes" GridLines="none"  ShowHeader="false" runat="server" AutoGenerateColumns="false">
      <AlternatingItemStyle  />
      <Columns>
        <asp:BoundColumn DataField="ServiceTypeID" HeaderText="ID" Visible="False" />
        <asp:TemplateColumn>
          <ItemTemplate>
            <div class="ticketsectionheader"><%#DataBinder.Eval(Container.DataItem, "ServiceType")%></div>
            <table>
              <tbody>
                <tr>
                  <td>&nbsp;&nbsp;&nbsp;</td>
                  <td>
                    <asp:DataGrid ID="dgvFolderSummary" GridLines="none" ShowHeader="false" AutoGenerateColumns="false" runat="server">
                      <Columns>
                        <asp:BoundColumn HeaderText="ID" DataField="TicketFolderID" Visible="false" />
                        <asp:TemplateColumn>
                          <ItemTemplate>
                            <a target="fratickets" id="ilink" href="ticketfolder.aspx?id=<%#DataBinder.Eval(Container.DataItem, "TicketFolderID")%>&sid=<%#DataBinder.Eval(Container.DataItem, "ServiceTypeID")%>"><%#DataBinder.Eval(Container.DataItem, "FolderName")%></a>&nbsp;
                          </ItemTemplate>
                        </asp:TemplateColumn>                        
                        <asp:BoundColumn HeaderText="Ticket Count" DataField="TicketCount" />
                      </Columns>
                    </asp:DataGrid>
                  </td>
                </tr>
              </tbody>
            </table>
          </ItemTemplate>          
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
    </div>
    <div><iframe name="fratickets" id="fraticket" runat="server" src="../images/needhelp.jpg" width="87%" height="550px"  marginwidth="0" marginheight="0" frameborder="0"  ></iframe></div>
  
  </form>
</asp:Content>