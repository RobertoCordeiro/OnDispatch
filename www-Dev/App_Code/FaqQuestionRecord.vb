Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class FaqQuestionRecord
        ' Methods
        Public Sub New()
            Me._FaqQuestionID = 0
            Me._FaqID = 0
            Me._CreatedBy = 0
            Me._Question = ""
            Me._Answer = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._FaqQuestionID = 0
            Me._FaqID = 0
            Me._CreatedBy = 0
            Me._Question = ""
            Me._Answer = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngFaqQuestionID As Long, ByVal strConnectionString As String)
            Me._FaqQuestionID = 0
            Me._FaqID = 0
            Me._CreatedBy = 0
            Me._Question = ""
            Me._Answer = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._FaqQuestionID)
        End Sub

        Public Sub Add(ByVal lngFaqID As Long, ByVal lngCreatedBy As Long, ByVal strQuestion As String, ByVal strAnswer As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddFaqQuestion")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngFaqQuestionID As Long = 0
                cmd.Parameters.Add("@FaqID", SqlDbType.Int).Value = lngFaqID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Question", SqlDbType.VarChar, Me.TrimTrunc(strQuestion, &HFF).Length).Value = Me.TrimTrunc(strQuestion, &HFF)
                cmd.Parameters.Add("@Answer", SqlDbType.Text).Value = strAnswer
                cnn.Open
                cmd.Connection = cnn
                lngFaqQuestionID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngFaqQuestionID > 0) Then
                    Me.Load(lngFaqQuestionID)
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
            Me._FaqQuestionID = 0
            Me._FaqID = 0
            Me._CreatedBy = 0
            Me._Question = ""
            Me._Answer = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveFaqQuestion")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@FaqQuestionID", SqlDbType.Int).Value = Me._FaqQuestionID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._FaqQuestionID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New FaqQuestionRecord(Me._FaqQuestionID, Me._ConnectionString)
            obj.Load(Me._FaqQuestionID)
            If (obj.Question <> Me._Question) Then
                blnReturn = True
            End If
            If (obj.Answer <> Me._Answer) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngFaqQuestionID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetFaqQuestion")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@FaqQuestionID", SqlDbType.Int).Value = lngFaqQuestionID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._FaqQuestionID = Conversions.ToLong(dtr.Item("FaqQuestionID"))
                    Me._FaqID = Conversions.ToLong(dtr.Item("FaqID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Question = dtr.Item("Question").ToString
                    Me._Answer = dtr.Item("Answer").ToString
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
                Dim obj As New FaqQuestionRecord(Me._FaqQuestionID, Me._ConnectionString)
                obj.Load(Me._FaqQuestionID)
                If (obj.Question <> Me._Question) Then
                    Me.UpdateQuestion(Me._Question, (cnn))
                    strTemp = String.Concat(New String() { "Question Changed to '", Me._Question, "' from '", obj.Question, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Answer <> Me._Answer) Then
                    Me.UpdateAnswer(Me._Answer, (cnn))
                    strTemp = String.Concat(New String() { "Answer Changed to '", Me._Answer, "' from '", obj.Answer, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._FaqQuestionID)
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

        Private Sub UpdateAnswer(ByVal NewAnswer As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateFaqQuestionAnswer")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@FaqQuestionID", SqlDbType.Int).Value = Me._FaqQuestionID
            cmd.Parameters.Add("@Answer", SqlDbType.Text).Value = NewAnswer
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateQuestion(ByVal NewQuestion As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateFaqQuestionQuestion")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@FaqQuestionID", SqlDbType.Int).Value = Me._FaqQuestionID
            cmd.Parameters.Add("@Question", SqlDbType.VarChar, Me.TrimTrunc(NewQuestion, &HFF).Length).Value = Me.TrimTrunc(NewQuestion, &HFF)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property Answer As String
            Get
                Return Me._Answer
            End Get
            Set(ByVal value As String)
                Me._Answer = value
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

        Public ReadOnly Property FaqID As Long
            Get
                Return Me._FaqID
            End Get
        End Property

        Public ReadOnly Property FaqQuestionID As Long
            Get
                Return Me._FaqQuestionID
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
                Me._Question = Me.TrimTrunc(value, &HFF)
            End Set
        End Property


        ' Fields
        Private _Answer As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _FaqID As Long
        Private _FaqQuestionID As Long
        Private _Question As String
        Private Const QuestionMaxLength As Integer = &HFF
    End Class
End Namespace

