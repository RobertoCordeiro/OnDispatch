Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class DocumentRecord
        ' Methods
        Public Sub New()
            Me._DocumentID = 0
            Me._CreatedBy = 0
            Me._DocumentName = ""
            Me._DocumentText = ""
            Me._IsHtml = False
            Me._DateCreated = DateTime.Now
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._DocumentID = 0
            Me._CreatedBy = 0
            Me._DocumentName = ""
            Me._DocumentText = ""
            Me._IsHtml = False
            Me._DateCreated = DateTime.Now
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngDocumentID As Long, ByVal strConnectionString As String)
            Me._DocumentID = 0
            Me._CreatedBy = 0
            Me._DocumentName = ""
            Me._DocumentText = ""
            Me._IsHtml = False
            Me._InfoID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._DocumentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strDocumentName As String, ByVal strDocumentText As String, ByVal blnIsHtml As Boolean, ByVal lngInfoID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddDocument")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngDocumentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@DocumentName", SqlDbType.VarChar, Me.TrimTrunc(strDocumentName, &HFF).Length).Value = Me.TrimTrunc(strDocumentName, &HFF)
                cmd.Parameters.Add("@DocumentText", SqlDbType.Text).Value = strDocumentText
                cmd.Parameters.Add("@IsHtml", SqlDbType.Bit).Value = blnIsHtml
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = lngInfoID
                cnn.Open()
                cmd.Connection = cnn
                lngDocumentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngDocumentID > 0) Then
                    Me.Load(lngDocumentID)
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
            Me._DocumentID = 0
            Me._CreatedBy = 0
            Me._DocumentName = ""
            Me._DocumentText = ""
            Me._IsHtml = False
            Me._DateCreated = DateTime.Now
            Me._InfoID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveDocument")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@DocumentID", SqlDbType.Int).Value = Me._DocumentID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._DocumentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New DocumentRecord(Me._DocumentID, Me._ConnectionString)
            If (obj.DocumentName <> Me._DocumentName) Then
                blnReturn = True
            End If
            If (obj.DocumentText <> Me._DocumentText) Then
                blnReturn = True
            End If
            If (obj.IsHtml <> Me._IsHtml) Then
                blnReturn = True
            End If
            If obj.InfoID <> Me._InfoID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngDocumentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetDocument")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@DocumentID", SqlDbType.Int).Value = lngDocumentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._DocumentID = Conversions.ToLong(dtr.Item("DocumentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._DocumentName = dtr.Item("DocumentName").ToString
                    Me._DocumentText = dtr.Item("DocumentText").ToString
                    Me._IsHtml = Conversions.ToBoolean(dtr.Item("IsHtml"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._InfoID = Conversions.ToLong(dtr.Item("InfoID"))
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
                Dim obj As New DocumentRecord(Me._DocumentID, Me._ConnectionString)
                If (obj.DocumentName <> Me._DocumentName) Then
                    Me.UpdateDocumentName(Me._DocumentName, (cnn))
                    strTemp = String.Concat(New String() { "DocumentName Changed to '", Me._DocumentName, "' from '", obj.DocumentName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DocumentText <> Me._DocumentText) Then
                    Me.UpdateDocumentText(Me._DocumentText, (cnn))
                    strTemp = String.Concat(New String() { "DocumentText Changed to '", Me._DocumentText, "' from '", obj.DocumentText, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.IsHtml <> Me._IsHtml) Then
                    Me.UpdateIsHtml(Me._IsHtml, (cnn))
                    strTemp = String.Concat(New String() { "IsHtml Changed to '", Conversions.ToString(Me._IsHtml), "' from '", Conversions.ToString(obj.IsHtml), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.InfoID <> Me._InfoID Then
                    UpdateInfoID(Me._InfoID, cnn)
                    strTemp = "InfoID Changed to '" & Me._InfoID & "' from '" & obj.InfoID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close
                Me.Load(Me._DocumentID)
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

        Private Sub UpdateDocumentName(ByVal NewDocumentName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateDocumentDocumentName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@DocumentID", SqlDbType.Int).Value = Me._DocumentID
            cmd.Parameters.Add("@DocumentName", SqlDbType.VarChar, Me.TrimTrunc(NewDocumentName, &HFF).Length).Value = Me.TrimTrunc(NewDocumentName, &HFF)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDocumentText(ByVal NewDocumentText As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateDocumentDocumentText")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@DocumentID", SqlDbType.Int).Value = Me._DocumentID
            cmd.Parameters.Add("@DocumentText", SqlDbType.Text).Value = NewDocumentText
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateIsHtml(ByVal NewIsHtml As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateDocumentIsHtml")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@DocumentID", SqlDbType.Int).Value = Me._DocumentID
            cmd.Parameters.Add("@IsHtml", SqlDbType.Bit).Value = NewIsHtml
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateInfoID(ByVal NewInfoID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateInfoID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@DocumentID", SqlDbType.Int).Value = Me._DocumentID
            cmd.Parameters.Add("@InfoID", SqlDbType.int).value = NewInfoID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
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

        Public ReadOnly Property DocumentID As Long
            Get
                Return Me._DocumentID
            End Get
        End Property

        Public Property DocumentName As String
            Get
                Return Me._DocumentName
            End Get
            Set(ByVal value As String)
                Me._DocumentName = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property DocumentText As String
            Get
                Return Me._DocumentText
            End Get
            Set(ByVal value As String)
                Me._DocumentText = value
            End Set
        End Property

        Public Property IsHtml As Boolean
            Get
                Return Me._IsHtml
            End Get
            Set(ByVal value As Boolean)
                Me._IsHtml = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property InfoID() As Long
            Get
                Return Me._InfoID
            End Get
            Set(ByVal value As Long)
                Me._InfoID = value
            End Set
        End Property

        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _DocumentID As Long
        Private _DocumentName As String
        Private _DocumentText As String
        Private _IsHtml As Boolean
        Private _InfoID As Long = 0
        Private Const DocumentNameMaxLength As Integer = &HFF
    End Class
End Namespace

