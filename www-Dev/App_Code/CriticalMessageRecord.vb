Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CriticalMessageRecord
        ' Methods
        Public Sub New()
            Me._MessageID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._DeliveredBy = 0
            Me._Message = ""
            Me._TimeOnScreen = 0
            Me._DateDelivered = New DateTime
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._MessageID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._DeliveredBy = 0
            Me._Message = ""
            Me._TimeOnScreen = 0
            Me._DateDelivered = New DateTime
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngMessageID As Long, ByVal strConnectionString As String)
            Me._MessageID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._DeliveredBy = 0
            Me._Message = ""
            Me._TimeOnScreen = 0
            Me._DateDelivered = New DateTime
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._MessageID)
        End Sub

        Public Sub Add(ByVal lngCustomerID As Long, ByVal lngCreatedBy As Long, ByVal strMessage As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCriticalMessage")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngMessageID As Long = 0
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Message", SqlDbType.Text).Value = strMessage
                cnn.Open
                cmd.Connection = cnn
                lngMessageID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngMessageID > 0) Then
                    Me.Load(lngMessageID)
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
            Me._MessageID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._DeliveredBy = 0
            Me._Message = ""
            Me._TimeOnScreen = 0
            Me._DateDelivered = New DateTime
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCriticalMessage")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@MessageID", SqlDbType.Int).Value = Me._MessageID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._MessageID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CriticalMessageRecord(Me._MessageID, Me._ConnectionString)
            If (obj.DeliveredBy <> Me._DeliveredBy) Then
                blnReturn = True
            End If
            If (obj.Message <> Me._Message) Then
                blnReturn = True
            End If
            If (obj.TimeOnScreen <> Me._TimeOnScreen) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DateDelivered, Me._DateDelivered) <> 0) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngMessageID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCriticalMessage")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@MessageID", SqlDbType.Int).Value = lngMessageID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._MessageID = Conversions.ToLong(dtr.Item("MessageID"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._DeliveredBy = Conversions.ToLong(dtr.Item("DeliveredBy"))
                    Me._Message = dtr.Item("Message").ToString
                    Me._TimeOnScreen = Conversions.ToDouble(dtr.Item("TimeOnScreen"))
                    Me._DateDelivered = Conversions.ToDate(dtr.Item("DateDelivered"))
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
                Dim obj As New CriticalMessageRecord(Me._MessageID, Me._ConnectionString)
                If (obj.DeliveredBy <> Me._DeliveredBy) Then
                    Me.UpdateDeliveredBy(Me._DeliveredBy, (cnn))
                    strTemp = String.Concat(New String() { "DeliveredBy Changed from '", Conversions.ToString(Me._DeliveredBy), "' to '", Conversions.ToString(obj.DeliveredBy), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Message <> Me._Message) Then
                    Me.UpdateMessage(Me._Message, (cnn))
                    strTemp = String.Concat(New String() { "Message Changed from '", Me._Message, "' to '", obj.Message, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TimeOnScreen <> Me._TimeOnScreen) Then
                    Me.UpdateTimeOnScreen(Me._TimeOnScreen, (cnn))
                    strTemp = String.Concat(New String() { "TimeOnScreen Changed from '", Conversions.ToString(Me._TimeOnScreen), "' to '", Conversions.ToString(obj.TimeOnScreen), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.DateDelivered, Me._DateDelivered) <> 0) Then
                    Me.UpdateDateDelivered((Me._DateDelivered), (cnn))
                    strTemp = String.Concat(New String() { "DateDelivered Changed from '", Conversions.ToString(Me._DateDelivered), "' to '", Conversions.ToString(obj.DateDelivered), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._MessageID)
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

        Private Sub UpdateDateDelivered(ByRef NewDateDelivered As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCriticalMessageDateDelivered")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@MessageID", SqlDbType.Int).Value = Me._MessageID
            If (NewDateDelivered.Year > 1) Then
                cmd.Parameters.Add("@DateDelivered", SqlDbType.DateTime).Value = CDate(NewDateDelivered)
            Else
                cmd.Parameters.Add("@DateDelivered", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDeliveredBy(ByVal NewDeliveredBy As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCriticalMessageDeliveredBy")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@MessageID", SqlDbType.Int).Value = Me._MessageID
            If (NewDeliveredBy > 0) Then
                cmd.Parameters.Add("@DeliveredBy", SqlDbType.Int).Value = NewDeliveredBy
            Else
                cmd.Parameters.Add("@DeliveredBy", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMessage(ByVal NewMessage As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCriticalMessageMessage")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@MessageID", SqlDbType.Int).Value = Me._MessageID
            cmd.Parameters.Add("@Message", SqlDbType.Text).Value = NewMessage
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTimeOnScreen(ByVal NewTimeOnScreen As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCriticalMessageTimeOnScreen")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@MessageID", SqlDbType.Int).Value = Me._MessageID
            cmd.Parameters.Add("@TimeOnScreen", SqlDbType.Float).Value = NewTimeOnScreen
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

        Public ReadOnly Property CustomerID As Long
            Get
                Return Me._CustomerID
            End Get
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property DateDelivered As DateTime
            Get
                Return Me._DateDelivered
            End Get
            Set(ByVal value As DateTime)
                Me._DateDelivered = value
            End Set
        End Property

        Public Property DeliveredBy As Long
            Get
                Return Me._DeliveredBy
            End Get
            Set(ByVal value As Long)
                Me._DeliveredBy = value
            End Set
        End Property

        Public Property Message As String
            Get
                Return Me._Message
            End Get
            Set(ByVal value As String)
                Me._Message = value
            End Set
        End Property

        Public ReadOnly Property MessageID As Long
            Get
                Return Me._MessageID
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property TimeOnScreen As Double
            Get
                Return Me._TimeOnScreen
            End Get
            Set(ByVal value As Double)
                Me._TimeOnScreen = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerID As Long
        Private _DateCreated As DateTime
        Private _DateDelivered As DateTime
        Private _DeliveredBy As Long
        Private _Message As String
        Private _MessageID As Long
        Private _TimeOnScreen As Double
    End Class
End Namespace

