<%@ Page Language="VB" CodeFile="default.aspx.vb" Inherits="_default" %>
<%@ Register Src="~/controls/FirstLastName.ascx" TagName="FirstLastName" TagPrefix="cv" %>
<%@ Register Src="~/controls/Address.ascx" TagName="Address" TagPrefix="cv" %>
<%@ Register Src="~/controls/PhoneNumber.ascx" TagName="Phone" TagPrefix="cv" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
  <head runat="server">
    <title>Join</title>
    <link rel="stylesheet" type="text/css"  href="/style.css" />
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <script type="text/javascript"><!--
amazon_ad_tag="bestse06-20"; 
amazon_ad_width="180"; 
amazon_ad_height="150"; 
amazon_color_border="A43907"; 
amazon_color_logo="FFFFFF"; 
amazon_color_link="A43907"; 
amazon_ad_logo="hide"; 
amazon_ad_link_target="new";
amazon_ad_title="Shop Online"; //--></script>
  </head>
  <body>
  <div class="main">
  <div class="blok_header">
    <div class="header">
      <div class="logo"><a href="/index.html"><img src="/images/fulllogo.jpg" width="359" height="99" border="0" alt="logo" /></a></div>
      <div class="menu">
        <ul>
          <li><a href="/index.html"><span>Home </span></a></li>
          <li><a href="/service.html"><span>Services</span></a></li>
          <li><a href="/store.aspx"><span>Shop Online</span></a></li>
          <li><a href="/login.aspx"><span>Log In</span></a></li>
          <li><a href="/contact.aspx"><span> Contact Us</span></a></li>
          <li><a href="/join/default.aspx" class="active"><span> Register </span></a></li>
        </ul>
        <div class="clr"></div>
      </div>
      <div class="clr"></div>
    </div>
    <div class="clr"></div>
  </div>
  <div class="clr"></div>
  <div class="header_text_bg2">
    <div class="header_text2">
      <h2>Registration Form</h2>
      <p>Become a Member by Registering  <br />
        No charges or hidden fees to become a Partner in our Service Network </p>
      <div class="clr"></div>
    </div>
    <div class="clr"></div>
  </div>
  <div class="body_resize">
    <div class="body">
      <div class="left">
         <div class="FBG">
            <form id="frmResume" runat="server">
              <div runat="server" id="divInput">
                <div style="margin-left: 10px;margin-right: auto; width: 600px;">
                  <div id="divError" runat="server" visible="false" />
                  <div style="font-weight:bold;" >Entity Type*</div>
                  <div><asp:DropDownList ID="cbxEntityTypes" runat="server" /></div>
                  <div>Your Company Name</div>
                  <div><asp:TextBox style="width:89%" ID="txtCompanyName" runat="server" /></div>
                  <cv:FirstLastName FirstNameRequired="true" LastNameRequired="true" runat="server" ID="flnContact" />
                  <div style="font-weight: bold; ">Email Address *</div>
                  <div><asp:TextBox style="width: 89%" ID="txtEmail" runat="server" /></div>
                  <div>Web Site (url)</div>
                  <div><asp:TextBox style="width: 89%" ID="txtWebsite" runat="server" /></div>
                  <div ><cv:Address id="addContact" RequireAddressType="true" RequireStreet="true" RequireCity="true" RequireState="true" RequireZip="true" runat="server" /></div>
                  <div><cv:Phone ID="phnPrimary" RequirePhone="true" text="Primary Phone" runat="server" /></div>
                  <div><cv:Phone ID="phnSecondary" Text="Secondary Phone" runat="server" /></div>
                  <div style="font-weight:bold;">Choose your main line of work:</div>
                  <div><asp:DropDownList ID="cbxResumeTypes" runat="server" style="width:90%" /></div>
                  <div style="font-weight:bold; ">Resume/Company Profile *</div>
                  <div><asp:TextBox TextMode="multiLine" style="width: 90%; height: 155px;" ID="txtResume" runat="server" /></div>
                  <div><asp:TextBox TextMode="multiLine" style="width: 90%; height: 64px;" ID="txtMisc" runat="server" visible="false"/></div>
                  <div style="font-weight:bold; ">Best Day(s) to Contact *</div>
                  <div>
                    <asp:CheckBox ID="chkSunday" runat="server" Text="Sun" />
                    <asp:CheckBox ID="chkMonday" runat="server" Text="Mon" />
                    <asp:CheckBox ID="chkTuesday" runat="server" Text="Tue" />
                    <asp:CheckBox ID="chkWednesday" runat="server" Text="Wed" />
                    <asp:CheckBox ID="chkThursday" runat="server" Text="Thr" />
                    <asp:CheckBox ID="chkFriday" runat="server" Text="Fri" />
                    <asp:CheckBox ID="chkSaturday" runat="server" Text="Sat" />
                  </div>
                  <div style="font-weight:bold; ">Between *<asp:DropDownList ID="cbxStart" runat="server" /> and <asp:DropDownList ID="cbxEnd" runat="server" /></div>
                  <div></div>
                  <div style="font-weight: bold; ">How did you hear about us?</div>
                  <div><asp:DropDownList ID="cbxReferrers" runat="server" /></div>
                  <div>Which One?</div>
                  <div><asp:TextBox ID="txtReferrerOther" runat="server" /></div>
                  <div>&nbsp;</div>
                  <div  style="text-align: right; width:90%;" ><asp:button ID="btnSubmit" text="Submit" runat="server" onclick="submitresume" /></div>
                </div>        
              </div>
              <div runat="server" visible="false" id="divResult" class="FBG">
                <div>&nbsp;</div>
                <div style="text-align: center; font-weight: bold;">Information Results</div>
                <div style="text-align: center; font-weight: bold; color:Black"> Your application has been submitted with Success! Thank you.<br /><br /></div>
                <div>&nbsp;</div>
                <div style="margin-left: 16px; margin-right: 16px;">We will review it and contact you so we can go to the next step in the process!<br /><br /></div>
                <div style="margin-left: 16px; margin-right: 16px;">Your Candidate ID Number is: <b><asp:Label ID="lblResumeID" runat="server" /></b>. <br /><br />Please save  this information for your records. If you need to contact us, please provide us your Candidate ID Number.<br /><br />Thank you! Have a great day.</div>
                <div>&nbsp;</div>
              </div>
              <div runat="server" visible="false" id="divDuplicate" class="FBG">
                <div>&nbsp;</div>
                <div style="text-align: center; font-weight: bold;">Information Results</div>
                <div style="text-align: center; font-weight: bold; color:Red">Duplicate Entry!</div>
                <div>&nbsp;</div>
                <div style="margin-left: 16px; margin-right: 16px;">A profile has already been entered with your information. Please call our recruiting department at <b><asp:Label ID="lblPartnerSupportNumber" runat="server" /></b> for further information or to update your profile.<br /><br /></div>
                <div style="margin-left: 16px; margin-right: 16px;">When contacting our Recruting Department please use your Canidate ID: <asp:Label ID="lblPSResumeID" runat="server" />.<br /><br /> Thank you! Have a great day.</div>
                <div>&nbsp;</div>
              </div>      
            </form>
          </div>
         </div> 
        <div class="right">
        <h2>By having your application approved, you will:<br />
        <span></span></h2>
        <ul>
            <li>Sign a Contract with BSA</li>
            <li>Represent us locally in your area</li>
            <li>Be assigned to a Geographic Area</li>
            <li>Become our Exclusive Technician in your area</li>
            <li>Receive all parts for the service repairs</li>
            <li>Have access to manuals online</li>
            <li>Have access to Live Technical Support</li>
            <li>Access to your Work Orders Online</li>
            <li>Receive actual service calls, not leads</li>
            <li>Be part of an Excellent Network of Professionals</li>
            <li>Be Part of Group Training and Seminars</li>
            <li>And much more...</li>
        </ul>
        <div class="clr"></div>
        <script type="text/javascript" src="http://www.assoc-amazon.com/s/asw.js"></script>
        <div class="clr"></div>
        <div><a href="/requestservice.aspx"><img src="/images/needservice1.jpg" alt="Request Service"  /></a></div>
        <div class="clr"></div>
        <h2>Monitoring My Repair<br /><a href="/eu/default.aspx"><img src="/images/tracking.jpg" alt="picture" width="100" height="100" border="0" /></a>
          <span>Monitor all the details of your service online. You will be able to view the history of your service, updates with detailed information of the progress of your service, verify what parts have been ordered for your service, track parts, etc. Go to <a href="/eu/default.aspx">  Monitoring My Repair »</a></span></h2>
        <div class="clr"></div>
      </div>
      <div class="clr"></div>
    </div>
    <div class="clr"></div>
  </div>
</div>
<div class="FBG">
  <div class="FBG_resize">
    <div class="right">
      <h2>Services You Can Count On</h2>
      <p>We work with your business and adapt our system to comply with your requirements all the way through the process of dispatching, managing and completing a service call.
        Our Network of Technicians can improve your customer experience and add value to your warranty on-site service representation.</p>
    </div>
    <div class="left">
      <h2>Features </h2>
      <ul>
        <li>Support Services</li>
        <li>Training</li>
        <li>Depot Repair</li>
        <li>Statewide Coverage</li>
      </ul>
    </div>
    <div class="left">
      <h2>Client Advantages </h2>
      <ul>
        <li>Highly Training Technician</li>
        <li>Improve Customer Experience</li>
        <li>Enhance Brand Loyalty</li>
        <li>Total Accountability</li>
      </ul>
    </div>
    <div class="right">
      <h2>Our Message</h2>
      <p> <img src="/images/test.gif" alt="picture" width="24" height="18" />&quot;To my customer: I may not have the answer, but I'll find it. I may not have the time, but I'll make it. I may not be the biggest, but I'll be the most committed to your success.
        &quot;</p>
    </div>
    <div class="clr"></div>
  </div>
  <div class="clr"></div>
</div>
<div class="footer">
  <div class="footer_resize"><a href="/index.html"><img src="/images/fulllogo.jpg" alt="picture" width="214" height="84" border="0" /></a>
    <p class="leftt">Copyright 2010 © Best Servicers of America. All Rights Reserved<br />
      <a href="/policy.html"><strong>Private Policy</strong></a></p>
    <div class="clr"></div>
  </div>
  <div class="clr"></div>
</div>
</body>
</html>