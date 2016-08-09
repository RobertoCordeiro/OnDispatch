Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class TicketDocumentRecord
        ' Methods
        Public Sub New()
            Me._TicketDocumentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._TicketDocumentTypeID = 0
            Me._FileID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues()
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._TicketDocumentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._TicketDocumentTypeID = 0
            Me._FileID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngTicketDocumentID As Long, ByVal strConnectionString As String)
            Me._TicketDocumentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._TicketDocumentTypeID = 0
            Me._FileID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._TicketDocumentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngTicketID As Long, ByVal lngTicketDocumentTypeID As Long, ByVal lngFileID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddTicketDocument")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketDocumentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cmd.Parameters.Add("@TicketDocumentTypeID", SqlDbType.Int).Value = lngTicketDocumentTypeID
                cmd.Parameters.Add("@FileID", SqlDbType.Int).Value = lngFileID
                cnn.Open()
                cmd.Connection = cnn
                lngTicketDocumentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngTicketDocumentID > 0) Then
                    Me.Load(lngTicketDocumentID)
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
            Me._TicketDocumentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._TicketDocumentTypeID = 0
            Me._FileID = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveTicketDocument")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketDocumentID", SqlDbType.Int).Value = Me._TicketDocumentID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Me.Load(Me._TicketDocumentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New TicketDocumentRecord(Me._TicketDocumentID, Me._ConnectionString)
            obj.Load(Me._TicketDocumentID)
            If (obj.TicketID <> Me._TicketID) Then
                blnReturn = True
            End If
            If (obj.TicketDocumentTypeID <> Me._TicketDocumentTypeID) Then
                blnReturn = True
            End If
            If (obj.FileID <> Me._FileID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngTicketDocumentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetTicketDocument")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketDocumentID", SqlDbType.Int).Value = lngTicketDocumentID
                cnn.Open()
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._TicketDocumentID = Conversions.ToLong(dtr.Item("TicketDocumentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._TicketID = Conversions.ToLong(dtr.Item("TicketID"))
                    Me._TicketDocumentTypeID = Conversions.ToLong(dtr.Item("TicketDocumentTypeID"))
                    Me._FileID = Conversions.ToLong(dtr.Item("FileID"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues()
                End If
                cnn.Close()
            End If
        End Sub

        Public Sub Load(ByVal lngTicketID As Long, ByVal lngTicketDocumentTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetTicketDocumentByDocumentType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cmd.Parameters.Add("@TicketDocumentTypeID", SqlDbType.Int).Value = lngTicketDocumentTypeID
                cnn.Open()
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me.Load(Conversions.ToLong(dtr.Item("TicketDocumentID")))
                Else
                    Me.ClearValues()
                End If
                cnn.Close()
                cmd.Dispose()
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open()
                Dim obj As New TicketDocumentRecord(Me._TicketDocumentID, Me._ConnectionString)
                obj.Load(Me._TicketDocumentID)
                If (obj.TicketID <> Me._TicketID) Then
                    Me.UpdateTicketID(Me._TicketID, (cnn))
                    strTemp = String.Concat(New String() {"TicketID Changed to '", Conversions.ToString(Me._TicketID), "' from '", Conversions.ToString(obj.TicketID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TicketDocumentTypeID <> Me._TicketDocumentTypeID) Then
                    Me.UpdateTicketDocumentTypeID(Me._TicketDocumentTypeID, (cnn))
                    strTemp = String.Concat(New String() {"TicketDocumentTypeID Changed to '", Conversions.ToString(Me._TicketDocumentTypeID), "' from '", Conversions.ToString(obj.TicketDocumentTypeID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.FileID <> Me._FileID) Then
                    Me.UpdateFileID(Me._FileID, (cnn))
                    strTemp = String.Concat(New String() {"FileID Changed to '", Conversions.ToString(Me._FileID), "' from '", Conversions.ToString(obj.FileID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close()
                Me.Load(Me._TicketDocumentID)
            Else
                Me.ClearValues()
            End If
        End Sub

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function

        Private Sub UpdateFileID(ByVal NewFileID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketDocumentFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketDocumentID", SqlDbType.Int).Value = Me._TicketDocumentID
            cmd.Parameters.Add("@FileID", SqlDbType.Int).Value = NewFileID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateTicketDocumentTypeID(ByVal NewTicketDocumentTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketDocumentTicketDocumentTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketDocumentID", SqlDbType.Int).Value = Me._TicketDocumentID
            cmd.Parameters.Add("@TicketDocumentTypeID", SqlDbType.Int).Value = NewTicketDocumentTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateTicketID(ByVal NewTicketID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketDocumentTicketID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketDocumentID", SqlDbType.Int).Value = Me._TicketDocumentID
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = NewTicketID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub


        ' Properties
        Public Property ConnectionString() As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

        Public ReadOnly Property CreatedBy() As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public ReadOnly Property DateCreated() As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property FileID() As Long
            Get
                Return Me._FileID
            End Get
            Set(ByVal value As Long)
                Me._FileID = value
            End Set
        End Property

        Public ReadOnly Property Modified() As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property TicketDocumentID() As Long
            Get
                Return Me._TicketDocumentID
            End Get
        End Property

        Public Property TicketDocumentTypeID() As Long
            Get
                Return Me._TicketDocumentTypeID
            End Get
            Set(ByVal value As Long)
                Me._TicketDocumentTypeID = value
            End Set
        End Property

        Public Property TicketID() As Long
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
        Private _FileID As Long
        Private _TicketDocumentID As Long
        Private _TicketDocumentTypeID As Long
        Private _TicketID As Long
    End Class
End Namespace


