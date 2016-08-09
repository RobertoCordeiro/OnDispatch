Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class InvoiceItemRecord
        ' Methods
        Public Sub New()
            Me._InvoiceItemID = 0
            Me._InvoiceID = 0
            Me._CreatedBy = 0
            Me._Code = ""
            Me._Description = ""
            Me._Units = 0
            Me._CostPerUnit = 0
            Me._PricePerUnit = 0
            Me._TaxRate = 0!
            Me._SubTotal = 0
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._InvoiceItemID = 0
            Me._InvoiceID = 0
            Me._CreatedBy = 0
            Me._Code = ""
            Me._Description = ""
            Me._Units = 0
            Me._CostPerUnit = 0
            Me._PricePerUnit = 0
            Me._TaxRate = 0!
            Me._SubTotal = 0
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngInvoiceItemID As Long, ByVal strConnectionString As String)
            Me._InvoiceItemID = 0
            Me._InvoiceID = 0
            Me._CreatedBy = 0
            Me._Code = ""
            Me._Description = ""
            Me._Units = 0
            Me._CostPerUnit = 0
            Me._PricePerUnit = 0
            Me._TaxRate = 0!
            Me._SubTotal = 0
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(lngInvoiceItemID)
        End Sub

        Public Sub Add(ByVal lngInvoiceID As Long, ByVal lngCreatedBy As Long, ByVal strDescription As String, ByVal dblUnits As Double, ByVal dblPricePerUnit As Double, ByVal sngTaxRate As Single)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddInvoiceItem")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = lngInvoiceID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                If (strDescription.Trim.Length <= &HFF) Then
                    cmd.Parameters.Add("@Description", SqlDbType.VarChar, strDescription.Trim.Length).Value = strDescription.Trim
                Else
                    cmd.Parameters.Add("@Description", SqlDbType.VarChar, &HFF).Value = strDescription.Trim.Substring(0, &HFF)
                End If
                cmd.Parameters.Add("@Units", SqlDbType.Float).Value = dblUnits
                cmd.Parameters.Add("@PricePerUnit", SqlDbType.Money).Value = dblPricePerUnit
                cmd.Parameters.Add("@TaxRate", SqlDbType.Float).Value = sngTaxRate
                cnn.Open
                cmd.Connection = cnn
                lngInvoiceID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                Me.Load(lngInvoiceID)
            End If
        End Sub

        Public Sub Add(ByVal lngInvoiceID As Long, ByVal lngCreatedBy As Long, ByVal strDescription As String, ByVal dblUnits As Double, ByVal dblPricePerUnit As Double, ByVal sngTaxRate As Single, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Me.Add(lngInvoiceID, lngCreatedBy, strDescription, dblUnits, dblPricePerUnit, sngTaxRate, strConnectionString)
        End Sub

        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If (strLog.Length > 0) Then
                strReturn = (strLog & Environment.NewLine)
            End If
            strReturn = (strReturn & strNewLine)
            strLog = strReturn
        End Sub

        Private Sub ClearValues()
            Me._InvoiceItemID = 0
            Me._InvoiceID = 0
            Me._CreatedBy = 0
            Me._Code = ""
            Me._Description = ""
            Me._Units = 0
            Me._PricePerUnit = 0
            Me._CostPerUnit = 0
            Me._TaxRate = 0!
            Me._SubTotal = 0
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveInvoiceItem")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InvoiceItemID", SqlDbType.Int).Value = Me._InvoiceItemID
                cnn.Open
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._InvoiceItemID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim iir As New InvoiceItemRecord(Me._InvoiceItemID, Me._ConnectionString)
                If (iir.Code <> Me._Code) Then
                    blnReturn = True
                End If
                If (iir.Description <> Me._Description) Then
                    blnReturn = True
                End If
                If (iir.Units <> Me._Units) Then
                    blnReturn = True
                End If
                If (iir.CostPerUnit <> Me._CostPerUnit) Then
                    blnReturn = True
                End If
                If (iir.PricePerUnit <> Me._PricePerUnit) Then
                    blnReturn = True
                End If
                If (iir.TaxRate <> Me._TaxRate) Then
                    blnReturn = True
                End If
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngInvoiceItemID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetInvoiceItem")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InvoiceItemID", SqlDbType.Int).Value = lngInvoiceItemID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._InvoiceItemID = Conversions.ToLong(dtr.Item("InvoiceItemID"))
                    Me._InvoiceID = Conversions.ToLong(dtr.Item("InvoiceID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Code = dtr.Item("Code").ToString
                    Me._Description = dtr.Item("Description").ToString
                    Me._Units = Conversions.ToDouble(dtr.Item("Units"))
                    Me._PricePerUnit = Conversions.ToDouble(dtr.Item("PricePerUnit"))
                    Me._TaxRate = Conversions.ToSingle(dtr.Item("TaxRate"))
                    Me._SubTotal = Conversions.ToDouble(dtr.Item("SubTotal"))
                    Me._CostPerUnit = Conversions.ToDouble(dtr.Item("CostPerUnit"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            Dim strTemp As String = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim iir As New InvoiceItemRecord(Me._InvoiceItemID, Me._ConnectionString)
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                If (iir.Code <> Me._Code) Then
                    Me.UpdateCode(Me._Code, (cnn))
                    strTemp = String.Concat(New String() { "Code changed from '", iir.Code, "' to '", Me._Code, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (iir.Description <> Me._Description) Then
                    Me.UpdateDescription(Me._Description, (cnn))
                    strTemp = String.Concat(New String() { "Description changed from '", iir.Description, "' to '", Me._Description, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (iir.Units <> Me._Units) Then
                    Me.UpdateUnits(Me._Units, (cnn))
                    strTemp = ("Units changed from " & iir.Units.ToString & " to " & Me._Units.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (iir.PricePerUnit <> Me._PricePerUnit) Then
                    Me.UpdatePricePerUnit(Me._PricePerUnit, (cnn))
                    strTemp = ("Price per Unit changed from " & Conversions.ToString(iir.PricePerUnit) & " to " & Me._PricePerUnit.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (iir.CostPerUnit <> Me._CostPerUnit) Then
                    Me.UpdateCostPerUnit(Me._CostPerUnit, (cnn))
                    strTemp = ("Price per Unit changed from " & Conversions.ToString(iir.CostPerUnit) & " to " & Me._CostPerUnit.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (iir.TaxRate <> Me._TaxRate) Then
                    Me.UpdateTaxRate(Me._TaxRate, (cnn))
                    strTemp = ("Tax Rate changed from " & Conversions.ToString(iir.TaxRate) & " to " & Me._TaxRate.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
            End If
        End Sub

        Private Sub UpdateCode(ByVal NewCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceItemCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceItemID", SqlDbType.Int).Value = Me._InvoiceItemID
            If (NewCode.Trim.Length > 0) Then
                If (NewCode.Trim.Length <= &H80) Then
                    cmd.Parameters.Add("@Code", SqlDbType.VarChar, NewCode.Trim.Length).Value = NewCode.Trim
                Else
                    cmd.Parameters.Add("@Code", SqlDbType.VarChar, &H80).Value = NewCode.Substring(0, &H80).Trim
                End If
            Else
                cmd.Parameters.Add("@Code", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCostPerUnit(ByVal NewCostPerUnit As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceItemCostPerUnit")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceItemID", SqlDbType.Int).Value = Me._InvoiceItemID
            cmd.Parameters.Add("@CostPerUnit", SqlDbType.Money).Value = NewCostPerUnit
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDescription(ByVal NewDescription As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceItemDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceItemID", SqlDbType.Int).Value = Me._InvoiceItemID
            If (NewDescription.Trim.Length > 0) Then
                If (NewDescription.Trim.Length <= &HFF) Then
                    cmd.Parameters.Add("@Description", SqlDbType.VarChar, NewDescription.Trim.Length).Value = NewDescription.Trim
                Else
                    cmd.Parameters.Add("@Description", SqlDbType.VarChar, &HFF).Value = NewDescription.Substring(0, &HFF).Trim
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdatePricePerUnit(ByVal NewPricePerUnit As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceItemPricePerUnit")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceItemID", SqlDbType.Int).Value = Me._InvoiceItemID
            cmd.Parameters.Add("@PricePerUnit", SqlDbType.Money).Value = NewPricePerUnit
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTaxRate(ByVal NewTaxRate As Single, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceItemTaxRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceItemID", SqlDbType.Int).Value = Me._InvoiceItemID
            cmd.Parameters.Add("@TaxRate", SqlDbType.Float).Value = NewTaxRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateUnits(ByVal NewUnits As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceItemUnits")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceItemID", SqlDbType.Int).Value = Me._InvoiceItemID
            cmd.Parameters.Add("@Units", SqlDbType.Float).Value = NewUnits
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property Code As String
            Get
                Return Me._Code
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H80) Then
                    Me._Code = value.Trim
                Else
                    Me._Code = value.Trim.Substring(0, &H80).Trim
                End If
            End Set
        End Property

        Public Property CostPerUnit As Double
            Get
                Return Me._CostPerUnit
            End Get
            Set(ByVal value As Double)
                Me._CostPerUnit = value
            End Set
        End Property

        Public ReadOnly Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property Description As String
            Get
                Return Me._Description
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HFF) Then
                    Me._Description = value.Trim
                Else
                    Me._Description = value.Trim.Substring(0, &HFF).Trim
                End If
            End Set
        End Property

        Public ReadOnly Property InvoiceID As Long
            Get
                Return Me._InvoiceID
            End Get
        End Property

        Public ReadOnly Property InvoiceItemID As Long
            Get
                Return Me._InvoiceItemID
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property PricePerUnit As Double
            Get
                Return Me._PricePerUnit
            End Get
            Set(ByVal value As Double)
                Me._PricePerUnit = value
            End Set
        End Property

        Public ReadOnly Property SubTotal As Double
            Get
                Return Me._SubTotal
            End Get
        End Property

        Public Property TaxRate As Single
            Get
                Return Me._TaxRate
            End Get
            Set(ByVal value As Single)
                Me._TaxRate = value
            End Set
        End Property

        Public Property Units As Double
            Get
                Return Me._Units
            End Get
            Set(ByVal value As Double)
                Me._Units = value
            End Set
        End Property


        ' Fields
        Private _Code As String
        Private _ConnectionString As String
        Private _CostPerUnit As Double
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Description As String
        Private _InvoiceID As Long
        Private _InvoiceItemID As Long
        Private _PricePerUnit As Double
        Private _SubTotal As Double
        Private _TaxRate As Single
        Private _Units As Double
        Private Const CodeMaxLength As Integer = &H80
        Private Const DescriptionMaxLength As Integer = &HFF
    End Class
End Namespace

