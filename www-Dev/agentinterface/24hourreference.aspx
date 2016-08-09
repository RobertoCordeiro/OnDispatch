<%@ Page Language="vb" masterpagefile="~/masters/agent.master" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = "24 Hour Clock Reference"
      Master.PageTitleText = Master.PageHeaderText
      Master.PageSubHeader = "<a href=""default.aspx"">My Desktop</a> &gt; 24 Hour Clock Reference"
    End If
  End Sub
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <div style="text-align: center">
    <table style="margin-left: auto; margin-right: auto;">
      <tbody>
        <tr class="gridheader">
          <td class="label">24 Hour Clock Time (AM)</td>
          <td class="label">Standard Time (AM)</td>
          <td class="label">24 Hour Clock Time (PM)</td>
          <td class="label">Standard Time (PM)</td>
        </tr>
        <tr>
          <td>00:00</td>
          <td>12:00 AM</td>
          <td>12:00</td>
          <td>12:00 PM (Noon)</td>
        </tr>
        <tr class="altrow">
          <td>01:00</td>
          <td>1:00 AM</td>
          <td>13:00</td>
          <td>1:00 PM</td>
        </tr>
        <tr>
          <td>02:00</td>
          <td>2:00 AM</td>
          <td>14:00</td>
          <td>2:00 PM</td>
        </tr>
        <tr class="altrow">
          <td>03:00</td>
          <td>3:00 AM</td>
          <td>15:00</td>
          <td>3:00 PM</td>
        </tr>
        <tr>
          <td>04:00</td>
          <td>4:00 AM</td>
          <td>16:00</td>
          <td>4:00 PM</td>
        </tr>
        <tr class="altrow">
          <td>05:00</td>
          <td>5:00 AM</td>
          <td>17:00</td>
          <td>5:00 PM</td>
        </tr>
        <tr>
          <td>06:00</td>
          <td>6:00 AM</td>
          <td>18:00</td>
          <td>6:00 PM</td>
        </tr>
        <tr class="altrow">
          <td>07:00</td>
          <td>7:00 AM</td>
          <td>19:00</td>
          <td>7:00 PM</td>
        </tr>
        <tr>
          <td>08:00</td>
          <td>8:00 AM</td>
          <td>20:00</td>
          <td>8:00 PM</td>
        </tr>
        <tr class="altrow">
          <td>09:00</td>
          <td>9:00 AM</td>
          <td>21:00</td>
          <td>9:00 PM</td>
        </tr>
        <tr>
          <td>10:00</td>
          <td>10:00 AM</td>
          <td>22:00</td>
          <td>10:00 PM</td>
        </tr>
        <tr class="altrow">
          <td>11:00</td>
          <td>11:00 AM</td>
          <td>23:00</td>
          <td>11:00 PM</td>
        </tr>               
      </tbody>
    </table>
  </div>
</asp:Content>