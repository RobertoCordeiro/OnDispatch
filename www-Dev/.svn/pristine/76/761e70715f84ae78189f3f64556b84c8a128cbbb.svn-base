<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

  Private _ID As Long = 1
  Private lngCustID as long = 1
  Private lngIt as long 

  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
        lblTicketCount.Text = ""
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Recruting Console Control"
            Master.PageTitleText = "Recruiting Console Control"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Recruiting Console Control"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
      If _ID < 1 Then
        _ID = 1
      End If
    Catch ex As Exception
      _ID = 1
    End Try
    
        If Not Page.IsPostBack Then
            LoadRegion()
            LoadAppliedFor()
        Else
            
        End If
   
    End Sub
    Private Sub LoadRegion()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListRegions", "RegionName", "RegionID", drpRegion)
        drpRegion.Items.Add("All Regions")
        drpRegion.SelectedValue = "All Regions"
    End Sub
    Private Sub LoadAppliedFor()
    
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListResumeTypes", "ResumeType", "ResumeTypeID", drpAppliedFor)
        drpAppliedFor.Items.Add("All Labor Network")
        drpAppliedFor.SelectedValue = "All Labor Network"
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTickets" runat="server">
    <table width="100%">
      <tbody>
        <tr>
          <td class="band" colspan="3">
            <div class="bandheader">View Candidates</div>
            <asp:DropDownList ID="drpRegion" runat="server" AutoPostBack="true"  />&nbsp;<asp:DropDownList ID="drpAppliedFor" runat="server" AutoPostBack="true"  />&nbsp;<asp:Button ID="btnByArea" runat="server" Text="By Area"  />&nbsp;<asp:Button ID="btnByTicket" runat="server" Text="By Tickets"  />&nbsp;<asp:Button ID="btnProcessing" runat="server" Text="Processing"  /></div>
            <div class="bandheader">&nbsp;</div>
          </td>
          <td></td>
          <td></td>
        </tr>
        <tr id="rowSendEmail"  runat="server" visible="false">
            <td colspan = "3" align="right"><asp:TextBox ID="txtSubject" runat="server" ToolTip="Enter Email Subject"  Width="98%"/><asp:TextBox ID="txtEmailBody" runat="server" TextMode="MultiLine" style="width: 100%" Height="75px" /><asp:Button ID="btnSendEmail" Text="Send Email" runat="server" /></td>
            <td></td>
            <td></td>
        </tr>
        <tr id="test1" runat="server" visible="false" >
           <td colspan="2">
                <div class="inputformsectionheader">Search</div> 
                <div class="inputform" style="padding-left: 3px">Quick Resume Search</div>
                <div id="divResumeSearchError" class="errorzone" visible="false" runat="server" /></div>
                <div style="padding-left: 3px;">
                  <div class="label">Criteria</div>
                  <div><asp:TextBox style="width:95%;" ID="txtResumeSearch" runat="server" /></div>
                  <div class="label">Look In</div>
                  <div><asp:DropDownList ID="cbxLookIn" style="width:95%;" runat="server" /></div>
                  <div style="text-align: right;"><asp:button ID="btnQuickSearch" text="Search" runat="server" /></div>
                </div> 
           </td>
           <td style="width:60%" >
                 <div class="inputformsectionheader">Look Up By Radius</div>
                 <div class="inputform" style="padding-left: 3px">Quick Resume Search</div> 
                 <div id="div1" class="errorzone" visible="false" runat="server" /></div>
                 <div style="padding-left: 3px;">
                    <div class="label">Zip Code</div>
                    <div><asp:TextBox style="width:95%;" ID="txtZipCode" runat="server" /></div>
                    <div class="label">Radius in Miles</div>
                    <div><asp:TextBox style="width:95%;" ID="txtRadius" runat="server" /></div>
                    <div style="text-align: right;"><asp:button ID="btnClosestCandidates" text="Get Candidates" runat="server" /></div>
                 </div>
           </td>
           <td></td>
        </tr>
        <tr>
            <td class="band" style="width: 1%" >
              <div class="bandheader">View List</div>
                <asp:DataGrid ID="dgvFolders" runat="server" ShowHeader="false" ShowFooter="false" AutoGenerateColumns="false">
                <ItemStyle CssClass="bandbar" />
                  <Columns>
                    <asp:BoundColumn DataField="TicketFolderID" HeaderText="ID" Visible="false" />
                    <asp:TemplateColumn ItemStyle-Wrap="false" >
                      <ItemTemplate>
                        <a href="tickets.aspx?"
                      </ItemTemplate>
                    </asp:TemplateColumn>
                  </Columns>              
                </asp:DataGrid>
            </td>
            <td class="band" colspan="2">
              <div class="inputformsectionheader">
                <asp:Label ID="lblTicketCount" runat="server"></asp:Label>
                <asp:DropDownList ID="drpCustomers1" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpStatus" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpProgram" Runat="server" AutoPostBack="True" />
                
                <asp:DropDownList ID="drpState" Runat="server" AutoPostBack="True" />
             </div>
             <div class="inputform">
              <asp:DataGrid AllowSorting="true" ID="dgvTickets" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%" >
                <AlternatingItemStyle CssClass="altrow" />
                <HeaderStyle CssClass="gridheader" />
                <Columns>
                  <asp:BoundColumn DataField="TicketID" HeaderText="ID" Visible="false" />
                  <asp:TemplateColumn SortExpression="TicketID" HeaderText="Ticket&nbsp;ID">
                    <ItemTemplate>
                      <a href="ticket.aspx?id=" /a></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
		            <asp:BoundColumn SortExpression="Age" HeaderText="Age" DataField="Age" />
                  <asp:TemplateColumn SortExpression="CustomerID" HeaderText="Customer">
                    <ItemTemplate>
                      <a href="customer.aspx?id="</a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn SortExpression="Status" HeaderText="Status" DataField="Status" />
                  <asp:BoundColumn SortExpression="ContactLastName" HeaderText="EULastName" DataField="ContactLastName" />
                  <asp:BoundColumn SortExpression="ServiceType" HeaderText="Program" DataField="ServiceType" />
                  <asp:TemplateColumn SortExpression="ServiceID" HeaderText="Service SKU">
                    <ItemTemplate>
                      <a target="_blank" href="servicedetail.aspx?id="></a>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  
                  <asp:TemplateColumn
                    SortExpression="CustomerPrioritySetting"
                    HeaderText="C&nbsp;Priority"
                    >
                  <ItemTemplate>
                    <img alt="Internal Priority" src="../graphics/level.png" />          
                  </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn SortExpression="City" DataField="City" HeaderText="City" />
                  <asp:BoundColumn SortExpression="Abbreviation" DataField="Abbreviation" HeaderText="State" />                  
                  <asp:TemplateColumn SortExpression="ZipCode" HeaderText="Zip" >
                    <ItemTemplate>
                      <a href="findzipcode.aspx"</a>
                    </ItemTemplate>
                  </asp:TemplateColumn>                  
                  <asp:BoundColumn SortExpression="ETA" HeaderText="ETA" DataField="ETA" Visible="True" />        
                  <asp:BoundColumn SortExpression="ScheduledEndDate" HeaderText="Schedule Date" DataField="ScheduledEndDate" />        
                </Columns>
              </asp:DataGrid>
            </div>
          </td>
           <td></td>
        </tr>
      </tbody>
    </table>
  </form>
  <asp:Label ID="lblSortOrder" runat="server" Visible="false" />
</asp:Content>