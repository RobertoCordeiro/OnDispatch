Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class ProductionTypeRecord

#Region "Private Constants"

        Private Const DescriptionMaxLength As Integer = 50

#End Region

#Region "Private Members"

        Private _ProductionTypeID As Long = 0
        Private _Description As String = ""
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
        ''' Returns the ProductionTypeID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property ProductionTypeID() As Long
            Get
                Return _ProductionTypeID
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
            _ProductionTypeID = 0
            _Description = ""
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
            Dim cmd As New SqlClient.SqlCommand("spUpdateProductionTypeDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ProductionTypeID", SqlDbType.Int).Value = _ProductionTypeID
            cmd.Parameters.Add("@Description", SqlDbType.VarChar, TrimTrunc(NewDescription, DescriptionMaxLength).Length).Value = TrimTrunc(NewDescription, DescriptionMaxLength)
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
            Dim obj As New ProductionTypeRecord(_ProductionTypeID, _ConnectionString)
            obj.Load(_ProductionTypeID)
            If obj.Description <> _Description Then
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
        ''' <param name="lngProductionTypeID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngProductionTypeID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_ProductionTypeID)
        End Sub

        ''' <summary>
        '''  Adds a new ProductionType record to the database.
        ''' </summary>
        ''' <param name="strDescription">The value for the Description portion of the record</param>
        Public Sub Add(ByVal strDescription As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddProductionType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngProductionTypeID As Long = 0
                cmd.Parameters.Add("@Description", SqlDbType.VarChar, TrimTrunc(strDescription, DescriptionMaxLength).Length).Value = TrimTrunc(strDescription, DescriptionMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngProductionTypeID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngProductionTypeID > 0 Then
                    Load(lngProductionTypeID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a ProductionType record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngProductionTypeID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetProductionType")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ProductionTypeID", SqlDbType.Int).Value = lngProductionTypeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _ProductionTypeID = CType(dtr("ProductionTypeID"), Long)
                    _Description = dtr("Description").ToString
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
                Dim obj As New ProductionTypeRecord(_ProductionTypeID, _ConnectionString)
                obj.Load(_ProductionTypeID)
                If obj.Description <> _Description Then
                    UpdateDescription(_Description, cnn)
                    strTemp = "Description Changed to '" & _Description & "' from '" & obj.Description & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_ProductionTypeID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded ProductionType Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveProductionType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ProductionTypeID", SqlDbType.Int).Value = _ProductionTypeID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_ProductionTypeID)
            End If
        End Sub

#End Region

    End Class

End Namespace