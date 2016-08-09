Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface


    Public Class CellPhoneCarrierRecord

#Region "Private Constants"

        Private Const FormatMaxLength As Integer = 32


#End Region

#Region "Private Members"

        Private _CellPhoneCarrierID As Long = 0
        Private _Format As String = ""
        Private _CountryID As Long = 0
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the Format field for the currently loaded record
        ''' </summary>
        Public Property Format() As String
            Get
                Return _Format
            End Get
            Set(ByVal value As String)
                _Format = TrimTrunc(value, FormatMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the CountryID field for the currently loaded record
        ''' </summary>
        Public Property CountryID() As Long
            Get
                Return _CountryID
            End Get
            Set(ByVal value As Long)
                _CountryID = value
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
        ''' Returns the CellPhoneCarrierID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property CellPhoneCarrierID() As Long
            Get
                Return _CellPhoneCarrierID
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
            _CellPhoneCarrierID = 0
            _Format = ""
            _CountryID = 0
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
        ''' Updates the Format field for this record.
        ''' </summary>
        ''' <param name="NewFormat">The new value for theFormat field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateFormat(ByVal NewFormat As String, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateCellPhoneCarrierFormat")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CellPhoneCarrierID", SqlDbType.Int).Value = _CellPhoneCarrierID
            cmd.Parameters.Add("@Format", SqlDbType.VarChar, TrimTrunc(NewFormat, FormatMaxLength).Length).Value = TrimTrunc(NewFormat, FormatMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the CountryID field for this record.
        ''' </summary>
        ''' <param name="NewCountryID">The new value for theCountryID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCountryID(ByVal NewCountryID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateCellPhoneCarrierCountryID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CellPhoneCarrierID", SqlDbType.Int).Value = _CellPhoneCarrierID
            cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = NewCountryID
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
            Dim obj As New CellPhoneCarrierRecord(_CellPhoneCarrierID, _ConnectionString)
            obj.Load(_CellPhoneCarrierID)
            If obj.Format <> _Format Then
                blnReturn = True
            End If
            If obj.CountryID <> _CountryID Then
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
        ''' <param name="lngCellPhoneCarrierID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngCellPhoneCarrierID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_CellPhoneCarrierID)
        End Sub

        ''' <summary>
        '''  Adds a new CellPhoneCarrier record to the database.
        ''' </summary>
        ''' <param name="strFormat">The value for the Format portion of the record</param>
        ''' <param name="lngCountryID">The value for the CountryID portion of the record</param>
        Public Sub Add(ByVal strFormat As String, ByVal lngCountryID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddCellPhoneCarrier")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCellPhoneCarrierID As Long = 0
                cmd.Parameters.Add("@Format", SqlDbType.VarChar, TrimTrunc(strFormat, FormatMaxLength).Length).Value = TrimTrunc(strFormat, FormatMaxLength)
                cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = lngCountryID
                cnn.Open()
                cmd.Connection = cnn
                lngCellPhoneCarrierID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngCellPhoneCarrierID > 0 Then
                    Load(lngCellPhoneCarrierID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a CellPhoneCarrier record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngCellPhoneCarrierID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetCellPhoneCarrier")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CellPhoneCarrierID", SqlDbType.Int).Value = lngCellPhoneCarrierID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _CellPhoneCarrierID = CType(dtr("CellPhoneCarrierID"), Long)
                    _Format = dtr("Format").ToString
                    _CountryID = CType(dtr("CountryID"), Long)
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
                Dim obj As New CellPhoneCarrierRecord(_CellPhoneCarrierID, _ConnectionString)
                obj.Load(_CellPhoneCarrierID)
                If obj.Format <> _Format Then
                    UpdateFormat(_Format, cnn)
                    strTemp = "Format Changed to '" & _Format & "' from '" & obj.Format & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.CountryID <> _CountryID Then
                    UpdateCountryID(_CountryID, cnn)
                    strTemp = "CountryID Changed to '" & _CountryID & "' from '" & obj.CountryID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_CellPhoneCarrierID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded CellPhoneCarrier Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveCellPhoneCarrier")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CellPhoneCarrierID", SqlDbType.Int).Value = _CellPhoneCarrierID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_CellPhoneCarrierID)
            End If
        End Sub

#End Region




    End Class
End Namespace