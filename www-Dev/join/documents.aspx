<%@ Page Language="vb" MasterPageFile="~/masters/resume.master" CodeFile="documents.aspx.vb"
  Inherits="Documents" %>

<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ Register Src="~/controls/BasicPhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<%@ MasterType VirtualPath="~/masters/resume.master" %>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDocuments" runat="server">
    <div class="resumeform" style="padding-left: 16px; padding-right: 16px;">
      <div style="text-align: center; font-weight: bold;">
        <asp:Label ID="lblCompanyNameHeader" runat="server" /></div>
      <div style="text-align: center; font-weight: bold;">
        <asp:Label ID="lblPhoneContact" runat="server" /></div>
      <div>
        &nbsp;</div>
      <div>
        &nbsp;&nbsp;Welcome to the document stage of the hiring process, please download
        the documents provided below. Once you have downloaded please...</div>
      <div>
        &nbsp;&nbsp;&nbsp;1. Read them</div>
      <div>
        &nbsp;&nbsp;&nbsp;2. Sign the Electronic Signature Authorization Form</div>
      <div>
        &nbsp;&nbsp;&nbsp;3. Upload the signed Signature Authorization Form</div>
      <div>
        &nbsp;&nbsp;&nbsp;4. Upload a scanned image of your drivers license.</div>
      <div>
        &nbsp;&nbsp;&nbsp;5. Indicate your acceptance of the documents and electronicly
        sign them by entering the confirmation code in the appropriate boxes.</div>
      <div>
        If you need help you may either review our <a target="_blank" href="viewfaq.aspx?id=4">
          FAQ</a> or contact Partner Support.</div>
      <div>
        &nbsp;</div>
      <div style="font-style: italic">
        Please note that the image types that we accept for the uploaded documents are Gif,
        Tiff, Jpg, Png or PDF.</div>
      <div class="resumesectionheader">
        Documents</div>
      <div class="errorzone" id="divErrors" runat="server" visible="false" />
      <table style="width: 100%">
        <tbody>
          <tr>
            <td>
              <a id="lnkESig" runat="server">Electronic Signature Authorization (tiff)</a></td>
            <td>
              <asp:Label ID="lblESig" runat="server" /></td>
            <td style="text-align: right;">
              <asp:FileUpload ID="fupEsig" runat="server" /><asp:Button OnClick="btnUploadEsig_Click"
                ID="btnUploadEsig" Text="Upload" runat="server" /></td>
          </tr>
          <tr>
            <td>
              Drivers License</td>
            <td>
              <asp:Label ID="lblDL" runat="server" /></td>
            <td style="text-align: right;">
              <asp:FileUpload ID="fupDL" runat="server" /><asp:Button OnClick="btnUploadDL_Click"
                ID="btnUploadDL" Text="Upload" runat="server" /></td>
          </tr>
          <tr>
            <td>
              <a id="lnkNDA" runat="server">Confidentiality Agreement (tiff)</a></td>
            <td>
              <asp:Label ID="lblUploadedNDA" runat="server" /></td>
            <td style="text-align: right;">
              Confirmation Code:
              <asp:TextBox ID="txtConfirmNDA" runat="server" /></td>
          </tr>
          <tr>
            <td>
              <a id="lnkWaiver" runat="server">Workman's Comp Waiver (tiff)</a></td>
            <td>
              <asp:Label ID="lblUploadedWaiver" runat="server" /></td>
            <td style="text-align: right;">
              Confirmation Code:
              <asp:TextBox ID="txtConfirmWaiver" runat="server" /></td>
          </tr>
          <tr>
            <td>
              <a id="lnkContract" runat="server">Independent Contractor Agreement (tiff)</a></td>
            <td>
              <asp:Label ID="lblUploadedContract" runat="server" /></td>
            <td style="text-align: right;">
              Confirmation Code:
              <asp:TextBox ID="txtConfirmContract" runat="server" /></td>
          </tr>
        </tbody>
      </table>
      <div style="text-align: right;">
        <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Save" /></div>
      <div id="divDone" class="savednotice" visible="false" runat="server" />
      <div>
        &nbsp;</div>
    </div>
  </form>
</asp:Content>
