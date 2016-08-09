Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class ServiceTypeRequirementRecord

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
        ''' <param name="lngServiceTypeRequirementID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngServiceTypeRequirementID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_ServiceTypeRequirementID)
        End Sub

        ''' <summary>
        '''  Adds a new ServiceTypeRequirement record to the database.
        ''' </summary>
        ''' <param name="lngServiceTypeID">The value for the ServiceTypeID portion of the record</param>
        ''' <param name="lngRequirementID">The value for the RequirementID portion of the record</param>
        Public Sub Add(ByVal lngServiceTypeID As Long, ByVal lngRequirementID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddServiceTypeRequirement")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngServiceTypeRequirementID As Long = 0
                cmd.Parameters.Add("@ServiceTypeID", SQLDBType.int).Value = lngServiceTypeID
                cmd.Parameters.Add("@RequirementID", SQLDBType.int).Value = lngRequirementID
                cnn.Open()
                cmd.Connection = cnn
                lngServiceTypeRequirementID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngServiceTypeRequirementID > 0 Then
                    Load(lngServiceTypeRequirementID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a ServiceTypeRequirement record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngServiceTypeRequirementID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetServiceTypeRequirement")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ServiceTypeRequirementID", SqlDbType.Int).Value = lngServiceTypeRequirementID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _ServiceTypeRequirementID = CType(dtr("ServiceTypeRequirementID"), Long)
                    _ServiceTypeID = CType(dtr("ServiceTypeID"), Long)
                    _RequirementID = CType(dtr("RequirementID"), Long)
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
                Dim obj As New ServiceTypeRequirementRecord(_ServiceTypeRequirementID, _ConnectionString)
                obj.Load(_ServiceTypeRequirementID)
                If obj.ServiceTypeID <> _ServiceTypeID Then
                    UpdateServiceTypeID(_ServiceTypeID, cnn)
                    strTemp = "ServiceTypeID Changed to '" & _ServiceTypeID & "' from '" & obj.ServiceTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.RequirementID <> _RequirementID Then
                    UpdateRequirementID(_RequirementID, cnn)
                    strTemp = "RequirementID Changed to '" & _RequirementID & "' from '" & obj.RequirementID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ExpirationDate <> _ExpirationDate Then
                    UpdateExpirationDate(_ExpirationDate, cnn)
                    strTemp = "ExpirationDate Changed to '" & _ExpirationDate & "' from '" & obj.ExpirationDate & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_ServiceTypeRequirementID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded ServiceTypeRequirement Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveServiceTypeRequirement")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ServiceTypeRequirementID", SqlDbType.Int).Value = _ServiceTypeRequirementID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_ServiceTypeRequirementID)
            End If
        End Sub

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the ServiceTypeID field for the currently loaded record
        ''' </summary>
        Public Property ServiceTypeID() As Long
            Get
                Return _ServiceTypeID
            End Get
            Set(ByVal value As Long)
                _ServiceTypeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the RequirementID field for the currently loaded record
        ''' </summary>
        Public Property RequirementID() As Long
            Get
                Return _RequirementID
            End Get
            Set(ByVal value As Long)
                _RequirementID = value
            End Set
        End Property

        ' Returns/Sets the ExpirationDate field for the currently loaded record

        Public Property ExpirationDate() As DateTime
            Get
                Return _ExpirationDate
            End Get
            Set(ByVal value As DateTime)
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
        ''' Returns the ServiceTypeRequirementID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property ServiceTypeRequirementID() As Long
            Get
                Return _ServiceTypeRequirementID
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
            _ServiceTypeRequirementID = 0
            _ServiceTypeID = 0
            _RequirementID = 0
            _ExpirationDate = Nothing
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
        ''' Updates the ServiceTypeID field for this record.
        ''' </summary>
        ''' <param name="NewServiceTypeID">The new value for theServiceTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateServiceTypeID(ByVal NewServiceTypeID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateServiceTypeRequirementServiceTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ServiceTypeRequirementID", sqlDBType.int).value = _ServiceTypeRequirementID
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.int).value = NewServiceTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the RequirementID field for this record.
        ''' </summary>
        ''' <param name="NewRequirementID">The new value for theRequirementID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateRequirementID(ByVal NewRequirementID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateServiceTypeRequirementRequirementID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ServiceTypeRequirementID", sqlDBType.int).value = _ServiceTypeRequirementID
            cmd.Parameters.Add("@RequirementID", SqlDbType.int).value = NewRequirementID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ExpirationDate field for this record.
        ''' </summary>
        ''' <param name="NewExpirationDate">The new value for theExpirationDate field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateExpirationDate(ByVal NewExpirationDate As DateTime, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateServiceTypeRequirementExpirationDate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceTypeRequirementID", SqlDbType.Int).Value = _ServiceTypeRequirementID
            If IsDate(NewExpirationDate) Then
                cmd.Parameters.Add("@ExpirationDate", SqlDbType.SmallDateTime).Value = NewExpirationDate
            Else
                cmd.Parameters.Add("@ExpirationDate", SqlDbType.SmallDateTime).Value = System.DBNull.Value
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
            Dim obj As New ServiceTypeRequirementRecord(_ServiceTypeRequirementID, _ConnectionString)
            obj.Load(_ServiceTypeRequirementID)
            If obj.ServiceTypeID <> _ServiceTypeID Then
                blnReturn = True
            End If
            If obj.RequirementID <> _RequirementID Then
                blnReturn = True
            End If
            If obj.ExpirationDate <> _ExpirationDate Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region


#Region "Private Members"

        Private _ServiceTypeRequirementID As Long = 0
        Private _ServiceTypeID As Long = 0
        Private _RequirementID As Long = 0
        Private _ExpirationDate As DateTime = Nothing
        Private _ConnectionString As String = ""

#End Region
    End Class
End Namespace