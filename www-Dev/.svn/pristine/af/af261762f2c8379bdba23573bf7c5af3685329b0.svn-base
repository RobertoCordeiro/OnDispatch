<%@ Page Language="VB" masterpagefile="~/masters/cust.master"%>
<%@ MasterType VirtualPath="~/masters/cust.master" %>
<%@ Register Src="~/controls/ticket.ascx" TagName="Ticket" TagPrefix="cv" %>
<script language="VB" runat="server">
  
  Private _Field As String = ""
  Private _Criteria As String = ""
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strHeaderText As String = "Find Ticket"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        If lgn.AccessCoding.Contains("C") Then
          Master.WebLoginID = lgn.WebLoginID
          'Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Find Ticket]"
          'Master.PageHeaderText = strHeaderText
          If Not IsPostBack Then
            LoadSearchFields()
          End If
          Try
            _Field = Request.QueryString("in").ToString
            _Criteria = Request.QueryString("crit").ToString
          Catch ex As Exception
            _Field = ""
            _Criteria = ""
          End Try
          If _Field.Trim.Length > 0 And _Criteria.Trim.Length > 0 Then
            divFind.Visible = False
            divResults.Visible = True
            LoadResults()
          Else
            divFind.Visible = True
            divResults.Visible = False
          End If
        Else
          Response.Redirect("/login.aspx", True)
        End If
      Else
        Response.Redirect("/login.aspx", True)
      End If
      Else
      Response.Redirect("/login.aspx", True)
    End If
  End Sub
  
  Private Sub LoadResults()
    Dim src As New BridgesInterface.SearchEngine(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim lngTicketID As Long = 0
    Select Case _Field.ToLower
      Case "ticketid"
        src.CustomerAgentFindTicketByTicketID(Master.CustomerAgentID, CType(_Criteria, Long), dgvResults)
      Case "zip"
        src.CustomerAgentFindTicketByZipCode(Master.CustomerAgentID, _Criteria, dgvResults)
      Case "lastname"
        src.CustomerAgentFindTicketByLastName(Master.CustomerAgentID, _Criteria, dgvResults)
      Case "ref1"
        src.CustomerAgentFindTicketByReferenceNumber1(Master.CustomerAgentID, _Criteria, dgvResults)
      Case "ref2"
        src.CustomerAgentFindTicketByReferenceNumber2(Master.CustomerAgentID, _Criteria, dgvResults)
      Case "ref3"
        src.CustomerAgentFindTicketByReferenceNumber3(Master.CustomerAgentID, _Criteria, dgvResults)
      Case "ref4"
        src.CustomerAgentFindTicketByReferenceNumber4(Master.CustomerAgentID, _Criteria, dgvResults)
      Case "serial"
        src.CustomerAgentFindTicketBySerialNumber(Master.CustomerAgentID, _Criteria, dgvResults)
      Case "label"
        src.CustomerAgentFindTicketByShippingLabel(Master.CustomerAgentID, _Criteria, dgvResults)
      Case "phone"
        src.CustomerAgentFindTicketByPhoneNumber(Master.CustomerAgentID, _Criteria, dgvResults)
    End Select
    lblResultCount.Text = dgvResults.Items.Count.ToString
    If dgvResults.Items.Count = 1 Then
      lngTicketID = CType(dgvResults.Items(0).Cells(0).Text, Long)
      Response.Redirect("ticket.aspx?id=" & lngTicketID.ToString, True)
    End If
  End Sub
  
  Private Sub LoadSearchFields()
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cst.Load(Master.CustomerID)
    With drpFields.Items
      .Clear()
      .Add(CreateItem("ticketid", "Ticket ID"))
      .Add(CreateItem("phone", "Phone Number"))
      .Add(CreateItem("lastname", "Last Name"))
      .Add(CreateItem("label", "Shipping Label"))
      .Add(CreateItem("zip", "Zip Code"))
      .Add(CreateItem("serial", "Serial Number"))
      If cst.Ref1Label.Trim.Length > 0 Then
        .Add(CreateItem("ref1", cst.Ref1Label))
      Else
        .Add(CreateItem("ref1", "Reference # 1"))
      End If
      If cst.Ref2Label.Trim.Length > 0 Then
        .Add(CreateItem("ref2", cst.Ref2Label))
      Else
        .Add(CreateItem("ref2", "Reference # 2"))
      End If
      If cst.Ref3Label.Trim.Length > 0 Then
        .Add(CreateItem("ref3", cst.Ref3Label))
      Else
        .Add(CreateItem("ref3", "Reference # 3"))
      End If
      If cst.Ref4Label.Trim.Length > 0 Then
        .Add(CreateItem("ref4", cst.Ref4Label))
      Else
        .Add(CreateItem("ref4", "Reference # 4"))
      End If
    End With
  End Sub
  
  Private Function CreateItem(ByVal strValue As String, ByVal strText As String) As System.Web.UI.WebControls.ListItem
    Dim itmReturn As New System.Web.UI.WebControls.ListItem(strText, strValue)
    Return itmReturn
  End Function
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim lng As Long = 0
    If txtLookFor.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Criteria Is Required</li>"
    Else
      Select Case drpFields.SelectedValue.ToLower
        Case "ticketid"
          If Not Long.TryParse(txtLookFor.Text, lng) Then
            blnReturn = False
            strErrors &= "<li>Ticket ID Must Be Numeric</li>"
          End If
        Case "phone"
          If Not Long.TryParse(txtLookFor.Text, lng) Then
            blnReturn = False
            strErrors &= "<li>Phone Number Must Be All Numbers (No Spaces, No Dashes or Brackets, etc) I.E. 5551212</li>"
          End If
      End Select
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Public Sub btnFind_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      trErrors.Visible = False
      Response.Redirect("findticket.aspx?crit=" & txtLookFor.Text.Trim & "&in=" & drpFields.SelectedValue)
    Else
      trErrors.Visible = True
    End If
  End Sub
  
</script>

<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
<form id="frmTickets" runat="server">
  <div id="divFind" visible="true" runat="server">
    <div style="padding-bottom: 50px;">&nbsp;</div>
    <table class="inputform" style="margin-left: auto; margin-right:auto; width: 416px;">
      <tbody>
        <tr>
          <td class="inputformsectionheader">Find Ticket</td>
        </tr>
        <tr>
          <td>
            <table>
              <tbody>
                <tr>
                  <td>Look For</td>
                  <td>In</td>
                </tr>
                <tr>
                  <td style="width: 200px; padding-right: 8px;"><asp:TextBox style="width: 100%" ID="txtLookFor" runat="server" /></td>
                  <td style="width: 200px;"><asp:DropDownList style="width: 100%" ID="drpFields" runat="server" /></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td style="text-align: right;"><asp:Button ID="btnFind" Text="Find" runat="server" OnClick="btnFind_Click" /></td>
                </tr>
              </tbody>
            </table>
            <asp:label ID="lblNotice" runat="server" />
          </td>
        </tr>
        <tr id="trErrors" runat="server" visible="false">
          <td class="errorzone"><div id="divErrors" runat="server" /></td>
        </tr>
      </tbody>
    </table>
  </div>
  <div><img src="/graphics/minheight.png" alt="Client Interface" /></div>
  <div id="divResults" runat="server" visible="false">
    <div class="bandheader">Search Results - <asp:Label ID="lblResultCount" runat="server" /> Ticket(s) Found</div>
    <asp:DataGrid ID="dgvResults" runat="server" style="width: 100%" AutoGenerateColumns="false">
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:BoundColumn HeaderText="Ticket ID" DataField="TicketID" Visible="false" />
        <asp:TemplateColumn HeaderText="Ticket ID">
          <ItemTemplate>
            <a href="ticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><%# DataBinder.Eval(Container.DataItem,"TicketID") %></a><a target="_blank" href="printableticket.aspx?id=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>"><img style="border: 0" alt="Printable Version" src="/graphics/printable.png" /></a>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn headertext="Status" DataField="Status" />
        <asp:BoundColumn HeaderText="SKU" DataField="ServiceName" />
        <asp:TemplateColumn
          HeaderText="Priority"
          >
        <ItemTemplate>
          <img alt="Priority" src="../graphics/level<%# Databinder.eval(Container.DataItem,"CustomerPrioritySetting") %>.png" />          
        </ItemTemplate>
        </asp:TemplateColumn>
        <asp:BoundColumn datafield="city" HeaderText="City" />
        <asp:BoundColumn DataField="Abbreviation" HeaderText="State" />
        <asp:TemplateColumn
          HeaderText="Zip"
          >
          <ItemTemplate>
            <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
          </ItemTemplate>
        </asp:TemplateColumn>        
        <asp:BoundColumn HeaderText="Requested Start" DataField="RequestedStartDate" />
        <asp:BoundColumn HeaderText="Requested End" DataField="RequestedEndDate" />        
        <asp:BoundColumn HeaderText="Date Created" DataField="DateCreated" />
      </Columns>       
    </asp:DataGrid>
    <div style="text-align: center"><a href="findticket.aspx">[New Search]</a></div>
  </div>

 </form>
</asp:Content>