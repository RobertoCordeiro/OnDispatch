<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  
  Private _ZipCode As String = ""
    Private _ID As Long
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Zip Code Lookup"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Zip Code Lookup"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Zip Code Lookup"
    End If
    Dim strZipCode As String = Request.QueryString("zip")
        Dim lng As Long = 0
        _ID = Request.QueryString("id")
        If _ID = 0 Then
            btnSend.Enabled = False
        Else
            btnSend.Enabled = True
        End If
    Try            
      If Long.TryParse(Request.QueryString("rad"), lng) Then
        If Not IsPostBack Then
          txtRadius.Text = lng.ToString
        End If
      Else
        If Not IsPostBack Then
          txtRadius.Text = "100"
        End If        
      End If     
    Catch ex As Exception
      txtRadius.Text = "100"
    End Try
    If Not IsPostBack Then
      txtZipCode.Text = strZipCode
    End If
    If IsNothing(strZipCode) Then
      divSearchForm.Visible = True
    Else
      divSearchForm.Visible = True
      if not IsPostBack then
        DisplayZip(strZipCode)
      else
        btnSend.Enabled = False
      end if
    End If
  End Sub
  
  Private Sub DisplayZip(ByVal strZipCode As String)
    Dim zip As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim stt As New BridgesInterface.StateRecord(zip.ConnectionString)
    Dim cnt As New BridgesInterface.CountryRecord(zip.ConnectionString)
        Dim ctp As New BridgesInterface.CityTypeRecord(zip.ConnectionString)
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim ter as New BridgesInterface.TerritoryRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
        Dim loc as New BridgesInterface.LocationRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
        Dim ggl As New cvCommon.Googler
        Dim strBody As String
        'Dim strSubject As String
        'Dim strMessage as String

    zip.Load(strZipCode.Trim)
    _ZipCode = strZipCode.Trim
    If zip.ZipCodeID > 0 Then
      stt.Load(zip.StateID)
      cnt.Load(stt.CountryID)
      ctp.Load(zip.CityTypeID)
      divResults.Visible = True
      lnkMapIt.HRef = ggl.MapZipCode(strZipCode.Trim)
      lblLocalTime.Text = zip.LocalTime.ToString
      lblCountyName.Visible = True
      lblCountyName.Text = zip.CountyName
      'loc.GetLocationName (zip.ZipCodeID ) 
      lblLocationName.Visible = True
      'lblLocationName.Text = loc.locationName
      LoadClosestResumes(zip.ZipCode, CType(txtRadius.Text, Long))
      LoadClosestPartnerAgents(zip.ZipCode, CType(txtRadius.Text, Long))
      LoadUnassignedTickets(zip.ZipCode, CType(txtRadius.Text, Long))
            LoadClosedTickets(zip.ZipCode, CType(txtRadius.Text, Long))
            
           tkt.Load(_ID)
                   
            strBody = "TICKET INFORMATION: " & Chr(13)
            strBody = "Ticket Number: " & _ID  & Chr(13)
            strBody = strBody & "Customer Name: " & tkt.ContactFirstName & " " & tkt.ContactLastName  & Chr(13)
            strBody = strBody & "Address: " & tkt.Street & Chr(13)
            strBody = strBody & "City,State,Zip: " & tkt.City & "  " & stt.Abbreviation & ", " & tkt.ZipCode & Chr(13)
            strBody = strBody & "CustomerNumber: " & tkt.ReferenceNumber1 & Chr(13)
            strBody = strBody & "Authorization Number: " & tkt.ReferenceNumber2 & Chr(13)
            strBody = strBody & "Type: " & tkt.Manufacturer & Chr(13)
            strBody = strBody & "Model Number: " & tkt.Model & Chr(13)
            strBody = strBody & "Problem Description: " & tkt.Notes & Chr(13) & Chr(13)
            
            'strMessage = "This is an automated email from National Appliance Network." & Chr(13) & Chr(13)
                    'strMessage = strMessage & "You are receiving this email as a notification that we have receive a service ticket around your area." & Chr(13)
                    'strMessage = strMessage & "To have this ticket assigned to you, please reply to this email or give us a call using the below phone number." & Chr(13) & Chr(13)
                    'strMessage = strMessage & "The unit has been troubleshooted over the phone, part is on order and it will be shipped to site." & Chr(13)
                    'strMessage = strMessage & "We need the technician to go onsite, replace the part and let us know if problem was solved. " & Chr(13)
                    'strMessage = strMessage & "If not solved, tech should give our support a call and let us know what part would be needed to give solution to the problem." & Chr(13)
                    'strMessage = strMessage & "Our support has a 98.9% avarage of problem solved on first visit!!!" & Chr(13) & Chr(13)
                    'strMessage = strMessage & "Our regular pay rate for labor on these calls, based on less then an hour onsite, is between $50.00 - $65.00 per visit." & Chr(13)
                    'strMessage = strMessage & "If this ticket is outside your geographic area, please let us know, when replying, what would be your total rate for labor and we will verify if we can get it approved." & Chr(13)
                    'strMessage = strMessage & "Receiving this email means that we have started receiving a higher volume of service calls in your area. If you don't have a geographic area assigned to you yet " & Chr(13)
                    'strMessage = strMessage & "please mention it in your email or give us a call so we can have it set up for you." & Chr(13) & Chr(13)
                    'strMessage = strMessage & "Thanks much," & Chr(13)& Chr(13) 
                    'strMessage = strMessage & "Vendor Administrator Team "  & Chr(13) 
                    'strMessage = strMessage & "National Appliance Network "  & Chr(13) 
                    'strMessage = strMessage & "866.249.5019 " & Chr(13) 
                    'strMessage = strMessage & "www.NationalApplianceNetwork.com"
                    
                    'strSubject = "Ticket Number: " & _ID 
            
            'txtMailBody.Text = strBody & chr(13) & chr(13) & strMessage
            'txtSubject.Text = strSubject 
            
    Else
      divNotFound.Visible = True
      divResults.Visible = False      
    End If
  End Sub
  
  Private Sub LoadClosestResumes(ByVal strZipCode As String, ByVal lngRadius As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spListClosestResumesToZipCode", "@Radius", lngRadius, "@ZipCode", strZipCode, dgvClosestResumes)
  End Sub
  Private Sub LoadUnassignedTickets(ByVal strZipCode As String, ByVal lngRadius As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spUnassignedTicketsByZipCode", "@Radius", lngRadius, "@ZipCode", strZipCode, dgvUnassignedTickets)
  End Sub
  Private Sub LoadClosedTickets(ByVal strZipCode As String, ByVal lngRadius As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spClosedTicketsByZipCode", "@Radius", lngRadius, "@ZipCode", strZipCode, dgvClosedTickets)
  End Sub

  Private Sub LoadClosestPartnerAgents(ByVal strZipCode As String, ByVal lngRadius As Long)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadLongStringParameterDataGrid("spListClosestPartnerAgentsToZipCode", "@Radius", lngRadius, "@ZipCode", strZipCode, dgvClosestAgents)
  End Sub
  
  Public Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)    
    If IsComplete() Then
      divErrors.Visible = False
            Response.Redirect("findzipcode.aspx?zip=" & txtZipCode.Text & "&rad=" & txtRadius.Text & "&id=" & _ID, True)
    Else
      divResults.Visible = False
      divNotFound.Visible = False
      divErrors.Visible = True
    End If
  End Sub
    Private Sub btnSend_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim stu as New BridgesInterface.TicketStatusRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
        Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
        Dim chkbox As CheckBox 
        Dim dgItem As DataGridItem
        Dim strBody as String
        'Dim strMessage as String
        'Dim strSubject as string 
      
        If Not IsDBNull(txtMailBody.Text) Then
        
            For Each dgItem In dgvClosestAgents.Items
                chkbox = dgItem.FindControl("chkSelected")
                
                If chkbox.Checked Then
                    tkt.Load(_ID)
                    stt.Load (tkt.StateID )
                    stu.Load(tkt.TicketStatusID)

                    strBody = "<b>TICKET INFORMATION:</b> <br><br>"  
                    strBody = strBody & "<b>Ticket Number:</b> " & _ID & "<br>" 
                    strBody = strBody & "<b>Customer Name:</b> " & tkt.ContactLastName & "<br>" 
                    strBody = strBody & "<b>City,State,Zip:</b> " & tkt.City & "  " & stt.Abbreviation & ", " & tkt.ZipCode & "<br>" 
                    strBody = strBody & "<b>CustomerNumber:</b> " & tkt.ReferenceNumber1 & "<br>" 
                    strBody = strBody & "<b>Type:</b> " & tkt.Manufacturer & "<br>" 
                    strBody = strBody & "<b>Model Number:</b> " & tkt.Model & "<br>" 
                    strBody = strBody & "<b>Problem Description:</b> " & tkt.Notes & "<br><br>" 
            
                    'strMessage = "This is an automated email from National Appliance Network.<br><br>" 
                    'strMessage = strMessage & "You are receiving this email as a notification that we have receive a service ticket around your area.<br>" 
                    'strMessage = strMessage & "To have this ticket assigned to you, please reply to this email or give us a call using the below phone number.<br><br>"
                    'strMessage = strMessage & "The unit has been troubleshooted over the phone, part is on order and it will be shipped to site.<br>"
                    'strMessage = strMessage & "We need the technician to go onsite, replace the part and let us know if problem was solved. <br>"
                    'strMessage = strMessage & "If not solved, tech should give our support a call and let us know what part would be needed to give solution to the problem. <br>"
                    'strMessage = strMessage & "Our support has a 98.9% avarage of problem solved on first visit!!!<br><br>"
                    'strMessage = strMessage & "Our regular pay rate for labor on these calls, based on less then an hour onsite, is between $50.00 - $65.00 per visit.<br>"
                    'strMessage = strMessage & "If this ticket is outside your geographic area, please let us know, when replying, what would be your total rate for labor and we will verify if we can get it approved. <br><br>"
                    'strMessage = strMessage & "Receiving this email means that we have started receiving a higher volume of service calls in your area. If you don't have a geographic area assigned to you yet <br>"
                    'strMessage = strMessage & "please mention it in your email or give us a call so we can have it set up for you.<br><br>"
                    'strMessage = strMessage & "Thanks much,<br>"
                    'strMessage = strMessage & "Vendor Administrator Team <br>" 
                    'strMessage = strMessage & "National Appliance Network <br>" 
                    'strMessage = strMessage & "866.249.5019 <br>" 
                    'strMessage = strMessage & "www.NationalApplianceNetwork.com"
                    
                    'strSubject = "Ticket Number: " & _ID & " / " & stu.Status & " / " & dgItem.Cells.Item(0).text
            
                                       
                    'eml.SendFrom = "phonesupport@bestservicers.com"
                   
                    'eml.SendTo = dgItem.Cells.Item(9).Text
                    'eml.SendTo = "Nelson.palavesino@bestservicers.com"
                    'eml.Subject = strSubject
                    'eml.Body = strBody & "<br><br>" & strMessage
      
                    'eml.Send()
            
                End If
            Next
            
            For Each dgItem In dgvClosestResumes.Items
                chkbox = dgItem.FindControl("chkSelected1")
                If chkbox.Checked Then
                    tkt.Load(_ID)
                    stt.Load (tkt.StateID )
                    stu.Load(tkt.TicketStatusID)
                    strBody = "<b>TICKET INFORMATION:</b> <br><br>"  
                    strBody = strBody & "<b>Ticket Number:</b> " & _ID & "<br>" 
                    strBody = strBody & "<b>Customer Name:</b> " & tkt.ContactLastName & "<br>" 
                    strBody = strBody & "<b>City,State,Zip:</b> " & tkt.City & "  " & stt.Abbreviation & ", " & tkt.ZipCode & "<br>" 
                    strBody = strBody & "<b>CustomerNumber:</b> " & tkt.ReferenceNumber1 & "<br>" 
                    strBody = strBody & "<b>Type:</b> " & tkt.Manufacturer & "<br>" 
                    strBody = strBody & "<b>Model Number:</b> " & tkt.Model & "<br>" 
                    strBody = strBody & "<b>Problem Description:</b> " & tkt.Notes & "<br><br>" 
            
                    'strMessage = "This is an automated email from National Appliance Network.<br><br>" 
                    'strMessage = strMessage & "You are receiving this email as a notification that we have receive a service ticket around your area.<br>" 
                    'strMessage = strMessage & "To have this ticket assigned to you, please reply to this email or give us a call using the below phone number.<br><br>"
                    'strMessage = strMessage & "The unit has been troubleshooted over the phone, part is on order and it will be shipped to site.<br>"
                    'strMessage = strMessage & "We need the technician to go onsite, replace the part and let us know if problem was solved. <br>"
                    'strMessage = strMessage & "If not solved, tech should give our support a call and let us know what part would be needed to give solution to the problem. <br>"
                    'strMessage = strMessage & "Our support has a 98.9% avarage of problem solved on first visit!!!<br><br>"
                    'strMessage = strMessage & "Our regular pay rate for labor on these calls, based on less then an hour onsite, is between $50.00 - $65.00 per visit.<br>"
                    'strMessage = strMessage & "If this ticket is outside your geographic area, please let us know, when replying, what would be your total rate for labor and we will verify if we can get it approved. <br><br>"
                    'strMessage = strMessage & "Receiving this email means that we have started receiving a higher volume of service calls in your area. If you don't have a geographic area assigned to you yet <br>"
                    'strMessage = strMessage & "please mention it in your email or give us a call so we can have it set up for you.<br><br>"
                    'strMessage = strMessage & "Thanks much,<br>"
                    'strMessage = strMessage & "Vendor Administrator Team <br>" 
                    'strMessage = strMessage & "National Appliance Network <br>" 
                    'strMessage = strMessage & "866.249.5019 <br>" 
                    'strMessage = strMessage & "www.NationalApplianceNetwork.com"
                    
                    'strSubject = "Ticket Number: " & _ID & " / " & stu.Status & " / " & dgItem.Cells.Item(0).text
            
                                   
                    'eml.SendFrom = "phonesupport@bestservicers.com"
                   
                    'eml.SendTo = dgItem.Cells.Item(9).Text
                    ''eml.SendTo = "Nelson.palavesino@bestservicers.com"
                    'eml.Subject = strSubject
                    'eml.Body = strBody & "<br><br>" & strMessage
      
                    'eml.Send()
            
                End If
            Next
            
            For Each dgItem In dgvClosedTickets.Items
                chkbox = dgItem.FindControl("chkSelected2")
                If chkbox.Checked Then
                   tkt.Load(_ID)
                    stt.Load (tkt.StateID )
                    stu.Load(tkt.TicketStatusID)
                    strBody = "<b>TICKET INFORMATION:</b> <br><br>"  
                    strBody = strBody & "<b>Ticket Number:</b> " & _ID & "<br>" 
                    strBody = strBody & "<b>Customer Name:</b> " & tkt.ContactLastName & "<br>" 
                    strBody = strBody & "<b>City,State,Zip:</b> " & tkt.City & "  " & stt.Abbreviation & ", " & tkt.ZipCode & "<br>" 
                    strBody = strBody & "<b>CustomerNumber:</b> " & tkt.ReferenceNumber1 & "<br>" 
                    strBody = strBody & "<b>Type:</b> " & tkt.Manufacturer & "<br>" 
                    strBody = strBody & "<b>Model Number:</b> " & tkt.Model & "<br>" 
                    strBody = strBody & "<b>Problem Description:</b> " & tkt.Notes & "<br><br>" 
            
                    'strMessage = "This is an automated email from National Appliance Network.<br><br>" 
                    'strMessage = strMessage & "You are receiving this email as a notification that we have receive a service ticket around your area.<br>" 
                    'strMessage = strMessage & "To have this ticket assigned to you, please reply to this email or give us a call using the below phone number.<br><br>"
                    'strMessage = strMessage & "The unit has been troubleshooted over the phone, part is on order and it will be shipped to site.<br>"
                    'strMessage = strMessage & "We need the technician to go onsite, replace the part and let us know if problem was solved. <br>"
                    'strMessage = strMessage & "If not solved, tech should give our support a call and let us know what part would be needed to give solution to the problem. <br>"
                    'strMessage = strMessage & "Our support has a 98.9% avarage of problem solved on first visit!!!<br><br>"
                    'strMessage = strMessage & "Our regular pay rate for labor on these calls, based on less then an hour onsite, is between $50.00 - $65.00 per visit.<br>"
                    'strMessage = strMessage & "If this ticket is outside your geographic area, please let us know, when replying, what would be your total rate for labor and we will verify if we can get it approved. <br><br>"
                    'strMessage = strMessage & "Receiving this email means that we have started receiving a higher volume of service calls in your area. If you don't have a geographic area assigned to you yet <br>"
                    'strMessage = strMessage & "please mention it in your email or give us a call so we can have it set up for you.<br><br>"
                    'strMessage = strMessage & "Thanks much,<br>"
                    'strMessage = strMessage & "Vendor Administrator Team <br>" 
                    'strMessage = strMessage & "National Appliance Network <br>" 
                    'strMessage = strMessage & "866.249.5019 <br>" 
                    'strMessage = strMessage & "www.NationalApplianceNetwork.com"
                    
                    
                    'strSubject = "Ticket Number: " & _ID & " / " & stu.Status & " / " & dgItem.Cells.Item(3).text
            
                                     
                    'eml.SendFrom = "phonesupport@bestservicers.com"
                   
                    'eml.SendTo = dgItem.Cells.Item(13).Text
                    ''eml.SendTo = "Nelson.palavesino@bestservicers.com"
                    'eml.Subject = strSubject
                    'eml.Body = strBody & "<br><br>" & strMessage
      
                    'eml.Send()
                End If
            Next
            Dim strChangeLog as String = ""
            Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Automatic Mailing - Searching for Technician: Replies going to the phonesupport public folder. " )
            tnt.CustomerVisible = False
            tnt.PartnerVisible = False
            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
            tnt.Acknowledged = True
            tnt.Save(strChangeLog)
        End If
    End Sub
    
    
    Private Function IsComplete() As Boolean
        Dim blnReturn As Boolean = True
        Dim strErrors As String = ""
        Dim lng As Long = 0
        If txtZipCode.Text.Trim.Length = 0 Then
            strErrors &= "<li>Zip Code Required</li>"
            blnReturn = False
        End If
        If txtRadius.Text.Trim.Length = 0 Then
            strErrors &= "<li>Radius is Required</li>"
            blnReturn = False
        Else
            If Not Long.TryParse(txtRadius.Text, lng) Then
                blnReturn = False
                strErrors &= "<li>Radius must be a whole number</li>"
            End If
        End If
        divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
        Return blnReturn
    End Function

  
    Private Function CurrentZip() As String
        Return Request.QueryString("zip")
    End Function
  
    Private Function ZipToZip(ByVal strDestinationZipCode As String) As String
        Dim ggl As New cvCommon.Googler
        Dim strReturn As String = ggl.ZipToZip(strDestinationZipCode, _ZipCode)
        Return strReturn
    End Function
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmLookup" runat="server">
    <div id="divSearchForm" class="inputform" runat="server" visible="false">
      <div class="inputformsectionheader">Zip Code Lookup</div>
      <div>&nbsp;</div>
      <div style="margin-left: auto; margin-right: auto; width: 350px;">
        <div class="errorzone" id="divErrors" visible="false" runat="server" />
        <div class="label">Enter Zip Code</div>
        <asp:TextBox style="width: 99%" ID="txtZipCode" runat="server" />
        <div class="label">Radius</div>
        <asp:TextBox style="width: 50%" ID="txtRadius" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnSubmit" Onclick="btnSubmit_Click" runat="server" Text="Find" />
        <div style="text-align: right;"></div>
        <div>County Name:&nbsp;<asp:Label ID="lblCountyName" runat="server"   ForeColor="Red" Visible ="false"/>&nbsp; Location Name:&nbsp;<asp:Label ID="lblLocationName" runat="server" visible="false" ForeColor="Red"/></div>
        <div class="label" style="text-align:center">Current Local Date/Time:</div>
        <div style="text-align:center"><asp:Label ID="lblLocalTime" runat="server" ForeColor="Red"/></div>
      </div>
    </div>    
    <div style="margin-top: 32px;" id="divNotFound" visible="false" runat="server">Zip Code Not Found, <a href="findzipcode.aspx">Retry</a>?</div>
    <div id="divResults" visible="false" runat="server" class="inputform">
      <div class="inputformsectionheader">Select Check Boxes and Send Email to Technicians</div>
      <table  style="margin-left: auto; margin-right: auto">
        <tbody>
        <tr>
         <td class="label">Subject:<asp:TextBox ID="txtSubject"  runat ="server" Width="70%" /></td>
        </tr>
          <tr>
            <td style="width:100%"  align="left" colspan="4"><asp:TextBox ID="txtMailBody" runat="server" TextMode="MultiLine" style="width: 70%" Height="75px" /><asp:Button ID="btnSend" runat="server" Text="Send" Onclick="btnSend_Click"/></td>
            <td><a id="lnkMapIt" target="_blank" runat="server"><asp:Label ID="lblZipCode" runat="server" /></a></td>
          </tr>
         </tbody>
      </table>
      <div>&nbsp;</div>
      <div class="inputformsectionheader">UnAssigned Tickets</div>
      <asp:DataGrid ID="dgvUnassignedTickets" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false">
        <HeaderStyle CssClass="gridheader" />
        <AlternatingItemStyle CssClass="altrow" />
        <Columns>
           <asp:TemplateColumn HeaderText="Ticket ID">
            <ItemTemplate>
              <a href="Ticket.aspx?id=<%#DataBinder.Eval(Container.DataItem, "TicketID")%>"><%#DataBinder.Eval(Container.DataItem, "TicketID")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:TemplateColumn HeaderText="Distance">
            <ItemTemplate>
              <a target="_blank" href="<%#ZipToZip(DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%#DataBinder.Eval(Container.DataItem, "Distance")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:BoundColumn HeaderText="Age" DataField="Age" />
          <asp:BoundColumn HeaderText="Company" DataField="Company" />
          <asp:BoundColumn HeaderText="Type" DataField="Manufacturer" />
          <asp:BoundColumn HeaderText="ServiceType" DataField="ServiceType" />
          <asp:BoundColumn HeaderText="County" DataField="CountyName" />
          <asp:BoundColumn HeaderText="City" DataField="City" />
          <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />
          <asp:BoundColumn HeaderText="zipCode" DataField="ZipCode" />
          <asp:BoundColumn HeaderText="ETA" DataField="ETA" visible="false"/>
        </Columns>
      </asp:DataGrid>
      <div>&nbsp;</div>
      <div>&nbsp;</div>
      <div class="inputformsectionheader">Closest Partner Agents</div>
      <asp:DataGrid ID="dgvClosestAgents" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false">
        <HeaderStyle CssClass="gridheader" />
        <AlternatingItemStyle CssClass="altrow" />
        <Columns>
          <asp:BoundColumn HeaderText="ID" DataField="ResumeID" Visible="false" />
          <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected" runat="server" />
                  </ItemTemplate>
            </asp:TemplateColumn>
          <asp:TemplateColumn HeaderText="Partner ID">
            <ItemTemplate>
              <a href="partner.aspx?id=<%#DataBinder.Eval(Container.DataItem, "PartnerID")%>"><%#DataBinder.Eval(Container.DataItem, "ResumeID")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:TemplateColumn HeaderText="Distance">
            <ItemTemplate>
              <a target="_blank" href="<%#ZipToZip(DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%#DataBinder.Eval(Container.DataItem, "Distance")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>          
          <asp:TemplateColumn HeaderText="Agent ID">
            <ItemTemplate>
              <a href="editpartneragent.aspx?id=<%#DataBinder.Eval(Container.DataItem, "PartnerAgentID")%>&returnurl=findzipcode.aspx%3fzip=<%# currentzip %>"><%#DataBinder.Eval(Container.DataItem, "resumeID")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:BoundColumn HeaderText="Type" DataField="ResumeType" />
          <asp:Templatecolumn HeaderText="Name">
            <ItemTemplate>
              <%#DataBinder.Eval(Container.DataItem, "FirstName")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%>
            </ItemTemplate>
          </asp:Templatecolumn>                
          <asp:BoundColumn HeaderText="City" DataField="City" />
          <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />
          <asp:BoundColumn HeaderText="Email" DataField="Email" Visible = "false" />
          
        </Columns>
      </asp:DataGrid>
      <div>&nbsp;</div>
      <div class="inputformsectionheader">Closest Resumes</div>
      <asp:DataGrid ID="dgvClosestResumes" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false">
        <HeaderStyle CssClass="gridheader" />
        <AlternatingItemStyle CssClass="altrow" />
        <Columns>
          <asp:BoundColumn HeaderText="ID" DataField="ResumeID" Visible="false" />
          <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected1" runat="server" />
                  </ItemTemplate>
            </asp:TemplateColumn>
          <asp:TemplateColumn HeaderText="Resume ID">
            <ItemTemplate>
              <a href="resume.aspx?resumeid=<%#DataBinder.Eval(Container.DataItem, "ResumeID")%>"><%#DataBinder.Eval(Container.DataItem, "ResumeID")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:TemplateColumn HeaderText="Distance">
            <ItemTemplate>
              <a target="_blank" href="<%#ZipToZip(DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%#DataBinder.Eval(Container.DataItem, "Distance")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:BoundColumn HeaderText="Type" DataField="ResumeType" />
          <asp:Templatecolumn HeaderText="Name">
            <ItemTemplate>
              <%#DataBinder.Eval(Container.DataItem, "FirstName")%>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%>
            </ItemTemplate>
          </asp:Templatecolumn>    
          <asp:BoundColumn HeaderText="FolderName" DataField="FolderName" />            
          <asp:BoundColumn HeaderText="City" DataField="City" />
          <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />
          <asp:BoundColumn HeaderText="Email" DataField="Email" Visible = False />
        </Columns>
      </asp:DataGrid>
      <div>&nbsp;</div>
      <div class="inputformsectionheader">Closed Tickets</div>
      <asp:DataGrid ID="dgvClosedTickets" runat="server" style="width: 100%; background-color: White;" AutoGenerateColumns="false">
        <HeaderStyle CssClass="gridheader" />
        <AlternatingItemStyle CssClass="altrow" />
        <Columns>
          <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected2" runat="server" />
                  </ItemTemplate>
            </asp:TemplateColumn>
           <asp:TemplateColumn HeaderText="Ticket ID">
            <ItemTemplate>
              <a href="Ticket.aspx?id=<%#DataBinder.Eval(Container.DataItem, "TicketID")%>"><%#DataBinder.Eval(Container.DataItem, "TicketID")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:TemplateColumn HeaderText="Distance">
            <ItemTemplate>
              <a target="_blank" href="<%#ZipToZip(DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%#DataBinder.Eval(Container.DataItem, "Distance")%></a>
            </ItemTemplate>
          </asp:TemplateColumn>
          <asp:BoundColumn HeaderText="Tech" DataField="ResumeID" />
          <asp:BoundColumn HeaderText="Age" DataField="Age" />
          <asp:BoundColumn HeaderText="Company" DataField="Company" />
          <asp:BoundColumn HeaderText="Type" DataField="Manufacturer" />
          <asp:BoundColumn HeaderText="ServiceType" DataField="ServiceType" />
          <asp:BoundColumn HeaderText="County" DataField="CountyName" />
          <asp:BoundColumn HeaderText="City" DataField="City" />
          <asp:BoundColumn HeaderText="State" DataField="Abbreviation" />
          <asp:BoundColumn HeaderText="zipCode" DataField="ZipCode" />
          <asp:BoundColumn HeaderText="ETA" DataField="ETA" Visible="false" />
          <asp:BoundColumn HeaderText="Email" DataField="Email" Visible = "false" />
        </Columns>
      </asp:DataGrid>
      <div>&nbsp;</div>
    </div>
  </form>
</asp:Content>