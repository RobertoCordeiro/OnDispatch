<%@ Page Language="VB" masterpagefile="~/masters/agentdialog.master"%>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script language="VB" runat="server">
  Private _TicketID As Long = 0
  Private _mode As long = 0
  Private _BBID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = "Black Book"
            Master.PageTitleText = "Black Book"
            Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; Black Book"
    End If
    Try
      lblReturnUrl.Text = Request.QueryString("returnurl")
    Catch ex As Exception
    End Try
     Try
      _TicketID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _TicketID = 0
        End Try
        Try
      _mode = CType(Request.QueryString("mode"), Long)
    Catch ex As Exception
      _mode = 0
        End Try
        Try
      _BBID = CType(Request.QueryString("BBID"), Long)
    Catch ex As Exception
      _BBID = 0
        End Try
    If Not IsPostBack Then      
       LoadPartnerAgents()
       LoadBlackBookTypes()
       LoadDepartments()
       LoadManagers()
       
            lblBlackBookTypes.Text = "Black Book Type"
            lblDepartments.Text = "From What Department?"
            lblBlackBookIssues.Text = "Black Book Issue"
            If _TicketID <> 0 then
            
               LoadPhoneNumbers()
               txtTicketID.Text = _TicketID
               txtTicketID.Enabled = False
               Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
               Dim zip As New BridgesInterface.ZipCodeRecord(tkt.ConnectionString)
               Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
               Dim strHtml As String = "" 
               tkt.Load(_TicketID)
               zip.Load(tkt.ZipCode) 
               stt.Load(tkt.StateID)
               lnkMapIt.HRef = MapIt(tkt.Street, tkt.ZipCode)
       
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
               strHtml &= "<div>" & tkt.City & " " & stt.Abbreviation & " " & tkt.ZipCode
               lblAddress.Text = strHtml
               lblCountyName.Text = zip.CountyName 
               lblLocationName.Text = GetLocation(tkt.ZipCode)
              If _mode <> 0 then 
                If _BBID <> 0 then
                  Dim blk As New BridgesInterface.BlackBookRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                  blk.Load(_BBID)
                  
                  drpBlackBookTypes.Enabled = False
                  drpBlackBookTypes.SelectedValue = blk.blackbooktypeID
                  drpDepartments.Enabled = False
                  drpDepartments.SelectedValue = blk.DepartmentID 
                  LoadBlackBookIssues (blk.BlackBookTypeID)
                  LoadPartnerAgents()
                  
                  drpBlackBookIssues.Enabled = False
                  drpBlackBookIssues.SelectedValue = blk.BlackBookIssueID
                  drpPartnerAgents.Enabled = False
                  If drpDepartments.SelectedValue = "9" Then
                    lblPartnerAgents.Visible = "true"
                    lblPartnerAgents.Text = "Issue About What Technician?"
                    lblEmployees.Visible = "False"
                    drpPartnerAgents.Visible = "true"
                    drpEmployees.Visible = "false"
                    drpPartnerAgents.SelectedValue = blk.PartnerAgentID 
                  Else
                    LoadUsers(Master.InfoID)
                    lblEmployees.Visible = "true"
                    lblEmployees.Text = "Issue About What Employee?"
                    lblPartnerAgents.Visible = "false"
                    drpEmployees.Visible = "true"
                    drpPartnerAgents.Visible = "false"
                    drpEmployees.SelectedValue = blk.userID
            End If
                  drpManagers.Enabled = False
                  drpManagers.SelectedValue = blk.FollowUpManager 
                  txtDescription.Enabled = False
                  txtDescription.Text = blk.description
                  txtResolution.Enabled = False
                  txtResolution.Text = blk.resolution
                  btnSubmit.Visible = False
               end if

              end if  
             
           end if
       
    End If
  End Sub
  
  
  Private Sub LoadPartnerAgents()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListActivePartnersAgentsWithCalls2", "Login", "PartnerAgentID", drpPartnerAgents)
        drpPartnerAgents.Items.Add("Choose One")
        drpPartnerAgents.SelectedValue = "Choose One"
    End Sub
    
     Private Sub LoadBlackBookTypes()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListBlackBookTypes","BlackBookType","BlackBookTypeID", drpBlackBookTypes)
        
        drpBlackBookTypes.Items.Add("Choose One")
        drpBlackBookTypes.SelectedValue = "Choose One"
        
    End Sub
    
     Private Sub LoadDepartments()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListDepartments", "DepartmentName", "DepartmentID", drpDepartments)
        drpDepartments.Items.Add("Choose One")
        drpDepartments.SelectedValue = "Choose One"
        
    End Sub
    Private Sub LoadManagers()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spGetuserQualityManagers", "UserName", "UserID", drpManagers)
        drpManagers.Items.Add("Choose One")
        drpManagers.SelectedValue = "Choose One"
        
    End Sub
    
     Private Sub LoadBlackBookIssues(lngBlackBookType As long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDropDownList("spListBlackBookIssuesByTypeID","@BlackBookTypeID",lngBlackBookType,"BlackBookIssue","BlackBookIssueID",drpBlackBookIssues)
        
        drpBlackBookIssues.Items.Add("Choose One")
        drpBlackBookIssues.SelectedValue = "Choose One"
    End Sub
    
    Private Sub LoadUsers(ByVal lngInfoID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
       
        ldr.LoadSingleLongParameterDropDownList("spListAllActiveUsersByCompanyID", "@InfoID", lngInfoID, "UserName", "UserID", drpEmployees)
        drpEmployees.Items.Add("Choose One")
        drpEmployees.SelectedValue = "Choose One"
    End Sub
    
    Private Sub MessageDelivered(ByVal S As Object, ByVal E As EventArgs)
      Dim msg as New BridgesInterface.PartnerAgentMessageRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strChangeLog as String = ""
      Dim intTotalMessages as Integer 

      msg.Load(Ctype(lblPartnerAgentMessageID.text,Long))
      msg.Delivered = True 
      msg.DeliveredDate = Datetime.Now()
      msg.DeliveredBy = Master.WebLoginID
      msg.Save(strChangeLog)
      
        EmailAdmin(msg.CreatedBy, msg.PartnerAgentID, msg.Message)
        
      intTotalMessages = getTotalMessages(drpPartnerAgents.SelectedValue )
      if intTotalMessages > 0 then
         'lblTotalMessages.Text = "Total Messages: " & intTotalMessages
         GetMessage(drpPartnerAgents.SelectedValue )
      else
       ClearForm()    
      end if
      
    End Sub
    
    Private Sub SelectIndexChange_BlackBookTypes(ByVal sender As Object, ByVal e As System.EventArgs)
    
        If drpBlackBookTypes.SelectedValue <> "Choose One" Then
            LoadBlackBookIssues(drpBlackBookTypes.SelectedValue)
            
        End If
    End Sub
    Private Sub SelectIndexChange_Departments(ByVal sender As Object, ByVal e As System.EventArgs)
    
        If drpDepartments.SelectedValue <> "Choose One" Then
            If drpDepartments.SelectedValue = "9" Then
                lblPartnerAgents.Visible = "true"
                lblPartnerAgents.Text = "Issue About What Technician?"
                lblEmployees.Visible = "False"
                drpPartnerAgents.Visible = "true"
                drpEmployees.Visible = "false"
            Else
                LoadUsers(Master.InfoID)
                lblEmployees.Visible = "true"
                lblEmployees.Text = "Issue About What Employee?"
                lblPartnerAgents.Visible = "false"
                drpEmployees.Visible = "true"
                drpPartnerAgents.Visible = "false"
            End If
            
        End If
    End Sub
    Private Function GetTotalMessages (lngPartnerAgentID as Long) as Integer 
            Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTotalMessagesForPartnerAgent")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = CType(drpPartnerAgents.SelectedValue, Long)
            cnn.Open()
            cmd.Connection = cnn
            Return cmd.ExecuteScalar 
            
            cnn.Close()
    
    end Function
    Private Sub btnSendMessage_Click (ByVal S As Object, ByVal E As EventArgs)
    Dim strChangelog As String = ""
     If Iscomplete then
        Dim blk As New BridgesInterface.BlackBookRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        blk.Add(txtTicketID.text,DateTime.Now,txtDescription.Text,txtResolution.Text,drpManagers.selectedvalue,Master.WebLoginID,drpBlackBookTypes.SelectedValue,drpDepartments.SelectedValue,drpBlackBookIssues.SelectedValue)
        If drpPartnerAgents.Visible = True then
          blk.PartnerAgentID  = drpPartnerAgents.selectedValue
        end if
        If drpEmployees.Visible = True then
          blk.userID = drpEmployees.selectedValue
        end if
        blk.Save(strChangeLog)

        Clearform ()
    end if
    end sub
    
    Private Function IsComplete () As boolean
    Dim boolResult As Boolean 
    boolResult = True
     If drpBlackBookTypes.SelectedValue = "Choose One" then
       boolResult = False
       MsgBox("You must Choose a Black Book Type")
     end if
     If drpDepartments.SelectedValue = "Choose One" then
       boolResult = False
       MsgBox ("You must Choose a Department")
     end if
     If drpBlackBookIssues.SelectedValue = "Choose One" then
       boolResult = False
       MsgBox ("You must Choose a Black Book Issue")
     end if
     If drpPartnerAgents.Visible = True then
        If drpPartnerAgents.SelectedValue = "Choose One" then
          boolResult = False
          MsgBox ("You must Choose a Technician")
        end if
     end if
     If drpEmployees.Visible = True then
       If drpEmployees.SelectedValue = "Choose One" then
         boolResult = False
         MsgBox("You must Choose an Employee")
       end if
     end if
     If drpManagers.selectedValue = "Choose One" then
       boolResult = False
       MsgBox("You must choose a Follow Up Manager for this Issue")
     
     end if
     If txtResolution.Text.ToString.Length = 0 then
       boolResult = False
       MsgBox("You must enter an Expected Resolution to the Issue")
     end if
     If txtDescription.Text.ToString.Length = 0 then
       boolResult = False
       MsgBox ("You must enter a Description of the Issue")
     end if
     Return boolResult
    end function
    
    Private Sub GetMessage (lngPartnerAgentID as Long)  
            Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPartnerAgentMessageByPartnerAgentID")
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = CType(drpPartnerAgents.SelectedValue, Long)
            cnn.Open()
            cmd.Connection = cnn
            cmd.ExecuteScalar 
            Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
            While dtr.Read
              lblCreatedDate.text = "Created On: " & dtr("CreatedDate")
              lblCreatedBy.text = "Sent By: " & GetUserName(dtr("CreatedBy"))
              txtMessage.Text = dtr("Message")
              lblPartnerAgentMessageID.text = dtr("PartnerAgentMessageID")
              getDelivered.Checked = dtr("delivered")
              
            End While
            cnn.Close()
    
    end Sub
    
    Private Function GetUserName (lngLogin as long) as String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd As New System.Data.SqlClient.SqlCommand("spGetWebLoginUser")
            Dim strUserName as string
            struserName = ""
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.Parameters.Add("@Login", Data.SqlDbType.Int).Value = lngLogin
            cnn.Open()
            cmd.Connection = cnn
            cmd.ExecuteScalar 
            Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
            While dtr.Read
             
              strUserName = dtr("FirstName") & "  " & dtr("LastName")
            End While
            GetUserName = strUserName
            cnn.Close()
  
    End Function
    
    Private sub ClearForm ()
      'drpPartnerAgents.SelectedValue = "Choose One"
      drpBlackBookTypes.SelectedValue = "Choose One"
      drpDepartments.SelectedValue = "Choose One"
      drpBlackBookIssues.SelectedValue = "Choose One"
      drpPartnerAgents.SelectedValue = "Choose One"
      drpPartnerAgents.Visible = False
      lblPartnerAgents.Visible = false
      drpEmployees.SelectedValue = "Choose One"
      drpEmployees.Visible = False
      lblEmployees.Visible = false
      txtDescription.Text = ""
      txtResolution.Text = ""
      drpManagers.SelectedValue = "Choose One"
      
    end sub
    Private Sub GetOldMessages()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadTwoLongParameterDataGrid("spListOldPartnerAgentMessages", "@PartnerAgentID",drpPartnerAgents.SelectedValue ,"@UserID",Master.WebLoginID, dgvNotes)
    'For Each itm As DataGridItem In dgvNotes.Items
    '  If Not CType(itm.Cells(1).Text, Boolean) Then
     '   itm.CssClass = "selectedbandbar"
     ' End If
    'Next
    
    end sub
    Private Sub btnClose_Click (ByVal S As Object, ByVal E As EventArgs)
      'Response.Redirect(lblReturnURL.text, True)
      btnClose.Attributes.Add("onclick","window.close()")
      
    end sub
    Private Sub MsgBox(ByVal strMessage As String)
        'Begin building the script 
        Dim strScript As String = "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
        strScript += "alert(""" & strMessage & """)" & vbCrLf
        strScript += "<" & "/" & "SCRIPT" & ">"
        'Register the script for the client side 
        ClientScript.RegisterStartupScript(GetType(String), "messageBox", strScript)
    End Sub
    Private Sub EmailAdmin(ByVal lngLoginID As Long, ByVal lngPartnerAgentID As Long, ByVal strMessage As String)
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        par.Load(lngPartnerAgentID)
        eml.Subject = "Your Message has been delivered to the technician:" & par.FirstName & " " & par.LastName
        eml.Body = strMessage
        eml.SendFrom = "DoNotReply@bestservicers.com"
        usr.Load(GetUserID(lngLoginID))
        
        eml.SendTo = usr.Email
           
        eml.Send()
    End Sub
    Private Function GetUserID(ByVal lngLogin As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetWebLoginUser")
        Dim lngUserID As Long
        lngUserID = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@Login", Data.SqlDbType.Int).Value = lngLogin
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
             
            lngUserID = dtr("UserID")
        End While
        GetUserID = lngUserID
        cnn.Close()
  
    End Function
    Private Function MapIt(ByVal strAddress As String, ByVal strZipCode As String) As String
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
        strReturn = ggl.MapAddress(strAddress, strZipCode)
    Return strReturn
  End Function
  Private Function GetLocation(ByVal strZipCode As String) As String
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetLocationByZipCodeID")
        Dim zic As New BridgesInterface.ZipCodeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        zic.Load(strZipCode)
        Dim lngZipCodeID As Long
        lngZipCodeID = zic.ZipCodeID
        Dim strLocationName As String
        strLocationName = ""
        cmd.Parameters.Add("@ZipCodeID", Data.SqlDbType.VarChar).Value = lngZipCodeID
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            strLocationName = dtr("LocationName")
        End While
        Return strLocationName
        cnn.Close()
    End Function
    Private Sub LoadPhoneNumbers()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListTicketPhoneNumbers", "@TicketID", _TicketID, dgvPhoneNumbers)
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangeSignature" runat="server">
    <table style="width: 600px;">
      <tbody>
        <tr>
          <td >
            <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;" runat="server">
              <div class="errorzone" id="divError" runat="server" visible="false" />
              <table width="100%";>
               <tr>
                 <td >
                    <div class="label"><asp:Label ID="lblBlackBookTypes" runat="server"></asp:Label> </div>
                    <asp:DropDownList ID="drpBlackBookTypes" runat="server" OnSelectedIndexChanged="SelectIndexChange_BlackBookTypes" AutoPostBack = "true"  /> 
                    <div>&nbsp;</div>
                    <div class="label"><asp:Label ID="lblDepartments" runat="server"></asp:Label></div>
                   <asp:DropDownList ID="drpDepartments" runat="server" OnSelectedIndexChanged ="SelectIndexChange_Departments" AutoPostBack="true" />
                   <div>&nbsp;</div>
                   <div class="label"><asp:Label ID="lblBlackBookIssues" runat="server"></asp:Label> </div>
                   <asp:DropDownList ID="drpBlackBookIssues" runat="server"  />
                   <div>&nbsp;</div>
                   <div class="label"><asp:Label ID="lblPartnerAgents" runat="server"></asp:Label></div>
                    <asp:DropDownList ID="drpPartnerAgents" runat="server" visible="false"  /> 
                    <div class="label"><asp:Label ID="lblEmployees" runat="server"></asp:Label></div> 
                    <asp:DropDownList ID="drpEmployees" runat="server"  visible="false"/>
                    <div>&nbsp;</div>
                    <div class="label"> Select Follow Up Manager:</div>
                   <div><asp:DropDownList ID="drpManagers" runat="server"  /> </div>
                </td>
                 <td rowspan = >
                   <div class="inputformsectionheader">Refering to Ticket ID:</div>
                         <div>&nbsp;</div>
                         <div><asp:TextBox ID="txtTicketID" runat ="server" ></asp:TextBox></div>
                         <div>&nbsp;</div>
                         <div class="inputformsectionheader">Contact Information</div>
                         <div><asp:Label ID="lblContact" runat="server" /></div>
                         <div><a target="_blank" id="lnkMapIt" runat="server"><asp:Label ID="lblAddress" runat="server" /></a></div>
                         <div>County: <asp:Label ID="lblCountyName" runat="server" /></div>
		                 <div>Location: <asp:Label ID="lblLocationName" runat="server" /></div>
		                 <div>&nbsp;</div>
		                 <div class="inputformsectionheader">Phone Numbers</div>
                    <asp:DataGrid style="width:100%; background-color: White;" ID="dgvPhoneNumbers" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
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
               </tr>
              </table>
              <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex = "0" >
                <asp:View ID="vwNewNotes"  runat="server">
                   <table width="100%";>
                     <tr>
                       <td colspan ="3">
                        <div>&nbsp;</div>
                        <div class="label">Issue Description:</div>
                        <asp:TextBox ID="txtDescription" TextMode="MultiLine" runat="server" style="width: 99%; height: 100px;" />
                        <div>&nbsp;</div>
                       </td>
                     </tr>
                     <tr>
                       <td>
                         <div class="label">Expected Resolution about Issue:</div>
                         <asp:TextBox ID="txtResolution" TextMode="MultiLine" runat="server" style="width: 99%; height: 100px;" />
                        <div>&nbsp;</div>
                        <div style="text-align: right"><asp:Button ID="btnSubmit"  Text="Submit" runat="Server" OnClick ="btnSendMessage_Click" />&nbsp;&nbsp;&nbsp;<asp:Button ID="btnClose"  Text="Close" runat="Server" OnClick ="btnClose_Click" /></div>
                        <div>&nbsp;</div>
                        <div style="text-align: right"><asp:Label ID="lblReturnURL" runat ="server" Visible = "false"  /></div>
                       </td>
                     </tr>
                   </table>
                </asp:View>
                <asp:View ID="vwToBeDelivered"  runat="server">
                 <asp:Label ID="lblCreatedDate" runat ="server" Visible = "true"  /> &nbsp;&nbsp;<asp:Label ID="lblCreatedBy" runat ="server" /> <asp:Label ID="lblPartnerAgentMessageID" runat ="server" Visible="false" />
                 <asp:TextBox ID="txtMessage" TextMode="MultiLine" runat="server" style="width: 99%; height: 100px;" ReadOnly = "true" />
                   <div style="text-align: right"><asp:CheckBox ID="GetDelivered" runat="server"  Text="Delivered" OnCheckedChanged="MessageDelivered"  AutoPostBack="true"  /></div>
                </asp:View>
                <asp:View ID="vwDelivered"  runat="server">
                   <asp:DataGrid ID="dgvNotes" runat="server" ShowHeader="false" AutoGenerateColumns="false" style="background-color: White;">
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn HeaderText="ID" DataField="PartnerAgentMessageID" Visible="false" />
                <asp:TemplateColumn ItemStyle-Width="1%" ItemStyle-VerticalAlign="top" >
                  <ItemTemplate>
                    <div style="white-space:nowrap;">Date:<%# Databinder.eval(Container.DataItem, "CreatedDate") %></div>
                    <div>Created By:<%# Databinder.eval(Container.DataItem, "Author") %></a></div>
                    <div>Delivered: <%# Databinder.eval(Container.DataItem, "Delivered") %></div>
                    <div>Delivered Date: <%#DataBinder.Eval(Container.DataItem, "DeliveredDate")%></div>
                    <div>Delivered By: <%#DataBinder.Eval(Container.DataItem, "Deliverer")%></div>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn ItemStyle-Wrap="true">
                  <Itemtemplate>
                  <%# Databinder.eval(Container.DataItem, "Message").ToString.Replace(environment.NewLine,"<br />") %>
                  </Itemtemplate>
                </asp:TemplateColumn>
              </Columns>
            </asp:DataGrid>    
                
                </asp:View>
             </asp:MultiView>
             </div>
             <div>&nbsp;</div>
          </td>
        </tr>
      </tbody>
    </table>
  </form>
</asp:Content>