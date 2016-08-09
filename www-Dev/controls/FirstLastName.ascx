<%@ Control Language="VB" ClassName="FirstLastName" CodeFile="FirstLastName.ascx.vb" Inherits="controls_FirstLastName" %>
<table cellpadding="0" cellspacing="0" style="width: 90%; text-align:left;" id="tblEdit" runat="server">
  <tbody>
    <tr>
      <td runat="server" id="tdFirstName" style="width:35%"><asp:Label ID="lblFirstName" runat="server" /></td>
      <td id="tdMI" runat="server" style="width:15%"><asp:Label ID="lblMI" runat="server" /></td>
      <td id="tdLastName" runat="server" ><asp:Label ID="lblLastName" runat="server" /></td>
    </tr>
    <tr>
      <td style="padding-right: 3px;"><asp:TextBox style="width:100%" ID="txtFirstName" runat="server" /></td>
      <td style="padding-right: 3px;"><asp:TextBox style="width:100%" ID="txtMI" runat="server" /></td>
      <td style="padding-right: 6px;"><asp:TextBox style="width:100%" ID="txtLastName" runat="server" /></td>
    </tr>
  </tbody>
</table>