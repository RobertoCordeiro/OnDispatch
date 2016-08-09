Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class BlackBookRecord

#Region "Private Members"

        Private _BlackBookID As Long = 0
        Private _UserID As Long = 0
        Private _TicketID As Long = 0
        Private _DateCreated As Date = DateTime.Now
        Private _Description As String = ""
        Private _Resolution As String = ""
        Private _FollowUpManager As Long = 0
        Private _FollowUpResolution As String = ""
        Private _DateClosed As Date = DateTime.Now
        Private _EnteredBy As Long = 0
        Private _BlackBookTypeID As Long = 0
        Private _DepartmentID As Long = 0
        Private _BlackBookIssueID As Long = 0
        Private _PartnerAgentID As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the UserID field for the currently loaded record
        ''' </summary>
        Public Property UserID() As Long
            Get
                Return _UserID
            End Get
            Set(ByVal value As Long)
                _UserID = value
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
        ''' Returns/Sets the Description field for the currently loaded record
        ''' </summary>
        Public Property Description() As String
            Get
                Return _Description
            End Get
            Set(ByVal value As String)
                _Description = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Resolution field for the currently loaded record
        ''' </summary>
        Public Property Resolution() As String
            Get
                Return _Resolution
            End Get
            Set(ByVal value As String)
                _Resolution = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the FollowUpManager field for the currently loaded record
        ''' </summary>
        Public Property FollowUpManager() As Long
            Get
                Return _FollowUpManager
            End Get
            Set(ByVal value As Long)
                _FollowUpManager = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the FollowUpResolution field for the currently loaded record
        ''' </summary>
        Public Property FollowUpResolution() As String
            Get
                Return _FollowUpResolution
            End Get
            Set(ByVal value As String)
                _FollowUpResolution = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the DateClosed field for the currently loaded record
        ''' </summary>
        Public Property DateClosed() As Date
            Get
                Return _DateClosed
            End Get
            Set(ByVal value As Date)
                _DateClosed = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the EnteredBy field for the currently loaded record
        ''' </summary>
        Public Property EnteredBy() As Long
            Get
                Return _EnteredBy
            End Get
            Set(ByVal value As Long)
                _EnteredBy = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the BlackBookTypeID field for the currently loaded record
        ''' </summary>
        Public Property BlackBookTypeID() As Long
            Get
                Return _BlackBookTypeID
            End Get
            Set(ByVal value As Long)
                _BlackBookTypeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the DepartmentID field for the currently loaded record
        ''' </summary>
        Public Property DepartmentID() As Long
            Get
                Return _DepartmentID
            End Get
            Set(ByVal value As Long)
                _DepartmentID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the BlackBookIssueID field for the currently loaded record
        ''' </summary>
        Public Property BlackBookIssueID() As Long
            Get
                Return _BlackBookIssueID
            End Get
            Set(ByVal value As Long)
                _BlackBookIssueID = value
            End Set
        End Property

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
        ''' Returns the BlackBookID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property BlackBookID() As Long
            Get
                Return _BlackBookID
            End Get
        End Property

        ''' <summary>
        ''' Returns the DateCreated field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property DateCreated() As Date
            Get
                Return _DateCreated
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
            _BlackBookID = 0
            _UserID = 0
            _TicketID = 0
            _DateCreated = DateTime.Now
            _Description = ""
            _Resolution = ""
            _FollowUpManager = 0
            _FollowUpResolution = ""
            _DateClosed = DateTime.Now
            _EnteredBy = 0
            _BlackBookTypeID = 0
            _DepartmentID = 0
            _BlackBookIssueID = 0
            _PartnerAgentID = 0
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
        ''' Updates the UserID field for this record.
        ''' </summary>
        ''' <param name="NewUserID">The new value for theUserID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateUserID(ByVal NewUserID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookUserID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            If NewUserID > 0 Then
                cmd.Parameters.Add("@UserID", SqlDbType.int).value = NewUserID
            Else
                cmd.Parameters.Add("@UserID", SqlDbType.int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the TicketID field for this record.
        ''' </summary>
        ''' <param name="NewTicketID">The new value for theTicketID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTicketID(ByVal NewTicketID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookTicketID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            cmd.Parameters.Add("@TicketID", SqlDbType.int).value = NewTicketID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Description field for this record.
        ''' </summary>
        ''' <param name="NewDescription">The new value for theDescription field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDescription(ByVal NewDescription As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            cmd.Parameters.Add("@Description", SqlDbType.text).value = NewDescription
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Resolution field for this record.
        ''' </summary>
        ''' <param name="NewResolution">The new value for theResolution field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateResolution(ByVal NewResolution As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookResolution")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            cmd.Parameters.Add("@Resolution", SqlDbType.text).value = NewResolution
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the FollowUpManager field for this record.
        ''' </summary>
        ''' <param name="NewFollowUpManager">The new value for theFollowUpManager field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateFollowUpManager(ByVal NewFollowUpManager As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookFollowUpManager")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            cmd.Parameters.Add("@FollowUpManager", SqlDbType.int).value = NewFollowUpManager
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the FollowUpResolution field for this record.
        ''' </summary>
        ''' <param name="NewFollowUpResolution">The new value for theFollowUpResolution field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateFollowUpResolution(ByVal NewFollowUpResolution As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookFollowUpResolution")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            If NewFollowUpResolution.Trim.Length > 0 Then
                cmd.Parameters.Add("@FollowUpResolution", SqlDbType.text).value = NewFollowUpResolution
            Else
                cmd.Parameters.Add("@FollowUpResolution", SqlDbType.text).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the DateClosed field for this record.
        ''' </summary>
        ''' <param name="NewDateClosed">The new value for theDateClosed field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDateClosed(ByVal NewDateClosed As Date, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookDateClosed")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            If NewDateClosed.ToString > 0 Then
                cmd.Parameters.Add("@DateClosed", SqlDbType.DateTime).Value = NewDateClosed
            Else
                cmd.Parameters.Add("@DateClosed", SqlDbType.DateTime).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the EnteredBy field for this record.
        ''' </summary>
        ''' <param name="NewEnteredBy">The new value for theEnteredBy field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateEnteredBy(ByVal NewEnteredBy As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookEnteredBy")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            cmd.Parameters.Add("@EnteredBy", SqlDbType.int).value = NewEnteredBy
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the BlackBookTypeID field for this record.
        ''' </summary>
        ''' <param name="NewBlackBookTypeID">The new value for theBlackBookTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateBlackBookTypeID(ByVal NewBlackBookTypeID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookBlackBookTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            cmd.Parameters.Add("@BlackBookTypeID", SqlDbType.int).value = NewBlackBookTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the DepartmentID field for this record.
        ''' </summary>
        ''' <param name="NewDepartmentID">The new value for theDepartmentID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDepartmentID(ByVal NewDepartmentID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookDepartmentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            cmd.Parameters.Add("@DepartmentID", SqlDbType.int).value = NewDepartmentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the BlackBookIssueID field for this record.
        ''' </summary>
        ''' <param name="NewBlackBookIssueID">The new value for theBlackBookIssueID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateBlackBookIssueID(ByVal NewBlackBookIssueID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookBlackBookIssueID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            cmd.Parameters.Add("@BlackBookIssueID", SqlDbType.int).value = NewBlackBookIssueID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the PartnerAgentID field for this record.
        ''' </summary>
        ''' <param name="NewPartnerAgentID">The new value for thePartnerAgentID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerAgentID(ByVal NewPartnerAgentID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateBlackBookPartnerAgentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@BlackBookID", sqlDBType.int).value = _BlackBookID
            If NewPartnerAgentID > 0 Then
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.int).value = NewPartnerAgentID
            Else
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.int).Value = System.DBNull.Value
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
            Dim obj As New BlackBookRecord(_BlackBookID, _ConnectionString)
            obj.load(_BlackBookID)
            If obj.UserID <> _UserID Then
                blnReturn = True
            End If
            If obj.TicketID <> _TicketID Then
                blnReturn = True
            End If
            If obj.Description <> _Description Then
                blnReturn = True
            End If
            If obj.Resolution <> _Resolution Then
                blnReturn = True
            End If
            If obj.FollowUpManager <> _FollowUpManager Then
                blnReturn = True
            End If
            If obj.FollowUpResolution <> _FollowUpResolution Then
                blnReturn = True
            End If
            If obj.DateClosed <> _DateClosed Then
                blnReturn = True
            End If
            If obj.EnteredBy <> _EnteredBy Then
                blnReturn = True
            End If
            If obj.BlackBookTypeID <> _BlackBookTypeID Then
                blnReturn = True
            End If
            If obj.DepartmentID <> _DepartmentID Then
                blnReturn = True
            End If
            If obj.BlackBookIssueID <> _BlackBookIssueID Then
                blnReturn = True
            End If
            If obj.PartnerAgentID <> _PartnerAgentID Then
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
        ''' <param name="lngBlackBookID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngBlackBookID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_BlackBookID)
        End Sub

        ''' <summary>
        '''  Adds a new BlackBook record to the database.
        ''' </summary>
        ''' <param name="lngTicketID">The value for the TicketID portion of the record</param>
        ''' <param name="datDateCreated">The value for the DateCreated portion of the record</param>
        ''' <param name="strDescription">The value for the Description portion of the record</param>
        ''' <param name="strResolution">The value for the Resolution portion of the record</param>
        ''' <param name="lngFollowUpManager">The value for the FollowUpManager portion of the record</param>
        ''' <param name="lngEnteredBy">The value for the EnteredBy portion of the record</param>
        ''' <param name="lngBlackBookTypeID">The value for the BlackBookTypeID portion of the record</param>
        ''' <param name="lngDepartmentID">The value for the DepartmentID portion of the record</param>
        ''' <param name="lngBlackBookIssueID">The value for the BlackBookIssueID portion of the record</param>
        Public Sub Add(ByVal lngTicketID As Long, ByVal datDateCreated As Date, ByVal strDescription As String, ByVal strResolution As String, ByVal lngFollowUpManager As Long, ByVal lngEnteredBy As Long, ByVal lngBlackBookTypeID As Long, ByVal lngDepartmentID As Long, ByVal lngBlackBookIssueID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddBlackBook")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngBlackBookID As Long = 0
                cmd.Parameters.Add("@TicketID", SQLDBType.int).Value = lngTicketID
                cmd.Parameters.Add("@DateCreated", SQLDBType.datetime).Value = datDateCreated
                cmd.Parameters.Add("@Description", SQLDBType.text).Value = strDescription
                cmd.Parameters.Add("@Resolution", SQLDBType.text).Value = strResolution
                cmd.Parameters.Add("@FollowUpManager", SQLDBType.int).Value = lngFollowUpManager
                cmd.Parameters.Add("@EnteredBy", SQLDBType.int).Value = lngEnteredBy
                cmd.Parameters.Add("@BlackBookTypeID", SQLDBType.int).Value = lngBlackBookTypeID
                cmd.Parameters.Add("@DepartmentID", SQLDBType.int).Value = lngDepartmentID
                cmd.Parameters.Add("@BlackBookIssueID", SQLDBType.int).Value = lngBlackBookIssueID
                cnn.Open()
                cmd.Connection = cnn
                lngBlackBookID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngBlackBookID > 0 Then
                    Load(lngBlackBookID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a BlackBook record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngBlackBookID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetBlackBook")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@BlackBookID", SqlDbType.Int).Value = lngBlackBookID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _BlackBookID = CType(dtr("BlackBookID"), Long)
                    If Not isdbnull(dtr("UserID")) Then
                        _UserID = CType(dtr("UserID"), Long)
                    Else
                        _UserID = 0
                    End If
                    _TicketID = CType(dtr("TicketID"), Long)
                    _DateCreated = CType(dtr("DateCreated"), Date)
                    _Description = dtr("Description").ToString
                    _Resolution = dtr("Resolution").ToString
                    _FollowUpManager = CType(dtr("FollowUpManager"), Long)
                    If Not isdbnull(dtr("FollowUpResolution")) Then
                        _FollowUpResolution = dtr("FollowUpResolution").ToString
                    Else
                        _FollowUpResolution = ""
                    End If
                    If Not isdbnull(dtr("DateClosed")) Then
                        _DateClosed = CType(dtr("DateClosed"), Date)
                    Else
                        _DateClosed = DateTime.Now
                    End If
                    _EnteredBy = CType(dtr("EnteredBy"), Long)
                    _BlackBookTypeID = CType(dtr("BlackBookTypeID"), Long)
                    _DepartmentID = CType(dtr("DepartmentID"), Long)
                    _BlackBookIssueID = CType(dtr("BlackBookIssueID"), Long)
                    If Not isdbnull(dtr("PartnerAgentID")) Then
                        _PartnerAgentID = CType(dtr("PartnerAgentID"), Long)
                    Else
                        _PartnerAgentID = 0
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
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                cnn.Open()
                Dim obj As New BlackBookRecord(_BlackBookID, _ConnectionString)
                obj.load(_BlackBookID)
                If obj.UserID <> _UserID Then
                    UpdateUserID(_UserID, cnn)
                    strTemp = "UserID Changed to '" & _UserID & "' from '" & obj.UserID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.TicketID <> _TicketID Then
                    UpdateTicketID(_TicketID, cnn)
                    strTemp = "TicketID Changed to '" & _TicketID & "' from '" & obj.TicketID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Description <> _Description Then
                    UpdateDescription(_Description, cnn)
                    strTemp = "Description Changed to '" & _Description & "' from '" & obj.Description & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Resolution <> _Resolution Then
                    UpdateResolution(_Resolution, cnn)
                    strTemp = "Resolution Changed to '" & _Resolution & "' from '" & obj.Resolution & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.FollowUpManager <> _FollowUpManager Then
                    UpdateFollowUpManager(_FollowUpManager, cnn)
                    strTemp = "FollowUpManager Changed to '" & _FollowUpManager & "' from '" & obj.FollowUpManager & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.FollowUpResolution <> _FollowUpResolution Then
                    UpdateFollowUpResolution(_FollowUpResolution, cnn)
                    strTemp = "FollowUpResolution Changed to '" & _FollowUpResolution & "' from '" & obj.FollowUpResolution & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.DateClosed <> _DateClosed Then
                    UpdateDateClosed(_DateClosed, cnn)
                    strTemp = "DateClosed Changed to '" & _DateClosed & "' from '" & obj.DateClosed & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.EnteredBy <> _EnteredBy Then
                    UpdateEnteredBy(_EnteredBy, cnn)
                    strTemp = "EnteredBy Changed to '" & _EnteredBy & "' from '" & obj.EnteredBy & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.BlackBookTypeID <> _BlackBookTypeID Then
                    UpdateBlackBookTypeID(_BlackBookTypeID, cnn)
                    strTemp = "BlackBookTypeID Changed to '" & _BlackBookTypeID & "' from '" & obj.BlackBookTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.DepartmentID <> _DepartmentID Then
                    UpdateDepartmentID(_DepartmentID, cnn)
                    strTemp = "DepartmentID Changed to '" & _DepartmentID & "' from '" & obj.DepartmentID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.BlackBookIssueID <> _BlackBookIssueID Then
                    UpdateBlackBookIssueID(_BlackBookIssueID, cnn)
                    strTemp = "BlackBookIssueID Changed to '" & _BlackBookIssueID & "' from '" & obj.BlackBookIssueID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.PartnerAgentID <> _PartnerAgentID Then
                    UpdatePartnerAgentID(_PartnerAgentID, cnn)
                    strTemp = "PartnerAgentID Changed to '" & _PartnerAgentID & "' from '" & obj.PartnerAgentID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_BlackBookID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded BlackBook Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveBlackBook")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@BlackBookID", SqlDbType.Int).Value = _BlackBookID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_BlackBookID)
            End If
        End Sub

#End Region

    End Class
End Namespace