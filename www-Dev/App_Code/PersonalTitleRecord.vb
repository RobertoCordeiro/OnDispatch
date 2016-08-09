Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PersonalTitleRecord
        ' Methods
        Public Sub New()
            Me._TitleID = 0
            Me._CreatedBy = 0
            Me._Title = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._TitleID = 0
            Me._CreatedBy = 0
            Me._Title = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngTitleID As Long, ByVal strConnectionString As String)
            Me._TitleID = 0
            Me._CreatedBy = 0
            Me._Title = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._TitleID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strTitle As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPersonalTitle")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTitleID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Title", SqlDbType.VarChar, Me.TrimTrunc(strTitle, &H10).Length).Value = Me.TrimTrunc(strTitle, &H10)
                cnn.Open
                cmd.Connection = cnn
                lngTitleID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngTitleID > 0) Then
                    Me.Load(lngTitleID)
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
            Me._TitleID = 0
            Me._CreatedBy = 0
            Me._Title = ""
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePersonalTitle")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TitleID", SqlDbType.Int).Value = Me._TitleID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._TitleID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PersonalTitleRecord(Me._TitleID, Me._ConnectionString)
            If (obj.Title <> Me._Title) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngTitleID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPersonalTitle")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TitleID", SqlDbType.Int).Value = lngTitleID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._TitleID = Conversions.ToLong(dtr.Item("TitleID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Title = dtr.Item("Title").ToString
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
                Dim obj As New PersonalTitleRecord(Me._TitleID, Me._ConnectionString)
                If (obj.Title <> Me._Title) Then
                    Me.UpdateTitle(Me._Title, (cnn))
                    strTemp = String.Concat(New String() { "Title Changed to '", Me._Title, "' from '", obj.Title, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._TitleID)
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

        Private Sub UpdateTitle(ByVal NewTitle As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePersonalTitleTitle")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TitleID", SqlDbType.Int).Value = Me._TitleID
            cmd.Parameters.Add("@Title", SqlDbType.VarChar, Me.TrimTrunc(NewTitle, &H10).Length).Value = Me.TrimTrunc(NewTitle, &H10)
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

        Public Property Title As String
            Get
                Return Me._Title
            End Get
            Set(ByVal value As String)
                Me._Title = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public ReadOnly Property TitleID As Long
            Get
                Return Me._TitleID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Title As String
        Private _TitleID As Long
        Private Const TitleMaxLength As Integer = &H10
    End Class
End Namespace

