Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class RateTypeRecord
        ' Methods
        Public Sub New()
            Me._RateTypeID = 0
            Me._CreatedBy = 0
            Me._Description = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._Active = True
            Me._DefaultRate = 0
            Me._Hourly = False
            Me._ResumeTypeID = 0
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._RateTypeID = 0
            Me._CreatedBy = 0
            Me._Description = ""
            Me._DateCreated = DateTime.Now
            Me._Active = True
            Me._DefaultRate = 0
            Me._Hourly = False
            Me._ResumeTypeID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngRateTypeID As Long, ByVal strConnectionString As String)
            Me._RateTypeID = 0
            Me._CreatedBy = 0
            Me._Description = ""
            Me._DateCreated = DateTime.Now
            Me._Active = True
            Me._DefaultRate = 0
            Me._Hourly = False
            Me._ResumeTypeID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._RateTypeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strDescription As String, ByVal boolActive As Boolean, ByVal dbDefaultRate As Double, ByVal boolHourly As Boolean, ByVal lngResumeTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddRateType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngRateTypeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Description", SqlDbType.VarChar, Me.TrimTrunc(strDescription, &H40).Length).Value = Me.TrimTrunc(strDescription, &H40)
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = boolActive
                cmd.Parameters.Add("@DefaultRate", SqlDbType.Money).Value = dbDefaultRate
                cmd.Parameters.Add("@Hourly", SqlDbType.Bit).Value = boolHourly
                cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = DateTime.Now
                cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = lngResumeTypeID
                cnn.Open()
                cmd.Connection = cnn
                lngRateTypeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngRateTypeID > 0) Then
                    Me.Load(lngRateTypeID)
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
            Me._RateTypeID = 0
            Me._CreatedBy = 0
            Me._Description = ""
            Me._Active = True
            Me._DefaultRate = 0
            Me._Hourly = False
            Me._ResumeTypeID = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveRateType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RateTypeID", SqlDbType.Int).Value = Me._RateTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._RateTypeID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New RateTypeRecord(Me._RateTypeID, Me._ConnectionString)
            obj.Load(Me._RateTypeID)
            If (obj.Description <> Me._Description) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngRateTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetRateType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RateTypeID", SqlDbType.Int).Value = lngRateTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._RateTypeID = Conversions.ToLong(dtr.Item("RateTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Description = dtr.Item("Description").ToString
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DefaultRate = Conversions.ToDouble(dtr.Item("DefaultRate"))
                    Me._Hourly = Conversions.ToBoolean(dtr.Item("Hourly"))
                    Me._ResumeTypeID = Conversions.ToLong(dtr.Item("ResumeTypeID"))
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
                cnn.Open()

                Dim obj As New RateTypeRecord(Me._RateTypeID, Me._ConnectionString)
                obj.Load(Me._RateTypeID)

                If (obj.Description <> Me._Description) Then
                    Me.UpdateDescription(Me._Description, (cnn))
                    strTemp = String.Concat(New String() {"Description Changed to '", Me._Description, "' from '", obj.Description, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DefaultRate <> Me._DefaultRate) Then
                    Me.UpdateDefaultRate(Me._DefaultRate, (cnn))
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                End If
                If (obj.Hourly <> Me._Hourly) Then
                    Me.UpdateHourly(Me._Hourly, (cnn))
                End If
                If (obj.ResumeTypeID <> Me._ResumeTypeID) Then
                    Me.UpdateResumeTypeID(Me._ResumeTypeID, (cnn))
                End If
                cnn.Close
                Me.Load(Me._RateTypeID)
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

        Private Sub UpdateDescription(ByVal NewDescription As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRateTypeDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RateTypeID", SqlDbType.Int).Value = Me._RateTypeID
            cmd.Parameters.Add("@Description", SqlDbType.VarChar, Me.TrimTrunc(NewDescription, &H40).Length).Value = Me.TrimTrunc(NewDescription, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDefaultRate(ByVal NewDefaultRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRateTypeDefaultRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RateTypeID", SqlDbType.Int).Value = Me._RateTypeID
            cmd.Parameters.Add("@DefaultRate", SqlDbType.Money).Value = NewDefaultRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRateTypeActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RateTypeID", SqlDbType.Int).Value = Me._RateTypeID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateHourly(ByVal NewHourly As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRateTypeHourly")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RateTypeID", SqlDbType.Int).Value = Me._RateTypeID
            cmd.Parameters.Add("@Hourly", SqlDbType.Bit).Value = NewHourly
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateResumeTypeID(ByVal NewResumeTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRateTypeResumeTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RateTypeID", SqlDbType.Int).Value = Me._RateTypeID
            cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = NewResumeTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        ' Properties
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
                Me._Description = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property RateTypeID As Long
            Get
                Return Me._RateTypeID
            End Get
        End Property

        Public Property DefaultRate() As Double
            Get
                Return Me._DefaultRate
            End Get
            Set(ByVal value As Double)
                Me._DefaultRate = value
            End Set
        End Property
        Public Property Active() As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
            End Set
        End Property
        Public Property Hourly() As Boolean
            Get
                Return Me._Hourly
            End Get
            Set(ByVal value As Boolean)
                Me._Hourly = value
            End Set
        End Property
        Public Property ResumeTypeID() As Long
            Get
                Return Me._ResumeTypeID
            End Get
            Set(ByVal value As Long)
                Me._ResumeTypeID = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Description As String
        Private _RateTypeID As Long
        Private _Active As Boolean
        Private _DefaultRate As Double
        Private _Hourly As Boolean
        Private _ResumeTypeID As Long
        Private Const DescriptionMaxLength As Integer = &H40
    End Class
End Namespace

