Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PartnerReferenceRateRecord
        ' Methods
        Public Sub New()
            Me._PartnerReferenceRateID = 0
            Me._CreatedBy = 0
            Me._PartnerID = 0
            Me._RateTypeID = 0
            Me._Rate = 0
            Me._Hourly = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PartnerReferenceRateID = 0
            Me._CreatedBy = 0
            Me._PartnerID = 0
            Me._RateTypeID = 0
            Me._Rate = 0
            Me._Hourly = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngPartnerReferenceRateID As Long, ByVal strConnectionString As String)
            Me._PartnerReferenceRateID = 0
            Me._CreatedBy = 0
            Me._PartnerID = 0
            Me._RateTypeID = 0
            Me._Rate = 0
            Me._Hourly = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._PartnerReferenceRateID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngPartnerID As Long, ByVal lngRateTypeID As Long, ByVal dblRate As Double, ByVal blnHourly As Boolean)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerReferenceRate")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerReferenceRateID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cmd.Parameters.Add("@RateTypeID", SqlDbType.Int).Value = lngRateTypeID
                cmd.Parameters.Add("@Rate", SqlDbType.Money).Value = dblRate
                cmd.Parameters.Add("@Hourly", SqlDbType.Bit).Value = blnHourly
                cnn.Open
                cmd.Connection = cnn
                lngPartnerReferenceRateID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngPartnerReferenceRateID > 0) Then
                    Me.Load(lngPartnerReferenceRateID)
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
            Me._PartnerReferenceRateID = 0
            Me._CreatedBy = 0
            Me._PartnerID = 0
            Me._RateTypeID = 0
            Me._Rate = 0
            Me._Hourly = False
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerReferenceRate")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerReferenceRateID", SqlDbType.Int).Value = Me._PartnerReferenceRateID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._PartnerReferenceRateID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PartnerReferenceRateRecord(Me._PartnerReferenceRateID, Me._ConnectionString)
            obj.Load(Me._PartnerReferenceRateID)
            If (obj.RateTypeID <> Me._RateTypeID) Then
                blnReturn = True
            End If
            If (obj.Rate <> Me._Rate) Then
                blnReturn = True
            End If
            If (obj.Hourly <> Me._Hourly) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngPartnerReferenceRateID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerReferenceRate")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerReferenceRateID", SqlDbType.Int).Value = lngPartnerReferenceRateID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerReferenceRateID = Conversions.ToLong(dtr.Item("PartnerReferenceRateID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._PartnerID = Conversions.ToLong(dtr.Item("PartnerID"))
                    Me._RateTypeID = Conversions.ToLong(dtr.Item("RateTypeID"))
                    Me._Rate = Conversions.ToDouble(dtr.Item("Rate"))
                    Me._Hourly = Conversions.ToBoolean(dtr.Item("Hourly"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
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
                Dim obj As New PartnerReferenceRateRecord(Me._PartnerReferenceRateID, Me._ConnectionString)
                obj.Load(Me._PartnerReferenceRateID)
                If (obj.RateTypeID <> Me._RateTypeID) Then
                    Me.UpdateRateTypeID(Me._RateTypeID, (cnn))
                    strTemp = String.Concat(New String() { "RateTypeID Changed to '", Conversions.ToString(Me._RateTypeID), "' from '", Conversions.ToString(obj.RateTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Rate <> Me._Rate) Then
                    Me.UpdateRate(Me._Rate, (cnn))
                    strTemp = String.Concat(New String() { "Rate Changed to '", Conversions.ToString(Me._Rate), "' from '", Conversions.ToString(obj.Rate), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Hourly <> Me._Hourly) Then
                    Me.UpdateHourly(Me._Hourly, (cnn))
                    strTemp = String.Concat(New String() { "Hourly Changed to '", Conversions.ToString(Me._Hourly), "' from '", Conversions.ToString(obj.Hourly), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._PartnerReferenceRateID)
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

        Private Sub UpdateHourly(ByVal NewHourly As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerReferenceRateHourly")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerReferenceRateID", SqlDbType.Int).Value = Me._PartnerReferenceRateID
            cmd.Parameters.Add("@Hourly", SqlDbType.Bit).Value = NewHourly
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateRate(ByVal NewRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerReferenceRateRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerReferenceRateID", SqlDbType.Int).Value = Me._PartnerReferenceRateID
            cmd.Parameters.Add("@Rate", SqlDbType.Money).Value = NewRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateRateTypeID(ByVal NewRateTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerReferenceRateRateTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerReferenceRateID", SqlDbType.Int).Value = Me._PartnerReferenceRateID
            cmd.Parameters.Add("@RateTypeID", SqlDbType.Int).Value = NewRateTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
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

        Public Property Hourly As Boolean
            Get
                Return Me._Hourly
            End Get
            Set(ByVal value As Boolean)
                Me._Hourly = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property PartnerID As Long
            Get
                Return Me._PartnerID
            End Get
        End Property

        Public ReadOnly Property PartnerReferenceRateID As Long
            Get
                Return Me._PartnerReferenceRateID
            End Get
        End Property

        Public Property Rate As Double
            Get
                Return Me._Rate
            End Get
            Set(ByVal value As Double)
                Me._Rate = value
            End Set
        End Property

        Public Property RateTypeID As Long
            Get
                Return Me._RateTypeID
            End Get
            Set(ByVal value As Long)
                Me._RateTypeID = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Hourly As Boolean
        Private _PartnerID As Long
        Private _PartnerReferenceRateID As Long
        Private _Rate As Double
        Private _RateTypeID As Long
    End Class
End Namespace

