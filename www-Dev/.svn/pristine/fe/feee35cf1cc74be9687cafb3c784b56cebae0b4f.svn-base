<%@ Page Language="vb" masterpagefile="~/masters/resume.master" CodeFile="detail.aspx.vb" Inherits="Detail" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ Register Src="~/controls/BasicPhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>
<%@ MasterType VirtualPath="~/masters/resume.master" %>
<asp:Content ContentPlaceHolderID="bodycontent" ID="cntBody" runat="server">
  <form id="frmDetail" runat="server">
    <table id="tdResume" runat="server" class="resumeform">
      <tbody>
        <tr>
          <td>
            <div style="text-align: center; font-weight: bold;"><asp:label ID="lblCompanyNameHeader" runat="server" /></div>
            <div style="text-align:center; font-weight: bold;"><asp:Label ID="lblPhoneContact" runat="server" /></div>
            <div>&nbsp;</div>
            <div id="divErrors" class="errorzone" visible="false" runat="server" />            
            <div id="divSaved" class="savednotice" visible="false" runat="server" />
            <div id="divForm" runat="server">
              <p>Welcome to the next step to joining our team! To continue with the hiring process please provide us with the information requested below.</p>
              <div class="resumesectionheader">Web Presence</div>
              <div class="label">Web Site</div>
              <asp:textbox TabIndex="1" ID="txtWebsite" style="width: 99%" runat="server" />          
              <div class="resumesectionheader">Business Start Date</div>  
              <table>
                <tbody>
                  <tr>
                    <td class="label">Month</td>
                    <td class="label">Year</td>
                  </tr>
                  <tr>
                    <td><asp:DropDownList ID="cbxMonths" TabIndex="2" runat="server" /></td>
                    <td><asp:textbox ID="txtYear" MaxLength="4" TabIndex="3" runat="server" /></td>
                  </tr>
                </tbody>
              </table>
              <div class="resumesectionheader">Tax/Identification Information</div>
                <div class="label">Company Name (Should not be the same as first and last name)</div>            
                <asp:TextBox ID="txtCompanyName" runat="server" style="width: 99%" />
                <div class="label">Entity Type</div>
                <div><asp:DropDownList ID="cbxEntityTypes" runat="server" /></div>              
                <table>
                  <tbody>
                    <tr>
                      <td class="label" style="font-style: italic">DL State *</td>
                      <td class="label" style="font-style: italic">Drivers License Number *</td>
                    </tr>
                    <tr>
                      <td><asp:DropDownList TabIndex="4" ID="cbxDLStates" runat="server" /></td>
                      <td><asp:TextBox TabIndex="5" ID="txtDLNumber" runat="server" /></td>
                    </tr>
                    <tr>
                      <td>
                        <div class="label" style="font-style: italic">EIN*</div>
                        <div><asp:TextBox TabIndex="6" ID="txtEIN" MaxLength="9"  runat="server" /></div>
                        <div class="label" style="font-style: italic">SSN*</div>
                        <div><asp:TextBox TabIndex="8" ID="txtSSN" MaxLength="9" runat="server" /></div>
                      </td>
                      <td>
                        <div class="label" style="font-style: italic">Confirm EIN* (No Dashes, Numbers Only)</div>
                        <div><asp:TextBox TabIndex="7" ID="txtConfirmEIN" MaxLength="9" runat="server" />
                          <a href="https://sa2.www4.irs.gov/sa_vign/newFormSS4.do" target="_blank">Don't have an EIN?</a> 
                        </div>
                        <div class="label" style="font-style: italic">Confirm SSN* (No Dashes, Numbers Only)</div>
                        <div><asp:TextBox TabIndex="9" ID="txtConfirmSSN" MaxLength="9" runat="server" /></div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              <div class="resumesectionheader">Addresses and Phone Numbers</div>
              <asp:DataGrid style="width:100%" ID="dgvPhoneNumbers" runat="server" OnItemCommand="btnEditPhone_Click" AutoGenerateColumns="false">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns>
                  <asp:BoundColumn 
                    DataField="ResumePhoneNumberID"
                    HeaderText="ID"
                    Visible="false"
                  />
                  <asp:BoundColumn
                    DataField="PhoneType"
                    HeaderText="Type"
                    ItemStyle-Wrap="false"
                    />                    
                  <asp:TemplateColumn
                    HeaderText="Phone Number"
                    ItemStyle-Wrap="false"
                    >
                    <ItemTemplate>
                      <%# Databinder.eval(Container.DataItem, "CountryCode") %> (<%# Databinder.eval(Container.DataItem, "AreaCode") %>) <%# Databinder.eval(Container.DataItem, "Exchange") %>-<%# Databinder.eval(Container.DataItem, "LineNumber") %>
                    </ItemTemplate>
                  </asp:TemplateColumn>
                  <asp:BoundColumn
                    DataField="Extension"
                    headertext="Extension"
                    />
                  <asp:BoundColumn
                    DataField="Pin"
                    headertext="Pin"
                    />
                  <asp:ButtonColumn 
                    ButtonType="LinkButton" 
                    HeaderText="Command"
                    Text="Edit"
                  />
                </Columns>                
              </asp:DataGrid>
              <div style="text-align:right"><asp:LinkButton ID="btnAddPhoneNumber" runat="server" Text="[Add Phone Number]" OnClick="btnAddPhoneNumber_Click" /></div>
              <br />
              <asp:DataGrid OnItemCommand="btnEditAddress_Click" style="width: 100%" AutoGenerateColumns="false" ID="dgvAddresses" runat="server">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns>
                  <asp:BoundColumn
                    DataField="ResumeAddressID"
                    HeaderText="ID"
                    Visible="False"
                  />
                  <asp:BoundColumn
                    DataField="AddressType"
                    HeaderText="Type"
                    ItemStyle-Wrap="false"
                    />
                  <asp:TemplateColumn
                    HeaderText="Address"
                    >
                    <ItemTemplate>
                      <%# Databinder.eval(Container.DataItem, "Street") %> <%#DataBinder.Eval(Container.DataItem, "Extended")%> 
                    </ItemTemplate>
                  </asp:TemplateColumn>                  
                  <asp:BoundColumn
                    DataField="City"
                    HeaderText="City"
                    />
                  <asp:BoundColumn
                    DataField="StateAbbreviation"
                    HeaderText="State"
                    />
                  <asp:BoundColumn
                    DataField="ZipCode"
                    HeaderText="Zip"
                    />
                  <asp:ButtonColumn 
                    ButtonType="LinkButton" 
                    HeaderText="Command"
                    Text="Edit"
                  />
                </Columns>        
              </asp:DataGrid>
              <div style="text-align:right"><asp:LinkButton ID="btnAddAddress" OnClick="btnAddAddress_Click" Text="[Add Address]" runat="server" /></div>            
              <div class="resumesectionheader">Emergency Contact</div>
              <cv:FirstLastName ID="flnEmergencyContact" LastNameRequired="true" FirstNameRequired="true" runat="server" />
              <cv:Phone ID="phnEmergency" RequirePhone="true" Text="Emergency&nbsp;Phone" runat="server" />
              <div class="resumesectionheader">Rates</div>
              <asp:DataGrid ID="dgvRates" style="width: 100%" OnItemCommand="btnEditRate_Click" runat="server" AutoGenerateColumns="false">
                <HeaderStyle CssClass="gridheader" />
                <AlternatingItemStyle CssClass="altrow" />   
                <Columns>
                  <asp:BoundColumn
                    DataField="ResumeRateID"
                    HeaderText="ID"
                    visible="False"
                  />
                  <asp:BoundColumn
                    DataField="Description"
                    HeaderText="Type"
                    ItemStyle-Wrap="false"
                    />
                  <asp:BoundColumn
                    DataField="Rate"
                    HeaderText="Rate"
                    DataFormatString="{0:C}"
                    />                    
                  <asp:ButtonColumn
                    ButtonType="linkButton"
                    Text="Edit"
                    HeaderText="Command"
                    />
                </Columns>                
              </asp:DataGrid>
  <%--            <div class="resumesectionheader">Availability</div>
              <table cellspacing="0" rules="all" border="1" style="width: 100%">
                <tbody>
                  <tr class="gridheader">
                    <td>Day</td>
                    <td>Times</td>
                    <td>Command</td>
                  </tr>
                  <tr>
                    <td>Sunday</td>
                    <td id="tdSunday" runat="server"></td>
                    <td><a href="edittimeslot.aspx?id=1&returnurl=detail.aspx">Edit</a></td>
                  </tr>
                  <tr class="altrow">
                    <td>Monday</td>
                    <td id="tdMonday" runat="server"></td>
                    <td><a href="edittimeslot.aspx?id=2&returnurl=detail.aspx">Edit</a></td>
                  </tr>
                  <tr>
                    <td>Tuesday</td>
                    <td id="tdTuesday" runat="server"></td>
                    <td><a href="edittimeslot.aspx?id=3&returnurl=detail.aspx">Edit</a></td>
                  </tr>
                  <tr class="altrow">
                    <td>Wednesday</td>
                    <td id="tdWednesday" runat="server"></td>
                    <td><a href="edittimeslot.aspx?id=4&returnurl=detail.aspx">Edit</a></td>
                  </tr>
                  <tr>
                    <td>Thursday</td>
                    <td id="tdThursday" runat="server"></td>
                    <td><a href="edittimeslot.aspx?id=5&returnurl=detail.aspx">Edit</a></td>
                  </tr>
                  <tr class="altrow">
                    <td>Friday</td>
                    <td id="tdFriday" runat="server"></td>
                    <td><a href="edittimeslot.aspx?id=6&returnurl=detail.aspx">Edit</a></td>
                  </tr>
                  <tr>
                    <td>Saturday</td>
                    <td id="tdSaturday" runat="server"></td>
                    <td><a href="edittimeslot.aspx?id=7&returnurl=detail.aspx">Edit</a></td>
                  </tr>                
                </tbody>
              </table>--%>
              <div>&nbsp;</div>
              <div style="text-align: right"><asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" /></div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    <div id="divRedirect" runat="server" visible="false">
      You are now ready for the document phase of the process, please <a href="documents.aspx">Click Here</a> if you are not redirected in 5 seconds
    </div>
  </form>
</asp:Content>