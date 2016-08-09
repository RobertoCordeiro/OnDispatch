<%@ Page Language="vb" masterpagefile="~/masters/partner.master" %>
<%@ MasterType VirtualPath="~/masters/partner.master" %>
<script runat="server">
  
  Private _ID As Long = 0
  Public _Act as string 
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
  
    Try
      _ID = CType(Request.QueryString("id"), Long)
      _Act = Request.QueryString("act")
    Catch ex As Exception
      _ID = 0
      _Act = Master.ActiveMenu
      
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If User.Identity.IsAuthenticated Then      
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " View Ticket"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " View Ticket"
      Master.ActiveMenu = _Act
    End If
    If _ID > 0 Then
            If Not IsPostBack Then
                Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                usr.LoadByWebLoginID(CType(User.Identity.Name, Long))
                If IsTicketAssignedToVendor(_ID, CType(User.Identity.Name, Long)) > 0 Then
                    LoadTicket()
                    
                    If CountPartsForTicket(_ID) > 0 Then
                        chkPreOrderParts.Visible = False
                    Else
                        chkPreOrderParts.Visible = True
                    End If
                Else
                    Response.Redirect(lblReturnUrl.Text, True)
                    
                End If
            End If
            Else
                Response.Redirect(lblReturnUrl.Text, True)
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
  
  Private Function MapIt(ByVal strAddress As String, ByVal strZipCode As String) As String
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
    strReturn = ggl.MapAddress(strAddress, strZipCode)
    Return strReturn
  End Function
  
  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim tst As New BridgesInterface.TicketStatusRecord(tkt.ConnectionString)
    Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
    Dim svt As New BridgesInterface.ServiceTypeRecord(tkt.ConnectionString)
    Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
    Dim zip As New BridgesInterface.ZipCodeRecord(tkt.ConnectionString)
    Dim wtm As New BridgesInterface.WarrantyTermRecord(tkt.ConnectionString)
    Dim strBlankDateSpacer As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    Dim datNothing As Date = Nothing
    Dim strHtml As String = ""    
    tkt.Load(_ID)
    LoadReferenceLabels(tkt.CustomerID)
    tst.Load(tkt.TicketStatusID)
    stt.Load(tkt.StateID)
    srv.Load(tkt.ServiceID)
    svt.Load(srv.ServiceTypeID)
    wtm.Load(tkt.WarrantyTermID)
    zip.Load(tkt.ZipCode)
    If zip.ZipCodeID > 0 Then
      lblLocalTime.Text = zip.LocalTime.Hour.ToString("00") & ":" & zip.LocalTime.Minute.ToString("00")
    Else
      lblLocalTime.Text = DateTime.Now.Hour.ToString("00") & ":" & DateTime.Now.Minute.ToString("00")
    End If
        'lnkAppt.HRef = "editticketappointment.aspx?id=" & tkt.TicketID & "&returnurl=ticket.aspx%3fid=" & tkt.TicketID & "&act=B"
    lnkMapIt.HRef = MapIt(tkt.Street, tkt.ZipCode)
    imgPostNet.ImageUrl = "barcode.aspx?value=" & tkt.ZipCode & "&height=5&type=PostNet"
    If tkt.Company.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Company & chr(10) & "</div>"
    End If
    strHtml &= "<div>" & tkt.ContactFirstName & " " & tkt.ContactMiddleName & " " & tkt.ContactLastName & chr(10) & "</div>"
    lblContact.Text = strHtml
    strHtml = "<div>" & tkt.Street & chr(10) & "</div>"
    If tkt.Extended.Trim.Length > 0 Then
      strHtml &= "<div>" & tkt.Extended & chr(10) & "</div>"
    End If
    strHtml &= "<div>" & tkt.City & " " & stt.Abbreviation & ", " & tkt.ZipCode
    lblAddress.Text = strHtml
    LoadPhoneNumbers()
    txtDescription.Text = tkt.Description.Replace("<br />", Environment.NewLine)
    txtNotes.Text = tkt.Notes.Replace("<br />", Environment.NewLine)
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
    lblService.Text = "<a href=""servicedetail.aspx?id=" & srv.ServiceID & """>" & srv.ServiceName & "</a>"
    lblManufacturer.Text = tkt.Manufacturer
    lblModel.Text = "<a target=""_blank"" href=""Manuals.aspx?id=" & tkt.Model & """>" & tkt.Model & "</a>"
        Dim strPartSerial As String
        strPartSerial = "*******" & Right(tkt.SerialNumber, 3)
        lblSerialNumber.Text = strPartSerial
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
   '   divNotesSpacer.Visible = True
    'End If
    LoadComponents()
    LoadNotes()
    LoadWorkOrders()
    LoadAttachedDocuments(tkt.TicketID)
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
  
  Private Sub LoadWorkOrders()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadTwoLongParameterDataGrid("spListDispatchedPartnerWorkOrdersForTicket", "@PartnerID", Master.PartnerID, "@TicketID", _ID, dgvWorkOrders)
  
  End Sub
  
  Private Sub LoadNotes()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerTicketNotes", "@TicketID", _ID, dgvNotes)
  End Sub

  Private Sub btnAddNote_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsNoteComplete() Then
      Dim strChangeLog As String = ""
            Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      tnt.Add(_ID, Master.WebLoginID, Master.UserID, txtTicketNote.Text)
      tnt.PartnerVisible = True
      tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Partner
      tnt.Acknowledged = False
      tnt.Save(strChangeLog)
      Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
      Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            par.Load(Master.PartnerAgentID)
            eml.Subject = "New Note Added by your Technician To Ticket:" & _ID
            eml.Body = txtTicketNote.Text
            If par.Email <> "" Then
                eml.SendFrom = par.Email
            Else
                eml.SendFrom = "partnersupport@bestservicers.com"
            End If
            tkt.Load(_ID)
            If Not IsDBNull(tkt.AssignedTo.ToString) Or tkt.AssignedTo <> 0 Then
                usr.Load(tkt.AssignedTo)
                eml.SendTo = usr.Email
            Else
                eml.SendTo = "services@bestservicers.com"
            End If
            
            eml.Send()
            txtTicketNote.Text = ""
            If chkPreOrderParts.Checked Then
               
                Dim fld As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                If tkt.TicketStatusID = 4 Or tkt.TicketStatusID = 11 Or tkt.TicketStatusID = 17 Then 'waiting parts,scheduled,Need Appt set
                    tkt.TicketStatusID = 14
                    tkt.Save(strChangeLog)
                
                    fld.Add(Master.UserID, _ID, 29)
                    fld.RemoveTicketFromFolder(_ID, 33)
                    fld.Save(strChangeLog)
                    
                    tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Auto Note: Status has been changed to Ordering Parts")
                    tnt.PartnerVisible = False
                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Partner
                    tnt.Acknowledged = False
                    tnt.Save(strChangeLog)
                
                    ClearAppt(_ID)
                    chkPreOrderParts.Checked = False
               
                Else
                    MsgBox("Please call into BSA Office and provide part numbers! Unable to move ticket to the parts department.")
                    
                End If
            End If
            
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
  
  Private Sub LoadAttachedDocuments(ByVal lngTicketID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSingleLongParameterDataGrid("spGetTicketDocumentsForVendors", "@TicketID", lngTicketID, dgvAttachments)
    End Sub
    
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

                Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("WOCnn"))
                Dim tkd As New BridgesInterface.TicketDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim lngFilID As Long
                Dim DocID As Long
                DocID = CType(e.Item.Cells(0).Text, Long)
                lngFilID = CType(e.Item.Cells(2).Text, Long)
                tkd.Load(DocID)
                fil.Load(lngFilID)
                fil.Delete()
                tkd.Delete()
                Dim strChangelog As String = ""
                Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Auto Note: Attachment has been removed from this ticket: " & e.Item.Cells(1).Text)
                tnt.CustomerVisible = False
                tnt.PartnerVisible = False
                tnt.Acknowledged = True
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Save(strChangelog)
                Response.Redirect("Ticket.aspx?id=" & _ID & "&returnurl=ticket.aspx?id=" & _ID)

        End Select
    End Sub
    Private Function UploadText(ByVal lngWorkOrderID As Long) As String
    Dim strReturn As String = ""
    Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    wrk.Load(lngWorkOrderID)
    If wrk.ClosingAgent <> 0 Then
      strReturn &= "<a href=""upload.aspx?id=" & lngWorkOrderID & "&returnurl=ticket.aspx%3fid=" & _ID & "&mode=wo"">[Upload]</a>"
    Else
      strReturn &= "&nbsp;"
    End If
    Return strReturn
  End Function
  
    Private Function IsTicketAssignedToVendor(ByVal lngTicketID As Long, ByVal lngWebloginID As Long) As Integer
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsTicketAssignedToVendor")
        Dim intReturn As Integer
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", System.Data.SqlDbType.Int).Value = lngTicketID
        cmd.Parameters.Add("@PartnerID", System.Data.SqlDbType.Int).Value = GetPartnerForWeblogin(lngWebLoginID)
        cnn.Open()
        cmd.Connection = cnn
        intReturn = cmd.ExecuteScalar()
        cnn.Close()
        IsTicketAssignedToVendor = intReturn
    End Function
    
    Private Function GetPartnerForWeblogin(ByVal lngWebloginID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPartnerForWeblogin")
        Dim lngReturn As Long
        lngReturn = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@WebloginID", System.Data.SqlDbType.Int).Value = lngWebloginID
        cnn.Open()
        cmd.Connection = cnn
        lngReturn = cmd.ExecuteScalar()
        cnn.Close()
        GetPartnerForWeblogin = lngReturn
    End Function
    
    Private Function SetAppointment(ByVal lngWorkOrderID As Object, ByRef lngPartnerID As Object) As String
        Dim strReturn As String = ""
        Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wrk.Load(lngWorkOrderID)
        If wrk.ClosingAgent = 0 Then
            strReturn &= "<a href=""editticketappointment2.aspx?id=" & _ID & "&pid=" & lngPartnerID & "&wid=" & lngWorkOrderID & "&returnurl=ticket.aspx%3fid=" & _ID & """>[Set Appt]</a>"
                                   
        Else
            strReturn &= "&nbsp;"
        End If
        Return strReturn
       
    End Function
    
    Private Function CountPartsForTicket(ByVal lngTicketID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountTicketComponentsForTicket")
       
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", System.Data.SqlDbType.Int).Value = lngTicketID
        cnn.Open()
        cmd.Connection = cnn
        CountPartsForTicket = cmd.ExecuteScalar()
        cnn.Close()
        
    End Function
    Private Sub DeleteScheduleAssignment(ByVal lngTicketID As Long)
  
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spDeleteScheduleAssignmentByTicketID")
  
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cnn.open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
   
    End Sub
    Private Sub ClearAppt(ByVal lngTicketID As Long)
       
        Dim strChangeLog As String = ""
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        tkt.Load(_ID)
        tkt.ScheduledDate = Nothing
        tkt.ScheduledEndDate = Nothing
        tkt.Save(strChangeLog)
        tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Auto Note: Appointment has been cleared BY TECHNICIAN so new one can be set.")
        tnt.CustomerVisible = True
        tnt.PartnerVisible = True
        tnt.Acknowledged = True
        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
        tnt.Save(strChangeLog)
        DeleteScheduleAssignment(_ID)
    End Sub
    
    Private Sub MsgBox(ByVal strMessage As String)
        'Begin building the script 
        Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
        strScript += "alert(""" & strMessage & """)" & vbCrLf
        strScript += "<" & "/" & "SCRIPT" & ">"
        'Register the script for the client side 
        ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript)
    End Sub
    
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmTicket" runat="server" >
    <div id="divErrors" runat="server" class="errorzone" visible="false" />
    <table style="width: 100%">
      <tbody>
        <tr>
          <td>
            <div class="inputform">
            <table style="width: 100%">
              <tbody>
                <tr>
                  <td class="inputform">
                    <div class="inputformsectionheader">Contact Information</div>
                      <div class="localtime">
                        <div class="bandheader">Local&nbsp;Time</div>
                        <div class="clock"><asp:Label ID="lblLocalTime" runat="server" /></div>
                      </div>
                      <div class="contact">
                        <div><asp:Label ID="lblContact" runat="server" /></div>
                        <div><a target="_blank" id="lnkMapIt" runat="server"><asp:Label ID="lblAddress" runat="server" /></a></div>
                        <div style="text-align: left;"><asp:Image ID="imgPostNet" runat="server" /></div>
                      </div>
                  </td>
                  <td class="inputform">
                    <div class="inputformsectionheader">Phone Numbers</div>
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
                      </Columns>                
                    </asp:DataGrid>
                  </td>
                  <td class="inputform">
                    <div class="inputformsectionheader">Ticket Information</div>
                    <table cellspacing="0">
                      <tr>
                        <td class="label">Ticket ID</td>
                        <td>&nbsp;</td>
                        <td><asp:Label ID="lblTicketID" runat="server" /> </td>
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
            <div class="inputformsectionheader">Reference Numbers</div>
            <table style="width: 100%" class="inputform">
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
                  <td class="label"><asp:Label ID="lblRef3Label" runat="server" Visible ="false" /></td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef3" runat="server" Visible ="false" /></td>
                  <td>&nbsp;</td>
                  <td class="label"><asp:Label ID="lblRef4Label" runat="server" Visible ="false" /></td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblRef4" runat="server" Visible ="false" /></td>
                </tr>      
              </tbody>
            </table>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Scheduling</div>
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
            <div class="inputformsectionheader">Service Information</div>
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
                  <td class="label">Unit Type</td>
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
            <table width="100%">
              <tr >
                <td style="width:65%">
                  <div class="inputformsectionheader" >On Site Instructions</div>
                  <div style="padding-right: 5px"><asp:TextBox runat="server" ID="txtDescription" TextMode="multiLine" ReadOnly="true" style="width: 100%; height: 50px;" /></div>
               </td>
               <td rowspan ="2">
                  <div class="inputformsectionheader">Attachments</div>
                  <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" Width ="30%" />      
                  <asp:DataGrid style="width:100%" ID="dgvAttachments" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="Item_Click">
                    <ItemStyle CssClass="bandbar" />
                      <Columns>
                        <asp:BoundColumn DataField="TicketDocumentID" HeaderText="ID" Visible="false" />
                        <asp:BoundColumn DataField="Description" HeaderText="DocType" Visible="True" />
                        <asp:BoundColumn DataField="FileID" HeaderText="FileID" Visible="false" />
                        <asp:ButtonColumn Text="View" CommandName ="View" ></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Update" CommandName="Update"></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Remove" CommandName="Remove" ></asp:ButtonColumn> 
                     </Columns>              
                  </asp:DataGrid> 
               </td>
              </tr>
              <tr>
                <td>
                  <div class="inputformsectionheader">Problem Description</div>
                  <div style="padding-right: 5px"><asp:TextBox runat="server" ID="txtNotes" TextMode="multiLine" ReadOnly="true" Wrap ="true" style="width: 100%; height: 50px;"/> </div>
                </td>
             </tr>
            </table>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Parts</div>
            <asp:DataGrid ID="dgvComponents" runat="server" AutoGenerateColumns="false" style="width: 100%; background-color: White;">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />
              <Columns>      
                <asp:BoundColumn DataField="TicketComponentID" Visible="false" />
                <asp:BoundColumn DataField="Qty" HeaderText="Qty" />
                <asp:BoundColumn DataField="Code" HeaderText="Code/SKU" />
                <asp:BoundColumn DataField="Component" HeaderText="Component Name" />
                <asp:BoundColumn DataField="SerialNumber" HeaderText="Part Invoice Number" />
                <asp:BoundColumn DataField="RMA" HeaderText="RMA Number" />
                <asp:TemplateColumn HeaderText="Enter Core Return Label">
                  <ItemTemplate>
                  <a href="AddReturnLabel.aspx?id=<%#DataBinder.Eval(Container.DataItem, "TicketComponentID")%>&TicketID=<%#_ID%>&returnurl=ticket.aspx?id=<%#_ID%>">Add/Edit DUD Return Label</a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Shipping Labels">
                  <ItemTemplate>
                    <asp:DataGrid ID="dgvLabels" style="width: 100%; background-color: White;" runat="server" AutoGenerateColumns="false">
                      <HeaderStyle CssClass="gridheader" />
                      <AlternatingItemStyle CssClass="altrow" />
                      <Columns>
                        <asp:BoundColumn DataField="ShippingLabelID" Visible="false" />
                        <asp:BoundColumn HeaderText="Courier" DataField="Courier" />
                        <asp:BoundColumn DataField="Destination" HeaderText="Destination" />
                        <asp:BoundColumn HeaderText="Method" DataField="Method" />
                        <asp:TemplateColumn HeaderText="Label">
                          <ItemTemplate>
                            <a target="_blank" href="<%# Databinder.eval(Container.DataItem,"TrackingScript").ToString.Replace("$shippinglabel",DataBinder.Eval(Container.DataItem,"ShippingLabel")) %>"><%# DataBinder.Eval(Container.DataItem,"ShippingLabel") %>&nbsp;&nbsp;&nbsp;&nbsp;</a>                    
                          </ItemTemplate>
                        </asp:TemplateColumn>
                      </Columns>
                    </asp:DataGrid>                    
                  </ItemTemplate>
                </asp:TemplateColumn>
              </Columns>
            </asp:DataGrid>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Work Orders</div>
            <asp:DataGrid ID="dgvWorkOrders" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="WorkOrderID" Visible="false" />
                <asp:templatecolumn HeaderText="Work Order ID">
                  <itemtemplate>
                    <a href="printableworkorder.aspx?id=<%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%>"><%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%></a>
                    <asp:Label ID="lblWorkOrderUploaded" runat="server" /> <%#UploadText(Databinder.Eval(Container.DataItem, "WorkOrderID"))%> 
                  </itemtemplate>
                </asp:templatecolumn>
                <asp:TemplateColumn headertext="Build Estimate">
                  <Itemtemplate >
                  <a target="_blank" href="estimatetemplate.aspx?id=<%#DataBinder.Eval(Container.DataItem, "WorkOrderID")%>" >Estimate</a> 
                  </Itemtemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Tasks">
                  <ItemTemplate>
                    <%#SetAppointment(DataBinder.Eval(Container.DataItem, "WorkOrderID"), DataBinder.Eval(Container.DataItem, "PartnerAgentID"))%>                
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn HeaderText="Status" DataField="WorkOrderStatus" />
                <asp:BoundColumn HeaderText="Resolved" DataField="Resolved" />
                <asp:BoundColumn HeaderText="Dispatched" DataField="DispatchDate" />
              </Columns>      
            </asp:DataGrid>
            <div>&nbsp;</div>
            <div class="inputformsectionheader">Activity Notes</div>
            <asp:TextBox ID="txtTicketNote" runat="server" TextMode="MultiLine" style="width: 99%" Height="75px" Wrap ="true" />
            <div style="text-align: right;"><asp:CheckBox ID="chkPreOrderParts" Text="Request to Pre-order Parts ( I already Cancelled Appt with End User )" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="Button1" Text="Add Note" OnClick="btnAddNote_Click" runat="server" /></div>
            <asp:DataGrid ID="dgvNotes" runat="server" ShowHeader="false" AutoGenerateColumns="false" style="width: 100%; background-color: White;">
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:TemplateColumn ItemStyle-Width="1%" ItemStyle-VerticalAlign="top" >
                  <ItemTemplate>
                    <div style="white-space:nowrap;"><%# Databinder.eval(Container.DataItem, "DateCreated") %></div>
                    <div><a href="mailto:<%# Databinder.eval(Container.DataItem, "Email") %>"><%# Databinder.eval(Container.DataItem, "Author") %></a></div>
                    <div>C-Visible: <%# Databinder.eval(Container.DataItem, "CustomerVisible") %></div>
                    <div>P-Visible: <%#DataBinder.Eval(Container.DataItem, "PartnerVisible")%></div>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn ItemStyle-Wrap="true">
                  <Itemtemplate>
                  <%# Databinder.eval(Container.DataItem, "NoteBody").ToString.Replace(environment.NewLine,"<br />") %>
                  </Itemtemplate>
                </asp:TemplateColumn>
              </Columns>
            </asp:DataGrid>    
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    <asp:Label id="lblReturnUrl" runat="server" Visible="false" />
  </form>
</asp:Content>