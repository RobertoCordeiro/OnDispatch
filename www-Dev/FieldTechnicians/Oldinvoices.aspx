<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">
  Private _Act as String = "A"
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Invoices"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Invoices"
      
            Master.ActiveMenu = "M"
    End If
    LoadOldInvoices
  End Sub
   Private Sub LoadOldInvoices()
    Dim ldr as New cvCommon.Loaders(system.Configuration.ConfigurationManager .AppSettings ("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid ("spGetVendorInvoicesByPartnerID","@PartnerID",master.PartnerID ,dgvOldInvoices)
    Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    

    Dim dgv1 As System.Web.UI.WebControls.DataGrid
    For Each itm As DataGridItem In dgvOldInvoices.Items
      inv.Load(CType(itm.Cells(0).Text, Long))  
      dgv1 = itm.FindControl ("dgvPayments")
      LoadPayments (CType(itm.Cells(0).Text, Long),dgv1)
      
      dgv1 = itm.FindControl ("dgvJournal")
      loadJournal (Ctype(itm.Cells(0).Text,Long),dgv1)
    Next
    
  End Sub
  
  Private Sub LoadPayments(lngInvoiceID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spGetInvoicePaymentsByInvoiceID", "@InvoiceID", lngInvoiceID, dgv)
      End If
  End Sub
  
  Private Sub LoadJournal(lngInvoiceID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spGetJournalEntriesForInvoice", "@InvoiceID", lngInvoiceID, dgv)
      End If
  End Sub
  
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
 <form id="invoices1" runat="server">
  <div style=" text-align:center;"></div>
   <div visible="True" id="divOldInvoices" class="inputformsectionheader" runat="server">Old Invoices</div>
            <asp:DataGrid Visible="True" ID="dgvOldInvoices" style="width: 100%" runat="server" AutoGenerateColumns="false">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                <asp:TemplateColumn HeaderText ="InvoiceNumber" > 
                  <ItemTemplate>
                    <a href="OldInvoicedetails.aspx?id=<%# Databinder.eval(Container.DataItem,"InvoiceID") %>&act=L" ><%# Databinder.eval(Container.DataItem,"InvoiceNumber") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>           
                <asp:BoundColumn DataField="Total" HeaderText="Total" DataFormatString="{0:C}" />
                <asp:BoundColumn DataField="InvoiceDate" HeaderText="InvoiceDate" />
                <asp:TemplateColumn HeaderText ="Payment Records">
                  <ItemTemplate>
                     <asp:DataGrid Visible="True" ID="dgvPayments" style="width: 100%" runat="server" AutoGenerateColumns="false">
                        <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />   
                            <Columns>
                               <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                               <asp:BoundColumn DataField="checkNumber" HeaderText="CheckNumber" />            
                               <asp:BoundColumn DataField="Amount" HeaderText="CheckAmount" DataFormatString="{0:C}" />
                               <asp:BoundColumn DataField="PayDate" HeaderText="PayDate" />
                            </Columns>                
                     </asp:DataGrid>    
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText ="Journal Entries" > 
                  <ItemTemplate>
                     <asp:DataGrid Visible="True" ID="dgvJournal" style="width: 100%" runat="server" AutoGenerateColumns="false">
                        <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />   
                            <Columns>
                               <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                               <asp:TemplateColumn ItemStyle-Wrap="true">
                                  <Itemtemplate>
                                     <%#DataBinder.Eval(Container.DataItem, "Comments").ToString.Replace(Environment.NewLine, "<br />")%>
                                  </Itemtemplate>
                               </asp:TemplateColumn>
                               <asp:BoundColumn DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                            </Columns>                
                     </asp:DataGrid>   
                  </ItemTemplate>
                </asp:TemplateColumn>                 
              </Columns>                
            </asp:DataGrid>             
 </form>
</asp:Content>