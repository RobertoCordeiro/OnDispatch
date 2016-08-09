Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class ProductionLogRecord

#Region "Private Constants"

        Private Const ActionMaxLength As Integer = 256

#End Region

#Region "Private Members"

        Private _ProductionLogID As Long = 0
        Private _UserID As Long = 0
        Private _DateEntered As Date = DateTime.Now
        Private _ProductionTypeID As Long = 0
        Private _Action As String = ""
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
        ''' Returns/Sets the DateEntered field for the currently loaded record
        ''' </summary>
        Public Property DateEntered() As Date
            Get
                Return _DateEntered
            End Get
            Set(ByVal value As Date)
                _DateEntered = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ProductionTypeID field for the currently loaded record
        ''' </summary>
        Public Property ProductionTypeID() As Long
            Get
                Return _ProductionTypeID
            End Get
            Set(ByVal value As Long)
                _ProductionTypeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Action field for the currently loaded record
        ''' </summary>
        Public Property Action() As String
            Get
                Return _Action
            End Get
            Set(ByVal value As String)
                _Action = TrimTrunc(value, ActionMaxLength)
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
        ''' Returns the ProductionLogID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property ProductionLogID() As Long
            Get
                Return _ProductionLogID
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
            _ProductionLogID = 0
            _UserID = 0
            _DateEntered = DateTime.Now
            _ProductionTypeID = 0
            _Action = ""
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
            Dim cmd As New sqlClient.sqlCommand("spUpdateProductionLogUserID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ProductionLogID", sqlDBType.int).value = _ProductionLogID
            cmd.Parameters.Add("@UserID", SqlDbType.int).value = NewUserID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the DateEntered field for this record.
        ''' </summary>
        ''' <param name="NewDateEntered">The new value for theDateEntered field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDateEntered(ByVal NewDateEntered As Date, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateProductionLogDateEntered")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ProductionLogID", sqlDBType.int).value = _ProductionLogID
            cmd.Parameters.Add("@DateEntered", SqlDbType.datetime).value = NewDateEntered
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ProductionTypeID field for this record.
        ''' </summary>
        ''' <param name="NewProductionTypeID">The new value for theProductionTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateProductionTypeID(ByVal NewProductionTypeID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateProductionLogProductionTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ProductionLogID", sqlDBType.int).value = _ProductionLogID
            cmd.Parameters.Add("@ProductionTypeID", SqlDbType.int).value = NewProductionTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Action field for this record.
        ''' </summary>
        ''' <param name="NewAction">The new value for theAction field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateAction(ByVal NewAction As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateProductionLogAction")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ProductionLogID", sqlDBType.int).value = _ProductionLogID
            cmd.Parameters.Add("@Action", SqlDbType.varchar, TrimTrunc(NewAction, ActionMaxLength).Length).value = TrimTrunc(NewAction, ActionMaxLength)
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
            Dim obj As New ProductionLogRecord(_ProductionLogID, _ConnectionString)
            obj.load(_ProductionLogID)
            If obj.UserID <> _UserID Then
                blnReturn = True
            End If
            If obj.DateEntered <> _DateEntered Then
                blnReturn = True
            End If
            If obj.ProductionTypeID <> _ProductionTypeID Then
                blnReturn = True
            End If
            If obj.Action <> _Action Then
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
        ''' <param name="lngProductionLogID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngProductionLogID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_ProductionLogID)
        End Sub

        ''' <summary>
        '''  Adds a new ProductionLog record to the database.
        ''' </summary>
        ''' <param name="lngUserID">The value for the UserID portion of the record</param>
        ''' <param name="datDateEntered">The value for the DateEntered portion of the record</param>
        ''' <param name="lngProductionTypeID">The value for the ProductionTypeID portion of the record</param>
        ''' <param name="strAction">The value for the Action portion of the record</param>
        Public Sub Add(ByVal lngUserID As Long, ByVal datDateEntered As Date, ByVal lngProductionTypeID As Long, ByVal strAction As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddProductionLog")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngProductionLogID As Long = 0
                cmd.Parameters.Add("@UserID", SQLDBType.int).Value = lngUserID
                cmd.Parameters.Add("@DateEntered", SQLDBType.datetime).Value = datDateEntered
                cmd.Parameters.Add("@ProductionTypeID", SQLDBType.int).Value = lngProductionTypeID
                cmd.Parameters.Add("@Action", SQLDBType.varchar, TrimTrunc(strAction, ActionMaxLength).Length).Value = TrimTrunc(strAction, ActionMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngProductionLogID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngProductionLogID > 0 Then
                    Load(lngProductionLogID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a ProductionLog record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngProductionLogID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetProductionLog")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ProductionLogID", SqlDbType.Int).Value = lngProductionLogID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _ProductionLogID = CType(dtr("ProductionLogID"), Long)
                    _UserID = CType(dtr("UserID"), Long)
                    _DateEntered = CType(dtr("DateEntered"), Date)
                    _ProductionTypeID = CType(dtr("ProductionTypeID"), Long)
                    _Action = dtr("Action").ToString
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
                Dim obj As New ProductionLogRecord(_ProductionLogID, _ConnectionString)
                obj.load(_ProductionLogID)
                If obj.UserID <> _UserID Then
                    UpdateUserID(_UserID, cnn)
                    strTemp = "UserID Changed to '" & _UserID & "' from '" & obj.UserID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.DateEntered <> _DateEntered Then
                    UpdateDateEntered(_DateEntered, cnn)
                    strTemp = "DateEntered Changed to '" & _DateEntered & "' from '" & obj.DateEntered & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ProductionTypeID <> _ProductionTypeID Then
                    UpdateProductionTypeID(_ProductionTypeID, cnn)
                    strTemp = "ProductionTypeID Changed to '" & _ProductionTypeID & "' from '" & obj.ProductionTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Action <> _Action Then
                    UpdateAction(_Action, cnn)
                    strTemp = "Action Changed to '" & _Action & "' from '" & obj.Action & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_ProductionLogID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded ProductionLog Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveProductionLog")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ProductionLogID", SqlDbType.Int).Value = _ProductionLogID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_ProductionLogID)
            End If
        End Sub

#End Region

    End Class
End Namespace