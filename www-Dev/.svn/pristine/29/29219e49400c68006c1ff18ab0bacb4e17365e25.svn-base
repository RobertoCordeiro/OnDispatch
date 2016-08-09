Imports System.ComponentModel
Imports System.Drawing
Imports Telerik.Reporting
Imports Telerik.Reporting.Drawing

Partial Class Report1
    
    'NOTE: The following procedure is required by the telerik Reporting Designer
    'It can be modified using the telerik Reporting Designer.  
    'Do not modify it using the code editor.
    Private Sub InitializeComponent()
        Dim StyleRule1 As Telerik.Reporting.Drawing.StyleRule = New Telerik.Reporting.Drawing.StyleRule
        Dim StyleRule2 As Telerik.Reporting.Drawing.StyleRule = New Telerik.Reporting.Drawing.StyleRule
        Dim StyleRule3 As Telerik.Reporting.Drawing.StyleRule = New Telerik.Reporting.Drawing.StyleRule
        Dim StyleRule4 As Telerik.Reporting.Drawing.StyleRule = New Telerik.Reporting.Drawing.StyleRule
        Me.companyDataTextBox = New Telerik.Reporting.TextBox
        Me.pageHeader = New Telerik.Reporting.PageHeaderSection
        Me.pageFooter = New Telerik.Reporting.PageFooterSection
        Me.currentTimeTextBox = New Telerik.Reporting.TextBox
        Me.pageInfoTextBox = New Telerik.Reporting.TextBox
        Me.reportHeader = New Telerik.Reporting.ReportHeaderSection
        Me.TextBox5 = New Telerik.Reporting.TextBox
        Me.TextBox6 = New Telerik.Reporting.TextBox
        Me.TextBox3 = New Telerik.Reporting.TextBox
        Me.TextBox4 = New Telerik.Reporting.TextBox
        Me.TextBox2 = New Telerik.Reporting.TextBox
        Me.TextBox7 = New Telerik.Reporting.TextBox
        Me.titleTextBox = New Telerik.Reporting.TextBox
        Me.detail = New Telerik.Reporting.DetailSection
        Me.laborAmountDataTextBox = New Telerik.Reporting.TextBox
        Me.adjustChargeDataTextBox = New Telerik.Reporting.TextBox
        Me.partAmountDataTextBox = New Telerik.Reporting.TextBox
        Me.totalDataTextBox = New Telerik.Reporting.TextBox
        Me.ticketIDDataTextBox = New Telerik.Reporting.TextBox
        Me.statusDataTextBox = New Telerik.Reporting.TextBox
        Me.BridgesDataSet = New Reports.BridgesDataSet
        Me.BridgesDataSetTableAdapter1 = New Reports.BridgesDataSetTableAdapters.BridgesDataSetTableAdapter
        CType(Me.BridgesDataSet, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'companyDataTextBox
        '
        Me.companyDataTextBox.CanGrow = True
        Me.companyDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.6666669845581055, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.companyDataTextBox.Name = "companyDataTextBox"
        Me.companyDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.7714290618896484, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.25833332538604736, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.companyDataTextBox.Style.Color = System.Drawing.Color.Black
        Me.companyDataTextBox.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(10, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.companyDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.companyDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.companyDataTextBox.StyleName = "Data"
        Me.companyDataTextBox.Value = "=Fields.Company"
        '
        'pageHeader
        '
        Me.pageHeader.Height = New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.pageHeader.Name = "pageHeader"
        '
        'pageFooter
        '
        Me.pageFooter.Height = New Telerik.Reporting.Drawing.Unit(0.22499999403953552, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.pageFooter.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.currentTimeTextBox, Me.pageInfoTextBox})
        Me.pageFooter.Name = "pageFooter"
        '
        'currentTimeTextBox
        '
        Me.currentTimeTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.01666666753590107, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.01666666753590107, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.currentTimeTextBox.Name = "currentTimeTextBox"
        Me.currentTimeTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(3.2083332538604736, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.currentTimeTextBox.StyleName = "PageInfo"
        Me.currentTimeTextBox.Value = "=NOW()"
        '
        'pageInfoTextBox
        '
        Me.pageInfoTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.2416665554046631, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.01666666753590107, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.pageInfoTextBox.Name = "pageInfoTextBox"
        Me.pageInfoTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(3.2083332538604736, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.pageInfoTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.pageInfoTextBox.StyleName = "PageInfo"
        Me.pageInfoTextBox.Value = "=PageNumber + ' of ' + PageCount"
        '
        'reportHeader
        '
        Me.reportHeader.Height = New Telerik.Reporting.Drawing.Unit(0.60000002384185791, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.reportHeader.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.TextBox5, Me.TextBox6, Me.TextBox3, Me.TextBox4, Me.TextBox2, Me.TextBox7, Me.titleTextBox, Me.companyDataTextBox})
        Me.reportHeader.Name = "reportHeader"
        '
        'TextBox5
        '
        Me.TextBox5.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.0666670799255371, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.40000003576278687, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox5.Name = "TextBox5"
        Me.TextBox5.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.59999948740005493, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox5.Style.BackgroundColor = System.Drawing.SystemColors.ButtonShadow
        Me.TextBox5.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox5.Value = "Parts"
        '
        'TextBox6
        '
        Me.TextBox6.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.86666673421859741, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.40000003576278687, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox6.Name = "TextBox6"
        Me.TextBox6.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.3333332538604736, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox6.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox6.Style.Color = System.Drawing.Color.Black
        Me.TextBox6.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox6.Value = "Status"
        '
        'TextBox3
        '
        Me.TextBox3.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.2000002861022949, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.40000003576278687, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox3.Name = "TextBox3"
        Me.TextBox3.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.86666667461395264, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox3.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox3.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox3.Value = "Labor Rate"
        '
        'TextBox4
        '
        Me.TextBox4.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.0666670799255371, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.40000003576278687, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox4.Name = "TextBox4"
        Me.TextBox4.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.9999997615814209, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox4.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox4.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox4.Value = "Extra Amount"
        '
        'TextBox2
        '
        Me.TextBox2.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.40000003576278687, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox2.Name = "TextBox2"
        Me.TextBox2.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.86666667461395264, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox2.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox2.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox2.Value = "TicketID"
        '
        'TextBox7
        '
        Me.TextBox7.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.6666669845581055, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.40000003576278687, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox7.Name = "TextBox7"
        Me.TextBox7.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333382606506348, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox7.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox7.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox7.Value = "Total"
        '
        'titleTextBox
        '
        Me.titleTextBox.Name = "titleTextBox"
        Me.titleTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.3333332538604736, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.40000000596046448, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.titleTextBox.StyleName = "Title"
        Me.titleTextBox.Value = "Invoice Report"
        '
        'detail
        '
        Me.detail.Height = New Telerik.Reporting.Drawing.Unit(0.22499999403953552, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.detail.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.laborAmountDataTextBox, Me.adjustChargeDataTextBox, Me.partAmountDataTextBox, Me.totalDataTextBox, Me.ticketIDDataTextBox, Me.statusDataTextBox})
        Me.detail.Name = "detail"
        '
        'laborAmountDataTextBox
        '
        Me.laborAmountDataTextBox.CanGrow = True
        Me.laborAmountDataTextBox.Format = "{0:C2}"
        Me.laborAmountDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.133333683013916, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.laborAmountDataTextBox.Name = "laborAmountDataTextBox"
        Me.laborAmountDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.9047619104385376, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.laborAmountDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.laborAmountDataTextBox.StyleName = "Data"
        Me.laborAmountDataTextBox.Value = "=Fields.LaborAmount"
        '
        'adjustChargeDataTextBox
        '
        Me.adjustChargeDataTextBox.CanGrow = True
        Me.adjustChargeDataTextBox.Format = "{0:C2}"
        Me.adjustChargeDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.0666670799255371, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.adjustChargeDataTextBox.Name = "adjustChargeDataTextBox"
        Me.adjustChargeDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.9047619104385376, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.adjustChargeDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.adjustChargeDataTextBox.StyleName = "Data"
        Me.adjustChargeDataTextBox.Value = "=Fields.AdjustCharge"
        '
        'partAmountDataTextBox
        '
        Me.partAmountDataTextBox.CanGrow = True
        Me.partAmountDataTextBox.Format = "{0:C2}"
        Me.partAmountDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.partAmountDataTextBox.Name = "partAmountDataTextBox"
        Me.partAmountDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.6380952000617981, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.partAmountDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.partAmountDataTextBox.StyleName = "Data"
        Me.partAmountDataTextBox.Value = "=Fields.PartAmount"
        '
        'totalDataTextBox
        '
        Me.totalDataTextBox.CanGrow = True
        Me.totalDataTextBox.Format = "{0:C2}"
        Me.totalDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.6666669845581055, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.totalDataTextBox.Name = "totalDataTextBox"
        Me.totalDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.77142906188964844, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.totalDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.totalDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.totalDataTextBox.StyleName = "Data"
        Me.totalDataTextBox.Value = "=Fields.Total"
        '
        'ticketIDDataTextBox
        '
        Me.ticketIDDataTextBox.CanGrow = True
        Me.ticketIDDataTextBox.Name = "ticketIDDataTextBox"
        Me.ticketIDDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.800000011920929, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.ticketIDDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.ticketIDDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Left
        Me.ticketIDDataTextBox.StyleName = "Data"
        Me.ticketIDDataTextBox.Value = "=Fields.TicketID"
        '
        'statusDataTextBox
        '
        Me.statusDataTextBox.CanGrow = True
        Me.statusDataTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.statusDataTextBox.Name = "statusDataTextBox"
        Me.statusDataTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.3333332538604736, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.statusDataTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.statusDataTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Left
        Me.statusDataTextBox.StyleName = "Data"
        Me.statusDataTextBox.Value = "=Fields.Status"
        '
        'BridgesDataSet
        '
        Me.BridgesDataSet.DataSetName = "BridgesDataSet"
        Me.BridgesDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema
        '
        'BridgesDataSetTableAdapter1
        '
        Me.BridgesDataSetTableAdapter1.ClearBeforeFill = True
        '
        'Report1
        '
        Me.DataSource = Me.BridgesDataSet
        Me.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.pageHeader, Me.pageFooter, Me.reportHeader, Me.detail})
        Me.PageSettings.Landscape = False
        Me.PageSettings.Margins.Bottom = New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Left = New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Right = New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Top = New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.PaperKind = System.Drawing.Printing.PaperKind.Letter
        Me.ReportParameters.Add(New Telerik.Reporting.ReportParameter("TicketID", Telerik.Reporting.ReportParameterType.[String], ""))
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
        Me.Width = New Telerik.Reporting.Drawing.Unit(6.5333333015441895, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        CType(Me.BridgesDataSet, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents companyDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents pageHeader As Telerik.Reporting.PageHeaderSection
    Friend WithEvents pageFooter As Telerik.Reporting.PageFooterSection
    Friend WithEvents currentTimeTextBox As Telerik.Reporting.TextBox
    Friend WithEvents pageInfoTextBox As Telerik.Reporting.TextBox
    Friend WithEvents reportHeader As Telerik.Reporting.ReportHeaderSection
    Friend WithEvents titleTextBox As Telerik.Reporting.TextBox
    Friend WithEvents detail As Telerik.Reporting.DetailSection
    Friend WithEvents ticketIDDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents statusDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents laborAmountDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents adjustChargeDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents partAmountDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents totalDataTextBox As Telerik.Reporting.TextBox
    Friend WithEvents BridgesDataSet As Reports.BridgesDataSet
    Friend WithEvents BridgesDataSetTableAdapter1 As Reports.BridgesDataSetTableAdapters.BridgesDataSetTableAdapter
    Friend WithEvents TextBox2 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox3 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox4 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox5 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox6 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox7 As Telerik.Reporting.TextBox
End Class