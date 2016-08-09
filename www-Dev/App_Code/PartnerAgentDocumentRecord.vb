Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PartnerAgentDocumentRecord
        ' Methods
        Public Sub New()
            Me._PartnerAgentDocumentID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._PartnerDocumentTypeID = 0
            Me._FileID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues()
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PartnerAgentDocumentID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._PartnerDocumentTypeID = 0
            Me._FileID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngPartnerAgentDocumentID As Long, ByVal strConnectionString As String)
            Me._PartnerAgentDocumentID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._PartnerDocumentTypeID = 0
            Me._FileID = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._PartnerAgentDocumentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngPartnerAgentID As Long, ByVal lngPartnerDocumentTypeID As Long, ByVal lngFileID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerAgentDocument")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerAgentDocumentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@PartnerDocumentTypeID", SqlDbType.Int).Value = lngPartnerDocumentTypeID
                cmd.Parameters.Add("@FileID", SqlDbType.Int).Value = lngFileID
                cnn.Open()
                cmd.Connection = cnn
                lngPartnerAgentDocumentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngPartnerAgentDocumentID > 0) Then
                    Me.Load(lngPartnerAgentDocumentID)
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
            Me._PartnerAgentDocumentID = 0
            Me._CreatedBy = 0
            Me._PartnerAgentID = 0
            Me._PartnerDocumentTypeID = 0
            Me._FileID = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerAgentDocument")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentDocumentID", SqlDbType.Int).Value = Me._PartnerAgentDocumentID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Me.Load(Me._PartnerAgentDocumentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PartnerAgentDocumentRecord(Me._PartnerAgentDocumentID, Me._ConnectionString)
            obj.Load(Me._PartnerAgentDocumentID)
            If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                blnReturn = True
            End If
            If (obj.PartnerDocumentTypeID <> Me._PartnerDocumentTypeID) Then
                blnReturn = True
            End If
            If (obj.FileID <> Me._FileID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngPartnerAgentDocumentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentDocument")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentDocumentID", SqlDbType.Int).Value = lngPartnerAgentDocumentID
                cnn.Open()
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerAgentDocumentID = Conversions.ToLong(dtr.Item("PartnerAgentDocumentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._PartnerAgentID = Conversions.ToLong(dtr.Item("PartnerAgentID"))
                    Me._PartnerDocumentTypeID = Conversions.ToLong(dtr.Item("PartnerDocumentTypeID"))
                    Me._FileID = Conversions.ToLong(dtr.Item("FileID"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues()
                End If
                cnn.Close()
            End If
        End Sub

        Public Sub Load(ByVal lngPartnerAgentID As Long, ByVal lngPartnerDocumentTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentDocumentByDocumentType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@PartnerDocumentTypeID", SqlDbType.Int).Value = lngPartnerDocumentTypeID
                cnn.Open()
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me.Load(Conversions.ToLong(dtr.Item("PartnerAgentDocumentID")))
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
                Dim obj As New PartnerAgentDocumentRecord(Me._PartnerAgentDocumentID, Me._ConnectionString)
                obj.Load(Me._PartnerAgentDocumentID)
                If (obj.PartnerAgentID <> Me._PartnerAgentID) Then
                    Me.UpdatePartnerAgentID(Me._PartnerAgentID, (cnn))
                    strTemp = String.Concat(New String() {"PartnerAgentID Changed to '", Conversions.ToString(Me._PartnerAgentID), "' from '", Conversions.ToString(obj.PartnerAgentID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerDocumentTypeID <> Me._PartnerDocumentTypeID) Then
                    Me.UpdatePartnerDocumentTypeID(Me._PartnerDocumentTypeID, (cnn))
                    strTemp = String.Concat(New String() {"PartnerDocumentTypeID Changed to '", Conversions.ToString(Me._PartnerDocumentTypeID), "' from '", Conversions.ToString(obj.PartnerDocumentTypeID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.FileID <> Me._FileID) Then
                    Me.UpdateFileID(Me._FileID, (cnn))
                    strTemp = String.Concat(New String() {"FileID Changed to '", Conversions.ToString(Me._FileID), "' from '", Conversions.ToString(obj.FileID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close()
                Me.Load(Me._PartnerAgentDocumentID)
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
            Dim cmd As New SqlCommand("spUpdatePartnerAgentDocumentFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentDocumentID", SqlDbType.Int).Value = Me._PartnerAgentDocumentID
            cmd.Parameters.Add("@FileID", SqlDbType.Int).Value = NewFileID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdatePartnerDocumentTypeID(ByVal NewPartnerDocumentTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentDocumentPartnerDocumentTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentDocumentID", SqlDbType.Int).Value = Me._PartnerAgentDocumentID
            cmd.Parameters.Add("@PartnerDocumentTypeID", SqlDbType.Int).Value = NewPartnerDocumentTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdatePartnerAgentID(ByVal NewPartnerAgentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentDocumentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentDocumentID", SqlDbType.Int).Value = Me._PartnerAgentDocumentID
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = NewPartnerAgentID
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

        Public ReadOnly Property PartnerAgentDocumentID() As Long
            Get
                Return Me._PartnerAgentDocumentID
            End Get
        End Property

        Public Property PartnerDocumentTypeID() As Long
            Get
                Return Me._PartnerDocumentTypeID
            End Get
            Set(ByVal value As Long)
                Me._PartnerDocumentTypeID = value
            End Set
        End Property

        Public Property PartnerAgentID() As Long
            Get
                Return Me._PartnerAgentID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAgentID = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _FileID As Long
        Private _PartnerAgentDocumentID As Long
        Private _PartnerDocumentTypeID As Long
        Private _PartnerAgentID As Long
    End Class
End Namespace

