Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class EntityTypeRecord
        ' Methods
        Public Sub New()
            Me._EntityTypeID = 0
            Me._CreatedBy = 0
            Me._EntityType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._EntityTypeID = 0
            Me._CreatedBy = 0
            Me._EntityType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngEntityTypeID As Long, ByVal strConnectionString As String)
            Me._EntityTypeID = 0
            Me._CreatedBy = 0
            Me._EntityType = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._EntityTypeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strEntityType As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddEntityType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngEntityTypeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@EntityType", SqlDbType.VarChar, Me.TrimTrunc(strEntityType, &H20).Length).Value = Me.TrimTrunc(strEntityType, &H20)
                cnn.Open
                cmd.Connection = cnn
                lngEntityTypeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngEntityTypeID > 0) Then
                    Me.Load(lngEntityTypeID)
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
            Me._EntityTypeID = 0
            Me._CreatedBy = 0
            Me._EntityType = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveEntityType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@EntityTypeID", SqlDbType.Int).Value = Me._EntityTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._EntityTypeID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New EntityTypeRecord(Me._EntityTypeID, Me._ConnectionString)
            If (obj.EntityType <> Me._EntityType) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngEntityTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetEntityType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@EntityTypeID", SqlDbType.Int).Value = lngEntityTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._EntityTypeID = Conversions.ToLong(dtr.Item("EntityTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._EntityType = dtr.Item("EntityType").ToString
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
                Dim obj As New EntityTypeRecord(Me._EntityTypeID, Me._ConnectionString)
                If (obj.EntityType <> Me._EntityType) Then
                    Me.UpdateEntityType(Me._EntityType, (cnn))
                    strTemp = String.Concat(New String() { "EntityType Changed to '", Me._EntityType, "' from '", obj.EntityType, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._EntityTypeID)
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

        Private Sub UpdateEntityType(ByVal NewEntityType As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateEntityTypeEntityType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@EntityTypeID", SqlDbType.Int).Value = Me._EntityTypeID
            cmd.Parameters.Add("@EntityType", SqlDbType.VarChar, Me.TrimTrunc(NewEntityType, &H20).Length).Value = Me.TrimTrunc(NewEntityType, &H20)
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

        Public Property EntityType As String
            Get
                Return Me._EntityType
            End Get
            Set(ByVal value As String)
                Me._EntityType = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public ReadOnly Property EntityTypeID As Long
            Get
                Return Me._EntityTypeID
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _EntityType As String
        Private _EntityTypeID As Long
        Private Const EntityTypeMaxLength As Integer = &H20
    End Class
End Namespace

