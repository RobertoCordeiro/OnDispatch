Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ResumeAddressRecord
        ' Methods
        Public Sub New()
            Me._ResumeAddressID = 0
            Me._ResumeID = 0
            Me._CreatedBy = 0
            Me._StateID = 0
            Me._AddressTypeID = 0
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._DateCreated = DateTime.Now
            Me._Active = True
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ResumeAddressID = 0
            Me._ResumeID = 0
            Me._CreatedBy = 0
            Me._StateID = 0
            Me._AddressTypeID = 0
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._DateCreated = DateTime.Now
            Me._Active = True
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngResumeAddressID As Long, ByVal strConnectionString As String)
            Me._ResumeAddressID = 0
            Me._ResumeID = 0
            Me._CreatedBy = 0
            Me._StateID = 0
            Me._AddressTypeID = 0
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._DateCreated = DateTime.Now
            Me._Active = True
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ResumeAddressID)
        End Sub

        Public Sub Add(ByVal lngResumeID As Long, ByVal lngCreatedBy As Long, ByVal lngStateID As Long, ByVal lngAddressTypeID As Long, ByVal strStreet As String, ByVal strCity As String, ByVal strZipCode As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResumeAddress")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngResumeAddressID As Long = 0
                cmd.Parameters.Add("@ResumeID", SqlDbType.Int).Value = lngResumeID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = lngStateID
                cmd.Parameters.Add("@AddressTypeID", SqlDbType.Int).Value = lngAddressTypeID
                cmd.Parameters.Add("@Street", SqlDbType.VarChar, Me.TrimTrunc(strStreet, &HFF).Length).Value = Me.TrimTrunc(strStreet, &HFF)
                cmd.Parameters.Add("@City", SqlDbType.VarChar, Me.TrimTrunc(strCity, &H80).Length).Value = Me.TrimTrunc(strCity, &H80)
                cmd.Parameters.Add("@ZipCode", SqlDbType.VarChar, Me.TrimTrunc(strZipCode, &H10).Length).Value = Me.TrimTrunc(strZipCode, &H10)
                cnn.Open
                cmd.Connection = cnn
                lngResumeAddressID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngResumeAddressID > 0) Then
                    Me.Load(lngResumeAddressID)
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
            Me._ResumeAddressID = 0
            Me._ResumeID = 0
            Me._CreatedBy = 0
            Me._StateID = 0
            Me._AddressTypeID = 0
            Me._Street = ""
            Me._Extended = ""
            Me._City = ""
            Me._ZipCode = ""
            Me._DateCreated = DateTime.Now
            Me._Active = True
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumeAddress")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeAddressID", SqlDbType.Int).Value = Me._ResumeAddressID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ResumeAddressID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumeAddressRecord(Me._ResumeAddressID, Me._ConnectionString)
            If (obj.StateID <> Me._StateID) Then
                blnReturn = True
            End If
            If (obj.AddressTypeID <> Me._AddressTypeID) Then
                blnReturn = True
            End If
            If (obj.Street <> Me._Street) Then
                blnReturn = True
            End If
            If (obj.Extended <> Me._Extended) Then
                blnReturn = True
            End If
            If (obj.City <> Me._City) Then
                blnReturn = True
            End If
            If (obj.ZipCode <> Me._ZipCode) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngResumeAddressID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeAddress")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeAddressID", SqlDbType.Int).Value = lngResumeAddressID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ResumeAddressID = Conversions.ToLong(dtr.Item("ResumeAddressID"))
                    Me._ResumeID = Conversions.ToLong(dtr.Item("ResumeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._StateID = Conversions.ToLong(dtr.Item("StateID"))
                    Me._AddressTypeID = Conversions.ToLong(dtr.Item("AddressTypeID"))
                    Me._Street = dtr.Item("Street").ToString
                    Me._Extended = dtr.Item("Extended").ToString
                    Me._City = dtr.Item("City").ToString
                    Me._ZipCode = dtr.Item("ZipCode").ToString
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
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
                Dim obj As New ResumeAddressRecord(Me._ResumeAddressID, Me._ConnectionString)
                obj.Load(Me._ResumeAddressID)
                If (obj.StateID <> Me._StateID) Then
                    Me.UpdateStateID(Me._StateID, (cnn))
                    strTemp = String.Concat(New String() { "StateID Changed to '", Conversions.ToString(Me._StateID), "' from '", Conversions.ToString(obj.StateID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AddressTypeID <> Me._AddressTypeID) Then
                    Me.UpdateAddressTypeID(Me._AddressTypeID, (cnn))
                    strTemp = String.Concat(New String() { "AddressTypeID Changed to '", Conversions.ToString(Me._AddressTypeID), "' from '", Conversions.ToString(obj.AddressTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Street <> Me._Street) Then
                    Me.UpdateStreet(Me._Street, (cnn))
                    strTemp = String.Concat(New String() { "Street Changed to '", Me._Street, "' from '", obj.Street, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Extended <> Me._Extended) Then
                    Me.UpdateExtended(Me._Extended, (cnn))
                    strTemp = String.Concat(New String() { "Extended Changed to '", Me._Extended, "' from '", obj.Extended, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.City <> Me._City) Then
                    Me.UpdateCity(Me._City, (cnn))
                    strTemp = String.Concat(New String() { "City Changed to '", Me._City, "' from '", obj.City, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ZipCode <> Me._ZipCode) Then
                    Me.UpdateZipCode(Me._ZipCode, (cnn))
                    strTemp = String.Concat(New String() { "ZipCode Changed to '", Me._ZipCode, "' from '", obj.ZipCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ResumeAddressID)
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
            Dim cmd As New SqlCommand("spUpdateResumeAddressActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeAddressID", SqlDbType.Int).Value = Me._ResumeAddressID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAddressTypeID(ByVal NewAddressTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeAddressAddressTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeAddressID", SqlDbType.Int).Value = Me._ResumeAddressID
            cmd.Parameters.Add("@AddressTypeID", SqlDbType.Int).Value = NewAddressTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCity(ByVal NewCity As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeAddressCity")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeAddressID", SqlDbType.Int).Value = Me._ResumeAddressID
            cmd.Parameters.Add("@City", SqlDbType.VarChar, Me.TrimTrunc(NewCity, &H80).Length).Value = Me.TrimTrunc(NewCity, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateExtended(ByVal NewExtended As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeAddressExtended")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeAddressID", SqlDbType.Int).Value = Me._ResumeAddressID
            If (NewExtended.Trim.Length > 0) Then
                cmd.Parameters.Add("@Extended", SqlDbType.VarChar, Me.TrimTrunc(NewExtended, &HFF).Length).Value = Me.TrimTrunc(NewExtended, &HFF)
            Else
                cmd.Parameters.Add("@Extended", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateStateID(ByVal NewStateID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeAddressStateID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeAddressID", SqlDbType.Int).Value = Me._ResumeAddressID
            cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = NewStateID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateStreet(ByVal NewStreet As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeAddressStreet")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeAddressID", SqlDbType.Int).Value = Me._ResumeAddressID
            cmd.Parameters.Add("@Street", SqlDbType.VarChar, Me.TrimTrunc(NewStreet, &HFF).Length).Value = Me.TrimTrunc(NewStreet, &HFF)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateZipCode(ByVal NewZipCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeAddressZipCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeAddressID", SqlDbType.Int).Value = Me._ResumeAddressID
            cmd.Parameters.Add("@ZipCode", SqlDbType.VarChar, Me.TrimTrunc(NewZipCode, &H10).Length).Value = Me.TrimTrunc(NewZipCode, &H10)
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
                Me._City = Me.TrimTrunc(value, &H80)
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

        Public Property Extended As String
            Get
                Return Me._Extended
            End Get
            Set(ByVal value As String)
                Me._Extended = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property ResumeAddressID As Long
            Get
                Return Me._ResumeAddressID
            End Get
        End Property

        Public ReadOnly Property ResumeID As Long
            Get
                Return Me._ResumeID
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
                Me._Street = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property ZipCode As String
            Get
                Return Me._ZipCode
            End Get
            Set(ByVal value As String)
                Me._ZipCode = Me.TrimTrunc(value, &H10)
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
        Private _ResumeAddressID As Long
        Private _ResumeID As Long
        Private _StateID As Long
        Private _Street As String
        Private _ZipCode As String
        Private Const CityMaxLength As Integer = &H80
        Private Const ExtendedMaxLength As Integer = &HFF
        Private Const StreetMaxLength As Integer = &HFF
        Private Const ZipCodeMaxLength As Integer = &H10
    End Class
End Namespace

