Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ResumePhoneNumberRecord
        ' Methods
        Public Sub New()
            Me._ResumePhoneNumberID = 0
            Me._ResumeID = 0
            Me._PhoneTypeID = 0
            Me._CreatedBy = 0
            Me._CountryCode = "1"
            Me._AreaCode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Pin = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ResumePhoneNumberID = 0
            Me._ResumeID = 0
            Me._PhoneTypeID = 0
            Me._CreatedBy = 0
            Me._CountryCode = "1"
            Me._AreaCode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Pin = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngResumePhoneNumberID As Long, ByVal strConnectionString As String)
            Me._ResumePhoneNumberID = 0
            Me._ResumeID = 0
            Me._PhoneTypeID = 0
            Me._CreatedBy = 0
            Me._CountryCode = "1"
            Me._AreaCode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Pin = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ResumePhoneNumberID)
        End Sub

        Public Sub Add(ByVal lngResumeID As Long, ByVal lngPhoneTypeID As Long, ByVal lngCreatedBy As Long, ByVal strCountryCode As String, ByVal strAreaCode As String, ByVal strExchange As String, ByVal strLineNumber As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResumePhoneNumber")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngResumePhoneNumberID As Long = 0
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = lngResumeID
                cmd.Parameters.Add("@PhoneTypeID", SqlDbType.Int).Value = lngPhoneTypeID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@CountryCode", SqlDbType.VarChar, Me.TrimTrunc(strCountryCode, 8).Length).Value = Me.TrimTrunc(strCountryCode, 8)
                cmd.Parameters.Add("@AreaCode", SqlDbType.VarChar, Me.TrimTrunc(strAreaCode, 3).Length).Value = Me.TrimTrunc(strAreaCode, 3)
                cmd.Parameters.Add("@Exchange", SqlDbType.VarChar, Me.TrimTrunc(strExchange, 3).Length).Value = Me.TrimTrunc(strExchange, 3)
                cmd.Parameters.Add("@LineNumber", SqlDbType.VarChar, Me.TrimTrunc(strLineNumber, 4).Length).Value = Me.TrimTrunc(strLineNumber, 4)
                cnn.Open
                cmd.Connection = cnn
                lngResumePhoneNumberID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngResumePhoneNumberID > 0) Then
                    Me.Load(lngResumePhoneNumberID)
                End If
            End If
        End Sub

        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If (strLog.Length > 0) Then
                strReturn = (strLog & Environment.NewLine)
            End If
            strReturn = (strReturn & strNewLine)
            strLog = strReturn
        End Sub

        Private Sub ClearValues()
            Me._ResumePhoneNumberID = 0
            Me._ResumeID = 0
            Me._PhoneTypeID = 0
            Me._CreatedBy = 0
            Me._CountryCode = "1"
            Me._AreaCode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Pin = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumePhoneNumber")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = Me._ResumePhoneNumberID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ResumePhoneNumberID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumePhoneNumberRecord(Me._ResumePhoneNumberID, Me._ConnectionString)
            If (obj.PhoneTypeID <> Me._PhoneTypeID) Then
                blnReturn = True
            End If
            If (obj.CountryCode <> Me._CountryCode) Then
                blnReturn = True
            End If
            If (obj.AreaCode <> Me._AreaCode) Then
                blnReturn = True
            End If
            If (obj.Exchange <> Me._Exchange) Then
                blnReturn = True
            End If
            If (obj.LineNumber <> Me._LineNumber) Then
                blnReturn = True
            End If
            If (obj.Extension <> Me._Extension) Then
                blnReturn = True
            End If
            If (obj.Pin <> Me._Pin) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumePhoneNumber")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = lngID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ResumePhoneNumberID = Conversions.ToLong(dtr.Item("ResumePhoneNumberID"))
                    Me._ResumeID = Conversions.ToLong(dtr.Item("ResumeID"))
                    Me._PhoneTypeID = Conversions.ToLong(dtr.Item("PhoneTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CountryCode = dtr.Item("CountryCode").ToString
                    Me._AreaCode = dtr.Item("AreaCode").ToString
                    Me._Exchange = dtr.Item("Exchange").ToString
                    Me._LineNumber = dtr.Item("LineNumber").ToString
                    Me._Extension = dtr.Item("Extension").ToString
                    Me._Pin = dtr.Item("Pin").ToString
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Load(ByVal strAreaCode As String, ByVal strExchange As String, ByVal strLineNumber As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumePhoneNumberByAreaCodeExchangeAndLineNumber")
                Dim lngId As Long = 0
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AreaCode", SqlDbType.VarChar, strAreaCode.Trim.Length).Value = strAreaCode.Trim
                cmd.Parameters.Add("@Exchange", SqlDbType.VarChar, strExchange.Trim.Length).Value = strExchange.Trim
                cmd.Parameters.Add("@LineNumber", SqlDbType.VarChar, strLineNumber.Trim.Length).Value = strLineNumber.Trim
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    lngId = Conversions.ToLong(dtr.Item("ResumePhoneNumberID"))
                End If
                cnn.Close
                Me.Load(lngId)
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New ResumePhoneNumberRecord(Me._ResumePhoneNumberID, Me._ConnectionString)
                obj.Load(Me._ResumePhoneNumberID)
                If (obj.PhoneTypeID <> Me._PhoneTypeID) Then
                    Me.UpdatePhoneTypeID(Me._PhoneTypeID, (cnn))
                    strTemp = String.Concat(New String() { "PhoneTypeID Changed to '", Conversions.ToString(Me._PhoneTypeID), "' from '", Conversions.ToString(obj.PhoneTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CountryCode <> Me._CountryCode) Then
                    Me.UpdateCountryCode(Me._CountryCode, (cnn))
                    strTemp = String.Concat(New String() { "CountryCode Changed to '", Me._CountryCode, "' from '", obj.CountryCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AreaCode <> Me._AreaCode) Then
                    Me.UpdateAreaCode(Me._AreaCode, (cnn))
                    strTemp = String.Concat(New String() { "AreaCode Changed to '", Me._AreaCode, "' from '", obj.AreaCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Exchange <> Me._Exchange) Then
                    Me.UpdateExchange(Me._Exchange, (cnn))
                    strTemp = String.Concat(New String() { "Exchange Changed to '", Me._Exchange, "' from '", obj.Exchange, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.LineNumber <> Me._LineNumber) Then
                    Me.UpdateLineNumber(Me._LineNumber, (cnn))
                    strTemp = String.Concat(New String() { "LineNumber Changed to '", Me._LineNumber, "' from '", obj.LineNumber, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Extension <> Me._Extension) Then
                    Me.UpdateExtension(Me._Extension, (cnn))
                    strTemp = String.Concat(New String() { "Extension Changed to '", Me._Extension, "' from '", obj.Extension, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Pin <> Me._Pin) Then
                    Me.UpdatePin(Me._Pin, (cnn))
                    strTemp = String.Concat(New String() { "Pin Changed to '", Me._Pin, "' from '", obj.Pin, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ResumePhoneNumberID)
            Else
                Me.ClearValues
            End If
        End Sub

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function

        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumePhoneNumberActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = Me._ResumePhoneNumberID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAreaCode(ByVal NewAreaCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumePhoneNumberAreaCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = Me._ResumePhoneNumberID
            cmd.Parameters.Add("@AreaCode", SqlDbType.VarChar, Me.TrimTrunc(NewAreaCode, 3).Length).Value = Me.TrimTrunc(NewAreaCode, 3)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCountryCode(ByVal NewCountryCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumePhoneNumberCountryCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = Me._ResumePhoneNumberID
            cmd.Parameters.Add("@CountryCode", SqlDbType.VarChar, Me.TrimTrunc(NewCountryCode, 8).Length).Value = Me.TrimTrunc(NewCountryCode, 8)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateExchange(ByVal NewExchange As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumePhoneNumberExchange")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = Me._ResumePhoneNumberID
            cmd.Parameters.Add("@Exchange", SqlDbType.VarChar, Me.TrimTrunc(NewExchange, 3).Length).Value = Me.TrimTrunc(NewExchange, 3)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateExtension(ByVal NewExtension As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumePhoneNumberExtension")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = Me._ResumePhoneNumberID
            If (NewExtension.Trim.Length > 0) Then
                cmd.Parameters.Add("@Extension", SqlDbType.VarChar, Me.TrimTrunc(NewExtension, &H10).Length).Value = Me.TrimTrunc(NewExtension, &H10)
            Else
                cmd.Parameters.Add("@Extension", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLineNumber(ByVal NewLineNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumePhoneNumberLineNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = Me._ResumePhoneNumberID
            cmd.Parameters.Add("@LineNumber", SqlDbType.VarChar, Me.TrimTrunc(NewLineNumber, 4).Length).Value = Me.TrimTrunc(NewLineNumber, 4)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePhoneTypeID(ByVal NewPhoneTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumePhoneNumberPhoneTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = Me._ResumePhoneNumberID
            cmd.Parameters.Add("@PhoneTypeID", SqlDbType.Int).Value = NewPhoneTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePin(ByVal NewPin As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumePhoneNumberPin")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumePhoneNumberID", SqlDbType.Int).Value = Me._ResumePhoneNumberID
            If (NewPin.Trim.Length > 0) Then
                cmd.Parameters.Add("@Pin", SqlDbType.VarChar, Me.TrimTrunc(NewPin, &H10).Length).Value = Me.TrimTrunc(NewPin, &H10)
            Else
                cmd.Parameters.Add("@Pin", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property Active As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
            End Set
        End Property

        Public Property AreaCode As String
            Get
                Return Me._AreaCode
            End Get
            Set(ByVal value As String)
                Me._AreaCode = Me.TrimTrunc(value, 3)
            End Set
        End Property

        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

        Public Property CountryCode As String
            Get
                Return Me._CountryCode
            End Get
            Set(ByVal value As String)
                Me._CountryCode = Me.TrimTrunc(value, 8)
            End Set
        End Property

        Public ReadOnly Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property Exchange As String
            Get
                Return Me._Exchange
            End Get
            Set(ByVal value As String)
                Me._Exchange = Me.TrimTrunc(value, 3)
            End Set
        End Property

        Public Property Extension As String
            Get
                Return Me._Extension
            End Get
            Set(ByVal value As String)
                Me._Extension = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public Property LineNumber As String
            Get
                Return Me._LineNumber
            End Get
            Set(ByVal value As String)
                Me._LineNumber = Me.TrimTrunc(value, 4)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property PhoneTypeID As Long
            Get
                Return Me._PhoneTypeID
            End Get
            Set(ByVal value As Long)
                Me._PhoneTypeID = value
            End Set
        End Property

        Public Property Pin As String
            Get
                Return Me._Pin
            End Get
            Set(ByVal value As String)
                Me._Pin = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public ReadOnly Property ResumeID As Long
            Get
                Return Me._ResumeID
            End Get
        End Property

        Public ReadOnly Property ResumePhoneNumberID As Long
            Get
                Return Me._ResumePhoneNumberID
            End Get
        End Property


        ' Fields
        Private _Active As Boolean
        Private _AreaCode As String
        Private _ConnectionString As String
        Private _CountryCode As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Exchange As String
        Private _Extension As String
        Private _LineNumber As String
        Private _PhoneTypeID As Long
        Private _Pin As String
        Private _ResumeID As Long
        Private _ResumePhoneNumberID As Long
        Private Const AreaCodeMaxLength As Integer = 3
        Private Const CountryCodeMaxLength As Integer = 8
        Private Const ExchangeMaxLength As Integer = 3
        Private Const ExtensionMaxLength As Integer = &H10
        Private Const LineNumberMaxLength As Integer = 4
        Private Const PinMaxLength As Integer = &H10
    End Class
End Namespace

