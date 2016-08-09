<%@ Page Language="vb" masterpagefile="~/masters/FieldTechnicians.master" %>
<%@ MasterType VirtualPath="~/masters/FieldTechnicians.master" %>
<script runat="server">

  Private _ID As Long = 0
  
  Private Sub Page_Load(ByVal s As Object, ByVal E As EventArgs)
    If User.Identity.IsAuthenticated Then
      Master.WebLoginID = CType(User.Identity.Name, Long)
      Master.PageHeaderText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Interface"
      Master.PageTitleText = System.Configuration.ConfigurationManager.AppSettings("ShortCompanyName") & " Partner Interface"
      _ID = Master.PartnerAgentID
      If Not IsPostBack Then
        LoadCerts()
      End If
    End If
  End Sub
  
  Private Sub LoadCerts()
    LoadAvailableCertifications()
    LoadExistingCertifications()
  End Sub
  
  Private Sub LoadExistingCertifications()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListPartnerAgentCertifications", "@PartnerAgentID", _ID, dgvCertifications)
    Dim txtExpires As TextBox
    Dim txtCertificationNumber As TextBox
    Dim txtCertificationDate As TextBox
    For Each itm As DataGridItem In dgvCertifications.Items
      txtExpires = itm.FindControl("txtExpires")
      txtCertificationNumber = itm.FindControl("txtCertificationNumber")
      txtCertificationDate = itm.FindControl("txtCertificationDate")
      txtCertificationDate.Text = itm.Cells(2).Text
      txtCertificationNumber.Text = itm.Cells(1).Text
      If itm.Cells(3).Text.ToLower <> "&nbsp;" Then
        txtExpires.Text = itm.Cells(3).Text
      Else
        txtExpires.Text = ""
      End If
    Next
  End Sub
  
  Private Sub LoadAvailableCertifications()
    Dim ldr As New cvCommon.Loaders(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    ldr.LoadSingleLongParameterDataGrid("spListAvailableCertificationsForPartner", "@PartnerAgentID", Master.PartnerAgentID, dgvAvailableCertifications)
  End Sub
  
  Private Sub Save()
    Dim strChangeLog As String = ""
    Dim txtExpires As TextBox
    Dim txtCertificationNumber As TextBox
    Dim txtCertificationDate As TextBox
    Dim pac As New BridgesInterface.PartnerAgentCertificationRecord(System.Configuration.ConfigurationManager.AppSettings("DBCnn"))
    For Each itm As DataGridItem In dgvAvailableCertifications.Items      
      txtExpires = itm.FindControl("txtExpires")
      txtCertificationNumber = itm.FindControl("txtCertificationNumber")
      txtCertificationDate = itm.FindControl("txtCertificationDate")
      If txtExpires.Text.Trim.Length + txtCertificationNumber.Text.Trim.Length + txtExpires.Text.Trim.Length > 0 Then
        pac.Add(CType(itm.Cells(0).Text, Long), Master.UserID, _ID, txtCertificationNumber.Text, txtCertificationDate.Text)
        If txtExpires.Text.Trim.Length > 0 Then
          pac.CertificationExpires = CType(txtExpires.Text, Date)
          pac.Save(strChangeLog)
        End If
      End If
    Next
  End Sub
  
  Private Function IsComplete() As Boolean
    Dim blnReturn As Boolean = True
    Dim strErrors As String = ""
    Dim txtExpires As TextBox
    Dim txtCertificationNumber As TextBox
    Dim txtCertificationDate As TextBox
    Dim dat As Date = DateTime.Now
    For Each itm As DataGridItem In dgvAvailableCertifications.Items
      txtExpires = itm.FindControl("txtExpires")
      txtCertificationNumber = itm.FindControl("txtCertificationNumber")
      txtCertificationDate = itm.FindControl("txtCertificationDate")
      If txtExpires.Text.Trim.Length + txtCertificationNumber.Text.Trim.Length + txtCertificationDate.Text.Trim.Length > 0 Then
        If txtExpires.Text.Trim.Length > 0 Then
          If Not DateTime.TryParse(txtExpires.Text, dat) Then
            blnReturn = False
            strErrors &= "<li>Expiration Date is Invalid for: " & itm.Cells(2).Text
          End If
        End If
        If txtCertificationDate.Text.Trim.Length = 0 Then
          blnReturn = False
          strErrors &= "<li>Certification Date is Required for: " & itm.Cells(2).Text
        Else
          If Not DateTime.TryParse(txtCertificationDate.Text, dat) Then
            blnReturn = False
            strErrors &= "<li>Certification Date is Invalid for: " & itm.Cells(2).Text
          End If
        End If
        If txtCertificationNumber.Text.Trim.Length = 0 Then
          blnReturn = False
          strErrors &= "<li>Certification Number is Required for: " & itm.Cells(2).Text
        End If
      End If
    Next
    divErrors.InnerHtml = "<ul>" & strErrors & "</ul>"
    Return blnReturn
  End Function

  Private Sub btnSave_Click(ByVal S As Object, ByVal E As EventArgs)
    If IsComplete() Then
      divErrors.Visible = False
      Save()
      LoadCerts()
    Else
      divErrors.Visible = True
    End If
  End Sub
  
</script>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmCertificationSurvey" runat="server">
    <div class="bandheader">Available Certifications</div>
    <div class="errorzone" id="divErrors" visible="false" runat="server" />
    <asp:DataGrid ID="dgvAvailableCertifications" style="width: 100%" AutoGenerateColumns="false" runat="server">
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:BoundColumn DataField="certificationid" HeaderText="ID" Visible="false" />
        <asp:BoundColumn DataField="agencyname" HeaderText="Agency" />
        <asp:BoundColumn DataField="certificationname" HeaderText="Certification" />
        <asp:TemplateColumn ItemStyle-Width="1%" HeaderText="Certification Date">
          <ItemTemplate>
            <asp:TextBox ID="txtCertificationDate" runat="server" />
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn ItemStyle-Width="1%" HeaderText="Certification Number">
          <ItemTemplate>
            <asp:TextBox ID="txtCertificationNumber" runat="server" />
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn ItemStyle-Width="1%" HeaderText="Expiration">
          <ItemTemplate>
            <asp:TextBox ID="txtExpires" runat="server" />
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>
    <div>&nbsp;</div>
    <div class="bandheader">Existing Certifications</div>
    <asp:DataGrid ID="dgvCertifications" style="width: 100%" AutoGenerateColumns="false" runat="server">
      <AlternatingItemStyle CssClass="altrow" />
      <HeaderStyle CssClass="gridheader" />
      <Columns>
        <asp:BoundColumn DataField="partneragentcertificationid" HeaderText="ID" Visible="false" />
        <asp:BoundColumn DataField="certificationnumber" Visible="false" />
        <asp:BoundColumn DataField="certificationdate" Visible="false" />
        <asp:BoundColumn DataField="certificationexpires" Visible="false" />
        <asp:BoundColumn DataField="agencyname" HeaderText="Agency" />
        <asp:BoundColumn DataField="certificationname" HeaderText="Certification" />
        <asp:TemplateColumn ItemStyle-Width="1%" HeaderText="Certification Date">
          <ItemTemplate>
            <asp:TextBox ID="txtCertificationDate" runat="server" />
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn ItemStyle-Width="1%" HeaderText="Certification Number">
          <ItemTemplate>
            <asp:TextBox ID="txtCertificationNumber" runat="server" />
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn ItemStyle-Width="1%" HeaderText="Expiration">
          <ItemTemplate>
            <asp:TextBox ID="txtExpires" runat="server" />
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </asp:DataGrid>    
    <div style="text-align: right;"><asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" /></div>
  </form>
</asp:Content>