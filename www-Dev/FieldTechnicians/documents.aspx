<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Documents"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Documents"  
      master.ActiveMenu = "P"          
    End If
    LoadInformation()
  End Sub
  
  Private Sub LoadInformation()
    Dim par As New BridgesInterface.PartnerAgentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    par.Load(Master.PartnerAgentID)
    Dim ptr As New BridgesInterface.PartnerRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ptr.Load(Master.PartnerID)
    ulAdminDocuments.Visible = par.AdminAgent
    Dim rsm As New BridgesInterface.ResumeRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    rsm.Load(ptr.ResumeID)
    Dim pdr As New BridgesInterface.PartnerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))    
    lnkContract.HRef = "viewfile.aspx?id=" & rsm.BlankContractFileID
    lnkContractSig.HRef = "viewfile.aspx?id=" & rsm.SignedContractFileID
    lblSignatureDate.Text = rsm.ContractSignatureDate
    lnkNDA.HRef = "viewfile.aspx?id=" & rsm.BlankNDAFileID
    lnkNDASig.HRef = "viewfile.aspx?id=" & rsm.SignedNDAFileID
    lblNDASignatureDate.Text = rsm.NDASignatureDate.ToString
    lnkWaiver.HRef = "viewfile.aspx?id=" & rsm.BlankWaiverFileID
    lnkWaiverSig.HRef = "viewfile.aspx?id=" & rsm.SignedWaiverFileID
    lblWaiverSignatureDate.Text = rsm.WaiverSignatureDate.ToString
    If par.SignatureFileID > 0 Then
      lnkEsig.HRef = "viewfile.aspx?id=" & par.SignatureFileID
    End If
    pdr.Load(Master.PartnerID, 1)
    If pdr.PartnerDocumentID > 0 Then
      lnkW9.HRef = "viewfile.aspx?id=" & pdr.FileID
    End If
    pdr = New BridgesInterface.PartnerDocumentRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    pdr.Load(Master.PartnerID, 2)
    If pdr.PartnerDocumentID > 0 Then
      lnkInsurance.HRef = "viewfile.aspx?id=" & pdr.FileID
    End If
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDocuments" runat="server">
    <div class="bandheader">Company Documents</div>
      <ul id="ulAdminDocuments" runat="server">
        <li><a id="lnkContract" runat="server">Contract</a>&nbsp;<a id="lnkContractSig" runat="server">Signature</a>&nbsp;<asp:label ID="lblSignatureDate" runat="server" /></li>
        <li><a id="lnkNDA" runat="server">Confidentiality Agreement</a>&nbsp;<a id="lnkNDASig" runat="server">Signature</a>&nbsp;<asp:Label ID="lblNDASignatureDate" runat="server" /></li>
        <li><a id="lnkWaiver" runat="server">Workmans Comp Waiver</a>&nbsp;<a id="lnkWaiverSig" runat="server">Signature</a>&nbsp;<asp:Label ID="lblWaiverSignatureDate" runat="server" /></li>
        <li><a id="lnkEsig" runat="server">E-Signature</a></li>
        <li><a id="lnkW9" runat="server">W9</a>&nbsp;<a href="upload.aspx?mode=w9&returnurl=documents.aspx">Upload New</a>&nbsp;(<a href="/files/fw9.pdf">Blank W9)</a></li>
        <li><a id="lnkInsurance" runat="server">Proof of Insurance</a>&nbsp;<a href="upload.aspx?mode=li&returnurl=documents.aspx">Upload New</a></li>
      </ul>
 
    
  </form>
</asp:Content>