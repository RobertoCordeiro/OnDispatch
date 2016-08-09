Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class PartnerPhoneNumberRecord
        ' Methods
        Public Sub New()
            Me._PartnerPhoneNumberID = 0
            Me._PartnerID = 0
            Me._PhoneTypeID = 0
            Me._CreatedBy = 0
            Me._Countrycode = ""
            Me._AreaCode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Comment = ""
            Me._Pin = ""
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PartnerPhoneNumberID = 0
            Me._PartnerID = 0
            Me._PhoneTypeID = 0
            Me._CreatedBy = 0
            Me._Countrycode = ""
            Me._AreaCode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Comment = ""
            Me._Pin = ""
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngPartnerPhoneNumberID As Long, ByVal strConnectionString As String)
            Me._PartnerPhoneNumberID = 0
            Me._PartnerID = 0
            Me._PhoneTypeID = 0
            Me._CreatedBy = 0
            Me._Countrycode = ""
            Me._AreaCode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Comment = ""
            Me._Pin = ""
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._PartnerPhoneNumberID)
        End Sub

        Public Sub Add(ByVal lngPartnerID As Long, ByVal lngPhoneTypeID As Long, ByVal lngCreatedBy As Long, ByVal strCountrycode As String, ByVal strAreaCode As String, ByVal strExchange As String, ByVal strLineNumber As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerPhoneNumber")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerPhoneNumberID As Long = 0
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cmd.Parameters.Add("@PhoneTypeID", SqlDbType.Int).Value = lngPhoneTypeID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Countrycode", SqlDbType.VarChar, Me.TrimTrunc(strCountrycode, 8).Length).Value = Me.TrimTrunc(strCountrycode, 8)
                cmd.Parameters.Add("@AreaCode", SqlDbType.Char, Me.TrimTrunc(strAreaCode, 3).Length).Value = Me.TrimTrunc(strAreaCode, 3)
                cmd.Parameters.Add("@Exchange", SqlDbType.Char, Me.TrimTrunc(strExchange, 3).Length).Value = Me.TrimTrunc(strExchange, 3)
                cmd.Parameters.Add("@LineNumber", SqlDbType.Char, Me.TrimTrunc(strLineNumber, 4).Length).Value = Me.TrimTrunc(strLineNumber, 4)
                cnn.Open
                cmd.Connection = cnn
                lngPartnerPhoneNumberID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngPartnerPhoneNumberID > 0) Then
                    Me.Load(lngPartnerPhoneNumberID)
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
            Me._PartnerPhoneNumberID = 0
            Me._PartnerID = 0
            Me._PhoneTypeID = 0
            Me._CreatedBy = 0
            Me._Countrycode = ""
            Me._AreaCode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Comment = ""
            Me._Pin = ""
            Me._Active = False
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerPhoneNumber")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._PartnerPhoneNumberID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PartnerPhoneNumberRecord(Me._PartnerPhoneNumberID, Me._ConnectionString)
            obj.Load(Me._PartnerPhoneNumberID)
            If (obj.PartnerID <> Me._PartnerID) Then
                blnReturn = True
            End If
            If (obj.PhoneTypeID <> Me._PhoneTypeID) Then
                blnReturn = True
            End If
            If (obj.Countrycode <> Me._Countrycode) Then
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
            If (obj.Comment <> Me._Comment) Then
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

        Public Sub Load(ByVal lngPartnerPhoneNumberID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerPhoneNumber")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = lngPartnerPhoneNumberID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerPhoneNumberID = Conversions.ToLong(dtr.Item("PartnerPhoneNumberID"))
                    Me._PartnerID = Conversions.ToLong(dtr.Item("PartnerID"))
                    Me._PhoneTypeID = Conversions.ToLong(dtr.Item("PhoneTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Countrycode = dtr.Item("Countrycode").ToString
                    Me._AreaCode = dtr.Item("AreaCode").ToString
                    Me._Exchange = dtr.Item("Exchange").ToString
                    Me._LineNumber = dtr.Item("LineNumber").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Extension"))) Then
                        Me._Extension = dtr.Item("Extension").ToString
                    Else
                        Me._Extension = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Comment"))) Then
                        Me._Comment = dtr.Item("Comment").ToString
                    Else
                        Me._Comment = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Pin"))) Then
                        Me._Pin = dtr.Item("Pin").ToString
                    Else
                        Me._Pin = ""
                    End If
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New PartnerPhoneNumberRecord(Me._PartnerPhoneNumberID, Me._ConnectionString)
                obj.Load(Me._PartnerPhoneNumberID)
                If (obj.PartnerID <> Me._PartnerID) Then
                    Me.UpdatePartnerID(Me._PartnerID, (cnn))
                    strTemp = String.Concat(New String() { "PartnerID Changed to '", Conversions.ToString(Me._PartnerID), "' from '", Conversions.ToString(obj.PartnerID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PhoneTypeID <> Me._PhoneTypeID) Then
                    Me.UpdatePhoneTypeID(Me._PhoneTypeID, (cnn))
                    strTemp = String.Concat(New String() { "PhoneTypeID Changed to '", Conversions.ToString(Me._PhoneTypeID), "' from '", Conversions.ToString(obj.PhoneTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Countrycode <> Me._Countrycode) Then
                    Me.UpdateCountrycode(Me._Countrycode, (cnn))
                    strTemp = String.Concat(New String() { "Countrycode Changed to '", Me._Countrycode, "' from '", obj.Countrycode, "'" })
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
                If (obj.Comment <> Me._Comment) Then
                    Me.UpdateComment(Me._Comment, (cnn))
                    strTemp = String.Concat(New String() { "Comment Changed to '", Me._Comment, "' from '", obj.Comment, "'" })
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
                Me.Load(Me._PartnerPhoneNumberID)
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
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAreaCode(ByVal NewAreaCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberAreaCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
            cmd.Parameters.Add("@AreaCode", SqlDbType.Char, Me.TrimTrunc(NewAreaCode, 3).Length).Value = Me.TrimTrunc(NewAreaCode, 3)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateComment(ByVal NewComment As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberComment")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
            If (NewComment.Trim.Length > 0) Then
                cmd.Parameters.Add("@Comment", SqlDbType.VarChar, Me.TrimTrunc(NewComment, &H40).Length).Value = Me.TrimTrunc(NewComment, &H40)
            Else
                cmd.Parameters.Add("@Comment", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCountrycode(ByVal NewCountrycode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberCountrycode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
            cmd.Parameters.Add("@Countrycode", SqlDbType.VarChar, Me.TrimTrunc(NewCountrycode, 8).Length).Value = Me.TrimTrunc(NewCountrycode, 8)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateExchange(ByVal NewExchange As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberExchange")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
            cmd.Parameters.Add("@Exchange", SqlDbType.Char, Me.TrimTrunc(NewExchange, 3).Length).Value = Me.TrimTrunc(NewExchange, 3)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateExtension(ByVal NewExtension As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberExtension")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
            If (NewExtension.Trim.Length > 0) Then
                cmd.Parameters.Add("@Extension", SqlDbType.VarChar, Me.TrimTrunc(NewExtension, &H10).Length).Value = Me.TrimTrunc(NewExtension, &H10)
            Else
                cmd.Parameters.Add("@Extension", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLineNumber(ByVal NewLineNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberLineNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
            cmd.Parameters.Add("@LineNumber", SqlDbType.Char, Me.TrimTrunc(NewLineNumber, 4).Length).Value = Me.TrimTrunc(NewLineNumber, 4)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerID(ByVal NewPartnerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberPartnerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = NewPartnerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePhoneTypeID(ByVal NewPhoneTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberPhoneTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
            cmd.Parameters.Add("@PhoneTypeID", SqlDbType.Int).Value = NewPhoneTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePin(ByVal NewPin As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerPhoneNumberPin")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerPhoneNumberID", SqlDbType.Int).Value = Me._PartnerPhoneNumberID
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

        Public Property Comment As String
            Get
                Return Me._Comment
            End Get
            Set(ByVal value As String)
                Me._Comment = Me.TrimTrunc(value, &H40)
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

        Public Property Countrycode As String
            Get
                Return Me._Countrycode
            End Get
            Set(ByVal value As String)
                Me._Countrycode = Me.TrimTrunc(value, 8)
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

        Public Property PartnerID As Long
            Get
                Return Me._PartnerID
            End Get
            Set(ByVal value As Long)
                Me._PartnerID = value
            End Set
        End Property

        Public ReadOnly Property PartnerPhoneNumberID As Long
            Get
                Return Me._PartnerPhoneNumberID
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


        ' Fields
        Private _Active As Boolean
        Private _AreaCode As String
        Private _Comment As String
        Private _ConnectionString As String
        Private _Countrycode As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Exchange As String
        Private _Extension As String
        Private _LineNumber As String
        Private _PartnerID As Long
        Private _PartnerPhoneNumberID As Long
        Private _PhoneTypeID As Long
        Private _Pin As String
        Private Const AreaCodeMaxLength As Integer = 3
        Private Const CommentMaxLength As Integer = &H40
        Private Const CountrycodeMaxLength As Integer = 8
        Private Const ExchangeMaxLength As Integer = 3
        Private Const ExtensionMaxLength As Integer = &H10
        Private Const LineNumberMaxLength As Integer = 4
        Private Const PinMaxLength As Integer = &H10
    End Class
End Namespace

