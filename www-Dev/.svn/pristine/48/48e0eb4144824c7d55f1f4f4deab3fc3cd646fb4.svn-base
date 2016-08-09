Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class WebLoginRecord
        ' Methods
        Public Sub New()
            Me._WebLoginID = 0
            Me._CreatedBy = 0
            Me._Login = ""
            Me._PasswordHashSum = 0
            Me._AccessCoding = ""
            Me._Active = False
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._WebLoginID = 0
            Me._CreatedBy = 0
            Me._Login = ""
            Me._PasswordHashSum = 0
            Me._AccessCoding = ""
            Me._Active = False
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngWebLoginID As Long, ByVal strConnectionString As String)
            Me._WebLoginID = 0
            Me._CreatedBy = 0
            Me._Login = ""
            Me._PasswordHashSum = 0
            Me._AccessCoding = ""
            Me._Active = False
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._WebLoginID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strLogin As String, ByVal strPassword As String, ByVal strAccessCoding As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddWebLogin")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngWebLoginID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Login", SqlDbType.VarChar, Me.TrimTrunc(strLogin, &H20).Length).Value = Me.TrimTrunc(strLogin, &H20)
                cmd.Parameters.Add("@AccessCoding", SqlDbType.Char, Me.TrimTrunc(strAccessCoding, 1).Length).Value = Me.TrimTrunc(strAccessCoding, 1)
                cnn.Open
                cmd.Connection = cnn
                lngWebLoginID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngWebLoginID > 0) Then
                    Me.Load(lngWebLoginID)
                    cnn.Open
                    Me.UpdatePasswordHashSum(Me.HashPassword(lngWebLoginID, strPassword), (cnn))
                    cnn.Close
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
            Me._WebLoginID = 0
            Me._CreatedBy = 0
            Me._Login = ""
            Me._PasswordHashSum = 0
            Me._AccessCoding = ""
            Me._Active = False
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveWebLogin")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = Me._WebLoginID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._WebLoginID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New WebLoginRecord(Me._WebLoginID, Me._ConnectionString)
            obj.Load(Me._WebLoginID)
            If (obj.CreatedBy <> Me._CreatedBy) Then
                blnReturn = True
            End If
            If (obj.Login <> Me._Login) Then
                blnReturn = True
            End If
            If (obj.PasswordHashSum <> Me._PasswordHashSum) Then
                blnReturn = True
            End If
            If (obj.AccessCoding <> Me._AccessCoding) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Private Function HashPassword(ByVal strPassword As String) As Long
            Return Me.HashPassword(Me._WebLoginID, strPassword)
        End Function

        Private Function HashPassword(ByVal lngCustomerAgentID As Long, ByVal strPassword As String) As Long
            Dim VBt_i8S0 As Long = (lngCustomerAgentID * 12)
            Return Me.SimpleHash((VBt_i8S0.ToString("000000000000") & strPassword), strPassword)
        End Function

        Public Sub Load(ByVal lngWebLoginID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetWebLogin")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = lngWebLoginID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._WebLoginID = Conversions.ToLong(dtr.Item("WebLoginID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Login = dtr.Item("Login").ToString
                    Me._PasswordHashSum = Conversions.ToLong(dtr.Item("PasswordHashSum"))
                    Me._AccessCoding = dtr.Item("AccessCoding").ToString
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Load(ByVal strLogin As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetWebLoginIDByLogin")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@Login", SqlDbType.VarChar, strLogin.Trim.Length).Value = strLogin.Trim
                Dim lngID As Long = 0
                cnn.Open
                cmd.Connection = cnn
                lngID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                Me.Load(lngID)
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New WebLoginRecord(Me._WebLoginID, Me._ConnectionString)
                obj.Load(Me._WebLoginID)
                If (obj.CreatedBy <> Me._CreatedBy) Then
                    Me.UpdateCreatedBy(Me._CreatedBy, (cnn))
                    strTemp = String.Concat(New String() { "CreatedBy Changed to '", Conversions.ToString(Me._CreatedBy), "' from '", Conversions.ToString(obj.CreatedBy), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Login <> Me._Login) Then
                    Me.UpdateLogin(Me._Login, (cnn))
                    strTemp = String.Concat(New String() { "Login Changed to '", Me._Login, "' from '", obj.Login, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PasswordHashSum <> Me._PasswordHashSum) Then
                    Me.UpdatePasswordHashSum(Me._PasswordHashSum, (cnn))
                    strTemp = String.Concat(New String() { "PasswordHashSum Changed to '", Conversions.ToString(Me._PasswordHashSum), "' from '", Conversions.ToString(obj.PasswordHashSum), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AccessCoding <> Me._AccessCoding) Then
                    Me.UpdateAccessCoding(Me._AccessCoding, (cnn))
                    strTemp = String.Concat(New String() { "AccessCoding Changed to '", Me._AccessCoding, "' from '", obj.AccessCoding, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                    Me.UpdateDateCreated(Me._DateCreated, (cnn))
                    strTemp = String.Concat(New String() { "DateCreated Changed to '", Conversions.ToString(Me._DateCreated), "' from '", Conversions.ToString(obj.DateCreated), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._WebLoginID)
            Else
                Me.ClearValues
            End If
        End Sub

        Public Sub SetPassword(ByVal strNewPassword As String)
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim lng As Long = Me.HashPassword(strNewPassword)
            cnn.Open
            Me.UpdatePasswordHashSum(lng, (cnn))
            Me._PasswordHashSum = lng
            cnn.Close
        End Sub

        Private Function SimpleHash(ByVal strSalt As String, ByVal strData As String) As Long
            Dim intPos As Integer = 1
            Dim lngWork As Long = 0
            Dim lngSaltValue As Long = 0
            Dim lngDataValue As Long = 0
            Dim VBt_i4L0 As Integer = strSalt.Length
            intPos = 1
            Do While (intPos <= VBt_i4L0)
                If (strSalt.Length > 1) Then
                    If (intPos > 1) Then
                        Dim chrSalt As Char = Convert.ToChar(strSalt.Substring((intPos - 1), 1))
                        lngWork = (Convert.ToInt32(chrSalt) + Convert.ToInt32(chrSalt))
                    Else
                        lngWork = Convert.ToInt32(Convert.ToChar(strSalt.Substring((intPos - 1), 1)))
                    End If
                Else
                    lngWork = Convert.ToInt32(Convert.ToChar(strSalt.Substring((intPos - 1), 1)))
                End If
                lngSaltValue = (lngSaltValue + lngWork)
                intPos += 1
            Loop
            Dim VBt_i4L1 As Integer = strData.Length
            intPos = 1
            Do While (intPos <= VBt_i4L1)
                If (strSalt.Length > 1) Then
                    If (intPos > 1) Then
                        Dim chrData As Char = Convert.ToChar(strData.Substring((intPos - 1), 1))
                        lngWork = (Convert.ToInt32(chrData) * Convert.ToInt32(chrData))
                    Else
                        lngWork = Convert.ToInt32(Convert.ToChar(strData.Substring((intPos - 1), 1)))
                    End If
                Else
                    lngWork = Convert.ToInt32(Convert.ToChar(strData.Substring((intPos - 1), 1)))
                End If
                lngDataValue = (lngDataValue + lngWork)
                intPos += 1
            Loop
            Return ((lngSaltValue * Convert.ToInt32(Math.Sqrt(CDbl(lngSaltValue)))) + lngDataValue)
        End Function

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function

        Private Sub UpdateAccessCoding(ByVal NewAccessCoding As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWebLoginAccessCoding")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = Me._WebLoginID
            cmd.Parameters.Add("@AccessCoding", SqlDbType.Char, Me.TrimTrunc(NewAccessCoding, 1).Length).Value = Me.TrimTrunc(NewAccessCoding, 1)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWebLoginActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = Me._WebLoginID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCreatedBy(ByVal NewCreatedBy As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWebLoginCreatedBy")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = Me._WebLoginID
            cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = NewCreatedBy
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDateCreated(ByVal NewDateCreated As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWebLoginDateCreated")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = Me._WebLoginID
            cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = NewDateCreated
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLastLogin(ByVal NewLastLogin As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWebLoginLastLogin")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = Me._WebLoginID
            cmd.Parameters.Add("@LastLogin", SqlDbType.DateTime).Value = NewLastLogin
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLogin(ByVal NewLogin As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWebLoginLogin")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = Me._WebLoginID
            cmd.Parameters.Add("@Login", SqlDbType.VarChar, Me.TrimTrunc(NewLogin, &H20).Length).Value = Me.TrimTrunc(NewLogin, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePasswordHashSum(ByVal NewPasswordHashSum As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWebLoginPasswordHashSum")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = Me._WebLoginID
            cmd.Parameters.Add("@PasswordHashSum", SqlDbType.BigInt).Value = NewPasswordHashSum
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Public Function Validate(ByVal strLogin As String, ByVal strPassword As String) As Boolean
            Dim lngHashValue As Long = 0
            Dim lngCustomerAgentID As Long = 0
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand("spGetWebLoginIDByLogin")
            Dim blnReturn As Boolean = False
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@Login", SqlDbType.VarChar, strLogin.Length).Value = strLogin
            cnn.Open
            cmd.Connection = cnn
            lngCustomerAgentID = Conversions.ToLong(cmd.ExecuteScalar)
            Me.Load(lngCustomerAgentID)
            lngHashValue = Me.HashPassword(Me._WebLoginID, strPassword)
            If (Me._WebLoginID > 0) Then
                If Me._Active Then
                    If (Me._PasswordHashSum = lngHashValue) Then
                        Me.UpdateLastLogin(DateTime.Now, (cnn))
                        blnReturn = True
                    Else
                        blnReturn = False
                    End If
                Else
                    blnReturn = False
                End If
            Else
                blnReturn = False
            End If
            cnn.Close
            Return blnReturn
        End Function


        ' Properties
        Public Property AccessCoding As String
            Get
                Return Me._AccessCoding
            End Get
            Set(ByVal value As String)
                Me._AccessCoding = Me.TrimTrunc(value, 1)
            End Set
        End Property

        Public Property Active As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
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

        Public Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
            Set(ByVal value As Long)
                Me._CreatedBy = value
            End Set
        End Property

        Public Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
            Set(ByVal value As DateTime)
                Me._DateCreated = value
            End Set
        End Property

        Public Property Login As String
            Get
                Return Me._Login
            End Get
            Set(ByVal value As String)
                Me._Login = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property PasswordHashSum As Long
            Get
                Return Me._PasswordHashSum
            End Get
            Set(ByVal value As Long)
                Me._PasswordHashSum = value
            End Set
        End Property

        Public ReadOnly Property WebLoginID As Long
            Get
                Return Me._WebLoginID
            End Get
        End Property


        ' Fields
        Private _AccessCoding As String
        Private _Active As Boolean
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Login As String
        Private _PasswordHashSum As Long
        Private _WebLoginID As Long
        Private Const AccessCodingMaxLength As Integer = 1
        Private Const LoginMaxLength As Integer = &H20
    End Class
End Namespace

