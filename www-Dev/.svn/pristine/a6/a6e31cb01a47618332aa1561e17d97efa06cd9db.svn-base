Imports System.ComponentModel
Imports System.Drawing
Imports Telerik.Reporting
Imports Telerik.Reporting.Drawing

Partial Class rptVendorInvoices

    'NOTE: The following procedure is required by the telerik Reporting Designer
    'It can be modified using the telerik Reporting Designer.  
    'Do not modify it using the code editor.
    Private Sub InitializeComponent()
        Me.PageHeaderSection1 = New Telerik.Reporting.PageHeaderSection
        Me.DetailSection1 = New Telerik.Reporting.DetailSection
        Me.TextBox1 = New Telerik.Reporting.TextBox
        Me.TextBox14 = New Telerik.Reporting.TextBox
        Me.TextBox15 = New Telerik.Reporting.TextBox
        Me.TextBox16 = New Telerik.Reporting.TextBox
        Me.TextBox17 = New Telerik.Reporting.TextBox
        Me.TextBox18 = New Telerik.Reporting.TextBox
        Me.TextBox19 = New Telerik.Reporting.TextBox
        Me.TextBox20 = New Telerik.Reporting.TextBox
        Me.TextBox21 = New Telerik.Reporting.TextBox
        Me.PageFooterSection1 = New Telerik.Reporting.PageFooterSection
        Me.SqlSelectCommand1 = New System.Data.SqlClient.SqlCommand
        Me.SqlConnection1 = New System.Data.SqlClient.SqlConnection
        Me.SqlDataAdapter1 = New System.Data.SqlClient.SqlDataAdapter
        Me.TextBox2 = New Telerik.Reporting.TextBox
        Me.ReportHeaderSection1 = New Telerik.Reporting.ReportHeaderSection
        Me.TextBox3 = New Telerik.Reporting.TextBox
        Me.TextBox5 = New Telerik.Reporting.TextBox
        Me.currentTimeTextBox = New Telerik.Reporting.TextBox
        Me.TextBox6 = New Telerik.Reporting.TextBox
        Me.TextBox7 = New Telerik.Reporting.TextBox
        Me.TextBox8 = New Telerik.Reporting.TextBox
        Me.TextBox9 = New Telerik.Reporting.TextBox
        Me.TextBox10 = New Telerik.Reporting.TextBox
        Me.TextBox11 = New Telerik.Reporting.TextBox
        Me.TextBox12 = New Telerik.Reporting.TextBox
        Me.TextBox13 = New Telerik.Reporting.TextBox
        Me.TextBox22 = New Telerik.Reporting.TextBox
        Me.TextBox23 = New Telerik.Reporting.TextBox
        Me.TextBox24 = New Telerik.Reporting.TextBox
        Me.TextBox25 = New Telerik.Reporting.TextBox
        Me.ReportFooterSection1 = New Telerik.Reporting.ReportFooterSection
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'PageHeaderSection1
        '
        Me.PageHeaderSection1.Height = New Telerik.Reporting.Drawing.Unit(0.66666668653488159, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageHeaderSection1.Name = "PageHeaderSection1"
        '
        'DetailSection1
        '
        Me.DetailSection1.Height = New Telerik.Reporting.Drawing.Unit(0.26666668057441711, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.DetailSection1.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.TextBox1, Me.TextBox14, Me.TextBox15, Me.TextBox16, Me.TextBox17, Me.TextBox18, Me.TextBox19, Me.TextBox20, Me.TextBox21})
        Me.DetailSection1.Name = "DetailSection1"
        '
        'TextBox1
        '
        Me.TextBox1.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.00000050862632861026214, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox1.Value = "=TicketID"
        '
        'TextBox14
        '
        Me.TextBox14.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.73333382606506348, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox14.Name = "TextBox14"
        Me.TextBox14.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox14.Value = "=WorkOrderID"
        '
        'TextBox15
        '
        Me.TextBox15.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.2000000476837158, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox15.Name = "TextBox15"
        Me.TextBox15.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox15.Value = "=CustomerPO"
        '
        'TextBox16
        '
        Me.TextBox16.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.5999999046325684, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox16.Name = "TextBox16"
        Me.TextBox16.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.2000002861022949, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox16.Value = "=CloseDate"
        '
        'TextBox17
        '
        Me.TextBox17.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.8000001907348633, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox17.Name = "TextBox17"
        Me.TextBox17.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.1333339214324951, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox17.Value = "=Status"
        '
        'TextBox18
        '
        Me.TextBox18.Format = "{0:C2}"
        Me.TextBox18.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(6.9333338737487793, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox18.Name = "TextBox18"
        Me.TextBox18.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333281278610229, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox18.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox18.Value = "=LaborAmount"
        '
        'TextBox19
        '
        Me.TextBox19.Format = "{0:C2}"
        Me.TextBox19.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(7.6666669845581055, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox19.Name = "TextBox19"
        Me.TextBox19.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333281278610229, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox19.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox19.Value = "=AdjustPay"
        '
        'TextBox20
        '
        Me.TextBox20.Format = "{0:C2}"
        Me.TextBox20.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(8.40000057220459, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox20.Name = "TextBox20"
        Me.TextBox20.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333281278610229, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox20.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox20.Value = "=PartAmount"
        '
        'TextBox21
        '
        Me.TextBox21.Format = "{0:C2}"
        Me.TextBox21.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(9.1333341598510742, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox21.Name = "TextBox21"
        Me.TextBox21.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333281278610229, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox21.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox21.Value = "=Total"
        '
        'PageFooterSection1
        '
        Me.PageFooterSection1.Height = New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageFooterSection1.Name = "PageFooterSection1"
        '
        'SqlSelectCommand1
        '
        Me.SqlSelectCommand1.CommandText = "spGetVendorInvoiceByInvoiceID"
        Me.SqlSelectCommand1.CommandType = System.Data.CommandType.StoredProcedure
        Me.SqlSelectCommand1.Connection = Me.SqlConnection1
        Me.SqlSelectCommand1.Parameters.AddRange(New System.Data.SqlClient.SqlParameter() {New System.Data.SqlClient.SqlParameter("InvoiceID", "195")})
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
        Me.SqlDataAdapter1.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "spGetInvoiceByInvoiceID", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("InvoiceID", "InvoiceID"), New System.Data.Common.DataColumnMapping("InvoiceNumber", "InvoiceNumber"), New System.Data.Common.DataColumnMapping("TicketID", "TicketID"), New System.Data.Common.DataColumnMapping("Company", "Company"), New System.Data.Common.DataColumnMapping("CustomerNumber", "CustomerNumber"), New System.Data.Common.DataColumnMapping("CustomerPO", "CustomerPO"), New System.Data.Common.DataColumnMapping("ServiceType", "ServiceType"), New System.Data.Common.DataColumnMapping("CloseDate", "CloseDate"), New System.Data.Common.DataColumnMapping("Status", "Status"), New System.Data.Common.DataColumnMapping("ServiceName", "ServiceName"), New System.Data.Common.DataColumnMapping("LaborAmount", "LaborAmount"), New System.Data.Common.DataColumnMapping("AdjustCharge", "AdjustCharge"), New System.Data.Common.DataColumnMapping("PartAmount", "PartAmount"), New System.Data.Common.DataColumnMapping("Total", "Total")})})
        '
        'TextBox2
        '
        Me.TextBox2.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.53333336114883423, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox2.Name = "TextBox2"
        Me.TextBox2.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox2.Value = "=InvoiceNumber"
        '
        'ReportHeaderSection1
        '
        Me.ReportHeaderSection1.Height = New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.ReportHeaderSection1.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.TextBox2, Me.TextBox3, Me.TextBox5, Me.currentTimeTextBox, Me.TextBox6, Me.TextBox7, Me.TextBox8, Me.TextBox9, Me.TextBox10, Me.TextBox11, Me.TextBox12, Me.TextBox13})
        Me.ReportHeaderSection1.Name = "ReportHeaderSection1"
        '
        'TextBox3
        '
        Me.TextBox3.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox3.Name = "TextBox3"
        Me.TextBox3.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox3.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox3.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox3.Value = "TicketID"
        '
        'TextBox5
        '
        Me.TextBox5.Name = "TextBox5"
        Me.TextBox5.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(4.7333331108093262, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.3333333432674408, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox5.Style.Color = System.Drawing.Color.Black
        Me.TextBox5.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(20, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.TextBox5.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox5.Value = "Vendor Group Payment Report"
        '
        'currentTimeTextBox
        '
        Me.currentTimeTextBox.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(6.6666669845581055, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.53333336114883423, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.currentTimeTextBox.Name = "currentTimeTextBox"
        Me.currentTimeTextBox.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(3.2083332538604736, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.currentTimeTextBox.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.currentTimeTextBox.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.currentTimeTextBox.StyleName = "PageInfo"
        Me.currentTimeTextBox.Value = "=NOW()"
        '
        'TextBox6
        '
        Me.TextBox6.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.73333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox6.Name = "TextBox6"
        Me.TextBox6.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox6.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox6.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox6.Value = "Work OrderID"
        '
        'TextBox7
        '
        Me.TextBox7.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.5999999046325684, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox7.Name = "TextBox7"
        Me.TextBox7.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.2000002861022949, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox7.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox7.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox7.Value = "Close Date"
        '
        'TextBox8
        '
        Me.TextBox8.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.2000000476837158, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox8.Name = "TextBox8"
        Me.TextBox8.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox8.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox8.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox8.Value = "Customer PO"
        '
        'TextBox9
        '
        Me.TextBox9.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.8000001907348633, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox9.Name = "TextBox9"
        Me.TextBox9.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.1333334445953369, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox9.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox9.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox9.Value = "Status"
        '
        'TextBox10
        '
        Me.TextBox10.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(6.9333333969116211, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox10.Name = "TextBox10"
        Me.TextBox10.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox10.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox10.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox10.Value = "Labor"
        '
        'TextBox11
        '
        Me.TextBox11.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(7.6666665077209473, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox11.Name = "TextBox11"
        Me.TextBox11.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox11.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox11.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox11.Value = "Extra"
        '
        'TextBox12
        '
        Me.TextBox12.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(8.3999996185302734, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox12.Name = "TextBox12"
        Me.TextBox12.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox12.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox12.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox12.Value = "Parts"
        '
        'TextBox13
        '
        Me.TextBox13.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(9.1333341598510742, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.80000007152557373, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox13.Name = "TextBox13"
        Me.TextBox13.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox13.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox13.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox13.Value = "Total"
        '
        'TextBox22
        '
        Me.TextBox22.Format = "{0:C2}"
        Me.TextBox22.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox22.Name = "TextBox22"
        Me.TextBox22.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(7.6666665077209473, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox22.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox22.Style.Color = System.Drawing.Color.Black
        Me.TextBox22.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox22.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox22.Value = "=Sum(LaborAmount)"
        '
        'TextBox23
        '
        Me.TextBox23.Format = "{0:C2}"
        Me.TextBox23.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(7.6666669845581055, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox23.Name = "TextBox23"
        Me.TextBox23.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333281278610229, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox23.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox23.Style.Color = System.Drawing.Color.Black
        Me.TextBox23.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox23.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox23.Value = "=Sum(AdjustPay)"
        '
        'TextBox24
        '
        Me.TextBox24.Format = "{0:C2}"
        Me.TextBox24.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(8.40000057220459, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox24.Name = "TextBox24"
        Me.TextBox24.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333281278610229, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox24.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox24.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox24.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox24.Value = "=Sum(PartAmount)"
        '
        'TextBox25
        '
        Me.TextBox25.Format = "{0:C2}"
        Me.TextBox25.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(9.1333341598510742, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox25.Name = "TextBox25"
        Me.TextBox25.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333281278610229, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox25.Style.BackgroundColor = System.Drawing.SystemColors.ControlDark
        Me.TextBox25.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox25.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox25.Value = "=Sum(Total)"
        '
        'ReportFooterSection1
        '
        Me.ReportFooterSection1.Height = New Telerik.Reporting.Drawing.Unit(0.26666668057441711, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.ReportFooterSection1.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.TextBox22, Me.TextBox23, Me.TextBox24, Me.TextBox25})
        Me.ReportFooterSection1.Name = "ReportFooterSection1"
        '
        'rptVendorInvoices
        '
        Me.DataSource = Me.SqlDataAdapter1
        Me.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.PageHeaderSection1, Me.DetailSection1, Me.PageFooterSection1, Me.ReportHeaderSection1, Me.ReportFooterSection1})
        Me.PageSettings.Landscape = True
        Me.PageSettings.Margins.Bottom = New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Left = New Telerik.Reporting.Drawing.Unit(0.5, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Right = New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Top = New Telerik.Reporting.Drawing.Unit(0.5, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.PaperKind = System.Drawing.Printing.PaperKind.Letter
        Me.Style.BackgroundColor = System.Drawing.Color.White
        Me.Width = New Telerik.Reporting.Drawing.Unit(9.9333333969116211, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents PageHeaderSection1 As PageHeaderSection
    Friend WithEvents DetailSection1 As DetailSection
    Friend WithEvents PageFooterSection1 As PageFooterSection
    Friend WithEvents SqlSelectCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlConnection1 As System.Data.SqlClient.SqlConnection
    Friend WithEvents SqlDataAdapter1 As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents TextBox1 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox2 As Telerik.Reporting.TextBox
    Friend WithEvents ReportHeaderSection1 As Telerik.Reporting.ReportHeaderSection
    Friend WithEvents TextBox3 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox5 As Telerik.Reporting.TextBox
    Friend WithEvents currentTimeTextBox As Telerik.Reporting.TextBox
    Friend WithEvents TextBox7 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox6 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox8 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox9 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox10 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox11 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox12 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox13 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox14 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox15 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox16 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox17 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox18 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox19 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox20 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox21 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox22 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox23 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox24 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox25 As Telerik.Reporting.TextBox
    Friend WithEvents ReportFooterSection1 As Telerik.Reporting.ReportFooterSection
End Class