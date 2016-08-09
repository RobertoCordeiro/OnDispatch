Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface

    Public Class TicketClaimApprovalRecord

#Region "Private Members"

        Private _TicketClaimApprovalsID As Long = 0
        Private _TicketID As Long = 0
        Private _ApprovalDate As DateTime = DateTime.Now
        Private _TicketClaimApprovalStatusID As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

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
        ''' Returns/Sets the ApprovalDate field for the currently loaded record
        ''' </summary>
        Public Property ApprovalDate() As DateTime
            Get
                Return _ApprovalDate
            End Get
            Set(ByVal value As DateTime)
                _ApprovalDate = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the TicketClaimApprovalStatusID field for the currently loaded record
        ''' </summary>
        Public Property TicketClaimApprovalStatusID() As Long
            Get
                Return _TicketClaimApprovalStatusID
            End Get
            Set(ByVal value As Long)
                _TicketClaimApprovalStatusID = value
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
        ''' Returns the TicketClaimApprovalsID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property TicketClaimApprovalsID() As Long
            Get
                Return _TicketClaimApprovalsID
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
            _TicketClaimApprovalsID = 0
            _TicketID = 0
            _ApprovalDate = DateTime.Now
            _TicketClaimApprovalStatusID = 0
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
        ''' Updates the TicketID field for this record.
        ''' </summary>
        ''' <param name="NewTicketID">The new value for theTicketID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTicketID(ByVal NewTicketID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketClaimApprovalTicketID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketClaimApprovalsID", sqlDBType.int).value = _TicketClaimApprovalsID
            cmd.Parameters.Add("@TicketID", SqlDbType.int).value = NewTicketID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ApprovalDate field for this record.
        ''' </summary>
        ''' <param name="NewApprovalDate">The new value for theApprovalDate field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateApprovalDate(ByVal NewApprovalDate As DateTime, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketClaimApprovalApprovalDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketClaimApprovalsID", sqlDBType.int).value = _TicketClaimApprovalsID
            cmd.Parameters.Add("@ApprovalDate", SqlDbType.smalldatetime).value = NewApprovalDate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the TicketClaimApprovalStatusID field for this record.
        ''' </summary>
        ''' <param name="NewTicketClaimApprovalStatusID">The new value for theTicketClaimApprovalStatusID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTicketClaimApprovalStatusID(ByVal NewTicketClaimApprovalStatusID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketClaimApprovalTicketClaimApprovalStatusID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketClaimApprovalsID", sqlDBType.int).value = _TicketClaimApprovalsID
            cmd.Parameters.Add("@TicketClaimApprovalStatusID", SqlDbType.int).value = NewTicketClaimApprovalStatusID
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
            Dim obj As New TicketClaimApprovalRecord(_TicketClaimApprovalsID, _ConnectionString)
            obj.Load(_TicketClaimApprovalsID)
            If obj.TicketID <> _TicketID Then
                blnReturn = True
            End If
            If obj.ApprovalDate <> _ApprovalDate Then
                blnReturn = True
            End If
            If obj.TicketClaimApprovalStatusID <> _TicketClaimApprovalStatusID Then
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
        ''' <param name="lngTicketClaimApprovalsID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngTicketClaimApprovalsID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_TicketClaimApprovalsID)
        End Sub

        ''' <summary>
        '''  Adds a new TicketClaimApproval record to the database.
        ''' </summary>
        ''' <param name="lngTicketID">The value for the TicketID portion of the record</param>
        ''' <param name="datApprovalDate">The value for the ApprovalDate portion of the record</param>
        ''' <param name="lngTicketClaimApprovalStatusID">The value for the TicketClaimApprovalStatusID portion of the record</param>
        Public Sub Add(ByVal lngTicketID As Long, ByVal datApprovalDate As DateTime, ByVal lngTicketClaimApprovalStatusID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddTicketClaimApproval")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketClaimApprovalsID As Long = 0
                cmd.Parameters.Add("@TicketID", SQLDBType.int).Value = lngTicketID
                cmd.Parameters.Add("@ApprovalDate", SQLDBType.smalldatetime).Value = datApprovalDate
                cmd.Parameters.Add("@TicketClaimApprovalStatusID", SQLDBType.int).Value = lngTicketClaimApprovalStatusID
                cnn.Open()
                cmd.Connection = cnn
                lngTicketClaimApprovalsID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngTicketClaimApprovalsID > 0 Then
                    Load(lngTicketClaimApprovalsID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a TicketClaimApproval record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngTicketClaimApprovalsID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetTicketClaimApproval")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketClaimApprovalsID", SqlDbType.Int).Value = lngTicketClaimApprovalsID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _TicketClaimApprovalsID = CType(dtr("TicketClaimApprovalsID"), Long)
                    _TicketID = CType(dtr("TicketID"), Long)
                    _ApprovalDate = CType(dtr("ApprovalDate"), DateTime)
                    _TicketClaimApprovalStatusID = CType(dtr("TicketClaimApprovalStatusID"), Long)
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
                Dim obj As New TicketClaimApprovalRecord(_TicketClaimApprovalsID, _ConnectionString)
                obj.Load(_TicketClaimApprovalsID)
                If obj.TicketID <> _TicketID Then
                    UpdateTicketID(_TicketID, cnn)
                    strTemp = "TicketID Changed to '" & _TicketID & "' from '" & obj.TicketID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ApprovalDate <> _ApprovalDate Then
                    UpdateApprovalDate(_ApprovalDate, cnn)
                    strTemp = "ApprovalDate Changed to '" & _ApprovalDate & "' from '" & obj.ApprovalDate & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.TicketClaimApprovalStatusID <> _TicketClaimApprovalStatusID Then
                    UpdateTicketClaimApprovalStatusID(_TicketClaimApprovalStatusID, cnn)
                    strTemp = "TicketClaimApprovalStatusID Changed to '" & _TicketClaimApprovalStatusID & "' from '" & obj.TicketClaimApprovalStatusID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_TicketClaimApprovalsID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded TicketClaimApproval Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveTicketClaimApproval")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketClaimApprovalsID", SqlDbType.Int).Value = _TicketClaimApprovalsID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_TicketClaimApprovalsID)
            End If
        End Sub

#End Region

    End Class

End Namespace