Imports System.ComponentModel
Imports System.Drawing
Imports Telerik.Reporting
Imports Telerik.Reporting.Drawing

Partial Class InvoiceSingle

    'NOTE: The following procedure is required by the telerik Reporting Designer
    'It can be modified using the telerik Reporting Designer.  
    'Do not modify it using the code editor.
    Private Sub InitializeComponent()
        Me.DetailSection1 = New Telerik.Reporting.DetailSection
        Me.txtLaborAmount = New Telerik.Reporting.TextBox
        Me.TextBox24 = New Telerik.Reporting.TextBox
        Me.ReportHeaderSection1 = New Telerik.Reporting.ReportHeaderSection
        Me.TextBox20 = New Telerik.Reporting.TextBox
        Me.txtInvoiceNumber = New Telerik.Reporting.TextBox
        Me.TextBox12 = New Telerik.Reporting.TextBox
        Me.TextBox13 = New Telerik.Reporting.TextBox
        Me.txtDateCreated = New Telerik.Reporting.TextBox
        Me.SqlSelectCommand1 = New System.Data.SqlClient.SqlCommand
        Me.SqlConnection1 = New System.Data.SqlClient.SqlConnection
        Me.SqlDataAdapter1 = New System.Data.SqlClient.SqlDataAdapter
        Me.txtBillCompany = New Telerik.Reporting.TextBox
        Me.txtBillName = New Telerik.Reporting.TextBox
        Me.txtBillStreet = New Telerik.Reporting.TextBox
        Me.txtCity = New Telerik.Reporting.TextBox
        Me.txtShipCity = New Telerik.Reporting.TextBox
        Me.txtShipStreet = New Telerik.Reporting.TextBox
        Me.txtShipName = New Telerik.Reporting.TextBox
        Me.txtShipCompany = New Telerik.Reporting.TextBox
        Me.grpTicketID = New Telerik.Reporting.Group
        Me.GroupFooterSection1 = New Telerik.Reporting.GroupFooterSection
        Me.TextBox19 = New Telerik.Reporting.TextBox
        Me.txtTotalLabor = New Telerik.Reporting.TextBox
        Me.TextBox21 = New Telerik.Reporting.TextBox
        Me.TextBox22 = New Telerik.Reporting.TextBox
        Me.txtTotalParts = New Telerik.Reporting.TextBox
        Me.txtTotalExtra = New Telerik.Reporting.TextBox
        Me.txtGrandTotal = New Telerik.Reporting.TextBox
        Me.TextBox26 = New Telerik.Reporting.TextBox
        Me.srptParts = New Telerik.Reporting.SubReport
        Me.SrptParts2 = New Reports.srptParts
        Me.TextBox23 = New Telerik.Reporting.TextBox
        Me.TextBox25 = New Telerik.Reporting.TextBox
        Me.TextBox27 = New Telerik.Reporting.TextBox
        Me.TextBox28 = New Telerik.Reporting.TextBox
        Me.TextBox29 = New Telerik.Reporting.TextBox
        Me.GroupHeaderSection1 = New Telerik.Reporting.GroupHeaderSection
        Me.TextBox1 = New Telerik.Reporting.TextBox
        Me.TextBox2 = New Telerik.Reporting.TextBox
        Me.TextBox3 = New Telerik.Reporting.TextBox
        Me.TextBox4 = New Telerik.Reporting.TextBox
        Me.txtShipState = New Telerik.Reporting.TextBox
        Me.txtShipZipCode = New Telerik.Reporting.TextBox
        Me.TextBox10 = New Telerik.Reporting.TextBox
        Me.txtCompany = New Telerik.Reporting.TextBox
        Me.TextBox15 = New Telerik.Reporting.TextBox
        Me.txtResolutionNote = New Telerik.Reporting.TextBox
        Me.TextBox5 = New Telerik.Reporting.TextBox
        Me.TextBox6 = New Telerik.Reporting.TextBox
        Me.TextBox7 = New Telerik.Reporting.TextBox
        Me.TextBox8 = New Telerik.Reporting.TextBox
        Me.TextBox9 = New Telerik.Reporting.TextBox
        Me.TextBox11 = New Telerik.Reporting.TextBox
        Me.TextBox14 = New Telerik.Reporting.TextBox
        Me.TextBox16 = New Telerik.Reporting.TextBox
        Me.TextBox18 = New Telerik.Reporting.TextBox
        Me.TextBox17 = New Telerik.Reporting.TextBox
        Me.SrptParts1 = New Reports.srptParts
        CType(Me.SrptParts2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SrptParts1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        '
        'DetailSection1
        '
        Me.DetailSection1.Height = New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.DetailSection1.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.txtLaborAmount, Me.TextBox24})
        Me.DetailSection1.Name = "DetailSection1"
        Me.DetailSection1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.DetailSection1.Style.Font.Style = System.Drawing.FontStyle.Regular
        '
        'txtLaborAmount
        '
        Me.txtLaborAmount.Format = "{0:C2}"
        Me.txtLaborAmount.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.7333335876464844, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtLaborAmount.Name = "txtLaborAmount"
        Me.txtLaborAmount.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtLaborAmount.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtLaborAmount.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.txtLaborAmount.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.txtLaborAmount.Value = "=Fields.LaborAmount"
        Me.txtLaborAmount.Visible = False
        '
        'TextBox24
        '
        Me.TextBox24.Format = "{0:C2}"
        Me.TextBox24.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(1.3333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox24.Name = "TextBox24"
        Me.TextBox24.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox24.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox24.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox24.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox24.Value = "=Fields.AdjustCharge"
        Me.TextBox24.Visible = False
        '
        'ReportHeaderSection1
        '
        Me.ReportHeaderSection1.Height = New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.ReportHeaderSection1.Name = "ReportHeaderSection1"
        Me.ReportHeaderSection1.Style.Font.Style = System.Drawing.FontStyle.Regular
        '
        'TextBox20
        '
        Me.TextBox20.Format = "{0:D}"
        Me.TextBox20.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.6666667461395264, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.73333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox20.Name = "TextBox20"
        Me.TextBox20.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.8000004291534424, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox20.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.TextBox20.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox20.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox20.Value = "= Fields.DateCreated"
        '
        'txtInvoiceNumber
        '
        Me.txtInvoiceNumber.Format = "{0:d}"
        Me.txtInvoiceNumber.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.0000004768371582, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.2666667699813843, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtInvoiceNumber.Name = "txtInvoiceNumber"
        Me.txtInvoiceNumber.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtInvoiceNumber.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtInvoiceNumber.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.txtInvoiceNumber.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.txtInvoiceNumber.Value = "=Fields.TicketID"
        '
        'TextBox12
        '
        Me.TextBox12.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.9333333969116211, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox12.Name = "TextBox12"
        Me.TextBox12.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.5333333015441895, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox12.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox12.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox12.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox12.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox12.Value = "Invoice Number:"
        '
        'TextBox13
        '
        Me.TextBox13.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.9333333969116211, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox13.Name = "TextBox13"
        Me.TextBox13.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.5333333015441895, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox13.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox13.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox13.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox13.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox13.Value = "Invoice Date:"
        '
        'txtDateCreated
        '
        Me.txtDateCreated.Format = "{0:d}"
        Me.txtDateCreated.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.0000004768371582, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.6666667461395264, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtDateCreated.Name = "txtDateCreated"
        Me.txtDateCreated.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtDateCreated.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtDateCreated.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.txtDateCreated.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.txtDateCreated.Value = "=Fields.DateCreated"
        '
        'SqlSelectCommand1
        '
        Me.SqlSelectCommand1.CommandText = "dbo.spGetInvoiceSingleByInvoiceID"
        Me.SqlSelectCommand1.CommandType = System.Data.CommandType.StoredProcedure
        Me.SqlSelectCommand1.Connection = Me.SqlConnection1
        Me.SqlSelectCommand1.Parameters.AddRange(New System.Data.SqlClient.SqlParameter() {New System.Data.SqlClient.SqlParameter("@InvoiceID", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(0, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, "8")})
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
        Me.SqlDataAdapter1.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "spGetInvoiceSingleByInvoiceID", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("InvoiceID", "InvoiceID"), New System.Data.Common.DataColumnMapping("CustomerID", "CustomerID"), New System.Data.Common.DataColumnMapping("CreatedBy", "CreatedBy"), New System.Data.Common.DataColumnMapping("InternalDescription", "InternalDescription"), New System.Data.Common.DataColumnMapping("BillName", "BillName"), New System.Data.Common.DataColumnMapping("BillCompany", "BillCompany"), New System.Data.Common.DataColumnMapping("BillStreet", "BillStreet"), New System.Data.Common.DataColumnMapping("BillExtended", "BillExtended"), New System.Data.Common.DataColumnMapping("BillCity", "BillCity"), New System.Data.Common.DataColumnMapping("BillState", "BillState"), New System.Data.Common.DataColumnMapping("BillZipCode", "BillZipCode"), New System.Data.Common.DataColumnMapping("ShipName", "ShipName"), New System.Data.Common.DataColumnMapping("ShipCompany", "ShipCompany"), New System.Data.Common.DataColumnMapping("ShipStreet", "ShipStreet"), New System.Data.Common.DataColumnMapping("ShipExtended", "ShipExtended"), New System.Data.Common.DataColumnMapping("ShipCity", "ShipCity"), New System.Data.Common.DataColumnMapping("ShipState", "ShipState"), New System.Data.Common.DataColumnMapping("ShipZipCode", "ShipZipCode"), New System.Data.Common.DataColumnMapping("Notes", "Notes"), New System.Data.Common.DataColumnMapping("Total", "Total"), New System.Data.Common.DataColumnMapping("DateCreated", "DateCreated"), New System.Data.Common.DataColumnMapping("Paid", "Paid"), New System.Data.Common.DataColumnMapping("InvoiceNumber", "InvoiceNumber"), New System.Data.Common.DataColumnMapping("IsVendorPayment", "IsVendorPayment"), New System.Data.Common.DataColumnMapping("PartnerID", "PartnerID"), New System.Data.Common.DataColumnMapping("WorkOrderID", "WorkOrderID"), New System.Data.Common.DataColumnMapping("CreatedBy1", "CreatedBy1"), New System.Data.Common.DataColumnMapping("PartnerAddressID", "PartnerAddressID"), New System.Data.Common.DataColumnMapping("PartnerID1", "PartnerID1"), New System.Data.Common.DataColumnMapping("PartnerAgentID", "PartnerAgentID"), New System.Data.Common.DataColumnMapping("WorkOrderStatusID", "WorkOrderStatusID"), New System.Data.Common.DataColumnMapping("ServiceID", "ServiceID"), New System.Data.Common.DataColumnMapping("TicketID", "TicketID"), New System.Data.Common.DataColumnMapping("WorkOrderFileID", "WorkOrderFileID"), New System.Data.Common.DataColumnMapping("IncrementTypeID", "IncrementTypeID"), New System.Data.Common.DataColumnMapping("ClosingAgent", "ClosingAgent"), New System.Data.Common.DataColumnMapping("MileageStart", "MileageStart"), New System.Data.Common.DataColumnMapping("MileageEnd", "MileageEnd"), New System.Data.Common.DataColumnMapping("TimeOnHold", "TimeOnHold"), New System.Data.Common.DataColumnMapping("TravelTime", "TravelTime"), New System.Data.Common.DataColumnMapping("SurveyEmail", "SurveyEmail"), New System.Data.Common.DataColumnMapping("TechSupportAgentName", "TechSupportAgentName"), New System.Data.Common.DataColumnMapping("ResolutionNote", "ResolutionNote"), New System.Data.Common.DataColumnMapping("MinimumPay", "MinimumPay"), New System.Data.Common.DataColumnMapping("MaximumPay", "MaximumPay"), New System.Data.Common.DataColumnMapping("PayRate", "PayRate"), New System.Data.Common.DataColumnMapping("AdjustPay", "AdjustPay"), New System.Data.Common.DataColumnMapping("SurveyAuthorized", "SurveyAuthorized"), New System.Data.Common.DataColumnMapping("Payable", "Payable"), New System.Data.Common.DataColumnMapping("ClosedFromSite", "ClosedFromSite"), New System.Data.Common.DataColumnMapping("Resolved", "Resolved"), New System.Data.Common.DataColumnMapping("DateClosed", "DateClosed"), New System.Data.Common.DataColumnMapping("DispatchDate", "DispatchDate"), New System.Data.Common.DataColumnMapping("Arrived", "Arrived"), New System.Data.Common.DataColumnMapping("Departed", "Departed"), New System.Data.Common.DataColumnMapping("DateCreated1", "DateCreated1"), New System.Data.Common.DataColumnMapping("Invoiced", "Invoiced"), New System.Data.Common.DataColumnMapping("InvoiceAmount", "InvoiceAmount"), New System.Data.Common.DataColumnMapping("InvoiceExtraAmount", "InvoiceExtraAmount"), New System.Data.Common.DataColumnMapping("InvoiceDate", "InvoiceDate"), New System.Data.Common.DataColumnMapping("InvoicePaidDate", "InvoicePaidDate"), New System.Data.Common.DataColumnMapping("InvoicePaidOnCheckNumber", "InvoicePaidOnCheckNumber"), New System.Data.Common.DataColumnMapping("VendorPaid", "VendorPaid"), New System.Data.Common.DataColumnMapping("VendorPaidAmount", "VendorPaidAmount"), New System.Data.Common.DataColumnMapping("VendorExtraAmount", "VendorExtraAmount"), New System.Data.Common.DataColumnMapping("VendorPaidDate", "VendorPaidDate"), New System.Data.Common.DataColumnMapping("VendorPaidOnCheckNumber", "VendorPaidOnCheckNumber"), New System.Data.Common.DataColumnMapping("VendorPayNotes", "VendorPayNotes"), New System.Data.Common.DataColumnMapping("InvoiceNotes", "InvoiceNotes"), New System.Data.Common.DataColumnMapping("InvoicePaidAmount", "InvoicePaidAmount"), New System.Data.Common.DataColumnMapping("Billable", "Billable"), New System.Data.Common.DataColumnMapping("TripChargeTypeID", "TripChargeTypeID"), New System.Data.Common.DataColumnMapping("InvoiceID1", "InvoiceID1"), New System.Data.Common.DataColumnMapping("ReferenceNumber1", "ReferenceNumber1"), New System.Data.Common.DataColumnMapping("ReferenceNumber2", "ReferenceNumber2"), New System.Data.Common.DataColumnMapping("TicketID1", "TicketID1"), New System.Data.Common.DataColumnMapping("Company", "Company"), New System.Data.Common.DataColumnMapping("CustomerNumber", "CustomerNumber"), New System.Data.Common.DataColumnMapping("CustomerPO", "CustomerPO"), New System.Data.Common.DataColumnMapping("ServiceType", "ServiceType"), New System.Data.Common.DataColumnMapping("LaborAmount", "LaborAmount"), New System.Data.Common.DataColumnMapping("CloseDate", "CloseDate"), New System.Data.Common.DataColumnMapping("Status", "Status"), New System.Data.Common.DataColumnMapping("ServiceName", "ServiceName"), New System.Data.Common.DataColumnMapping("AdjustCharge", "AdjustCharge"), New System.Data.Common.DataColumnMapping("PartAmount", "PartAmount")})})
        '
        'txtBillCompany
        '
        Me.txtBillCompany.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.13333334028720856, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.3333333730697632, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtBillCompany.Name = "txtBillCompany"
        Me.txtBillCompany.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.2666666507720947, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtBillCompany.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtBillCompany.Value = "=Fields.BillCompany"
        '
        'txtBillName
        '
        Me.txtBillName.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.13333334028720856, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.6000001430511475, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtBillName.Name = "txtBillName"
        Me.txtBillName.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.2666666507720947, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtBillName.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtBillName.Value = "=Fields.BillName"
        '
        'txtBillStreet
        '
        Me.txtBillStreet.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.13333334028720856, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.8666667938232422, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtBillStreet.Name = "txtBillStreet"
        Me.txtBillStreet.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.2666666507720947, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtBillStreet.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtBillStreet.Value = "=Fields.BillStreet"
        '
        'txtCity
        '
        Me.txtCity.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.13333334028720856, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.1333334445953369, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtCity.Name = "txtCity"
        Me.txtCity.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtCity.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtCity.Value = "=Fields.BillCity "
        '
        'txtShipCity
        '
        Me.txtShipCity.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.5999999046325684, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.1333334445953369, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipCity.Name = "txtShipCity"
        Me.txtShipCity.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.0666669607162476, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipCity.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtShipCity.Value = "=Fields.City"
        '
        'txtShipStreet
        '
        Me.txtShipStreet.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.6000001430511475, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.8666667938232422, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipStreet.Name = "txtShipStreet"
        Me.txtShipStreet.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.2666666507720947, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipStreet.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtShipStreet.Value = "=Fields.Street"
        '
        'txtShipName
        '
        Me.txtShipName.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.6000001430511475, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.6000001430511475, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipName.Name = "txtShipName"
        Me.txtShipName.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.2666666507720947, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipName.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtShipName.Value = "=Fields.EU"
        '
        'txtShipCompany
        '
        Me.txtShipCompany.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.6000001430511475, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.3333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipCompany.Name = "txtShipCompany"
        Me.txtShipCompany.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.2666668891906738, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipCompany.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtShipCompany.Value = "=Fields.CO"
        '
        'grpTicketID
        '
        Me.grpTicketID.GroupFooter = Me.GroupFooterSection1
        Me.grpTicketID.GroupHeader = Me.GroupHeaderSection1
        Me.grpTicketID.Grouping.AddRange(New Telerik.Reporting.Data.Grouping() {New Telerik.Reporting.Data.Grouping("=Fields.TicketID")})
        Me.grpTicketID.GroupKeepTogether = Telerik.Reporting.GroupKeepTogether.All
        Me.grpTicketID.Sorting.AddRange(New Telerik.Reporting.Data.Sorting() {New Telerik.Reporting.Data.Sorting("=Fields.TicketID", Telerik.Reporting.Data.SortDirection.Asc)})
        '
        'GroupFooterSection1
        '
        Me.GroupFooterSection1.Height = New Telerik.Reporting.Drawing.Unit(3.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.GroupFooterSection1.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.TextBox19, Me.txtTotalLabor, Me.TextBox21, Me.TextBox22, Me.txtTotalParts, Me.txtTotalExtra, Me.txtGrandTotal, Me.TextBox26, Me.srptParts, Me.TextBox23, Me.TextBox25, Me.TextBox27, Me.TextBox28, Me.TextBox29})
        Me.GroupFooterSection1.Name = "GroupFooterSection1"
        Me.GroupFooterSection1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.GroupFooterSection1.Style.Font.Style = System.Drawing.FontStyle.Regular
        '
        'TextBox19
        '
        Me.TextBox19.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.9333338737487793, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.0000002384185791, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox19.Name = "TextBox19"
        Me.TextBox19.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.5333328247070312, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox19.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox19.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox19.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox19.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox19.Value = "Total Extra Amount:"
        '
        'txtTotalLabor
        '
        Me.txtTotalLabor.Format = "{0:C2}"
        Me.txtTotalLabor.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.0000004768371582, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.7333335876464844, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtTotalLabor.Name = "txtTotalLabor"
        Me.txtTotalLabor.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtTotalLabor.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtTotalLabor.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.txtTotalLabor.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.txtTotalLabor.Value = "=Sum(Fields.LaborAmount)"
        '
        'TextBox21
        '
        Me.TextBox21.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.9333338737487793, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.5333335399627686, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox21.Name = "TextBox21"
        Me.TextBox21.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.5333328247070312, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox21.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox21.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox21.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox21.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox21.Value = "Total Labor:"
        '
        'TextBox22
        '
        Me.TextBox22.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.9333338737487793, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.4666669368743896, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox22.Name = "TextBox22"
        Me.TextBox22.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.5333328247070312, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.18333359062671661, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox22.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox22.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox22.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox22.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox22.Value = "Total Parts:"
        '
        'txtTotalParts
        '
        Me.txtTotalParts.Format = "{0:C2}"
        Me.txtTotalParts.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.0000004768371582, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.7333335876464844, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtTotalParts.Name = "txtTotalParts"
        Me.txtTotalParts.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.18333359062671661, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtTotalParts.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtTotalParts.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.txtTotalParts.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.txtTotalParts.Value = "=Fields.PartAmount"
        '
        'txtTotalExtra
        '
        Me.txtTotalExtra.Format = "{0:C2}"
        Me.txtTotalExtra.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.0000004768371582, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.2000002861022949, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtTotalExtra.Name = "txtTotalExtra"
        Me.txtTotalExtra.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.18333359062671661, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtTotalExtra.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtTotalExtra.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.txtTotalExtra.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.txtTotalExtra.Value = "=Sum(Fields.AdjustCharge)"
        '
        'txtGrandTotal
        '
        Me.txtGrandTotal.Format = "{0:C2}"
        Me.txtGrandTotal.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.0000004768371582, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(3.2666668891906738, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtGrandTotal.Name = "txtGrandTotal"
        Me.txtGrandTotal.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtGrandTotal.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtGrandTotal.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.txtGrandTotal.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.txtGrandTotal.Value = "=(Sum(Fields.LaborAmount)+ Sum(Fields.AdjustCharge)+ Fields.PartAmount)"
        '
        'TextBox26
        '
        Me.TextBox26.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.9333338737487793, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(3.0000002384185791, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox26.Name = "TextBox26"
        Me.TextBox26.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.5333328247070312, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox26.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox26.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox26.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox26.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox26.Value = "Total Amount:"
        '
        'srptParts
        '
        Me.srptParts.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.26666668057441711, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.srptParts.Name = "srptParts"
        Me.srptParts.Parameters.Add(New Telerik.Reporting.Parameter("TicketID", "= Fields.TicketID"))
        Me.srptParts.ReportSource = Me.SrptParts2
        Me.srptParts.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(6.4000000953674316, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.2000000476837158, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.srptParts.Style.BorderStyle.Default = Telerik.Reporting.Drawing.BorderType.Solid
        Me.srptParts.Style.Font.Style = System.Drawing.FontStyle.Regular
        '
        'TextBox23
        '
        Me.TextBox23.Format = "{0:C2}"
        Me.TextBox23.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.0000004768371582, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.7333335876464844, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox23.Name = "TextBox23"
        Me.TextBox23.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.18333359062671661, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox23.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox23.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox23.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox23.Value = "=Fields.PartAmount"
        '
        'TextBox25
        '
        Me.TextBox25.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.7333333492279053, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox25.Name = "TextBox25"
        Me.TextBox25.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(4.8000001907348633, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.7333333492279053, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox25.Style.BorderStyle.Default = Telerik.Reporting.Drawing.BorderType.Solid
        Me.TextBox25.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox25.Value = "=Fields.Notes"
        '
        'TextBox27
        '
        Me.TextBox27.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.5333333015441895, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox27.Name = "TextBox27"
        Me.TextBox27.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(4.8000001907348633, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox27.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox27.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox27.Value = "Notes:"
        '
        'TextBox28
        '
        Me.TextBox28.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.5333333015441895, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox28.Name = "TextBox28"
        Me.TextBox28.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(4.8000001907348633, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox28.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox28.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox28.Value = "Notes:"
        '
        'TextBox29
        '
        Me.TextBox29.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox29.Name = "TextBox29"
        Me.TextBox29.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(6.4000000953674316, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox29.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox29.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox29.Value = "Parts:"
        '
        'GroupHeaderSection1
        '
        Me.GroupHeaderSection1.Height = New Telerik.Reporting.Drawing.Unit(4.1999998092651367, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.GroupHeaderSection1.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.txtBillCompany, Me.txtBillName, Me.txtBillStreet, Me.txtCity, Me.txtShipCompany, Me.txtShipName, Me.txtShipStreet, Me.txtShipCity, Me.txtDateCreated, Me.TextBox13, Me.TextBox12, Me.txtInvoiceNumber, Me.TextBox1, Me.TextBox2, Me.TextBox3, Me.TextBox4, Me.txtShipState, Me.txtShipZipCode, Me.TextBox10, Me.txtCompany, Me.TextBox15, Me.txtResolutionNote, Me.TextBox5, Me.TextBox6, Me.TextBox7, Me.TextBox8, Me.TextBox9, Me.TextBox11, Me.TextBox14, Me.TextBox16, Me.TextBox18, Me.TextBox20, Me.TextBox17})
        Me.GroupHeaderSection1.Name = "GroupHeaderSection1"
        Me.GroupHeaderSection1.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.GroupHeaderSection1.Style.Font.Style = System.Drawing.FontStyle.Regular
        '
        'TextBox1
        '
        Me.TextBox1.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(1.5333333015441895, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.1333334445953369, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox1.Name = "TextBox1"
        Me.TextBox1.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.20000000298023224, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox1.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox1.Value = "=Fields.BillState"
        '
        'TextBox2
        '
        Me.TextBox2.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(1.7333333492279053, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.1333334445953369, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox2.Name = "TextBox2"
        Me.TextBox2.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.666666567325592, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox2.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox2.Value = "=Fields.BillZipCode"
        '
        'TextBox3
        '
        Me.TextBox3.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox3.Name = "TextBox3"
        Me.TextBox3.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.4000000953674316, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox3.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox3.Style.Color = System.Drawing.Color.Black
        Me.TextBox3.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox3.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox3.Value = "Bill To:"
        '
        'TextBox4
        '
        Me.TextBox4.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.5333335399627686, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox4.Name = "TextBox4"
        Me.TextBox4.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.3333332538604736, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox4.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox4.Style.Color = System.Drawing.Color.Black
        Me.TextBox4.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox4.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Left
        Me.TextBox4.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox4.Value = "Serviced Site/End User:"
        '
        'txtShipState
        '
        Me.txtShipState.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.7333335876464844, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.1333334445953369, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipState.Name = "txtShipState"
        Me.txtShipState.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.33333307504653931, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipState.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtShipState.Value = "=Fields.Abbreviation"
        '
        'txtShipZipCode
        '
        Me.txtShipZipCode.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.0666670799255371, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.1333334445953369, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipZipCode.Name = "txtShipZipCode"
        Me.txtShipZipCode.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(0.73333334922790527, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtShipZipCode.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtShipZipCode.Value = "=Fields.ZipCode"
        '
        'TextBox10
        '
        Me.TextBox10.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.9333333969116211, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.9333335161209106, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox10.Name = "TextBox10"
        Me.TextBox10.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.5333333015441895, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox10.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox10.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox10.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox10.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox10.Value = "Customer:"
        '
        'txtCompany
        '
        Me.txtCompany.Format = "{0:d}"
        Me.txtCompany.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(5.0000004768371582, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.1333334445953369, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtCompany.Name = "txtCompany"
        Me.txtCompany.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtCompany.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtCompany.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.txtCompany.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.txtCompany.Value = "=Fields.Company"
        '
        'TextBox15
        '
        Me.TextBox15.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.8666670322418213, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox15.Name = "TextBox15"
        Me.TextBox15.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(6.4000000953674316, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox15.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox15.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox15.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox15.Value = "Service Performed:"
        '
        'txtResolutionNote
        '
        Me.txtResolutionNote.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(3.066666841506958, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtResolutionNote.Name = "txtResolutionNote"
        Me.txtResolutionNote.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(6.4000000953674316, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(1.0666663646697998, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.txtResolutionNote.Style.BorderStyle.Default = Telerik.Reporting.Drawing.BorderType.Solid
        Me.txtResolutionNote.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.txtResolutionNote.Value = "=Fields.ResolutionNote "
        '
        'TextBox5
        '
        Me.TextBox5.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666796803474426, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.6000001430511475, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox5.Name = "TextBox5"
        Me.TextBox5.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox5.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox5.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox5.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox5.Value = "=Fields.InvoiceNumber"
        '
        'TextBox6
        '
        Me.TextBox6.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666796803474426, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.4000003337860107, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox6.Name = "TextBox6"
        Me.TextBox6.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox6.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox6.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox6.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox6.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox6.Value = "Group Invoice:"
        '
        'TextBox7
        '
        Me.TextBox7.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(1.4666668176651, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.4000003337860107, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox7.Name = "TextBox7"
        Me.TextBox7.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox7.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox7.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox7.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox7.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox7.Value = "Customer Number:"
        '
        'TextBox8
        '
        Me.TextBox8.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(1.533333420753479, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.6000001430511475, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox8.Name = "TextBox8"
        Me.TextBox8.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox8.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox8.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox8.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox8.Value = "=Fields.ReferenceNumber1"
        '
        'TextBox9
        '
        Me.TextBox9.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.066666841506958, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.6000001430511475, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox9.Name = "TextBox9"
        Me.TextBox9.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.3999999761581421, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox9.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox9.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox9.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox9.Value = "=Fields.ReferenceNumber2"
        '
        'TextBox11
        '
        Me.TextBox11.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(2.9333333969116211, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.4000003337860107, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox11.Name = "TextBox11"
        Me.TextBox11.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(1.5333333015441895, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox11.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox11.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox11.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox11.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox11.Value = "Customer PO:"
        '
        'TextBox14
        '
        Me.TextBox14.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.4000003337860107, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox14.Name = "TextBox14"
        Me.TextBox14.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox14.Style.BackgroundColor = System.Drawing.Color.Silver
        Me.TextBox14.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox14.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox14.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox14.Value = "Close Date:"
        '
        'TextBox16
        '
        Me.TextBox16.Format = "{0:d}"
        Me.TextBox16.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(4.4666666984558105, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(2.6000001430511475, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox16.Name = "TextBox16"
        Me.TextBox16.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.19166666269302368, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox16.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox16.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Center
        Me.TextBox16.Style.VerticalAlign = Telerik.Reporting.Drawing.VerticalAlign.Middle
        Me.TextBox16.Value = "=Fields.Departed"
        '
        'TextBox18
        '
        Me.TextBox18.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox18.Name = "TextBox18"
        Me.TextBox18.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.93333333730697632, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox18.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(9, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.TextBox18.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.TextBox18.Value = "Best Servicers of America, Inc." & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "801 Northpoint Parkway 104" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "West Palm Beach, FL " & _
            "33407" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Phone: 561.886.6699" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Fax: 561.886.6690" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "www.bestservicers.com"
        '
        'TextBox17
        '
        Me.TextBox17.Format = "{0:D}"
        Me.TextBox17.Location = New Telerik.Reporting.Drawing.PointU(New Telerik.Reporting.Drawing.Unit(3.6666667461395264, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.066666670143604279, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox17.Name = "TextBox17"
        Me.TextBox17.Size = New Telerik.Reporting.Drawing.SizeU(New Telerik.Reporting.Drawing.Unit(2.8000004291534424, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)), New Telerik.Reporting.Drawing.Unit(0.40000000596046448, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType)))
        Me.TextBox17.Style.Font.Size = New Telerik.Reporting.Drawing.Unit(20, CType(Telerik.Reporting.Drawing.UnitType.Point, Telerik.Reporting.Drawing.UnitType))
        Me.TextBox17.Style.Font.Style = System.Drawing.FontStyle.Bold
        Me.TextBox17.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Right
        Me.TextBox17.Value = "Invoice"
        '
        'InvoiceSingles
        '
        Me.DataSource = Me.SqlDataAdapter1
        Me.Groups.AddRange(New Telerik.Reporting.Group() {Me.grpTicketID})
        Me.Items.AddRange(New Telerik.Reporting.ReportItemBase() {Me.GroupHeaderSection1, Me.GroupFooterSection1, Me.DetailSection1, Me.ReportHeaderSection1})
        Me.PageSettings.Landscape = False
        Me.PageSettings.Margins.Bottom = New Telerik.Reporting.Drawing.Unit(0.50999999046325684, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Left = New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Right = New Telerik.Reporting.Drawing.Unit(0.5, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.Margins.Top = New Telerik.Reporting.Drawing.Unit(1, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        Me.PageSettings.PaperKind = System.Drawing.Printing.PaperKind.Letter
        Me.Style.BackgroundColor = System.Drawing.Color.White
        Me.Style.Font.Style = System.Drawing.FontStyle.Regular
        Me.Style.TextAlign = Telerik.Reporting.Drawing.HorizontalAlign.Left
        Me.Width = New Telerik.Reporting.Drawing.Unit(6.5083332061767578, CType(Telerik.Reporting.Drawing.UnitType.Inch, Telerik.Reporting.Drawing.UnitType))
        CType(Me.SrptParts2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SrptParts1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()

    End Sub
    Friend WithEvents DetailSection1 As DetailSection
    Friend WithEvents ReportHeaderSection1 As Telerik.Reporting.ReportHeaderSection
    Friend WithEvents SqlSelectCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlConnection1 As System.Data.SqlClient.SqlConnection
    Friend WithEvents SqlDataAdapter1 As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents txtBillCompany As Telerik.Reporting.TextBox
    Friend WithEvents txtBillName As Telerik.Reporting.TextBox
    Friend WithEvents txtBillStreet As Telerik.Reporting.TextBox
    Friend WithEvents txtCity As Telerik.Reporting.TextBox
    Friend WithEvents txtShipCity As Telerik.Reporting.TextBox
    Friend WithEvents txtShipStreet As Telerik.Reporting.TextBox
    Friend WithEvents txtShipName As Telerik.Reporting.TextBox
    Friend WithEvents txtShipCompany As Telerik.Reporting.TextBox
    Friend WithEvents txtInvoiceNumber As Telerik.Reporting.TextBox
    Friend WithEvents TextBox12 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox13 As Telerik.Reporting.TextBox
    Friend WithEvents txtDateCreated As Telerik.Reporting.TextBox
    Friend WithEvents grpTicketID As Telerik.Reporting.Group
    Friend WithEvents GroupFooterSection1 As Telerik.Reporting.GroupFooterSection
    Friend WithEvents GroupHeaderSection1 As Telerik.Reporting.GroupHeaderSection
    Friend WithEvents TextBox1 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox2 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox3 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox4 As Telerik.Reporting.TextBox
    Friend WithEvents txtShipState As Telerik.Reporting.TextBox
    Friend WithEvents txtShipZipCode As Telerik.Reporting.TextBox
    Friend WithEvents TextBox10 As Telerik.Reporting.TextBox
    Friend WithEvents txtCompany As Telerik.Reporting.TextBox
    Friend WithEvents TextBox15 As Telerik.Reporting.TextBox
    Friend WithEvents txtResolutionNote As Telerik.Reporting.TextBox
    Friend WithEvents TextBox5 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox6 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox7 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox8 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox9 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox11 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox14 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox16 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox19 As Telerik.Reporting.TextBox
    Friend WithEvents txtTotalLabor As Telerik.Reporting.TextBox
    Friend WithEvents TextBox21 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox22 As Telerik.Reporting.TextBox
    Friend WithEvents txtTotalParts As Telerik.Reporting.TextBox
    Friend WithEvents txtTotalExtra As Telerik.Reporting.TextBox
    Friend WithEvents txtLaborAmount As Telerik.Reporting.TextBox
    Friend WithEvents TextBox24 As Telerik.Reporting.TextBox
    Friend WithEvents txtGrandTotal As Telerik.Reporting.TextBox
    Friend WithEvents TextBox26 As Telerik.Reporting.TextBox
    Friend WithEvents srptParts As Telerik.Reporting.SubReport
    Friend WithEvents TextBox20 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox23 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox25 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox27 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox28 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox29 As Telerik.Reporting.TextBox
    Friend WithEvents SrptParts1 As Reports.srptParts
    Friend WithEvents TextBox18 As Telerik.Reporting.TextBox
    Friend WithEvents TextBox17 As Telerik.Reporting.TextBox
    Friend WithEvents SrptParts2 As Reports.srptParts
End Class