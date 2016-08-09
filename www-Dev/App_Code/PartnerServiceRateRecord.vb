Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

NameSpace BridgesInterface

    Public Class PartnerServiceRateRecord

#Region "Private Constants"

        Private Const ServiceNameMaxLength As Integer = 32

#End Region

#Region "Private Members"

        Private _PartnerServiceRateID As Long = 0
        Private _PartnerID As Long = 0
        Private _ServiceID As Long = 0
        Private _PayIncrementID As Long = 0
        Private _ServiceName As String = ""
        Private _FlatRate As Double = 0
        Private _HourlyRate As Double = 0
        Private _MinTimeOnSite As Long = 0
        Private _Active As Boolean = False
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the PartnerID field for the currently loaded record
        ''' </summary>
        Public Property PartnerID() As Long
            Get
                Return Me._PartnerID
            End Get
            Set(ByVal value As Long)
                Me._PartnerID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ServiceID field for the currently loaded record
        ''' </summary>
        Public Property ServiceID() As Long
            Get
                Return Me._ServiceID
            End Get
            Set(ByVal value As Long)
                Me._ServiceID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the PayIncrementID field for the currently loaded record
        ''' </summary>
        Public Property PayIncrementID() As Long
            Get
                Return Me._PayIncrementID
            End Get
            Set(ByVal value As Long)
                Me._PayIncrementID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ServiceName field for the currently loaded record
        ''' </summary>
        Public Property ServiceName() As String
            Get
                Return Me._ServiceName
            End Get
            Set(ByVal value As String)
                Me._ServiceName = TrimTrunc(value, ServiceNameMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the FlatRate field for the currently loaded record
        ''' </summary>
        Public Property FlatRate() As Double
            Get
                Return Me._FlatRate
            End Get
            Set(ByVal value As Double)
                Me._FlatRate = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the HourlyRate field for the currently loaded record
        ''' </summary>
        Public Property HourlyRate() As Double
            Get
                Return Me._HourlyRate
            End Get
            Set(ByVal value As Double)
                Me._HourlyRate = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the MinTimeOnSite field for the currently loaded record
        ''' </summary>
        Public Property MinTimeOnSite() As Long
            Get
                Return Me._MinTimeOnSite
            End Get
            Set(ByVal value As Long)
                Me._MinTimeOnSite = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Active field for the currently loaded record
        ''' </summary>
        Public Property Active() As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
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
        ''' Returns the PartnerServiceRateID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property PartnerServiceRateID() As Long
            Get
                Return Me._PartnerServiceRateID
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
            Me._PartnerServiceRateID = 0
            Me._PartnerID = 0
            Me._ServiceID = 0
            Me._PayIncrementID = 0
            Me._ServiceName = ""
            Me._FlatRate = 0
            Me._HourlyRate = 0
            Me._MinTimeOnSite = 0
            Me._Active = False

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
        ''' Updates the PartnerID field for this record.
        ''' </summary>
        ''' <param name="NewPartnerID">The new value for thePartnerID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerID(ByVal NewPartnerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatetblPartnerServiceRatePartnerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = Me._PartnerServiceRateID
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = NewPartnerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ServiceID field for this record.
        ''' </summary>
        ''' <param name="NewServiceID">The new value for theServiceID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateServiceID(ByVal NewServiceID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatetblPartnerServiceRateServiceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = Me._PartnerServiceRateID
            cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = NewServiceID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the PayIncrementID field for this record.
        ''' </summary>
        ''' <param name="NewPayIncrementID">The new value for thePayIncrementID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePayIncrementID(ByVal NewPayIncrementID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatetblPartnerServiceRatePayIncrementID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = Me._PartnerServiceRateID
            cmd.Parameters.Add("@PayIncrementID", SqlDbType.Int).Value = NewPayIncrementID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ServiceName field for this record.
        ''' </summary>
        ''' <param name="NewServiceName">The new value for theServiceName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateServiceName(ByVal NewServiceName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatetblPartnerServiceRateServiceName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = Me._PartnerServiceRateID
            cmd.Parameters.Add("@ServiceName", SqlDbType.VarChar, TrimTrunc(NewServiceName, ServiceNameMaxLength).Length).Value = TrimTrunc(NewServiceName, ServiceNameMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the FlatRate field for this record.
        ''' </summary>
        ''' <param name="NewFlatRate">The new value for theFlatRate field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateFlatRate(ByVal NewFlatRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatetblPartnerServiceRateFlatRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = Me._PartnerServiceRateID
            cmd.Parameters.Add("@FlatRate", SqlDbType.Money).Value = NewFlatRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the HourlyRate field for this record.
        ''' </summary>
        ''' <param name="NewHourlyRate">The new value for theHourlyRate field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateHourlyRate(ByVal NewHourlyRate As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatetblPartnerServiceRateHourlyRate")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = Me._PartnerServiceRateID
            cmd.Parameters.Add("@HourlyRate", SqlDbType.Money).Value = NewHourlyRate
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the MinTimeOnSite field for this record.
        ''' </summary>
        ''' <param name="NewMinTimeOnSite">The new value for theMinTimeOnSite field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateMinTimeOnSite(ByVal NewMinTimeOnSite As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatetblPartnerServiceRateMinTimeOnSite")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = Me._PartnerServiceRateID
            cmd.Parameters.Add("@MinTimeOnSite", SqlDbType.Int).Value = NewMinTimeOnSite
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Active field for this record.
        ''' </summary>
        ''' <param name="NewActive">The new value for theActive field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatetblPartnerServiceRateActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = Me._PartnerServiceRateID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
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
            Dim obj As New PartnerServiceRateRecord(Me._PartnerServiceRateID, Me._ConnectionString)
            obj.Load(_PartnerServiceRateID)
            If obj.PartnerID <> Me._PartnerID Then
                blnReturn = True
            End If
            If obj.ServiceID <> Me._ServiceID Then
                blnReturn = True
            End If
            If obj.PayIncrementID <> Me._PayIncrementID Then
                blnReturn = True
            End If
            If obj.ServiceName <> Me._ServiceName Then
                blnReturn = True
            End If
            If obj.FlatRate <> Me._FlatRate Then
                blnReturn = True
            End If
            If obj.HourlyRate <> Me._HourlyRate Then
                blnReturn = True
            End If
            If obj.MinTimeOnSite <> Me._MinTimeOnSite Then
                blnReturn = True
            End If
            If obj.Active <> Me._Active Then
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
            Me._ConnectionString = strConnectionString
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object and loads by the passed in Primary Key
        ''' </summary>
        ''' <param name="lngPartnerServiceRateID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngPartnerServiceRateID As Long, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Load(Me._PartnerServiceRateID)
        End Sub

        
        Public Sub Add(ByVal lngPartnerID As Long, ByVal lngServiceID As Long, ByVal lngPayIncrementID As Long, ByVal strServiceName As String, ByVal dbFlatRate As Double, ByVal dbHourlyRate As Double, ByVal lngMinTimeOnSite As Long, ByVal boolActive As Boolean)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddtblPartnerServiceRate")
                Dim lngPartnerServiceRateID As Long = 0
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = lngServiceID
                cmd.Parameters.Add("@PayIncrementID", SqlDbType.Int).Value = lngPayIncrementID
                cmd.Parameters.Add("@ServiceName", SqlDbType.VarChar).Value = strServiceName
                cmd.Parameters.Add("@FlatRate", SqlDbType.Money).Value = dbFlatRate
                cmd.Parameters.Add("@HourlyRate", SqlDbType.Money).Value = dbHourlyRate
                cmd.Parameters.Add("@MinTimeOnSite", SqlDbType.Int).Value = lngMinTimeOnSite
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = boolActive
                cnn.Open()
                cmd.Connection = cnn
                lngPartnerServiceRateID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngPartnerServiceRateID > 0 Then
                    Load(lngPartnerServiceRateID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a tblPartnerServiceRate record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngPartnerServiceRateID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGettblPartnerServiceRate")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = lngPartnerServiceRateID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerServiceRateID = CType(dtr("PartnerServiceRateID"), Long)
                    Me._PartnerID = CType(dtr("PartnerID"), Long)
                    Me._ServiceID = CType(dtr("ServiceID"), Long)
                    Me._PayIncrementID = CType(dtr("PayIncrementID"), Long)
                    Me._ServiceName = dtr("ServiceName").ToString
                    Me._FlatRate = CType(dtr("FlatRate"), Double)
                    Me._HourlyRate = CType(dtr("HourlyRate"), Double)
                    Me._MinTimeOnSite = CType(dtr("MinTimeOnSite"), Long)
                    Me._Active = CType(dtr("Active"), Boolean)

                Else
                    ClearValues()
                End If
                cnn.Close()
            End If
        End Sub

        Public Sub Load(ByVal lngPartnerID As Long, ByVal lngServiceID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGettblPartnerServiceRateByPartnerIDServiceID")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = lngServiceID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerServiceRateID = CType(dtr("PartnerServiceRateID"), Long)
                    Me._PartnerID = CType(dtr("PartnerID"), Long)
                    Me._ServiceID = CType(dtr("ServiceID"), Long)
                    Me._PayIncrementID = CType(dtr("PayIncrementID"), Long)
                    Me._ServiceName = dtr("ServiceName").ToString
                    Me._FlatRate = CType(dtr("FlatRate"), Double)
                    Me._HourlyRate = CType(dtr("HourlyRate"), Double)
                    Me._MinTimeOnSite = CType(dtr("MinTimeOnSite"), Long)
                    Me._Active = CType(dtr("Active"), Boolean)

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
                Dim obj As New PartnerServiceRateRecord(Me._PartnerServiceRateID, Me._ConnectionString)
                obj.Load(_PartnerServiceRateID)
                If obj.PartnerID <> Me._PartnerID Then
                    UpdatePartnerID(Me._PartnerID, cnn)
                    strTemp = "PartnerID Changed to '" & Me._PartnerID & "' from '" & obj.PartnerID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ServiceID <> Me._ServiceID Then
                    UpdateServiceID(Me._ServiceID, cnn)
                    strTemp = "ServiceID Changed to '" & Me._ServiceID & "' from '" & obj.ServiceID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.PayIncrementID <> Me._PayIncrementID Then
                    UpdatePayIncrementID(Me._PayIncrementID, cnn)
                    strTemp = "PayIncrementID Changed to '" & Me._PayIncrementID & "' from '" & obj.PayIncrementID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ServiceName <> Me._ServiceName Then
                    UpdateServiceName(Me._ServiceName, cnn)
                    strTemp = "ServiceName Changed to '" & Me._ServiceName & "' from '" & obj.ServiceName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.FlatRate <> Me._FlatRate Then
                    UpdateFlatRate(Me._FlatRate, cnn)
                    strTemp = "FlatRate Changed to '" & Me._FlatRate & "' from '" & obj.FlatRate & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.HourlyRate <> Me._HourlyRate Then
                    UpdateHourlyRate(Me._HourlyRate, cnn)
                    strTemp = "HourlyRate Changed to '" & Me._HourlyRate & "' from '" & obj.HourlyRate & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.MinTimeOnSite <> Me._MinTimeOnSite Then
                    UpdateMinTimeOnSite(Me._MinTimeOnSite, cnn)
                    strTemp = "MinTimeOnSite Changed to '" & Me._MinTimeOnSite & "' from '" & obj.MinTimeOnSite & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Active <> Me._Active Then
                    UpdateActive(Me._Active, cnn)
                    strTemp = "Active Changed to '" & Me._Active & "' from '" & obj.Active & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                
                cnn.Close()
                Load(Me._PartnerServiceRateID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded tblPartnerServiceRate Record
        ''' </summary>
        Public Sub Delete()
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovetblPartnerServiceRate")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerServiceRateID", SqlDbType.Int).Value = Me._PartnerServiceRateID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(Me._PartnerServiceRateID)
            End If
        End Sub


        Public Function RecordExists(ByVal lngPartnerID As Long, ByVal lngServiceID As Long) As Boolean
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spIsRecordIntblPartnerServiceRates")
                Dim dtr As SqlDataReader
                Dim intcount As Integer
                intcount = 0
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = lngServiceID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                While dtr.Read
                    intcount = dtr("Total")
                End While
                cnn.Close()

                If intcount > 0 Then
                    Return True
                Else
                    Return False
                End If
            Else
                Return False
            End If
        End Function

#End Region

    End Class
End Namespace