Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.InteropServices

Namespace BridgesInterface
    Public Class UserAddressRecord
        ' Methods
        Public Sub New(ByVal strConnectionstring As String)
            Me._UserAddressID = -1
            Me._UserID = -1
            Me._CreatedBy = -1
            Me._StateID = -1
            Me._AddressTypeID = -1
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
            Me._ConnectionString = strConnectionstring
        End Sub

        Public Sub New(ByVal lngUserAddressID As Long, ByVal strConnectionString As String)
            Me._UserAddressID = -1
            Me._UserID = -1
            Me._CreatedBy = -1
            Me._StateID = -1
            Me._AddressTypeID = -1
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
            Me._ConnectionString = strConnectionString
            Me.Load(lngUserAddressID)
        End Sub

        Public Sub New(ByVal lngUserID As Long, ByVal lngCreatedBy As Long, ByVal lngStateID As Long, ByVal lngAddressTypeID As Long, ByVal strStreet As String, ByVal strCity As String, ByVal strZipCode As String, ByVal strConnectionString As String, ByVal Optional strExtended As String = "")
            Me._UserAddressID = -1
            Me._UserID = -1
            Me._CreatedBy = -1
            Me._StateID = -1
            Me._AddressTypeID = -1
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.ClearValues
            Me.Add(lngUserID, lngCreatedBy, lngStateID, lngAddressTypeID, strStreet, strCity, strZipCode, strExtended)
        End Sub

        Public Function Add(ByVal lngUserID As Long, ByVal lngCreatedBy As Long, ByVal lngStateID As Long, ByVal lngAddressTypeID As Long, ByVal strStreet As String, ByVal strCity As String, ByVal strZipCode As String, ByVal Optional strExtended As String = "") As Long
            Dim lngReturn As Long = -1
            If (Me._ConnectionString.Trim.Length > 0) Then
                Me._UserID = lngUserID
                Me.CreatedBy = lngCreatedBy
                Me.StateID = lngStateID
                Me.AddressTypeID = lngAddressTypeID
                Me.Street = strStreet
                Me.Extended = strExtended
                Me.City = strCity
                Me.ZipCode = strZipCode
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddUserAddress")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
                cmd.Parameters.Add("@CreatedBY", SqlDbType.Int).Value = Me._CreatedBy
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = Me._StateID
                cmd.Parameters.Add("@AddressTypeID", SqlDbType.Int).Value = Me._AddressTypeID
                cmd.Parameters.Add("@Street", SqlDbType.VarChar, Me._Street.Length).Value = Me._Street
                cmd.Parameters.Add("@City", SqlDbType.VarChar, Me._City.Length).Value = Me._City
                cmd.Parameters.Add("@ZipCode", SqlDbType.VarChar, Me._ZipCode.Length).Value = Me._ZipCode
                cnn.Open
                cmd.Connection = cnn
                lngReturn = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                Me.Load(lngReturn)
                If (strExtended.Trim.Length > 0) Then
                    Me.UpdateExtended(strExtended.Trim)
                End If
            End If
            Return lngReturn
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
            Me._UserAddressID = -1
            Me._UserID = -1
            Me._CreatedBy = -1
            Me._StateID = -1
            Me._AddressTypeID = -1
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._Active = True
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveUserAddress")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserAddressID", SqlDbType.Int).Value = Me._UserAddressID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._UserAddressID)
            End If
        End Sub

        Private Function FormatForLabel() As String
            Dim strTemp As String = ""
            If (Me._ConnectionString.Trim.Length <= 0) Then
                Return strTemp
            End If
            strTemp = (strTemp & Me._Street & Environment.NewLine)
            If (Me._Extended.Trim.Length > 0) Then
                strTemp = (strTemp & Me._Extended & Environment.NewLine)
            End If
            strTemp = (strTemp & Me._City & ",")
            Dim stState As New StateRecord(Me._StateID, Me._ConnectionString)
            Return ((strTemp & stState.Abbreviation & ". ") & Me._ZipCode)
        End Function

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim uaddCompare As New UserAddressRecord(Me._UserAddressID, Me._ConnectionString)
            If (uaddCompare.StateID <> Me._StateID) Then
                blnReturn = True
            End If
            If (uaddCompare.AddressTypeID <> Me._AddressTypeID) Then
                blnReturn = True
            End If
            If (uaddCompare.Street <> Me._Street) Then
                blnReturn = True
            End If
            If (uaddCompare.Extended <> Me._Extended) Then
                blnReturn = True
            End If
            If (uaddCompare.City <> Me._City) Then
                blnReturn = True
            End If
            If (uaddCompare.ZipCode <> Me._ZipCode) Then
                blnReturn = True
            End If
            If (uaddCompare.Active <> Me._Active) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngUserAddressID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetUserAddress")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserAddressID", SqlDbType.Int).Value = lngUserAddressID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._UserAddressID = Conversions.ToLong(dtr.Item("UserAddressID"))
                    Me._UserID = Conversions.ToLong(dtr.Item("UserID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._StateID = Conversions.ToLong(dtr.Item("StateID"))
                    Me._AddressTypeID = Conversions.ToLong(dtr.Item("AddressTypeID"))
                    Me._Street = dtr.Item("Street").ToString
                    Me._Extended = dtr.Item("Extended").ToString
                    Me._City = dtr.Item("City").ToString
                    Me._ZipCode = dtr.Item("ZipCode").ToString
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef Optional strChangeLog As String = "")
            Dim addCompare As New UserAddressRecord(Me._UserAddressID, Me._ConnectionString)
            strChangeLog = ""
            If (addCompare.StateID <> Me._StateID) Then
                Dim stFrom As New StateRecord(addCompare.StateID, Me._ConnectionString)
                Dim stTo As New StateRecord(Me._StateID, Me._ConnectionString)
                Me.UpdateStateID(Me._StateID)
                Me.AppendChangeLog((strChangeLog), String.Concat(New String() { "State changed from '", stFrom.StateName, "' to '", stTo.StateName, "'" }))
            End If
            If (addCompare.AddressTypeID <> Me._AddressTypeID) Then
                Dim adtFrom As New AddressTypeRecord(addCompare.AddressTypeID, Me._ConnectionString)
                Dim adtTo As New AddressTypeRecord(Me._AddressTypeID, Me._ConnectionString)
                Me.UpdateAddressTypeID(Me._AddressTypeID)
                Me.AppendChangeLog((strChangeLog), String.Concat(New String() { "Address type changed from '", adtFrom.AddressType, "' to '", adtTo.AddressType, "'" }))
            End If
            If (addCompare.Street <> Me._Street) Then
                Me.UpdateStreet(Me._Street)
                Me.AppendChangeLog((strChangeLog), String.Concat(New String() { "Street (Line 1) changed from '", addCompare.Street, "' to '", Me._Street, "'" }))
            End If
            If (addCompare.Extended <> Me._Extended) Then
                Me.UpdateExtended(Me._Extended)
                Me.AppendChangeLog((strChangeLog), String.Concat(New String() { "Extended (line 2) changed from '", addCompare.Extended, "' to '", Me._Extended, "'" }))
            End If
            If (addCompare.City <> Me._City) Then
                Me.UpdateCity(Me._City)
                Me.AppendChangeLog((strChangeLog), String.Concat(New String() { "City changed from '", addCompare.City, "' to '", Me._City, "'" }))
            End If
            If (addCompare.ZipCode <> Me._ZipCode) Then
                Me.UpdateZipCode(Me._ZipCode)
                Me.AppendChangeLog((strChangeLog), String.Concat(New String() { "Zip Code changed from '", addCompare.ZipCode, "' to '", Me._ZipCode, "'" }))
            End If
            If (addCompare.Active <> Me._Active) Then
                Me.UpdateActive(Me._Active)
                Me.AppendChangeLog((strChangeLog), String.Concat(New String() { "Active changed from '", addCompare.Active.ToString, "' to '", Me._Active.ToString, "'" }))
            End If
        End Sub

        Private Sub UpdateActive(ByVal blnNewActive As Boolean)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateUserAddressActive")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserAddressID", SqlDbType.Int).Value = Me._UserAddressID
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = blnNewActive
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateAddressTypeID(ByVal lngNewAddressTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateUserAddressAddressTypeID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserAddressID", SqlDbType.Int).Value = Me._UserAddressID
                cmd.Parameters.Add("@AddressTypeID", SqlDbType.Int).Value = lngNewAddressTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateCity(ByVal strNewCity As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateUserAddressCity")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserAddressID", SqlDbType.Int).Value = Me._UserAddressID
                If (strNewCity.Trim.Length > &H80) Then
                    strNewCity = strNewCity.Trim.Substring(0, &H80)
                End If
                cmd.Parameters.Add("@City", SqlDbType.VarChar, strNewCity.Trim.Length).Value = strNewCity.Trim
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateExtended(ByVal strNewExtended As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateUserAddressExtended")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserAddressID", SqlDbType.Int).Value = Me._UserAddressID
                If (strNewExtended.Trim.Length > &HFF) Then
                    strNewExtended = strNewExtended.Substring(0, &HFF)
                End If
                If (strNewExtended.Trim.Length > 0) Then
                    cmd.Parameters.Add("@Extended", SqlDbType.VarChar, strNewExtended.Trim.Length).Value = strNewExtended.Trim
                Else
                    cmd.Parameters.Add("@Extended", SqlDbType.VarChar).Value = DBNull.Value
                End If
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Extended = strNewExtended
            End If
        End Sub

        Private Sub UpdateStateID(ByVal lngNewStateID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateUserAddressStateID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserAddressID", SqlDbType.Int).Value = Me._UserAddressID
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = lngNewStateID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateStreet(ByVal strNewStreet As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateUserAddressStreet")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserAddressID", SqlDbType.Int).Value = Me._UserAddressID
                If (strNewStreet.Trim.Length > &HFF) Then
                    strNewStreet = strNewStreet.Trim.Substring(0, &HFF)
                End If
                cmd.Parameters.Add("@Street", SqlDbType.VarChar, strNewStreet.Trim.Length).Value = strNewStreet.Trim
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateZipCode(ByVal strNewZipCode As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserAddressID", SqlDbType.Int).Value = Me._UserAddressID
                If (strNewZipCode.Trim.Length > &H10) Then
                    strNewZipCode = strNewZipCode.Trim.Substring(0, &H10)
                End If
                cmd.Parameters.Add("@ZipCode", SqlDbType.VarChar, strNewZipCode.Trim.Length).Value = strNewZipCode.Trim
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

        Public Property AddressTypeID As Long
            Get
                Return Me._AddressTypeID
            End Get
            Set(ByVal value As Long)
                Me._AddressTypeID = value
            End Set
        End Property

        Public Property City As String
            Get
                Return Me._City
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H80) Then
                    Me._City = value.Trim
                Else
                    Me._City = value.Trim.Substring(0, &H80)
                End If
            End Set
        End Property

        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString.Trim
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value.Trim
            End Set
        End Property

        Public Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
            Set(ByVal value As Long)
                Me._CreatedBy = value
            End Set
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property Extended As String
            Get
                Return Me._Extended
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HFF) Then
                    Me._Extended = value.Trim
                Else
                    Me._Extended = value.Trim.Substring(0, &HFF)
                End If
            End Set
        End Property

        Public ReadOnly Property LabelText As String
            Get
                Return Me.FormatForLabel
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property StateID As Long
            Get
                Return Me._StateID
            End Get
            Set(ByVal value As Long)
                Me._StateID = value
            End Set
        End Property

        Public Property Street As String
            Get
                Return Me._Street
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HFF) Then
                    Me._Street = value.Trim
                Else
                    Me._Street = value.Trim.Substring(0, &HFF)
                End If
            End Set
        End Property

        Public ReadOnly Property UserAddressID As Long
            Get
                Return Me._UserAddressID
            End Get
        End Property

        Public ReadOnly Property UserID As Long
            Get
                Return Me._UserID
            End Get
        End Property

        Public Property ZipCode As String
            Get
                Return Me._ZipCode
            End Get
            Set(ByVal value As String)
                If (value.Length <= &H10) Then
                    Me._ZipCode = value
                Else
                    Me._ZipCode = value.Trim.Substring(0, &H10)
                End If
            End Set
        End Property


        ' Fields
        Private _Active As Boolean
        Private _AddressTypeID As Long
        Private _City As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Extended As String
        Private _StateID As Long
        Private _Street As String
        Private _UserAddressID As Long
        Private _UserID As Long
        Private _ZipCode As String
        Private Const CityMaxLength As Integer = &H80
        Private Const ExtendedMaxLength As Integer = &HFF
        Private Const StreetMaxLength As Integer = &HFF
        Private Const ZipCodeMaxLength As Integer = &H10
    End Class
End Namespace

