Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ResumeFolderAssignmentRecord
        ' Methods
        Public Sub New()
            Me._AssignmentID = 0
            Me._ResumeID = 0
            Me._FolderID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._ResumeID = 0
            Me._FolderID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngAssignmentID As Long, ByVal strConnectionString As String)
            Me._AssignmentID = 0
            Me._ResumeID = 0
            Me._FolderID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._AssignmentID)
        End Sub

        Public Sub Add(ByVal lngResumeID As Long, ByVal lngFolderID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResumeFolderAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngAssignmentID As Long = 0
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = lngResumeID
                cmd.Parameters.Add("@FolderID", SqlDbType.Int).Value = lngFolderID
                cnn.Open
                cmd.Connection = cnn
                lngAssignmentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngAssignmentID > 0) Then
                    Me.Load(lngAssignmentID)
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
            Me._AssignmentID = 0
            Me._ResumeID = 0
            Me._FolderID = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumeFolderAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = Me._AssignmentID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._AssignmentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumeFolderAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
            If (obj.ResumeID <> Me._ResumeID) Then
                blnReturn = True
            End If
            If (obj.FolderID <> Me._FolderID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngAssignmentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeFolderAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AssignmentID", SqlDbType.Int).Value = lngAssignmentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._AssignmentID = Conversions.ToLong(dtr.Item("AssignmentID"))
                    Me._ResumeID = Conversions.ToLong(dtr.Item("ResumeID"))
                    Me._FolderID = Conversions.ToLong(dtr.Item("FolderID"))
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
                Dim obj As New ResumeFolderAssignmentRecord(Me._AssignmentID, Me._ConnectionString)
                If (obj.ResumeID <> Me._ResumeID) Then
                    Me.UpdateResumeID(Me._ResumeID, (cnn))
                    strTemp = String.Concat(New String() { "ResumeID Changed to '", Conversions.ToString(Me._ResumeID), "' from '", Conversions.ToString(obj.ResumeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.FolderID <> Me._FolderID) Then
                    Me.UpdateFolderID(Me._FolderID, (cnn))
                    strTemp = String.Concat(New String() { "FolderID Changed to '", Conversions.ToString(Me._FolderID), "' from '", Conversions.ToString(obj.FolderID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._AssignmentID)
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

        Private Sub UpdateFolderID(ByVal NewFolderID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeFolderAssignmentFolderID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@FolderID", SqlDbType.Int).Value = NewFolderID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateResumeID(ByVal NewResumeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeFolderAssignmentResumeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@AssignmentID", SqlDbType.BigInt).Value = Me._AssignmentID
            cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = NewResumeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public ReadOnly Property AssignmentID As Long
            Get
                Return Me._AssignmentID
            End Get
        End Property

        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property FolderID As Long
            Get
                Return Me._FolderID
            End Get
            Set(ByVal value As Long)
                Me._FolderID = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property ResumeID As Long
            Get
                Return Me._ResumeID
            End Get
            Set(ByVal value As Long)
                Me._ResumeID = value
            End Set
        End Property


        ' Fields
        Private _AssignmentID As Long
        Private _ConnectionString As String
        Private _DateCreated As DateTime
        Private _FolderID As Long
        Private _ResumeID As Long
    End Class
End Namespace

