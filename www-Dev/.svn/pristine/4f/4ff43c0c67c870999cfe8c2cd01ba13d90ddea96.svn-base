Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PartnerAgentMessageRecord

#Region "Private Members"

        Private _PartnerAgentMessageID As Long = 0
        Private _PartnerAgentID As Long = 0
        Private _CreatedBy As Long = 0
        Private _CreatedDate As Date = DateTime.Now
        Private _Message As String = ""
        Private _Delivered As Boolean = False
        Private _DeliveredDate As Date = DateTime.Now
        Private _DeliveredBy As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the PartnerAgentID field for the currently loaded record
        ''' </summary>
        Public Property PartnerAgentID() As Long
            Get
                Return _PartnerAgentID
            End Get
            Set(ByVal value As Long)
                _PartnerAgentID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the CreatedDate field for the currently loaded record
        ''' </summary>
        Public Property CreatedDate() As Date
            Get
                Return _CreatedDate
            End Get
            Set(ByVal value As Date)
                _CreatedDate = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Message field for the currently loaded record
        ''' </summary>
        Public Property Message() As String
            Get
                Return _Message
            End Get
            Set(ByVal value As String)
                _Message = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Delivered field for the currently loaded record
        ''' </summary>
        Public Property Delivered() As Boolean
            Get
                Return _Delivered
            End Get
            Set(ByVal value As Boolean)
                _Delivered = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the DeliveredDate field for the currently loaded record
        ''' </summary>
        Public Property DeliveredDate() As Date
            Get
                Return _DeliveredDate
            End Get
            Set(ByVal value As Date)
                _DeliveredDate = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the DeliveredBy field for the currently loaded record
        ''' </summary>
        Public Property DeliveredBy() As Long
            Get
                Return _DeliveredBy
            End Get
            Set(ByVal value As Long)
                _DeliveredBy = value
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
        ''' Returns the PartnerAgentMessageID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property PartnerAgentMessageID() As Long
            Get
                Return _PartnerAgentMessageID
            End Get
        End Property

        ''' <summary>
        ''' Returns the CreatedBy field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property CreatedBy() As Long
            Get
                Return _CreatedBy
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
            _PartnerAgentMessageID = 0
            _PartnerAgentID = 0
            _CreatedBy = 0
            _CreatedDate = DateTime.Now
            _Message = ""
            _Delivered = False
            _DeliveredDate = DateTime.Now
            _DeliveredBy = 0
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
        ''' Updates the PartnerAgentID field for this record.
        ''' </summary>
        ''' <param name="NewPartnerAgentID">The new value for thePartnerAgentID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerAgentID(ByVal NewPartnerAgentID As Long, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdatePartnerAgentMessagePartnerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentMessageID", sqlDBType.int).value = _PartnerAgentMessageID
            cmd.Parameters.Add("@PartnerAgentID", SqlDbType.int).value = NewPartnerAgentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the CreatedDate field for this record.
        ''' </summary>
        ''' <param name="NewCreatedDate">The new value for theCreatedDate field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCreatedDate(ByVal NewCreatedDate As Date, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdatePartnerAgentMessageCreatedDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentMessageID", sqlDBType.int).value = _PartnerAgentMessageID
            cmd.Parameters.Add("@CreatedDate", SqlDbType.datetime).value = NewCreatedDate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Message field for this record.
        ''' </summary>
        ''' <param name="NewMessage">The new value for theMessage field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateMessage(ByVal NewMessage As String, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdatePartnerAgentMessageMessage")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentMessageID", sqlDBType.int).value = _PartnerAgentMessageID
            cmd.Parameters.Add("@Message", SqlDbType.text).value = NewMessage
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Delivered field for this record.
        ''' </summary>
        ''' <param name="NewDelivered">The new value for theDelivered field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDelivered(ByVal NewDelivered As Boolean, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdatePartnerAgentMessageDelivered")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentMessageID", sqlDBType.int).value = _PartnerAgentMessageID
            'If NewDelivered > 0 Then
            cmd.Parameters.Add("@Delivered", SqlDbType.Bit).Value = NewDelivered
            'Else
            'cmd.Parameters.Add("@Delivered", SqlDbType.Bit).Value = System.DBNull.Value
            'End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the DeliveredDate field for this record.
        ''' </summary>
        ''' <param name="NewDeliveredDate">The new value for theDeliveredDate field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDeliveredDate(ByVal NewDeliveredDate As Date, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdatePartnerAgentMessageDeliveredDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentMessageID", sqlDBType.int).value = _PartnerAgentMessageID
            If Not IsDBNull(NewDeliveredDate) Then
                cmd.Parameters.Add("@DeliveredDate", SqlDbType.DateTime).Value = NewDeliveredDate
            Else
                cmd.Parameters.Add("@DeliveredDate", SqlDbType.DateTime).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the DeliveredBy field for this record.
        ''' </summary>
        ''' <param name="NewDeliveredBy">The new value for theDeliveredBy field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDeliveredBy(ByVal NewDeliveredBy As Long, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdatePartnerAgentMessageDeliveredBy")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@PartnerAgentMessageID", sqlDBType.int).value = _PartnerAgentMessageID
            If NewDeliveredBy > 0 Then
                cmd.Parameters.Add("@DeliveredBy", SqlDbType.int).value = NewDeliveredBy
            Else
                cmd.Parameters.Add("@DeliveredBy", SqlDbType.int).Value = System.DBNull.Value
            End If
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
            Dim obj As New PartnerAgentMessageRecord(_PartnerAgentMessageID, _ConnectionString)
            obj.load(_PartnerAgentMessageID)
            If obj.PartnerAgentID <> _PartnerAgentID Then
                blnReturn = True
            End If
            If obj.CreatedDate <> _CreatedDate Then
                blnReturn = True
            End If
            If obj.Message <> _Message Then
                blnReturn = True
            End If
            If obj.Delivered <> _Delivered Then
                blnReturn = True
            End If
            If obj.DeliveredDate <> _DeliveredDate Then
                blnReturn = True
            End If
            If obj.DeliveredBy <> _DeliveredBy Then
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
        ''' <param name="lngPartnerAgentMessageID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngPartnerAgentMessageID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_PartnerAgentMessageID)
        End Sub

        ''' <summary>
        '''  Adds a new PartnerAgentMessage record to the database.
        ''' </summary>
        ''' <param name="lngPartnerAgentID">The value for the PartnerAgentID portion of the record</param>
        ''' <param name="lngCreatedBy">The value for the CreatedBy portion of the record</param>
        ''' <param name="datCreatedDate">The value for the CreatedDate portion of the record</param>
        ''' <param name="strMessage">The value for the Message portion of the record</param>
        Public Sub Add(ByVal lngPartnerAgentID As Long, ByVal lngCreatedBy As Long, ByVal datCreatedDate As Date, ByVal strMessage As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerAgentMessage")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerAgentMessageID As Long = 0
                cmd.Parameters.Add("@PartnerAgentID", SQLDBType.int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@CreatedBy", SQLDBType.int).Value = lngCreatedBy
                cmd.Parameters.Add("@CreatedDate", SQLDBType.datetime).Value = datCreatedDate
                cmd.Parameters.Add("@Message", SQLDBType.text).Value = strMessage
                cnn.Open()
                cmd.Connection = cnn
                lngPartnerAgentMessageID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngPartnerAgentMessageID > 0 Then
                    Load(lngPartnerAgentMessageID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a PartnerAgentMessage record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngPartnerAgentMessageID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentMessage")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentMessageID", SqlDbType.Int).Value = lngPartnerAgentMessageID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _PartnerAgentMessageID = CType(dtr("PartnerAgentMessageID"), Long)
                    _PartnerAgentID = CType(dtr("PartnerAgentID"), Long)
                    _CreatedBy = CType(dtr("CreatedBy"), Long)
                    _CreatedDate = CType(dtr("CreatedDate"), Date)
                    _Message = dtr("Message").ToString
                    If Not IsDBNull(dtr("Delivered")) Then
                        _Delivered = CType(dtr("Delivered"), Boolean)
                    Else
                        _Delivered = False
                    End If
                    If Not IsDBNull(dtr("DeliveredDate")) Then
                        _DeliveredDate = CType(dtr("DeliveredDate"), Date)
                    Else
                        _DeliveredDate = DateTime.Now
                    End If
                    If Not IsDBNull(dtr("DeliveredBy")) Then
                        _DeliveredBy = CType(dtr("DeliveredBy"), Long)
                    Else
                        _DeliveredBy = 0
                    End If
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
                Dim obj As New PartnerAgentMessageRecord(_PartnerAgentMessageID, _ConnectionString)
                obj.Load(_PartnerAgentMessageID)
                If obj.PartnerAgentID <> _PartnerAgentID Then
                    UpdatePartnerAgentID(_PartnerAgentID, cnn)
                    strTemp = "PartnerAgentID Changed to '" & _PartnerAgentID & "' from '" & obj.PartnerAgentID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.CreatedDate <> _CreatedDate Then
                    UpdateCreatedDate(_CreatedDate, cnn)
                    strTemp = "CreatedDate Changed to '" & _CreatedDate & "' from '" & obj.CreatedDate & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Message <> _Message Then
                    UpdateMessage(_Message, cnn)
                    strTemp = "Message Changed to '" & _Message & "' from '" & obj.Message & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Delivered <> _Delivered Then
                    UpdateDelivered(_Delivered, cnn)
                    strTemp = "Delivered Changed to '" & _Delivered & "' from '" & obj.Delivered & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.DeliveredDate <> _DeliveredDate Then
                    UpdateDeliveredDate(_DeliveredDate, cnn)
                    strTemp = "DeliveredDate Changed to '" & _DeliveredDate & "' from '" & obj.DeliveredDate & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.DeliveredBy <> _DeliveredBy Then
                    UpdateDeliveredBy(_DeliveredBy, cnn)
                    strTemp = "DeliveredBy Changed to '" & _DeliveredBy & "' from '" & obj.DeliveredBy & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_PartnerAgentMessageID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded PartnerAgentMessage Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerAgentMessage")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentMessageID", SqlDbType.Int).Value = _PartnerAgentMessageID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_PartnerAgentMessageID)
            End If
        End Sub

#End Region

    End Class

End Namespace