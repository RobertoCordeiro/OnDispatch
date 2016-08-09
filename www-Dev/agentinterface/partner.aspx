<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">

  Private _ID As Long = 0
  Private _mnu As long = 0
   
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Information"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Information"
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""partners.aspx"">Partner Management</a> &gt; Partner Information"
      Try
        _ID = CType(Request.QueryString("id"), Long)
      Catch ex As Exception
        _ID = 0
      End Try
      
      Try
        _mnu = CType(Request.QueryString("mnu"), Long)
      Catch ex As Exception
        _mnu = 0
      End Try
      
      if (page.IsPostBack =False) then
                Dim inf As New BridgesInterface.CompanyInfoRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                inf.Load(Master.InfoID)
                Dim par As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                par.Load(_ID)
                If par.InfoID <> inf.InfoID Then
                    Response.Redirect("/logout.aspx")
                Else
                    LoadInformation()
        
                    menu.Items(_mnu).Selected = True
                    Multiview1.ActiveViewIndex = _mnu
                End If
            Else
                menu.Items(_mnu).Selected = True
                Multiview1.ActiveViewIndex = _mnu
            End If
            End If
  End Sub
  
  Private Sub LoadInformation()
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ptr.Load(_ID)
    Dim res as New BridgesInterface.ResumeRecord (system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    res.Load (ptr.ResumeID)
    Dim rty as New BridgesInterface.ResumeTypeRecord (system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim usr As New BridgesInterface.UserRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
    rty.Load (res.ResumeTypeID)
    lblClosedWorkOrders.Text = ptr.ClosedWorkOrderCount
    lblOpenWorkOrders.Text = ptr.OpenWorkOrderCount
    lblPartnerID.Text = ptr.ResumeID
    lnkAddAgent.HRef = "addpartneragent.aspx?id=" & _ID
    lnkAddAddress.HRef = "addaddress.aspx?id=" & _ID & "&returnurl=partner.aspx%3fid=" & _ID & "&mode=partner"
    lnkAddPhone.HRef = "addphone.aspx?id=" & _ID & "&returnurl=partner.aspx%3fid=" & _ID & "&mode=partner"
    lblCompany.Text = ptr.CompanyName
    lblWebsite.Text = ptr.WebSite
    lblEmail.Text = ptr.Email
    lblResumeTypes.Text= rty.ResumeType 
    lnkEmail.HRef = "mailto:" & ptr.Email
    lblDateCreated.Text = ptr.DateCreated
    lnkDeactivate.HRef = "deactivatepartner.aspx?id=" & ptr.PartnerID & "&returnurl=partner.aspx%3fid=" & ptr.PartnerID
    lnkEdit.HRef = "editpartner.aspx?id=" & ptr.PartnerID & "&returnurl=partner.aspx%3fid=" & ptr.PartnerID
    lnkResume.HRef = "resume.aspx?resumeid=" & ptr.ResumeID
    If ptr.Active Then
      lblStatus.Text = "Active"
    Else
      lblStatus.Text = "Not Active"
    End If
    usr.Load(ptr.UserID)
    lblCSR.text = usr.UserName

    Dim pta As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    tdAdmin.Visible = True
    LoadAgents()
    LoadPhoneNumbers()
    LoadAddresses()
    divRates.Visible = True
    dgvRates.Visible = True
    divProjectRates.Visible = True
    dgvProjectRates.Visible = True
    LoadReferenceRates()
    LoadResumeNotes(ptr.ResumeID)
    LoadPartnerNotes(_ID)
    LoadOldInvoices()
    LoadJournalEntries()
    LoadInvoiceNumbers()
    LoadNeedPartsReturned()
    LoadAttachedDocuments(_ID)
    LoadProjectRates()
    
  End Sub
  
  Private Sub LoadReferenceRates()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerReferenceRates", "@PartnerID", _ID, dgvRates)
  End Sub
  
  Private Sub LoadOldInvoices()
    Dim ldr as New cvCommon.Loaders(system.Configuration.ConfigurationManager .AppSettings ("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid ("spGetVendorInvoicesByPartnerID","@PartnerID",_ID,dgvOldInvoices)
    Dim inv As New BridgesInterface.InvoiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    

    Dim dgv1 As System.Web.UI.WebControls.DataGrid
    For Each itm As DataGridItem In dgvOldInvoices.Items
      inv.Load(CType(itm.Cells(0).Text, Long))  
      dgv1 = itm.FindControl ("dgvPayments")
      LoadPayments (CType(itm.Cells(0).Text, Long),dgv1)
      
      dgv1 = itm.FindControl ("dgvJournal")
      loadJournal (Ctype(itm.Cells(0).Text,Long),dgv1)
    Next
    
  End Sub
  
  Private Sub LoadPayments(lngInvoiceID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spGetInvoicePaymentsByInvoiceID", "@InvoiceID", lngInvoiceID, dgv)
      End If
  End Sub
  
  Private Sub LoadAgents()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAgents", "@PartnerID", _ID, dgvAgents)
  End Sub
  
  Private Sub LoadPhoneNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerPhoneNumbers", "@PartnerID", _ID, Me.dgvPhoneNumbers)
  End Sub
  
  Private Sub LoadAddresses()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListPartnerAddresses", "@PartnerID", _ID, Me.dgvAddresses)
        LoadCounties(GetShippingAddressID(_ID))
       
  End Sub
  
  Private Function CurrentPartner() As Long
    Return _ID
  End Function
  
  Private Function MapIt(ByVal strAddress As String, ByVal strZipCode As String) As String
    Dim strReturn As String = ""
    Dim ggl As New cvCommon.Googler
    strReturn = ggl.MapAddress(strAddress, strZipCode)
    Return strReturn
  End Function
  
  Private Sub LoadResumeNotes(ByVal lngResumeID As Long)
    Dim ptr As New BridgesInterface.resumeNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ptr.Load(_ID)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListResumeNotes", "@ResumeID", lngResumeID, dgvNotes)
  End Sub
  
  Private Sub LoadPartnerNotes(ByVal lngPartnerID As Long)
    
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerNotes", "@PartnerID", lngPartnerID,dgvBillingNotes)
  End Sub
  
  Private Sub btnAddNote_Click(ByVal S As Object, ByVal E As EventArgs)
    dim ptr as New BridgesInterface.PartnerRecord(system.configuration.configurationmanager.appsettings("DBCnn"))    
    ptr.Load(_ID)
    If txtNote.Text.Trim.Length > 0 Then
      Dim rnt As New BridgesInterface.ResumeNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      rnt.Add(CType(ptr.ResumeID, Long), Master.UserID, txtNote.Text)
      LoadResumeNotes(CType(ptr.ResumeID, Long))
      txtNote.Text = ""
    End If
  End Sub
  
  Private Sub btnAddBillingNote_Click(ByVal S As Object, ByVal E As EventArgs)
    dim ptr as New BridgesInterface.PartnerRecord(system.configuration.configurationmanager.appsettings("DBCnn"))    
    ptr.Load(_ID)
    If txtBillingNote.Text.Trim.Length > 0 Then
      Dim rnt As New BridgesInterface.PartnerNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      rnt.Add(_ID ,Master.UserID, txtBillingNote.Text)
      
      LoadPartnerNotes(_ID)
      txtBillingNote.Text = ""
    End If
  End Sub
  
  Private Sub menu_MenuItemClick(ByVal sender As Object, ByVal e As MenuEventArgs) Handles menu.MenuItemClick
        Multiview1.ActiveViewIndex = Int32.Parse(e.Item.Value)
        Select Case Int32.Parse(e.Item.Value)
            
            Case Is = 0
                
            Case Is = 1
                
            Case Is = 2
                
            Case Is = 3
                
        End Select
        
    End Sub
    
    Private Sub LoadJournalEntries()
        Dim datDate2 As DateTime
        datDate2 = Now()
        
        
        Dim ldr As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadLongDateParameterDataGrid("spGetJournalEntriesByPartnerIDAndEndDate", "@PartnerID", _ID, "@EndPayPeriod", datDate2, dgvJournalEntries)
        
        
    End Sub
    
    Private Sub LoadJournal(lngInvoiceID as long, dgv as System.Web.UI.WebControls.DataGrid)
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      If Not IsNothing(dgv) Then
        ldr.LoadSingleLongParameterDataGrid("spGetJournalEntriesForInvoice", "@InvoiceID", lngInvoiceID, dgv)
      End If
  End Sub
  
  Private Sub LoadProjectRates()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerServiceRates", "@PartnerID", _ID, dgvProjectRates)
    LoadPaymentIncrements()
    txtDefaultPartnerFlatRate.Text = CDbl(0)
    txtDefaultPartnerHourlyRate.Text = CDbl(0)
    txtDefaultPartnerMinTimeOnSite.Text = CDbl(0)
    cbxDefaultPartnerIncrement.SelectedValue = "None"
    
  End Sub
  
  private Sub btnSubmitJournalEntry_Click(ByVal S As Object, ByVal E As EventArgs)
  If IsComplete then
   dim ptr as New BridgesInterface.PartnerRecord(system.configuration.configurationmanager.appsettings("DBCnn"))    
    ptr.Load(_ID)
   Dim rnt As New BridgesInterface.JournalEntryRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
   Dim pay as New BridgesInterface.PaymentRecord (system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
   Dim lngInvoiceID as Long 
   
    If drpInvoiceNumber.selectedValue <> "Choose One" Then
      If txtTicketID.Text <> "" then
        If txtWorkOrderID.Text <> "" then
          'Submit with InvoiceNumber, TicketID and workorderID
          rnt.Add (_ID, 0,txtAmount.Text,drpInvoiceNumber.SelectedValue ,txtTicketID.Text,txtWorkOrderID.Text,txtJournalNotes.text,Now(),txtDate.Text)
          'adding journal entry to payment records associated with invoice number
          lngInvoiceID = getinvoiceIDbyinvoicenumber(drpInvoiceNumber.SelectedValue )
          if lngInvoiceID <> 0 then
            pay.Add(lngInvoiceID,1,17,Ctype(txtAmount.Text,Double),Ctype(txtDate.Text,Date))
          end if
        else
          'submit with InvoiceNumber and TicketID
          rnt.Add (_ID, 0,txtAmount.Text,drpInvoiceNumber.SelectedValue ,txtTicketID.Text,0,txtJournalNotes.text,Now(),txtDate.Text)
          lngInvoiceID = getinvoiceIDbyinvoicenumber(drpInvoiceNumber.SelectedValue )
          if lngInvoiceID <> 0 then
            pay.Add(lngInvoiceID,1,17,Ctype(txtAmount.Text,Double),Ctype(txtDate.Text,Date))
          end if
        end if
      else
        if txtWorkorderID.Text <> "" Then
          'submit with InvoiceNumber and workoderID
          rnt.Add (_ID, 0,txtAmount.Text,drpInvoiceNumber.SelectedValue ,0,txtWorkOrderID.Text,txtJournalNotes.text,Now(),txtDate.Text)
          lngInvoiceID = getinvoiceIDbyinvoicenumber(drpInvoiceNumber.SelectedValue )
          if lngInvoiceID <> 0 then
            pay.Add(lngInvoiceID,1,17,Ctype(txtAmount.Text,Double),Ctype(txtDate.Text,Date))
          end if
        else
          'submit with InvoiceNumber
          rnt.Add (_ID, 0,txtAmount.Text,drpInvoiceNumber.SelectedValue ,0,0,txtJournalNotes.text,Now(),txtDate.Text)
          lngInvoiceID = drpInvoiceNumber.SelectedValue
          if lngInvoiceID <> 0 then
            pay.Add(lngInvoiceID,1,17,Ctype(txtAmount.Text,Double),Ctype(txtDate.Text,Date))
          end if
        end if
      end if
    else
      If txtTicketID.Text <> "" then
        If txtWorkOrderID.Text <> "" then
          'submit with TicketID and WorkOrderID
          rnt.Add (_ID, 0,txtAmount.Text,0,txtTicketID.Text,txtWorkOrderID.Text,txtJournalNotes.text,Now(),txtDate.Text)

        else
        'submit with TicketID only
         rnt.Add (_ID, 0,txtAmount.Text,0,txtTicketID.Text,0,txtJournalNotes.text,Now(),txtDate.Text)

        end if
      else
        'submit WITHOUT InvoiceNumber, TicketID and WorkOrderID
        rnt.Add (_ID, 0,txtAmount.Text,0,0,0,txtJournalNotes.text,Now(),txtDate.Text)

      end if
    end if
    
          txtJournalNotes.Text = ""
          txtdate.Text = ""
          txtAmount.Text = ""
          drpInvoiceNumber.selectedvalue = "Choose One"
          txtTicketID.Text = ""
          txtWorkOrderID.Text = ""
          LoadJournalEntries()
  end if
  
  end sub
  
  Private Function IsComplete() as boolean
    Dim bolReturn as Boolean 
    bolReturn = False
    If txtDate.Text <> "" then
      If IsDate(txtDate.Text) then
        bolReturn = True
      else
        
      end if
    else
    end if
    if txtAmount.Text <> "" then
      bolReturn = True
    else
    
    end if
    If txtJournalNotes.Text <> "" then
      bolReturn = True
    else
      
    end if
    
    IsComplete = bolReturn
      
  end Function
  
  Private Sub btnDeleteJournalEntry_Click(ByVal S As Object, ByVal E As EventArgs)
  Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim payr As New BridgesInterface.JournalEntryRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim dgItem As DataGridItem
  Dim chkbox As CheckBox
  Dim intJournalID As Integer
        
        For Each dgItem In dgvJournalEntries.Items
            chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                intJournalID = CType(dgItem.Cells.Item(1).Text, Long)
                
                payr.Load(intJournalID)
                
                payr.Delete()
                
            End If
        Next
        dgvJournalEntries.DataSource = Nothing
        
        'ldl.LoadStringDateParameterDataGrid("spGetPaidInvoices", "@CheckNumber", CType(txtCheckNumber.Text, String), "@DateCreated", datDate2, dgvTickets)
        LoadJournalEntries()
  end sub
  Function GetInvoiceIDByInvoiceNumber(ByVal strInvoiceNumber As String) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetInvoiceIDByInvoiceNumber")
        Dim lngInvoiceID As Long

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@InvoiceNumber", Data.SqlDbType.VarChar, len(strInvoiceNumber)).Value = strInvoiceNumber
        cnn.Open()
        cmd.Connection = cnn
        lngInvoiceID = cmd.ExecuteScalar()
        cnn.Close()
        GetInvoiceIDByInvoiceNumber = lngInvoiceID
    End Function
  Private Sub LoadInvoiceNumbers()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    
        ldr.LoadSingleLongParameterDropDownList("spGetLastInvoicesForPartner", "@PartnerID", _ID, "InvoiceNumber", "InvoiceID", drpInvoiceNumber)
        drpInvoiceNumber.Items.Add("Choose One")
        drpInvoiceNumber.SelectedValue = "Choose One"
 End Sub
 
 Private Sub btnApplyJournalEntry_Click(ByVal S As Object, ByVal E As EventArgs)
  Dim ldl As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim payr As New BridgesInterface.JournalEntryRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim pay as New BridgesInterface.PaymentRecord (system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim dgItem As DataGridItem
  Dim chkbox As CheckBox
  Dim intJournalID As Integer
  Dim strChangeLog as String = ""
  
      
        For Each dgItem In dgvJournalEntries.Items
            chkbox = dgItem.FindControl("chkselected")
            If chkbox.Checked Then
                intJournalID = CType(dgItem.Cells.Item(1).Text, Long)
                
                payr.Load(intJournalID)
                payr.InvoiceID = drpInvoiceNumber.SelectedValue 
                
                pay.Add(Ctype(drpInvoiceNumber.SelectedValue,Long) ,1,17,payr.Amount , payr.EndPayPeriod )
                pay.Comments = payr.Notes
                
                payr.save(strChangeLog) 
                pay.Save(strChangeLog)
            End If
        Next
        dgvJournalEntries.DataSource = Nothing
        LoadJournalEntries()
  end sub
  
   Private Sub LoadNeedPartsReturned()
        
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spListPartsNeedReturnedByPartnerID", "@PartnerID", _ID, dgvOpenWorkOrders)
        'ldr.LoadSingleLongParameterDataGrid("spListRequireSignatureDispatchedPartnerWorkOrders", "@PartnerID", Master.PartnerID, Me.dgvRequireUpload)
        
        lblTicketCount1.Text = " [ " & CType(dgvOpenWorkOrders.DataSource, Data.DataSet).Tables(0).Rows.Count & " ] "

  
    End Sub
    
    Private Sub btnExport_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Dim ex As New Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     
        If dgvOpenWorkOrders.Items.Count > 0 Then
            ex.ExportGrid("PartsNotReturned.xls", dgvOpenWorkOrders)
        End If
    End Sub
    
    Private Sub Item_Click(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs)
        Dim strTest As String
        
        strTest = (CType(e.CommandSource, LinkButton)).CommandName
        Select Case (CType(e.CommandSource, LinkButton)).CommandName
            
            Case "View"
                Dim exp As New cvCommon.Export
                Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
                Dim lngID As Long
                
                lngID = CType(e.Item.Cells(2).Text, Long)
                strTest = e.Item.Cells(1).Text
                
                fil.Load(lngID)
                exp.BinaryFileOut(Response, fil,System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection"))
                
            Case "Update"
                Dim lngFileID As Long
                lngFileID = CType(e.Item.Cells(2).Text, Long)
                Response.Redirect("PartnerDocumentsUpload.aspx?fid=" & CType(e.Item.Cells(0).Text, Long) & "&id=" & _ID & "&returnurl=partner.aspx?id=" & _ID & "&mode=doce&updt=" & lngFileID)

            Case "Remove"

                Dim fil As New cvFileLibrary.FileRecord(System.Configuration.ConfigurationManager.AppSettings("FLCnn"))
                Dim prt As New BridgesInterface.PartnerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
                Dim lngFilID As Long
                Dim DocID As Long
                DocID = CType(e.Item.Cells(0).Text, Long)
                lngFilID = CType(e.Item.Cells(2).Text, Long)
                prt.Load(DocID)
                fil.Load(lngFilID)
                
                Dim strChangelog As String = ""
               dim ptr as New BridgesInterface.PartnerRecord(system.configuration.configurationmanager.appsettings("DBCnn"))    
               ptr.Load(_ID)
               Dim rnt As New BridgesInterface.ResumeNoteRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
               rnt.Add(CType(ptr.ResumeID, Long), Master.UserID, "Auto Note: A Document has been removed from Vendor's Account: " & e.Item.Cells(1).Text )
               fil.Delete()
               prt.Delete()
               Response.Redirect("partner.aspx?id=" & _ID & "&returnurl=partner.aspx?id=" & _ID)
        End Select
    End Sub
    
    Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
        Response.Redirect("PartnerDocumentsUpload.aspx?fid=0" & "&id=" & _ID & "&returnurl=partner.aspx?id=" & _ID & "&mode=doc&updt=0")
    End Sub
    
    Private Sub LoadAttachedDocuments(ByVal lngPartnerID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        
        ldr.LoadSingleLongParameterDataGrid("spGetPartnerDocuments", "@PartnerID", lngPartnerID, dgvAttachments)
    End Sub
    Private Sub LoadCounties(ByVal lngPartnerAddressID As Long)
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSingleLongParameterDataGrid("spGetCountiesPerPartnerAddressID", "@PartnerAddressID", lngPartnerAddressID, dgvCounties)
    End Sub
    
    Private Function GetShippingAddressID(ByVal lngPartnerID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetPartnerShippingAddressByPartnerID")
        Dim lngID As Long

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.Int).Value = lngPartnerID
        cnn.Open()
        cmd.Connection = cnn
        lngID = cmd.ExecuteScalar()
        cnn.Close()
        GetShippingAddressID = lngID
        
        
    End Function
    
    
    
    Private Function GetResumeTypeID(ByVal lngServiceID As Long) As Long
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumeTypeIDByServiceID")
        Dim lngResumeTypeID As Long
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@ServiceID", Data.SqlDbType.int).Value = lngServiceID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            lngResumeTypeID = CType(dtr("ResumeTypeID"), Long)
        End While
        cnn.Close()
        GetResumeTypeID = lngResumeTypeID
    End Function
    
    Private Function IsPartnerAssignedToResumeTypeID(ByVal lngPartnerID As Long, ByVal lngResumeTypeID As Long) As Boolean
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsPartnerAssignedToResumeTypeID")
        Dim intCount As Integer
        intCount = 0
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerID", Data.SqlDbType.int).Value = lngPartnerID
        cmd.Parameters.Add("@ResumeTypeID", Data.SqlDbType.int).Value = lngResumeTypeID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            intCount = dtr("Total")
        End While
        cnn.Close()
        If intCount > 0 Then
            IsPartnerAssignedToResumeTypeID = True
        Else
            IsPartnerAssignedToResumeTypeID = False
        End If
    End Function
    
    Private Sub btnAssociateServices_click(ByVal S As Object, ByVal E As EventArgs)
     Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
     Dim svr As New BridgesInterface.PartnerServiceRateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))

        Dim cmd As New System.Data.SqlClient.SqlCommand("spListActiveServices")
        Dim lngResumeTypeID As Long
        Dim strChangeLog As String
        strChangeLog = ""
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            'lngResumeTypeID = GetResumeTypeID(dtr("ServiceID"))
            Dim cnn1 As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
            Dim cmd1 As New System.Data.SqlClient.SqlCommand("spGetResumeTypeIDByServiceID")
                    
            cmd1.CommandType = Data.CommandType.StoredProcedure
            cmd1.Parameters.Add("@ServiceID", Data.SqlDbType.Int).Value = dtr("ServiceID")
            cnn1.Open()
            cmd1.Connection = cnn1
            Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd1.ExecuteReader
            While dtr1.Read
                lngResumeTypeID = CType(dtr1("ResumeTypeID"), Long)
                
                If IsPartnerAssignedToResumeTypeID(_ID, lngResumeTypeID) Then
              
                    If Not svr.RecordExists(_ID, dtr("ServiceID")) Then
                        svr.Add(_ID, dtr("ServiceID"), cbxDefaultPartnerIncrement.SelectedValue, dtr("ServiceName"), txtDefaultPartnerFlatRate.Text, txtDefaultPartnerHourlyRate.Text, txtDefaultPartnerMinTimeOnSite.Text, True)
                    Else
                        svr.Load(_ID, dtr("ServiceID"))
                        svr.ServiceName = dtr("ServiceName")
                        svr.Save(strChangeLog)
                    End If
                Else
                    If svr.RecordExists(_ID, dtr("ServiceID")) Then
                        svr.Load(_ID, dtr("ServiceID"))
                        svr.FlatRate = CType(0, Double)
                        svr.HourlyRate = CType(0, Double)
                        svr.MinTimeOnSite = CType(0, Long)
                        svr.PayIncrementID = cbxDefaultPartnerIncrement.SelectedValue
                        svr.ServiceName = dtr("ServiceName")
                        svr.Active = False
                        svr.Save(strChangeLog)
                    End If

                End If
                
            End While
            cnn1.Close()
            
        End While
        cnn.Close()
        Response.Redirect("partner.aspx?id=" & _ID & "&mnu=5&returnurl=partner.aspx?id=" & _ID )
        
    end sub
    
    Private Sub LoadPaymentIncrements()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    'ldr.LoadSimpleDropDownList("spListPayIncrements", "IncrementType", "IncrementTypeID", cbxIncrement)
    ldr.LoadSimpleDropDownList("spListPayIncrements", "IncrementType", "IncrementTypeID", cbxDefaultPartnerIncrement)
  End Sub
  
  Private Sub btnPartnersUpdate_Click(ByVal S As Object, ByVal E As EventArgs)
  
  Dim dgItem As DataGridItem
  Dim chkbox As CheckBox
  Dim svr As New BridgesInterface.PartnerServiceRateRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
  Dim strChangeLog As String
  strChangeLog = ""
  
  For Each dgItem in dgvProjectRates.Items
          chkbox = dgItem.FindControl("chkselected")
          If chkbox.Checked Then
          
            svr.Load(CType(dgItem.Cells.Item(1).Text, Integer))
            svr.FlatRate = CType(txtDefaultPartnerFlatRate.Text, Double)
            svr.HourlyRate = CType(txtDefaultPartnerHourlyRate.Text, Double)
            svr.MinTimeOnSite = CType(txtDefaultPartnerMinTimeOnSite.Text, Long)
            svr.PayIncrementID = cbxDefaultPartnerIncrement.SelectedValue
            svr.Save(strChangeLog)
          End If
  Next
  Response.Redirect("partner.aspx?id=" & _ID & "&mnu=5&returnurl=partner.aspx?id=" & _ID )
  end sub
  
  
    
  </script>

<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
<form id="frmSettings" runat="server">
    <table style="width: 100%">
      <tbody>
        <tr>
          <td rowspan="2" class="band">
            <div class="inputformsectionheader">Commands</div>
            <div class="inputform">
              <div><a id="lnkDeactivate" runat="server">Deactivate</a></div>
              <div><a id="lnkEdit" runat="server">Edit</a></div>
            </div>
          </td>
          <td>
            <table>
              <tbody>
                <tr>
                  <td class="label">Company</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblCompany" runat="server" /></td>
                  <td>&nbsp;</td>
                  <td class="label">Partner Since</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblDateCreated" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Status</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblStatus" runat="server" /></td>
                  <td>&nbsp;</td>               
                  <td class="label">Email</td>
                  <td>&nbsp;</td>                  
                  <td><a id="lnkEmail" runat="server"><asp:Label ID="lblEmail" runat="server" /></a></td>
                </tr>
                <tr>
                  <td class="label">Website</td>
                  <td>&nbsp;</td>
                  <td colspan="5"><a target="_blank" id="lnkWebsite" runat="server"><asp:Label ID="lblWebsite" runat="server" /></a></td>
                </tr>
                <tr>
                  <td class="label">Resume</td>
                  <td>&nbsp;</td>
                  <td><a runat="server" id="lnkResume">View</a></td>
                  <td>&nbsp;</td>
                  <td class="label">Partner ID</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblPartnerID" runat="server" /></td>
                </tr>
                <tr>
                  <td class="label">Open WOs</td>
                  <td>&nbsp;</td>
                  <td><asp:Label ID="lblOpenWorkOrders" runat="server" /></td>
                  <td>&nbsp;</td>               
                  <td class="label">Closed WOs</td>
                  <td>&nbsp;</td>                  
                  <td><a id="A1" runat="server"><asp:Label ID="lblClosedWorkOrders" runat="server" /></a></td>
                </tr>
                <tr>
                 <td><b>Labor Network: </b></td>
                 <td colspan ="6"><asp:Label ID="lblResumeTypes"  runat ="server" /></td>
                </tr>
                <tr>
                  <td><b>Assigned Administrator: </b></td>
                  <td colspan="6"><asp:Label ID="lblCSR"  runat ="server" /></td>
                </tr>
              </tbody>
            </table>
            <div>&nbsp;</div>
            <div runat="server" id="divPrograms" visible="false" class="inputformsectionheader">Programs</div>
            <asp:DataGrid ID="dgvServiceTypes" AutoGenerateColumns="false" style="width: 100%" runat="server" CssClass="Grid1">
              <AlternatingItemStyle CssClass="altrow" />
              <HeaderStyle CssClass="gridheader" />
              <Columns>
                <asp:BoundColumn
                  HeaderText="ID"
                  DataField="ServiceTypeID"
                  visible="false"
                  />
                <asp:BoundColumn
                  HeaderText="Program"
                  DataField="ServiceType"
                  />
                <asp:TemplateColumn 
                  HeaderText="Active"
                  >             
                  <ItemTemplate>
                    <img alt="status" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>         
                <asp:BoundColumn
                  HeaderText="Date&nbsp;Created"
                  DataField="DateCreated"
                  />
              </Columns>      
            </asp:DataGrid>
          </td>          
          <td id="tdAdmin" runat="server" visible="false" style="padding-left: 16px; padding-right: 8px;">
          </td>
        </tr>
        <tr>
          <td colspan="2">
          <div id="tab5">
          <asp:Menu ID="menu" runat="server" Orientation="Horizontal" OnMenuItemClick ="menu_MenuItemClick" CssClass="ul">
             <StaticMenuItemStyle CssClass="li" />
             <StaticHoverStyle CssClass="hoverstyle" />
             <StaticSelectedStyle CssClass="current" />
             <Items>
                <asp:MenuItem  value ="0" Text="Notes"></asp:MenuItem>
                <asp:MenuItem value ="1" Text="Billing Notes"></asp:MenuItem> 
                <asp:MenuItem value = "2" Text="Journal Entries"></asp:MenuItem>
                <asp:MenuItem value = "3" Text="Old Invoices"></asp:MenuItem>
                <asp:MenuItem value = "4" Text="Regular Rates"></asp:MenuItem>
                <asp:MenuItem value = "5" Text="Project Rates"></asp:MenuItem>
                <asp:MenuItem value = "6" Text="Contacts"></asp:MenuItem>
                <asp:MenuItem value = "7" Text="Phone Numbers"></asp:MenuItem>
                <asp:MenuItem value = "8" Text="Addresses"></asp:MenuItem>
                <asp:MenuItem value = "9" Text="PartsNotReturned"></asp:MenuItem>
                <asp:MenuItem value = "10" Text="Attached Documents"></asp:MenuItem>
             </Items>
           </asp:Menu>
          </div>
          <div id="ratesheader" class="tabbody">
          <div >&nbsp;</div></div>
          <asp:MultiView ID="Multiview1" runat="server" ActiveViewIndex="0" >
          <asp:View ID="viewNotes"  runat="server">
             <div id="divNoteError" visible="false" runat="server" class="errorzone" />            
                <div class="inputformsectionheader">Add Note</div>
                <div class="inputform">
                <div style="padding-right: 3px"><asp:textbox ID="txtNote" runat="server" style="width: 100%; height: 100px;" TextMode="multiLine" /></div>
                <div style="text-align: right;"><asp:Button ID="btnAddNote" OnClick="btnAddNote_Click" runat="server" Text="Add Note" /></div>
              </div>
              <div class="inputformsectionheader">Notes</div>
              <asp:DataGrid ID="dgvNotes" runat="server" ShowHeader="false" AutoGenerateColumns="false" style="width: 100%" CssClass="Grid2">
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns>
                  <asp:TemplateColumn ItemStyle-Width="10%" ItemStyle-VerticalAlign="top" >
                    <ItemTemplate>
                      <div style="white-space:nowrap;"><%# Databinder.eval(Container.DataItem, "DateCreated") %></div>
                      <div><a href="mailto:<%# Databinder.eval(Container.DataItem, "Email") %>"><%# Databinder.eval(Container.DataItem, "UserName") %></a></div>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn ItemStyle-Wrap="true">
                    <Itemtemplate>
                    <%# Databinder.eval(Container.DataItem, "NoteBody").ToString.Replace(environment.NewLine,"<br />") %>
                    </Itemtemplate>
                  </asp:TemplateColumn>
                </Columns>
              </asp:DataGrid>
           </asp:View>
           <asp:View ID="viewBilingNotes"  runat="server">
             <div id="divNoteError1" visible="false" runat="server" class="errorzone" />            
                <div class="inputformsectionheader">Add Billing Note</div>
                <div class="inputform">
                <div style="padding-right: 3px"><asp:textbox ID="txtBillingNote" runat="server" style="width: 100%; height: 100px;" TextMode="multiLine" /></div>
                <div style="text-align: right;"><asp:Button ID="btnBillingNote" OnClick="btnAddBillingNote_Click" runat="server" Text="Add Note" /></div>
              </div>
              <div class="inputformsectionheader">Notes</div>
              <asp:DataGrid ID="dgvBillingNotes" runat="server" ShowHeader="false" AutoGenerateColumns="false" style="width: 100%" CssClass="Grid2">
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns>
                  <asp:TemplateColumn ItemStyle-Width="10%" ItemStyle-VerticalAlign="top" >
                    <ItemTemplate>
                      <div style="white-space:nowrap;"><%# Databinder.eval(Container.DataItem, "DateCreated") %></div>
                      <div><a href="mailto:<%# Databinder.eval(Container.DataItem, "Email") %>"><%# Databinder.eval(Container.DataItem, "UserName") %></a></div>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:TemplateColumn ItemStyle-Wrap="true">
                    <Itemtemplate>
                    <%# Databinder.eval(Container.DataItem, "NoteBody").ToString.Replace(environment.NewLine,"<br />") %>
                    </Itemtemplate>
                  </asp:TemplateColumn>
                </Columns>
              </asp:DataGrid>
           </asp:View>
           <asp:View ID="viewJournalEntries"  runat="server">
           <div >    
           <div >&nbsp;</div>
            <div >Date:<asp:textbox ID="txtDate" runat="server" />&nbsp;Amount:<asp:textbox ID="txtAmount" runat="server" />&nbsp;InvoiceNumber:<asp:dropdownlist ID="drpInvoiceNumber" runat="server" />&nbsp;TicketID<asp:textbox ID="txtTicketID" runat="server" />&nbsp;WorkOrderID:<asp:textbox ID="txtWorkOrderID" runat="server" /></div>
             <div >&nbsp;</div>
             <div style="text-align: right;"><asp:textbox ID="txtJournalNotes" runat="server" style="width: 100%; height: 100px;" TextMode="multiLine" /><asp:Button ID="btnSubmitJournalEntry" OnClick="btnSubmitJournalEntry_Click" runat="server" Text="Submit"  /></div>
             <div style="text-align: left;"><asp:Button ID="btnDelete" OnClick="btnDeleteJournalEntry_Click" runat="server" Text="Delete Journal Entry"  />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnApply" OnClick="btnApplyJournalEntry_Click" runat="server" Text="Apply Journal Entry to Invoice"  /></div>
             <div >&nbsp;</div>
           </div>
           <asp:DataGrid ID="dgvJournalEntries" AutoGenerateColumns="false" runat="server" style="background-color: White; width: 100%"  ShowFooter = "True" CssClass="Grid1" ><FooterStyle cssClass="gridheader" HorizontalAlign="Right" BackColor="#C0C0C0" />
             <AlternatingItemStyle CssClass="altrow" />
             <HeaderStyle CssClass="gridheader" />
             <Columns>
             <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected" runat="server" />
                  </ItemTemplate>
             </asp:TemplateColumn>
             <asp:BoundColumn DataField="JournalEntryID" HeaderText="ID" Visible="false" />
             <asp:BoundColumn DataField="Amount" HeaderText="Amount" />
             <asp:BoundColumn DataField="Notes" HeaderText="Notes"  />
             <asp:BoundColumn DataField="EndPayPeriod" HeaderText="End Date"  />
             </Columns>
             </asp:DataGrid> 
           </asp:View> 
           <asp:View ID="viewOldInvoices"  runat="server">
            <div visible="True" id="divOldInvoices" class="inputformsectionheader" runat="server">Old Invoices</div>
            <asp:DataGrid Visible="True" ID="dgvOldInvoices" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                <asp:TemplateColumn HeaderText ="InvoiceNumber" > 
                  <ItemTemplate>
                    <a href="OldInvoices.aspx?id=<%# Databinder.eval(Container.DataItem,"InvoiceID") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"InvoiceNumber") %></a><a target="_blank" href="VendorInvoiceReport.aspx?id=<%# Databinder.eval(Container.DataItem,"InvoiceID") %>"><img style="border: 0" alt="Printable Version" src="/graphics/printable.png" />
                  </ItemTemplate>
                </asp:TemplateColumn>           
                <asp:BoundColumn DataField="Total" HeaderText="Total" DataFormatString="{0:C}" />
                <asp:BoundColumn DataField="InvoiceDate" HeaderText="InvoiceDate" />
                <asp:TemplateColumn HeaderText ="Payment Records">
                  <ItemTemplate>
                     <asp:DataGrid Visible="True" ID="dgvPayments" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                        <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />   
                            <Columns>
                               <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                               <asp:BoundColumn DataField="checkNumber" HeaderText="CheckNumber" />            
                               <asp:BoundColumn DataField="Amount" HeaderText="CheckAmount" DataFormatString="{0:C}" />
                               <asp:BoundColumn DataField="PayDate" HeaderText="PayDate" />
                            </Columns>                
                     </asp:DataGrid>    
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText ="Journal Entries" > 
                  <ItemTemplate>
                     <asp:DataGrid Visible="True" ID="dgvJournal" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
                        <HeaderStyle CssClass="gridheader" />
                          <AlternatingItemStyle CssClass="altrow" />   
                            <Columns>
                               <asp:BoundColumn DataField="InvoiceID" HeaderText="ID" visible="False" />
                               <asp:TemplateColumn ItemStyle-Wrap="true">
                                  <Itemtemplate>
                                     <%#DataBinder.Eval(Container.DataItem, "Comments").ToString.Replace(Environment.NewLine, "<br />")%>
                                  </Itemtemplate>
                               </asp:TemplateColumn>
                               <asp:BoundColumn DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
                            </Columns>                
                     </asp:DataGrid>   
                  </ItemTemplate>
                </asp:TemplateColumn>                
              </Columns>                
            </asp:DataGrid>  
           </asp:View>
           <asp:View ID="viewRates"  runat="server">
            <div visible="false" id="divRates" class="inputformsectionheader" runat="server">Regular Rates</div>
            <asp:DataGrid Visible="false" ID="dgvRates" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn
                  DataField="PartnerReferenceRateID"
                  HeaderText="ID"
                  visible="False"
                />
                <asp:BoundColumn
                  DataField="Description"
                  HeaderText="Type"
                  ItemStyle-Wrap="false"
                  />
                <asp:BoundColumn
                  DataField="Rate"
                  HeaderText="Rate"
                  DataFormatString="{0:C}"
                  />
                <asp:TemplateColumn>
                  <ItemTemplate>
                    <a href="editpartnerrate.aspx?id=<%# Databinder.eval(Container.DataItem,"PartnerReferenceRateID") %>&returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>">Edit</a>
                  </ItemTemplate>
                </asp:TemplateColumn>               
              </Columns>                
            </asp:DataGrid>
           </asp:View>
           <asp:View ID="viewProjectRates"  runat="server">
           <div class="vendorrates"  style="width:"100%;">
           <div class="vendorrates">Set Vendor Default Rates
            <table cellpadding="0" width="100%";>
              <tbody>
                 <tr>
                    <td class="label">Flat Rate</td>
                    <td>&nbsp;</td>
                    <td class="label">Hourly Rate</td>
                    <td>&nbsp;</td>
                    <td class="label">MinTimeOnSite</td>
                    <td>&nbsp;</td>
                    <td class="label">Increment</td>
                </tr>
                <tr>
                    <td class="label"><asp:TextBox ID="txtDefaultPartnerFlatRate" style="width:60px" runat="server" /></td>
                    <td>&nbsp;</td>
                    <td class="label"><asp:TextBox ID="txtDefaultPartnerHourlyRate" style="width:60px" runat="server" /></td>
                    <td>&nbsp;</td>
                    <td class="label"><asp:TextBox ID="txtDefaultPartnerMinTimeOnSite" style="width:60px" runat="server" /></td>
                    <td>&nbsp;</td>
                    <td class="label"><asp:DropDownList ID="cbxDefaultPartnerIncrement" style="width: 100%" runat="server" /></td>
                    <td>&nbsp;</td>
                    <td><asp:Button OnClick="btnAssociateServices_Click" ID="btnAssociateServices" runat="server" Text="Associate Services To Vendor"  /></td>
                    <td>&nbsp;</td>
                    <td><asp:Button OnClick="btnPartnersUpdate_Click" ID="Partners" runat="server" Text="Update Selected Services"  /></td>
                </tr>
              </tbody>
            </table>
          </div>
           </div>
            <div visible="false" id="divProjectRates" class="inputformsectionheader" runat="server">Project Rates</div>
            <asp:DataGrid  Visible="false" ID="dgvProjectRates" style="width: 100%" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" /> 
              <Columns>
                  <asp:TemplateColumn>
                  <ItemTemplate>
                    <asp:CheckBox ID="chkSelected" runat="server"    />
                  </ItemTemplate>
                </asp:TemplateColumn>  
             
                <asp:BoundColumn
                  DataField="PartnerServiceRateID"
                  HeaderText="ID"
                  visible="False"
                />
                <asp:BoundColumn
                  DataField="ServiceName"
                  HeaderText="Type"
                  ItemStyle-Wrap="false"
                  />
                <asp:BoundColumn
                  DataField="FlatRate"
                  HeaderText="Rate"
                  DataFormatString="{0:C}"
                  />
                <asp:TemplateColumn>
                  <ItemTemplate>
                    <a href="editpartnerrate.aspx?id=<%# Databinder.eval(Container.DataItem,"PartnerServiceRateID") %>&returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>">Edit</a>
                  </ItemTemplate>
                </asp:TemplateColumn>               
              </Columns>                
            </asp:DataGrid>
           </asp:View>
           <asp:View ID="viewContacts"  runat="server">
           <div class="inputformsectionheader">Contacts / Agents</div>
            <asp:DataGrid style="width: 100%" ID="dgvAgents" AutoGenerateColumns="false" runat="server" CssClass="Grid1">
              <HeaderStyle cssclass="gridheader" />
              <AlternatingItemStyle cssclass="altrow" />  
              <Columns>
                <asp:BoundColumn
                  HeaderText="ID"
                  DataField="PartnerAgentID"
                  Visible="false"
                />
                <asp:TemplateColumn
                  HeaderText="Command"
                  >
                  <ItemTemplate>
                    <a href="editpartneragent.aspx?returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerAgentID") %>">[Open]</a>&nbsp;<a href="certificationsurvey.aspx?returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerAgentID") %>">[Certs]</a>&nbsp;<a href="skillsetsurvey.aspx?returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerAgentID") %>">[Skills]</a>
                  </ItemTemplate>
                </asp:TemplateColumn>                
                <asp:BoundColumn
                  HeaderText="Type"
                  DataField="AgentType"
                  />
                  <asp:BoundColumn
                  HeaderText="Status"
                  DataField="PartnerAgentStatus"
                  />
                <asp:TemplateColumn
                  HeaderText="Name"
                  >
                  <Itemtemplate>
                    <%# DataBinder.Eval(Container.DataItem,"FirstName") %>&nbsp;<%# DataBinder.Eval(Container.DataItem,"MiddleName") %>&nbsp;<%#DataBinder.Eval(Container.DataItem, "LastName")%>                    
                  </Itemtemplate>                  
                </asp:TemplateColumn>
                <asp:TemplateColumn 
                  HeaderText="Admin"
                  >             
                  <ItemTemplate>
                    <img alt="Admin Agent" src="/graphics/<%# Databinder.eval(Container.DataItem, "AdminAgent") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn 
                  HeaderText="Active"
                  >             
                  <ItemTemplate>
                    <img alt="Active" src="/graphics/<%# Databinder.eval(Container.DataItem, "Active") %>.png" />                 
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn
                  DataField="LastLogIn"
                  HeaderText="Last Login"
                  />                
              </Columns>
            </asp:DataGrid>            
            <div style="text-align:right;"><a id="lnkAddAgent" runat="server" >[Add Agent]</a></div>
           </asp:View>
           <asp:View ID="viewPhoneNumbers"  runat="server">
           <div class="inputformsectionheader">Phone Numbers</div>
            
            <asp:DataGrid style="width:100%" ID="dgvPhoneNumbers" runat="server" AutoGenerateColumns="false" CssClass="Grid1">
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
                    <a href="editphone.aspx?returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerPhoneNumberID") %>&mode=Partner">Edit</a>
                  </Itemtemplate>
                </asp:TemplateColumn>                            
              </Columns>                
            </asp:DataGrid>
            <div style="text-align:right"><a id="lnkAddPhone" runat="server">[Add Phone Number]</a></div>
           </asp:View>
           <asp:View  ID="viewAddresses" runat="server">
            <div class="inputformsectionheader">Addresses</div>
            <asp:DataGrid style="width: 100%" AutoGenerateColumns="false" ID="dgvAddresses" runat="server" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
              <AlternatingItemStyle CssClass="altrow" />   
              <Columns>
                <asp:BoundColumn
                  DataField="AddressType"
                  HeaderText="Type"
                  ItemStyle-Wrap="false"
                  />
                <asp:TemplateColumn
                  HeaderText="Address"
                  >
                  <ItemTemplate>
                    <a target="_blank" href="<%# MapIt(DataBinder.Eval(Container.DataItem,"Street"),DataBinder.Eval(Container.DataItem,"ZipCode")) %>"><%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%></a>
                  </ItemTemplate>
                </asp:TemplateColumn>                  
                <asp:BoundColumn
                  DataField="City"
                  HeaderText="City"
                  />
                <asp:BoundColumn
                  DataField="StateAbbreviation"
                  HeaderText="State"
                  />
                <asp:TemplateColumn
                  HeaderText="Zip"
                  >
                  <ItemTemplate>
                    <a href="findzipcode.aspx?zip=<%# Databinder.eval(Container.DataItem,"ZipCode") %>" target="_blank"><%# Databinder.eval(Container.DataItem,"ZipCode") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn
                  HeaderText="Location"
                  >
                  <ItemTemplate>
                    <a href="../Maps/<%# Databinder.eval(Container.DataItem,"LocationName") %>.jpg" target="_blank"><%# Databinder.eval(Container.DataItem,"LocationName") %></a>
                  </ItemTemplate>
                </asp:TemplateColumn>
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
                    <a href="editaddress.aspx?mode=partner&returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerAddressID") %>">Edit</a>&nbsp;<a href="buildterritory.aspx?returnurl=partner.aspx%3fid=<%# DataBinder.Eval(Container.DataItem,"PartnerID") %>&id=<%# DataBinder.Eval(Container.DataItem,"PartnerAddressID") %>">Radius</a>
                  </Itemtemplate>
                </asp:TemplateColumn>
              </Columns>        
            </asp:DataGrid>
            <div style="text-align:right"><a id="lnkAddAddress" runat="server">[Add Address]</a></div>
            <div>&nbsp;</div> 
            <div class="inputformsectionheader">Counties Covered</div>
            <div>
              <asp:DataGrid ID="dgvCounties" runat="server" style="background-color: White;" AutoGenerateColumns="false" CssClass="Grid1">
                        <AlternatingItemStyle CssClass="altrow" />
                        <HeaderStyle CssClass="gridheader" />
                        <Columns>
                          <asp:BoundColumn DataField="CountyName" HeaderText="County" />
                        </Columns>
                     </asp:DataGrid>
            </div> 
           </asp:View>
           <asp:View ID="NeedReturnParts"  runat="server">
            <div class="inputformsectionheader"><asp:ImageButton ID="btnExport" AlternateText ="Export to Excel" ImageUrl ="/images/Excel-16.gif"  ImageAlign="right"  OnClick="btnExport_Click" runat="server"/></div> 
            <div class="inputformsectionheader">&nbsp;</div>
            <div class="inputformsectionheader"><asp:Label ID="lblTicketCount1" runat="server"></asp:Label> Tickets Needing Part Returned</div>
            <asp:DataGrid ID="dgvOpenWorkOrders" runat="server" style="width: 100%; background-color:White;" AutoGenerateColumns="false" CssClass="Grid1">
              <HeaderStyle CssClass="gridheader" />
               <AlternatingItemStyle CssClass="altrow" />
                 <Columns>
                   <asp:TemplateColumn HeaderText="Ticket ID">
                     <ItemTemplate>
                        <a target="_blank" href="ticket.aspx?id=<%# Databinder.Eval(Container.DataItem,"TicketID") %>&returnurl=workoders.aspx&act=G"><%# Databinder.Eval(Container.DataItem,"TicketID") %></a>
                     </ItemTemplate>
                   </asp:TemplateColumn>
                  <asp:BoundColumn HeaderText="Age" DataField="Age" />
                  <asp:BoundColumn HeaderText="Customer" DataField="Company" />
                  <asp:BoundColumn HeaderText="TypeOfService" DataField="ServiceName" />
                  <asp:BoundColumn HeaderText="Status" DataField="Status" />
                  <asp:BoundColumn HeaderText="PartNumber" DataField="Code" />
                  <asp:BoundColumn HeaderText="Description" DataField="Component" />
                  <asp:BoundColumn HeaderText="PartCost" DataField="PartCost" DataFormatString="{0:c}"/>
                  <asp:BoundColumn HeaderText="ReturnType" DataField="Destination" />
                  <asp:TemplateColumn HeaderText="TrackingNumber">
                          <ItemTemplate>
                            <a target="_blank" href="<%# Databinder.eval(Container.DataItem,"TrackingScript").ToString.Replace("$shippinglabel",DataBinder.Eval(Container.DataItem,"ShippingLabel")) %>"><%# DataBinder.Eval(Container.DataItem,"ShippingLabel") %></a>                    
                          </ItemTemplate>
                        </asp:TemplateColumn>
               </Columns>      
            </asp:DataGrid>
           </asp:View>
           <asp:View ID="AttachedDocuments"  runat="server">
            <div class="inputformsectionheader">Attachments</div>
                  <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" Width ="30%" />      
                  <asp:DataGrid style="width:100%" ID="dgvAttachments" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="Item_Click" CssClass="Grid1">
                    <ItemStyle CssClass="bandbar" />
                      <Columns>
                        <asp:BoundColumn DataField="PartnerDocumentID" HeaderText="ID" Visible="false" />
                        <asp:BoundColumn DataField="Description" HeaderText="DocType" Visible="True" />
                        <asp:BoundColumn DataField="FileID" HeaderText="FileID" Visible="false" />
                        <asp:ButtonColumn Text="View" CommandName ="View" ></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Update" CommandName="Update"></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Remove" CommandName="Remove" ></asp:ButtonColumn> 
                     </Columns>              
                  </asp:DataGrid> 
           </asp:View>
           <asp:View ID="ScheduleAvailability"  runat="server">
            <div class="inputformsectionheader">Schedule Availability</div>
                  <asp:Button ID="Button1" runat="server" Text="Add" OnClick="btnAdd_Click" Width ="30%" />      
                  <asp:DataGrid style="width:100%" ID="DataGrid1" runat="server" ShowHeader="True" ShowFooter="false" AutoGenerateColumns="false" OnItemCommand="Item_Click" CssClass="Grid1">
                    <ItemStyle CssClass="bandbar" />
                      <Columns>
                        <asp:BoundColumn DataField="PartnerDocumentID" HeaderText="ID" Visible="false" />
                        <asp:BoundColumn DataField="Description" HeaderText="DocType" Visible="True" />
                        <asp:BoundColumn DataField="FileID" HeaderText="FileID" Visible="false" />
                        <asp:ButtonColumn Text="View" CommandName ="View" ></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Update" CommandName="Update"></asp:ButtonColumn>  
                        <asp:ButtonColumn Text="Remove" CommandName="Remove" ></asp:ButtonColumn> 
                     </Columns>              
                  </asp:DataGrid> 
           </asp:View>
           </asp:MultiView>   
          </td>
        </tr>
      </tbody>
    </table>
</form>
</asp:Content>