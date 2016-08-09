Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class CustomerDocumentTypeRecord

#Region "Private Constants"

        Private Const DescriptionMaxLength As Integer = 32

#End Region

#Region "Private Members"

        Private _CustomerDocumentTypeID As Long = 0
        Private _CreatedBy As Long = 0
        Private _Description As String = ""
        Private _DateCreated As Date = DateTime.Now
        Private _ExpirationDate As Date = DateTime.Now
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the Description field for the currently loaded record
        ''' </summary>
        Public Property Description() As String
            Get
                Return _Description
            End Get
            Set(ByVal value As String)
                _Description = TrimTrunc(value, DescriptionMaxLength)
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
        ''' Returns the CustomerDocumentTypeID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property CustomerDocumentTypeID() As Long
            Get
                Return _CustomerDocumentTypeID
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
            _CustomerDocumentTypeID = 0
            _CreatedBy = 0
            _Description = ""
            _DateCreated = DateTime.Now
            _ExpirationDate = DateTime.Now
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
        ''' Updates the Description field for this record.
        ''' </summary>
        ''' <param name="NewDescription">The new value for theDescription field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDescription(ByVal NewDescription As String, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateCustomerDocumentTypeDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerDocumentTypeID", SqlDbType.Int).Value = _CustomerDocumentTypeID
            cmd.Parameters.Add("@Description", SqlDbType.VarChar, TrimTrunc(NewDescription, DescriptionMaxLength).Length).Value = TrimTrunc(NewDescription, DescriptionMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ExpirationDate field for this record.
        ''' </summary>
        ''' <param name="NewExpirationDate">The new value for theExpirationDate field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateExpirationDate(ByVal NewExpirationDate As Date, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateCustomerDocumentTypeExpirationDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerDocumentTypeID", SqlDbType.Int).Value = _CustomerDocumentTypeID
            If NewExpirationDate.ToString.Length > 0 Then
                cmd.Parameters.Add("@ExpirationDate", SqlDbType.DateTime).Value = NewExpirationDate
            Else
                cmd.Parameters.Add("@ExpirationDate", SqlDbType.DateTime).Value = System.DBNull.Value
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
            Dim obj As New CustomerDocumentTypeRecord(_CustomerDocumentTypeID, _ConnectionString)
            obj.Load(_CustomerDocumentTypeID)
            If obj.Description <> _Description Then
                blnReturn = True
            End If
            If obj.ExpirationDate <> _ExpirationDate Then
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
        ''' <param name="lngCustomerDocumentTypeID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngCustomerDocumentTypeID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_CustomerDocumentTypeID)
        End Sub

        ''' <summary>
        '''  Adds a new CustomerDocumentType record to the database.
        ''' </summary>
        ''' <param name="lngCreatedBy">The value for the CreatedBy portion of the record</param>
        ''' <param name="strDescription">The value for the Description portion of the record</param>
        ''' <param name="datDateCreated">The value for the DateCreated portion of the record</param>
        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strDescription As String, ByVal datDateCreated As Date)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddCustomerDocumentType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCustomerDocumentTypeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Description", SqlDbType.VarChar, TrimTrunc(strDescription, DescriptionMaxLength).Length).Value = TrimTrunc(strDescription, DescriptionMaxLength)
                cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = datDateCreated
                cnn.Open()
                cmd.Connection = cnn
                lngCustomerDocumentTypeID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngCustomerDocumentTypeID > 0 Then
                    Load(lngCustomerDocumentTypeID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a CustomerDocumentType record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngCustomerDocumentTypeID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetCustomerDocumentType")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerDocumentTypeID", SqlDbType.Int).Value = lngCustomerDocumentTypeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _CustomerDocumentTypeID = CType(dtr("CustomerDocumentTypeID"), Long)
                    _CreatedBy = CType(dtr("CreatedBy"), Long)
                    _Description = dtr("Description").ToString
                    _DateCreated = CType(dtr("DateCreated"), Date)
                    If Not IsDBNull(dtr("ExpirationDate")) Then
                        _ExpirationDate = CType(dtr("ExpirationDate"), Date)
                    Else
                        _ExpirationDate = DateTime.Now
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
                Dim obj As New CustomerDocumentTypeRecord(_CustomerDocumentTypeID, _ConnectionString)
                obj.Load(_CustomerDocumentTypeID)
                If obj.Description <> _Description Then
                    UpdateDescription(_Description, cnn)
                    strTemp = "Description Changed to '" & _Description & "' from '" & obj.Description & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ExpirationDate <> _ExpirationDate Then
                    UpdateExpirationDate(_ExpirationDate, cnn)
                    strTemp = "ExpirationDate Changed to '" & _ExpirationDate & "' from '" & obj.ExpirationDate & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_CustomerDocumentTypeID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded CustomerDocumentType Record
        ''' </summary>
        Public Sub Delete()

            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveCustomerDocumentType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerDocumentTypeID", SqlDbType.Int).Value = _CustomerDocumentTypeID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_CustomerDocumentTypeID)
            End If
        End Sub

#End Region

    End Class
End Namespace