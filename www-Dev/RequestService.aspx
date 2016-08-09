<%@ Page Language="vb" MasterPageFile="~/masters/euRequest.master" %>

<%@ MasterType VirtualPath="~/masters/euRequest.master" %>
<%@ Import Namespace="BridgesInterface.UserRecord" %>
<%@ Register Src="~/controls/BasicPhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>

<script runat="server">
  
  Private Sub TrackTraffic()
    Exit Sub
    Dim tm As New cvTrafficMaster.TransactionRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    tm.Add(Request.ServerVariables("SCRIPT_NAME"))
    If Not IsNothing(Request.ServerVariables("HTTP_REFERER")) Then
      tm.Referrer = Request.ServerVariables("HTTP_REFERER")
    End If
    If Not IsNothing(Request.ServerVariables("HTTP_USER_AGENT")) Then
      tm.UserAgent = Request.ServerVariables("HTTP_USER_AGENT")
    End If
    If Not IsNothing(Request.ServerVariables("REMOTE_ADDR")) Then
      tm.RemoteAddress = Request.ServerVariables("REMOTE_ADDR")
    End If
    If Not IsNothing(Request.ServerVariables("QUERY_STRING")) Then
      tm.QueryString = Request.ServerVariables("QUERY_STRING")
    End If
    If Not IsNothing(Request.ServerVariables("SERVER_NAME")) Then
      tm.ServerName = Request.ServerVariables("SERVER_NAME")
    End If
    Dim strChangelog As String = ""
    tm.Save(strChangelog)
    Dim tf As New cvTrafficMaster.FlagRecord(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    tf.LoadByRemoteHost(tm.RemoteAddress)
    If tf.FlagID > 0 Then
      Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      eml.SendFrom = "services@bestservicers.com"
      eml.SendTo = "services@bestservicers.com"
      eml.Subject = "Possible Login Security Breach!"
      eml.Body = "<p>A user at a flagged IP Address tried to access the system, this is a possible security breach!</p>"
      eml.Body &= "<div>Details</div>"
      eml.Body &= "Login:" & txtEmailAddress.Text & "<br />"
      eml.Send()
    End If
  End Sub
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Dim strRef As String = Request.QueryString("ReturnUrl")
    Dim strDefaultText As String = ""
    TrackTraffic()
    If Not IsNothing(strRef) Then
      Try
        Select Case strRef.Split("/")(1).ToLower
          Case "partners"
           ' lblWelcome.Text = ""
          Case "agentinterface"
            'lblWelcome.Text = ""
          Case "clients"
            'lblWelcome.Text = ""
          Case "eu"
            'lblWelcome.Text = ""  
          Case Else
            'lblWelcome.Text = strDefaultText
        End Select
      Catch ex As Exception
        'lblWelcome.Text = strDefaultText
      End Try
    Else
      'lblWelcome.Text = strDefaultText
    End If
    if not Ispostback then
      main.ActiveViewIndex = 0
      loadstates()
      
    end if
    
    
  End Sub
  
  ''' <summary>
  ''' Determines if the input is complete
  ''' </summary>
  Private Function IsComplete() As Boolean
   Dim val As New cvCommon.Validators
   Dim blnReturn As Boolean = True
   Dim strError As String = ""

   If phn.AreaCode.Trim.Length + phn.LineNumber.Trim.Length + phn.Exchange.Trim.Length > 0 Then
      If phn.AreaCode.Trim.Length <> 3 Then
        blnReturn = False
        strError &= "<li>" & "Phone Area Code is Invalid" & "</li>"
      End If
      If phn.Exchange.Trim.Length <> 3 Then
        blnReturn = False
        strError &= "<li>" & "Phone Exchange is Invalid" & "</li>"
      End If
      If phn.LineNumber.Trim.Length <> 4 Then
        blnReturn = False
        strError &= "<li>" & "Phone Line Number is Invalid" & "</li>"
      End If
    Else
      blnReturn = False
      strError &= "<li>" & "Phone number is Required" & "</li>"
    End If
    'If txtReferenceNumber.Text.Trim.Length = 0 Then
    '  blnReturn = False
     ' strError &= "<li>A Reference Number is required</li>"
    'End If
    If txtEmailAddress.Text.Trim.Length = 0 Then
      If Not val.IsValidEmail(txtEmailAddress.Text.Trim) Then
        blnReturn = False
        strError &= "<li>Email does not appear to be valid</li>"
      End If
    End If
    If Not blnReturn Then
      strError = "The following errors occured...<br /><ul class=""errortext"">" & strError & "</ul>"
      lblErrorPage3.Text = strError
      
    End If
    Return blnReturn
  End Function
  
  ''' <summary>
  ''' Attempts to validate the login information
  ''' </summary>
  Private Sub AttemptLogin(ByVal S As Object, ByVal E As EventArgs)
    Dim lngTicketID as long = 0
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
       
    If IsComplete() Then
      Dim strRef As String = Request.QueryString("ReturnUrl")
      Dim x As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
      'lngTicketID = GetCredentials (txtReferenceNumber.Text,phn.AreaCode,phn.Exchange ,phn.LineNumber )
      If lngTicketID > 0 then
          'If x.Validate(txtUserName.Text.Trim, txtPassword.Text.Trim) Then
                FormsAuthentication.SetAuthCookie("22", False)
        
          If IsNothing(strRef) Then
              Dim tkt as New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
              Dim strChangeLog as String = ""
              tkt.Load (lngTicketID)
              tkt.Email = txtEmailAddress.text
              tkt.Save(strChangeLog)

              Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
          Else
            Response.Redirect(strRef)
          End If
       Else
          'lngTicketID = GetCredentials2(txtReferenceNumber.Text,phn.AreaCode,phn.Exchange,phn.LineNumber )
          If lngTicketID > 0 then 
                    FormsAuthentication.SetAuthCookie("22", False)
        
             If IsNothing(strRef) Then
               Dim tkt as New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBcnn"))
               Dim strChangeLog as String = ""
               tkt.Load (lngTicketID)
               tkt.Email = txtEmailAddress.text
               tkt.Save(strChangeLog)

               Response.Redirect("/eu/ticket.aspx?id=" & lngTicketID)
             Else
               'Response.Redirect("/eu/default.aspx")
               blnReturn = False
                strErrors &= "<li>No record has been found with information provided.</li>"
                
                'lblErrorPage3.Text = strErrors
                
               
             End If
          else
            'Response.Redirect("/eu/default.aspx")
            blnReturn = False
            strErrors &= "<li>No record has been found with information provided.</li>"
           
            
          end if  
        end if  
     end if
  End Sub
  
    Private Function GetCredentials(strReferenceNumber as String, strAreaCode as String, strExchange as String, strLineNumber as string)as long
        Dim blnReturn As Boolean = True
        Dim strErrors As String = ""
        Dim lngTicket As long = 0
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketByPhoneReferenceNumber")
        cmd.Parameters.Add("@ReferenceNumber", Data.SqlDbType.VarChar).Value = strReferenceNumber
        cmd.Parameters.Add("@PhoneNumber1", Data.SqlDbType.VarChar).Value = strAreaCode
        cmd.Parameters.Add("@PhoneNumber2", Data.SqlDbType.VarChar).Value = strExchange
        cmd.Parameters.Add("@PhoneNumber3", Data.SqlDbType.VarChar).Value = strLineNumber
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTicket = dtr("TicketID")
            If lngTicket > 0 Then
              Return lngTicket
            Else
              if IsNumeric(strReferenceNumber) then
                 lngTicket =  GetCredentials2 (Ctype(strReferenceNumber,Long),strAreaCode,strExchange,strLineNumber)
              else
                blnReturn = False
                strErrors &= "<li>No record has been found with information provided.</li>"
                
                Return lngTicket
              end if
            End If
        End While
        cnn.Close()
       
    end Function 
    
     Private Function GetCredentials2(lngTicketID as long, strAreaCode as String, strExchange as String, strLineNumber as string)as long
        Dim blnReturn As Boolean = True
        Dim strErrors As String = ""
        Dim lngTicket As long = 0
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetTicketByPhoneTicketID")
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.int).Value = lngTicketID
        cmd.Parameters.Add("@PhoneNumber1", Data.SqlDbType.VarChar).Value = strAreaCode
        cmd.Parameters.Add("@PhoneNumber2", Data.SqlDbType.VarChar).Value = strExchange
        cmd.Parameters.Add("@PhoneNumber3", Data.SqlDbType.VarChar).Value = strLineNumber
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngTicket = dtr("TicketID")
            If lngTicket > 0 Then
              Return lngTicket
            Else
                blnReturn = False
                strErrors &= "<li>No record has been found with information provided.</li>"
                
                Return lngTicket
            End If
        End While
        
        cnn.Close()
       
    end Function 
    
    Private Sub btnMoveNext_Click (ByVal sender As Object, e As System.Web.UI.ImageClickEventArgs)
     
        Select Case main.ActiveViewIndex.ToString
            
            Case Is = 0 'Type of Service needed
                if IsPage1Complete then
                  main.ActiveViewIndex = 1 
                else
                  lblErrorPage1.Visible = True
                end if
                
            Case Is = 1 ' Address
                if IsPage2Complete then
                  main.ActiveViewIndex = 2 
                else
                  lblErrorPage2.Visible = True
                end if
                
            Case Is = 2 'contact
                if IsPage3Complete then
                  main.ActiveViewIndex = 3 
                else
                  lblErrorPage3.Visible = True
                end if
            Case Is = 3 'unit information
                if IsPage4Complete then
                  main.ActiveViewIndex = 4 
                else
                  lblErrorPage4.Visible = True
                end if
            Case Is = 4 'date for service
                if IsPage5Complete then
                 If IsDuplicate(30,txtSerialNumber.Text) = 0 then
                   main.ActiveViewIndex = 5 
                   createTicket()
                 else
                   lblErrorPage5.Text = "Our system indicates that there is already a service ticket in our database for your unit. Please call 561.886.6699 for assistance."
                   lblErrorPage5.Visible = True
                 end if
                else
                  lblErrorPage5.visible = True
                end if
            Case Is = 5 'payment
                  main.ActiveViewIndex = 6 
        End Select
    
    
    
    End Sub
    Private Sub btnMoveBack_Click (ByVal sender As Object, e As System.Web.UI.ImageClickEventArgs)
    Select Case main.ActiveViewIndex.ToString
            
            Case Is = 5
                main.ActiveViewIndex = 4
            Case Is = 4
                main.ActiveViewIndex = 3
            Case Is = 3
                main.ActiveViewIndex = 2
            Case Is = 2
                main.ActiveViewIndex = 1
            Case Is = 1
                main.ActiveViewIndex = 0 
            
        End Select
    
    End Sub
    
    
    Private Sub CreateTicket ()
    'for testing purpose Customer ID = 1
    'if IsDuplicate(1,txtSerialNumber.text) = 0 then
    
    if IsDuplicate(30,txtSerialNumber.text) = 0 then
                
                'divErrors.Visible = False
                Dim strChangeLog As String = ""
                Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim srv As New BridgesInterface.ServiceRecord(tkt.ConnectionString)
                Dim phr As New BridgesInterface.TicketPhoneNumberRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim lngTypeOfService as long
                
                if typeofservice.SelectedValue <> "" then
                
                  Select Case typeofservice.SelectedValue 
                  
                    case = 1 'Appliance Repair
                      lngTypeofService = 199 ' 75 
                    Case = 2 'Flat Panel TV repair
                      lngTypeofService = 206
                    Case = 3 'Air Conditioner Repair
                      lngTypeofService = 282
                    Case = 4 'Appliance Installation
                      lngTypeofService = 284
                    case = 5 'Flat Panel TV Installation
                      lngTypeofService = 286
                    case = 6 'Air conditioner maintenance
                      lngTypeofService = 289
                  end select
                
                  srv.Load(CType(lngTypeofService, Long))
                  'for testing purpose customer ID = 1
                  'tkt.Add(1, 1,  1, 1, cbxState.selectedvalue, srv.ServiceID, srv.PayIncrementID,   4, 1, 1, srv.MinimumCharge, srv.ChargeRate, srv.AdjustmentCharge, txtFirstName.text, txtLastName.text, txtAddress.text, txtCity.text, txtZipCode.text, txtProblemDescription.Text, Now(), Now())
                  
                tkt.Add(22, 15, 30, 1, cbxState.SelectedValue, srv.ServiceID, srv.PayIncrementID, 4, 1, 1, srv.MinimumCharge, srv.ChargeRate, srv.AdjustmentCharge, txtFirstName.Text, txtLastName.Text, txtAddress.Text, txtCity.Text, txtZipCode.Text, txtProblemDescription.Text, Now(), Now())
                  
                  tkt.SerialNumber = txtSerialNumber.Text
                  tkt.ReferenceNumber1 = txtSerialNumber.text
                  tkt.ReferenceNumber2 = txtSerialNumber.Text 
                  tkt.Manufacturer = txtManufacturer.Text & " " & txtUnittype.text
                  tkt.Model = txtModelNumber.Text
                  tkt.Notes = txtManufacturer.Text & " " & txtUnitType.text & ": " & txtProblemDescription.Text
                  tkt.Instructions = srv.Instructions
                  tkt.Description = srv.Description
                tkt.AssignedTo = AssignAgent(LoadClosestPartnerAgents(tkt.ZipCode, 50))
                
                phr.Add(tkt.TicketID, 1, 22, 1, phn.AreaCode, phn.Exchange, phn.LineNumber, True)
                  phr.Save(strChangeLog)
                
                If phnCell.AreaCode.Trim.Length > 0 Then
                    phr.Add(tkt.TicketID, 4, 22, 1, phnCell.AreaCode, phnCell.Exchange, phnCell.LineNumber, True)
                    phr.Save(strChangeLog)
                End If
                
               Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                tnt.Add(tkt.TicketID, 2204, 22, "Ticket Added to System via WebSite.")
                tnt.CustomerVisible = True
                tnt.Acknowledged = True
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Save(strChangeLog)
                
                tnt.Add(tkt.TicketID, 2204, 22, "End user requesting service to be done on: " & Calendar1.SelectedDate)
                tnt.CustomerVisible = False
                tnt.PartnerVisible = False
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Save(strChangeLog)
               end if
               
               Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
               Dim stt as New BridgesInterface.StateRecord (system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
               Dim strBody as string
               eml.Subject = "New Service Call Addedd Via Website!"
               stt.Load(Ctype(cbxState.SelectedValue,Long) )
               
              strBody = "<b>" & "New Service Call Via Website - Ticket Information: " & "</b><br /><br />"
              strBody = strBody & "<b>" & "TicketID: " & tkt.TicketID & "</b><br />"
              strBody= strBody & "<b>" & "Customer Name: " & "</b> " & txtFirstName.Text  & " " & txtLastName.text & "<br />"
              strBody= strBody & "<b>" & "Address: " & "</b> " & txtAddress.text & "<br />"
              strBody= strBody & "<b>" & "City,State,Zip: " & "</b> " & txtCity.text & "  " & stt.Abbreviation & ", " & txtZipCode.text & "<br />"
              'strBody = strBody & "City,State,Zip: " & tkt.City & ", FL " & tkt.ZipCode & ""<br />""
              strBody= strBody & "<b>" & "CustomerNumber: " & "</b> " & txtSerialNumber.text & "<br />"
              strBody= strBody & "<b>" & "Customer PO Number: " & "</b> " & txtSerialNumber.text & "<br />"
              strBody = strBody & "<b>" & "Type of Service: " & "</b> " & txtUnitType.text & "<br />"
              strBody = strBody & "<b>" & "Problem Description: " & "</b> " & txtProblemDescription.text & "<br />"
              strBody = strBody & "<b>" & "End User Requesting service to be done on:" & "</b>" & Calendar1.SelectedDate 
    
              eml.Body = "A new Service has been created via Website. Need special attention!"  & "<br /><br />" & strBody
              eml.SendFrom = "webservicerequest@bestservicers.com"
              eml.SendTo = "services@bestservicers.com"
              eml.Send()
              
              tkt.Save(strChangeLog) 
      end if
    End Sub
    
    Private Function IsPage1Complete () as Boolean 
    Dim blnReturn As Boolean = True
    Dim strError As String = ""
    Dim str as String

    str = TypeofService.SelectedValue 
    If TypeofService.SelectedValue <> ""  then
      blnreturn = True
    else
      blnreturn = False
      strError = "You must choose a type of service"
      lblErrorPage1.text = strError
    end if
    IsPage1Complete = blnReturn
    End Function
    
    Private Function IsPage2Complete () as Boolean 
    Dim blnReturn As Boolean = True
    Dim strError As String = ""
    lblErrorPage2.text = ""
        
    if txtAddress.Text <> "" then
      blnReturn = True
    else
      blnReturn = False
      lblErrorPage2.Text = "Address is neeeded."
    end if
    
    if txtCity.Text <> "" then
      blnReturn = True 
    else
      blnReturn = False
      lblErrorPage2.Text = lblErrorPage2.Text & " City is needed."
    end if
    
    if cbxState.selectedvalue <> "" then
      blnReturn = True 
    else
         blnReturn = False
      lblErrorPage2.text = lblErrorPage2.Text & " State is needed."
    end if
    
    if txtZipCode.Text <> "" then
      blnReturn = True
    else
      blnReturn = False
      lblErrorPage2.Text = lblErrorPage2.Text & " ZipCode is needed."
    end if
    
    IsPage2Complete = blnReturn
    End Function
    
    Private Function IsPage3Complete () as Boolean 
    Dim blnReturn As Boolean = True
    Dim strError As String = ""
    lblErrorPage3.text = ""
    strError = ""
    
    if txtFirstName.Text <> "" then
      blnReturn = True 
    else
      blnReturn = False
      lblErrorPage3.Text = "First Name needed."
    end if
    
    If txtLastName.Text <> "" then
      blnReturn = True 
    else 
      blnReturn = False
      lblErrorPage3.text = lblErrorPage3.text & " Last Name needed."
    end if
    
    If phn.AreaCode.Trim.Length + phn.LineNumber.Trim.Length + phn.Exchange.Trim.Length > 0 Then
      If phn.AreaCode.Trim.Length <> 3 Then
        blnReturn = False
        strError &= "<li>" & "Phone Area Code is Invalid" & "</li>"
      End If
      If phn.Exchange.Trim.Length <> 3 Then
        blnReturn = False
        strError &= "<li>" & "Phone Exchange is Invalid" & "</li>"
      End If
      If phn.LineNumber.Trim.Length <> 4 Then
        blnReturn = False
        strError &= "<li>" & "Phone Line Number is Invalid" & "</li>"
      End If
    Else
      blnReturn = False
      strError &= "<li>" & "Home number is Required" & "</li>"
    End If
      lblErrorPage3.text = lblErrorPage3.text & " " & strError
    if txtEmailAddress.Text <> "" then
      Dim val As New cvCommon.Validators
      If Not val.IsValidEmail(txtEmailAddress.Text) Then
        blnReturn = False
        strError &= "<li>" & "Email does not appear to be valid" & "</li>"
      else
        blnReturn = True
      End If
    else
      blnReturn = False
      strError &= "<li>" & "Email Address Needed" & "</li>"
    end if
      lblErrorPage3.text = lblErrorPage3.text & " " & strError
    IsPage3Complete = blnReturn
    end Function
    
    Private Function IsPage4Complete () as Boolean 
     Dim blnReturn As Boolean = True
     Dim strError As String = ""
     lblErrorPage4.text = ""
     
     if txtManufacturer.Text <> "" then
       blnReturn = True 
     else
       blnReturn = False
       lblErrorPage4.text &= "<li>" & "Manufacturer name needed" & "<li>" 
     end if
     
     if txtUnitType.Text <> "" then
       blnReturn = True 
     else
       blnReturn = False
       lblErrorPage4.text &= "<li>" & "Unit Type needed" & "<li>" 
     end if
     
     if txtModelNumber.Text <> "" then
       blnReturn = True 
     else
       blnReturn = False
       lblErrorPage4.text &= "<li>" & "Model Number needed" & "<li>"
     end if
     
     If txtSerialNumber.Text <> "" then
       blnReturn = True 
     else
       blnReturn = False
       lblErrorPage4.text &= "<li>" & "Serial Number needed" & "<li>"
     end if
     
     if txtProblemDescription.Text <> "" then
       blnReturn = True 
     else
       blnReturn = False
       lblErrorPage4.text &= "<li>" & "Problem Description needed" & "<li>"
     end if
     IsPage4Complete = blnReturn
    end Function
    
    Private Function IsPage5Complete () as Boolean 
     Dim blnReturn As Boolean = True
     Dim strError As String = ""
     lblErrorPage5.text = ""
     
     if Calendar1.SelectedDate <> "#12:00:00 AM#" then
       blnReturn = True  
     else
       blnReturn = False
       lblErrorPage5.text &= "<li>" & "You must choose a service date." & "<li>"
     end if
     IsPage5Complete = blnReturn
     
    end function
    
     Private Function IsDuplicate(ByVal lngCustomerID As Long, ByVal strCustomerPO As String) As Integer
        Dim blnReturn As Boolean = false
        Dim strErrors As String = ""
        Dim intTotal As Integer = 0
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsDuplicateTicket")
        cmd.Parameters.Add("@CustomerID", Data.SqlDbType.Int).Value = lngCustomerID
        cmd.Parameters.Add("@CustomerPO", Data.SqlDbType.VarChar).Value = strCustomerPO
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            intTotal = dtr("Total")
            If intTotal > 0 Then
                blnReturn = true
                strErrors &= "<li>Duplicate Ticket. Open ticket already in the system.</li>"
                'divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
                Return intTotal
            Else
                Return intTotal
            End If
            
        End While
        cnn.Close()
        
    End Function
    
    Private Sub LoadStates()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSimpleDropDownList("spListStates", "StateName", "StateID", cbxState)
        
        cbxState.SelectedValue = 10
       
    End Sub
    Private Function GetZipID(ByVal strZip As String) As Long
     
        Dim lngZipCode As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetZipCodeByZipCode")
        cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar).Value = strZip
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngZipCode = dtr("ZipCodeID")
        End While
        Return lngZipCode
        cnn.Close()
        
    End Function
    Private Function AssignAgent(ByVal lngPartnerID As Long) As Long
        Dim lngAdminAgent As Long
        Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        If lngPartnerID <> 0 Then
            par.Load(lngPartnerID)
            lngAdminAgent = par.UserID
        Else
            lngAdminAgent = 115
        End If
        Return lngAdminAgent
    End Function
    Private Function LoadClosestPartnerAgents(ByVal strZipCode As String, ByVal lngRadius As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spListClosestPartnerAgentsToZipCodeTop1")
        Dim lngPartnerID As Long
        lngPartnerID = 0
        cmd.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar).Value = strZipCode
        cmd.Parameters.Add("@Radius", Data.SqlDbType.Int).Value = lngRadius
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngPartnerID = dtr("PartnerID")
        End While
        Return lngPartnerID
        cnn.Close()
    End Function
</script>

<asp:Content ID="cntLogin" ContentPlaceHolderID="cntMain" runat="server">
    <form id="frmLogin" runat="server" >
        <asp:MultiView ID="main" runat="server">
            <asp:View ID="TypeofJob" runat="server">
                <div >&nbsp;</div>
                <div><h3>Please let us know what type of service you need:</h3></div>
                <div>
                <asp:RadioButtonList ID="TypeofService" runat="server">
                <asp:ListItem  value = "1" Text="Home Appliance Repair" ></asp:ListItem>
                <asp:ListItem Value="2" Text="Flat Panel TV Repair"></asp:ListItem>
                <asp:ListItem Value="3" Text="Central AC Repair"></asp:ListItem>
                <asp:ListItem  value = "4" Text="Home Appliance Installation" ></asp:ListItem>
                <asp:ListItem Value="5" Text="Flat Panel TV Installation"></asp:ListItem>
                <asp:ListItem Value="6" Text="Central AC Maintenance"></asp:ListItem>
                </asp:RadioButtonList></div>
                <div style="color:Red;"><asp:Label visible= "false" ID="lblErrorPage1" runat ="server"/></div>
                <div style="text-align:center; "><asp:ImageButton ID="imgNext" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click" /></div>
            </asp:View>
            
            <asp:View ID="Address" runat="server" >
                <div>&nbsp;</div>
                <div ><h3>Address where service will be performed:</h3></div>
                <div style="text-align: left;">
                    <b>Address *</b></div>
                <div>
                    <asp:TextBox Style="width: 50%" ID="txtAddress" runat="server" /></div>
                <div style="text-align: left;">
                    <b>City *</b></div>
                <div>
                    <asp:TextBox Style="width: 50%" ID="txtCity" runat="server" /></div>
                <div style="text-align: left;">
                    <b>State*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ZipCode*</b></div>
                <div>
                
                    <asp:DropDownList Style="width: 20%" ID="cbxState" runat="server" />&nbsp;&nbsp;<asp:TextBox Style="width: 15%" ID="txtZipCode" runat="server" /></div>&nbsp;
                <div style="color:Red;"><asp:Label ID="lblErrorPage2" visible = "false" runat ="server"/></div>
                <div style="text-align:center; "><asp:ImageButton ID="ImageButton1" runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" />   <asp:ImageButton ID="ImageButton3" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif" OnClick="btnMoveNext_Click"/></div>

            </asp:View>
            
            <asp:View ID="contact" runat="server" >
            <div >
                    <h3>Contact Information</h3>
                </div>
                <div style="text-align: left;">
                    <b>First Name *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Last Name *</b></div>
                <div>
                    <asp:TextBox Style="width: 20%" ID="txtFirstName" runat="server" />&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox Style="width: 20%" ID="txtLastName" runat="server" /></div>
                <div style="text-align: left;">
                <div>
                    <cv:Phone Text="Home Number" RequirePhone="true" ID="phn" runat="server" />
                </div>
                <div>
                    <cv:Phone Text="Cell Number" RequirePhone="true" ID="phnCell" runat="server" />
                </div>
                    <b>Email Address *</b></div>
                <div>
                    <asp:TextBox Style="width: 50%" ID="txtEmailAddress" runat="server" /></div>
                <div style="color:Red;"><asp:Label visible= "false" ID="lblErrorPage3" runat ="server"/></div>
                <div>&nbsp;</div>
                <div style="text-align:center; "><asp:ImageButton ID="imgBack"  runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" />   <asp:ImageButton ID="ImageButton2" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click"/></div>
            </asp:View>
            
            <asp:View ID="UnitInfo" runat="server" >
                <div ><h3>Unit Information</h3></div>
                <div><b>Manufacturer *</b></div>
                <div><asp:TextBox Style="width: 50%" ID="txtManufacturer" runat="server" /></div>
                <div><b>Unit Type *</b></div>
                <div><asp:TextBox Style="width: 50%" ID="txtUnitType" runat="server" /></div>
                <div><b>Model Number *</b></div>
                <div>
                    <asp:TextBox Style="width: 50%" ID="txtModelNumber" runat="server" /></div>
            <div>
                    <b>Serial Number *</b></div>
                <div>
                    <asp:TextBox Style="width: 50%" ID="txtSerialNumber" runat="server" /></div>
            <div>
                    <b>Problem Description *</b></div>
                <div>
                    <asp:TextBox Style="width: 80%" ID="txtProblemDescription" runat="server"  TextMode="MultiLine" /></div>
                <div style="color:Red;"><asp:Label visible= "false" ID="lblErrorPage4" runat ="server"/></div>
                <div>&nbsp;</div>
                <div style="text-align:center; "><asp:ImageButton ID="ImageButton4"  runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" /><asp:ImageButton ID="ImageButton5" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click"/></div>
            </asp:View>
            
            <asp:View runat="server" ID="servicedate">
            <div ><h3>Choose Service Date</h3></div>
            <div style="text-align:left; ">
              <asp:Calendar ID="Calendar1" runat="server" BackColor="White" BorderColor="#999999" CellPadding="4" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="150px" Width="230px" >
                <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                <SelectorStyle BackColor="#CCCCCC" />
                <WeekendDayStyle BackColor="#FFFFCC" />
                <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                <OtherMonthDayStyle ForeColor="#808080" />
                <NextPrevStyle VerticalAlign="Bottom" />
                <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
              </asp:Calendar></div>
              <div>&nbsp;</div>
              <div style="color:Red;"><asp:Label ID="lblErrorPage5" visible = "false" runat ="server"/></div>
              <div style="text-align:center; "><asp:ImageButton ID="ImageButton6" runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" />   <asp:ImageButton ID="ImageButton7" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click"/></div>
            </asp:View>
            <asp:View runat="server" ID="payment">
            <div><h3>Payment for Onsite Diagnostic</h3></div>
            <div>Our technician will diagnose your unit and provide you with a written estimate for the repair. By accepting the estimate, the diagnose fee you are paying now will be applied towards the total of the estimate which will make this a free diagnostic.</div>
            <div>&nbsp;</div>
               <input type="hidden" name="LinkId" value="a1d0d71d-e12b-49e4-b405-61753e3ca098" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <asp:ImageButton ID="ImageButPayNow" runat="server"  ImageUrl="/images/paybutton1.jpg" PostBackUrl="https://simplecheckout.authorize.net/payment/catalogpayment.aspx" />
               <div>* By clicking the Pay Now Button, you will be transferred to a secure site to process your credit card transaction.</div>
               <div>* By paying the onsite diagnose fee, our system will key the technician that a new service ticket is ready for service. You will be receiving a phone call to confirm the appointment time within 4 hour of your payment confirmation. If after hours, weekends or holidays, you will be contacted next business day. For any questions, please contact us at 561.886.6699.</div>

            <div style="text-align:center; "><asp:ImageButton ID="ImageButton8"  runat="server"  ImageUrl="/graphics/arrows_grey_072.gif" OnClick="btnMoveBack_Click" visible="False"/>   <asp:ImageButton ID="ImageButton9" runat="server"  ImageUrl="/graphics/arrows_grey_071.gif"  OnClick="btnMoveNext_Click" Visible="false" /></div>
            </asp:View>
            <asp:View >
            </asp:View>
        </asp:MultiView>
    </form>
</asp:Content>
