<%@ Page Language="vb" MasterPageFile="~/masters/resumedialog.master" CodeFile="editrate.aspx.vb"
  Inherits="EditRate" %>

<%@ MasterType VirtualPath="~/masters/resumedialog.master" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmChangePass" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;"
      runat="server">
      <div style="width: 150px; margin-left: auto; margin-right: auto;">
        <div id="divError" runat="server" visible="false" class="errorzone" />
        <div class="label">
          <asp:Label ID="lblRateType" runat="server" /></div>
        <div>
          <asp:TextBox ID="txtRate" runat="server" /></div>
        <div>
          &nbsp;</div>
        <div style="text-align: right">
          <asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button
            ID="btnSubmit" runat="server" Text="Update" OnClick="btnSubmit_Click" /></div>
      </div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>
        &nbsp;</div>
      <div class="successtext">
        Success!</div>
    </div>
    <asp:Label ID="lblReturnUrl" runat="server" Visible="False" />
  </form>
</asp:Content>
