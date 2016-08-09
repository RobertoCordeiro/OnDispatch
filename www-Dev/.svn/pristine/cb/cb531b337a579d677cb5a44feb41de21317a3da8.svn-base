Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class PaymentRecord
        ' Methods
        Public Sub New()
            Me._PaymentID = 0
            Me._InvoiceID = 0
            Me._CreatedBy = 0
            Me._MethodID = 0
            Me._Comments = ""
            Me._TransactionNumber = ""
            Me._CheckNumber = ""
            Me._Amount = 0
            Me._DateCreated = New DateTime
            Me._Posted = False
            Me._TicketID = 0
            Me._WorkOrderID = 0
            Me._PartnerID = 0
            Me._TicketComponentID = 0
            Me._ConnectionString = ""
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PaymentID = 0
            Me._InvoiceID = 0
            Me._CreatedBy = 0
            Me._MethodID = 0
            Me._Comments = ""
            Me._TransactionNumber = ""
            Me._CheckNumber = ""
            Me._Amount = 0
            Me._DateCreated = New DateTime
            Me._Posted = False
            Me._TicketID = 0
            Me._WorkOrderID = 0
            Me._PartnerID = 0
            Me._TicketComponentID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngPaymentID As Long, ByVal strConnectionString As String)
            Me._PaymentID = 0
            Me._InvoiceID = 0
            Me._CreatedBy = 0
            Me._MethodID = 0
            Me._Comments = ""
            Me._TransactionNumber = ""
            Me._CheckNumber = ""
            Me._Amount = 0
            Me._DateCreated = New DateTime
            Me._Posted = False
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me._TicketID = 0
            Me._WorkOrderID = 0
            Me._PartnerID = 0
            Me._TicketComponentID = 0
            Me.Load(lngPaymentID)
        End Sub

        Public Sub Add(ByVal lngInvoiceID As Long, ByVal lngCreatedBy As Long, ByVal lngMethodID As Long, ByVal dblAmount As Double, ByVal datDateCreated As DateTime)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPayment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = lngInvoiceID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@MethodID", SqlDbType.Int).Value = lngMethodID
                cmd.Parameters.Add("@Amount", SqlDbType.Money).Value = dblAmount
                cmd.Parameters.Add("@datecreated", SqlDbType.SmallDateTime).Value = datDateCreated
                Dim lngPaymentID As Long = 0
                cnn.Open()
                cmd.Connection = cnn
                lngPaymentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                Me.Load(lngPaymentID)
            End If
        End Sub
        Public Sub AddJournalEntry(ByVal lngInvoiceID As Long, ByVal lngCreatedBy As Long, ByVal lngMethodID As Long, ByVal dblAmount As Double, ByVal datDateCreated As DateTime, ByVal lngPartnerID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddJournalEntry")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = lngInvoiceID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@MethodID", SqlDbType.Int).Value = lngMethodID
                cmd.Parameters.Add("@Amount", SqlDbType.Money).Value = dblAmount
                cmd.Parameters.Add("@datecreated", SqlDbType.SmallDateTime).Value = datDateCreated
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                Dim lngPaymentID As Long = 0
                cnn.Open()
                cmd.Connection = cnn
                lngPaymentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                Me.Load(lngPaymentID)
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
            Me._PaymentID = 0
            Me._InvoiceID = 0
            Me._CreatedBy = 0
            Me._MethodID = 0
            Me._Comments = ""
            Me._TransactionNumber = ""
            Me._CheckNumber = ""
            Me._Amount = 0
            Me._DateCreated = New DateTime
            Me._Posted = False
            Me._TicketID = 0
            Me._WorkOrderID = 0
            Me._PartnerID = 0
            Me._TicketComponentID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePayment")
                cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._PaymentID)
            Else
                Me.ClearValues
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim pmt As New PaymentRecord(Me._PaymentID, Me._ConnectionString)
            If (pmt.MethodID <> Me._MethodID) Then
                blnReturn = True
            End If
            If (pmt.TicketID <> Me._TicketID) Then
                blnReturn = True
            End If
            If (pmt.WorkOrderID <> Me._WorkOrderID) Then
                blnReturn = True
            End If
            If (pmt.PartnerID <> Me._PartnerID) Then
                blnReturn = True
            End If
            If (pmt.Comments <> Me._Comments) Then
                blnReturn = True
            End If
            If (pmt.TransactionNumber <> Me._TransactionNumber) Then
                blnReturn = True
            End If
            If (pmt.CheckNumber <> Me._CheckNumber) Then
                blnReturn = True
            End If
            If (pmt.Amount <> Me._Amount) Then
                blnReturn = True
            End If
            If (pmt.Posted <> Me._Posted) Then
                blnReturn = True
            End If
            If (pmt.TicketComponentID <> Me._TicketComponentID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngPaymentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPayment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = lngPaymentID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PaymentID = Conversions.ToLong(dtr.Item("PaymentID"))
                    Me._InvoiceID = Conversions.ToLong(dtr.Item("InvoiceID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._MethodID = Conversions.ToLong(dtr.Item("MethodID"))
                    Me._PartnerID = Conversions.ToLong(dtr.Item("PartnerID"))
                    Me._Comments = dtr.Item("Comments").ToString
                    Me._TransactionNumber = dtr.Item("TransactionNumber").ToString
                    Me._CheckNumber = dtr.Item("CheckNumber").ToString
                    Me._Amount = Conversions.ToDouble(dtr.Item("Amount"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._Posted = Convert.ToBoolean(RuntimeHelpers.GetObjectValue(dtr.Item("Posted")))
                    If Not IsDBNull(dtr.Item("TicketID")) Then
                        Me._TicketID = Conversions.ToLong(dtr.Item("TicketID"))
                    End If
                    If Not IsDBNull(dtr.Item("WorkOrderID")) Then
                        Me._WorkOrderID = Conversions.ToLong(dtr.Item("WorkOrderID"))
                    End If
                    If Not IsDBNull(dtr.Item("TicketComponentID")) Then
                        Me._TicketComponentID = Conversions.ToLong(dtr.Item("TicketComponentID"))
                    End If
                Else
                    Me.ClearValues()
                End If
                cnn.Close()
            Else
                Me.ClearValues()
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim pmt As New PaymentRecord(Me._PaymentID, Me._ConnectionString)
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                If (pmt.MethodID <> Me._MethodID) Then
                    Me.UpdateMethodID(Me._MethodID, (cnn))
                    strTemp = String.Concat(New String() { "Method changed from ", pmt.MethodID.ToString, "(", New PaymentMethodRecord(pmt.MethodID, Me._ConnectionString).Method, ") to ", Me._MethodID.ToString, "(", New PaymentMethodRecord(Me._MethodID, Me._ConnectionString).Method, ")" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (pmt.TicketID <> Me._TicketID) Then
                    Me.UpdateTicketID(Me._TicketID, (cnn))
                    strTemp = String.Concat(New String() {"TicketID changed from ", pmt.TicketID.ToString, "' to '", Me._TicketID, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (pmt.WorkOrderID <> Me._WorkOrderID) Then
                    Me.UpdateWorkOrderID(Me._WorkOrderID, (cnn))
                    strTemp = String.Concat(New String() {"WorkOrderID changed from ", pmt.WorkOrderID.ToString, "' to '", Me._WorkOrderID, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (pmt.PartnerID <> Me._PartnerID) Then
                    Me.UpdatePartnerID(Me._PartnerID, (cnn))
                    strTemp = String.Concat(New String() {"PartnerID changed from ", pmt.PartnerID.ToString, "' to '", Me._PartnerID, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (pmt.Comments <> Me._Comments) Then
                    Me.UpdateComments(Me._Comments, (cnn))
                    strTemp = String.Concat(New String() {"Comments changed from '", pmt.Comments, "' to '", Me._Comments.Trim, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (pmt.TransactionNumber <> Me._TransactionNumber) Then
                    Me.UpdateTransactionNumber(Me._TransactionNumber, (cnn))
                    strTemp = String.Concat(New String() { "Transaction Number changed from '", pmt.TransactionNumber, "' to '", Me._TransactionNumber.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (pmt.CheckNumber <> Me._CheckNumber) Then
                    Me.UpdateCheckNumber(Me._CheckNumber, (cnn))
                    strTemp = String.Concat(New String() { "Check Number changed from '", pmt.CheckNumber, "' to '", Me._CheckNumber, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (pmt.Amount <> Me._Amount) Then
                    Me.UpdateAmount(Me._Amount, (cnn))
                    strTemp = ("Amount changed from " & pmt.Amount.ToString & " to " & Me._Amount.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (pmt.Posted <> Me._Posted) Then
                    Me.UpdatePosted(Me._Posted, (cnn))
                    strTemp = ("Posted changed from " & pmt.Posted.ToString & " to " & Me._Posted.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (pmt.TicketComponentID <> Me._TicketComponentID) Then
                    Me.UpdateTicketComponentID(Me._TicketComponentID, (cnn))
                    strTemp = String.Concat(New String() {"TicketComponentID changed from ", pmt.TicketComponentID.ToString, "' to '", Me._TicketComponentID, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._PaymentID)
            Else
                Me.ClearValues
            End If
        End Sub

        Private Sub UpdateAmount(ByVal NewAmount As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentAmount")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            cmd.Parameters.Add("@Amount", SqlDbType.Money).Value = NewAmount
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCheckNumber(ByVal NewCheckNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentCheckNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            If (NewCheckNumber.Trim.Length <= &H40) Then
                If (NewCheckNumber.Trim.Length > 0) Then
                    cmd.Parameters.Add("@CheckNumber", SqlDbType.VarChar, NewCheckNumber.Trim.Length).Value = NewCheckNumber.Trim
                Else
                    cmd.Parameters.Add("@CheckNumber", SqlDbType.VarChar).Value = DBNull.Value
                End If
            Else
                cmd.Parameters.Add("@CheckNumber", SqlDbType.VarChar, &H40).Value = NewCheckNumber.Trim.Substring(0, &H40)
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateComments(ByVal NewComments As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentComments")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            If (NewComments.Trim.Length <= &H80) Then
                If (NewComments.Trim.Length > 0) Then
                    cmd.Parameters.Add("@Comments", SqlDbType.VarChar, NewComments.Trim.Length).Value = NewComments.Trim
                Else
                    cmd.Parameters.Add("@Comments", SqlDbType.VarChar).Value = DBNull.Value
                End If
            Else
                cmd.Parameters.Add("@Comments", SqlDbType.VarChar, &H80).Value = NewComments.Trim.Substring(0, &H80)
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMethodID(ByVal NewMethodID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentMethodID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            cmd.Parameters.Add("@MethodID", SqlDbType.Int).Value = NewMethodID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateTicketID(ByVal NewTicketID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentTicketID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = NewTicketID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateWorkOrderID(ByVal NewWorkOrderID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentWorkOrderID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = NewWorkOrderID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdatePartnerID(ByVal NewPartnerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentWorkOrderID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = NewPartnerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdatePosted(ByVal NewPosted As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentPosted")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            cmd.Parameters.Add("@Posted", SqlDbType.Bit).Value = NewPosted
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTransactionNumber(ByVal NewTransactionNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentTransactionNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            If (NewTransactionNumber.Trim.Length <= &H40) Then
                If (NewTransactionNumber.Trim.Length > 0) Then
                    cmd.Parameters.Add("@TransactionNumber", SqlDbType.VarChar, NewTransactionNumber.Trim.Length).Value = NewTransactionNumber.Trim
                Else
                    cmd.Parameters.Add("@TransactionNumber", SqlDbType.VarChar).Value = DBNull.Value
                End If
            Else
                cmd.Parameters.Add("@TransactionNumber", SqlDbType.VarChar, &H40).Value = NewTransactionNumber.Trim.Substring(0, &H40)
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateTicketComponentID(ByVal NewTicketComponentID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePaymentTicketComponentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PaymentID", SqlDbType.Int).Value = Me._PaymentID
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = NewTicketComponentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub


        ' Properties
        Public Property Amount As Double
            Get
                Return Me._Amount
            End Get
            Set(ByVal value As Double)
                Me._Amount = value
            End Set
        End Property

        Public Property CheckNumber As String
            Get
                Return Me._CheckNumber.Trim
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H40) Then
                    Me._CheckNumber = value.Trim
                Else
                    Me._CheckNumber = value.Trim.Substring(0, &H40).Trim
                End If
            End Set
        End Property

        Public Property Comments As String
            Get
                Return Me._Comments
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H80) Then
                    Me._Comments = value.Trim
                Else
                    Me._Comments = value.Trim.Substring(0, &H80).Trim
                End If
            End Set
        End Property

        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value.Trim
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

        Public ReadOnly Property InvoiceID As Long
            Get
                Return Me._InvoiceID
            End Get
        End Property
        Public Property TicketID() As Long
            Get
                Return Me._TicketID
            End Get
            Set(ByVal value As Long)
                Me._TicketID = value
            End Set
        End Property
        Public Property WorkOrderID() As Long
            Get
                Return Me._WorkOrderID
            End Get
            Set(ByVal value As Long)
                Me._WorkOrderID = value
            End Set
        End Property

        Public Property MethodID As Long
            Get
                Return Me._MethodID
            End Get
            Set(ByVal value As Long)
                Me._MethodID = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property PaymentID As Long
            Get
                Return Me._PaymentID
            End Get
        End Property
        Public ReadOnly Property PartnerID() As Long
            Get
                Return Me._PartnerID
            End Get
        End Property

        Public Property Posted As Boolean
            Get
                Return Me._Posted
            End Get
            Set(ByVal value As Boolean)
                Me._Posted = value
            End Set
        End Property

        Public Property TransactionNumber As String
            Get
                Return Me._TransactionNumber
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H40) Then
                    Me._TransactionNumber = value.Trim
                Else
                    Me._TransactionNumber = value.Trim.Substring(0, &H40).Trim
                End If
            End Set
        End Property
        Public Property TicketComponentID() As Long
            Get
                Return Me._TicketComponentID
            End Get
            Set(ByVal value As Long)
                Me._TicketComponentID = value
            End Set
        End Property


        ' Fields
        Private _Amount As Double
        Private _CheckNumber As String
        Private _Comments As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _InvoiceID As Long
        Private _MethodID As Long
        Private _PaymentID As Long
        Private _Posted As Boolean
        Private _TransactionNumber As String
        Private _TicketID As Integer
        Private _WorkOrderID As Integer
        Private _PartnerID As Integer
        Private _TicketComponentID As Integer
        Private Const CheckNumberMaxLength As Integer = &H40
        Private Const CommentsMaxLength As Integer = &H80
        Private Const TransactionNumberMaxLength As Integer = &H40
    End Class
End Namespace

