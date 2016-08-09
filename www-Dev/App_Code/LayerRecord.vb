Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class LayerRecord

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
        ''' <param name="lngLayerID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngLayerID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_LayerID)
        End Sub

        ''' <summary>
        '''  Adds a new Layer record to the database.
        ''' </summary>
        ''' <param name="strLayerName">The value for the LayerName portion of the record</param>
        Public Sub Add(ByVal strLayerName As String, ByVal lngInfoID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddLayer")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngLayerID As Long = 0
                cmd.Parameters.Add("@LayerName", SqlDbType.VarChar, TrimTrunc(strLayerName, LayerNameMaxLength).Length).Value = TrimTrunc(strLayerName, LayerNameMaxLength)
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = lngInfoID
                cnn.Open()
                cmd.Connection = cnn
                lngLayerID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngLayerID > 0 Then
                    Load(lngLayerID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a Layer record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngLayerID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetLayer")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@LayerID", SqlDbType.Int).Value = lngLayerID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _LayerID = CType(dtr("LayerID"), Long)
                    _LayerName = dtr("LayerName").ToString
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
                Dim obj As New LayerRecord(_LayerID, _ConnectionString)
                obj.Load(_LayerID)
                If obj.LayerName <> _LayerName Then
                    UpdateLayerName(_LayerName, cnn)
                    strTemp = "LayerName Changed to '" & _LayerName & "' from '" & obj.LayerName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.InfoID <> _InfoID Then
                    UpdateInfoID(_InfoID, cnn)
                    strTemp = "InfoID changed to '" & _InfoID & "' from '" & obj.InfoID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_LayerID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded Layer Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveLayer")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@LayerID", SqlDbType.Int).Value = _LayerID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_LayerID)
            End If
        End Sub

#End Region


#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the LayerName field for the currently loaded record
        ''' </summary>
        Public Property LayerName() As String
            Get
                Return _LayerName
            End Get
            Set(ByVal value As String)
                _LayerName = TrimTrunc(value, LayerNameMaxLength)
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
        Public Property InfoID() As Long
            Get
                Return _InfoID
            End Get
            Set(ByVal value As Long)
                _InfoID = value
            End Set
        End Property

#End Region

#Region "ReadOnly Properties"

        ''' <summary>
        ''' Returns the LayerID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property LayerID() As Long
            Get
                Return _LayerID
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
            _LayerID = 0
            _LayerName = ""
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
        ''' Updates the LayerName field for this record.
        ''' </summary>
        ''' <param name="NewLayerName">The new value for theLayerName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateLayerName(ByVal NewLayerName As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateLayerLayerName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@LayerID", sqlDBType.int).value = _LayerID
            cmd.Parameters.Add("@LayerName", SqlDbType.varchar, TrimTrunc(NewLayerName, LayerNameMaxLength).Length).value = TrimTrunc(NewLayerName, LayerNameMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateInfoID(ByVal NewInfoID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateLayerInfoID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@LayerID", SqlDbType.Int).Value = _LayerID
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = NewInfoID
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
            Dim obj As New LayerRecord(_LayerID, _ConnectionString)
            obj.Load(_LayerID)
            If obj.LayerName <> _LayerName Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region


#Region "Private Constants"

        Private Const LayerNameMaxLength As Integer = 50

#End Region

#Region "Private Members"

        Private _LayerID As Long = 0
        Private _LayerName As String = ""
        Private _InfoID As Long = 0
        Private _ConnectionString As String = ""

#End Region
    End Class
End Namespace
