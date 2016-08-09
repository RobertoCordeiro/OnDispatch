<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    
    lblReturnUrl.Text = Request.QueryString("returnurl")
    if lblReturnUrl.Text = "" then
      lblReturnUrl.Text = "ticket.aspx?id=" & _ID
    end if
    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Initial Contact"
      Master.PageTitleText = "Initial Contact"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; <a href=""ticket.aspx?id=" & _ID & """>Ticket</a> &gt; Initial Contact"
      GetTicketInfo(_ID)    
End If
    If _ID = 0 Then
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    If txtNote.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Note is Required</li>"
    End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
  Private Sub btnOK_Click(ByVal S As Object, ByVal E As EventArgs)
   Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
   Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
   Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
 
    If IsComplete() Then
      if chkFirstContact.checked = True Then     
      
         Dim strChangeLog As String = ""
         divErrors.Visible = False
         tkt.Load(_ID)
         tkt.InitialContact = DateTime.Now
         tkt.TicketStatusID = 5
         tkt.model = txtModel.text
         tkt.serialnumber = txtSerial.text
         
         tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Initial Contact: " & txtNote.Text)
         tnt.CustomerVisible = True
         tnt.PartnerVisible = True
         tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
         tnt.Acknowledged = True
         tnt.Save(strChangeLog)
         tkt.Save(strChangeLog)
         Dim strIp As String = Request.QueryString("REMOTE_ADDR")
         Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
         If IsNothing(strIp) Then
           strIp = "unknown"
         End If
         If IsNothing(strType) Then
           strType = "web"
         End If
         act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID, 33, tkt.TicketID, strChangeLog)
         Response.Redirect(lblReturnUrl.Text, True)
   else
      Dim strChangeLog As String = ""
         divErrors.Visible = False
         tkt.Load(_ID)
         'tkt.InitialContact = DateTime.Now
         tkt.model = txtModel.text
         tkt.serialnumber = txtSerial.Text
          
         tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Attempted Contact:" & txtNote.Text)
         tnt.CustomerVisible = True
         tnt.PartnerVisible = True
         tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
         tnt.Acknowledged = True
         
         tnt.Save(strChangeLog)
         tkt.Save(strChangeLog)
         
         'Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
         'Dim strIp As String = Request.QueryString("REMOTE_ADDR")
         'Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
         'If IsNothing(strIp) Then
         '  strIp = "unknown"
         'End If
         'If IsNothing(strType) Then
         '  strType = "web"
         'End If
         'act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID, 33, tkt.TicketID, strChangeLog)
         Response.Redirect(lblReturnUrl.Text, True)
   end if    
Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private Sub btnViewScript_Click(ByVal S As Object, ByVal E As EventArgs)
   if btnview.text = "View Script" then    
            'If txtProgram.Text = "30" Or txtProgram.Text = "32" Or txtProgram.Text = "34" Then
            Electrolux.Visible = True
            Omni.Visible = False
            'End If
            'If txtProgram.Text = "33" Or txtProgram.Text = "26" Or txtProgram.Text = "37" Then
            'Omni.Visible = True
            'Electrolux.Visible = False
            'End If
            btnView.Text = "Hide Script"
        Else
            Electrolux.Visible = False
            Omni.Visible = False
            btnView.Text = "View Script"
        End If
  End Sub


  Private Sub GetTicketInfo (_ID as long)
  Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim tst As New BridgesInterface.TicketStatusRecord(tkt.ConnectionString)  
  Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)  
  Dim svt As New BridgesInterface.ServiceTypeRecord(tkt.ConnectionString)  
  Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)  
  Dim strHtml As String = "" 
  Dim strChangeLog as String = ""  
  tkt.Load(_ID)
  srv.Load(tkt.ServiceID)
  svt.Load(srv.ServiceTypeID)
  tst.Load (tkt.TicketStatusID )
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
    'lnkAssignWorkOrder.HRef = "assignworkorder.aspx?id=" & tkt.TicketID
    'txtDescription.Text = tkt.Description.Replace("<br />", Environment.NewLine)
    txtNotes.Text = tkt.Notes.Replace("<br />", Environment.NewLine)
    lblTicketID.Text = tkt.TicketID
    lblStatus.Text = tst.Status
    lblDateCreated.Text = tkt.DateCreated.ToString
    txtprogram.text = svt.serviceTypeID
    txtModel.text = tkt.Model
    txtSerial.text = tkt.SerialNumber
        txtServiceType.Text = svt.ServiceType
        txtDOP.Text = tkt.PurchaseDate
    lnkEditTicket.HRef = "editticket.aspx?id=" & tkt.TicketID & "&returnurl=initialcontact.aspx%3fid=" & _ID
    lnkAddPhone.HRef = "addphone.aspx?id=" & tkt.TicketID & "&mode=ticket&returnurl=initialcontact.aspx%3fid=" & _ID
   
    
  end sub
 
Private Sub LoadPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListTicketPhoneNumbers", "@TicketID", _ID, dgvPhoneNumbers)
  End Sub
 
 Private Sub btnSendEmail_Click(ByVal S As Object, ByVal E As EventArgs)
 Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
 Dim cst as New BridgesInterface.CustomerRecord(system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
 tkt.Load (_ID)
 cst.Load(tkt.CustomerID )
 Dim doc As New BridgesInterface.DocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
 Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
 doc.Load(9) 
 Dim strBody As String = doc.DocumentText  
    strBody = strBody.Replace("$firstname", tkt.ContactFirstName )
    strBody = strBody.Replace("$lastname", tkt.ContactLastName )
    strBody = strBody.Replace("$UnitType", tkt.Manufacturer )
    strBody = strBody.Replace("$TicketID",_ID)
    eml.Subject = "Important information regarding your repair"
    eml.SendTo = tkt.Email 
    eml.SendFrom = "welcome@bestservicers.com"
    eml.BCC = "welcome@bestservicers.com"
    eml.Body = strBody
    eml.HTMLBody = True
    eml.Send()

Dim strChangeLog as String = "" 
Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, " Auto message: Welcome letter sent to customer")
  tnt.CustomerVisible = False
  tnt.Acknowledged = False
  tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
  tnt.Save(strChangeLog)   
 
 btnSendEmail.Enabled = False

 End Sub
 
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
<form id="frmDialog" runat="server" class="inputform" >
<div >
            <table style="width: 100%">
              <tbody>
                <tr>
                  <td class="inputform">
                    <div class="inputformsectionheader">Contact Information</div>
                    <div><asp:Label ID="lblContact" runat="server" /></div>
                    <div><a target="_blank" id="lnkMapIt" runat="server"><asp:Label ID="lblAddress" runat="server" /></a></div>
                    <div><a id="lnkEditTicket" runat="server">Edit</a></div> 
                  </td>
                  <td>&nbsp;</td>
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
                        <asp:TemplateColumn
                          HeaderText="Command"
                          >
                          <Itemtemplate>
                            <a href="editphone.aspx?returnurl=ticket.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"TicketID") %>&id=<%# DataBinder.Eval(Container.DataItem,"TicketPhoneNumberID") %>&mode=ticket">Edit</a>
                          </Itemtemplate>
                        </asp:TemplateColumn>                            
                      </Columns>                
                    </asp:DataGrid> 
                    <div><a id="lnkAddPhone" runat="server">Add&nbsp;Phone&nbsp;Number</a></div>
                  </td>
                  <td>&nbsp;</td>
                  <td class="inputform">
                    <div class="inputformsectionheader">Ticket Information</div>
                    <table cellspacing="0">
                      <tr>
                        <td class="label">Ticket ID</td>
                        <td>&nbsp;</td>
                        <td ><asp:Label ID="lblTicketID" runat="server" /></td>
                      </tr>
                      <tr>
                        <td class="label">Status</td>
                        <td>&nbsp;</td>
                        <td ><asp:Label ID="lblStatus" runat="server" /></td>
                      </tr>
                      <tr>
                        <td class="label">Created</td>
                        <td>&nbsp;</td>
                        <td ><asp:Label ID="lblDateCreated" runat="server" /></td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
</div>
<div style="padding-right: 5px"><asp:TextBox runat="server" ID="txtNotes" TextMode="multiLine" ReadOnly="true" style="width: 100%; height: 50px;" /></div>
<div>
              <div class="label"><b>Model Number: </b>&nbsp;<asp:TextBox runat="server" ID="txtModel" />&nbsp;&nbsp;<b> Serial Number: </b>&nbsp;<asp:TextBox runat="server" ID="txtSerial" visible ="True"/>&nbsp;&nbsp;<b>DOP: </b>&nbsp;<asp:TextBox runat="server" ID="txtDOP" />&nbsp;&nbsp;<b>Service Type:</b>&nbsp;<asp:TextBox runat="server" ID="txtServiceType" visible ="true"/><asp:TextBox runat="server" ID="txtProgram" visible ="false"/></div>
              <div>&nbsp;</div> 
</div>
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <div class="label">Contact Note</div>
    <div style="padding-right: 3px;"><asp:TextBox ID="txtNote" runat="server" TextMode="multiLine" style="width: 100%; height: 200px;" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnSendEmail_Click" ID="btnSendEmail"  runat="server" Text="Send Welcome Email" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <asp:CheckBox ID="chkFirstContact" runat="server" Text="First Contact Done"/>&nbsp;&nbsp;
      <asp:Button OnClick="btnViewScript_Click" ID="btnView" runat="server" Text="View Script" />&nbsp;
      <asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;
      <asp:Button ID="btnOK" OnClick="btnOK_Click" Text="Submit" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
  <div id="Electrolux" runat="server" visible= "False">
    
    <p><span style='font-size:10.0pt;font-family:"Arial","sans-serif";'>
    <ol>
       <li>Hi, this is &quot;Your Name&quot; from Best Services of America with &quot;Customer Name&quot;</li><br/><br/>
       <li>We have received a work order to service the appliance your are having problems with.(Verify which appliance)</li><br/><br/>
       <li>To process your order I need to verify some information, do you have few minutes? Thank you.</li><br/><br/>
       <li>First I need to verify your home address: address, city, state and zip code</li><br/><br/>
       <li>I also would need to verify the model and serial number of the unit to be repaired. Would you be able to provide me the model number now?</li><br/><br/>
       <li>Would you be able to explain in details what seems to be the problem that you are having with the unit?</li><br/><br/>
       <li>Ok, at this point I have verified all the necessary information for service,</li><br/><br/>
        <li>Let me provide you the technicians information. Do you have a pen?</li><br/><br/>
        <li>(Provide techs name and number)</li><br/><br/>
       <li>If you have any question until then, you can please give us a call at 561.886.6699 and your reference number in our system is: (Provide ticketID)</li><br/><br/>
        <li>I will put you on hold for few minutes so I can try to reach the technician so we can schedule an appt. Is that ok with you? Thanks, one moment please.</li><br/><br/>
       <li>(conference tech with end user to schedule)</li><br/><br/>
       <li>Thank you for your time and information, and have a nice day!</li></span></p>
    
   </ol>    
   <div>&nbsp;</div>
 </div>
 <div id="Omni" runat="server" visible= "False">
    
    <p><span style='font-size:10.0pt;font-family:"Arial","sans-serif";'>
    <ol>
       <li>Hi, this is &quot;Your Name&quot; from Best Service of America with &quot;Customer Name&quot;</li><br/><br/>
       <li>We have received a work order to service the appliance your are having problems with.(Verify which appliance)</li><br/><br/>
       <li>Do you have a pen and a paper handy? I would like to give you our information in case you need to get in contact with us.</li><br/><br/>
       <li>(provide our phone number and ticket ID to end user)</li><br/><br/>
       <li>And I also would like to give you our fax number so you can fax us the proof of purchase for the unit which is required</li><br/>
           by the warranty company in order to provide service?</li><br/><br/>
       <li>(provide fax number to end user)</li><br/><br/>
	   <b>&quot;IF PROOF OF PURCHASE IS AVAILABLE&quot;</b><br/><br/>
       <li>Would you be able to explain in details what seems to be the problem you are having with the unit?</li><br/><br/>
       <li>Ok, at this point I have entered all the necessary information for technical support, if they feel they need any extra information<br/>
          to be able to order your part they should be contacting again.</li><br/><br/>
       <li>For now, once the part is ordered...can we ship it to your address we have on file? (Yes)</li><br/><br/>
       <li>Please once, you receive the part give us a call at 866.249.5033.</li><br/><br/>
       <li>And if you have any question until then, you can please give us a call on that same phone number and refer to the ticket number &quot;ticket ID&quot;.</li><br/><br/>
       <li>Thank you for your time and information, and have a nice day!</li></span><span ><o:p></o:p></span></p>
           <B>&quot;IF PROOF OF PURCHASE IS NOT AVAILABLE&quot;</B><br/><br/>
       <li>Without a proof of purchase, this repair will have to be handled as an out of warranty service. Would that be OK with you?</li><br/><br/>
       <li>As an out of warranty service, a $85,00 deposit fee is collected in order to send a technician onsite to diagnose the unit.<br/>
           The Technician will verify what is necessary to fix the unit and we will provide you an estimate for the cost of the repair.</li><br/><br/>
       <li>At that point, if you decide to go ahead and repair the unit, we will apply the $85.00 deposit towards the total amount of the repair,<br/>
	   and we will need to collect the balance for the repair prior from ordering the parts and continue with the service.</li><br/><br/>
       <li>If for some reason you decide not to accept our estimate, we will stay with the deposit in order to cover the costs of the visit from the technician.</li><br/><br/>
       <li>Do you agree with these terms?</li><br/><br/>
       <li>Please provide me with the credit or debit card, that you would like to make the payment with. (Charge the $50.00 deposit)</li></span><span ><o:p></o:p></span></p>
       <li>We will be assigning the ticket to a technician in your area and the technician should be contacting you within 24/48 hours.</li>  
 </ol>    
   <div>&nbsp;</div>
 </div>
 
</asp:Content>