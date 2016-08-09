Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class TicketClaimApprovalStatusRecord

#Region "Private Constants"

        Private Const StatusDescriptionMaxLength As Integer = 64

#End Region

#Region "Private Members"

        Private _TicketClaimApprovalStatusID As Long = 0
        Private _StatusDescription As String = ""
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the StatusDescription field for the currently loaded record
        ''' </summary>
        Public Property StatusDescription() As String
            Get
                Return _StatusDescription
            End Get
            Set(ByVal value As String)
                _StatusDescription = TrimTrunc(value, StatusDescriptionMaxLength)
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
        ''' Returns the TicketClaimApprovalStatusID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property TicketClaimApprovalStatusID() As Long
            Get
                Return _TicketClaimApprovalStatusID
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
            _TicketClaimApprovalStatusID = 0
            _StatusDescription = ""
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
        ''' Updates the StatusDescription field for this record.
        ''' </summary>
        ''' <param name="NewStatusDescription">The new value for theStatusDescription field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateStatusDescription(ByVal NewStatusDescription As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketClaimApprovalStatusStatusDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketClaimApprovalStatusID", sqlDBType.int).value = _TicketClaimApprovalStatusID
            cmd.Parameters.Add("@StatusDescription", SqlDbType.varchar, TrimTrunc(NewStatusDescription, StatusDescriptionMaxLength).Length).value = TrimTrunc(NewStatusDescription, StatusDescriptionMaxLength)
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
            Dim obj As New TicketClaimApprovalStatusRecord(_TicketClaimApprovalStatusID, _ConnectionString)
            obj.Load(_TicketClaimApprovalStatusID)
            If obj.StatusDescription <> _StatusDescription Then
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
        ''' <param name="lngTicketClaimApprovalStatusID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngTicketClaimApprovalStatusID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_TicketClaimApprovalStatusID)
        End Sub

        ''' <summary>
        '''  Adds a new TicketClaimApprovalStatus record to the database.
        ''' </summary>
        ''' <param name="strStatusDescription">The value for the StatusDescription portion of the record</param>
        Public Sub Add(ByVal strStatusDescription As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddTicketClaimApprovalStatus")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketClaimApprovalStatusID As Long = 0
                cmd.Parameters.Add("@StatusDescription", SQLDBType.varchar, TrimTrunc(strStatusDescription, StatusDescriptionMaxLength).Length).Value = TrimTrunc(strStatusDescription, StatusDescriptionMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngTicketClaimApprovalStatusID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngTicketClaimApprovalStatusID > 0 Then
                    Load(lngTicketClaimApprovalStatusID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a TicketClaimApprovalStatus record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngTicketClaimApprovalStatusID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetTicketClaimApprovalStatus")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketClaimApprovalStatusID", SqlDbType.Int).Value = lngTicketClaimApprovalStatusID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _TicketClaimApprovalStatusID = CType(dtr("TicketClaimApprovalStatusID"), Long)
                    _StatusDescription = dtr("StatusDescription").ToString
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
                Dim obj As New TicketClaimApprovalStatusRecord(_TicketClaimApprovalStatusID, _ConnectionString)
                obj.Load(_TicketClaimApprovalStatusID)
                If obj.StatusDescription <> _StatusDescription Then
                    UpdateStatusDescription(_StatusDescription, cnn)
                    strTemp = "StatusDescription Changed to '" & _StatusDescription & "' from '" & obj.StatusDescription & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_TicketClaimApprovalStatusID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded TicketClaimApprovalStatus Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveTicketClaimApprovalStatus")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketClaimApprovalStatusID", SqlDbType.Int).Value = _TicketClaimApprovalStatusID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_TicketClaimApprovalStatusID)
            End If
        End Sub

#End Region

    End Class

End Namespace