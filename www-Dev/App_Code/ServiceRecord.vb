Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ServiceRecord
        ' Methods
        Public Sub New()
            Me._ServiceID = 0
            Me._CreatedBy = 0
            Me._ServiceTypeID = 0
            Me._PayIncrementID = 0
            Me._ServiceName = ""
            Me._MinimumCharge = 0
            Me._AdjustmentCharge = 0
            Me._FlatRate = 0
            Me._ChargeRate = 0
            Me._Description = ""
            Me._Instructions = ""
            Me._Active = False
            Me._DefaultPartnerFlatRate = 0
            Me._DefaultPartnerHourlyRate = 0
            Me._DefaultPartnerMinTimeOnSite = 1
            Me._DefaultPartnerIncrement = 13
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ServiceID = 0
            Me._CreatedBy = 0
            Me._ServiceTypeID = 0
            Me._PayIncrementID = 0
            Me._ServiceName = ""
            Me._MinimumCharge = 0
            Me._AdjustmentCharge = 0
            Me._ChargeRate = 0
            Me._FlatRate = 0
            Me._Description = ""
            Me._Instructions = ""
            Me._Active = False
            Me._DefaultPartnerFlatRate = 0
            Me._DefaultPartnerHourlyRate = 0
            Me._DefaultPartnerMinTimeOnSite = 1
            Me._DefaultPartnerIncrement = 13
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngServiceID As Long, ByVal strConnectionString As String)
            Me._ServiceID = 0
            Me._CreatedBy = 0
            Me._ServiceTypeID = 0
            Me._PayIncrementID = 0
            Me._ServiceName = ""
            Me._MinimumCharge = 0
            Me._AdjustmentCharge = 0
            Me._ChargeRate = 0
            Me._FlatRate = 0
            Me._Description = ""
            Me._Instructions = ""
            Me._Active = False
            Me._DefaultPartnerFlatRate = 0
            Me._DefaultPartnerHourlyRate = 0
            Me._DefaultPartnerMinTimeOnSite = 1
            Me._DefaultPartnerIncrement = 13
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ServiceID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngServiceTypeID As Long, ByVal lngPayIncrementID As Long, ByVal strServiceName As String, ByVal strDescription As String, ByVal strInstructions As String, ByVal dbFlatRate As Double, ByVal dbChargeRate As Double, ByVal lngMinimumCharge As Long, ByVal dbDefaultPartnerFlatRate As Double, ByVal dbDefaultPartnerHourlyRate As Double, ByVal dbDefaultPartnerMinTimeOnSite As Long, ByVal dbDefaultPartnerIncrement As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddService")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngServiceID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = lngServiceTypeID
                cmd.Parameters.Add("@PayIncrementID", SqlDbType.Int).Value = lngPayIncrementID
                cmd.Parameters.Add("@ServiceName", SqlDbType.VarChar, Me.TrimTrunc(strServiceName, &H20).Length).Value = Me.TrimTrunc(strServiceName, &H20)
                cmd.Parameters.Add("@Description", SqlDbType.Text).Value = strDescription
                cmd.Parameters.Add("@Instructions", SqlDbType.Text).Value = strInstructions
                cmd.Parameters.Add("@FlatRate", SqlDbType.Money).Value = dbFlatRate
                cmd.Parameters.Add("@ChargeRate", SqlDbType.Money).Value = dbChargeRate 'hourly rate
                cmd.Parameters.Add("@MinimumCharge", SqlDbType.Int).Value = lngMinimumCharge 'MinTimeOnSite
                cmd.Parameters.Add("@DefaultPartnerFlatRate", SqlDbType.Money).Value = dbDefaultPartnerFlatRate
                cmd.Parameters.Add("@DefaultPartnerHourlyRate", SqlDbType.Money).Value = dbDefaultPartnerHourlyRate
                cmd.Parameters.Add("@DefaultPartnerMinTimeOnSite", SqlDbType.Money).Value = dbDefaultPartnerMinTimeOnSite
                cmd.Parameters.Add("@DefaultPartnerIncrement", SqlDbType.Money).Value = dbDefaultPartnerIncrement
                cnn.Open()
                cmd.Connection = cnn
                lngServiceID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngServiceID > 0) Then
                    Me.Load(lngServiceID)
                End If
            End If
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
            Me._ServiceID = 0
            Me._CreatedBy = 0
            Me._ServiceTypeID = 0
            Me._PayIncrementID = 0
            Me._ServiceName = ""
            Me._MinimumCharge = 0
            Me._AdjustmentCharge = 0
            Me._ChargeRate = 0
            Me._FlatRate = 0
            Me._Description = ""
            Me._Instructions = ""
            Me._Active = False
            Me._DefaultPartnerFlatRate = 0
            Me._DefaultPartnerHourlyRate = 0
            Me._DefaultPartnerMinTimeOnSite = 1
            Me._DefaultPartnerIncrement = 13
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveService")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ServiceID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ServiceRecord(Me._ServiceID, Me._ConnectionString)
            obj.Load(Me._ServiceID)
            If (obj.ServiceTypeID <> Me._ServiceTypeID) Then
                blnReturn = True
            End If
            If (obj.PayIncrementID <> Me._PayIncrementID) Then
                blnReturn = True
            End If
            If (obj.ServiceName <> Me._ServiceName) Then
                blnReturn = True
            End If
            If (obj.MinimumCharge <> Me._MinimumCharge) Then
                blnReturn = True
            End If
            If (obj.AdjustmentCharge <> Me._AdjustmentCharge) Then
                blnReturn = True
            End If
            If (obj.ChargeRate <> Me._ChargeRate) Then
                blnReturn = True
            End If
            If (obj.FlatRate <> Me._FlatRate) Then
                blnReturn = True
            End If
            If (obj.Description <> Me._Description) Then
                blnReturn = True
            End If
            If (obj.Instructions <> Me._Instructions) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            If (obj.DefaultPartnerFlatRate <> Me._DefaultPartnerFlatRate) Then
                blnReturn = True
            End If
            If (obj.DefaultPartnerHourlyRate <> Me._DefaultPartnerHourlyRate) Then
                blnReturn = True
            End If
            If (obj.DefaultPartnerMinTimeOnSite <> Me._DefaultPartnerMinTimeOnSite) Then
                blnReturn = True
            End If
            If (obj.DefaultPartnerIncrement <> Me._DefaultPartnerIncrement) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngServiceID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetService")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = lngServiceID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ServiceID = Conversions.ToLong(dtr.Item("ServiceID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._ServiceTypeID = Conversions.ToLong(dtr.Item("ServiceTypeID"))
                    Me._PayIncrementID = Conversions.ToLong(dtr.Item("PayIncrementID"))
                    Me._ServiceName = dtr.Item("ServiceName").ToString
                    Me._MinimumCharge = Conversions.ToDouble(dtr.Item("MinimumCharge"))
                    Me._AdjustmentCharge = Conversions.ToDouble(dtr.Item("AdjustmentCharge"))
                    Me._ChargeRate = Conversions.ToDouble(dtr.Item("ChargeRate"))
                    Me._FlatRate = Conversions.ToDouble(dtr.Item("FlatRate"))
                    Me._Description = dtr.Item("Description").ToString
                    Me._Instructions = dtr.Item("Instructions").ToString
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._DefaultPartnerFlatRate = Conversions.ToDouble(dtr.Item("DefaultPartnerFlatRate"))
                    Me._DefaultPartnerHourlyRate = Conversions.ToDouble(dtr.Item("DefaultPartnerHourlyRate"))
                    Me._DefaultPartnerMinTimeOnSite = Conversions.ToLong(dtr.Item("DefaultPartnerMinTimeOnSite"))
                    Me._DefaultPartnerIncrement = Conversions.ToLong(dtr.Item("DefaultPartnerIncrement"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New ServiceRecord(Me._ServiceID, Me._ConnectionString)
                obj.Load(Me._ServiceID)
                If (obj.ServiceTypeID <> Me._ServiceTypeID) Then
                    Me.UpdateServiceTypeID(Me._ServiceTypeID, (cnn))
                    strTemp = String.Concat(New String() { "ServiceTypeID Changed to '", Conversions.ToString(Me._ServiceTypeID), "' from '", Conversions.ToString(obj.ServiceTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PayIncrementID <> Me._PayIncrementID) Then
                    Me.UpdatePayIncrementID(Me._PayIncrementID, (cnn))
                    strTemp = String.Concat(New String() { "PayIncrementID Changed to '", Conversions.ToString(Me._PayIncrementID), "' from '", Conversions.ToString(obj.PayIncrementID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ServiceName <> Me._ServiceName) Then
                    Me.UpdateServiceName(Me._ServiceName, (cnn))
                    strTemp = String.Concat(New String() { "ServiceName Changed to '", Me._ServiceName, "' from '", obj.ServiceName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MinimumCharge <> Me._MinimumCharge) Then
                    Me.UpdateMinimumCharge(Me._MinimumCharge, (cnn))
                    strTemp = String.Concat(New String() { "MinimumCharge Changed to '", Conversions.ToString(Me._MinimumCharge), "' from '", Conversions.ToString(obj.MinimumCharge), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AdjustmentCharge <> Me._AdjustmentCharge) Then
                    Me.UpdateAdjustmentCharge(Me._AdjustmentCharge, (cnn))
                    strTemp = String.Concat(New String() { "AdjustmentCharge Changed to '", Conversions.ToString(Me._AdjustmentCharge), "' from '", Conversions.ToString(obj.AdjustmentCharge), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ChargeRate <> Me._ChargeRate) Then
                    Me.UpdateChargeRate(Me._ChargeRate, (cnn))
                    strTemp = String.Concat(New String() { "ChargeRate Changed to '", Conversions.ToString(Me._ChargeRate), "' from '", Conversions.ToString(obj.ChargeRate), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.FlatRate <> Me._FlatRate) Then
                    Me.UpdateFlatRate(Me._FlatRate, (cnn))
                    strTemp = String.Concat(New String() {"FlatRate Changed to '", Conversions.ToString(Me._FlatRate), "' from '", Conversions.ToString(obj.FlatRate), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Description <> Me._Description) Then
                    Me.UpdateDescription(Me._Description, (cnn))
                    strTemp = String.Concat(New String() { "Description Changed to '", Me._Description, "' from '", obj.Description, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Instructions <> Me._Instructions) Then
                    Me.UpdateInstructions(Me._Instructions, (cnn))
                    strTemp = String.Concat(New String() { "Instructions Changed to '", Me._Instructions, "' from '", obj.Instructions, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DefaultPartnerFlatRate <> Me._DefaultPartnerFlatRate) Then
                    Me.UpdateDefaultPartnerFlatRate(Me._DefaultPartnerFlatRate, (cnn))
                    strTemp = String.Concat(New String() {"DefaultPartnerFlatRate Changed to '", Conversions.ToString(Me._DefaultPartnerFlatRate), "' from '", Conversions.ToString(obj.DefaultPartnerFlatRate), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DefaultPartnerHourlyRate <> Me._DefaultPartnerHourlyRate) Then
                    Me.UpdateDefaultPartnerHourlyRate(Me._DefaultPartnerHourlyRate, (cnn))
                    strTemp = String.Concat(New String() {"DefaultPartnerHourlyRate Changed to '", Conversions.ToString(Me._DefaultPartnerHourlyRate), "' from '", Conversions.ToString(obj.DefaultPartnerHourlyRate), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DefaultPartnerMinTimeOnSite <> Me._DefaultPartnerMinTimeOnSite) Then
                    Me.UpdateDefaultPartnerMinTimeOnSite(Me._DefaultPartnerMinTimeOnSite, (cnn))
                    strTemp = String.Concat(New String() {"DefaultPartnerMinTimeOnSite Changed to '", Conversions.ToString(Me._DefaultPartnerMinTimeOnSite), "' from '", Conversions.ToString(obj.DefaultPartnerMinTimeOnSite), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DefaultPartnerIncrement <> Me._DefaultPartnerIncrement) Then
                    Me.UpdateDefaultPartnerIncrement(Me._DefaultPartnerIncrement, (cnn))
                    strTemp = String.Concat(New String() {"DefaultPartnerIncrement Changed to '", Conversions.ToString(Me._DefaultPartnerIncrement), "' from '", Conversions.ToString(obj.DefaultPartnerIncrement), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ServiceID)
            Else
                Me.ClearValues
            End If
        End Sub

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function

        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAdjustmentCharge(ByVal NewAdjustmentCharge As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceAdjustmentCharge")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@AdjustmentCharge", SqlDbType.Money).Value = NewAdjustmentCharge
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateChargeRate(ByVal NewChargeRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceChargeRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@ChargeRate", SqlDbType.Money).Value = NewChargeRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateFlatRate(ByVal NewFlatRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceFlatRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@FlatRate", SqlDbType.Money).Value = NewFlatRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateDescription(ByVal NewDescription As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@Description", SqlDbType.Text).Value = NewDescription
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateInstructions(ByVal NewInstructions As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceInstructions")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@Instructions", SqlDbType.Text).Value = NewInstructions
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMinimumCharge(ByVal NewMinimumCharge As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceMinimumCharge")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@MinimumCharge", SqlDbType.Money).Value = NewMinimumCharge
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePayIncrementID(ByVal NewPayIncrementID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServicePayIncrementID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@PayIncrementID", SqlDbType.Int).Value = NewPayIncrementID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateServiceName(ByVal NewServiceName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceServiceName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@ServiceName", SqlDbType.VarChar, Me.TrimTrunc(NewServiceName, &H20).Length).Value = Me.TrimTrunc(NewServiceName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateServiceTypeID(ByVal NewServiceTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceServiceTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = NewServiceTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateDefaultPartnerFlatRate(ByVal NewDefaultPartnerFlatRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceDefaultPartnerFlatRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@DefaultPartnerFlatRate", SqlDbType.Money).Value = NewDefaultPartnerFlatRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateDefaultPartnerHourlyRate(ByVal NewDefaultPartnerHourlyRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceDefaultPartnerHourlyRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@DefaultPartnerHourlyRate", SqlDbType.Money).Value = NewDefaultPartnerHourlyRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateDefaultPartnerMinTimeOnSite(ByVal NewDefaultPartnerMinTimeOnSite As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceDefaultPartnerMinTimeOnSite")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@DefaultPartnerMinTimeOnSite", SqlDbType.Int).Value = NewDefaultPartnerMinTimeOnSite
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateDefaultPartnerIncrement(ByVal NewDefaultPartnerIncrement As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceDefaultPartnerIncrement")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = Me._ServiceID
            cmd.Parameters.Add("@DefaultPartnerIncrement", SqlDbType.Int).Value = NewDefaultPartnerIncrement
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub




        ' Properties
        Public Property Active As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
            End Set
        End Property

        Public Property AdjustmentCharge As Double
            Get
                Return Me._AdjustmentCharge
            End Get
            Set(ByVal value As Double)
                Me._AdjustmentCharge = value
            End Set
        End Property

        Public Property ChargeRate As Double
            Get
                Return Me._ChargeRate
            End Get
            Set(ByVal value As Double)
                Me._ChargeRate = value
            End Set
        End Property
        Public Property FlatRate() As Double
            Get
                Return Me._FlatRate
            End Get
            Set(ByVal value As Double)
                Me._FlatRate = value
            End Set
        End Property

        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
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
                Me._Description = value
            End Set
        End Property

        Public Property Instructions As String
            Get
                Return Me._Instructions
            End Get
            Set(ByVal value As String)
                Me._Instructions = value
            End Set
        End Property

        Public Property MinimumCharge As Double
            Get
                Return Me._MinimumCharge
            End Get
            Set(ByVal value As Double)
                Me._MinimumCharge = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property PayIncrementID As Long
            Get
                Return Me._PayIncrementID
            End Get
            Set(ByVal value As Long)
                Me._PayIncrementID = value
            End Set
        End Property

        Public ReadOnly Property ServiceID As Long
            Get
                Return Me._ServiceID
            End Get
        End Property

        Public Property ServiceName As String
            Get
                Return Me._ServiceName
            End Get
            Set(ByVal value As String)
                Me._ServiceName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property ServiceTypeID As Long
            Get
                Return Me._ServiceTypeID
            End Get
            Set(ByVal value As Long)
                Me._ServiceTypeID = value
            End Set
        End Property
        Public Property DefaultPartnerFlatRate() As Double
            Get
                Return Me._DefaultPartnerFlatRate
            End Get
            Set(ByVal value As Double)
                Me._DefaultPartnerFlatRate = value
            End Set
        End Property
        Public Property DefaultPartnerHourlyRate() As Double
            Get
                Return Me._DefaultPartnerHourlyRate
            End Get
            Set(ByVal value As Double)
                Me._DefaultPartnerHourlyRate = value
            End Set
        End Property
        Public Property DefaultPartnerMinTimeOnSite() As Long
            Get
                Return Me._DefaultPartnerMinTimeOnSite
            End Get
            Set(ByVal value As Long)
                Me._DefaultPartnerMinTimeOnSite = value
            End Set
        End Property
        Public Property DefaultPartnerIncrement() As Long
            Get
                Return Me._DefaultPartnerIncrement
            End Get
            Set(ByVal value As Long)
                Me._DefaultPartnerIncrement = value
            End Set
        End Property


        ' Fields
        Private _Active As Boolean
        Private _AdjustmentCharge As Double
        Private _ChargeRate As Double
        Private _FlatRate As Double
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Description As String
        Private _Instructions As String
        Private _MinimumCharge As Double
        Private _PayIncrementID As Long
        Private _ServiceID As Long
        Private _ServiceName As String
        Private _ServiceTypeID As Long
        Private _DefaultPartnerFlatRate As Double
        Private _DefaultPartnerHourlyRate As Double
        Private _DefaultPartnerIncrement As Long
        Private _DefaultPartnerMinTimeOnSite As Long
        Private Const ServiceNameMaxLength As Integer = &H20
    End Class
End Namespace

