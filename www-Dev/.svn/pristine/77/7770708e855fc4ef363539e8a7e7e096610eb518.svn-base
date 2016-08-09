Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface

    Public Class DepartmentGroupRecord

#Region "Private Constants"

        Private Const GroupNameMaxLength As Integer = 32

#End Region

#Region "Private Members"

        Private _GroupID As Long = 0
        Private _DepartmentID As Long = 0
        Private _GroupName As String = ""
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

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
        ''' Returns/Sets the GroupName field for the currently loaded record
        ''' </summary>
        Public Property GroupName() As String
            Get
                Return _GroupName
            End Get
            Set(ByVal value As String)
                _GroupName = TrimTrunc(value, GroupNameMaxLength)
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
        ''' Returns the GroupID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property GroupID() As Long
            Get
                Return _GroupID
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
            _GroupID = 0
            _DepartmentID = 0
            _GroupName = ""
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
        ''' Updates the DepartmentID field for this record.
        ''' </summary>
        ''' <param name="NewDepartmentID">The new value for theDepartmentID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDepartmentID(ByVal NewDepartmentID As Long, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateDepartmentGroupDepartmentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@GroupID", sqlDBType.int).value = _GroupID
            cmd.Parameters.Add("@DepartmentID", SqlDbType.int).value = NewDepartmentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the GroupName field for this record.
        ''' </summary>
        ''' <param name="NewGroupName">The new value for theGroupName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateGroupName(ByVal NewGroupName As String, ByRef cnn As sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateDepartmentGroupGroupName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@GroupID", sqlDBType.int).value = _GroupID
            cmd.Parameters.Add("@GroupName", SqlDbType.varchar, TrimTrunc(NewGroupName, GroupNameMaxLength).Length).value = TrimTrunc(NewGroupName, GroupNameMaxLength)
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
            Dim obj As New DepartmentGroupRecord(_GroupID, _ConnectionString)
            obj.load(_GroupID)
            If obj.DepartmentID <> _DepartmentID Then
                blnReturn = True
            End If
            If obj.GroupName <> _GroupName Then
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
        ''' <param name="lngGroupID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngGroupID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_GroupID)
        End Sub

        ''' <summary>
        '''  Adds a new DepartmentGroup record to the database.
        ''' </summary>
        ''' <param name="lngDepartmentID">The value for the DepartmentID portion of the record</param>
        ''' <param name="strGroupName">The value for the GroupName portion of the record</param>
        Public Sub Add(ByVal lngDepartmentID As Long, ByVal strGroupName As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddDepartmentGroup")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngGroupID As Long = 0
                cmd.Parameters.Add("@DepartmentID", SQLDBType.int).Value = lngDepartmentID
                cmd.Parameters.Add("@GroupName", SQLDBType.varchar, TrimTrunc(strGroupName, GroupNameMaxLength).Length).Value = TrimTrunc(strGroupName, GroupNameMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngGroupID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngGroupID > 0 Then
                    Load(lngGroupID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a DepartmentGroup record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngGroupID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetDepartmentGroup")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@GroupID", SqlDbType.Int).Value = lngGroupID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _GroupID = CType(dtr("GroupID"), Long)
                    _DepartmentID = CType(dtr("DepartmentID"), Long)
                    _GroupName = dtr("GroupName").ToString
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
                Dim obj As New DepartmentGroupRecord(_GroupID, _ConnectionString)
                obj.Load(_GroupID)
                If obj.DepartmentID <> _DepartmentID Then
                    UpdateDepartmentID(_DepartmentID, cnn)
                    strTemp = "DepartmentID Changed to '" & _DepartmentID & "' from '" & obj.DepartmentID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.GroupName <> _GroupName Then
                    UpdateGroupName(_GroupName, cnn)
                    strTemp = "GroupName Changed to '" & _GroupName & "' from '" & obj.GroupName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_GroupID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded DepartmentGroup Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemoveDepartmentGroup")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@GroupID", SqlDbType.Int).Value = _GroupID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_GroupID)
            End If
        End Sub

#End Region

    End Class

End Namespace