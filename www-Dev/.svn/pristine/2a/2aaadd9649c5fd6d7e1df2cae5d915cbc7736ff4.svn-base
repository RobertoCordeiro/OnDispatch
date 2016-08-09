Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class FaqRecord
        ' Methods
        Public Sub New()
            Me._FaqID = 0
            Me._Title = ""
            Me._CreatedBy = 0
            Me._PublicFaq = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._FaqID = 0
            Me._Title = ""
            Me._CreatedBy = 0
            Me._PublicFaq = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngFaqID As Long, ByVal strConnectionString As String)
            Me._FaqID = 0
            Me._Title = ""
            Me._CreatedBy = 0
            Me._PublicFaq = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._FaqID)
        End Sub

        Public Sub Add(ByVal strTitle As String, ByVal lngCreatedBy As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddFaq")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngFaqID As Long = 0
                cmd.Parameters.Add("@Title", SqlDbType.VarChar, Me.TrimTrunc(strTitle, &H80).Length).Value = Me.TrimTrunc(strTitle, &H80)
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cnn.Open
                cmd.Connection = cnn
                lngFaqID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngFaqID > 0) Then
                    Me.Load(lngFaqID)
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
            Me._FaqID = 0
            Me._Title = ""
            Me._CreatedBy = 0
            Me._PublicFaq = False
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveFaq")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@FaqID", SqlDbType.Int).Value = Me._FaqID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._FaqID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New FaqRecord(Me._FaqID, Me._ConnectionString)
            obj.Load(Me._FaqID)
            If (obj.Title <> Me._Title) Then
                blnReturn = True
            End If
            If (obj.PublicFaq <> Me._PublicFaq) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngFaqID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetFaq")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@FaqID", SqlDbType.Int).Value = lngFaqID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._FaqID = Conversions.ToLong(dtr.Item("FaqID"))
                    Me._Title = dtr.Item("Title").ToString
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._PublicFaq = Conversions.ToBoolean(dtr.Item("PublicFAQ"))
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
                Dim obj As New FaqRecord(Me._FaqID, Me._ConnectionString)
                obj.Load(Me._FaqID)
                If (obj.Title <> Me._Title) Then
                    Me.UpdateTitle(Me._Title, (cnn))
                    strTemp = String.Concat(New String() { "Title Changed to '", Me._Title, "' from '", obj.Title, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                Me.UpdatePublicFaq(Me._PublicFaq, (cnn))
                cnn.Close
                Me.Load(Me._FaqID)
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

        Private Sub UpdatePublicFaq(ByVal NewPublicFaq As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateFaqPublicFaq")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@FaqID", SqlDbType.Int).Value = Me._FaqID
            If NewPublicFaq Then
                cmd.Parameters.Add("@PublicFaq", SqlDbType.Bit).Value = 1
            Else
                cmd.Parameters.Add("@PublicFaq", SqlDbType.Bit).Value = 0
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTitle(ByVal NewTitle As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateFaqTitle")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@FaqID", SqlDbType.Int).Value = Me._FaqID
            cmd.Parameters.Add("@Title", SqlDbType.VarChar, Me.TrimTrunc(NewTitle, &H80).Length).Value = Me.TrimTrunc(NewTitle, &H80)
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

        Public ReadOnly Property FaqID As Long
            Get
                Return Me._FaqID
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property PublicFaq As Boolean
            Get
                Return Me._PublicFaq
            End Get
            Set(ByVal value As Boolean)
                Me._PublicFaq = value
            End Set
        End Property

        Public Property Title As String
            Get
                Return Me._Title
            End Get
            Set(ByVal value As String)
                Me._Title = Me.TrimTrunc(value, &H80)
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _FaqID As Long
        Private _PublicFaq As Boolean
        Private _Title As String
        Private Const TitleMaxLength As Integer = &H80
    End Class
End Namespace

