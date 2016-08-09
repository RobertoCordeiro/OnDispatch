Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface

    Public Class DepartamentRecord

#Region "Private Constants"

        Private Const DepartmentNameMaxLength As Integer = 32

#End Region

#Region "Private Members"

        Private _DepartmentID As Long = 0
        Private _DepartmentName As String = ""
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the DepartmentName field for the currently loaded record
        ''' </summary>
        Public Property DepartmentName() As String
            Get
                Return _DepartmentName
            End Get
            Set(ByVal value As String)
                _DepartmentName = TrimTrunc(value, DepartmentNameMaxLength)
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
        ''' Returns the DepartmentID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property DepartmentID() As Long
            Get
                Return _DepartmentID
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
            _DepartmentID = 0
            _DepartmentName = ""
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
        ''' Updates the DepartmentName field for this record.
        ''' </summary>
        ''' <param name="NewDepartmentName">The new value for theDepartmentName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDepartmentName(ByVal NewDepartmentName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateDepartamentDepartmentName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@DepartmentID", SqlDbType.Int).Value = _DepartmentID
            cmd.Parameters.Add("@DepartmentName", SqlDbType.VarChar, TrimTrunc(NewDepartmentName, DepartmentNameMaxLength).Length).Value = TrimTrunc(NewDepartmentName, DepartmentNameMaxLength)
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
            Dim obj As New DepartamentRecord(_DepartmentID, _ConnectionString)
            obj.Load(_DepartmentID)
            If obj.DepartmentName <> _DepartmentName Then
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
        ''' <param name="lngDepartmentID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngDepartmentID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_DepartmentID)
        End Sub

        ''' <summary>
        '''  Adds a new Departament record to the database.
        ''' </summary>
        ''' <param name="strDepartmentName">The value for the DepartmentName portion of the record</param>
        Public Sub Add(ByVal strDepartmentName As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddDepartament")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngDepartmentID As Long = 0
                cmd.Parameters.Add("@DepartmentName", SqlDbType.VarChar, TrimTrunc(strDepartmentName, DepartmentNameMaxLength).Length).Value = TrimTrunc(strDepartmentName, DepartmentNameMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngDepartmentID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngDepartmentID > 0 Then
                    Load(lngDepartmentID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a Departament record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngDepartmentID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spGetDepartament")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@DepartmentID", SqlDbType.Int).Value = lngDepartmentID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _DepartmentID = CType(dtr("DepartmentID"), Long)
                    _DepartmentName = dtr("DepartmentName").ToString
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
                Dim obj As New DepartamentRecord(_DepartmentID, _ConnectionString)
                obj.Load(_DepartmentID)
                If obj.DepartmentName <> _DepartmentName Then
                    UpdateDepartmentName(_DepartmentName, cnn)
                    strTemp = "DepartmentName Changed to '" & _DepartmentName & "' from '" & obj.DepartmentName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_DepartmentID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded Departament Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemoveDepartament")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@DepartmentID", SqlDbType.Int).Value = _DepartmentID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_DepartmentID)
            End If
        End Sub

#End Region

    End Class

End Namespace
