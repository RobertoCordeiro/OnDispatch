<%@page language="vb" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Drawing2d" %>
<script runat="server">
 
  Private Sub Display(ByVal datStartDate As Date, ByVal datEndDate As Date, ByVal strInterval As String)
    Dim mem As New MemoryStream
    Dim tfm As New cvTrafficMaster.Transactions(System.Configuration.ConfigurationManager.AppSettings("TMCnn"))
    Dim x As Long = 0    
    Dim gph As New cvGraphing.Graph
    Dim r As New Random(255)
    Dim img As System.Drawing.Image
    'Dim x As New Random
    gph.Width = 800
    gph.Height = 600
    Dim l As New cvGraphing.GraphLayer
    Dim d As cvGraphing.GraphLayerDataMember
    l.UseMemberColors = True
    l.ForeColor = Color.FromArgb(128, 138, 148, 249)
    l.ShowCaptions = False
    l.ShowValues = False
    Select Case strInterval.ToLower
      Case "d" 'days
        For I As Integer = 0 To DateDiff(DateInterval.Day, datStartDate, datEndDate)
          x = tfm.GetTransactionCountForDay(datStartDate.AddDays(I))
          d = New cvGraphing.GraphLayerDataMember
          d.MemberColor = Color.FromArgb(128, r.Next(255), r.Next(255), r.Next(255))
          d.Caption = x.ToString
          d.Value = x
          l.Members.Add(d)
        Next
    End Select
    Response.ContentType = "image/png"
    l.ShowCaptions = True
    l.LineStroke = 2    
    gph.Layers.Add(l)
    gph.ShowCeilingAndFloor = True
    gph.ShowGrid = True
    gph.GraphType = cvGraphing.Graph.GraphTypes.Mountain
    img = gph.Image
    img.Save(mem, System.Drawing.Imaging.ImageFormat.Png)    
    mem.WriteTo(Response.OutputStream)
    img.Dispose()
  End Sub
  
  Private Sub Page_Load(ByVal S As Object, ByVal E As EventArgs)
    Dim datStartDate As Date = DateTime.Now.AddDays(-30)
    Dim datEndDate As Date = DateTime.Now
    Display(datStartDate, datEndDate, "d")
  End Sub
</script>