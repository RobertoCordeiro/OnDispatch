Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface

    Public Class JournalEntryRecord

#Region "Private Members"

        Private _JournalEntryID As Long = 0
        Private _PartnerID As Long = 0
        Private _CustomerID As Long = 0
        Private _Amount As Double = 0
        Private _InvoiceID As Long = 0
        Private _TicketID As Long = 0
        Private _WorkOrderID As Long = 0
        Private _Notes As String = ""
        Private _DateCreated As Date = Now()
        Private _EndPayPeriod As Date = Now()
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the PartnerID field for the currently loaded record
        ''' </summary>
        Public Property PartnerID() As Long
            Get
                Return _PartnerID
            End Get
            Set(ByVal value As Long)
                _PartnerID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the CustomerID field for the currently loaded record
        ''' </summary>
        Public Property CustomerID() As Long
            Get
                Return _CustomerID
            End Get
            Set(ByVal value As Long)
                _CustomerID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Amount field for the currently loaded record
        ''' </summary>
        Public Property Amount() As Double
            Get
                Return _Amount
            End Get
            Set(ByVal value As Double)
                _Amount = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the InvoiceID field for the currently loaded record
        ''' </summary>
        Public Property InvoiceID() As Long
            Get
                Return _InvoiceID
            End Get
            Set(ByVal value As Long)
                _InvoiceID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the TicketID field for the currently loaded record
        ''' </summary>
        Public Property TicketID() As Long
            Get
                Return _TicketID
            End Get
            Set(ByVal value As Long)
                _TicketID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the WorkOrderID field for the currently loaded record
        ''' </summary>
        Public Property WorkOrderID() As Long
            Get
                Return _WorkOrderID
            End Get
            Set(ByVal value As Long)
                _WorkOrderID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Notes field for the currently loaded record
        ''' </summary>
        Public Property Notes() As String
            Get
                Return _Notes
            End Get
            Set(ByVal value As String)
                _Notes = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the DateCreated field for the currently loaded record
        ''' </summary>
        Public Property DateCreated() As Date
            Get
                Return _DateCreated
            End Get
            Set(ByVal value As Date)
                _DateCreated = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the EndPayPeriod field for the currently loaded record
        ''' </summary>
        Public Property EndPayPeriod() As Date
            Get
                Return _EndPayPeriod
            End Get
            Set(ByVal value As Date)
                _EndPayPeriod = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the connection string to the database
        ''' </summary>
        Public Property ConnectionString() As String
            Get
                Return _ConnectionString
            End Get
            Set(ByVal value As String)
                _ConnectionString = value
            End Set
        End Property

#End Region

#Region "ReadOnly Properties"

        ''' <summary>
        ''' Returns the JournalEntryID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property JournalEntryID() As Long
            Get
                Return _JournalEntryID
            End Get
        End Property

        ''' <summary>
        ''' Returns a boolean value indicating if the object has changed
        ''' since the last time it was loaded.
        ''' </summary>
        Public ReadOnly Property Modified() As Boolean
            Get
                Return HasChanged()
            End Get
        End Property

#End Region

#Region "Private Sub-Routines"

        ''' <summary>
        ''' Clears all values except for the connection string
        ''' </summary>
        Private Sub ClearValues()
            _JournalEntryID = 0
            _PartnerID = 0
            _CustomerID = 0
            _Amount = 0
            _InvoiceID = 0
            _TicketID = 0
            _WorkOrderID = 0
            _Notes = ""
            _DateCreated = Now()
            _EndPayPeriod = Now()
        End Sub

        ''' <summary>
        ''' Appends a line to a change log
        ''' </summary>
        ''' <param name="strLog">The log to append to</param>
        ''' <param name="strNewLine">The line to append to the log</param>
        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If strLog.Length > 0 Then
                strReturn = strLog & Environment.NewLine
            End If
            strReturn &= strNewLine
            strLog = strReturn
        End Sub

        ''' <summary>
        ''' Updates the PartnerID field for this record.
        ''' </summary>
        ''' <param name="NewPartnerID">The new value for thePartnerID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerID(ByVal NewPartnerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateJournalEntryPartnerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = NewPartnerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the CustomerID field for this record.
        ''' </summary>
        ''' <param name="NewCustomerID">The new value for theCustomerID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCustomerID(ByVal NewCustomerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateJournalEntryCustomerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = NewCustomerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Amount field for this record.
        ''' </summary>
        ''' <param name="NewAmount">The new value for theAmount field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateAmount(ByVal NewAmount As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateJournalEntryAmount")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
            cmd.Parameters.Add("@Amount", SqlDbType.Money).Value = NewAmount
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the InvoiceID field for this record.
        ''' </summary>
        ''' <param name="NewInvoiceID">The new value for theInvoiceID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateInvoiceID(ByVal NewInvoiceID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateJournalEntryInvoiceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = NewInvoiceID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the TicketID field for this record.
        ''' </summary>
        ''' <param name="NewTicketID">The new value for theTicketID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTicketID(ByVal NewTicketID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateJournalEntryTicketID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
            cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = NewTicketID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the WorkOrderID field for this record.
        ''' </summary>
        ''' <param name="NewWorkOrderID">The new value for theWorkOrderID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateWorkOrderID(ByVal NewWorkOrderID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateJournalEntryWorkOrderID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
            cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = NewWorkOrderID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Notes field for this record.
        ''' </summary>
        ''' <param name="NewNotes">The new value for theNotes field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateNotes(ByVal NewNotes As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateJournalEntryNotes")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
            cmd.Parameters.Add("@Notes", SqlDbType.Text).Value = NewNotes
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the DateCreated field for this record.
        ''' </summary>
        ''' <param name="NewDateCreated">The new value for theDateCreated field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDateCreated(ByVal NewDateCreated As Date, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateJournalEntryDateCreated")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
            cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = NewDateCreated
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the EndPayPeriod field for this record.
        ''' </summary>
        ''' <param name="NewEndPayPeriod">The new value for theEndPayPeriod field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateEndPayPeriod(ByVal NewEndPayPeriod As Date, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateJournalEntryEndPayPeriod")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
            cmd.Parameters.Add("@EndPayPeriod", SqlDbType.DateTime).Value = NewEndPayPeriod
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

#End Region

#Region "Private Functions"

        ''' <summary>
        ''' Returns a string that has been trimmed and trunced down to its max length
        ''' </summary>
        ''' <param name="strInput">The string to manipulate</param>
        ''' <param name="intMaxLength">The maximum length the string can be</param>
        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If strReturn.Trim.Length <= intMaxLength Then
                strReturn = strReturn.Trim
            Else
                strReturn = strReturn.Substring(0, intMaxLength)
                strReturn = strReturn.Trim
            End If
            Return strReturn
        End Function

        ''' <summary>
        ''' Returns a boolean indicating if the object has changed
        ''' </summary>
        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New JournalEntryRecord(_JournalEntryID, _ConnectionString)
            obj.Load(_JournalEntryID)
            If obj.PartnerID <> _PartnerID Then
                blnReturn = True
            End If
            If obj.CustomerID <> _CustomerID Then
                blnReturn = True
            End If
            If obj.Amount <> _Amount Then
                blnReturn = True
            End If
            If obj.InvoiceID <> _InvoiceID Then
                blnReturn = True
            End If
            If obj.TicketID <> _TicketID Then
                blnReturn = True
            End If
            If obj.WorkOrderID <> _WorkOrderID Then
                blnReturn = True
            End If
            If obj.Notes <> _Notes Then
                blnReturn = True
            End If
            If obj.DateCreated <> _DateCreated Then
                blnReturn = True
            End If
            If obj.EndPayPeriod <> _EndPayPeriod Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region

#Region "Public Sub-Routines"

        ''' <summary>
        ''' Overloaded, initializes the object
        ''' </summary>
        Public Sub New()
            ClearValues()
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object with a given connection string
        ''' </summary>
        ''' <param name="strConnectionString">The connection string to the database the customer is contained in</param>
        Public Sub New(ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object and loads by the passed in Primary Key
        ''' </summary>
        ''' <param name="lngJournalEntryID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngJournalEntryID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_JournalEntryID)
        End Sub

        ''' <summary>
        '''  Adds a new JournalEntry record to the database.
        ''' </summary>
        ''' <param name="lngPartnerID">The value for the PartnerID portion of the record</param>
        ''' <param name="lngCustomerID">The value for the CustomerID portion of the record</param>
        ''' <param name="dblAmount">The value for the Amount portion of the record</param>
        ''' <param name="lngInvoiceID">The value for the InvoiceID portion of the record</param>
        ''' <param name="lngTicketID">The value for the TicketID portion of the record</param>
        ''' <param name="lngWorkOrderID">The value for the WorkOrderID portion of the record</param>
        ''' <param name="datDateCreated">The value for the DateCreated portion of the record</param>
        ''' <param name="datEndPayPeriod">The value for the EndPayPeriod portion of the record</param>
        Public Sub Add(ByVal lngPartnerID As Long, ByVal lngCustomerID As Long, ByVal dblAmount As Double, ByVal lngInvoiceID As Long, ByVal lngTicketID As Long, ByVal lngWorkOrderID As Long, ByVal strNotes As String, ByVal datDateCreated As Date, ByVal datEndPayPeriod As Date)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddJournalEntry")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngJournalEntryID As Long = 0
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cmd.Parameters.Add("@Amount", SqlDbType.Money).Value = dblAmount
                cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = lngInvoiceID
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = lngWorkOrderID
                cmd.Parameters.Add("@Notes", SqlDbType.NText, Len(strNotes)).value = strNotes
                cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = datDateCreated
                cmd.Parameters.Add("@EndPayPeriod", SqlDbType.DateTime).Value = datEndPayPeriod
                cnn.Open()
                cmd.Connection = cnn
                lngJournalEntryID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngJournalEntryID > 0 Then
                    Load(lngJournalEntryID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a JournalEntry record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngJournalEntryID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetJournalEntry")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = lngJournalEntryID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _JournalEntryID = CType(dtr("JournalEntryID"), Long)
                    _PartnerID = CType(dtr("PartnerID"), Long)
                    _CustomerID = CType(dtr("CustomerID"), Long)
                    _Amount = CType(dtr("Amount"), Double)
                    _InvoiceID = CType(dtr("InvoiceID"), Long)
                    _TicketID = CType(dtr("TicketID"), Long)
                    _WorkOrderID = CType(dtr("WorkOrderID"), Long)
                    _Notes = dtr("Notes").ToString
                    _DateCreated = CType(dtr("DateCreated"), Date)
                    _EndPayPeriod = CType(dtr("EndPayPeriod"), Date)
                Else
                    ClearValues()
                End If
                cnn.Close()
            End If
        End Sub

        ''' <summary>
        ''' Saves any changes to the record since it was last loaded
        ''' </summary>
        ''' <param name="strChangeLog">The string variable you want manipulated that returns a log of changes.</param>
        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If _ConnectionString.Trim.Length > 0 Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(_ConnectionString)
                cnn.Open()
                Dim obj As New JournalEntryRecord(_JournalEntryID, _ConnectionString)
                obj.Load(_JournalEntryID)
                If obj.PartnerID <> _PartnerID Then
                    UpdatePartnerID(_PartnerID, cnn)
                    strTemp = "PartnerID Changed to '" & _PartnerID & "' from '" & obj.PartnerID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.CustomerID <> _CustomerID Then
                    UpdateCustomerID(_CustomerID, cnn)
                    strTemp = "CustomerID Changed to '" & _CustomerID & "' from '" & obj.CustomerID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Amount <> _Amount Then
                    UpdateAmount(_Amount, cnn)
                    strTemp = "Amount Changed to '" & _Amount & "' from '" & obj.Amount & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.InvoiceID <> _InvoiceID Then
                    UpdateInvoiceID(_InvoiceID, cnn)
                    strTemp = "InvoiceID Changed to '" & _InvoiceID & "' from '" & obj.InvoiceID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.TicketID <> _TicketID Then
                    UpdateTicketID(_TicketID, cnn)
                    strTemp = "TicketID Changed to '" & _TicketID & "' from '" & obj.TicketID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.WorkOrderID <> _WorkOrderID Then
                    UpdateWorkOrderID(_WorkOrderID, cnn)
                    strTemp = "WorkOrderID Changed to '" & _WorkOrderID & "' from '" & obj.WorkOrderID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Notes <> _Notes Then
                    UpdateNotes(_Notes, cnn)
                    strTemp = "Notes Changed to '" & _Notes & "' from '" & obj.Notes & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.DateCreated <> _DateCreated Then
                    UpdateDateCreated(_DateCreated, cnn)
                    strTemp = "DateCreated Changed to '" & _DateCreated & "' from '" & obj.DateCreated & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.EndPayPeriod <> _EndPayPeriod Then
                    UpdateEndPayPeriod(_EndPayPeriod, cnn)
                    strTemp = "EndPayPeriod Changed to '" & _EndPayPeriod & "' from '" & obj.EndPayPeriod & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_JournalEntryID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded JournalEntry Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemoveJournalEntry")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@JournalEntryID", SqlDbType.Int).Value = _JournalEntryID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_JournalEntryID)
            End If
        End Sub

#End Region

    End Class
End Namespace