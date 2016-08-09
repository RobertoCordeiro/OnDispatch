<%@ Page Language="vb" MasterPageFile="~/masters/resumedialog.master" CodeFile="editaddress.aspx.vb"
  Inherits="EditAddress" %>

<%@ MasterType VirtualPath="~/masters/resumedialog.master" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDialog" runat="server">
    <div id="divForm" style="margin-left: 4px; margin-right: 4px; margin-top: 4px; margin-bottom: 4px;"
      runat="server">
      <div id="divError" runat="server" visible="false" class="errorzone" />
      <div>
        <cv:Address ID="addAddress" runat="server" RequireAddressType="true" RequireCity="true"
          RequireState="true" RequireZip="true" RequireStreet="true" />
      </div>
      <asp:CheckBox ID="chkRemove" runat="server" Text="Check Here to Remove This Address" />
      <div>
        &nbsp;</div>
      <div style="text-align: right">
        <asp:Button ID="btnCancel" Text="Cancel" OnClick="btnCancel_Click" runat="server" />&nbsp;<asp:Button
          ID="btnSubmit" runat="server" Text="Update" OnClick="btnSubmit_Click" /></div>
    </div>
    <div id="divResult" visible="false" runat="server">
      <div>
        &nbsp;</div>
      <div class="successtext">
        Success!</div>
    </div>
    <asp:Label ID="lblReturnUrl" Visible="false" runat="server" />
  </form>
</asp:Content>
