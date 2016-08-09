<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Default Rates"
      Master.PageTitleText = " Default Rates"
      
    End If
    
    LoadAssignedResumeTypes
  End Sub
  
  Private Sub LoadReferenceRates(lngResumeTypeID as long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadsingleLongParameterDataGrid ("SpListRateTypesByResumeTypeID","@ResumeTypeID",lngResumeTypeID,dgvRates)
   

  End Sub
  
  
   'Load Assigned Labor Networks
  Private Sub LoadAssignedResumeTypes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDataGrid("spListResumeTypes",dgvresumetypes)
  End Sub 
  
  Private Sub dgvResumeTypes_onselectedIndesChange (ByVal sender As Object, ByVal e As System.EventArgs )Handles dgvResumeTypes.SelectedIndexChanged 
   Dim str as string
   
   
   str = dgvResumeTypes.SelectedItem.Cells(1).Text

  
  LoadReferenceRates(Ctype(dgvResumeTypes.SelectedItem.Cells(1).text,Long))
  lnkAdd.HRef = "addrate.aspx?id=" & Ctype(dgvResumeTypes.SelectedItem.Cells(1).text,Long)
  end sub
  
  
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmWorkOrders" runat="server">
    <div id="ratesheader" class="tabbody">
    <div>&nbsp;</div>
    <div>** These should be yours tech's regular rates. Rates they would show to their local customers (not rates based on BSA Customers) ** </div>
    <div>&nbsp;</div>
    </div>
    <table width="100%">
      <tr>
        <td style="width:30%;">
          <div class="inputformsectionheader"><asp:Label ID="lblAssignedResumeTypes" runat="server" />&nbsp;Associated&nbsp;Labor Network(s)</div>
            <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvResumeTypes" runat="server" OnSelectedIndexChanged ="dgvResumeTypes_onselectedIndesChange"  >
              <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />   
                  <Columns>
                     <asp:ButtonColumn ButtonType="linkbutton"   Text="select" CommandName="Select" Visible="true"></asp:ButtonColumn>
                     <asp:BoundColumn DataField="ResumeTypeID" HeaderText="Type" visible= "false"/>
                     <asp:BoundColumn DataField="ResumeType" HeaderText="Labor Network" />
                  </Columns>        
            </asp:DataGrid>
       </td>
       <td style="width:70%;">
         <div id="divRates" class="bandheader" runat="server"></div>
            <asp:DataGrid  ID="dgvRates" style="width: 100%" runat="server" AutoGenerateColumns="false" >
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn
                  DataField="RateTypeID"
                  HeaderText="ID"
                  visible="False"
                />
                <asp:BoundColumn
                  DataField="Description"
                  HeaderText="Type"
                  ItemStyle-Wrap="false"
                  />
                <asp:BoundColumn
                  DataField="DefaultRate"
                  HeaderText="Rate"
                  DataFormatString="{0:C}"
                  />
                <asp:TemplateColumn>
                  <ItemTemplate>
                    <a  target="_blank" href="editrate.aspx?id=<%# Databinder.eval(Container.DataItem,"RateTypeID") %>">Edit</a>  

                  </ItemTemplate>
                </asp:TemplateColumn> 
              </Columns>                
            </asp:DataGrid> 
            <div style="text-align:right;"><a id="lnkAdd" target="_blank" runat="server" >[Add Service Types Rates]</a></div>
            <div>&nbsp;</div>
            <div runat="server" id="divPrograms" visible="false" class="bandheader">Programs</div>
            <asp:DataGrid ID="dgvServiceTypes" AutoGenerateColumns="false" style="width: 100%" runat="server">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn
                  HeaderText="ID"
                  DataField="ServiceTypeID"
                  visible="false"
                  />
                <asp:BoundColumn
                  HeaderText="Program"
                  DataField="ServiceType"
                  />
                <asp:TemplateColumn 
                  HeaderText="Active"
                  >             
                  <ItemTemplate>
                    <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>         
                <asp:BoundColumn
                  HeaderText="Date&nbsp;Created"
                  DataField="DateCreated"
                  />
              </Columns>      
            </asp:DataGrid>
         </td>
      </tr>
    </table>
  </form>
</asp:Content>