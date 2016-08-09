<%@ Page Language="vb" masterpagefile="~/masters/agentdialog.master" %>
<%@ MasterType VirtualPath="~/masters/agentdialog.master" %>
<script runat="server"> 
  
  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = " Add Service"
      Master.PageTitleText = " Add Service"
      'Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customers.aspx"">Customers</a> &gt;"
    End If
    Try
      _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
      _ID = 0
    End Try
    lblReturnUrl.Text = Request.QueryString("returnurl")
    If _ID > 0 Then
      Dim stp As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      stp.Load(_ID)
      Dim cus As New BridgesInterface.CustomerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim com As New BridgesInterface.CompanyInfoRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      cus.Load(stp.CustomerID)
      com.Load (cus.InfoID )
      
      If com.CustomerID = stp.CustomerID  then
         Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""mycompany.aspx?id=" & cus.InfoID & """>My Company</a> &gt; <a href=""editservicetype.aspx?id=" & stp.ServiceTypeID & """>Edit Program</a>"
         lblReturnUrl.Text = "editservicetype.aspx?id=" & stp.ServiceTypeID
      else
         Master.PageSubHeader &= "<a href=""default.aspx"">My Desktop</a> &gt; <a href=""customer.aspx?id=" & _ID & """>Customer</a></a>"
         lblReturnUrl.Text = "editservicetype.aspx?id=" & stp.ServiceTypeID
      end if
    
    
      LoadServiceType()
      If Not IsPostBack Then
        LoadPaymentIncrements()      

      End If
    Else
      Response.Redirect(lblReturnUrl.Text, True)
    End If
  End Sub
  
  Private Sub LoadServiceType()
    Dim stp As New BridgesInterface.ServiceTypeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    stp.Load(_ID)
    'Master.PageSubHeader &= " <a href=""customer.aspx?id=" & stp.CustomerID & """>Customer</a> &gt; <a href=""editservicetype.aspx?id=" & stp.ServiceTypeID & """>Service Type</a> &gt; Add Service"
    If lblReturnUrl.Text.Trim.Length = 0 Then
      lblReturnUrl.Text = "editservicetype.aspx?id=" & stp.ServiceTypeID
    End If
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
      strErrors &= "<li>Minimum is Required</li>"
      blnReturn = False
    Else
      If Not long.TryParse(txtMinimum.Text, lng) Then
        strErrors &= "<li>Minimum Must Be A Number</li>"
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
    divErrors.innerhtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnSubmit_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      Dim srv As New BridgesInterface.ServiceRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim strChangeLog As String = ""
      Dim lngServiceID as long
      srv.Add( Master.UserID, _ID,  cbxIncrement.SelectedValue, txtServiceName.Text, txtDescription.Text, txtInstructions.Text, txtFlatRate.Text, txtRate.Text,txtMinimum.Text,txtDefaultPartnerFlatRate.Text,txtDefaultPartnerHourlyRate.Text,txtDefaultPartnerMinTimeOnSite.Text,cbxDefaultPartnerIncrement.SelectedValue )
      lngServiceID = srv.serviceID
      updatePartnerServiceRates(lngServiceID)
      Response.Redirect(lblReturnUrl.Text, True)
      divErrors.Visible = False
    Else
      divErrors.Visible = True
    End If
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub
  
  Private sub UpdatePartnerServiceRates(lngServiceID as long)
   Dim svr as New BridgesInterface.PartnerServiceRateRecord (System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
   Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spListActivePartners")
        Dim lngResumeTypeID as long
        Dim intCount as Integer 
        intCount = 0
        lngResumeTypeID = GetResumeTypeID(lngServiceID)
        cmd.CommandType = Data.CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr.Read
            If not svr.RecordExists(dtr("PartnerID"),lngServiceID) then
              If IsPartnerAssignedToResumeTypeID(dtr("PartnerID"),lngResumeTypeID) then
                 svr.Add(dtr("PartnerID"),lngServiceID,cbxDefaultPartnerIncrement.SelectedValue,txtServiceName.Text,txtDefaultPartnerFlatRate.Text,txtDefaultPartnerHourlyRate.Text,txtDefaultPartnerMinTimeOnSite.Text,True)
              else
                 svr.Add(dtr("PartnerID"),lngServiceID,cbxDefaultPartnerIncrement.SelectedValue,txtServiceName.Text,txtDefaultPartnerFlatRate.Text,txtDefaultPartnerHourlyRate.Text,txtDefaultPartnerMinTimeOnSite.Text,False)
              end if
              intCount = intCount + 1
            end if        
        End While
        cnn.Close()
        PartnerCount.Text = "The new Service has been added to a total of " & intCount & " Partners."
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
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divErrors" class="errorzone" runat="server" visible="false" />
    <div class="label">Service Name</div>
    <asp:textbox ID="txtServiceName" style="width: 99%" runat="server" />
    <div class="label">Description</div>
    <asp:TextBox ID="txtDescription" style="width: 99%; height: 50px;" TextMode="MultiLine" runat="server" />    
    <div class="label">Instructions</div>
    <asp:TextBox ID="txtInstructions" style="width: 99%; height: 100px;" TextMode="MultiLine" runat="server" />
    <div class="bandheader">Pricing</div>
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
    <div>&nbsp;</div>
    <div style="text-align: right;"><asp:Button OnClick="btnCancel_Click" ID="btnCancel" runat="server" Text="Cancel" />&nbsp;<asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" Text="Submit" /></div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
    <asp:Label ID="PartnerCount" runat="server" />
  </form>
</asp:Content>