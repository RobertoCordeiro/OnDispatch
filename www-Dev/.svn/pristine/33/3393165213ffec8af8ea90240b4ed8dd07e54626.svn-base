Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.InteropServices

Namespace BridgesInterface

    Public Class LocationRecord

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
            Me._ConnectionString = strConnectionString
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object and loads by the passed in Primary Key
        ''' </summary>
        ''' <param name="lngLocationID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngLocationID As Long, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Load(Me._LocationID)
        End Sub

        ''' <summary>
        '''  Adds a new Location record to the database.
        ''' </summary>
        ''' <param name="strLocationName">The value for the LocationName portion of the record</param>
        ''' <param name="lngPartnerAddressID">The value for the PartnerAddressID portion of the record</param>
        Public Sub Add(ByVal strLocationName As String, ByVal lngPartnerAddressID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddLocation")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngLocationID As Long = 0
                cmd.Parameters.Add("@LocationName", SqlDbType.VarChar, TrimTrunc(strLocationName, LocationNameMaxLength).Length).Value = TrimTrunc(strLocationName, LocationNameMaxLength)
                cmd.Parameters.Add("@PartnerAddressID", SqlDbType.Int).Value = lngPartnerAddressID
                cnn.Open()
                cmd.Connection = cnn
                lngLocationID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngLocationID > 0 Then
                    Load(lngLocationID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a Location record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngLocationID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetLocation")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@LocationID", SqlDbType.Int).Value = lngLocationID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._LocationID = CType(dtr("LocationID"), Long)
                    Me._LocationName = dtr("LocationName").ToString
                    Me._PartnerAddressID = CType(dtr("PartnerAddressID"), Long)
                Else
                    ClearValues()
                End If
                cnn.Close()
            End If
        End Sub

        Public Sub GetLocationName(ByVal lngZipCodeID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetLocationByZipCodeID")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = lngZipCodeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._LocationID = CType(dtr("LocationID"), Long)
                    Me._LocationName = dtr("LocationName").ToString
                    Me._PartnerAddressID = CType(dtr("PartnerAddressID"), Long)
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
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open()
                Dim obj As New LocationRecord(Me._LocationID, Me._ConnectionString)
                obj.Load(Me._LocationID)
                If obj.LocationName <> Me._LocationName Then
                    UpdateLocationName(Me._LocationName, cnn)
                    strTemp = "LocationName Changed to '" & Me._LocationName & "' from '" & obj.LocationName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.PartnerAddressID <> Me._PartnerAddressID Then
                    UpdatePartnerAddressID(Me._PartnerAddressID, cnn)
                    strTemp = "PartnerAddressID Changed to '" & Me._PartnerAddressID & "' from '" & obj.PartnerAddressID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(Me._LocationID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded Location Record
        ''' </summary>
        Public Sub Delete()
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveLocation")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@LocationID", SqlDbType.Int).Value = Me._LocationID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(Me._LocationID)
            End If
        End Sub
        Public Function GetNewLocation() As String
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand("spGetNewLocationName")
            Dim strLocationName As String
            Dim dtr As SqlDataReader
            Dim strLengh As String
            Dim intTotal As Integer
            Dim intlengh As Integer

            strLocationName = "BSA00000"
            cmd.Connection = cnn
            cnn.Open()
            dtr = cmd.ExecuteReader
            If dtr.Read Then
                strLengh = dtr("Total")
                intlengh = Len(strLengh)
                If strLengh = "0" Then
                    intTotal = intlengh
                Else
                    intTotal = CType(strLengh + 1, Integer)
                End If

                Select Case intTotal

                    Case 1 To 9
                        strLocationName = "BSA0000" & intTotal
                    Case 10 To 99
                        strLocationName = "BSA000" & intTotal
                    Case 100 To 999
                        strLocationName = "BSA00" & intTotal
                    Case 1000 To 9999
                        strLocationName = "BSA0" & intTotal
                    Case 10000 To 99999
                        strLocationName = "BSA" & intTotal
                    Case Else
                        strLocationName = "BSA" & intTotal
                End Select
                GetNewLocation = strLocationName
            Else
                GetNewLocation = 0
            End If
            cnn.Close()

        End Function
        Public Function GetLocationByPartnerAddressID(ByVal lngPartnerAddressID As Long) As Long

            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand("spGetLocationByPartnerAddressID")
            Dim dtr As SqlDataReader
            Dim lngLocationID As Long

            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAddressID", SqlDbType.Int).Value = lngPartnerAddressID
            cnn.Open()
            cmd.Connection = cnn
            dtr = cmd.ExecuteReader
            If dtr.Read Then
                lngLocationID = CType(dtr("LocationID"), Long)
            End If
            GetLocationByPartnerAddressID = lngLocationID
            cnn.Close()

        End Function





#End Region
#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the LocationName field for the currently loaded record
        ''' </summary>
        Public Property LocationName() As String
            Get
                Return Me._LocationName
            End Get
            Set(ByVal value As String)
                Me._LocationName = TrimTrunc(value, LocationNameMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the PartnerAddressID field for the currently loaded record
        ''' </summary>
        Public Property PartnerAddressID() As Long
            Get
                Return Me._PartnerAddressID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAddressID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the connection string to the database
        ''' </summary>
        Public Property ConnectionString() As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

#End Region

#Region "ReadOnly Properties"

        ''' <summary>
        ''' Returns the LocationID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property LocationID() As Long
            Get
                Return Me._LocationID
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
            Me._LocationID = 0
            Me._LocationName = ""
            Me._PartnerAddressID = 0
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
        ''' Updates the LocationName field for this record.
        ''' </summary>
        ''' <param name="NewLocationName">The new value for theLocationName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateLocationName(ByVal NewLocationName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateLocationLocationName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@LocationID", SqlDbType.Int).Value = Me._LocationID
            cmd.Parameters.Add("@LocationName", SqlDbType.VarChar, TrimTrunc(NewLocationName, LocationNameMaxLength).Length).Value = TrimTrunc(NewLocationName, LocationNameMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the PartnerAddressID field for this record.
        ''' </summary>
        ''' <param name="NewPartnerAddressID">The new value for thePartnerAddressID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerAddressID(ByVal NewPartnerAddressID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateLocationPartnerAddressID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@LocationID", SqlDbType.Int).Value = Me._LocationID
            cmd.Parameters.Add("@PartnerAddressID", SqlDbType.Int).Value = NewPartnerAddressID
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
            Dim obj As New LocationRecord(Me._LocationID, Me._ConnectionString)
            obj.Load(Me._LocationID)
            If obj.LocationName <> Me._LocationName Then
                blnReturn = True
            End If
            If obj.PartnerAddressID <> Me._PartnerAddressID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region
#Region "Private Members"

        Private _LocationID As Long = 0
        Private _LocationName As String = ""
        Private _PartnerAddressID As Long = 0
        Private _ConnectionString As String = ""

#End Region
#Region "Private Constants"

        Private Const LocationNameMaxLength As Integer = 32

#End Region

    End Class

End Namespace
