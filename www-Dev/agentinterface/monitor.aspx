<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Activity Monitor"
      Master.PageTitleText = "Activity Monitor"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Activity Monitor"
      If Not IsPostBack Then
        LoadLogins()
      End If
    End If
  End Sub
  
  Private Sub LoadLogins()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleDateParameterDataGrid("spGetLoginsForDay", "@DateInput", DateTime.Now, dgvLogins)
  End Sub
  
  Private Function HumanReadableAccessCoding(ByVal strAccessCoding As String) As String
    Dim strReturn As String = ""
    Select Case strAccessCoding.ToLower.Trim
      Case "a"
        strReturn = "Agent"
      Case "c"
        strReturn = "Customer"
      Case "r"
        strReturn = "Recruit"
      Case "p"
        strReturn = "Partner"
      case "t"
        strReturn = "Accountant"
    End Select
    Return strReturn
  End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frm" runat="server">
    <table>
      <tbody>
        <tr>
          <td>
            <asp:DataGrid AutoGenerateColumns="false" AllowSorting="true" ID="dgvLogins" runat="server">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="WebLoginID" Visible="false" />
                <asp:BoundColumn HeaderText="Login" DataField="Login" />
                <asp:TemplateColumn HeaderText="Type">
                  <ItemTemplate>
                    <%# HumanReadableAccessCoding(DataBinder.Eval(Container.DataItem,"AccessCoding")) %>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:templatecolumn HeaderText="Last Login">
                  <ItemTemplate>
                    <%#CType(DataBinder.Eval(Container.DataItem, "LastLogin"), Date).Hour.ToString("00") & ":" & CType(DataBinder.Eval(Container.DataItem, "LastLogin"), Date).Minute.ToString("00")%>
                  </ItemTemplate>
                </asp:templatecolumn>
                <asp:templatecolumn HeaderText="Last Active">
                  <ItemTemplate>
                    <%#CType(DataBinder.Eval(Container.DataItem, "LastActive"), Date).Hour.ToString("00") & ":" & CType(DataBinder.Eval(Container.DataItem, "LastActive"), Date).Minute.ToString("00")%>
                  </ItemTemplate>
                </asp:templatecolumn>
              </Columns>
            </asp:DataGrid>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</asp:Content>