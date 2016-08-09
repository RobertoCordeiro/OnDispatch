<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
   
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "Cancel Ticket"
      Master.PageTitleText = "Cancel Ticket"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""tickets.aspx"">Ticket Management</a> &gt; Cancel Ticket"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      If Not IsPostBack Then
        txtCancelFee.Text = "0.00"
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim dbl As Double = 0
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    tkt.Load(_ID)
    If tkt.WorkOrderCount > 0 Then
      blnReturn = False
      strErrors &= "<li>This Ticket has Work Order(s), Please Cancel It via the Close Work Order Form.</li>"
    End If
    If txtCancelationReason.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Cancellation Reason is Required</li>"
    End If
    If txtCancelFee.Text.Trim.Length = 0 Then
      blnReturn = False
      strErrors &= "<li>Cancellation Fee is Required</li>"
    Else
      If Not Double.TryParse(txtCancelFee.Text, dbl) Then
        blnReturn = False
        strErrors &= "<li>Cancellation Fee Must Be A Number</li>"
      End If
    End If
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function
  
    Private Sub btnYes_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lngTicketID As Long
        If IsComplete() Then
            divErrors.Visible = False
            Dim strChangeLog As String = ""
            Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            tkt.Load(_ID)
            Dim tnt As New BridgesInterface.TicketNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            tkt.ServiceStartDate = Now
            tkt.ServiceEndDate = Now
            tkt.AdjustCharge = 0
            tkt.ChargeRate = 0
            tkt.CompletedBy = Master.UserID
            tkt.CompletedDate = Now
            tkt.CustomerPrioritySetting = 1
            tkt.InternalPrioritySetting = 1
            tkt.IncrementTypeID = 13
            tkt.TicketStatusID = 9
            tkt.CompletedDate = Now
            If IsDBNull(tkt.ScheduledEndDate) Or tkt.ScheduledEndDate = "#12:00:00 AM#" Then
                tkt.ScheduledDate = DateTime.Now
                tkt.ScheduledEndDate = DateTime.Now
            End If
            tkt.MaximumCharge = CType(txtCancelFee.Text, Double)
            tnt.Add(_ID, Master.WebLoginID, Master.UserID, "Ticket Cancelled: " & txtCancelationReason.Text)
            tnt.CustomerVisible = True
            tnt.SourceID = BridgesInterface.TicketNoteRecord.Sources.Internal
            tnt.Acknowledged = True
            tnt.Save(strChangeLog)
            lngTicketID = tkt.TicketID
            tkt.Save(strChangeLog)
            MaintainProduction(lngTicketID, 9)
            Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim strIp As String = Request.QueryString("REMOTE_ADDR")
            Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
            If IsNothing(strIp) Then
                strIp = "unknown"
            End If
            If IsNothing(strType) Then
                strType = "web"
            End If
            act.Add(Master.UserID, "web", strType, strIp, Master.WebLoginID.ToString, tkt.ActionObjectID, tkt.TicketID, strChangeLog)
            
            Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
            Dim cst As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            cst.Load(tkt.CustomerID)
            
            If tkt.CustomerID = CType(25, Long) Then
                'eml.SendFrom = "AutoClosedCall@centurionvision.com"
                'eml.SendTo = "vagner.saude@centurionvision.com"
                'eml.CC = "renata.libano@centurionvision.com"
                'eml.Subject = "Closed Ticket: " & tkt.TicketID & " / " & tkt.ReferenceNumber1 & " - Cancelled"
                'eml.Body = txtCancelationReason.Text
      
                'eml.Send()
                
                Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                fdl.Add(6, lngTicketID, 34)
                
            End If
            
            
            
            
            Response.Redirect(lblReturnUrl.Text)
        Else
            divErrors.Visible = True
        End If
    End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  Private Sub MaintainProduction (lngTicketID as long, lngStatusID as long)
    'If CType(tkt.TicketStatusID,long) <> CType(drpTicketStatus.selectedValue,long) then
        
        'Dim usr As New BridgesInterface.UserRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        'usr.Load(Master.LoginID)
        Dim wbl As New BridgesInterface.WebLoginRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        wbl.Load(Master.WebLoginID)    
        Dim strUserName as string
        strUserName = wbl.Login
        
        Dim plog As New BridgesInterface.ProductionLogRecord(System.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
        plog.Add(Master.WebLoginID,Now(),6,"Ticket Closed as Cancelled - " & lngTicketID)

        'Dim eml As New cvCommon.Email(System.Configuration.ConfigurationManager.AppSettings("EmailHost"))
        'eml.Subject = "Ticket Cancelled By: " & strUserName
        'eml.Body = "The status has been changed to - Cancelled - on ticket: " & lngTicketID
        ''eml.SendFrom = System.Configuration.ConfigurationManager.AppSettings("PartnerSupportEmail")
        'eml.SendFrom = strUserName & "@centurionvision.com"
        ''eml.SendTo = ptr.Email
        'eml.SendTo = "CallCenterCallsClosed@centurionvision.com"
        ''eml.cc = "Nelson.Palavesino@centurionvision.com"
        ''eml.cc = "howard.goldman@centurionvision.com"
        'eml.Send()
        
        
      'end if
      HandleFolders(lngticketID,lngStatusID) 

  end sub
  
  Private Sub HandleFolders(ByVal lngTicketID As Long, ByVal lngFolderID As Long)
        Dim fdl As New BridgesInterface.TicketFolderAssignmentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
               
        Select Case lngFolderID 'Ticket StatusID

            Case Is = CType(27, Long), CType(28, Long), CType(30, Long)
                'Add to folder Phone Support
                fdl.Add(6, lngTicketID, CType(26, Long))
                
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(29, Long)
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(25, Long))
 
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(14, Long)
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(29, Long))
 
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(26, Long)
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(30, Long))
 
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(16, Long)
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(31, Long))
 
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Is = CType(22, Long)
                'add to folder Need Tech
                fdl.Add(6, lngTicketID, CType(32, Long))
 
                removeTicketFromFolder(lngTicketID, CType(25, Long))
                removeTicketFromFolder(lngTicketID, CType(26, Long))
                removeTicketFromFolder(lngTicketID, CType(29, Long))
                removeTicketFromFolder(lngTicketID, CType(30, Long))
                removeTicketFromFolder(lngTicketID, CType(31, Long))
                removeTicketFromFolder(lngTicketID, CType(33, Long))
            Case Else
                removeTicketFromFolder(lngTicketID, CType(1, Long)) 'Folder New
                removeTicketFromFolder(lngTicketID, CType(2, Long)) 'Folder Open
                removeTicketFromFolder(lngTicketID, CType(3, Long)) 'Folder Awaiting parts
                removeTicketFromFolder(lngTicketID, CType(4, Long)) 'Folder Escalated
                removeTicketFromFolder(lngTicketID, CType(7, Long)) 'Folder Missed Appt
                removeTicketFromFolder(lngTicketID, CType(10, Long)) ' Folder Ready for service
                removeTicketFromFolder(lngTicketID, CType(13, Long)) 'Folder Need appt set
                removeTicketFromFolder(lngTicketID, CType(16, Long)) 'Folder To be Dispatched
                removeTicketFromFolder(lngTicketID, CType(17, Long)) 'Folder FistContact
                removeTicketFromFolder(lngTicketID, CType(18, Long)) 'Folder Has Parts
                removeTicketFromFolder(lngTicketID, CType(20, Long)) 'Folder Labor Only
                removeTicketFromFolder(lngTicketID, CType(23, Long)) 'Folder Need Update
                removeTicketFromFolder(lngTicketID, CType(24, Long)) 'Folder New Notes
                removeTicketFromFolder(lngTicketID, CType(25, Long)) 'Folder Need Tech
                removeTicketFromFolder(lngTicketID, CType(26, Long)) 'Folder Phone support
                removeTicketFromFolder(lngTicketID, CType(29, Long)) 'Folder Ordering parts
                removeTicketFromFolder(lngTicketID, CType(30, Long)) 'Folder Need Customer Feedback
                removeTicketFromFolder(lngTicketID, CType(31, Long)) 'Folder Part on Backorder
                removeTicketFromFolder(lngTicketID, CType(32, Long)) 'Folder Part on Backorder
                removeTicketFromFolder(lngTicketID, CType(33, Long)) 'Folder Need Appt set

        End Select

    End Sub  
    Private Sub removeTicketFromFolder(ByVal lngTicketID As Long, ByVal lngFolderID As Long)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spRemoveTicketFromFolder")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketID", Data.SqlDbType.Int).Value = lngTicketID
        cmd.Parameters.Add("@FolderID", Data.SqlDbType.Int).Value = lngFolderID
        cnn.open        
        cmd.Connection = cnn
        
        cmd.ExecuteNonQuery()
        cnn.Close()
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div class="errorzone" id="divErrors" runat="server" visible="false" />
    <p>Are you sure you wish to cancel this ticket?</p>
    <div class="label">Cancellation Fee</div>
    <asp:TextBox ID="txtCancelFee" style="text-align: right;" runat="server" />
    <div class="label">Reason for Cancelation</div>
    <div style="padding-right: 3px"><asp:TextBox ID="txtCancelationReason" runat="server" style="width: 100%; height: 100px;" TextMode="multiline" /></div>
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="No" />&nbsp;<asp:Button ID="btnYes" Text="Yes" OnClick="btnYes_Click" runat="server" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>