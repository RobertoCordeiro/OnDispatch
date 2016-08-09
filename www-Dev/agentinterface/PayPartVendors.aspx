<%@ Page Language="vb" masterpagefile="~/masters/agent.master" MaintainScrollPositionOnPostback = "True" %>
<%@ MasterType VirtualPath="~/masters/agent.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="headermenucontent" Runat="Server">
 <form id="frmTickets" runat="server" >
    <table style="width: 100%">
      <tbody>
        <tr>
          <td class="band" style="width: 1%">
             first column
          </td>
          <td>
            second column
          </td>
        </tr>
      </tbody>
     </table>
  </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="bodycontent" Runat="Server">
</asp:Content>

