<%@ Page Language="VB" %>


<script runat="server">
  ' A page that logs the authenticated user out of the system.
  ' Completed: 02/06/2007
  ' Author: George H. Slaterpryce
  ' Modifications: None
  
  ''' <summary>
  ''' Runs when page initializes
  ''' </summary>
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    FormsAuthentication.SignOut()
    Response.Redirect("/login.aspx", False)
  End Sub
  
</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head runat="server">
    <title>Log Out</title>
</head>
<body style="text-align: center">
    <br />
    <br />
    <div style="border: solid 1px gainsboro; width:365px; margin-left: auto; margin-right: auto;">
    <br />
    You have been logged out of the system. If you are not redirected to the main page shortly please click <a href="/login.aspx">here</a>.
    <br /><br />
    </div>
  </body>
</html>
