<%@ Control Language="VB" ClassName="BasicPhoneNumber" CodeFile="BasicPhoneNumber.ascx.vb" Inherits="controls_BasicPhoneNumber" %>
<table cellpadding="0" cellspacing="0" style="width:1%">
  <tbody>
    <tr>
      <td colspan="5" style="width:1%"><asp:Label ID="lblPhoneNumber" Text="Phone Number" runat="server" /></td>
    </tr>
    <tr>
      <td style="white-space:nowrap">(<asp:TextBox style="width:30px;" maxlength="3" id="txtAreaCode" runat="server" />)</td>
      <td style="width: 4px;">&nbsp;</td>
      <td><asp:TextBox style="width:30px;" maxlength="3" ID="txtExchange" runat="server" /></td>
      <td style="width: 4px;">-</td>
      <td><asp:TextBox style="width:40px;" maxlength="4" ID="txtLineNumber" runat="server" /></td>
      <td style="width: 4px;">&nbsp;</td>
    </tr>    
  </tbody>
</table>
