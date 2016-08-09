Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class LayerTerritoryAssignmentRecord

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
        ''' <param name="lngLayerTerritoryAssignmentID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngLayerTerritoryAssignmentID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_LayerTerritoryAssignmentID)
        End Sub

        ''' <summary>
        '''  Adds a new LayerTerritoryAssignment record to the database.
        ''' </summary>
        ''' <param name="lngLayerID">The value for the LayerID portion of the record</param>
        ''' <param name="lngTerritoryID">The value for the TerritoryID portion of the record</param>
        ''' <param name="lngZipCodeID">The value for the ZipCodeID portion of the record</param>
        Public Sub Add(ByVal lngLayerID As Long, ByVal lngTerritoryID As Long, ByVal lngZipCodeID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddLayerTerritoryAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngLayerTerritoryAssignmentID As Long = 0
                cmd.Parameters.Add("@LayerID", SQLDBType.int).Value = lngLayerID
                cmd.Parameters.Add("@TerritoryID", SQLDBType.int).Value = lngTerritoryID
                cmd.Parameters.Add("@ZipCodeID", SQLDBType.int).Value = lngZipCodeID
                cnn.Open()
                cmd.Connection = cnn
                lngLayerTerritoryAssignmentID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngLayerTerritoryAssignmentID > 0 Then
                    Load(lngLayerTerritoryAssignmentID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a LayerTerritoryAssignment record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngLayerTerritoryAssignmentID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetLayerTerritoryAssignment")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@LayerTerritoryAssignmentID", SqlDbType.Int).Value = lngLayerTerritoryAssignmentID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _LayerTerritoryAssignmentID = CType(dtr("LayerTerritoryAssignmentID"), Long)
                    _LayerID = CType(dtr("LayerID"), Long)
                    _TerritoryID = CType(dtr("TerritoryID"), Long)
                    _ZipCodeID = CType(dtr("ZipCodeID"), Long)
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
                Dim obj As New LayerTerritoryAssignmentRecord(_LayerTerritoryAssignmentID, _ConnectionString)
                obj.Load(_LayerTerritoryAssignmentID)
                If obj.LayerID <> _LayerID Then
                    UpdateLayerID(_LayerID, cnn)
                    strTemp = "LayerID Changed to '" & _LayerID & "' from '" & obj.LayerID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.TerritoryID <> _TerritoryID Then
                    UpdateTerritoryID(_TerritoryID, cnn)
                    strTemp = "TerritoryID Changed to '" & _TerritoryID & "' from '" & obj.TerritoryID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ZipCodeID <> _ZipCodeID Then
                    UpdateZipCodeID(_ZipCodeID, cnn)
                    strTemp = "ZipCodeID Changed to '" & _ZipCodeID & "' from '" & obj.ZipCodeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_LayerTerritoryAssignmentID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded LayerTerritoryAssignment Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveLayerTerritoryAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@LayerTerritoryAssignmentID", SqlDbType.Int).Value = _LayerTerritoryAssignmentID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_LayerTerritoryAssignmentID)
            End If
        End Sub

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the LayerID field for the currently loaded record
        ''' </summary>
        Public Property LayerID() As Long
            Get
                Return _LayerID
            End Get
            Set(ByVal value As Long)
                _LayerID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the TerritoryID field for the currently loaded record
        ''' </summary>
        Public Property TerritoryID() As Long
            Get
                Return _TerritoryID
            End Get
            Set(ByVal value As Long)
                _TerritoryID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ZipCodeID field for the currently loaded record
        ''' </summary>
        Public Property ZipCodeID() As Long
            Get
                Return _ZipCodeID
            End Get
            Set(ByVal value As Long)
                _ZipCodeID = value
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
        ''' Returns the LayerTerritoryAssignmentID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property LayerTerritoryAssignmentID() As Long
            Get
                Return _LayerTerritoryAssignmentID
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
            _LayerTerritoryAssignmentID = 0
            _LayerID = 0
            _TerritoryID = 0
            _ZipCodeID = 0
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
        ''' Updates the LayerID field for this record.
        ''' </summary>
        ''' <param name="NewLayerID">The new value for theLayerID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateLayerID(ByVal NewLayerID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateLayerTerritoryAssignmentLayerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@LayerTerritoryAssignmentID", sqlDBType.int).value = _LayerTerritoryAssignmentID
            cmd.Parameters.Add("@LayerID", SqlDbType.int).value = NewLayerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the TerritoryID field for this record.
        ''' </summary>
        ''' <param name="NewTerritoryID">The new value for theTerritoryID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTerritoryID(ByVal NewTerritoryID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateLayerTerritoryAssignmentTerritoryID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@LayerTerritoryAssignmentID", sqlDBType.int).value = _LayerTerritoryAssignmentID
            cmd.Parameters.Add("@TerritoryID", SqlDbType.int).value = NewTerritoryID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ZipCodeID field for this record.
        ''' </summary>
        ''' <param name="NewZipCodeID">The new value for theZipCodeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateZipCodeID(ByVal NewZipCodeID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateLayerTerritoryAssignmentZipCodeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@LayerTerritoryAssignmentID", sqlDBType.int).value = _LayerTerritoryAssignmentID
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.int).value = NewZipCodeID
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
            Dim obj As New LayerTerritoryAssignmentRecord(_LayerTerritoryAssignmentID, _ConnectionString)
            obj.Load(_LayerTerritoryAssignmentID)
            If obj.LayerID <> _LayerID Then
                blnReturn = True
            End If
            If obj.TerritoryID <> _TerritoryID Then
                blnReturn = True
            End If
            If obj.ZipCodeID <> _ZipCodeID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region


#Region "Private Members"

        Private _LayerTerritoryAssignmentID As Long = 0
        Private _LayerID As Long = 0
        Private _TerritoryID As Long = 0
        Private _ZipCodeID As Long = 0
        Private _ConnectionString As String = ""

#End Region
    End Class
End Namespace