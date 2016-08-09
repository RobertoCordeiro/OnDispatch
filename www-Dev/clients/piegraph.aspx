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
    gph.GraphType = cvGraphing.Graph.GraphTypes.Pie
    Dim r As New Random(255)
    Dim img As System.Drawing.Image
    'Dim x As New Random
    gph.Width = 128
    gph.Height = 128
    Dim l As New cvGraphing.GraphLayer
    Dim d As cvGraphing.GraphLayerDataMember
    l.UseMemberColors = True
    l.ForeColor = Color.FromArgb(128, 138, 148, 249)
    l.ShowCaptions = False
    l.ShowValues = False
    Dim strValues() As String = Request.QueryString("values").ToString.Split("D")
    Dim lst As New System.Collections.Generic.List(Of Long)
    For I As Integer = 0 To strValues.Length - 1
      lst.Add(CType(strValues(I), Long))
    Next
    For Each lng As Long In lst
      x = lng
      d = New cvGraphing.GraphLayerDataMember
      
      d.MemberColor = Color.FromArgb(225, r.Next(255), r.Next(255), r.Next(255))
      d.Caption = x.ToString
      d.Value = x
      l.Members.Add(d)
    Next
    Response.ContentType = "image/png"
    l.ShowCaptions = True
    l.LineStroke = 2
    gph.Layers.Add(l)
    gph.ShowZeroPointReticle = False
    gph.ShowCeilingAndFloor = False
    gph.ShowTickMarks = False
    gph.ShowGrid = False
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