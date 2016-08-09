Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class StateRecord
        ' Methods
        Public Sub New()
            Me._StateID = 0
            Me._CreatedBy = 0
            Me._CountryID = 0
            Me._Abbreviation = ""
            Me._StateName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._StateID = 0
            Me._CreatedBy = 0
            Me._CountryID = 0
            Me._Abbreviation = ""
            Me._StateName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngStateID As Long, ByVal strConnectionString As String)
            Me._StateID = 0
            Me._CreatedBy = 0
            Me._CountryID = 0
            Me._Abbreviation = ""
            Me._StateName = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._StateID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngCountryID As Long, ByVal strAbbreviation As String, ByVal strStateName As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddState")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngStateID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = lngCountryID
                cmd.Parameters.Add("@Abbreviation", SqlDbType.Char, Me.TrimTrunc(strAbbreviation, 2).Length).Value = Me.TrimTrunc(strAbbreviation, 2)
                cmd.Parameters.Add("@StateName", SqlDbType.VarChar, Me.TrimTrunc(strStateName, &H20).Length).Value = Me.TrimTrunc(strStateName, &H20)
                cnn.Open
                cmd.Connection = cnn
                lngStateID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngStateID > 0) Then
                    Me.Load(lngStateID)
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
            Me._StateID = 0
            Me._CreatedBy = 0
            Me._CountryID = 0
            Me._Abbreviation = ""
            Me._StateName = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveState")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = Me._StateID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._StateID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New StateRecord(Me._StateID, Me._ConnectionString)
            obj.Load(Me._StateID)
            If (obj.CountryID <> Me._CountryID) Then
                blnReturn = True
            End If
            If (obj.Abbreviation <> Me._Abbreviation) Then
                blnReturn = True
            End If
            If (obj.StateName <> Me._StateName) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngStateID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetState")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = lngStateID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._StateID = Conversions.ToLong(dtr.Item("StateID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CountryID = Conversions.ToLong(dtr.Item("CountryID"))
                    Me._Abbreviation = dtr.Item("Abbreviation").ToString
                    Me._StateName = dtr.Item("StateName").ToString
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub LoadFromZip(ByVal strZipCode As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetStateFromZip")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ZipCode", SqlDbType.Int).Value = strZipCode
                cnn.Open()
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._StateID = Conversions.ToLong(dtr.Item("StateID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CountryID = Conversions.ToLong(dtr.Item("CountryID"))
                    Me._Abbreviation = dtr.Item("Abbreviation").ToString
                    Me._StateName = dtr.Item("StateName").ToString
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues()
                End If
                cnn.Close()
            End If
        End Sub
        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New StateRecord(Me._StateID, Me._ConnectionString)
                obj.Load(Me._StateID)
                If (obj.CountryID <> Me._CountryID) Then
                    Me.UpdateCountryID(Me._CountryID, (cnn))
                    strTemp = String.Concat(New String() { "CountryID Changed to '", Conversions.ToString(Me._CountryID), "' from '", Conversions.ToString(obj.CountryID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Abbreviation <> Me._Abbreviation) Then
                    Me.UpdateAbbreviation(Me._Abbreviation, (cnn))
                    strTemp = String.Concat(New String() { "Abbreviation Changed to '", Me._Abbreviation, "' from '", obj.Abbreviation, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.StateName <> Me._StateName) Then
                    Me.UpdateStateName(Me._StateName, (cnn))
                    strTemp = String.Concat(New String() { "StateName Changed to '", Me._StateName, "' from '", obj.StateName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._StateID)
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

        Private Sub UpdateAbbreviation(ByVal NewAbbreviation As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateStateAbbreviation")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = Me._StateID
            cmd.Parameters.Add("@Abbreviation", SqlDbType.Char, Me.TrimTrunc(NewAbbreviation, 2).Length).Value = Me.TrimTrunc(NewAbbreviation, 2)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCountryID(ByVal NewCountryID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateStateCountryID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = Me._StateID
            cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = NewCountryID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateStateName(ByVal NewStateName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateStateStateName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = Me._StateID
            cmd.Parameters.Add("@StateName", SqlDbType.VarChar, Me.TrimTrunc(NewStateName, &H20).Length).Value = Me.TrimTrunc(NewStateName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property Abbreviation As String
            Get
                Return Me._Abbreviation
            End Get
            Set(ByVal value As String)
                Me._Abbreviation = Me.TrimTrunc(value, 2)
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

        Public Property CountryID As Long
            Get
                Return Me._CountryID
            End Get
            Set(ByVal value As Long)
                Me._CountryID = value
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

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property StateID As Long
            Get
                Return Me._StateID
            End Get
        End Property

        Public Property StateName As String
            Get
                Return Me._StateName
            End Get
            Set(ByVal value As String)
                Me._StateName = Me.TrimTrunc(value, &H20)
            End Set
        End Property


        ' Fields
        Private _Abbreviation As String
        Private _ConnectionString As String
        Private _CountryID As Long
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _StateID As Long
        Private _StateName As String
        Private Const AbbreviationMaxLength As Integer = 2
        Private Const StateNameMaxLength As Integer = &H20
    End Class
End Namespace

