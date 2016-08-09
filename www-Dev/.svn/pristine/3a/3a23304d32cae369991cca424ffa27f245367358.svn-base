Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PayIncrementRecord
        ' Methods
        Public Sub New()
            Me._IncrementTypeID = 0
            Me._CreatedBy = 0
            Me._IncrementType = ""
            Me._Units = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._IncrementTypeID = 0
            Me._CreatedBy = 0
            Me._IncrementType = ""
            Me._Units = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngIncrementTypeID As Long, ByVal strConnectionString As String)
            Me._IncrementTypeID = 0
            Me._CreatedBy = 0
            Me._IncrementType = ""
            Me._Units = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._IncrementTypeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strIncrementType As String, ByVal lngUnits As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPayIncrement")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngIncrementTypeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@IncrementType", SqlDbType.VarChar, Me.TrimTrunc(strIncrementType, &H10).Length).Value = Me.TrimTrunc(strIncrementType, &H10)
                cmd.Parameters.Add("@Units", SqlDbType.BigInt).Value = lngUnits
                cnn.Open
                cmd.Connection = cnn
                lngIncrementTypeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngIncrementTypeID > 0) Then
                    Me.Load(lngIncrementTypeID)
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
            Me._IncrementTypeID = 0
            Me._CreatedBy = 0
            Me._IncrementType = ""
            Me._Units = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePayIncrement")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@IncrementTypeID", SqlDbType.Int).Value = Me._IncrementTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._IncrementTypeID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PayIncrementRecord(Me._IncrementTypeID, Me._ConnectionString)
            obj.Load(Me._IncrementTypeID)
            If (obj.IncrementType <> Me._IncrementType) Then
                blnReturn = True
            End If
            If (obj.Units <> Me._Units) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngIncrementTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPayIncrement")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@IncrementTypeID", SqlDbType.Int).Value = lngIncrementTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._IncrementTypeID = Conversions.ToLong(dtr.Item("IncrementTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._IncrementType = dtr.Item("IncrementType").ToString
                    Me._Units = Conversions.ToLong(dtr.Item("Units"))
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
                Dim obj As New PayIncrementRecord(Me._IncrementTypeID, Me._ConnectionString)
                obj.Load(Me._IncrementTypeID)
                If (obj.IncrementType <> Me._IncrementType) Then
                    Me.UpdateIncrementType(Me._IncrementType, (cnn))
                    strTemp = String.Concat(New String() { "IncrementType Changed to '", Me._IncrementType, "' from '", obj.IncrementType, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Units <> Me._Units) Then
                    Me.UpdateUnits(Me._Units, (cnn))
                    strTemp = String.Concat(New String() { "Units Changed to '", Conversions.ToString(Me._Units), "' from '", Conversions.ToString(obj.Units), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._IncrementTypeID)
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

        Private Sub UpdateIncrementType(ByVal NewIncrementType As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePayIncrementIncrementType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@IncrementTypeID", SqlDbType.Int).Value = Me._IncrementTypeID
            cmd.Parameters.Add("@IncrementType", SqlDbType.VarChar, Me.TrimTrunc(NewIncrementType, &H10).Length).Value = Me.TrimTrunc(NewIncrementType, &H10)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateUnits(ByVal NewUnits As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePayIncrementUnits")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@IncrementTypeID", SqlDbType.Int).Value = Me._IncrementTypeID
            cmd.Parameters.Add("@Units", SqlDbType.BigInt).Value = NewUnits
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

        Public Property IncrementType As String
            Get
                Return Me._IncrementType
            End Get
            Set(ByVal value As String)
                Me._IncrementType = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public ReadOnly Property IncrementTypeID As Long
            Get
                Return Me._IncrementTypeID
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property Units As Long
            Get
                Return Me._Units
            End Get
            Set(ByVal value As Long)
                Me._Units = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _IncrementType As String
        Private _IncrementTypeID As Long
        Private _Units As Long
        Private Const IncrementTypeMaxLength As Integer = &H10
    End Class
End Namespace

