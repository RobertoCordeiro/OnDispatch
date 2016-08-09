Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class TerritoryRecord

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
        ''' <param name="lngTerritoryID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngTerritoryID As Long, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Load(_TerritoryID)
        End Sub

        ''' <summary>
        '''  Adds a new Territory record to the database.
        ''' </summary>
        ''' <param name="lngLocationID">The value for the LocationID portion of the record</param>
        ''' <param name="lngZipCodeID">The value for the ZipCodeID portion of the record</param>
        Public Sub Add(ByVal lngLocationID As Long, ByVal lngZipCodeID As Long, ByVal blnVersion As Boolean)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spAddTerritory")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTerritoryID As Long = 0
                cmd.Parameters.Add("@LocationID", SqlDbType.Int).Value = lngLocationID
                cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = lngZipCodeID
                cmd.Parameters.Add("@Version", SqlDbType.Bit).Value = blnVersion
                cnn.Open()
                cmd.Connection = cnn
                lngTerritoryID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngTerritoryID > 0 Then
                    Load(lngTerritoryID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a Territory record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngTerritoryID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetTerritory")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TerritoryID", SqlDbType.Int).Value = lngTerritoryID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._TerritoryID = CType(dtr("TerritoryID"), Long)
                    Me._LocationID = CType(dtr("LocationID"), Long)
                    Me._ZipCodeID = CType(dtr("ZipCodeID"), Long)
                    Me._Version = CType(dtr("Version"), Boolean)
                Else
                    ClearValues()
                End If
                cnn.Close()
            End If
        End Sub

        Public Sub Load(ByVal lngZipCodeID As String)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetTerritoryIDByZipCodeID")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = lngZipCodeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._TerritoryID = CType(dtr("TerritoryID"), Long)
                    Me._LocationID = CType(dtr("LocationID"), Long)
                    Me._ZipCodeID = CType(dtr("ZipCodeID"), Long)
                    Me._Version = CType(dtr("Version"), Boolean)
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
                Dim obj As New TerritoryRecord(Me._TerritoryID, Me._ConnectionString)
                obj.Load(Me._TerritoryID)
                If obj.LocationID <> Me._LocationID Then
                    UpdateLocationID(Me._LocationID, cnn)
                    strTemp = "LocationID Changed to '" & Me._LocationID & "' from '" & obj.LocationID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ZipCodeID <> Me._ZipCodeID Then
                    UpdateZipCodeID(Me._ZipCodeID, cnn)
                    strTemp = "ZipCodeID Changed to '" & Me._ZipCodeID & "' from '" & obj.ZipCodeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Version <> Me._Version Then
                    UpdateVersion(Me._Version, cnn)
                    strTemp = "Version Changed to '" & Me._Version & "' from '" & obj.Version & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(Me._TerritoryID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded Territory Record
        ''' </summary>
        Public Sub Delete()
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveTerritory")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TerritoryID", SqlDbType.Int).Value = Me._TerritoryID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(Me._TerritoryID)
            End If
        End Sub
        


#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the LocationID field for the currently loaded record
        ''' </summary>
        Public Property LocationID() As Long
            Get
                Return Me._LocationID
            End Get
            Set(ByVal value As Long)
                Me._LocationID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ZipCodeID field for the currently loaded record
        ''' </summary>
        Public Property ZipCodeID() As Long
            Get
                Return Me._ZipCodeID
            End Get
            Set(ByVal value As Long)
                Me._ZipCodeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Version field for the currently loaded record
        ''' </summary>
        Public Property Version() As Boolean
            Get
                Return Me._Version
            End Get
            Set(ByVal value As Boolean)
                Me._Version = value
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
        ''' Returns the TerritoryID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property TerritoryID() As Long
            Get
                Return Me._TerritoryID
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
            Me._TerritoryID = 0
            Me._LocationID = 0
            Me._ZipCodeID = 0
            Me._Version = False
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
        ''' Updates the LocationID field for this record.
        ''' </summary>
        ''' <param name="NewLocationID">The new value for theLocationID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateLocationID(ByVal NewLocationID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTerritoryLocationID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TerritoryID", SqlDbType.Int).Value = Me._TerritoryID
            cmd.Parameters.Add("@LocationID", SqlDbType.Int).Value = NewLocationID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ZipCodeID field for this record.
        ''' </summary>
        ''' <param name="NewZipCodeID">The new value for theZipCodeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateZipCodeID(ByVal NewZipCodeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTerritoryZipCodeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TerritoryID", SqlDbType.Int).Value = _TerritoryID
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = NewZipCodeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Version field for this record.
        ''' </summary>
        ''' <param name="NewVersion">The new value for theVersion field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateVersion(ByVal NewVersion As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateVersion")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TerritoryID", sqlDBType.int).value = _TerritoryID
            cmd.Parameters.Add("@Version", SqlDbType.Bit).Value = NewVersion
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
            Dim obj As New TerritoryRecord(Me._TerritoryID, Me._ConnectionString)
            obj.Load(Me._TerritoryID)
            If obj.LocationID <> Me._LocationID Then
                blnReturn = True
            End If
            If obj.ZipCodeID <> Me._ZipCodeID Then
                blnReturn = True
            End If
            If obj.Version <> Me._Version Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region

#Region "Private Members"

        Private _TerritoryID As Long = 0
        Private _LocationID As Long = 0
        Private _ZipCodeID As Long = 0
        Private _Version As Boolean = False
        Private _ConnectionString As String = ""

#End Region


    End Class
End Namespace