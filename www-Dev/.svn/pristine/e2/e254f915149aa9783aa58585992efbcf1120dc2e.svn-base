Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface

    Public Class ShippingLabelRecord

#Region "Private Constants"

        Private Const ShippingLabelMaxLength As Integer = 128

#End Region

#Region "Private Members"

        Private _ShippingLabelID As Long = 0
        Private _CreatedBy As Long = 0
        Private _TicketComponentID As Long = 0
        Private _CourierMethodID As Long = 0
        Private _ShippingDestinationID As Long = 0
        Private _ShippingLabel As String = ""
        Private _Delivered As Date = DateTime.Now
        Private _DateCreated As Date = DateTime.Now
        Private _TrackInformation As String = ""
        Private _Tracked As Boolean = False
        Private _ConnectionString As String = ""

#End Region

#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the TicketComponentID field for the currently loaded record
        ''' </summary>
        Public Property TicketComponentID() As Long
            Get
                Return _TicketComponentID
            End Get
            Set(ByVal value As Long)
                _TicketComponentID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the CourierMethodID field for the currently loaded record
        ''' </summary>
        Public Property CourierMethodID() As Long
            Get
                Return _CourierMethodID
            End Get
            Set(ByVal value As Long)
                _CourierMethodID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ShippingDestinationID field for the currently loaded record
        ''' </summary>
        Public Property ShippingDestinationID() As Long
            Get
                Return _ShippingDestinationID
            End Get
            Set(ByVal value As Long)
                _ShippingDestinationID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ShippingLabel field for the currently loaded record
        ''' </summary>
        Public Property ShippingLabel() As String
            Get
                Return _ShippingLabel
            End Get
            Set(ByVal value As String)
                _ShippingLabel = TrimTrunc(value, ShippingLabelMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Delivered field for the currently loaded record
        ''' </summary>
        Public Property Delivered() As Date
            Get
                Return _Delivered
            End Get
            Set(ByVal value As Date)
                _Delivered = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the TrackInformation field for the currently loaded record
        ''' </summary>
        Public Property TrackInformation() As String
            Get
                Return _TrackInformation
            End Get
            Set(ByVal value As String)
                _TrackInformation = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Tracked field for the currently loaded record
        ''' </summary>
        Public Property Tracked() As Boolean
            Get
                Return _Tracked
            End Get
            Set(ByVal value As Boolean)
                _Tracked = value
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
        ''' Returns the ShippingLabelID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property ShippingLabelID() As Long
            Get
                Return _ShippingLabelID
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
            _ShippingLabelID = 0
            _CreatedBy = 0
            _TicketComponentID = 0
            _CourierMethodID = 0
            _ShippingDestinationID = 0
            _ShippingLabel = ""
            _Delivered = DateTime.Now
            _DateCreated = DateTime.Now
            _TrackInformation = ""
            _Tracked = False
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
        ''' Updates the TicketComponentID field for this record.
        ''' </summary>
        ''' <param name="NewTicketComponentID">The new value for theTicketComponentID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTicketComponentID(ByVal NewTicketComponentID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateShippingLabelTicketComponentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ShippingLabelID", sqlDBType.int).value = _ShippingLabelID
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.int).value = NewTicketComponentID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the CourierMethodID field for this record.
        ''' </summary>
        ''' <param name="NewCourierMethodID">The new value for theCourierMethodID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateCourierMethodID(ByVal NewCourierMethodID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateShippingLabelCourierMethodID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ShippingLabelID", sqlDBType.int).value = _ShippingLabelID
            cmd.Parameters.Add("@CourierMethodID", SqlDbType.int).value = NewCourierMethodID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ShippingDestinationID field for this record.
        ''' </summary>
        ''' <param name="NewShippingDestinationID">The new value for theShippingDestinationID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateShippingDestinationID(ByVal NewShippingDestinationID As Long, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateShippingLabelShippingDestinationID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ShippingLabelID", sqlDBType.int).value = _ShippingLabelID
            cmd.Parameters.Add("@ShippingDestinationID", SqlDbType.int).value = NewShippingDestinationID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ShippingLabel field for this record.
        ''' </summary>
        ''' <param name="NewShippingLabel">The new value for theShippingLabel field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateShippingLabel(ByVal NewShippingLabel As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateShippingLabelShippingLabel")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ShippingLabelID", sqlDBType.int).value = _ShippingLabelID
            cmd.Parameters.Add("@ShippingLabel", SqlDbType.varchar, TrimTrunc(NewShippingLabel, ShippingLabelMaxLength).Length).value = TrimTrunc(NewShippingLabel, ShippingLabelMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Delivered field for this record.
        ''' </summary>
        ''' <param name="NewDelivered">The new value for theDelivered field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateDelivered(ByVal NewDelivered As Date, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateShippingLabelDelivered")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ShippingLabelID", sqlDBType.int).value = _ShippingLabelID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewDelivered, datNothing) <> 0) Then
                cmd.Parameters.Add("@Delivered", SqlDbType.DateTime).Value = NewDelivered
            Else
                cmd.Parameters.Add("@Delivered", SqlDbType.DateTime).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the TrackInformation field for this record.
        ''' </summary>
        ''' <param name="NewTrackInformation">The new value for theTrackInformation field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTrackInformation(ByVal NewTrackInformation As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateShippingLabelTrackInformation")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ShippingLabelID", sqlDBType.int).value = _ShippingLabelID
            If NewTrackInformation.Trim.Length > 0 Then
                cmd.Parameters.Add("@TrackInformation", SqlDbType.text).value = NewTrackInformation
            Else
                cmd.Parameters.Add("@TrackInformation", SqlDbType.text).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Tracked field for this record.
        ''' </summary>
        ''' <param name="NewTracked">The new value for theTracked field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateTracked(ByVal NewTracked As Boolean, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateShippingLabelTracked")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@ShippingLabelID", sqlDBType.int).value = _ShippingLabelID
            If NewTracked.ToString.Trim.Length > 0 Then
                cmd.Parameters.Add("@Tracked", SqlDbType.Bit).Value = NewTracked
            Else
                cmd.Parameters.Add("@Tracked", SqlDbType.Bit).Value = System.DBNull.Value
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
            Dim obj As New ShippingLabelRecord(_ShippingLabelID, _ConnectionString)
            obj.load(_ShippingLabelID)
            If obj.TicketComponentID <> _TicketComponentID Then
                blnReturn = True
            End If
            If obj.CourierMethodID <> _CourierMethodID Then
                blnReturn = True
            End If
            If obj.ShippingDestinationID <> _ShippingDestinationID Then
                blnReturn = True
            End If
            If obj.ShippingLabel <> _ShippingLabel Then
                blnReturn = True
            End If
            If obj.Delivered <> _Delivered Then
                blnReturn = True
            End If
            If obj.TrackInformation <> _TrackInformation Then
                blnReturn = True
            End If
            If obj.Tracked <> _Tracked Then
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
        ''' <param name="lngShippingLabelID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngShippingLabelID As Long, ByVal strConnectionString As String)
            _ConnectionString = strConnectionString
            Load(_ShippingLabelID)
        End Sub

        ''' <summary>
        '''  Adds a new ShippingLabel record to the database.
        ''' </summary>
        ''' <param name="lngCreatedBy">The value for the CreatedBy portion of the record</param>
        ''' <param name="lngTicketComponentID">The value for the TicketComponentID portion of the record</param>
        ''' <param name="lngCourierMethodID">The value for the CourierMethodID portion of the record</param>
        ''' <param name="lngShippingDestinationID">The value for the ShippingDestinationID portion of the record</param>
        ''' <param name="strShippingLabel">The value for the ShippingLabel portion of the record</param>
        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngTicketComponentID As Long, ByVal lngCourierMethodID As Long, ByVal lngShippingDestinationID As Long, ByVal strShippingLabel As String)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spAddShippingLabel")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngShippingLabelID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = lngTicketComponentID
                cmd.Parameters.Add("@CourierMethodID", SqlDbType.Int).Value = lngCourierMethodID
                cmd.Parameters.Add("@ShippingDestinationID", SqlDbType.Int).Value = lngShippingDestinationID
                cmd.Parameters.Add("@ShippingLabel", SqlDbType.VarChar, TrimTrunc(strShippingLabel, ShippingLabelMaxLength).Length).Value = TrimTrunc(strShippingLabel, ShippingLabelMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngShippingLabelID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngShippingLabelID > 0 Then
                    Load(lngShippingLabelID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a ShippingLabel record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngShippingLabelID As Long)
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spGetShippingLabel")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ShippingLabelID", SqlDbType.Int).Value = lngShippingLabelID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    _ShippingLabelID = CType(dtr("ShippingLabelID"), Long)
                    _CreatedBy = CType(dtr("CreatedBy"), Long)
                    _TicketComponentID = CType(dtr("TicketComponentID"), Long)
                    _CourierMethodID = CType(dtr("CourierMethodID"), Long)
                    _ShippingDestinationID = CType(dtr("ShippingDestinationID"), Long)
                    _ShippingLabel = dtr("ShippingLabel").ToString
                    If Not isdbnull(dtr("Delivered")) Then
                        _Delivered = CType(dtr("Delivered"), Date)
                    Else
                        _Delivered = DateTime.Now
                    End If
                    If Not isdbnull(dtr("DateCreated")) Then
                        _DateCreated = CType(dtr("DateCreated"), Date)
                    Else
                        _DateCreated = DateTime.Now
                    End If
                    If Not isdbnull(dtr("TrackInformation")) Then
                        _TrackInformation = dtr("TrackInformation").ToString
                    Else
                        _TrackInformation = ""
                    End If
                    If Not isdbnull(dtr("Tracked")) Then
                        _Tracked = CType(dtr("Tracked"), Boolean)
                    Else
                        _Tracked = False
                    End If
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
                Dim obj As New ShippingLabelRecord(_ShippingLabelID, _ConnectionString)
                obj.load(_ShippingLabelID)
                If obj.TicketComponentID <> _TicketComponentID Then
                    UpdateTicketComponentID(_TicketComponentID, cnn)
                    strTemp = "TicketComponentID Changed to '" & _TicketComponentID & "' from '" & obj.TicketComponentID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.CourierMethodID <> _CourierMethodID Then
                    UpdateCourierMethodID(_CourierMethodID, cnn)
                    strTemp = "CourierMethodID Changed to '" & _CourierMethodID & "' from '" & obj.CourierMethodID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ShippingDestinationID <> _ShippingDestinationID Then
                    UpdateShippingDestinationID(_ShippingDestinationID, cnn)
                    strTemp = "ShippingDestinationID Changed to '" & _ShippingDestinationID & "' from '" & obj.ShippingDestinationID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ShippingLabel <> _ShippingLabel Then
                    UpdateShippingLabel(_ShippingLabel, cnn)
                    strTemp = "ShippingLabel Changed to '" & _ShippingLabel & "' from '" & obj.ShippingLabel & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Delivered <> _Delivered Then
                    UpdateDelivered(_Delivered, cnn)
                    strTemp = "Delivered Changed to '" & _Delivered & "' from '" & obj.Delivered & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.TrackInformation <> _TrackInformation Then
                    UpdateTrackInformation(_TrackInformation, cnn)
                    strTemp = "TrackInformation Changed to '" & _TrackInformation & "' from '" & obj.TrackInformation & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Tracked <> _Tracked Then
                    UpdateTracked(_Tracked, cnn)
                    strTemp = "Tracked Changed to '" & _Tracked & "' from '" & obj.Tracked & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(_ShippingLabelID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded ShippingLabel Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlClient.SqlConnection(_ConnectionString)
                Dim cmd As New SqlClient.SqlCommand("spRemoveShippingLabel")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ShippingLabelID", SqlDbType.Int).Value = _ShippingLabelID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(_ShippingLabelID)
            End If
        End Sub

#End Region

    End Class

End Namespace

