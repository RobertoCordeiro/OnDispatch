<%@ Page Language="VB" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

  Private _ID As Long = 0
  Private _TicketID As Long = 0
  
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
        lblPhoneNumber.Text = System.Configuration.ConfigurationManager.AppSettings ("PhoneNumber")
        lblFax.Text = System.Configuration.ConfigurationManager.AppSettings ("FaxNumber")        
        LoadWorkOrder()
      Else
        frmTicket.Visible = False
      End If
    End If
  End Sub

  Private Sub LoadWorkOrder()
    Dim datNothing As Date = Nothing
    Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    wrk.Load(_ID)
    _TicketID = wrk.TicketID
    If wrk.Arrived <> datNothing Then
      lblArrived.Text = wrk.Arrived.Month.ToString & "/" & wrk.Arrived.Day.ToString("00") & "/" & wrk.Arrived.Year.ToString("0000")
      lblArrivedTime.Text = wrk.Arrived.Hour.ToString("00") & ":" & wrk.Arrived.Minute.ToString("00")
    End If
    If wrk.Departed <> datNothing Then
      lblDepartedTime.Text = wrk.Departed.Hour.ToString("00") & ":" & wrk.Departed.Minute.ToString("00")
    End If
    If wrk.ClosingAgent > 0 Then
      Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      usr.Load(wrk.ClosingAgent)
      'lblClosingAgent.Text = usr.NameTag
    End If
    'lblSupportAgent.Text = wrk.TechSupportAgentName    
    'lblSurveyEmail.Text = wrk.SurveyEmail
    If wrk.ClosingAgent > 0 Then
      lblResolutionNote.Text = wrk.ResolutionNote
      'lblMileageStart.Text = wrk.MileageStart
      'lblMileageEnd.Text = wrk.MileageEnd
      'lblTravelTime.Text = wrk.TravelTime
      'lblHoldTime.Text = wrk.TimeOnHold
    End If
    If wrk.SurveyAuthorized Then
      lblSurveyAuthorized.Text = "Yes"
    Else
      If wrk.ClosingAgent > 0 Then
        lblSurveyAuthorized.Text = "No"
        'lblMileageStart.Text = wrk.MileageStart
        'lblMileageEnd.Text = wrk.MileageEnd
        'lblTravelTime.Text = wrk.TravelTime
        'lblHoldTime.Text = wrk.TimeOnHold
      End If
    End If
    lblDispatched.Text = wrk.DispatchDate
    lblWorkOrderID.Text = wrk.WorkOrderID
    'imgWorkOrderBarCode.ImageUrl = "barcode.aspx?value=" & wrk.WorkOrderID & "&height=32&type=128"
    LoadTicket()
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
    tkt.Load(_TicketID)
    cst.Load(tkt.CustomerID)
    tst.Load(tkt.TicketStatusID)
    stt.Load(tkt.StateID)
    srv.Load(tkt.ServiceID)
    svt.Load(srv.ServiceTypeID)
    wtm.Load(tkt.WarrantyTermID)
    'imgTicketBarCode.ImageUrl = "barcode.aspx?value=" & tkt.TicketID & "&height=32&type=128"
    'imgPostNet.ImageUrl = "barcode.aspx?value=" & tkt.ZipCode & "&height=5&type=PostNet"
    If tkt.Company.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Company & "</div>"
    End If
    strHtml &= "<div>" & tkt.ContactFirstName & " " & tkt.ContactMiddleName & " " & tkt.ContactLastName & "</div>"
    lblContact.Text = strHtml
    strHtml = "<div>" & tkt.Street & "</div>"
    If tkt.Extended.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Extended & "</div>"
    End If
    strHtml &= "<div>" & tkt.City & " " & stt.Abbreviation & ", " & tkt.ZipCode
    lblAddress.Text = strHtml
    LoadPhoneNumbers(tkt.TicketID)
    lblDescription.Text = tkt.Description.Replace(Environment.NewLine, "<br />")
    lblNotes.Text = tkt.Notes.Replace(Environment.NewLine, "<br />")
    lblTicketID.Text = tkt.TicketID
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
      'lblRef3Label.Text = cst.Ref3Label
    Else
      'lblRef3Label.Text = "Ref 3"
    End If
    If tkt.ReferenceNumber3.Trim.Length > 0 Then
      'lblRef3.Text = tkt.ReferenceNumber3
    Else
      'lblRef3.Text = "&nbsp;"
    End If
    If cst.Ref4Label.Trim.Length > 0 Then
      'lblRef4Label.Text = cst.Ref4Label
    Else
      'lblRef4Label.Text = "Ref 4"
    End If
    If tkt.ReferenceNumber4.Trim.Length > 0 Then
      'lblRef4.Text = tkt.ReferenceNumber4
    Else
      'lblRef4.Text = "&nbsp;"
    End If
    'lblRequestedStartDate.Text = tkt.RequestedStartDate
    'lblRequestedEndDate.Text = tkt.RequestedEndDate
    lblServiceType.Text = svt.ServiceType
    lblService.Text = srv.ServiceName
    lblManufacturer.Text = tkt.Manufacturer
    lblModel.Text = tkt.Model
    lblSerialNumber.Text = tkt.SerialNumber
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
    LoadComponents(tkt.TicketID)
  End Sub
  
  Private Sub LoadComponents(ByVal lngTicketID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListTicketComponents", "@TicketID", lngTicketID, dgvComponents)
    Dim rpt As Repeater
    For Each itm As System.Web.UI.WebControls.DataGridItem In dgvComponents.Items
      rpt = itm.FindControl("rptLabels")
      If Not IsNothing(rpt) Then
        ldr.LoadSingleLongParameterRepeater("spListTicketComponentShippingLabels", "@TicketComponentID", CType(itm.Cells(0).Text, Long), rpt)
      End If
    Next
  End Sub

  Private Sub LoadPhoneNumbers(ByVal lngTicketID As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterRepeater("spListTicketPhoneNumbers", "@TicketID", lngTicketID, rptPhoneNumbers)
  End Sub
  
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Work Order</title>
    <link rel="stylesheet" type="text/css"  href="/stylesheets/paper.css" />
</head>
  <body class="paper">
    <form id="frmTicket" runat="server">
      <table style="width: 100%;">
        <tr>
          <td class="label" style="text-align: center; font-size: x-large;"><asp:Label ID="lblCompanyName" runat="server" />, Inc.</td>
        </tr>
        <tr>
          <td style="text-align: center; font-size:  small;">Phone:<asp:Label ID="lblPhoneNumber" runat="server" /> / Fax:<asp:Label ID="lblFax" runat="server" /></td>
        </tr>
      </table> 
      <div style="border-bottom: solid 1px Black;">&nbsp;</div>
      <table style="width: 100%">
        <tbody>
          <tr>
          <td>
              <div class="ticketsectionheader">Ticket Information</div>
              <table cellspacing="0">
                <tr>
                  <td class="label">Ticket ID</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblTicketID" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Work Order ID</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblWorkOrderID" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Dispatched</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblDispatched" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label"><asp:Label ID="lblRef1Label" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef1" runat="server" /></td>
                </tr>              
                <tr>
                  <td class="label"><asp:Label ID="lblRef2Label" runat="server" /></td>
                    <td>&nbsp;</td>
                    <td><asp:Label ID="lblRef2" runat="server" /></td>
                </tr>
              </table>
              <div class="ticketsectionheader">End User Information</div>
              <div class="label"><asp:Label ID="lblContact" runat="server" /></div>
              <div class="label"><asp:Label ID="lblAddress" runat="server" /></div>
              <asp:Repeater ID="rptPhoneNumbers" runat="server">
              <ItemTemplate>
                  <div><span class="label"><%#DataBinder.Eval(Container.DataItem, "PhoneType")%>&nbsp;</span><%#DataBinder.Eval(Container.DataItem, "CountryCode")%>&nbsp;(<%#DataBinder.Eval(Container.DataItem, "AreaCode")%>)&nbsp;<%#DataBinder.Eval(Container.DataItem, "Exchange")%>-<%#DataBinder.Eval(Container.DataItem, "LineNumber")%>&nbsp;x:<%#DataBinder.Eval(Container.DataItem, "Extension")%>&nbsp;p:<%#DataBinder.Eval(Container.DataItem, "Pin")%></div>
                </ItemTemplate>
              </asp:Repeater>
           </td>
           <td>
              <div class="ticketsectionheader">Unit Information</div>
              <table>
                <tbody>
                  <tr>
                    <td class="label">Unit Type:</td>
                    <td>&nbsp;</td>
                    <td><asp:Label ID="lblManufacturer" runat="server" /></td>
                  </tr>
                  <tr>
                    <td class="label">Model</td>
                    <td>&nbsp;</td>
                    <td><asp:label ID="lblModel" runat="server" /></td>
                  </tr>
                  <tr>
                    <td class="label">Serial Number</td>
                    <td>&nbsp;</td>
                    <td><asp:Label ID="lblSerialNumber" runat="server" /></td>
                  </tr>
                  <tr>
                    <td class="label">Purchase Date</td>
                    <td>&nbsp;</td>
                    <td><asp:Label ID="lblPurchaseDate" runat="server" /></td>
                  </tr>
                </tbody>
              </table> 
              <div class="ticketsectionheader">Service Type</div>
              <table>
                <tbody>
                  <tr>
                    <td class="label">Program</td>
                    <td>&nbsp;</td>
                    <td><asp:Label ID="lblServiceType" runat="server" /></td>                  
                  </tr>
                  <tr>
                    <td class="label">Service SKU</td>
                    <td>&nbsp;</td>
                    <td><asp:label ID="lblService" runat="server" /></td>                  
                  </tr>
                  <tr>
                    <td class="label">Appt. Start</td>
                    <td>&nbsp;</td>
                    <td><asp:label ID="lblScheduledDate" runat="server" /></td>
                  </tr>
                  <tr>
                    <td class="label">Appt. End</td>
                    <td>&nbsp;</td>
                    <td><asp:Label ID="lblScheduledDateEnd" runat="server" /></td>
                  </tr>
                </tbody>
              </table>
           </td>
          </tr> 
        </tbody>
      </table>
      <div class="ticketsectionheader">Problem Description</div>
      <asp:Label ID="lblNotes" runat="server" style="width:100%"/>
      <div>&nbsp;</div>
      <div class="ticketsectionheader">Parts</div>
      <asp:DataGrid ID="dgvComponents" runat="server" AutoGenerateColumns="false" style="width: 100%">
        <HeaderStyle Font-Bold="true" />
        <Columns>
          <asp:BoundColumn DataField="TicketComponentID" Visible="false" />
          <asp:BoundColumn DataField="Code" HeaderText="Part Number" />
          <asp:BoundColumn DataField="Component" HeaderText="Part Description" />
          <asp:TemplateColumn HeaderText="Tracking Number">
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
      <div>&nbsp;</div>
      <div class="ticketsectionheader">Onsite Visit Information - Service Technician to Fill Out the Blanks</div>
      <table  frame="box" style="width: 100%; " >
        <tbody>
          <tr style="height:20px;">
            <td style="width:1%" class="label">Service Date:</td>
            <td style="width: 31%; border-bottom: solid 1px white;">&nbsp;<asp:Label ID="lblArrived" runat="server" /></td>
            <td style="width:1%" class="label">Unit Model Number:</td>
            <td style="width: 31%; border-bottom: solid 1px white;"><asp:Label ID="lblMileageEnd" runat="server" />&nbsp;</td>
          </tr>
          <tr style="height:20px;">
            <td style="width:1%" class="label">Arrival Time:</td>
            <td style="width: 31%; border-bottom: solid 1px white;">&nbsp;<asp:Label ID="lblArrivedTime" runat="server" /></td>
            <td style="width:1%" class="label">Unit Serial Number:</td>
            <td style="width: 31%; border-bottom: solid 1px white;">&nbsp;</td>
          </tr>
          <tr style="height:20px;">
            <td style="width:1%" class="label">Departure Time:</td>
            <td style="width: 31%; border-bottom: solid 1px white;">&nbsp;<asp:Label ID="lblDepartedTime" runat="server" /></td>
            <td style="width:1%" class="label">BOM Number (Refrigerators)</td>
            <td style="width: 31%; border-bottom: solid 1px white;">&nbsp;</td>
          </tr>
          <tr style="height:20px;">
            <td style="width:1%" class="label">Date of Purchase (DOP):</td>
            <td style="width: 31%; border-bottom: solid 1px white;">&nbsp;<asp:Label ID="lblSurveyAuthorized" runat="server" /></td>
            <td style="width:1%" class="label" >Version Number (TVs Only):</td>
            <td colspan="4" style="width: 31%; border-bottom: solid 1px white;">&nbsp;</td>
          </tr>  
          <tr style="height:20px;">
            <td style="width:1%" class="label"  >Problem Solved:</td>
            <td style="width: 31%; border-bottom: solid 1px white;"  >&nbsp;<asp:Label ID="Label1" runat="server" /></td>
            <td style="width:1%" class="label" >Closed from Site?</td>
            <td colspan="4"  style="width: 31%; border-bottom: solid 1px white;">&nbsp;</td>
          </tr> 
          <tr style="height:40px;">
            <td style="width:1%" class="label" rowspan="2">Customer Signature:</td>
            <td style="width: 31%; border-bottom: solid 1px white;"></td>
            <td style="width:1%" class="label" rowspan="2">Technician Signature:</td>
            <td style="width: 31%; border-bottom: solid 1px white;"></td>
            
          </tr>
        </tbody>
      </table>
      <div>&nbsp;</div>
      <div class="ticketsectionheader">Describe Service Performed:</div>
      <div><asp:Label ID="lblResolutionNote" runat="server" /></div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div class="ticketsectionheader">Special Instructions</div>
      <asp:Label ID="lblDescription" runat="server" />
    </form>
  </body>
</html>
