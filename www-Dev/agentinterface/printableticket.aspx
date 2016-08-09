<%@ Page Language="VB" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Response.Buffer = True
    If CType(System.Configuration.ConfigurationManager.AppSettings("DownForMaintenance"), Boolean) Then
      Response.Redirect(System.Configuration.ConfigurationManager.AppSettings("MaintenanceUrl"), True)
      Response.Flush()
      Response.End()
    Else
      Dim blnRequireSecure As Boolean = System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection")
      If blnRequireSecure Then
        If (Request.ServerVariables("HTTPS") = "off") Then
          Dim strRedirect As String = ""
          Dim strQuery As String = ""
          strRedirect = "https://" & Request.ServerVariables("SERVER_NAME")
          strRedirect &= Request.ServerVariables("SCRIPT_NAME")
          strQuery = Request.ServerVariables("QUERY_STRING")
          If strQuery.Trim.Length > 0 Then
            strRedirect &= "?"
            strRedirect &= strQuery
          End If
          Response.Redirect(strRedirect, True)
        End If
      End If
      Try
        _ID = CType(Request.QueryString("id"), Long)
      Catch ex As Exception
        _ID = 0
      End Try
      If _ID > 0 Then
        lblCompanyName.Text = System.Configuration.ConfigurationManager.AppSettings("CompanyName")
        LoadTicket()
      Else
        frmTicket.Visible = False
      End If
    End If
  End Sub

  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cst As New BridgesInterface.CustomerRecord(tkt.ConnectionString)
    Dim tst As New BridgesInterface.TicketStatusRecord(tkt.ConnectionString)
    Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
    Dim svt As New BridgesInterface.ServiceTypeRecord(tkt.ConnectionString)
    Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
    Dim wtm As New BridgesInterface.WarrantyTermRecord(tkt.ConnectionString)
    Dim strBlankDateSpacer As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    Dim datNothing As Date = Nothing
    Dim strHtml As String = ""    
    tkt.Load(_ID)
    cst.Load(tkt.CustomerID)
    tst.Load(tkt.TicketStatusID)
    stt.Load(tkt.StateID)
    srv.Load(tkt.ServiceID)
    svt.Load(srv.ServiceTypeID)
    wtm.Load(tkt.WarrantyTermID)
    imgBarCode.ImageUrl = "barcode.aspx?value=" & tkt.TicketID & "&height=32&type=128"
    imgPostNet.ImageUrl = "barcode.aspx?value=" & tkt.ZipCode & "&height=5&type=PostNet"
    imgPriority.ImageUrl = "../graphics/level" & tkt.CustomerPrioritySetting & ".png"
    If tkt.Company.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Company & "</div>"
    End If
    strHtml &= "<div>" & tkt.ContactFirstName & " " & tkt.ContactMiddleName & " " & tkt.ContactLastName & "</div>"
    If tkt.Email.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Email & "</div>"
    End If
    lblContact.Text = strHtml
    strHtml = "<div>" & tkt.Street & "</div>"
    If tkt.Extended.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Extended & "</div>"
    End If
    strHtml &= "<div>" & tkt.City & " " & stt.Abbreviation & ", " & tkt.ZipCode
    lblAddress.Text = strHtml
    LoadPhoneNumbers()
    lblDescription.Text = tkt.Description.Replace(Environment.NewLine, "<br />")
    lblNotes.Text = tkt.Notes.Replace(Environment.NewLine, "<br />")
    lblTicketID.Text = tkt.TicketID
    lblStatus.Text = tst.Status
    lblDateCreated.Text = tkt.DateCreated.ToString
    If cst.Ref1Label.Trim.Length > 0 Then
      lblRef1Label.Text = cst.Ref1Label
    Else
      lblRef1Label.Text = "Ref 1"
    End If
    If tkt.ReferenceNumber1.Trim.Length > 0 Then
      lblRef1.Text = tkt.ReferenceNumber1
    Else
      lblRef1.Text = "&nbsp;"
    End If
    If cst.Ref2Label.Trim.Length > 0 Then
      lblRef2Label.Text = cst.Ref2Label
    Else
      lblRef2Label.Text = "Ref 2"
    End If
    If tkt.ReferenceNumber2.Trim.Length > 0 Then
      lblRef2.Text = tkt.ReferenceNumber2
    Else
      lblRef2.Text = "&nbsp;"
    End If
    If cst.Ref3Label.Trim.Length > 0 Then
      lblRef3Label.Text = cst.Ref3Label
    Else
      lblRef3Label.Text = "Ref 3"
    End If
    If tkt.ReferenceNumber3.Trim.Length > 0 Then
      lblRef3.Text = tkt.ReferenceNumber3
    Else
      lblRef3.Text = "&nbsp;"
    End If
    If cst.Ref4Label.Trim.Length > 0 Then
      lblRef4Label.Text = cst.Ref4Label
    Else
      lblRef4Label.Text = "Ref 4"
    End If
    If tkt.ReferenceNumber4.Trim.Length > 0 Then
      lblRef4.Text = tkt.ReferenceNumber4
    Else
      lblRef4.Text = "&nbsp;"
    End If
    lblRequestedStartDate.Text = tkt.RequestedStartDate
    lblRequestedEndDate.Text = tkt.RequestedEndDate
    lblServiceType.Text = svt.ServiceType
    lblService.Text = srv.ServiceName
    lblManufacturer.Text = tkt.Manufacturer
    lblModel.Text = tkt.Model
    lblSerialNumber.Text = tkt.SerialNumber
    If Not IsNothing(tkt.WarrantyStart) Then
      If tkt.WarrantyStart <> datNothing Then
        lblWarrantyStart.Text = tkt.WarrantyStart.ToString
      Else
        lblWarrantyStart.Text = strBlankDateSpacer
      End If
    Else
      lblWarrantyStart.Text = strBlankDateSpacer
    End If
    If Not IsNothing(tkt.WarrantyEnd) Then
      If tkt.WarrantyEnd <> datNothing Then
        lblWarrantyEnd.Text = tkt.WarrantyEnd.ToString
      Else
        lblWarrantyEnd.Text = strBlankDateSpacer
      End If
    Else
      lblWarrantyEnd.Text = strBlankDateSpacer
    End If
    If Not IsNothing(tkt.PurchaseDate) Then
      If tkt.PurchaseDate <> datNothing Then
        lblPurchaseDate.Text = tkt.PurchaseDate.ToString
      Else
        lblPurchaseDate.Text = strBlankDateSpacer
      End If
    Else
      lblPurchaseDate.Text = strBlankDateSpacer
    End If
    If tkt.ScheduledDate <> datNothing Then
      lblScheduledDate.Text = tkt.ScheduledDate.ToString
    Else
      lblScheduledDate.Text = strBlankDateSpacer
    End If
    If tkt.ScheduledEndDate <> datNothing Then
      lblScheduledDateEnd.Text = tkt.ScheduledEndDate.ToString
    Else
      lblScheduledDateEnd.Text = strBlankDateSpacer
    End If
    If tkt.ServiceStartDate <> datNothing Then
      lblServiceStartDate.Text = tkt.ServiceStartDate.ToString
    Else
      lblServiceStartDate.Text = strBlankDateSpacer
    End If
    If tkt.ServiceEndDate <> datNothing Then
      lblServiceEndDate.Text = tkt.ServiceEndDate.ToString
    Else
      lblServiceEndDate.Text = strBlankDateSpacer
    End If
    If tkt.CompletedDate <> datNothing Then
      lblCompletedDate.Text = tkt.CompletedDate.ToString
    Else
      lblCompletedDate.Text = strBlankDateSpacer
    End If
    lblWarrantyTerm.Text = wtm.Term
    If lblNotes.Text.Trim.Length > 0 Then
      divNotesSpacer.Visible = False
    Else
      divNotesSpacer.Visible = True
    End If
    LoadComponents()
  End Sub
  
  Private Sub LoadComponents()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListTicketComponents", "@TicketID", _ID, dgvComponents)
    Dim rpt As Repeater
    For Each itm As System.Web.UI.WebControls.DataGridItem In dgvComponents.Items
      rpt = itm.FindControl("rptLabels")
      If Not IsNothing(rpt) Then
        ldr.LoadSingleLongParameterRepeater("spListTicketComponentShippingLabels", "@TicketComponentID", CType(itm.Cells(0).Text, Long), rpt)
      End If
    Next
  End Sub

  Private Sub LoadPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterRepeater("spListTicketPhoneNumbers", "@TicketID", _ID, rptPhoneNumbers)
  End Sub
  
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>View Ticket</title>
    <link rel="stylesheet" type="text/css"  href="/stylesheets/paper.css" />
</head>
  <body class="paper">
    <form id="frmTicket" runat="server">
      <table style="width: 100%;">
        <tr>
          <td style="width: 64px;"><asp:Image ID="imgPriority" runat="server" /></td>
          <td class="ticketsectionheader" style="text-align: center;"><asp:Label ID="lblCompanyName" runat="server" /> Ticket</td>
          <td style="width: 64px;"><asp:Image ID="imgBarCode" runat="server" /></td>
        </tr>
      </table>    
      <table style="width: 100%">
        <tbody>
          <tr>
            <td>
              <div class="ticketsectionheader">Contact Information</div>
              <div><asp:Label ID="lblContact" runat="server" /></div>
              <div><asp:Label ID="lblAddress" runat="server" /></div>
              <div style="text-align: left;"><asp:Image ID="imgPostNet" runat="server" /></div>
            </td>
            <td>&nbsp;</td>
            <td>
              <div class="ticketsectionheader">Phone Numbers</div>
              <asp:Repeater ID="rptPhoneNumbers" runat="server">
                <ItemTemplate>
                  <div><span class="label"><%#DataBinder.Eval(Container.DataItem, "PhoneType")%>&nbsp;</span><%#DataBinder.Eval(Container.DataItem, "CountryCode")%>&nbsp;(<%#DataBinder.Eval(Container.DataItem, "AreaCode")%>)&nbsp;<%#DataBinder.Eval(Container.DataItem, "Exchange")%>-<%#DataBinder.Eval(Container.DataItem, "LineNumber")%>&nbsp;x:<%#DataBinder.Eval(Container.DataItem, "Extension")%>&nbsp;p:<%#DataBinder.Eval(Container.DataItem, "Pin")%></div>
                </ItemTemplate>
              </asp:Repeater>
            </td>
            <td>&nbsp;</td>
            <td>
              <div class="ticketsectionheader">Ticket Information</div>
              <table cellspacing="0">
                <tr>
                  <td class="label">Ticket ID</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblTicketID" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Status</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblStatus" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Created</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblDateCreated" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Start By</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRequestedStartDate" runat="server" /></td>
                </tr>              
                <tr>
                  <td class="label">End By</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRequestedEndDate" runat="server" /></td>
                </tr>
              </table>
            </td>
          </tr>        
        </tbody>
      </table>
      <div>&nbsp;</div>
      <div class="ticketsectionheader">Reference Numbers</div>
      <table style="width: 100%">
        <tbody>
          <tr>
            <td class="label"><asp:Label ID="lblRef1Label" runat="server" /></td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblRef1" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label"><asp:Label ID="lblRef2Label" runat="server" /></td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblRef2" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label"><asp:Label ID="lblRef3Label" runat="server" /></td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblRef3" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label"><asp:Label ID="lblRef4Label" runat="server" /></td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblRef4" runat="server" /></td>
          </tr>      
        </tbody>
      </table>
      <div>&nbsp;</div>
      <div class="ticketsectionheader">Scheduling</div>
      <table>
        <tbody>
          <tr>
            <td class="label">Appt. Start</td>
            <td>&nbsp;</td>
            <td><asp:label ID="lblScheduledDate" runat="server" /></td>
            <td class="label">Appt. End</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblScheduledDateEnd" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Ticket Completed</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblCompletedDate" runat="server" /></td>          
          </tr>
        </tbody>
      </table>    
      <div>&nbsp;</div>
      <div class="ticketsectionheader">Service Information</div>
      <table>
        <tbody>
          <tr>
            <td class="label">Service Type</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblServiceType" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Service</td>
            <td><asp:label ID="lblService" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Service Started</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblServiceStartDate" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Service Ended</td>
            <td><asp:Label ID="lblServiceEndDate" runat="server" /></td>
          </tr>
        </tbody>
      </table>
      <table>
        <tbody>
          <tr>
            <td class="label">Manufacturer</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblManufacturer" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Model</td>
            <td><asp:label ID="lblModel" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Serial Number</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblSerialNumber" runat="server" /></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class="label">Purchase Date</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblPurchaseDate" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Warranty Term</td>
            <td><asp:label ID="lblWarrantyTerm" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Warranty Start</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblWarrantyStart" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Warranty End</td>
            <td><asp:Label ID="lblWarrantyEnd" runat="server" /></td>
          </tr>        
        </tbody>
      </table>
      <div>&nbsp;</div>
      <div class="ticketsectionheader">On Site Instructions</div>
      <asp:Label ID="lblDescription" runat="server" />
      <div>&nbsp;</div>
      <div class="ticketsectionheader">Description Of Work</div>
      <asp:Label ID="lblNotes" runat="server" />
      <div id="divNotesSpacer" runat="server" visible="false">
        <br />
        <br />
        <br />
        <br />
      </div>
      <div>&nbsp;</div>
      <div class="ticketsectionheader">Components/Parts</div>
      <asp:DataGrid ID="dgvComponents" runat="server" AutoGenerateColumns="false" style="width: 100%">
        <HeaderStyle Font-Bold="true" />
        <Columns>
          <asp:BoundColumn DataField="TicketComponentID" Visible="false" />
          <asp:BoundColumn DataField="Code" HeaderText="Code/SKU" />
          <asp:BoundColumn DataField="Component" HeaderText="Component Name" />
          <asp:BoundColumn DataField="SerialNumber" HeaderText="Serial Number" />
          <asp:BoundColumn DataField="Notes" HeaderText="Notes" />
          <asp:BoundColumn DataField="DateDelivered" HeaderText="Delivered" />
          <asp:BoundColumn DataField="Consumable" HeaderText="Consumable" />
          <asp:TemplateColumn HeaderText="Shipping Labels">
            <ItemTemplate>
              <asp:Repeater ID="rptLabels" runat="server">
                <ItemTemplate>
                  <div><span class="label"><%# DataBinder.Eval(Container.DataItem,"Courier") %>&nbsp;<%#DataBinder.Eval(Container.DataItem, "Destination")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "Method")%>&nbsp;</span><%# DataBinder.Eval(Container.DataItem,"ShippingLabel") %></div>
                </ItemTemplate>
              </asp:Repeater>
            </ItemTemplate>
          </asp:TemplateColumn>
        </Columns>
      </asp:DataGrid>
    </form>
  </body>
</html>
