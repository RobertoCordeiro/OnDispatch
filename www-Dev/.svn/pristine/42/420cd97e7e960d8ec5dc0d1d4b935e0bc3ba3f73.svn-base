<%@ Control Language="VB" ClassName="TicketComponent" CodeFile="TicketComponent.ascx.vb" Inherits="controls_TicketComponent" %>

<table>
  <tbody>
    <tr>
      <td class="label">Part SKU</td>
      <td class="label">Component&nbsp;Name</td>
      <td class="label">Serial Number</td>      
    </tr>
    <tr>
      <td><asp:TextBox style="width: 100%" ID="txtCode" runat="server" /></td>
      <td><asp:TextBox style="width: 100%" ID="txtComponent" runat="server" /></td>
      <td style="padding-right: 4px;"><asp:TextBox style="width: 100%" ID="txtSerialNumber" runat="server" /></td>
    </tr>
    <tr>
      <td class="label">Ship&nbsp;To&nbsp;Courier</td>
      <td class="label">Method</td>
      <td class="label">Shipping&nbsp;Label</td>
    </tr>
    <tr>
      <td><asp:DropDownList style="width: 100%" ID="cbxShipCourier" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ShipCourierChanged" /></td>
      <td><asp:DropDownList style="width: 100%" ID="cbxShipMethod" runat="server" /></td>      
      <td style="padding-right: 4px;"><asp:TextBox ID="txtShipLabel" style="width: 100%" runat="server" /></td>
    </tr>
    <tr>
      <td class="label">Return&nbsp;Courier</td>
      <td class="label">Method</td>
      <td class="label">Shipping&nbsp;Label</td>
    </tr>
    <tr>
      <td><asp:DropDownList style="width: 100%" ID="cbxReturnCourier" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ReturnCourierChanged" /></td>
      <td><asp:DropDownList style="width: 100%" ID="cbxReturnMethod" runat="server" /></td>      
      <td style="padding-right: 4px;"><asp:TextBox ID="txtReturnLabel" style="width: 100%" runat="server" /></td>
    </tr>
    <tr>
      <td colspan="3" style="padding-right: 4px;"><asp:TextBox style="width: 100%;" ID="txtNotes" TextMode="multiline" runat="server" /></td>
    </tr>
    <tr>
      <td colspan="3" style="text-align: right;"><asp:CheckBox ID="chkConsumable" Text="Consumable" runat="server" /></td>
    </tr>
  </tbody>
</table>