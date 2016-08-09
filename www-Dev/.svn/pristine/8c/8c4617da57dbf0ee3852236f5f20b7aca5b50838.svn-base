Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class SkillSetQuestionRecord
        ' Methods
        Public Sub New()
            Me._SkillSetQuestionID = 0
            Me._CreatedBy = 0
            Me._Question = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._SkillSetQuestionID = 0
            Me._CreatedBy = 0
            Me._Question = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngSkillSetQuestionID As Long, ByVal strConnectionString As String)
            Me._SkillSetQuestionID = 0
            Me._CreatedBy = 0
            Me._Question = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._SkillSetQuestionID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strQuestion As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddSkillSetQuestion")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngSkillSetQuestionID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Question", SqlDbType.VarChar, Me.TrimTrunc(strQuestion, &H80).Length).Value = Me.TrimTrunc(strQuestion, &H80)
                cnn.Open
                cmd.Connection = cnn
                lngSkillSetQuestionID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngSkillSetQuestionID > 0) Then
                    Me.Load(lngSkillSetQuestionID)
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
            Me._SkillSetQuestionID = 0
            Me._CreatedBy = 0
            Me._Question = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveSkillSetQuestion")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SkillSetQuestionID", SqlDbType.Int).Value = Me._SkillSetQuestionID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._SkillSetQuestionID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New SkillSetQuestionRecord(Me._SkillSetQuestionID, Me._ConnectionString)
            obj.Load(Me._SkillSetQuestionID)
            If (obj.Question <> Me._Question) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngSkillSetQuestionID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetSkillSetQuestion")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@SkillSetQuestionID", SqlDbType.Int).Value = lngSkillSetQuestionID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._SkillSetQuestionID = Conversions.ToLong(dtr.Item("SkillSetQuestionID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Question = dtr.Item("Question").ToString
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
                Dim obj As New SkillSetQuestionRecord(Me._SkillSetQuestionID, Me._ConnectionString)
                obj.Load(Me._SkillSetQuestionID)
                If (obj.Question <> Me._Question) Then
                    Me.UpdateQuestion(Me._Question, (cnn))
                    strTemp = String.Concat(New String() { "Question Changed to '", Me._Question, "' from '", obj.Question, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._SkillSetQuestionID)
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

        Private Sub UpdateQuestion(ByVal NewQuestion As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateSkillSetQuestionQuestion")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@SkillSetQuestionID", SqlDbType.Int).Value = Me._SkillSetQuestionID
            cmd.Parameters.Add("@Question", SqlDbType.VarChar, Me.TrimTrunc(NewQuestion, &H80).Length).Value = Me.TrimTrunc(NewQuestion, &H80)
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

        Public Property Question As String
            Get
                Return Me._Question
            End Get
            Set(ByVal value As String)
                Me._Question = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public ReadOnly Property SkillSetQuestionID As Long
            Get
                Return Me._SkillSetQuestionID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Question As String
        Private _SkillSetQuestionID As Long
        Private Const QuestionMaxLength As Integer = &H80
    End Class
End Namespace

