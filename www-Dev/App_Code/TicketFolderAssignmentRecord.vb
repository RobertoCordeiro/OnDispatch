Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class TicketFolderAssignmentRecord
        ' Methods
        Public Sub New()
            Me._TicketFolderAssignmentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._TicketFolderID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._TicketFolderAssignmentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._TicketFolderID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngTicketFolderAssignmentID As Long, ByVal strConnectionString As String)
            Me._TicketFolderAssignmentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._TicketFolderID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._TicketFolderAssignmentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngTicketID As Long, ByVal lngTicketFolderID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddTicketFolderAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketFolderAssignmentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cmd.Parameters.Add("@TicketFolderID", SqlDbType.Int).Value = lngTicketFolderID
                cnn.Open
                cmd.Connection = cnn
                lngTicketFolderAssignmentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngTicketFolderAssignmentID > 0) Then
                    Me.Load(lngTicketFolderAssignmentID)
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
            Me._TicketFolderAssignmentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._TicketFolderID = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveTicketFolderAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketFolderAssignmentID", SqlDbType.Int).Value = Me._TicketFolderAssignmentID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._TicketFolderAssignmentID)
            End If
        End Sub
        Public Sub RemoveTicketFromFolder(ByVal lngTicketID As Long, ByVal lngTicketFolderID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveTicketFromFolder")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cmd.Parameters.Add("@FolderID", SqlDbType.Int).Value = lngTicketFolderID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Me.Load(Me._TicketFolderAssignmentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New TicketFolderAssignmentRecord(Me._TicketFolderAssignmentID, Me._ConnectionString)
            obj.Load(Me._TicketFolderAssignmentID)
            If (obj.TicketID <> Me._TicketID) Then
                blnReturn = True
            End If
            If (obj.TicketFolderID <> Me._TicketFolderID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngTicketFolderAssignmentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetTicketFolderAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketFolderAssignmentID", SqlDbType.Int).Value = lngTicketFolderAssignmentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._TicketFolderAssignmentID = Conversions.ToLong(dtr.Item("TicketFolderAssignmentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._TicketID = Conversions.ToLong(dtr.Item("TicketID"))
                    Me._TicketFolderID = Conversions.ToLong(dtr.Item("TicketFolderID"))
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
                Dim obj As New TicketFolderAssignmentRecord(Me._TicketFolderAssignmentID, Me._ConnectionString)
                obj.Load(Me._TicketFolderAssignmentID)
                If (obj.TicketID <> Me._TicketID) Then
                    Me.UpdateTicketID(Me._TicketID, (cnn))
                    strTemp = String.Concat(New String() { "TicketID Changed to '", Conversions.ToString(Me._TicketID), "' from '", Conversions.ToString(obj.TicketID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TicketFolderID <> Me._TicketFolderID) Then
                    Me.UpdateTicketFolderID(Me._TicketFolderID, (cnn))
                    strTemp = String.Concat(New String() { "TicketFolderID Changed to '", Conversions.ToString(Me._TicketFolderID), "' from '", Conversions.ToString(obj.TicketFolderID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._TicketFolderAssignmentID)
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

        Private Sub UpdateTicketFolderID(ByVal NewTicketFolderID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketFolderAssignmentTicketFolderID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketFolderAssignmentID", SqlDbType.BigInt).Value = Me._TicketFolderAssignmentID
            cmd.Parameters.Add("@TicketFolderID", SqlDbType.Int).Value = NewTicketFolderID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTicketID(ByVal NewTicketID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketFolderAssignmentTicketID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketFolderAssignmentID", SqlDbType.BigInt).Value = Me._TicketFolderAssignmentID
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = NewTicketID
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

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property TicketFolderAssignmentID As Long
            Get
                Return Me._TicketFolderAssignmentID
            End Get
        End Property

        Public Property TicketFolderID As Long
            Get
                Return Me._TicketFolderID
            End Get
            Set(ByVal value As Long)
                Me._TicketFolderID = value
            End Set
        End Property

        Public Property TicketID As Long
            Get
                Return Me._TicketID
            End Get
            Set(ByVal value As Long)
                Me._TicketID = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _TicketFolderAssignmentID As Long
        Private _TicketFolderID As Long
        Private _TicketID As Long
    End Class
End Namespace

