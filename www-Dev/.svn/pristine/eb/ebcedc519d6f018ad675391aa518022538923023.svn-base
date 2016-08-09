Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices
Imports System.Runtime.InteropServices

Namespace BridgesInterface
    Public Class CustomerPhoneNumberRecord
        ' Methods
        Public Sub New()
            Me._CustomerPhoneNumberID = -1
            Me._CustomerID = -1
            Me._PhoneTypeID = -1
            Me._CreatedBy = -1
            Me._CountryCode = ""
            Me._Areacode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Comment = ""
            Me._Pin = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ValueFormat = PhoneNumberFormat.Standard
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CustomerPhoneNumberID = -1
            Me._CustomerID = -1
            Me._PhoneTypeID = -1
            Me._CreatedBy = -1
            Me._CountryCode = ""
            Me._Areacode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Comment = ""
            Me._Pin = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ValueFormat = PhoneNumberFormat.Standard
            Me.ClearValues
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCustomerPhoneNumberID As Long, ByVal strConnectionString As String)
            Me._CustomerPhoneNumberID = -1
            Me._CustomerID = -1
            Me._PhoneTypeID = -1
            Me._CreatedBy = -1
            Me._CountryCode = ""
            Me._Areacode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Comment = ""
            Me._Pin = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ValueFormat = PhoneNumberFormat.Standard
            Me.ClearValues
            Me._ConnectionString = strConnectionString
            Me.Load(lngCustomerPhoneNumberID)
        End Sub

        Public Sub New(ByVal lngCustomerID As Long, ByVal lngPhoneTypeID As Long, ByVal lngCreatedBy As Long, ByVal strCountryCode As String, ByVal strAreaCode As String, ByVal strExchange As String, ByVal strLineNumber As String, ByVal strConnectionString As String, ByVal Optional strExtension As String = "", ByVal Optional strComment As String = "", ByVal Optional strPin As String = "")
            Me._CustomerPhoneNumberID = -1
            Me._CustomerID = -1
            Me._PhoneTypeID = -1
            Me._CreatedBy = -1
            Me._CountryCode = ""
            Me._Areacode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Comment = ""
            Me._Pin = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ValueFormat = PhoneNumberFormat.Standard
            Me.ClearValues
            Me._ConnectionString = strConnectionString
            Me._CustomerID = lngCustomerID
            Me._PhoneTypeID = lngPhoneTypeID
            Me._CreatedBy = lngCreatedBy
            Me.CountryCode = strCountryCode
            Me.AreaCode = strAreaCode
            Me.Exchange = strExchange
            Me.LineNumber = strLineNumber
            Me.Extension = strExtension
            Me.Comment = strComment
            Me.Pin = strPin
            Me.Add
            If (Me._CustomerPhoneNumberID > 0) Then
                If (Me.Extension.Trim.Length > 0) Then
                    Me.UpdateExtension(Me.Extension)
                End If
                If (Me.Comment.Trim.Length > 0) Then
                    Me.UpdateComment(Me.Comment)
                End If
                If (Me.Pin.Trim.Length > 0) Then
                    Me.UpdatePin(Me.Pin)
                End If
            End If
            Me._ConnectionString = strConnectionString.Trim
        End Sub

        Public Function Add() As Long
            Dim lngReturn As Long = -1
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCustomerPhoneNumber")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
                cmd.Parameters.Add("@PhoneTypeID", SqlDbType.Int).Value = Me._PhoneTypeID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = Me._CreatedBy
                cmd.Parameters.Add("@CountryCode", SqlDbType.VarChar, Me._CountryCode.Trim.Length).Value = Me._CountryCode
                cmd.Parameters.Add("@AreaCode", SqlDbType.Char, 3).Value = Me._Areacode
                cmd.Parameters.Add("@Exchange", SqlDbType.Char, 3).Value = Me._Exchange
                cmd.Parameters.Add("@LineNumber", SqlDbType.Char, 4).Value = Me._LineNumber
                cnn.Open
                cmd.Connection = cnn
                lngReturn = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                Me.Load(lngReturn)
            End If
            Return lngReturn
        End Function

        Public Function Add(ByVal lngCustomerID As Long, ByVal lngPhoneTypeID As Long, ByVal lngCreatedBy As Long, ByVal strCountryCode As String, ByVal strAreaCode As String, ByVal strExchange As String, ByVal strLineNumber As String) As Long
            Me._CustomerID = lngCustomerID
            Me._PhoneTypeID = lngPhoneTypeID
            Me._CreatedBy = lngCreatedBy
            Me.CountryCode = strCountryCode
            Me.AreaCode = strAreaCode
            Me.Exchange = strExchange
            Me.LineNumber = strLineNumber
            Me.Add
            Return Me._CustomerPhoneNumberID
        End Function

        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If (strLog.Length > 0) Then
                strReturn = (strLog & Environment.NewLine)
            End If
            strReturn = (strReturn & strNewLine)
            strLog = strReturn
        End Sub

        Private Sub ClearValues()
            Me._CustomerPhoneNumberID = -1
            Me._CustomerID = -1
            Me._PhoneTypeID = -1
            Me._CreatedBy = -1
            Me._CountryCode = ""
            Me._Areacode = ""
            Me._Exchange = ""
            Me._LineNumber = ""
            Me._Extension = ""
            Me._Comment = ""
            Me._Pin = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCustomerPhoneNumber")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CustomerPhoneNumberID)
            End If
        End Sub

        Private Function EnforceMinLength(ByVal Input As String, ByVal MinLength As Long, ByVal PadChar As Char, ByVal PadSide As PadLocation) As String
            Dim strReturn As String = ""
            If (Input.Length = MinLength) Then
                Return Input
            End If
            Dim intPadCharCount As Integer = Convert.ToInt32(CLng((MinLength - Input.Length)))
            Dim VBt_i4L0 As Integer = intPadCharCount
            Dim intPos As Integer = 1
            Do While (intPos <= VBt_i4L0)
                strReturn = (strReturn & PadChar.ToString)
                intPos += 1
            Loop
            Select Case PadSide
                Case PadLocation.PadLeft
                    Return (strReturn & Input)
                Case PadLocation.PadRight
                    Return (Input & strReturn)
            End Select
            Return strReturn
        End Function

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim phnCompare As New CustomerPhoneNumberRecord(Me._CustomerPhoneNumberID, Me._ConnectionString)
                If (phnCompare.PhoneTypeID <> Me._PhoneTypeID) Then
                    blnReturn = True
                End If
                If (phnCompare.CountryCode <> Me._CountryCode) Then
                    blnReturn = True
                End If
                If (phnCompare.AreaCode <> Me._Areacode) Then
                    blnReturn = True
                End If
                If (phnCompare.Exchange <> Me._Exchange) Then
                    blnReturn = True
                End If
                If (phnCompare.LineNumber <> Me._LineNumber) Then
                    blnReturn = True
                End If
                If (phnCompare.Extension <> Me._Extension) Then
                    blnReturn = True
                End If
                If (phnCompare.Comment <> Me._Comment) Then
                    blnReturn = True
                End If
                If (phnCompare.Pin <> Me._Pin) Then
                    blnReturn = True
                End If
                If (phnCompare.Active <> Me._Active) Then
                    blnReturn = True
                End If
            End If
            Return blnReturn
        End Function

        Private Function LabelText(ByVal fmt As PhoneNumberFormat) As String
            Dim strReturn As String = ""
            strReturn = ((((strReturn & Me._CountryCode.Trim) & " (" & Me._Areacode.Trim) & ")" & Me._Exchange.Trim) & "-" & Me._LineNumber.Trim)
            Select Case fmt
                Case PhoneNumberFormat.Standard
                    Return strReturn.Trim
                Case PhoneNumberFormat.NumberPlusPin
                    Return (strReturn & " p:" & Me._Pin.Trim)
                Case PhoneNumberFormat.NumberPlusExtension
                    Return (strReturn & " x:" & Me._Extension.Trim)
                Case PhoneNumberFormat.NumberPlusPinAndExtension
                    Return String.Concat(New String() { strReturn, " x:", Me._Extension.Trim, " p:", Me._Pin.Trim })
            End Select
            Return strReturn
        End Function

        Public Sub Load(ByVal lngCustomerPhoneNumberID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerPhoneNumber")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = lngCustomerPhoneNumberID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CustomerPhoneNumberID = Conversions.ToLong(dtr.Item("CustomerPhoneNumberID"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._PhoneTypeID = Conversions.ToLong(dtr.Item("PhoneTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CountryCode = dtr.Item("CountryCode").ToString
                    Me._Areacode = dtr.Item("AreaCode").ToString
                    Me._Exchange = dtr.Item("Exchange").ToString
                    Me._LineNumber = dtr.Item("LineNumber").ToString
                    Me._Comment = dtr.Item("Comment").ToString
                    Me._Pin = dtr.Item("Pin").ToString
                    Me._Active = Convert.ToBoolean(RuntimeHelpers.GetObjectValue(dtr.Item("Active")))
                    Me._DateCreated = Convert.ToDateTime(RuntimeHelpers.GetObjectValue(dtr.Item("DateCreated")))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef Optional strChangeLog As String = "")
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim phnCompare As New CustomerPhoneNumberRecord(Me._CustomerPhoneNumberID, Me._ConnectionString)
                Dim strTemp As String = ""
                If (phnCompare.PhoneTypeID <> Me._PhoneTypeID) Then
                    Me.UpdatePhoneTypeID(Me._PhoneTypeID)
                    Dim ptyp As New PhoneTypeRecord(phnCompare.PhoneTypeID, Me._ConnectionString)
                    strTemp = ("Changed the phone type from '" & ptyp.PhoneType & "' to '")
                    ptyp = New PhoneTypeRecord(Me._PhoneTypeID, Me._ConnectionString)
                    strTemp = (strTemp & ptyp.PhoneType & "'")
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (phnCompare.CountryCode <> Me._CountryCode) Then
                    Me.UpdateCountryCode(Me._CountryCode)
                    strTemp = String.Concat(New String() { "Changed the country code from '", phnCompare.CountryCode, "' to '", Me._CountryCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (phnCompare.AreaCode <> Me._Areacode) Then
                    Me.UpdateAreaCode(Me._Areacode)
                    strTemp = String.Concat(New String() { "Changed the area code from '", phnCompare.AreaCode, "' to '", Me._Areacode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (phnCompare.Exchange <> Me._Exchange) Then
                    Me.UpdateExchange(Me._Exchange)
                    strTemp = String.Concat(New String() { "Changed the exchange from '", phnCompare.Exchange, "' to '", Me._Exchange, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (phnCompare.LineNumber <> Me._LineNumber) Then
                    Me.UpdateLineNumber(Me._LineNumber)
                    strTemp = String.Concat(New String() { "Changed the line number from '", phnCompare.LineNumber, "' to '", Me._LineNumber, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (phnCompare.Extension <> Me._Extension) Then
                    Me.UpdateExtension(Me._Extension)
                    strTemp = String.Concat(New String() { "Changed the extension from '", phnCompare.Exchange, "' to '", Me._Extension, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (phnCompare.Comment <> Me._Comment) Then
                    Me.UpdateComment(Me._Comment)
                    strTemp = String.Concat(New String() { "Changed the comment from '", phnCompare.Comment, "' to '", Me._Comment, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (phnCompare.Pin <> Me._Pin) Then
                    Me.UpdatePin(Me._Pin)
                    strTemp = String.Concat(New String() { "Changed the pin from '", phnCompare.Pin, "' to '", Me._Pin, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (phnCompare.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active)
                    strTemp = ("Changed the active state from " & phnCompare.Active.ToString & " to " & Me._Active.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
            End If
        End Sub

        Private Sub UpdateActive(ByVal NewActive As Boolean)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerPhoneNumberActive")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateAreaCode(ByVal NewAreaCode As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerPhoneNumberAreaCode")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                cmd.Parameters.Add("@AreaCode", SqlDbType.Char, NewAreaCode.Length).Value = NewAreaCode
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateComment(ByVal NewComment As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerPhoneNumberComment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                If (NewComment.Trim.Length > 0) Then
                    cmd.Parameters.Add("@Comment", SqlDbType.VarChar, NewComment.Trim.Length).Value = NewComment.Trim
                Else
                    cmd.Parameters.Add("@Comment", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateCountryCode(ByVal NewCountryCode As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerPhoneNumberCountryCode")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                cmd.Parameters.Add("@CountryCode", SqlDbType.VarChar, NewCountryCode.Trim.Length).Value = NewCountryCode.Trim
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateExchange(ByVal NewExchange As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerPhoneNumberExchange")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                cmd.Parameters.Add("@Exchange", SqlDbType.Char, NewExchange.Length).Value = NewExchange
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateExtension(ByVal NewExtension As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerPhoneNumberExtension")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                If (NewExtension.Trim.Length > 0) Then
                    cmd.Parameters.Add("Extension", SqlDbType.VarChar, NewExtension.Trim.Length).Value = NewExtension
                Else
                    cmd.Parameters.Add("Extension", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateLineNumber(ByVal NewLineNumber As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerPhoneNumberLineNumber")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                cmd.Parameters.Add("@LineNumber", SqlDbType.Char, NewLineNumber.Length).Value = NewLineNumber.Trim
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdatePhoneTypeID(ByVal NewPhoneTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerPhoneNumberPhoneTypeID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                cmd.Parameters.Add("@PhoneTypeID", SqlDbType.Int).Value = NewPhoneTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdatePin(ByVal NewPin As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerPhoneNumberPin")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerPhoneNumberID", SqlDbType.Int).Value = Me._CustomerPhoneNumberID
                If (NewPin.Trim.Length > 0) Then
                    cmd.Parameters.Add("@Pin", SqlDbType.VarChar, NewPin.Trim.Length).Value = NewPin.Trim
                Else
                    cmd.Parameters.Add("@Pin", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
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
                Return Me._Areacode
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= 3) Then
                    Me._Areacode = Me.EnforceMinLength(value.Trim, 3, Convert.ToChar("?"), PadLocation.PadLeft)
                Else
                    Me._Areacode = value.Trim.Substring(0, 3)
                End If
            End Set
        End Property

        Public Property Comment As String
            Get
                Return Me._Comment
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H40) Then
                    Me._Comment = value.Trim
                Else
                    Me._Comment = value.Trim.Substring(0, &H40)
                End If
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
                If (value.Trim.Length <= 8) Then
                    Me._CountryCode = value.Trim
                Else
                    Me._CountryCode = value.Trim.Substring(0, 8)
                End If
            End Set
        End Property

        Public ReadOnly Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public ReadOnly Property CustomerID As Long
            Get
                Return Me._CustomerID
            End Get
        End Property

        Public ReadOnly Property CustomerPhoneNumberID As Long
            Get
                Return Me._CustomerPhoneNumberID
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
                If (value.Trim.Length <= 3) Then
                    Me._Exchange = Me.EnforceMinLength(value.Trim, 3, Convert.ToChar("?"), PadLocation.PadLeft)
                Else
                    Me._Exchange = value.Trim.Substring(0, 3)
                End If
            End Set
        End Property

        Public Property Extension As String
            Get
                Return Me._Extension
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H10) Then
                    Me._Extension = value.Trim
                Else
                    Me._Extension = value.Trim.Substring(0, &H10)
                End If
            End Set
        End Property

        Public Property LineNumber As String
            Get
                Return Me._LineNumber
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= 4) Then
                    Me._LineNumber = Me.EnforceMinLength(value.Trim, 4, Convert.ToChar("?"), PadLocation.PadRight)
                Else
                    Me._LineNumber = value.Trim.Substring(0, 4)
                End If
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
                If (value.Trim.Length <= &H10) Then
                    Me._Pin = value.Trim
                Else
                    Me._Pin = value.Substring(0, &H10)
                End If
            End Set
        End Property

        Public ReadOnly Property Value As String
            Get
                Return Me.LabelText(Me._ValueFormat)
            End Get
        End Property

        Public Property ValueFormat As PhoneNumberFormat
            Get
                Return Me._ValueFormat
            End Get
            Set(ByVal value As PhoneNumberFormat)
                Me._ValueFormat = value
            End Set
        End Property


        ' Fields
        Private _Active As Boolean
        Private _Areacode As String
        Private _Comment As String
        Private _ConnectionString As String
        Private _CountryCode As String
        Private _CreatedBy As Long
        Private _CustomerID As Long
        Private _CustomerPhoneNumberID As Long
        Private _DateCreated As DateTime
        Private _Exchange As String
        Private _Extension As String
        Private _LineNumber As String
        Private _PhoneTypeID As Long
        Private _Pin As String
        Private _ValueFormat As PhoneNumberFormat
        Private Const AreaCodeMaxLength As Integer = 3
        Private Const AreaCodeMinLength As Integer = 3
        Private Const CommentMaxLength As Integer = &H40
        Private Const CountryCodeMaxLength As Integer = 8
        Private Const ExchangeMaxLength As Integer = 3
        Private Const ExchangeMinLength As Integer = 3
        Private Const ExtensionMaxLength As Integer = &H10
        Private Const LineNumberMaxLength As Integer = 4
        Private Const LineNumberMinLength As Integer = 4
        Private Const PinMaxLength As Integer = &H10

        ' Nested Types
        Private Enum PadLocation
            ' Fields
            PadLeft = 0
            PadRight = 1
        End Enum

        Public Enum PhoneNumberFormat
            ' Fields
            NumberPlusExtension = 2
            NumberPlusPin = 1
            NumberPlusPinAndExtension = 3
            Standard = 0
        End Enum
    End Class
End Namespace

