Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PartnerAgentStatusRecord

#Region "Private Constants"

        Private Const PartnerAgentStatusMaxLength As Integer = 64

#End Region

#Region "Private Members"

        Private _PartnerAgentStatusID As Long = 0
        Private _PartnerAgentStatus As String = ""
        Private _Active As Boolean = False
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the PartnerAgentStatus field for the currently loaded record
        ''' </summary>
        Public Property PartnerAgentStatus() As String
            Get
                Return _PartnerAgentStatus
            End Get
            Set(ByVal value As String)
                _PartnerAgentStatus = TrimTrunc(value, PartnerAgentStatusMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Active field for the currently loaded record
        ''' </summary>
        Public Property Active() As Boolean
            Get
                Return _Active
            End Get
            Set(ByVal value As Boolean)
                _Active = value
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
        ''' Returns the PartnerAgentStatusID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property PartnerAgentStatusID() As Long
            Get
                Return _PartnerAgentStatusID
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
            _PartnerAgentStatusID = 0
            _PartnerAgentStatus = ""
            _Active = False
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
        ''' Updates the PartnerAgentStatus field for this record.
        ''' </summary>
        ''' <param name="NewPartnerAgentStatus">The new value for thePartnerAgentStatus field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerAgentStatus(ByVal NewPartnerAgentStatus As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentStatusPartnerAgentStatus")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentStatusID", SqlDbType.Int).Value = _PartnerAgentStatusID
            cmd.Parameters.Add("@PartnerAgentStatus", SqlDbType.VarChar, TrimTrunc(NewPartnerAgentStatus, PartnerAgentStatusMaxLength).Length).Value = TrimTrunc(NewPartnerAgentStatus, PartnerAgentStatusMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Active field for this record.
        ''' </summary>
        ''' <param name="NewActive">The new value for theActive field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentStatusActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentStatusID", SqlDbType.Int).Value = _PartnerAgentStatusID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
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
            Dim obj As New PartnerAgentStatusRecord(_PartnerAgentStatusID, _ConnectionString)
            obj.Load(_PartnerAgentStatusID)
            If obj.PartnerAgentStatus <> _PartnerAgentStatus Then
                blnReturn = True
            End If
            If obj.Active <> _Active Then
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
        ''' <param name="lngPartnerAgentStatusID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngPartnerAgentStatusID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_PartnerAgentStatusID)
        End Sub

        ''' <summary>
        '''  Adds a new PartnerAgentStatus record to the database.
        ''' </summary>
        ''' <param name="strPartnerAgentStatus">The value for the PartnerAgentStatus portion of the record</param>
        Public Sub Add(ByVal strPartnerAgentStatus As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerAgentStatus")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerAgentStatusID As Long = 0
                cmd.Parameters.Add("@PartnerAgentStatus", SqlDbType.VarChar, TrimTrunc(strPartnerAgentStatus, PartnerAgentStatusMaxLength).Length).Value = TrimTrunc(strPartnerAgentStatus, PartnerAgentStatusMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngPartnerAgentStatusID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngPartnerAgentStatusID > 0 Then
                    Load(lngPartnerAgentStatusID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a PartnerAgentStatus record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngPartnerAgentStatusID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentStatus")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentStatusID", SqlDbType.Int).Value = lngPartnerAgentStatusID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _PartnerAgentStatusID = CType(dtr("PartnerAgentStatusID"), Long)
                    _PartnerAgentStatus = dtr("PartnerAgentStatus").ToString
                    _Active = CType(dtr("Active"), Boolean)
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
                Dim obj As New PartnerAgentStatusRecord(_PartnerAgentStatusID, _ConnectionString)
                obj.Load(_PartnerAgentStatusID)
                If obj.PartnerAgentStatus <> _PartnerAgentStatus Then
                    UpdatePartnerAgentStatus(_PartnerAgentStatus, cnn)
                    strTemp = "PartnerAgentStatus Changed to '" & _PartnerAgentStatus & "' from '" & obj.PartnerAgentStatus & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Active <> _Active Then
                    UpdateActive(_Active, cnn)
                    strTemp = "Active Changed to '" & _Active & "' from '" & obj.Active & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_PartnerAgentStatusID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded PartnerAgentStatus Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerAgentStatus")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentStatusID", SqlDbType.Int).Value = _PartnerAgentStatusID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_PartnerAgentStatusID)
            End If
        End Sub

#End Region

    End Class
End Namespace