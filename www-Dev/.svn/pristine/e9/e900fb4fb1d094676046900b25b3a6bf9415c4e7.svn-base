<%@page language="vb" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Drawing2d" %>
<script runat="server">
 
  Private Sub Display()
    Dim mem As New MemoryStream
    Dim img As System.Drawing.Image = New System.Drawing.Bitmap(1, 1)
    Select Case Request.QueryString("type").ToLower
      Case "128"
        Dim bar As New cvBarCodeEngine.Code128
        bar.Height = CType(Request.QueryString("height"), Integer)
        bar.BarCodeString = Request.QueryString("value")
        img = bar.Render
      Case "39"
        Dim bar As New cvBarCodeEngine.Code39
        bar.Height = CType(Request.QueryString("height"), Integer)
        bar.BarCode = Request.QueryString("value")
        img = bar.Render
      Case "93"
        Dim bar As New cvBarCodeEngine.Code93
        bar.Height = CType(Request.QueryString("height"), Integer)
        bar.BarCodeString = Request.QueryString("value")
        img = bar.Render
      Case "A"
        Dim bar As New cvBarCodeEngine.CodeA
        bar.Height = CType(Request.QueryString("height"), Integer)
        bar.BarCode = Request.QueryString("value")
        img = bar.Render
      Case "upca"
        Dim bar As New cvBarCodeEngine.UPCA
        bar.BarCode = Request.QueryString("value")
        img = bar.Render
      Case "msi"
        Dim bar As New cvBarCodeEngine.CodeMSI
        bar.Height = CType(Request.QueryString("height"), Integer)
        bar.BarCodeString = Request.QueryString("value")
        img = bar.Render
      Case "postnet"
        Dim bar As New cvBarCodeEngine.PostNet
        bar.Height = CType(Request.QueryString("height"), Integer)
        bar.ZipCode = Request.QueryString("value")
        img = bar.Render
    End Select
    img.Save(mem, System.Drawing.Imaging.ImageFormat.Png)
    mem.WriteTo(Response.OutputStream)
    img.Dispose()
  End Sub
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Display()
  End Sub
</script>