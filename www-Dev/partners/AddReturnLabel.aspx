<%@ Page Language="vb" masterpagefile="~/masters/partnerdialog.master" %>
<%@ MasterType VirtualPath="~/masters/partnerdialog.master" %>
<script runat="server">  
  
    Private _ID As Long = 0
    Private _TicketID As Long = 0
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
            Master.PageHeaderText = " Add DUD Return Label"
            Master.PageTitleText = " Core Return Label"
    End If
    
    Try
            _TicketID = CType(Request.QueryString("Ticketid"), Long)
    Catch ex As Exception
      _TicketID = 0
    End Try
    Try
            _ID = CType(Request.QueryString("id"), Long)
    Catch ex As Exception
            _ID = 0
    End Try
    
    lblReturnUrl.Text = Request.QueryString("returnurl")
    
    if not IsPostBack then
            LoadCouriers()
    end if
  End Sub
  
  Private Sub btnCancel_Click(ByVal S As Object, ByVal E As EventArgs)
    Response.Redirect(lblReturnUrl.Text)
  End Sub

    Private Sub btnAdd_Click(ByVal S As Object, ByVal E As EventArgs)
        Dim lng As Long = 0
        If IsComplete() Then
            If CountDUDLabel() = 0 Then
                AddShippingLabel()
                Response.Redirect(lblReturnUrl.Text, True)
                
            Else
                Dim intShippingLabelID As Integer
                intShippingLabelID = 0
                intShippingLabelID = GetShippingLabelID()
                
                If intShippingLabelID <> 0 Then
                    'UpdateShippingLabelInfo(intShippingLabelID, GetCourierMethodID(drpCouriers.SelectedValue), txtReturnLabel.Text)
                End If
                Response.Redirect(lblReturnUrl.Text, True)
                
            End If
            
        Else
            divErrors.Visible = True
        End If
    End Sub
  
    Private Function CountDUDLabel() As Integer
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spCountDUDLabelsPerTicketComponentID")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketComponentID", System.Data.SqlDbType.Int).Value = _ID
        Dim intCount As Integer
        intCount = 0
        cnn.Open()
        cmd.Connection = cnn
        intCount = cmd.ExecuteScalar()
        cnn.Close()
        CountDUDLabel = intCount
        
    End Function
   
    Private Sub AddShippingLabel()
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spAddShippingLabel")

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CreatedBy", System.Data.SqlDbType.Int).Value = 6
        cmd.Parameters.Add("@TicketComponentID", System.Data.SqlDbType.Int).Value = _ID
        cmd.Parameters.Add("@CourierMethodID", System.Data.SqlDbType.Int).Value = GetCourierMethodID(drpCouriers.SelectedValue)
        cmd.Parameters.Add("@ShippingLabel", System.Data.SqlDbType.VarChar, 128).Value = txtReturnLabel.Text
        cmd.Parameters.Add("@ShippingDestinationID", System.Data.SqlDbType.Int).Value = 4
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
        
    End Sub
    
    Private Function GetShippingLabelID() As Integer
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetShippingLabelByTicketComponentIDAndDestinationID")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@TicketComponentID", System.Data.SqlDbType.Int).Value = _ID
        cmd.Parameters.Add("@ShippingDestinationID", System.Data.SqlDbType.Int).Value = 4
        Dim intCount As Integer
        intCount = 0
        cnn.Open()
        cmd.Connection = cnn
        intCount = cmd.ExecuteScalar()
        cnn.Close()
        GetShippingLabelID = intCount
        
    End Function
    
    Private Function GetCourierMethodID(ByVal intCourierID As Integer) As Integer
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spGetCourierMethodIDByCourier")
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@CourierID", System.Data.SqlDbType.Int).Value = intCourierID
        
        Dim intCount As Integer
        intCount = 0
        cnn.Open()
        cmd.Connection = cnn
        intCount = cmd.ExecuteScalar()
        cnn.Close()
        GetCourierMethodID = intCount
        
    End Function
    
    Private Sub UpdateShippingLabelInfo(ByVal intShippingLabelID As Integer, ByVal intCourierMethodID As Integer, ByVal strShippingLabel As String)
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spUpdateShippingLabelInfo")

        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@ShippingLabelID", System.Data.SqlDbType.Int).Value = intShippingLabelID
        cmd.Parameters.Add("@CourierMethodID", System.Data.SqlDbType.Int).Value = intCourierMethodID
        cmd.Parameters.Add("@ShippingLabel", System.Data.SqlDbType.VarChar, 128).Value = strShippingLabel
        cnn.Open()
        cmd.Connection = cnn
        cmd.ExecuteScalar()
        cnn.Close()
        
    End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
   
        If drpCouriers.SelectedValue = "Choose One" Then
            blnReturn = False
            strErrors &= "<li> You MUST choose a Courier before you can save the DUD Return Label.</li>"
        End If
        If txtReturnLabel.Text = "" Or Len(txtReturnLabel.Text) = 0 Then
            blnReturn = False
            strErrors &= "<li> You MUST enter the DUD return tracking Number to be saved or updated.</li>"
        End If
    
        divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
        Return blnReturn
    End Function
  
    Private Sub LoadCouriers()
        Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        ldr.LoadSimpleDropDownList("spListCouriers", "Courier", "CourierID", drpCouriers)
        drpCouriers.Items.Add("Choose One")
        drpCouriers.SelectedValue = "Choose One"
    End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">

  <form id="frmDialog" runat="server" >
  <table>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td>
         <div class="errorzone" runat="server" id="divErrors" visible="false" />
         <div>&nbsp;</div>
         <div><b>Choose Courier:</b></div>
         <asp:DropDownList ID="drpCouriers" runat="server" AutoPostBack = "false" />
         <div>&nbsp;</div>
         <div> <b>Enter Return Tracking Number provided inside of the box:</b></div>
         <asp:TextBox  ID="txtReturnLabel" runat="server" Width ="100%" />
         <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
         <div>&nbsp;</div> 
         <div><b>***IMPORTANT ***</b></div> 
         <div>&nbsp;</div> 
         <div><b>1. Attention: This page should only be used to add/update DUD Return Label information.</b></div> 
         <div>2. In Case the DUD Return Label is missing in the box, enter the word <u><b>MISSING</b></u> in the tracking label field. We will request a label for you.</div> 
         <div>3. <u><b>Do not use the DUD label to return RA parts</b></u>. Unused, damaged or wrong parts received need to be returned with an Return Authorization Label.<br /> We will provide you one.</div> 
         <div>4. We usually have <u><b>90 days from the date we ordered the part</b></u> to have the Core Part returned. Please ship it back as soon as possible, don't wait until <br />last minute to do so.</div>
         <div>5. Not returning a Core part within the correct time frame will allow the manufacturer to <u></ul><b> charge you 30% of the value of the part </b></u> as a non-returning fee.</div> 
         <div>&nbsp;</div><asp:Button OnClick="btnAdd_Click" ID="btnAdd" Text="Add DUD Label" runat="server"/>&nbsp;&nbsp;<asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" />
          <div>&nbsp;</div>
       </td>
       <td>&nbsp;</td>
      </tr>
   </table>
  </form>
</asp:Content>