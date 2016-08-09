<%@ Page Language="VB" masterpagefile="~/masters/customer.master" ValidateRequest="false"%>
<%@ MasterType VirtualPath="~/masters/customer.master" %>
<%@ Register Src="~/controls/ticket.ascx" TagName="Ticket" TagPrefix="cv" %>
<script language="VB" runat="server">
  
  Private _ID As Long = 0
  Private _ReadOnly As Boolean = False
   
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Dim lgn As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strMode As String = ""
      If CType(Request.QueryString("mode"), String) <> "" Then
        strMode = Request.QueryString("mode")
      End If       
      Dim strHeaderText As String = "View Ticket"
      lgn.Load(CType(User.Identity.Name, Long))
      If lgn.WebLoginID > 0 Then
        Try
          _ID = CType(Request.QueryString("id"), Long)
        Catch ex As Exception
          _ID = 0
        End Try
        Master.WebLoginID = lgn.WebLoginID
        Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("CompanyName") & " Client Access [Ticket]"
        Master.PageHeaderText = strHeaderText
        Secure()
        If Not IsPostBack Then          
          LoadTicket()
        End If
      Else
        Response.Redirect("/login.aspx", True)
      End If
    Else
      Response.Redirect("/login.aspx", True)
    End If
  End Sub

  Private Sub Secure()
    Dim cag As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cag.Load(Master.CustomerAgentID)
    Dim tkt As New BridgesInterface.TicketRecord(cag.ConnectionString)
    tkt.Load(_ID)
    Dim srv As New BridgesInterface.ServiceRecord(cag.ConnectionString)
    srv.Load(tkt.ServiceID)
    If tkt.CustomerID <> Master.CustomerID Then
      divTicket.Visible = False
      divNoAccess.Visible = True
    Else
      _ReadOnly = cag.ServiceTypeReadOnly(srv.ServiceTypeID)
      If _ReadOnly Then
        txtTicketNote.Enabled = False
        txtTicketNote.ReadOnly = True
        btnAddNote.Enabled = False
        'lnkEditTicket.Visible = False
        'lnkAddComponent.Visible = False
        lnkAddPhone.Visible = False
        lnkPriority.Visible = False
      Else
        lnkPriority.Visible = True
        txtTicketNote.Enabled = True
        txtTicketNote.ReadOnly = False
        btnAddNote.Enabled = True
        'lnkEditTicket.Visible = False
      End If
    End If
  End Sub
  
  Private Sub LoadReferenceLabels(ByVal lngID As Long)
    Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    cst.Load(lngID)
    If cst.Ref1Label.Trim.Length > 0 Then
      lblRef1Label.Text = cst.Ref1Label
    Else
      lblRef1Label.Text = "Reference # 1"
    End If
    If cst.Ref2Label.Trim.Length > 0 Then
      lblRef2Label.Text = cst.Ref2Label
    Else
      lblRef2Label.Text = "Reference # 2"
    End If
    If cst.Ref3Label.Trim.Length > 0 Then
      lblRef3Label.Text = cst.Ref3Label
    Else
      lblRef3Label.Text = "Reference # 3"
    End If
    If cst.Ref4Label.Trim.Length > 0 Then
      lblRef4Label.Text = cst.Ref4Label
    Else
      lblRef4Label.Text = "Reference # 4"
    End If
  End Sub
  
  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim tst As New BridgesInterface.TicketStatusRecord(tkt.ConnectionString)
    Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
    Dim svt As New BridgesInterface.ServiceTypeRecord(tkt.ConnectionString)
    Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
    Dim wtm As New BridgesInterface.WarrantyTermRecord(tkt.ConnectionString)
    Dim strBlankDateSpacer As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    Dim datNothing As Date = Nothing
    Dim strHtml As String = ""
    tkt.Load(_ID)
    If _ID = 78021 Then
      spnPDF.Visible = True
    End If
    LoadReferenceLabels(tkt.CustomerID)
    tst.Load(tkt.TicketStatusID)
    stt.Load(tkt.StateID)
    srv.Load(tkt.ServiceID)
    svt.Load(srv.ServiceTypeID)
    wtm.Load(tkt.WarrantyTermID)
    If lblReturnUrl.Text.Trim.Length = 0 Then
      lblReturnUrl.Text = "customer.aspx?id=" & tkt.CustomerID
    End If
    'imgBarCode.ImageUrl = "barcode.aspx?value=" & tkt.TicketID & "&height=32&type=128"
    imgPostNet.ImageUrl = "barcode.aspx?value=" & tkt.ZipCode & "&height=5&type=PostNet"
    imgPriority.ImageUrl = "/graphics/level" & tkt.CustomerPrioritySetting & ".png"
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
    'lblDescription.Text = tkt.Description.Replace(Environment.NewLine, "<br />")
    lblNotes.Text = tkt.Notes.Replace(Environment.NewLine, "<br />")
    lblTicketID.Text = tkt.TicketID
    lblStatus.Text = tst.Status
    lblDateCreated.Text = tkt.DateCreated.ToString
    If tkt.ReferenceNumber1.Trim.Length > 0 Then
      lblRef1.Text = tkt.ReferenceNumber1
    Else
      lblRef1.Text = "&nbsp;"
    End If
    If tkt.ReferenceNumber2.Trim.Length > 0 Then
      lblRef2.Text = tkt.ReferenceNumber2
    Else
      lblRef2.Text = "&nbsp;"
    End If
    If tkt.ReferenceNumber3.Trim.Length > 0 Then
      lblRef3.Text = tkt.ReferenceNumber3
    Else
      lblRef3.Text = "&nbsp;"
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
    'If lblNotes.Text.Trim.Length > 0 Then
    '  divNotesSpacer.Visible = False
    'Else
    '  divNotesSpacer.Visible = True
    'End If
    LoadComponents()
    LoadNotes()
    LoadAttachedDocuments(tkt.TicketID)
    'lnkPrintable.Target = "_blank"
    'lnkPrintable.HRef = "printableticket.aspx?id=" & tkt.TicketID
    lnkAddPhone.HRef = "addphone.aspx?id=" & tkt.TicketID & "&mode=ticket&returnurl=ticket.aspx%3fid=" & tkt.TicketID
    'lnkAddComponent.HRef = "addcomponent.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
    'lnkEditTicket.HRef = "editticket.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID
    lnkPriority.HRef = "editpriority.aspx?id=" & tkt.TicketID
  End Sub
  
  Private Sub LoadComponents()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListTicketComponents", "@TicketID", _ID, dgvComponents)
    Dim dgv As System.Web.UI.WebControls.DataGrid
    For Each itm As System.Web.UI.WebControls.DataGridItem In dgvComponents.Items
      dgv = itm.FindControl("dgvLabels")
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spListTicketComponentShippingLabels", "@TicketComponentID", CType(itm.Cells(0).Text, Long), dgv)
      End If
    Next
  End Sub
  
  Private Sub LoadNotes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListCustomerTicketNotes", "@TicketID", _ID, dgvNotes)
  End Sub

  Private Sub btnAddNote_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsNoteComplete() Then
      Dim strChangeLog As String = ""
      Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      tnt.Add(_ID, Master.WebLoginID, Master.UserID, txtTicketNote.Text.Replace(">", "&gt;").Replace("<", "&lt;"))
      tnt.CustomerVisible = True
      tnt.PartnerVisible = False
      tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Customer
      tnt.Acknowledged = False
      tnt.Save(strChangeLog)
      Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cst.Load(Master.CustomerID)
      If cst.InternalEmail.Trim.Length > 0 Then
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        Dim car As New BridgesInterface.CustomerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        car.Load(Master.CustomerAgentID)
        If car.Email.Trim.Length > 0 Then
          eml.SendFrom = car.Email
        Else
          eml.SendFrom = cst.InternalEmail
        End If
        eml.SendTo = cst.InternalEmail
        eml.Subject = "Note Added To " & _ID
        eml.Body = "<p>A new note was added to ticket: <a href=""https://www.NationalApplianceNetwork.com/agentinterface/ticket.aspx?id=" & _ID & """>" & _ID & "</a></p>"
        eml.Body &= "<p>" & txtTicketNote.Text & "</p>"
        'eml.Send()
      End If
      txtTicketNote.Text = ""
      LoadTicket()
    End If
  End Sub
  
  Private Function IsNoteComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtTicketNote.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Note must contain text</li>"
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub LoadPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListTicketPhoneNumbers", "@TicketID", _ID, dgvPhoneNumbers)
  End Sub

  Private Function MergeTrackingScript(ByVal strTrackingScript As String, ByVal strShippingLabel As String) As String
    Dim strReturn As String = strTrackingScript.Replace("$shippinglabel", strShippingLabel)
    Return strReturn
  End Function
  
  Private Function CurrentID() As Long
    Return _ID
  End Function

  Private Function AddShippingLabelLink(ByVal lngTicketComponentID As Long) As String
    Dim strReturn As String = ""
    If _ReadOnly Then
      strReturn = "&nbsp;"
    Else
      strReturn = "<a href=""addshippinglabel.aspx?id=" & lngTicketComponentID.ToString & "&returnurl=ticket.aspx%3fid=" & _ID.ToString & """>[Add Shipping Label]</a>"
    End If
    Return strReturn
  End Function

  Private Function EditShippingLabelLink(ByVal lngShippingLabelID As Long) As String
    Dim strReturn As String = ""
    If _ReadOnly Then
      strReturn = "&nbsp;"
    Else
      strReturn = "<a href=""editshippinglabel.aspx?id=" & lngShippingLabelID.ToString & "&returnurl=ticket.aspx%3fid=" & _ID.ToString & """>Edit</a>"
    End If     
    Return strReturn
  End Function

  Private Function EditComponentLink(ByVal lngComponentID As Long) As String
    Dim strReturn As String = ""
    If _ReadOnly Then
      strReturn = "&nbsp;"
    Else
      strReturn = "<a href=""editcomponent.aspx?id=" & lngComponentID.ToString & "&returnurl=ticket.aspx%3fid=" & _ID.ToString & """>Edit</a>"
    End If
    Return strReturn
  End Function

  Private Function EditPhoneLink(ByVal lngTicketPhoneNumberID As Long) As String
    Dim strReturn As String = ""
    If _ReadOnly Then
      strReturn = "&nbsp;"
    Else
      strReturn = "<a href=""editphone.aspx?returnurl=ticket.aspx%3fid=" & _ID.ToString & "&id=" & lngTicketPhoneNumberID.tostring & "&mode=ticket"">Edit</a>"
    End If
    Return strReturn
  End Function
  
  Private Function ShipToText(ByVal lngWorkOrderID As Object) As String
    Dim lngID As Long = 0
    If Not IsDBNull(lngWorkOrderID) Then
      lngID = lngWorkOrderID
    Else
      lngID = 0
    End If
    Dim strReturn As String = ""
    Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    wrk.Load(lngID)
    If wrk.WorkOrderID > 0 Then
      Dim pad As New BridgesInterface.PartnerAddressRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      pad.Load(wrk.PartnerAddressID)
      strReturn = "<div>" & pad.Street & "</div>"
      If pad.Extended.Trim.Length > 0 Then
        strReturn &= "<div>" & pad.Extended & "</div>"
      End If
      Dim stt As New BridgesInterface.StateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      stt.Load(pad.StateID)
      strReturn &= "<div>" & pad.City & ", " & stt.Abbreviation & ". " & pad.ZipCode & "</div>"
    End If
    Return strReturn
  End Function
Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect("TicketDocumentsUpload.aspx?fid=0" & "&id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID & "&mode=doc&updt=0")
    End Sub
    
    Private Sub Item_Click(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs)
        Dim strTest As String
        
        strTest = (CType(e.CommandSource, LinkButton)).CommandName
        Select Case (CType(e.CommandSource, LinkButton)).CommandName
            
            Case "View"
                Dim exp As New cvCommon.Export
                Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("WOCnn"))
                Dim lngID As Long
                
                lngID = CType(e.Item.Cells(2).Text, Long)
                strTest = e.Item.Cells(2).Text
                fil.Load(lngID)
                exp.BinaryFileOut(Response, fil, System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection"))
            Case "Update"
                Dim lngFileID As Long
                lngFileID = CType(e.Item.Cells(2).Text, Long)
                Response.Redirect("TicketDocumentsUpload.aspx?fid=" & CType(e.Item.Cells(0).Text, Long) & "&id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID & "&mode=doce&updt=" & lngFileID)

            Case "Remove"

                'Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("WOCnn"))
                'Dim tkd As New BridgesInterface.TicketDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'Dim lngFilID As Long
                'Dim DocID As Long
                'DocID = CType(e.Item.Cells(0).Text, Long)
                'lngFilID = CType(e.Item.Cells(2).Text, Long)
                'tkd.Load(DocID)
                'fil.Load(lngFilID)
                'fil.Delete()
                'tkd.Delete()
                'Dim strChangelog As String = ""
                'Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                'tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Auto Note: Attachment has been removed from this ticket: " & e.Item.Cells(1).Text)
                'tnt.CustomerVisible = False
                'tnt.PartnerVisible = False
                'tnt.Acknowledged = True
                'tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                'tnt.Save(strChangelog)
                'Response.Redirect("Ticket.aspx?id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID)

        End Select
    End Sub
  Private Sub LoadAttachedDocuments(ByVal lngTicketID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSingleLongParameterDataGrid("spGetTicketDocuments", "@TicketID", lngTicketID, dgvAttachments)
    End Sub
</script>

<asp:Content ContentPlaceHolderID="bodycontent" runat="server">
  <form id="frmTicket" runat="server" style="background-color: #EAEAEA;">
    <div id="divTicket" runat="server" visible="true">
      <div id="divErrors" runat="server" class="errorzone" visible="false" />
      <table style="width: 100%; background-color: White;">
        <tbody>
        </tbody>
      </table>    
      <table style="width: 100%;">
        <tbody>
          <tr>
            <td>
              <div class="ticketformsectionheader">Contact Information</div>
              <div><asp:Label ID="lblContact" runat="server" /></div>
              <div><asp:Label ID="lblAddress" runat="server" /></div>
              <div style="text-align: left;"><asp:Image ID="imgPostNet" runat="server" /></div>
               <asp:Image ID="imgPriority" runat="server" /><a id="lnkPriority" runat="server">[Change Priority]</a>

            </td>
            <td>&nbsp;</td>
            <td>
              <div class="ticketformsectionheader">Phone Numbers</div>
              <asp:DataGrid style="width:100%; background-color: White;" ID="dgvPhoneNumbers" runat="server" AutoGenerateColumns="false">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />
                <Columns>
                  <asp:BoundColumn
                    DataField="PhoneType"
                    HeaderText="Type"
                    ItemStyle-Wrap="false"
                    />                    
                  <asp:TemplateColumn
                    HeaderText="Phone Number"
                    ItemStyle-Wrap="false"
                    >
                    <ItemTemplate>
                      <%# Databinder.eval(Container.DataItem, "CountryCode") %> (<%# Databinder.eval(Container.DataItem, "AreaCode") %>) <%# Databinder.eval(Container.DataItem, "Exchange") %>-<%# Databinder.eval(Container.DataItem, "LineNumber") %>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn
                    DataField="Extension"
                    headertext="Extension"
                    />
                  <asp:BoundColumn
                    DataField="Pin"
                    headertext="Pin"
                    />
                  <asp:TemplateColumn 
                    HeaderText="Active"
                    >             
                    <ItemTemplate>
                      <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                    </ItemTemplate>
                  </asp:TemplateColumn>                              
                  <asp:TemplateColumn
                    HeaderText="Command"
                    >
                    <Itemtemplate>
                      <%#EditPhoneLink(DataBinder.Eval(Container.DataItem, "TicketPhoneNumberID"))%>
                    </Itemtemplate>
                  </asp:TemplateColumn>                            
                </Columns>                
              </asp:DataGrid>
              <div style="text-align: right;"><a id="lnkAddPhone" runat="server">[Add Phone Number]</a></div>
            </td>
            <td>&nbsp;</td>
            <td>
              <div class="ticketformsectionheader">Ticket Information</div>
              <table cellspacing="0">
                <tr>
                  <td class="label">Ticket ID</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblTicketID" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label" visible="False"></td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblStatus" runat="server" visible="False"/><span id="spnPDF" runat="server" visible="false"><a href="78021.PDF">View Signed</a></span></td>                  
                </tr>
                <tr>
                  <td class="label">Created</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblDateCreated" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Req. Start</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRequestedStartDate" runat="server" /></td>
                </tr>              
                <tr>
                  <td class="label">Req. End</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRequestedEndDate" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Ticket Completed</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblCompletedDate" runat="server" /></td>                 
                </tr>                
              </table>
            </td>
          </tr>        
        </tbody>
      </table>
      <div>&nbsp;</div>
      <div class="ticketformsectionheader">Reference Numbers</div>
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
      <div class="ticketformsectionheader">Scheduling</div>
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
          </tr>
        </tbody>
      </table>    
      <div>&nbsp;</div>
      <div class="ticketformsectionheader">Service Information</div>
        <table>
        <tbody>
          <tr>
            <td class="label">Program</td>
            <td>&nbsp;</td>
            <td><asp:Label ID="lblServiceType" runat="server" /></td>
            <td>&nbsp;</td>
            <td class="label">Service SKU</td>
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
            <td></td>
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
            <td></td>
          </tr>        
        </tbody>
      </table>
        <div class="ticketformsectionheader">Description Of Work</div>
        <table width ="100%">
        <tr>
          <td valign ="top">
             <asp:Label ID="lblNotes" runat="server" />
              <br /> 
          </td>
        <td valign ="top" style="background-color: White; width:36%;  height:100%;">
         <div class="inputformsectionheader"><b>Attachments</b>(Click the add button to upload a file)</div>
                  <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" Width ="30%" />      
                  <asp:DataGrid style="width:100%" ID="dgvAttachments" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="Item_Click">
                    <ItemStyle CssClass="bandbar" />
                      <Columns>
                        <asp:BoundColumn DataField="TicketDocumentID" HeaderText="ID" Visible="false" />
                        <asp:BoundColumn DataField="Description" HeaderText="DocType" Visible="True" />
                        <asp:BoundColumn DataField="FileID" HeaderText="FileID" Visible="false" />
                        <asp:ButtonColumn Text="View" CommandName ="View" ></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Update" CommandName="Update"></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Remove" CommandName="Remove" visible="false"></asp:ButtonColumn> 
                     </Columns>              
                  </asp:DataGrid> 
        </td>
        </tr>
      </table>  
      <div class="ticketformsectionheader">Components/Parts</div>
      <asp:DataGrid ID="dgvComponents" runat="server" AutoGenerateColumns="false" style="width: 100%; background-color: White;">
        <HeaderStyle CssClass="gridheader" />
        <AlternatingItemStyle CssClass="altrow" />      
        <Columns>      
          <asp:BoundColumn DataField="TicketComponentID" Visible="false" />
          <asp:BoundColumn DataField="Code" HeaderText="Part SKU" />
          <asp:BoundColumn DataField="Component" HeaderText="Component Name" />
          <asp:TemplateColumn HeaderText="Shipping Labels">
            <ItemTemplate>
              <asp:DataGrid ID="dgvLabels" style="width: 100%" runat="server" AutoGenerateColumns="false">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />
                <ItemStyle BackColor="white" />
                <Columns>
                  <asp:BoundColumn DataField="ShippingLabelID" Visible="false" />
                  <asp:BoundColumn HeaderText="Courier" DataField="Courier" />
                  <asp:BoundColumn DataField="Destination" HeaderText="Destination" />
                  <asp:BoundColumn HeaderText="Method" DataField="Method" />
                  <asp:TemplateColumn HeaderText="Label">
                    <ItemTemplate>
                      <a target="_blank" href="<%# Databinder.eval(Container.DataItem,"TrackingScript").ToString.Replace("$shippinglabel",DataBinder.Eval(Container.DataItem,"ShippingLabel")) %>"><%# DataBinder.Eval(Container.DataItem,"ShippingLabel") %></a>                    
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn>
                    <ItemTemplate>
                      <%#EditShippingLabelLink(DataBinder.Eval(Container.DataItem, "ShippingLabelID"))%>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                </Columns>
              </asp:DataGrid>
            </ItemTemplate>
          </asp:TemplateColumn>
        </Columns>
      </asp:DataGrid>
      <div>&nbsp;</div>
      <div class="ticketformsectionheader">Activity Notes</div>
      <div class="label">Quick Add Note</div>
      <asp:TextBox ID="txtTicketNote" TextMode="MultiLine" runat="server" style="width: 99%" Height="75px" />
      <div style="text-align: right;"><asp:Button ID="btnAddNote" Text="Add Note" OnClick="btnAddNote_Click" runat="server" /></div>
      <div>&nbsp;</div>
      <asp:DataGrid ID="dgvNotes" runat="server" ShowHeader="false" AutoGenerateColumns="false" style="width: 100%; background-color: White;">
        <AlternatingItemStyle CssClass="altrow" />      
        <Columns>
          <asp:TemplateColumn ItemStyle-Width="1%" ItemStyle-VerticalAlign="top" >
            <ItemTemplate>
              <div style="white-space:nowrap;"><%# Databinder.eval(Container.DataItem, "DateCreated") %></div>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:TemplateColumn ItemStyle-Wrap="true">
            <Itemtemplate>
            &nbsp;<%# Databinder.eval(Container.DataItem, "NoteBody").ToString.Replace(environment.NewLine,"<br />") %>
            </Itemtemplate>
          </asp:TemplateColumn>
        </Columns>
      </asp:DataGrid>    
      <asp:Label id="lblReturnUrl" runat="server" Visible="false" />
    </div>
    <div id="divNoAccess" runat="server" visible="false">
      <div style="text-align: center;">We're sorry your account does not have sufficient access to use this feature. Please see your account administrator for more information.</div>
    </div>
  </form>
</asp:Content>