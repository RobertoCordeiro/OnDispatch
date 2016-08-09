Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CustomerDocumentRecord

#Region "Private Members"

        Private _CustomerDocumentID As Long = 0
        Private _CreatedBy As Long = 0
        Private _CustomerDocumentTypeID As Long = 0
        Private _FileID As Long = 0
        Private _DateCreated As Date = DateTime.Now
        Private _ExpirationDate As Date = DateTime.Now
        Private _CustomerID As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the CustomerDocumentTypeID field for the currently loaded record
        ''' </summary>
        Public Property CustomerDocumentTypeID() As Long
            Get
                Return _CustomerDocumentTypeID
            End Get
            Set(ByVal value As Long)
                _CustomerDocumentTypeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the FileID field for the currently loaded record
        ''' </summary>
        Public Property FileID() As Long
            Get
                Return _FileID
            End Get
            Set(ByVal value As Long)
                _FileID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ExpirationDate field for the currently loaded record
        ''' </summary>
        Public Property ExpirationDate() As Date
            Get
                Return _ExpirationDate
            End Get
            Set(ByVal value As Date)
                _ExpirationDate = value
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
        ''' Returns the CustomerDocumentID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property CustomerDocumentID() As Long
            Get
                Return _CustomerDocumentID
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
            _CustomerDocumentID = 0
            _CreatedBy = 0
            _CustomerDocumentTypeID = 0
            _FileID = 0
            _DateCreated = DateTime.Now
            _ExpirationDate = DateTime.Now
            _CustomerID = 0
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
        ''' Updates the CustomerDocumentTypeID field for this record.
        ''' </summary>
        ''' <param name="NewCustomerDocumentTypeID">The new value for theCustomerDocumentTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCustomerDocumentTypeID(ByVal NewCustomerDocumentTypeID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateCustomerDocumentCustomerDocumentTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@CustomerDocumentID", sqlDBType.int).value = _CustomerDocumentID
            cmd.Parameters.Add("@CustomerDocumentTypeID", SqlDbType.int).value = NewCustomerDocumentTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the FileID field for this record.
        ''' </summary>
        ''' <param name="NewFileID">The new value for theFileID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateFileID(ByVal NewFileID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateCustomerDocumentFileID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@CustomerDocumentID", sqlDBType.int).value = _CustomerDocumentID
            cmd.Parameters.Add("@FileID", SqlDbType.int).value = NewFileID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ExpirationDate field for this record.
        ''' </summary>
        ''' <param name="NewExpirationDate">The new value for theExpirationDate field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateExpirationDate(ByVal NewExpirationDate As Date, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateCustomerDocumentExpirationDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@CustomerDocumentID", sqlDBType.int).value = _CustomerDocumentID
            cmd.Parameters.Add("@ExpirationDate", SqlDbType.datetime).value = NewExpirationDate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the CustomerID field for this record.
        ''' </summary>
        ''' <param name="NewCustomerID">The new value for theCustomerID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCustomerID(ByVal NewCustomerID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateCustomerDocumentCustomerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@CustomerDocumentID", sqlDBType.int).value = _CustomerDocumentID
            cmd.Parameters.Add("@CustomerID", SqlDbType.int).value = NewCustomerID
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
            Dim obj As New CustomerDocumentRecord(_CustomerDocumentID, _ConnectionString)
            obj.load(_CustomerDocumentID)
            If obj.CustomerDocumentTypeID <> _CustomerDocumentTypeID Then
                blnReturn = True
            End If
            If obj.FileID <> _FileID Then
                blnReturn = True
            End If
            If obj.ExpirationDate <> _ExpirationDate Then
                blnReturn = True
            End If
            If obj.CustomerID <> _CustomerID Then
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
        ''' <param name="lngCustomerDocumentID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngCustomerDocumentID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_CustomerDocumentID)
        End Sub

     
        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngCustomerDocumentTypeID As Long, ByVal lngFileID As Long, ByVal lngCustomerID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddCustomerDocument")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCustomerDocumentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@CustomerDocumentTypeID", SqlDbType.Int).Value = lngCustomerDocumentTypeID
                cmd.Parameters.Add("@FileID", SqlDbType.Int).Value = lngFileID
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cnn.Open()
                cmd.Connection = cnn
                lngCustomerDocumentID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngCustomerDocumentID > 0 Then
                    Load(lngCustomerDocumentID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a CustomerDocument record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngCustomerDocumentID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetCustomerDocument")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerDocumentID", SqlDbType.Int).Value = lngCustomerDocumentID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _CustomerDocumentID = CType(dtr("CustomerDocumentID"), Long)
                    _CreatedBy = CType(dtr("CreatedBy"), Long)
                    _CustomerDocumentTypeID = CType(dtr("CustomerDocumentTypeID"), Long)
                    _FileID = CType(dtr("FileID"), Long)
                    _DateCreated = CType(dtr("DateCreated"), Date)
                    _ExpirationDate = CType(dtr("ExpirationDate"), Date)
                    _CustomerID = CType(dtr("CustomerID"), Long)
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
                Dim obj As New CustomerDocumentRecord(_CustomerDocumentID, _ConnectionString)
                obj.load(_CustomerDocumentID)
                If obj.CustomerDocumentTypeID <> _CustomerDocumentTypeID Then
                    UpdateCustomerDocumentTypeID(_CustomerDocumentTypeID, cnn)
                    strTemp = "CustomerDocumentTypeID Changed to '" & _CustomerDocumentTypeID & "' from '" & obj.CustomerDocumentTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.FileID <> _FileID Then
                    UpdateFileID(_FileID, cnn)
                    strTemp = "FileID Changed to '" & _FileID & "' from '" & obj.FileID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ExpirationDate <> _ExpirationDate Then
                    UpdateExpirationDate(_ExpirationDate, cnn)
                    strTemp = "ExpirationDate Changed to '" & _ExpirationDate & "' from '" & obj.ExpirationDate & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.CustomerID <> _CustomerID Then
                    UpdateCustomerID(_CustomerID, cnn)
                    strTemp = "CustomerID Changed to '" & _CustomerID & "' from '" & obj.CustomerID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_CustomerDocumentID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded CustomerDocument Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveCustomerDocument")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerDocumentID", SqlDbType.Int).Value = _CustomerDocumentID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_CustomerDocumentID)
            End If
        End Sub

#End Region

    End Class
End Namespace