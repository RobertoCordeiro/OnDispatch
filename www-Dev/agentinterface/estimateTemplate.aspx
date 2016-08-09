<%@ Page Language="VB" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
Private _ID As Long = 0
Private _TicketID As Long = 0
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Response.Buffer = True
    If CType(System.Configuration.ConfigurationManager.AppSettings("DownForMaintenance"), Boolean) Then
      Response.Redirect(System.Configuration.ConfigurationManager.AppSettings("MaintenanceUrl"), True)
      Response.Flush()
      Response.End()
    Else
      Dim blnRequireSecure As Boolean = System.Configuration.ConfigurationManager.AppSettings("RequireSecureConnection")
      If blnRequireSecure Then
        If (Request.ServerVariables("HTTPS") = "off") Then
          Dim strRedirect As String = ""
          Dim strQuery As String = ""
          strRedirect = "https://" & Request.ServerVariables("SERVER_NAME")
          strRedirect &= Request.ServerVariables("SCRIPT_NAME")
          strQuery = Request.ServerVariables("QUERY_STRING")
          If strQuery.Trim.Length > 0 Then
            strRedirect &= "?"
            strRedirect &= strQuery
          End If
          Response.Redirect(strRedirect, True)
        End If
      End If
      Try
        _ID = CType(Request.QueryString("id"), Long)
      Catch ex As Exception
        _ID = 0
      End Try
      If _ID > 0 Then
        LoadWorkOrder()
        LoadTicket()
      End If
    End If
  End Sub

  Private Sub LoadWorkOrder()
      Dim wrk As New BridgesInterface.WorkOrderRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim par as New BridgesInterface.PartnerRecord (system.Configuration.configurationmanager.AppSettings ("DBCnn"))
      Dim agt as New BridgesInterface.PartnerAgentRecord (system.Configuration.ConfigurationManager.AppSettings("DBCnn"))
      Dim add as New BridgesInterface.PartnerAddressRecord (system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
      Dim agtadd as New BridgesInterface.PartnerAgentAddressAssignmentRecord(system.Configuration.ConfigurationManager.AppSettings ("DBCnn"))
      Dim strHtml as string

      wrk.Load(_ID)
     _TicketID = wrk.TicketID
      par.Load (wrk.PartnerID)
      agt.Load (wrk.PartnerAgentID)
      
      strHtml = par.CompanyName & chr(10)
      strHtml &= agt.FirstName & " " & agt.LastName & chr(10)
      strHtml &= getagentaddress(wrk.PartnerAgentID) & chr(10)
      strHtml &= "877.369.0399"
      
      address.Text= strHtml
      txtInvoiceNumber.Text = wrk.TicketID & "-" & wrk.WorkOrderID

      

  end sub
  Private Sub LoadTicket()
    Dim tkt As New BridgesInterface.TicketRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    Dim cst As New BridgesInterface.CustomerRecord(tkt.ConnectionString)
    Dim stt As New BridgesInterface.StateRecord(tkt.ConnectionString)

    Dim strHtml as String
    tkt.Load(_TicketID)
    cst.Load(tkt.CustomerID)
    stt.Load(tkt.StateID)
    strHtml = tkt.ContactFirstName & " " & tkt.ContactLastName & chr(10)
    strHtml &= tkt.Street & " "
    If tkt.Extended.Trim.Length > 0 Then
      strHtml &= tkt.Extended 
    End If
    strHtml &= chr(10) & tkt.City & " " & stt.Abbreviation & ", " & tkt.ZipCode
    customerTitle.text = strHtml

 end sub
 Private Function GetAgentAddress(lngPartnerAgentID as Long) as string
        Dim cnn As New System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
        Dim cmd As New System.Data.SqlClient.SqlCommand("spListPartnerAgentAddresses")
        Dim strChangeLog As String
        Dim straddress as string
        strChangeLog = ""
        straddress = ""
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Add("@PartnerAgentID", Data.SqlDbType.Int).Value = lngPartnerAgentID
        
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr1 As System.Data.SqlClient.SqlDataReader = cmd.ExecuteReader
        While dtr1.Read
            if dtr1("AddressTypeID").ToString  = "6" or dtr1("AddressTypeID").ToString  = "2" then
              straddress = dtr1("city").ToString & ", " & dtr1("StateAbbreviation").ToString & " " & dtr1("ZipCode").ToString 
              
            end if
        End While
        return straddress
        cnn.Close()
    End Function

</script>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
<title>Build Estimate</title>
<link rel='stylesheet' type='text/css' href='/stylesheets/style.css' />
<link rel='stylesheet' type='text/css' href='/stylesheets/print.css' media="print" />
<script type='text/javascript' src='/Scripts/jquery-1.3.2.min.js'></script>
<script type='text/javascript' src='/Scripts/example.js'></script>
</head>
<body>
<form runat="server" id="frmEstimate">
<div id="page-wrap">
  <div id="header">
  <asp:label   runat="server">ESTIMATE</asp:label></div>
  <div id="identity">
    <b>Authorized Service Provider:</b>
    <asp:textbox id="address" TextMode="multiline" Rows="4"  Width ="500px" runat="server" ></asp:textbox>
    <div id="logo">
       <div id="logoctr">
          <a href="javascript:;" id="change-logo" title="Change logo">Change Logo</a>
          <a href="javascript:;" id="save-logo" title="Save changes">Save</a>
          <a href="javascript:;" id="delete-logo" title="Delete logo">Delete Logo</a>
          <a href="javascript:;" id="cancel-logo" title="Cancel changes">Cancel</a>
       </div>
       <div id="logohelp">
          <input id="imageloc" type="text" size="50" value="" /><br />(max width: 540px, max height: 100px)
       </div>
       <img id="image" src="/images/logowhitesmaller.png" alt="logo" />
     </div>
    </div>
    <div style="clear:both"></div>
    <div id="customer">
     <b>To Customer: </b><br />
       <asp:textbox TextMode="multiline" Rows="4"  Width ="500px" id="customertitle" runat="server"></asp:textbox>
       <table id="meta">
          <tr>
             <td class="meta-head">Estimate #</td>
             <td><asp:textbox textmode="multiLine" Rows="1" runat="server" ID="txtInvoiceNumber"></asp:textbox></td>
          </tr>
          <tr>
             <td class="meta-head">Date</td>
             <td><asp:textbox TextMode="multiLine" Rows="1" runat="server" id="date">December 15, 2009</asp:textbox></td>
          </tr>
          <tr>
             <td class="meta-head">Amount Due</td>
             <td><div class="due"></div></td>
          </tr>
        </table>
     </div>
     <table id="items">
        <tr>
          <th>Item</th>
          <th>Description</th>
          <th>Unit Cost</th>
          <th>Quantity</th>
          <th>Price</th>
        </tr>
        <tr class="item-row">
          <td class="item-name">
             <div class="delete-wpr"><asp:textbox TextMode="multiLine" Rows="1" runat="server" ></asp:textbox>
             <a class="delete" href="javascript:;" title="Remove row">X</a>
             </div>
          </td>
          <td class="description">
             <asp:textbox runat="server" TextMode="MultiLine" Rows="2" CssClass="description"></asp:textbox>
          </td>
          <td >
             <asp:textbox TextMode="multiLine" Rows="1" runat="server" CssClass="cost" >$</asp:textbox>
          </td>
          <td >
             <asp:textbox TextMode="multiLine" Rows="1" runat="server" CssClass="qty" ></asp:textbox>
          </td>
          <td>
             <span class="price">$</span>
          </td>
        </tr>
        <tr class="item-row">
           <td class="item-name">
              <div class="delete-wpr">
                 <asp:textbox TextMode="multiLine" Rows="1" runat="server"></asp:textbox>
                 <a class="delete" href="javascript:;" title="Remove row">X</a>
              </div>
           </td>
           <td class="description">
               <asp:textbox runat="server" TextMode="multiLine" Rows="2" CssClass="description"></asp:textbox>
           </td>
           <td>
               <asp:textbox TextMode="multiLine" Rows="1" runat="server"  CssClass ="cost">$</asp:textbox>
           </td>
           <td>
               <asp:textbox TextMode="multiLine" Rows="1" runat="server" CssClass ="qty" ></asp:textbox>
           </td>
           <td> 
               <span class="price">$</span>
           </td>
        </tr>
        <tr class="item-row">
           <td class="item-name">
              <div class="delete-wpr">
                 <asp:textbox TextMode="multiLine" Rows="1" runat="server"></asp:textbox>
                 <a class="delete" href="javascript:;" title="Remove row">X</a>
              </div>
           </td>
           <td class="description">
               <asp:textbox runat="server" TextMode="multiLine" Rows="2" CssClass="description"></asp:textbox>
           </td>
           <td>
               <asp:textbox TextMode="multiLine" Rows="1" runat="server"  CssClass ="cost">$</asp:textbox>
           </td>
           <td>
               <asp:textbox TextMode="multiLine" Rows="1" runat="server" CssClass ="qty" ></asp:textbox>
           </td>
           <td> 
               <span class="price">$</span>
           </td>
        </tr>
        <tr id="hiderow">
           <td colspan="5">
              <a id="addrow" href="javascript:;" title="Add a row">Add a row</a>
           </td>
        </tr>
        <tr>
           <td colspan="2" class="diagnosis">Diagnose Results</td>
           <td colspan="2" class="total-line">Subtotal</td>
           <td class="total-value">
              <div id="subtotal">$</div>
           </td>
        </tr>
        <tr>
           <td colspan="2" class="notes"><asp:textbox TextMode="multiLine" Rows="1" runat="server" ></asp:textbox></td>
           <td colspan="2" class="total-line">Total</td>
           <td class="total-value">
              <div id="total">$</div>
           </td>
        </tr>
        <tr >
           <td colspan="2" class="notes"><asp:textbox TextMode="multiLine" Rows="1" runat="server" ></asp:textbox></td>
           <td colspan="2" class="total-line">Diagnose Fee</td>
           <td class="total-value">
              <asp:textbox TextMode="multiLine" Rows="1" runat="server" id="fee">$ 50.00</asp:textbox></td>
        </tr>
        <tr>
           <td colspan="2" class="notes"><asp:textbox TextMode="multiLine" Rows="1" runat="server" ></asp:textbox> </td>
           <td colspan="2" class="total-line">Down Payment</td>
           <td class="total-value">
              <asp:textbox TextMode="multiLine" Rows="1" runat="server" id="paid">$</asp:textbox></td>
        </tr>
        <tr>
           <td colspan="2" class="notes"><asp:textbox TextMode="multiLine" Rows="1" runat="server" ></asp:textbox> </td>
           <td colspan="2" class="total-line balance">Balance Due</td>
           <td class="total-value balance">
              <div class="due">$</div>
           </td>
        </tr>
      </table>
      <div id="terms">
         <h5>Remarks</h5>
             <asp:textbox runat="server" TextMode="multiLine" Rows="2">PAYMENT TERMS: 50% deposit required to start work. Balance 50% on completion.
VALIDITY: 7 days from the date of this quote.</asp:textbox>
      </div>
      <div id="signature">
        <asp:textbox runat="server" TextMode="multiLine" Rows="2">We trust that you will find our estimate satisfactory and look forward to working with you. Please contact us should you have any questions at all.</asp:textbox>
        <div>&nbsp;</div>
        <div>
           <h3></h3>
           <asp:textbox runat="server" TextMode="multiLine" Rows="1">To accept, please sign.</asp:textbox>
        </div>
      </div>
    </div>
    </form>
  </body>
</html>