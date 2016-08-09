Imports System.ComponentModel
Imports System.Drawing
Imports Telerik.Reporting
Imports Telerik.Reporting.Drawing

Partial Class srptParts
    
    'NOTE: The following procedure is required by the telerik Reporting Designer
    'It can be modified using the telerik Reporting Designer.  
    'Do not modify it using the code editor.
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(srptParts))
        Dim StyleRule1 As Telerik.Reporting.Drawing.StyleRule = New Telerik.Reporting.Drawing.StyleRule
        Dim StyleRule2 As Telerik.Reporting.Drawing.StyleRule = New Telerik.Reporting.Drawing.StyleRule
        Dim StyleRule3 As Telerik.Reporting.Drawing.StyleRule = New Telerik.Reporting.Drawing.StyleRule
        Dim StyleRule4 As Telerik.Reporting.Drawing.StyleRule = New Telerik.Reporting.Drawing.StyleRule
        Me.reportHeader = New Telerik.Reporting.ReportHeaderSection
        Me.codeCaptionTextBox1 = New Telerik.Reporting.TextBox
        Me.componentCaptionTextBox1 = New Telerik.Reporting.TextBox
        Me.qtyCaptionTextBox1 = New Telerik.Reporting.TextBox
        Me.partAmountCaptionTextBox1 = New Telerik.Reporting.TextBox
        Me.taxCaptionTextBox1 = New Telerik.Reporting.TextBox
        Me.shippingCaptionTextBox1 = New Telerik.Reporting.TextBox
        Me.TextBox1 = New Telerik.Reporting.TextBox
        Me.TextBox3 = New Telerik.Reporting.TextBox
        Me.detail = New Telerik.Reporting.DetailSection
        Me.ticketIDDataTextBox = New Telerik.Reporting.TextBox
        Me.codeDataTextBox = New Telerik.Reporting.TextBox
        Me.componentDataTextBox = New Telerik.Reporting.TextBox
        Me.qtyDataTextBox = New Telerik.Reporting.TextBox
        Me.partAmountDataTextBox = New Telerik.Reporting.TextBox
        Me.taxDataTextBox = New Telerik.Reporting.TextBox
        Me.shippingDataTextBox = New Telerik.Reporting.TextBox
        Me.TextBox2 = New Telerik.Reporting.TextBox
        Me.TextBox4 = New Telerik.Reporting.TextBox
        Me.SqlSelectCommand1 = New System.Data.SqlClient.SqlCommand
        Me.SqlConnection1 = New System.Data.SqlClient.SqlConnection
        Me.SqlDataAdapter1 = New System.Data.SqlClient.SqlDataAdapter
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'reportHeader
        '
        Me.reportHeader.Height = New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.reportHeader.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.codeCaptionTextBox1, Me.componentCaptionTextBox1, Me.qtyCaptionTextBox1, Me.partAmountCaptionTextBox1, Me.taxCaptionTextBox1, Me.shippingCaptionTextBox1, Me.TextBox1, Me.TextBox3})
        Me.reportHeader.Name = "reportHeader"
        '
        'codeCaptionTextBox1
        '
        Me.codeCaptionTextBox1.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.40000003576278687, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.codeCaptionTextBox1.Name = "codeCaptionTextBox1"
        Me.codeCaptionTextBox1.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.93333333730697632, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.codeCaptionTextBox1.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.codeCaptionTextBox1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.codeCaptionTextBox1.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.codeCaptionTextBox1.StyleName = "Caption"
        Me.codeCaptionTextBox1.Value = "PartNumber"
        '
        'componentCaptionTextBox1
        '
        Me.componentCaptionTextBox1.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(1.3333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.componentCaptionTextBox1.Name = "componentCaptionTextBox1"
        Me.componentCaptionTextBox1.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.0666667222976685, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.1916700005531311, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.componentCaptionTextBox1.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.componentCaptionTextBox1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.componentCaptionTextBox1.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.componentCaptionTextBox1.StyleName = "Caption"
        Me.componentCaptionTextBox1.Value = "PartDescription"
        '
        'qtyCaptionTextBox1
        '
        Me.qtyCaptionTextBox1.Name = "qtyCaptionTextBox1"
        Me.qtyCaptionTextBox1.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.40000000596046448, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.qtyCaptionTextBox1.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.qtyCaptionTextBox1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.qtyCaptionTextBox1.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.qtyCaptionTextBox1.StyleName = "Caption"
        Me.qtyCaptionTextBox1.Value = "Qty"
        '
        'partAmountCaptionTextBox1
        '
        Me.partAmountCaptionTextBox1.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.8666665554046631, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.partAmountCaptionTextBox1.Name = "partAmountCaptionTextBox1"
        Me.partAmountCaptionTextBox1.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333382606506348, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.partAmountCaptionTextBox1.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.partAmountCaptionTextBox1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.partAmountCaptionTextBox1.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.partAmountCaptionTextBox1.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.partAmountCaptionTextBox1.StyleName = "Caption"
        Me.partAmountCaptionTextBox1.Value = "PartAmount"
        '
        'taxCaptionTextBox1
        '
        Me.taxCaptionTextBox1.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.5999999046325684, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.taxCaptionTextBox1.Name = "taxCaptionTextBox1"
        Me.taxCaptionTextBox1.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.53333336114883423, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.taxCaptionTextBox1.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.taxCaptionTextBox1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.taxCaptionTextBox1.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.taxCaptionTextBox1.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.taxCaptionTextBox1.StyleName = "Caption"
        Me.taxCaptionTextBox1.Value = "Tax"
        '
        'shippingCaptionTextBox1
        '
        Me.shippingCaptionTextBox1.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.1333332061767578, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.shippingCaptionTextBox1.Name = "shippingCaptionTextBox1"
        Me.shippingCaptionTextBox1.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.60000002384185791, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.shippingCaptionTextBox1.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.shippingCaptionTextBox1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.shippingCaptionTextBox1.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.shippingCaptionTextBox1.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.shippingCaptionTextBox1.StyleName = "Caption"
        Me.shippingCaptionTextBox1.Value = "Shipping"
        '
        'TextBox1
        '
        Me.TextBox1.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.7333331108093262, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.66666716337203979, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox1.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.TextBox1.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox1.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox1.StyleName = "Caption"
        Me.TextBox1.Value = "Total"
        '
        'TextBox3
        '
        Me.TextBox3.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.4000000953674316, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox3.Name = "TextBox3"
        Me.TextBox3.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.1916700005531311, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox3.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox3.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.TextBox3.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox3.StyleName = "Caption"
        Me.TextBox3.Value = "Airbill"
        '
        'detail
        '
        Me.detail.Height = New Telerik.Reporting.Drawing.Unit(0.22499999403953552, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.detail.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.ticketIDDataTextBox, Me.codeDataTextBox, Me.componentDataTextBox, Me.qtyDataTextBox, Me.partAmountDataTextBox, Me.taxDataTextBox, Me.shippingDataTextBox, Me.TextBox2, Me.TextBox4})
        Me.detail.Name = "detail"
        '
        'ticketIDDataTextBox
        '
        Me.ticketIDDataTextBox.Name = "ticketIDDataTextBox"
        Me.ticketIDDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.3333333432674408, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.ticketIDDataTextBox.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.ticketIDDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.ticketIDDataTextBox.StyleName = "Data"
        Me.ticketIDDataTextBox.TextWrap = False
        Me.ticketIDDataTextBox.Value = "=Fields.TicketID"
        Me.ticketIDDataTextBox.Visible = False
        '
        'codeDataTextBox
        '
        Me.codeDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.40000000596046448, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.codeDataTextBox.Name = "codeDataTextBox"
        Me.codeDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.93333333730697632, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.codeDataTextBox.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.codeDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.codeDataTextBox.StyleName = "Data"
        Me.codeDataTextBox.Value = "=Fields.Code"
        '
        'componentDataTextBox
        '
        Me.componentDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(1.3333333730697632, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.componentDataTextBox.Name = "componentDataTextBox"
        Me.componentDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.0666667222976685, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.componentDataTextBox.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.componentDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.componentDataTextBox.StyleName = "Data"
        Me.componentDataTextBox.Value = "=Fields.Component"
        '
        'qtyDataTextBox
        '
        Me.qtyDataTextBox.Name = "qtyDataTextBox"
        Me.qtyDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.40000000596046448, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.qtyDataTextBox.StyleName = "Data"
        Me.qtyDataTextBox.Value = "=Fields.Qty"
        '
        'partAmountDataTextBox
        '
        Me.partAmountDataTextBox.Format = "{0:C2}"
        Me.partAmountDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.8666665554046631, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.partAmountDataTextBox.Name = "partAmountDataTextBox"
        Me.partAmountDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.7333330512046814, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.partAmountDataTextBox.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.partAmountDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.partAmountDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.partAmountDataTextBox.StyleName = "Data"
        Me.partAmountDataTextBox.Value = "=Fields.TotalPartAmount"
        '
        'taxDataTextBox
        '
        Me.taxDataTextBox.Format = "{0:C2}"
        Me.taxDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.5999999046325684, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.taxDataTextBox.Name = "taxDataTextBox"
        Me.taxDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.53333336114883423, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.taxDataTextBox.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.taxDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.taxDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.taxDataTextBox.StyleName = "Data"
        Me.taxDataTextBox.Value = "=Fields.Tax"
        '
        'shippingDataTextBox
        '
        Me.shippingDataTextBox.Format = "{0:C2}"
        Me.shippingDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.133333683013916, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.shippingDataTextBox.Name = "shippingDataTextBox"
        Me.shippingDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.60000002384185791, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.shippingDataTextBox.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.shippingDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.shippingDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.shippingDataTextBox.StyleName = "Data"
        Me.shippingDataTextBox.Value = "=Fields.Shipping"
        '
        'TextBox2
        '
        Me.TextBox2.Format = "{0:C2}"
        Me.TextBox2.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.7333331108093262, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox2.Name = "TextBox2"
        Me.TextBox2.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.66666668653488159, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox2.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.TextBox2.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox2.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox2.StyleName = "Data"
        Me.TextBox2.Value = "=Fields.Total"
        '
        'TextBox4
        '
        Me.TextBox4.Format = "{0:C2}"
        Me.TextBox4.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.4000000953674316, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox4.Name = "TextBox4"
        Me.TextBox4.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox4.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.TextBox4.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox4.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Left
        Me.TextBox4.StyleName = "Data"
        Me.TextBox4.Value = "=Fields.ShippingLabel"
        '
        'SqlSelectCommand1
        '
        Me.SqlSelectCommand1.CommandText = resources.GetString("SqlSelectCommand1.CommandText")
        Me.SqlSelectCommand1.Connection = Me.SqlConnection1
        '
        'SqlConnection1
        '
        Me.SqlConnection1.ConnectionString = "Network=DBMSSOCN;Data Source=10.200.101.3;Initial Catalog=Bridges;Persist Securit" & _
            "y Info=True;User ID=sa;Password=nan4218"
        Me.SqlConnection1.FireInfoMessageEventOnUserErrors = False
        '
        'SqlDataAdapter1
        '
        Me.SqlDataAdapter1.SelectCommand = Me.SqlSelectCommand1
        Me.SqlDataAdapter1.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "tblTicketComponents", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("TicketComponentID", "TicketComponentID"), New System.Data.Common.DataColumnMapping("CreatedBy", "CreatedBy"), New System.Data.Common.DataColumnMapping("TicketID", "TicketID"), New System.Data.Common.DataColumnMapping("WorkOrderID", "WorkOrderID"), New System.Data.Common.DataColumnMapping("Consumable", "Consumable"), New System.Data.Common.DataColumnMapping("Code", "Code"), New System.Data.Common.DataColumnMapping("Component", "Component"), New System.Data.Common.DataColumnMapping("SerialNumber", "SerialNumber"), New System.Data.Common.DataColumnMapping("Notes", "Notes"), New System.Data.Common.DataColumnMapping("DateDelivered", "DateDelivered"), New System.Data.Common.DataColumnMapping("DateCreated", "DateCreated"), New System.Data.Common.DataColumnMapping("Qty", "Qty"), New System.Data.Common.DataColumnMapping("PartAmount", "PartAmount"), New System.Data.Common.DataColumnMapping("Tax", "Tax"), New System.Data.Common.DataColumnMapping("Shipping", "Shipping"), New System.Data.Common.DataColumnMapping("DateOrdered", "DateOrdered"), New System.Data.Common.DataColumnMapping("SuppliedBy", "SuppliedBy"), New System.Data.Common.DataColumnMapping("Markup", "Markup"), New System.Data.Common.DataColumnMapping("BillCustomer", "BillCustomer"), New System.Data.Common.DataColumnMapping("BillShipping", "BillShipping"), New System.Data.Common.DataColumnMapping("BillTaxes", "BillTaxes"), New System.Data.Common.DataColumnMapping("NeedReturned", "NeedReturned"), New System.Data.Common.DataColumnMapping("RMA", "RMA")})})
        '
        'srptParts
        '
        Me.DataSource = Me.SqlDataAdapter1
        Me.Filters.AddRange(New Telerik.Reporting.Data.Filter() {New Telerik.Reporting.Data.Filter("=Fields.TicketID", CType(Telerik.Reporting.Data.FilterOperator.Equal, Telerik.Reporting.Data.FilterOperator), "=Parameters.TicketID")})
        Me.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.reportHeader, Me.detail})
        Me.PageSettings.Landscape = False
        Me.PageSettings.Margins.Bottom = New Telerik.Reporting.Drawing.Unit(0.20999999344348907, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Left = New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Right = New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Top = New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.PaperKind = System.Drawing.Printing.PaperKind.Letter
        Me.ReportParameters.Add(New Telerik.Reporting.ReportParameter("TicketID", Telerik.Reporting.ReportParameterType.[String], "0"))
        Me.Style.BackgroundColor = System.Drawing.Color.White
        StyleRule1.Selectors.AddRange(New Telerik.Reporting.Drawing.ISelector() {New Telerik.Reporting.Drawing.StyleSelector("Title")})
        StyleRule1.Style.Color = System.Drawing.Color.Black
        StyleRule1.Style.Font.Name = "Tahoma"
        StyleRule1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(20, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        StyleRule1.Style.Font.Style = System.Drawing.FontStyle.Bold
        StyleRule2.Selectors.AddRange(New Telerik.Reporting.Drawing.ISelector() {New Telerik.Reporting.Drawing.StyleSelector("Caption")})
        StyleRule2.Style.Color = System.Drawing.Color.Black
        StyleRule2.Style.Font.Name = "Tahoma"
        StyleRule2.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(11, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        StyleRule2.Style.Font.Style = System.Drawing.FontStyle.Regular
        StyleRule2.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        StyleRule3.Selectors.AddRange(New Telerik.Reporting.Drawing.ISelector() {New Telerik.Reporting.Drawing.StyleSelector("Data")})
        StyleRule3.Style.Font.Name = "Tahoma"
        StyleRule3.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(11, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        StyleRule3.Style.Font.Style = System.Drawing.FontStyle.Regular
        StyleRule3.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        StyleRule4.Selectors.AddRange(New Telerik.Reporting.Drawing.ISelector() {New Telerik.Reporting.Drawing.StyleSelector("PageInfo")})
        StyleRule4.Style.Font.Name = "Tahoma"
        StyleRule4.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(11, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        StyleRule4.Style.Font.Style = System.Drawing.FontStyle.Regular
        StyleRule4.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.StyleSheet.AddRange(New Telerik.Reporting.Drawing.StyleRule() {StyleRule1, StyleRule2, StyleRule3, StyleRule4})
        Me.Width = New Telerik.Reporting.Drawing.Unit(6.4083333015441895, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents reportHeader As Telerik.Reporting.ReportHeaderSection
    Friend WithEvents codeCaptionTextBox1 As Telerik.Reporting.TextBox
    Friend WithEvents componentCaptionTextBox1 As Telerik.Reporting.TextBox
    Friend WithEvents qtyCaptionTextBox1 As Telerik.Reporting.TextBox
    Friend WithEvents partAmountCaptionTextBox1 As Telerik.Reporting.TextBox
    Friend WithEvents taxCaptionTextBox1 As Telerik.Reporting.TextBox
    Friend WithEvents shippingCaptionTextBox1 As Telerik.Reporting.TextBox
    Friend WithEvents detail As Telerik.Reporting.DetailSection
    Friend WithEvents ticketIDDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents codeDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents componentDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents qtyDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents partAmountDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents taxDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents shippingDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents SqlSelectCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlConnection1 As System.Data.SqlClient.SqlConnection
    Friend WithEvents SqlDataAdapter1 As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents TextBox1 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox2 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox3 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox4 As Telerik.Reporting.TextBox
End Class