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
    End If
  End Sub
  
  Private Sub Test()
        'lbl.Text = GetHost("http://www.nationalappliancenetwork.com")
        lbl.Text = "HEllo"
        testFolders()
        'testFolders1()
    End Sub

    Private Sub testFolders()
        Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cnn2 As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("ATest1")
        Dim strSerialNumber As String
        Dim intLen As Integer
        Dim strYear As String
        Dim strMonth As String
        
        lbl.Text = "Wait"
        cmd.CommandType = Data.CommandType.StoredProcedure
        Dim strChangeLog As String
        strChangeLog = ""
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr1.Read
            'ldl.RunFolderCode1(cnn, dtr1("TicketID"))
            
            Dim cmd1 As New System.Data.SqlClient.SqlCommand("ATest2")
            cnn2.Open()
            cmd1.Connection = cnn2
            cmd1.CommandType = Data.CommandType.StoredProcedure
            cmd1.Parameters.Add("@model", Data.SqlDbType.VarChar, 64).Value = dtr1("model")
            Dim dtr2 As System.Data.SqlClient.SqlDataReader = cmd1.ExecuteReader
            While dtr2.Read
                tkt.Load(dtr1("TicketID"))
                tkt.Manufacturer = dtr2("manufacturer")
                txttest1.Text = dtr1("TicketID")
                lbl.Text = dtr1("TicketID")
                strSerialNumber = dtr1("SerialNumber")
                intLen = Len(strSerialNumber)
                Select Case intLen
                    Case Is = 15
                        strYear = Mid(strSerialNumber, 8, 1)
                        strMonth = Mid(strSerialNumber, 9, 1)
                        Select Case strYear
                            
                            Case "S"
                                lbl.Text = strYear
                                If dtr2("ServiceTypeID") = 46 Then
                                    tkt.ServiceID = 112
                                    
                                End If
                                If dtr2("ServiceTypeID") = 47 Then
                                    tkt.ServiceID = 118
                                End If
                                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** VALID SERIAL NUMBER IN GSPN >> UNIT IS UNDER WARRANTY")
                                tnt.CustomerVisible = False
                                tnt.PartnerVisible = False
                                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                tnt.Acknowledged = True
                                tnt.Save(strChangeLog)
                            Case "Q"
                                lbl.Text = strYear
                                If strMonth = "A" Then
                                    strMonth = 10
                                End If
                                If strMonth = "B" Then
                                    strMonth = 11
                                End If
                                If strMonth = "C" Then
                                    strMonth = 12
                                End If
                                If CType(strMonth, Integer) > 7 Then
                                    If dtr2("ServiceTypeID") = 46 Then
                                        tkt.ServiceID = 112
                                    End If
                                    If dtr2("ServiceTypeID") = 47 Then
                                        tkt.ServiceID = 118
                                    End If
                                    tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** VALID SERIAL NUMBER IN GSPN >> UNIT IS UNDER WARRANTY")
                                    tnt.CustomerVisible = False
                                    tnt.PartnerVisible = False
                                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                    tnt.Acknowledged = True
                                    tnt.Save(strChangeLog)
                                Else
                                    lbl.Text = strYear
                                    If dtr2("ServiceTypeID") = 46 Then
                                        tkt.ServiceID = 114
                                    End If
                                    If dtr2("ServiceTypeID") = 47 Then
                                        tkt.ServiceID = 120
                                    End If
                                    tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** VALID SERIAL NUMBER IN GSPN >> UNIT IS OUT OF WARRANTY")
                                    tnt.CustomerVisible = False
                                    tnt.PartnerVisible = False
                                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                    tnt.Acknowledged = True
                                    tnt.Save(strChangeLog)
                                End If
                            Case Else
                                lbl.Text = strYear
                                lbl.Text = strYear
                                If dtr2("ServiceTypeID") = 46 Then
                                    tkt.ServiceID = 114
                                End If
                                If dtr2("ServiceTypeID") = 47 Then
                                    tkt.ServiceID = 120
                                End If
                                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** VALID SERIAL NUMBER IN GSPN >> UNIT IS OUT OF WARRANTY")
                                tnt.CustomerVisible = False
                                tnt.PartnerVisible = False
                                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                tnt.Acknowledged = True
                                tnt.Save(strChangeLog)
                        End Select
                        tkt.Save(strChangeLog)
 
                        
                    Case Is = 11
                       
                        strYear = Mid(strSerialNumber, 4, 1)
                        strMonth = Mid(strSerialNumber, 5, 1)
                        Select Case strYear
                            Case "S"
                                lbl.Text = strYear
                                If dtr2("ServiceTypeID") = 46 Then
                                    tkt.ServiceID = 112
                                End If
                                If dtr2("ServiceTypeID") = 47 Then
                                    tkt.ServiceID = 118
                                End If
                                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** VALID SERIAL NUMBER IN GSPN >> UNIT IS UNDER WARRANTY")
                                tnt.CustomerVisible = False
                                tnt.PartnerVisible = False
                                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                tnt.Acknowledged = True
                                tnt.Save(strChangeLog)
                            Case "Q"
                                lbl.Text = strYear
                                If strMonth = "A" Then
                                    strMonth = 10
                                End If
                                If strMonth = "B" Then
                                    strMonth = 11
                                End If
                                If strMonth = "C" Then
                                    strMonth = 12
                                End If
                                If CType(strMonth, Integer) > 7 Then
                                    If dtr2("ServiceTypeID") = 46 Then
                                        tkt.ServiceID = 112
                                    End If
                                    If dtr2("ServiceTypeID") = 47 Then
                                        tkt.ServiceID = 1118
                                    End If
                                    tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** VALID SERIAL NUMBER IN GSPN >> UNIT IS UNDER WARRANTY")
                                    tnt.CustomerVisible = False
                                    tnt.PartnerVisible = False
                                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                    tnt.Acknowledged = True
                                    tnt.Save(strChangeLog)
                                Else
                                    lbl.Text = strYear
                                    If dtr2("ServiceTypeID") = 46 Then
                                        tkt.ServiceID = 114
                                    End If
                                    If dtr2("ServiceTypeID") = 47 Then
                                        tkt.ServiceID = 120
                                    End If
                                    tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** VALID SERIAL NUMBER IN GSPN >> UNIT IS OUT OF WARRANTY")
                                    tnt.CustomerVisible = False
                                    tnt.PartnerVisible = False
                                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                    tnt.Acknowledged = True
                                    tnt.Save(strChangeLog)
                                End If
                            Case Else
                                lbl.Text = strYear
                                If dtr2("ServiceTypeID") = 46 Then
                                    tkt.ServiceID = 114
                                End If
                                If dtr2("ServiceTypeID") = 47 Then
                                    tkt.ServiceID = 120
                                End If
                                tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** VALID SERIAL NUMBER IN GSPN >> UNIT IS OUT OF WARRANTY")
                                tnt.CustomerVisible = False
                                tnt.PartnerVisible = False
                                tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                tnt.Acknowledged = True
                                tnt.Save(strChangeLog)
                        End Select
                        tkt.Save(strChangeLog)
                    Case Else
                        If intLen = 14 Then
                            strYear = Mid(strSerialNumber, 8, 1)
                            strMonth = Mid(strSerialNumber, 9, 1)
                            Select Case strYear
                                Case "S"
                                    lbl.Text = strYear
                                    If dtr2("ServiceTypeID") = 46 Then
                                        tkt.ServiceID = 112
                                    End If
                                    If dtr2("ServiceTypeID") = 47 Then
                                        tkt.ServiceID = 118
                                    End If
                                    tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** NOT VALID SERIAL NUMBER IN GSPN >> UNIT IS UNDER WARRANTY")
                                    tnt.CustomerVisible = False
                                    tnt.PartnerVisible = False
                                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                    tnt.Acknowledged = True
                                    tnt.Save(strChangeLog)
                                Case "Q"
                                    lbl.Text = strYear
                                    If strMonth = "A" Then
                                        strMonth = 10
                                    End If
                                    If strMonth = "B" Then
                                        strMonth = 11
                                    End If
                                    If strMonth = "C" Then
                                        strMonth = 12
                                    End If
                                    If CType(strMonth, Integer) > 7 Then
                                        If dtr2("ServiceTypeID") = 46 Then
                                            tkt.ServiceID = 112
                                        End If
                                        If dtr2("ServiceTypeID") = 47 Then
                                            tkt.ServiceID = 1118
                                        End If
                                        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** NOT VALID SERIAL NUMBER IN GSPN >> UNIT IS UNDER WARRANTY")
                                        tnt.CustomerVisible = False
                                        tnt.PartnerVisible = False
                                        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                        tnt.Acknowledged = True
                                        tnt.Save(strChangeLog)
                                    Else
                                        lbl.Text = strYear
                                        If dtr2("ServiceTypeID") = 46 Then
                                            tkt.ServiceID = 114
                                        End If
                                        If dtr2("ServiceTypeID") = 47 Then
                                            tkt.ServiceID = 120
                                        End If
                                        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** NOT VALID SERIAL NUMBER IN GSPN >> UNIT IS OUT OF WARRANTY")
                                        tnt.CustomerVisible = False
                                        tnt.PartnerVisible = False
                                        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                        tnt.Acknowledged = True
                                        tnt.Save(strChangeLog)
                                    End If
                                Case Else
                                    lbl.Text = strYear
                                    If dtr2("ServiceTypeID") = 46 Then
                                        tkt.ServiceID = 114
                                    End If
                                    If dtr2("ServiceTypeID") = 47 Then
                                        tkt.ServiceID = 120
                                    End If
                                    tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** NOT VALID SERIAL NUMBER IN GSPN >> UNIT IS OUT OF WARRANTY")
                                    tnt.CustomerVisible = False
                                    tnt.PartnerVisible = False
                                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                    tnt.Acknowledged = True
                                    tnt.Save(strChangeLog)
                            End Select
                            tkt.Save(strChangeLog)
                        
                        End If
                        If intLen = 10 Then
                            strYear = Mid(strSerialNumber, 4, 1)
                            strMonth = Mid(strSerialNumber, 5, 1)
                            Select Case strYear
                                Case "S"
                                    lbl.Text = strYear
                                    If dtr2("ServiceTypeID") = 46 Then
                                        tkt.ServiceID = 112
                                    End If
                                    If dtr2("ServiceTypeID") = 47 Then
                                        tkt.ServiceID = 118
                                    End If
                                    tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** NOT VALID SERIAL NUMBER IN GSPN >> UNIT IS UNDER WARRANTY")
                                    tnt.CustomerVisible = False
                                    tnt.PartnerVisible = False
                                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                    tnt.Acknowledged = True
                                    tnt.Save(strChangeLog)
                                Case "Q"
                                    lbl.Text = strYear
                                    If strMonth = "A" Then
                                        strMonth = 10
                                    End If
                                    If strMonth = "B" Then
                                        strMonth = 11
                                    End If
                                    If strMonth = "C" Then
                                        strMonth = 12
                                    End If
                                    If CType(strMonth, Integer) > 7 Then
                                        If dtr2("ServiceTypeID") = 46 Then
                                            tkt.ServiceID = 112
                                        End If
                                        If dtr2("ServiceTypeID") = 47 Then
                                            tkt.ServiceID = 1118
                                        End If
                                        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** NOT VALID SERIAL NUMBER IN GSPN >> UNIT IS UNDER WARRANTY")
                                        tnt.CustomerVisible = False
                                        tnt.PartnerVisible = False
                                        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                        tnt.Acknowledged = True
                                        tnt.Save(strChangeLog)
                                    Else
                                        lbl.Text = strYear
                                        If dtr2("ServiceTypeID") = 46 Then
                                            tkt.ServiceID = 114
                                        End If
                                        If dtr2("ServiceTypeID") = 47 Then
                                            tkt.ServiceID = 120
                                        End If
                                        tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** NOT VALID SERIAL NUMBER IN GSPN >> UNIT IS OUT OF WARRANTY")
                                        tnt.CustomerVisible = False
                                        tnt.PartnerVisible = False
                                        tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                        tnt.Acknowledged = True
                                        tnt.Save(strChangeLog)
                                    End If
                                Case Else
                                    lbl.Text = strYear
                                    If dtr2("ServiceTypeID") = 46 Then
                                        tkt.ServiceID = 114
                                    End If
                                    If dtr2("ServiceTypeID") = 47 Then
                                        tkt.ServiceID = 120
                                    End If
                                    tnt.Add(tkt.TicketID, Master.WebLoginID, Master.UserID, "** NOT VALID SERIAL NUMBER IN GSPN >> UNIT IS OUT OF WARRANTY")
                                    tnt.CustomerVisible = False
                                    tnt.PartnerVisible = False
                                    tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
                                    tnt.Acknowledged = True
                                    tnt.Save(strChangeLog)
                            End Select
                            tkt.Save(strChangeLog)
                        
                        End If
                End Select
                
            End While
            cnn2.Close()
        End While
        'cnn.Close()
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
        Dim X As New System.Uri("http://www.BestServicers.com")
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
  
</script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
<form id="frmTest" runat="server">
  <asp:Label ID="lbl" runat="server" visible= "True"/>
  <div>
  <asp:TextBox ID="txttest1" runat="server" visible = "True"/>
  </div>
  
</form>
</asp:Content>