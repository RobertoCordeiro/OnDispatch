<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>

<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Agent Interface"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Agent Interface"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a>"
            Test()
            'BulkEmail()
    End If
  End Sub
  
  Private Sub Test()
        'lbl.Text = GetHost("http://www.nationalappliancenetwork.com")
        lbl.Text = "Enter Radius in miles:"
        'testFolders()
        'testFolders1()
    End Sub
    
    Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
        testFolders(CType(txttest1.Text, Integer))
    End Sub

    Private Sub testFolders(ByVal intRadius As Integer)
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cnn2 As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spListTicketsInFolder")
        Dim strChangeLog As String
        Dim intEmailCount As Integer
        Dim lngTicketID As Long
        
        intEmailCount = 0
        strChangeLog = ""
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketFolderID", Data.SqlDbType.Int).Value = 25
        
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr1.Read
            lbl.Text = dtr1("TicketID")
            lngTicketID = dtr1("TicketID")
            intEmailCount = 0
            Dim cmd1 As New System.Data.SqlClient.SqlCommand("spListClosestPartnerAgentsToZipCode")
            cnn2.Open()
            cmd1.Connection = cnn2
            cmd1.CommandType = Data.CommandType.StoredProcedure
            cmd1.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar, 5).Value = dtr1("ZipCode")
            cmd1.Parameters.Add("@Radius", Data.SqlDbType.Int).Value = intRadius
            Dim dtr2 As System.Data.SqlClient.SqlDataReader = cmd1.ExecuteReader
            While dtr2.Read
                txttest1.Text = dtr2("ResumeID")
                If IsCorrectLaborNetwork(dtr1("ServiceTypeID"), dtr2("ResumeTypeID")) Then
                    BuildEmailMessage(dtr1("TicketID"), dtr2("Email"), dtr2("ResumeID"))
                    intEmailCount = intEmailCount + 1
                End If
            End While
            cnn2.Close()
            
            Dim cmd2 As New System.Data.SqlClient.SqlCommand("spListClosestResumesToZipCode")
            cnn2.Open()
            cmd2.Connection = cnn2
            cmd2.CommandType = Data.CommandType.StoredProcedure
            cmd2.Parameters.Add("@ZipCode", Data.SqlDbType.VarChar, 5).Value = dtr1("ZipCode")
            cmd2.Parameters.Add("@Radius", Data.SqlDbType.Int).Value = intRadius
            Dim dtr3 As System.Data.SqlClient.SqlDataReader = cmd2.ExecuteReader
            While dtr3.Read
                txttest1.Text = "Candidate:" & dtr3("ResumeID")
                If IsCorrectLaborNetwork(dtr1("ServiceTypeID"), dtr3("ResumeTypeID")) Then
                    BuildEmailMessage(dtr1("TicketID"), dtr3("Email"), dtr3("ResumeID"))
                    intEmailCount = intEmailCount + 1
                End If

            End While
            cnn2.Close()
            If intEmailCount > 0 Then
                tnt.Add(lngTicketID, Master.WebLoginID, Master.UserID, "Automatic Mailing - Searching for Technician (" & intEmailCount & "): Replies going to the phonesupport public folder. ")
                tnt.CustomerVisible = False
                tnt.PartnerVisible = False
                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                tnt.Acknowledged = True
                tnt.Save(strChangeLog)
            End If
        End While
        
        cnn.Close()
    End Sub
    
    Private Sub testFolders1()
        'Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'Dim cnn As New System.Data.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumes")
        cmd.CommandType = Data.CommandType.StoredProcedure
        Dim strChangeLog As String
        strChangeLog = ""
        'cnn.Open()
        'cmd.Connection = cnn
        Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr1.Read
            'ldl.RunFolderCode1(cnn, dtr1("TicketID"))
            'lbl.Text = GetHost("http://www.nationalappliancenetwork.com")
            'fdl.Add(CType(6, Long), CType(dtr1("ticketID"), Long), CType(33, Long))
            'ResumeFoldersCheck (Ctype(dtr1("ResumeID"),Long))
        End While
        'cnn.Close()
    End Sub
    Private Sub ResumeFoldersCheck(intResumeID as integer)
        'Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'Dim cnn As New System.Data.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spDetermineResumeFolderAssignment")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@ResumeID", Data.SqlDbType.Int).Value = intResumeID
        Dim strChangeLog As String
        strChangeLog = ""
        'cnn.Open()
        'cmd.Connection = cnn
        'cmd.ExecuteNonQuery()
        'Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        'While dtr1.Read
            'ldl.RunFolderCode1(cnn, dtr1("TicketID"))
            'lbl.Text = GetHost("http://www.nationalappliancenetwork.com")
            'fdl.Add(CType(6, Long), CType(dtr1("ticketID"), Long), CType(33, Long))
            
        'End While
        'cnn.Close()
    End Sub
    
    
    
    ''' <summary>
    ''' Gets the host of the specified url.
    ''' </summary>
    ''' <param name="strURL"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetHost(ByVal strURL As String) As String
        Dim strReturn As String = ""
        Dim X As New System.Uri("http://www.bestservicers.com")
        If strURL.Trim.Length > 0 Then
            If (strURL.Substring(0, 7) = "http://") Or (strURL.Substring(0, 8) = "https://") Then
                X = New System.Uri(strURL)
                strReturn = X.Host
            Else
                X = New System.Uri("http://" & strURL)
                strReturn = X.Host
            End If
        End If
        Return strReturn
    End Function
    
    Private Sub BuildEmailMessage(ByVal lngTicketID As Long, ByVal strEmailAddress As String, ByVal lngResumeID As Long)
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim stu As New BridgesInterface.TicketStatusRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)
        Dim strBody As String
        'Dim strMessage As String
        'Dim strSubject As String
      
        
        tkt.Load(lngTicketID)
        stt.Load(tkt.StateID)
        stu.Load(tkt.TicketStatusID)

        strBody = "<b>TICKET INFORMATION:</b> <br><br>"
        strBody = strBody & "<b>Ticket Number:</b> " & lngTicketID & "<br>"
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
                    
        'strSubject = "Ticket Number: " & lngTicketID & " / " & stu.Status & " / " & lngResumeID
            
        ''strEmailAddress = "paulo.pinheiro@bestservicers.com"
        
        'If strEmailAddress <> "" Then
        '    eml.SendFrom = "phonesupport@nationalappliancenetwork.com"
        
        '    eml.SendTo = strEmailAddress
        '    'eml.SendTo = "Nelson.palavesino@bestservicers.com"
        '    eml.Subject = strSubject
        '    eml.Body = strBody & "<br><br>" & strMessage
      
        '    eml.Send()
        'End If
            
    End Sub
    
    Private Function IsCorrectLaborNetwork(ByVal lngServiceTypeID As Long, ByVal lngResumeTypeID As Long) As Boolean
        Dim stp As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim lngLayerID As Long
        stp.Load(lngServiceTypeID)
        lngLayerID = stp.LayerID
        
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsResumeTypeInLayer")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("LayerID", Data.SqlDbType.Int).Value = lngLayerID
        cmd.Parameters.Add("ResumeTypeID", Data.SqlDbType.Int).Value = lngResumeTypeID
        Dim strChangeLog As String
        Dim intTotalCount As Integer
        strChangeLog = ""
        cnn.Open()
        cmd.Connection = cnn
        
        Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr1.Read
            intTotalCount = dtr1("Total")
            If intTotalCount = 0 Then
                IsCorrectLaborNetwork = False
            Else
                IsCorrectLaborNetwork = True
            End If
        End While
        cnn.Close()
    End Function
    
    Private Sub BulkEmail()
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cnn2 As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spBulkEmails")
        Dim strChangeLog As String
        Dim intEmailCount As Integer
        
        
        intEmailCount = 0
        strChangeLog = ""
        
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr1.Read
            If dtr1("Email") <> "" Then
                BuildBulkEmail(dtr1("Email"))
            End If
        End While
        
        cnn.Close()
        
        
        
        
    End Sub
    
    Public Sub BuildBulkEmail(ByVal strEmailAddress As String)
        Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        'Dim strMessage As String
        'Dim strSubject As String
      
            
        'strMessage = "To All Current Technicians and Candidates.<br><br>"
        'strMessage = strMessage & "National Appliance Network will be the primary provider for all Samsung Appliances and Flat Panel TV "
        'strMessage = strMessage & "repairs for Lowes, Wall Mart and Sam’s Club retail stores.<br><br>"
        'strMessage = strMessage & "Due to the difficulties Samsung has in administering and handling these retail service calls we have made an agreement with Samsung to have specific technicians assigned to each of the stores throughout the country. <br><br>"
        'strMessage = strMessage & "This way the technician would be creating a good relationship with the managers from each store and making sure their repair needs are taking care in a timely manner. "
        'strMessage = strMessage & "This would make everyone happy including the technician, who would have multiple units in one location to work with, without a lot of travel involved and constant volume of service coming through.<br><br>"
        'strMessage = strMessage & "If you have one of these stores in your neighborhood and would like to become the assigned technician responsible for the services for the specific store, reply to this email. <br><br>"
        'strMessage = strMessage & "Please specify what store locations you are interested on by providing the store’s name, address, city and zip code. We will be able to assign just one technician per store, but multiple stores to one technician if available.<br><br>"
        'strMessage = strMessage & "Marie Cadet and Charlene Joseph will be the agents responsible for the assignments of the stores to the technicians. As they receive your email they will be contacting you to explain how this process will work and answer any kind of questions you might have.<br><br>"
        'strMessage = strMessage & "Sincerely,<br><br>"
        'strMessage = strMessage & "Paulo Pinheiro<br>"
       
                    
        'strSubject = "Lowes - Wall Mart - Sams Club Retail Stores"
            
        ''strEmailAddress = "paulo.pinheiro@bestservicers.com"
        
        'If strEmailAddress <> "" Then
        '    eml.SendFrom = "phonesupport@nationalappliancenetwork.com"
        
        '    eml.SendTo = strEmailAddress
        '    'eml.SendTo = "Nelson.palavesino@bestservicers.com"
        '    eml.Subject = strSubject
        '    eml.Body = strMessage
      
        '    eml.Send()
        'End If
    End Sub
  
</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
<form id="frmTest" runat="server">
  <asp:Label ID="lbl" runat="server" visible= "True"/>
  <div>
  <asp:TextBox ID="txttest1" runat="server" visible = "True"/>
  </div>
  <div>
  <asp:Button ID="btnSubmit" runat="server" Text="Send" OnClick="btnSubmit_Click"/>
  </div>
  
</form>
</asp:Content>