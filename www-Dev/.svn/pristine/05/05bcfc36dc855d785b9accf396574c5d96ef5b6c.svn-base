Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class TicketStatusRecord
        ' Methods
        Public Sub New()
            Me._TicketStatusID = 0
            Me._CreatedBy = 0
            Me._Status = ""
            Me._DateCreated = DateTime.Now
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me._ProductionOrder = 0
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._TicketStatusID = 0
            Me._CreatedBy = 0
            Me._Status = ""
            Me._DateCreated = DateTime.Now
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngTicketStatusID As Long, ByVal strConnectionString As String)
            Me._TicketStatusID = 0
            Me._CreatedBy = 0
            Me._Status = ""
            Me._DateCreated = DateTime.Now
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._TicketStatusID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strStatus As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddTicketStatus")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketStatusID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Status", SqlDbType.VarChar, Me.TrimTrunc(strStatus, &H40).Length).Value = Me.TrimTrunc(strStatus, &H40)
                cnn.Open
                cmd.Connection = cnn
                lngTicketStatusID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngTicketStatusID > 0) Then
                    Me.Load(lngTicketStatusID)
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
            Me._TicketStatusID = 0
            Me._CreatedBy = 0
            Me._Status = ""
            Me._DateCreated = DateTime.Now
            Me._InfoID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveTicketStatus")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketStatusID", SqlDbType.Int).Value = Me._TicketStatusID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._TicketStatusID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New TicketStatusRecord(Me._TicketStatusID, Me._ConnectionString)
            obj.Load(Me._TicketStatusID)
            If (obj.Status <> Me._Status) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngTicketStatusID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetTicketStatus")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketStatusID", SqlDbType.Int).Value = lngTicketStatusID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._TicketStatusID = Conversions.ToLong(dtr.Item("TicketStatusID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Status = dtr.Item("Status").ToString
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    If Not IsDBNull(dtr("ProductionOrder")) Then
                        Me._ProductionOrder = CType(dtr("ProductionOrder"), Long)
                    Else
                        Me._ProductionOrder = 0
                    End If
                    If Not IsDBNull(dtr("InfoID")) Then
                        Me._ProductionOrder = CType(dtr("InfoID"), Long)
                    Else
                        Me._ProductionOrder = 0
                    End If
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
                Dim obj As New TicketStatusRecord(Me._TicketStatusID, Me._ConnectionString)
                obj.Load(Me._TicketStatusID)
                If (obj.Status <> Me._Status) Then
                    Me.UpdateStatus(Me._Status, (cnn))
                    strTemp = String.Concat(New String() { "Status Changed to '", Me._Status, "' from '", obj.Status, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ProductionOrder <> _ProductionOrder) Then
                    Me.UpdateProductionOrder(Me._ProductionOrder, (cnn))
                    strTemp = "ProductionOrder Changed to '" & _ProductionOrder & "' from '" & obj.ProductionOrder & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close
                Me.Load(Me._TicketStatusID)
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

        Private Sub UpdateStatus(ByVal NewStatus As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketStatusStatus")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketStatusID", SqlDbType.Int).Value = Me._TicketStatusID
            cmd.Parameters.Add("@Status", SqlDbType.VarChar, Me.TrimTrunc(NewStatus, &H40).Length).Value = Me.TrimTrunc(NewStatus, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateProductionOrder(ByVal NewProductionOrder As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketStatusProductionOrder")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketStatusID", SqlDbType.Int).Value = _TicketStatusID
            If NewProductionOrder > 0 Then
                cmd.Parameters.Add("@ProductionOrder", SqlDbType.Int).Value = NewProductionOrder
            Else
                cmd.Parameters.Add("@ProductionOrder", SqlDbType.Int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateInfoID(ByVal NewInfoID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketStatusInfoID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketStatusID", SqlDbType.Int).Value = _TicketStatusID
            If NewInfoID > 0 Then
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = NewInfoID
            Else
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = System.DBNull.Value
            End If
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

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property Status As String
            Get
                Return Me._Status
            End Get
            Set(ByVal value As String)
                Me._Status = Me.TrimTrunc(value, &H40)
            End Set
        End Property
        Public Property ProductionOrder() As Long
            Get
                Return _ProductionOrder
            End Get
            Set(ByVal value As Long)
                _ProductionOrder = value
            End Set
        End Property

        Public ReadOnly Property TicketStatusID As Long
            Get
                Return Me._TicketStatusID
            End Get
        End Property
        Public Property InfoID() As Long
            Get
                Return _InfoID
            End Get
            Set(ByVal value As Long)
                _InfoID = value
            End Set
        End Property



        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Status As String
        Private _TicketStatusID As Long
        Private _ProductionOrder As Long = 0
        Private _InfoID As Long = 0
        Private Const StatusMaxLength As Integer = &H40
    End Class
End Namespace

