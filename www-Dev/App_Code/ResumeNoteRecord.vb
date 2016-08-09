Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ResumeNoteRecord
        ' Methods
        Public Sub New()
            Me._ResumeNoteID = 0
            Me._ResumeID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ResumeNoteID = 0
            Me._ResumeID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngResumeNoteID As Long, ByVal strConnectionString As String)
            Me._ResumeNoteID = 0
            Me._ResumeID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ResumeNoteID)
        End Sub

        Public Sub Add(ByVal lngResumeID As Long, ByVal lngCreatedBy As Long, ByVal strNoteBody As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResumeNote")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngResumeNoteID As Long = 0
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = lngResumeID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@NoteBody", SqlDbType.Text).Value = strNoteBody
                cnn.Open
                cmd.Connection = cnn
                lngResumeNoteID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngResumeNoteID > 0) Then
                    Me.Load(lngResumeNoteID)
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
            Me._ResumeNoteID = 0
            Me._ResumeID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumeNote")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeNoteID", SqlDbType.Int).Value = Me._ResumeNoteID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ResumeNoteID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumeNoteRecord(Me._ResumeNoteID, Me._ConnectionString)
            If (obj.NoteBody <> Me._NoteBody) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngResumeNoteID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeNote")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeNoteID", SqlDbType.Int).Value = lngResumeNoteID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ResumeNoteID = Conversions.ToLong(dtr.Item("ResumeNoteID"))
                    Me._ResumeID = Conversions.ToLong(dtr.Item("ResumeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._NoteBody = dtr.Item("NoteBody").ToString
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
                Dim obj As New ResumeNoteRecord(Me._ResumeNoteID, Me._ConnectionString)
                If (obj.NoteBody <> Me._NoteBody) Then
                    Me.UpdateNoteBody(Me._NoteBody, (cnn))
                    strTemp = String.Concat(New String() { "NoteBody Changed to '", Me._NoteBody, "' from '", obj.NoteBody, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ResumeNoteID)
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

        Private Sub UpdateNoteBody(ByVal NewNoteBody As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeNoteNoteBody")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeNoteID", SqlDbType.BigInt).Value = Me._ResumeNoteID
            cmd.Parameters.Add("@NoteBody", SqlDbType.Text).Value = NewNoteBody
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

        Public Property NoteBody As String
            Get
                Return Me._NoteBody
            End Get
            Set(ByVal value As String)
                Me._NoteBody = value
            End Set
        End Property

        Public ReadOnly Property ResumeID As Long
            Get
                Return Me._ResumeID
            End Get
        End Property

        Public ReadOnly Property ResumeNoteID As Long
            Get
                Return Me._ResumeNoteID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _NoteBody As String
        Private _ResumeID As Long
        Private _ResumeNoteID As Long
    End Class
End Namespace

