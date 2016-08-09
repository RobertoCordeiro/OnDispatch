<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Edit Service"
      Master.PageTitleText = " Edit Service"
      'Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customers</a> &gt;"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      Dim srv As New BridgesInterface.ServiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      srv.Load(_ID) 
      Dim stp As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      stp.Load(srv.servicetypeID)     
      Dim cus As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim com As New BridgesInterface.CompanyInfoRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cus.Load(stp.CustomerID)
      com.Load (cus.InfoID )
      
      If com.CustomerID = stp.CustomerID  then
         Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""mycompany.aspx?id=" & cus.InfoID & """>My Company</a> &gt; <a href=""editservicetype.aspx?id=" & stp.ServiceTypeID & """>Edit Program</a>"
         lblReturnUrl.Text = "editservicetype.aspx?id=" & srv.ServiceTypeID
      else
         Master.PageSubHeader &= "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customer.aspx?id=" & stp.CustomerID & """>Customer</a></a>&gt; <a href=""editservicetype.aspx?id=" & stp.ServiceTypeID & """>Edit Program</a>"
         lblReturnUrl.Text = "editservicetype.aspx?id=" & srv.ServiceTypeID
      end if
      If Not IsPostBack Then        
        LoadPaymentIncrements()
        LoadService()
      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadService()    
    Dim srv As New BridgesInterface.ServiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    srv.Load(_ID)
    txtServiceName.Text = srv.ServiceName
    txtDescription.Text = srv.Description
    txtInstructions.Text = srv.Instructions
    txtMinimum.Text = srv.MinimumCharge.ToString
    txtRate.Text = srv.ChargeRate.ToString("#0.00")
    txtFlatRate.Text = srv.FlatRate.ToString("#0.00")
    txtDefaultPartnerFlatRate.Text = srv.DefaultPartnerFlatRate.ToString("#0.00")
    txtDefaultPartnerHourlyRate.Text = srv.DefaultPartnerHourlyRate.ToString("#0.00")
    txtDefaultPartnerMinTimeOnSite.Text = srv.DefaultPartnerMinTimeOnSite.ToString 
    cbxDefaultPartnerIncrement.SelectedValue = srv.DefaultPartnerIncrement
    'txtAdjust.Text = srv.AdjustmentCharge.ToString("#0.00")
    cbxIncrement.SelectedValue = srv.PayIncrementID
    chkActive.Checked = srv.Active
  End Sub

  Private Sub LoadPaymentIncrements()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSimpleDropDownList("spListPayIncrements", "IncrementType", "IncrementTypeID", cbxIncrement)
    ldr.LoadSimpleDropDownList("spListPayIncrements", "IncrementType", "IncrementTypeID", cbxDefaultPartnerIncrement)
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim dbl As Double = 0
    Dim lng as Long = 0
    Dim strErrors As String = ""
    If txtServiceName.Text.Trim.Length = 0 Then
      strErrors &= "<li>Service Name is Required</li>"
      blnReturn = False
    End If
    If txtDescription.Text.Trim.Length = 0 Then
      strErrors &= "<li>Description is Required</li>"
      blnReturn = False
    End If
    If txtInstructions.Text.Trim.Length = 0 Then
      strErrors &= "<li>Instructions Are Required</li>"
      blnReturn = False
    End If
    If txtMinimum.Text.Trim.Length = 0 Then
      strErrors &= "<li>MinTimeOnSite is Required</li>"
      blnReturn = False
    Else
      If Not long.TryParse(txtMinimum.Text, lng) Then
        strErrors &= "<li>MinTimeOnSite Must Be A Number</li>"
        blnReturn = False
      End If
    End If
    If txtRate.Text.Trim.Length = 0 Then
      strErrors &= "<li>Hourly Rate is Required</li>"
      blnReturn = False
      If Not Double.TryParse(txtRate.Text, dbl) Then
        strErrors &= "<li>Rate Must Be A Number</li>"
        blnReturn = False
      End If
    End If
    If txtFlatRate.Text.Trim.Length = 0 Then
      strErrors &= "<li>Flat Rate is Required</li>"
      blnReturn = False
      If Not Double.TryParse(txtFlatRate.Text, dbl) Then
        strErrors &= "<li>Rate Must Be A Number</li>"
        blnReturn = False
      End If
    End If
    If txtDefaultPartnerFlatRate.Text.Trim.Length = 0 Then
      strErrors &= "<li>Default Parnter Flat Rate is Required</li>"
      blnReturn = False
      If Not Double.TryParse(txtDefaultPartnerFlatRate.Text, dbl) Then
        strErrors &= "<li>Rate Must Be A Number</li>"
        blnReturn = False
      End If
    End If
    If txtDefaultPartnerHourlyRate.Text.Trim.Length = 0 Then
      strErrors &= "<li>Default Parnter Hourly Rate is Required</li>"
      blnReturn = False
      If Not Double.TryParse(txtDefaultPartnerHourlyRate.Text, dbl) Then
        strErrors &= "<li>Rate Must Be A Number</li>"
        blnReturn = False
      End If
    End If
    If txtDefaultPartnerMinTimeOnSite.Text.Trim.Length = 0 Then
      strErrors &= "<li>Default Parnter MinTimeOnSite is Required</li>"
      blnReturn = False
      If Not long.TryParse(txtDefaultPartnerMinTimeOnSite.Text,lng) Then
        strErrors &= "<li>MinTimeOnSite Must Be A Number</li>"
        blnReturn = False
      End If
    End If
   
    'If txtAdjust.Text.Trim.Length = 0 Then
    '  strErrors &= "<li>Adjustment is Required</li>"
    '  blnReturn = False
    '  If Not Double.TryParse(txtAdjust.Text, dbl) Then
    '    strErrors &= "<li>Adjust Must Be A Number</li>"
    '    blnReturn = False
    '  End If
    'End If
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim srv As New BridgesInterface.ServiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      srv.Load(_ID)
      Dim strChangeLog As String = ""
      srv.ServiceName = txtServiceName.Text
      srv.Description = txtDescription.Text
      srv.Instructions = txtInstructions.Text
      srv.PayIncrementID = cbxIncrement.SelectedValue
      srv.Active = chkActive.Checked
      'srv.AdjustmentCharge = CType(txtAdjust.Text, Double)
      srv.MinimumCharge = CType(txtMinimum.Text, Double)
      srv.ChargeRate = CType(txtRate.Text, Double)
      srv.FlatRate = Ctype(txtFlatRate.Text,Double)
      srv.DefaultPartnerFlatRate = Ctype(txtDefaultPartnerFlatRate.Text,Double)
      srv.DefaultPartnerHourlyRate = Ctype(txtDefaultPartnerHourlyRate.Text,Double)
      srv.DefaultPartnerMinTimeOnSite = ctype(txtDefaultPartnerMinTimeOnSite.Text,Long)
      srv.DefaultPartnerIncrement = cbxDefaultPartnerIncrement.SelectedValue 
      srv.Save(strChangeLog)
      
      
      Dim act As New BridgesInterface.ActionRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strIp As String = Request.QueryString("REMOTE_ADDR")
      Dim strType As String = Request.ServerVariables("HTTP_USER_AGENT")
      If IsNothing(strIp) Then
        strIp = "unknown"
      End If
      If IsNothing(strType) Then
        strType = "web"
      End If
      act.Add(2, "web", strType, strIp, "web", 32, srv.ServiceID, strChangeLog)
      Response.Redirect(lblReturnUrl.Text, True)
      divErrors.Visible = False
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private sub UpdatePartnerServiceRates()
   Dim svr as New BridgesInterface.PartnerServiceRateRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
   Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spListActivePartners")
        Dim lngResumeTypeID as long
        Dim strChangeLog as String
        strChangeLog = ""
        lngResumeTypeID = GetResumeTypeID(_ID)
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            
            If not svr.RecordExists(dtr("PartnerID"),_ID) then
              If IsPartnerAssignedToResumeTypeID(dtr("PartnerID"),lngResumeTypeID) then
                 svr.Add(dtr("PartnerID"),_ID,cbxDefaultPartnerIncrement.SelectedValue,txtServiceName.Text,txtDefaultPartnerFlatRate.Text,txtDefaultPartnerHourlyRate.Text,txtDefaultPartnerMinTimeOnSite.Text,True)
              else
                 svr.Add(dtr("PartnerID"),_ID,cbxDefaultPartnerIncrement.SelectedValue,txtServiceName.Text,txtDefaultPartnerFlatRate.Text,txtDefaultPartnerHourlyRate.Text,txtDefaultPartnerMinTimeOnSite.Text,False)
              end if
            else
            svr.Load(dtr("PartnerID"),_ID)
                If svr.FlatRate < CType(txtDefaultPartnerFlatRate.Text, Double) Then
                    svr.FlatRate = CType(txtDefaultPartnerFlatRate.Text, Double)
                End If
                
                svr.HourlyRate = CType(txtDefaultPartnerHourlyRate.Text, Double)
                svr.MinTimeOnSite = CType(txtDefaultPartnerMinTimeOnSite.Text, Long)
                svr.PayIncrementID = cbxDefaultPartnerIncrement.SelectedValue
                svr.ServiceName = txtServiceName.Text
                If IsPartnerAssignedToResumeTypeID(dtr("PartnerID"), lngResumeTypeID) Then
                    svr.Active = True
                Else
                    svr.Active = False
                End If
            
                svr.Save(strChangeLog)
                End If
        End While
        cnn.Close()
  
  end sub
  Private Function GetResumeTypeID (lngServiceID as Long) as Long
  Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetResumeTypeIDByServiceID")
        Dim lngResumeTypeID as long
        
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@ServiceID", Data.SqlDbType.int).Value = lngServiceID
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
           lngResumeTypeID = Ctype(dtr("ResumeTypeID"),Long)             
        End While
        cnn.Close()
        GetResumeTypeID = lngResumeTypeID
  end function
  
Private Function IsPartnerAssignedToResumeTypeID (lngPartnerID as Long, lngResumeTypeID as long) as Boolean 
  Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spIsPartnerAssignedToResumeTypeID")
        Dim intCount as Integer 
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
        If intCount > 0 then
          IsPartnerAssignedToResumeTypeID = True
          else
          IsPartnerAssignedToResumeTypeID = False
          end if
  end function
  
  Private Sub btnPartnersUpdate_Click(ByVal S As Object, ByVal E As EventArgs)
    UpdatePartnerServiceRates()
  end sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divErrors" class="errorzone" runat="server" visible="false" />
      <div class="label">Service SKU</div>
      <asp:textbox ID="txtServiceName" style="width: 99%" runat="server" />
      <div class="label">On Site Insturctions</div>
      <asp:TextBox ID="txtDescription" style="width: 99%; height: 50px;" TextMode="MultiLine" runat="server" />    
      <div class="label">Instructions</div>
      <asp:TextBox ID="txtInstructions" style="width: 99%; height: 100px;" TextMode="MultiLine" runat="server" />
      <div>&nbsp;</div>
      <div class="bandheader">Pricing</div>
      <div class="blockrate">
         <div class="customerrates">Customer Rates
            <table cellpadding="0">
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
                    <td class="label"><asp:TextBox ID="TxtFlatRate" style="width:60px" runat="server" /></td>
                    <td>&nbsp;</td>
                    <td class="label"><asp:TextBox ID="txtRate" style="width:60px" runat="server" /></td>
                    <td>&nbsp;</td>
                    <td class="label"><asp:TextBox ID="txtMinimum" style="width:60px" runat="server" /></td>
                    <td>&nbsp;</td>
                    <td class="label"><asp:DropDownList ID="cbxIncrement" style="width: 100%" runat="server" /></td>
                </tr>
              </tbody>
            </table>
         </div>
         <div class="vendorrates">Vendor Default Rates
            <table cellpadding="0">
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
                </tr>
              </tbody>
            </table>
          </div>
          <div class="submitbuttons">
            <table cellpadding="0" >
              <tbody>
                 <tr >
                     <td  colspan ="7">
                      <div ><asp:CheckBox ID="chkActive" runat="server" Text="Active"  /></div>
                      <div>&nbsp;</div>
                      <div ><asp:Button OnClick="btnPartnersUpdate_Click" ID="Partners" runat="server" Text="UpDate Partners" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" Text="Submit" /></div>
                      <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
                     </td>
                 </tr>
                 <tr>
                     <td colspan="7">&nbsp;</td>
                 </tr>
              </tbody>
            </table>
         </div>
    </div>
  </form>
</asp:Content>