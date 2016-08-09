Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class TicketFolderRecord

#Region "Private Constants"

        Private Const FolderNameMaxLength As Integer = 64

#End Region

#Region "Private Members"

        Private _TicketFolderID As Long = 0
        Private _CreatedBy As Long = 0
        Private _FolderName As String = ""
        Private _Personal As Boolean = False
        Private _Shared As Boolean = False
        Private _CustomerViewable As Boolean = False
        Private _PartnerViewable As Boolean = False
        Private _DisplayOrder As Long = 0
        Private _DateCreated As Date = DateTime.Now
        Private _InfoID As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the FolderName field for the currently loaded record
        ''' </summary>
        Public Property FolderName() As String
            Get
                Return _FolderName
            End Get
            Set(ByVal value As String)
                _FolderName = TrimTrunc(value, FolderNameMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Personal field for the currently loaded record
        ''' </summary>
        Public Property Personal() As Boolean
            Get
                Return _Personal
            End Get
            Set(ByVal value As Boolean)
                _Personal = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Shared field for the currently loaded record
        ''' </summary>
        Public Property [Shared]() As Boolean
            Get
                Return _Shared
            End Get
            Set(ByVal value As Boolean)
                _Shared = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the CustomerViewable field for the currently loaded record
        ''' </summary>
        Public Property CustomerViewable() As Boolean
            Get
                Return _CustomerViewable
            End Get
            Set(ByVal value As Boolean)
                _CustomerViewable = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the PartnerViewable field for the currently loaded record
        ''' </summary>
        Public Property PartnerViewable() As Boolean
            Get
                Return _PartnerViewable
            End Get
            Set(ByVal value As Boolean)
                _PartnerViewable = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the DisplayOrder field for the currently loaded record
        ''' </summary>
        Public Property DisplayOrder() As Long
            Get
                Return _DisplayOrder
            End Get
            Set(ByVal value As Long)
                _DisplayOrder = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the InfoID field for the currently loaded record
        ''' </summary>
        Public Property InfoID() As Long
            Get
                Return _InfoID
            End Get
            Set(ByVal value As Long)
                _InfoID = value
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
        ''' Returns the TicketFolderID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property TicketFolderID() As Long
            Get
                Return _TicketFolderID
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
            _TicketFolderID = 0
            _CreatedBy = 0
            _FolderName = ""
            _Personal = False
            _Shared = False
            _CustomerViewable = False
            _PartnerViewable = False
            _DisplayOrder = 0
            _DateCreated = DateTime.Now
            _InfoID = 0
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
        ''' Updates the FolderName field for this record.
        ''' </summary>
        ''' <param name="NewFolderName">The new value for theFolderName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateFolderName(ByVal NewFolderName As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketFolderFolderName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketFolderID", sqlDBType.int).value = _TicketFolderID
            cmd.Parameters.Add("@FolderName", SqlDbType.varchar, TrimTrunc(NewFolderName, FolderNameMaxLength).Length).value = TrimTrunc(NewFolderName, FolderNameMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Personal field for this record.
        ''' </summary>
        ''' <param name="NewPersonal">The new value for thePersonal field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePersonal(ByVal NewPersonal As Boolean, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketFolderPersonal")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketFolderID", sqlDBType.int).value = _TicketFolderID
            cmd.Parameters.Add("@Personal", SqlDbType.bit).value = NewPersonal
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Shared field for this record.
        ''' </summary>
        ''' <param name="NewShared">The new value for theShared field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateShared(ByVal NewShared As Boolean, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketFolderShared")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketFolderID", sqlDBType.int).value = _TicketFolderID
            cmd.Parameters.Add("@Shared", SqlDbType.bit).value = NewShared
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the CustomerViewable field for this record.
        ''' </summary>
        ''' <param name="NewCustomerViewable">The new value for theCustomerViewable field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCustomerViewable(ByVal NewCustomerViewable As Boolean, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketFolderCustomerViewable")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketFolderID", sqlDBType.int).value = _TicketFolderID
            cmd.Parameters.Add("@CustomerViewable", SqlDbType.bit).value = NewCustomerViewable
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the PartnerViewable field for this record.
        ''' </summary>
        ''' <param name="NewPartnerViewable">The new value for thePartnerViewable field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerViewable(ByVal NewPartnerViewable As Boolean, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketFolderPartnerViewable")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketFolderID", sqlDBType.int).value = _TicketFolderID
            cmd.Parameters.Add("@PartnerViewable", SqlDbType.bit).value = NewPartnerViewable
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the DisplayOrder field for this record.
        ''' </summary>
        ''' <param name="NewDisplayOrder">The new value for theDisplayOrder field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDisplayOrder(ByVal NewDisplayOrder As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketFolderDisplayOrder")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketFolderID", sqlDBType.int).value = _TicketFolderID
            cmd.Parameters.Add("@DisplayOrder", SqlDbType.int).value = NewDisplayOrder
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the InfoID field for this record.
        ''' </summary>
        ''' <param name="NewInfoID">The new value for theInfoID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateInfoID(ByVal NewInfoID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketFolderInfoID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketFolderID", sqlDBType.int).value = _TicketFolderID
            cmd.Parameters.Add("@InfoID", SqlDbType.int).value = NewInfoID
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
            Dim obj As New TicketFolderRecord(_TicketFolderID, _ConnectionString)
            obj.Load(_TicketFolderID)
            If obj.FolderName <> _FolderName Then
                blnReturn = True
            End If
            If obj.Personal <> _Personal Then
                blnReturn = True
            End If
            If obj.Shared <> _Shared Then
                blnReturn = True
            End If
            If obj.CustomerViewable <> _CustomerViewable Then
                blnReturn = True
            End If
            If obj.PartnerViewable <> _PartnerViewable Then
                blnReturn = True
            End If
            If obj.DisplayOrder <> _DisplayOrder Then
                blnReturn = True
            End If
            If obj.InfoID <> _InfoID Then
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
        ''' <param name="lngTicketFolderID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngTicketFolderID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_TicketFolderID)
        End Sub

        ''' <summary>
        '''  Adds a new TicketFolder record to the database.
        ''' </summary>
        ''' <param name="lngCreatedBy">The value for the CreatedBy portion of the record</param>
        ''' <param name="strFolderName">The value for the FolderName portion of the record</param>
        ''' <param name="blnPersonal">The value for the Personal portion of the record</param>
        ''' <param name="blnShared">The value for the Shared portion of the record</param>
        ''' <param name="blnCustomerViewable">The value for the CustomerViewable portion of the record</param>
        ''' <param name="blnPartnerViewable">The value for the PartnerViewable portion of the record</param>
        ''' <param name="lngDisplayOrder">The value for the DisplayOrder portion of the record</param>
        ''' <param name="datDateCreated">The value for the DateCreated portion of the record</param>
        ''' <param name="lngInfoID">The value for the InfoID portion of the record</param>
        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strFolderName As String, ByVal blnPersonal As Boolean, ByVal blnShared As Boolean, ByVal blnCustomerViewable As Boolean, ByVal blnPartnerViewable As Boolean, ByVal lngDisplayOrder As Long, ByVal datDateCreated As Date, ByVal lngInfoID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddTicketFolder")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketFolderID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SQLDBType.int).Value = lngCreatedBy
                cmd.Parameters.Add("@FolderName", SQLDBType.varchar, TrimTrunc(strFolderName, FolderNameMaxLength).Length).Value = TrimTrunc(strFolderName, FolderNameMaxLength)
                cmd.Parameters.Add("@Personal", SQLDBType.bit).Value = blnPersonal
                cmd.Parameters.Add("@Shared", SQLDBType.bit).Value = blnShared
                cmd.Parameters.Add("@CustomerViewable", SQLDBType.bit).Value = blnCustomerViewable
                cmd.Parameters.Add("@PartnerViewable", SQLDBType.bit).Value = blnPartnerViewable
                cmd.Parameters.Add("@DisplayOrder", SQLDBType.int).Value = lngDisplayOrder
                cmd.Parameters.Add("@DateCreated", SQLDBType.datetime).Value = datDateCreated
                cmd.Parameters.Add("@InfoID", SQLDBType.int).Value = lngInfoID
                cnn.Open()
                cmd.Connection = cnn
                lngTicketFolderID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngTicketFolderID > 0 Then
                    Load(lngTicketFolderID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a TicketFolder record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngTicketFolderID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetTicketFolder")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketFolderID", SqlDbType.Int).Value = lngTicketFolderID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _TicketFolderID = CType(dtr("TicketFolderID"), Long)
                    _CreatedBy = CType(dtr("CreatedBy"), Long)
                    _FolderName = dtr("FolderName").ToString
                    _Personal = CType(dtr("Personal"), Boolean)
                    _Shared = CType(dtr("Shared"), Boolean)
                    _CustomerViewable = CType(dtr("CustomerViewable"), Boolean)
                    _PartnerViewable = CType(dtr("PartnerViewable"), Boolean)
                    _DisplayOrder = CType(dtr("DisplayOrder"), Long)
                    _DateCreated = CType(dtr("DateCreated"), Date)
                    _InfoID = CType(dtr("InfoID"), Long)
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
                Dim obj As New TicketFolderRecord(_TicketFolderID, _ConnectionString)
                obj.Load(_TicketFolderID)
                If obj.FolderName <> _FolderName Then
                    UpdateFolderName(_FolderName, cnn)
                    strTemp = "FolderName Changed to '" & _FolderName & "' from '" & obj.FolderName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Personal <> _Personal Then
                    UpdatePersonal(_Personal, cnn)
                    strTemp = "Personal Changed to '" & _Personal & "' from '" & obj.Personal & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Shared <> _Shared Then
                    UpdateShared(_Shared, cnn)
                    strTemp = "Shared Changed to '" & _Shared & "' from '" & obj.Shared & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.CustomerViewable <> _CustomerViewable Then
                    UpdateCustomerViewable(_CustomerViewable, cnn)
                    strTemp = "CustomerViewable Changed to '" & _CustomerViewable & "' from '" & obj.CustomerViewable & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.PartnerViewable <> _PartnerViewable Then
                    UpdatePartnerViewable(_PartnerViewable, cnn)
                    strTemp = "PartnerViewable Changed to '" & _PartnerViewable & "' from '" & obj.PartnerViewable & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.DisplayOrder <> _DisplayOrder Then
                    UpdateDisplayOrder(_DisplayOrder, cnn)
                    strTemp = "DisplayOrder Changed to '" & _DisplayOrder & "' from '" & obj.DisplayOrder & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.InfoID <> _InfoID Then
                    UpdateInfoID(_InfoID, cnn)
                    strTemp = "InfoID Changed to '" & _InfoID & "' from '" & obj.InfoID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_TicketFolderID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded TicketFolder Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveTicketFolder")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketFolderID", SqlDbType.Int).Value = _TicketFolderID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_TicketFolderID)
            End If
        End Sub

#End Region

    End Class
End Namespace