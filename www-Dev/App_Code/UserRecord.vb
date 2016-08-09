﻿Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class UserRecord
        ' Methods
        Public Sub New()
            Me._UserID = 0
            Me._PositionID = 0
            Me._PictureID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._UserName = ""
            Me._PasswordHashSum = 0
            Me._Title = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Suffix = ""
            Me._Email = ""
            Me._Extension = ""
            Me._Signature = ""
            Me._EmploymentStart = New DateTime
            Me._EmploymentEnd = New DateTime
            Me._Active = False
            Me._ForcePasswordReset = False
            Me._DateCreated = DateTime.Now
            Me._StartTime = DateTime.Now
            Me._StopTime = DateTime.Now
            Me._LunchStartTime = DateTime.Now
            Me._LunchStopTime = DateTime.Now
            Me._InfoID = 0
            Me._DepartmentID = 0
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._UserID = 0
            Me._PositionID = 0
            Me._PictureID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._UserName = ""
            Me._PasswordHashSum = 0
            Me._Title = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Suffix = ""
            Me._Email = ""
            Me._Extension = ""
            Me._Signature = ""
            Me._EmploymentStart = New DateTime
            Me._EmploymentEnd = New DateTime
            Me._Active = False
            Me._ForcePasswordReset = False
            Me._DateCreated = DateTime.Now
            Me._StartTime = DateTime.Now
            Me._StopTime = DateTime.Now
            Me._LunchStartTime = DateTime.Now
            Me._LunchStopTime = DateTime.Now
            Me._InfoID = 0
            Me._DepartmentID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngUserID As Long, ByVal strConnectionString As String)
            Me._UserID = 0
            Me._PositionID = 0
            Me._PictureID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._UserName = ""
            Me._PasswordHashSum = 0
            Me._Title = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Suffix = ""
            Me._Email = ""
            Me._Extension = ""
            Me._Signature = ""
            Me._EmploymentStart = New DateTime
            Me._EmploymentEnd = New DateTime
            Me._Active = False
            Me._ForcePasswordReset = False
            Me._DateCreated = DateTime.Now
            Me._StartTime = DateTime.Now
            Me._StopTime = DateTime.Now
            Me._LunchStartTime = DateTime.Now
            Me._LunchStopTime = DateTime.Now
            Me._InfoID = 0
            Me._DepartmentID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._UserID)
        End Sub

        Public Sub Add(ByVal lngPositionID As Long, ByVal lngCreatedBy As Long, ByVal strUserName As String, ByVal lngPasswordHashSum As Long, ByVal strFirstName As String, ByVal strLastName As String, ByVal lngInfoID As Long, ByVal lngDepartmentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddUser")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngUserID As Long = 0
                cmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = lngPositionID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@UserName", SqlDbType.VarChar, Me.TrimTrunc(strUserName, &H20).Length).Value = Me.TrimTrunc(strUserName, &H20)
                cmd.Parameters.Add("@PasswordHashSum", SqlDbType.BigInt).Value = lngPasswordHashSum
                cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(strFirstName, &H20).Length).Value = Me.TrimTrunc(strFirstName, &H20)
                cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(strLastName, &H40).Length).Value = Me.TrimTrunc(strLastName, &H40)
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = lngInfoID
                cmd.Parameters.Add("@DepartmentID", SqlDbType.Int).Value = lngDepartmentID
                cnn.Open()
                cmd.Connection = cnn
                lngUserID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngUserID > 0) Then
                    Me.Load(lngUserID)
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
            Me._UserID = 0
            Me._PositionID = 0
            Me._PictureID = 0
            Me._CreatedBy = 0
            Me._WebLoginID = 0
            Me._UserName = ""
            Me._PasswordHashSum = 0
            Me._Title = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Suffix = ""
            Me._Email = ""
            Me._Extension = ""
            Me._Signature = ""
            Me._EmploymentStart = New DateTime
            Me._EmploymentEnd = New DateTime
            Me._Active = False
            Me._ForcePasswordReset = False
            Me._DateCreated = DateTime.Now
            Me._StartTime = DateTime.Now
            Me._StopTime = DateTime.Now
            Me._LunchStartTime = DateTime.Now
            Me._LunchStopTime = DateTime.Now
            Me._InfoID = 0
            Me._DepartmentID = 0

        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveUser")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._UserID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New UserRecord(Me._UserID, Me._ConnectionString)
            obj.Load(Me._UserID)
            If (obj.PositionID <> Me._PositionID) Then
                blnReturn = True
            End If
            If (obj.PictureID <> Me._PictureID) Then
                blnReturn = True
            End If
            If (obj.WebLoginID <> Me._WebLoginID) Then
                blnReturn = True
            End If
            If (obj.UserName <> Me._UserName) Then
                blnReturn = True
            End If
            If (obj.PasswordHashSum <> Me._PasswordHashSum) Then
                blnReturn = True
            End If
            If (obj.Title <> Me._Title) Then
                blnReturn = True
            End If
            If (obj.FirstName <> Me._FirstName) Then
                blnReturn = True
            End If
            If (obj.MiddleName <> Me._MiddleName) Then
                blnReturn = True
            End If
            If (obj.LastName <> Me._LastName) Then
                blnReturn = True
            End If
            If (obj.Suffix <> Me._Suffix) Then
                blnReturn = True
            End If
            If (obj.Email <> Me._Email) Then
                blnReturn = True
            End If
            If (obj.Extension <> Me._Extension) Then
                blnReturn = True
            End If
            If (obj.Signature <> Me._Signature) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.EmploymentStart, Me._EmploymentStart) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.EmploymentEnd, Me._EmploymentEnd) <> 0) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            If (obj.ForcePasswordReset <> Me._ForcePasswordReset) Then
                blnReturn = True
            End If
            If obj.StartTime <> _StartTime Then
                blnReturn = True
            End If
            If obj.StopTime <> _StopTime Then
                blnReturn = True
            End If
            If obj.LunchStartTime <> _LunchStartTime Then
                blnReturn = True
            End If
            If obj.LunchStopTime <> _LunchStopTime Then
                blnReturn = True
            End If
            If obj.InfoID <> _InfoID Then
                blnReturn = True
            End If
            If obj.DepartmentID <> _DepartmentID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Private Function LabelText() As String
            Dim strReturn As String = ""
            strReturn = (Me._LastName & ",")
            If (Me._FirstName.Trim.Length > 0) Then
                strReturn = (strReturn & Me._FirstName.Substring(0, 1))
            End If
            Return ((strReturn & ". (") & Me._UserName & ")")
        End Function

        Public Sub Load(ByVal lngUserID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetUser")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = lngUserID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._UserID = Conversions.ToLong(dtr.Item("UserID"))
                    Me._PositionID = Conversions.ToLong(dtr.Item("PositionID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("PictureID"))) Then
                        Me._PictureID = Conversions.ToLong(dtr.Item("PictureID"))
                    Else
                        Me._PictureID = 0
                    End If
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WebLoginID"))) Then
                        Me._WebLoginID = Conversions.ToLong(dtr.Item("WebLoginID"))
                    Else
                        Me._WebLoginID = 0
                    End If
                    Me._UserName = dtr.Item("UserName").ToString
                    Me._PasswordHashSum = Conversions.ToLong(dtr.Item("PasswordHashSum"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Title"))) Then
                        Me._Title = dtr.Item("Title").ToString
                    Else
                        Me._Title = ""
                    End If
                    Me._FirstName = dtr.Item("FirstName").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("MiddleName"))) Then
                        Me._MiddleName = dtr.Item("MiddleName").ToString
                    Else
                        Me._MiddleName = ""
                    End If
                    Me._LastName = dtr.Item("LastName").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Suffix"))) Then
                        Me._Suffix = dtr.Item("Suffix").ToString
                    Else
                        Me._Suffix = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Email"))) Then
                        Me._Email = dtr.Item("Email").ToString
                    Else
                        Me._Email = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Extension"))) Then
                        Me._Extension = dtr.Item("Extension").ToString
                    Else
                        Me._Extension = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Signature"))) Then
                        Me._Signature = dtr.Item("Signature").ToString
                    Else
                        Me._Signature = ""
                    End If
                    Me._EmploymentStart = Conversions.ToDate(dtr.Item("EmploymentStart"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("EmploymentEnd"))) Then
                        Me._EmploymentEnd = Conversions.ToDate(dtr.Item("EmploymentEnd"))
                    Else
                        Me._EmploymentEnd = New DateTime
                    End If
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._ForcePasswordReset = Conversions.ToBoolean(dtr.Item("ForcePasswordReset"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("StartTime"))) Then
                        Me._StartTime = Conversions.ToDate(dtr.Item("StartTime"))
                    Else
                        Me._StartTime = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("StopTime"))) Then
                        Me._StopTime = Conversions.ToDate(dtr.Item("StopTime"))
                    Else
                        Me._StopTime = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("LunchStartTime"))) Then
                        Me._LunchStartTime = Conversions.ToDate(dtr.Item("LunchStartTime"))
                    Else
                        Me._LunchStartTime = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("LunchStopTime"))) Then
                        Me._LunchStopTime = Conversions.ToDate(dtr.Item("LunchStopTime"))
                    Else
                        Me._LunchStopTime = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("InfoID"))) Then
                        _InfoID = Conversions.ToLong(dtr.Item("InfoID"))
                    Else
                        _InfoID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("DepartmentID"))) Then
                        _DepartmentID = Conversions.ToLong(dtr.Item("DepartmentID"))
                    Else
                        _DepartmentID = 0
                    End If
                Else

                    Me.ClearValues()
                End If
                cnn.Close()
            End If
        End Sub

        Public Sub LoadByWebLoginID(ByVal lngWebLoginID As Long)
            Dim lngUserID As Long = -1
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand("spGetUserByWebLoginID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = lngWebLoginID
            cnn.Open
            cmd.Connection = cnn
            Dim dtr As SqlDataReader = cmd.ExecuteReader
            If dtr.Read Then
                lngUserID = Conversions.ToLong(dtr.Item("UserID"))
            End If
            Me.Load(lngUserID)
            cnn.Close
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New UserRecord(Me._UserID, Me._ConnectionString)
                obj.Load(Me._UserID)
                If (obj.PositionID <> Me._PositionID) Then
                    Me.UpdatePositionID(Me._PositionID, (cnn))
                    strTemp = String.Concat(New String() { "PositionID Changed to '", Conversions.ToString(Me._PositionID), "' from '", Conversions.ToString(obj.PositionID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PictureID <> Me._PictureID) Then
                    Me.UpdatePictureID(Me._PictureID, (cnn))
                    strTemp = String.Concat(New String() { "PictureID Changed to '", Conversions.ToString(Me._PictureID), "' from '", Conversions.ToString(obj.PictureID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WebLoginID <> Me._WebLoginID) Then
                    Me.UpdateWebLoginID(Me._WebLoginID, (cnn))
                    strTemp = String.Concat(New String() { "WebLoginID Changed to '", Conversions.ToString(Me._WebLoginID), "' from '", Conversions.ToString(obj.WebLoginID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.UserName <> Me._UserName) Then
                    Me.UpdateUserName(Me._UserName, (cnn))
                    strTemp = String.Concat(New String() { "UserName Changed to '", Me._UserName, "' from '", obj.UserName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PasswordHashSum <> Me._PasswordHashSum) Then
                    Me.UpdatePasswordHashSum(Me._PasswordHashSum, (cnn))
                    strTemp = String.Concat(New String() { "PasswordHashSum Changed to '", Conversions.ToString(Me._PasswordHashSum), "' from '", Conversions.ToString(obj.PasswordHashSum), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Title <> Me._Title) Then
                    Me.UpdateTitle(Me._Title, (cnn))
                    strTemp = String.Concat(New String() { "Title Changed to '", Me._Title, "' from '", obj.Title, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.FirstName <> Me._FirstName) Then
                    Me.UpdateFirstName(Me._FirstName, (cnn))
                    strTemp = String.Concat(New String() { "FirstName Changed to '", Me._FirstName, "' from '", obj.FirstName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MiddleName <> Me._MiddleName) Then
                    Me.UpdateMiddleName(Me._MiddleName, (cnn))
                    strTemp = String.Concat(New String() { "MiddleName Changed to '", Me._MiddleName, "' from '", obj.MiddleName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.LastName <> Me._LastName) Then
                    Me.UpdateLastName(Me._LastName, (cnn))
                    strTemp = String.Concat(New String() { "LastName Changed to '", Me._LastName, "' from '", obj.LastName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Suffix <> Me._Suffix) Then
                    Me.UpdateSuffix(Me._Suffix, (cnn))
                    strTemp = String.Concat(New String() { "Suffix Changed to '", Me._Suffix, "' from '", obj.Suffix, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Email <> Me._Email) Then
                    Me.UpdateEmail(Me._Email, (cnn))
                    strTemp = String.Concat(New String() { "Email Changed to '", Me._Email, "' from '", obj.Email, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Extension <> Me._Extension) Then
                    Me.UpdateExtension(Me._Extension, (cnn))
                    strTemp = String.Concat(New String() { "Extension Changed to '", Me._Extension, "' from '", obj.Extension, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Signature <> Me._Signature) Then
                    Me.UpdateSignature(Me._Signature, (cnn))
                    strTemp = String.Concat(New String() { "Signature Changed to '", Me._Signature, "' from '", obj.Signature, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.EmploymentStart, Me._EmploymentStart) <> 0) Then
                    Me.UpdateEmploymentStart(Me._EmploymentStart, (cnn))
                    strTemp = String.Concat(New String() { "EmploymentStart Changed to '", Conversions.ToString(Me._EmploymentStart), "' from '", Conversions.ToString(obj.EmploymentStart), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.EmploymentEnd, Me._EmploymentEnd) <> 0) Then
                    Me.UpdateEmploymentEnd(Me._EmploymentEnd, (cnn))
                    strTemp = String.Concat(New String() { "EmploymentEnd Changed to '", Conversions.ToString(Me._EmploymentEnd), "' from '", Conversions.ToString(obj.EmploymentEnd), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ForcePasswordReset <> Me._ForcePasswordReset) Then
                    Me.UpdateForcePasswordReset(Me._ForcePasswordReset, (cnn))
                    strTemp = String.Concat(New String() { "ForcePasswordReset Changed to '", Conversions.ToString(Me._ForcePasswordReset), "' from '", Conversions.ToString(obj.ForcePasswordReset), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.StartTime <> Me._StartTime) Then
                    Me.UpdateStartTime(Me._StartTime, (cnn))

                End If
                If obj.StopTime <> _StopTime Then
                    Me.UpdateStopTime(Me._StopTime, (cnn))

                End If
                If obj.LunchStartTime <> _LunchStartTime Then
                    Me.UpdateLunchStartTime(Me._LunchStartTime, (cnn))

                End If
                If obj.LunchStopTime <> _LunchStopTime Then
                    Me.UpdateLunchStopTime(Me._LunchStopTime, (cnn))

                End If
                If obj.InfoID <> _InfoID Then
                    Me.UpdateInfoID(Me._InfoID, (cnn))
                    strTemp = "InfoID Changed to '" & _InfoID & "' from '" & obj.InfoID & "'"
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.DepartmentID <> _DepartmentID Then
                    Me.UpdateDepartmentID(Me._DepartmentID, (cnn))
                    strTemp = "DepartmentID Changed to '" & _DepartmentID & "' from '" & obj.DepartmentID & "'"
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._UserID)
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
            Dim cmd As New SqlCommand("spUpdateUserActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmail(ByVal NewEmail As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserEmail")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            If (NewEmail.Trim.Length > 0) Then
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, Me.TrimTrunc(NewEmail, &HFF).Length).Value = Me.TrimTrunc(NewEmail, &HFF)
            Else
                cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmploymentEnd(ByVal NewEmploymentEnd As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserEmploymentEnd")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewEmploymentEnd, datNothing) <> 0) Then
                cmd.Parameters.Add("@EmploymentEnd", SqlDbType.SmallDateTime).Value = NewEmploymentEnd
            Else
                cmd.Parameters.Add("@EmploymentEnd", SqlDbType.SmallDateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmploymentStart(ByVal NewEmploymentStart As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserEmploymentStart")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            cmd.Parameters.Add("@EmploymentStart", SqlDbType.SmallDateTime).Value = NewEmploymentStart
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateExtension(ByVal NewExtension As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserExtension")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            If (NewExtension.Trim.Length > 0) Then
                cmd.Parameters.Add("@Extension", SqlDbType.VarChar, Me.TrimTrunc(NewExtension, &H10).Length).Value = Me.TrimTrunc(NewExtension, &H10)
            Else
                cmd.Parameters.Add("@Extension", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateFirstName(ByVal NewFirstName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserFirstName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(NewFirstName, &H20).Length).Value = Me.TrimTrunc(NewFirstName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateForcePasswordReset(ByVal NewForcePasswordReset As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserForcePasswordReset")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            cmd.Parameters.Add("@ForcePasswordReset", SqlDbType.Bit).Value = NewForcePasswordReset
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLastName(ByVal NewLastName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserLastName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(NewLastName, &H40).Length).Value = Me.TrimTrunc(NewLastName, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMiddleName(ByVal NewMiddleName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserMiddleName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            If (NewMiddleName.Trim.Length > 0) Then
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar, Me.TrimTrunc(NewMiddleName, &H20).Length).Value = Me.TrimTrunc(NewMiddleName, &H20)
            Else
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePasswordHashSum(ByVal NewPasswordHashSum As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserPasswordHashSum")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            cmd.Parameters.Add("@PasswordHashSum", SqlDbType.BigInt).Value = NewPasswordHashSum
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePictureID(ByVal NewPictureID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserPictureID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            If (NewPictureID > 0) Then
                cmd.Parameters.Add("@PictureID", SqlDbType.Int).Value = NewPictureID
            Else
                cmd.Parameters.Add("@PictureID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePositionID(ByVal NewPositionID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserPositionID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            cmd.Parameters.Add("@PositionID", SqlDbType.Int).Value = NewPositionID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSignature(ByVal NewSignature As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserSignature")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            If (NewSignature.Trim.Length > 0) Then
                cmd.Parameters.Add("@Signature", SqlDbType.Text).Value = NewSignature
            Else
                cmd.Parameters.Add("@Signature", SqlDbType.Text).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSuffix(ByVal NewSuffix As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserSuffix")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            If (NewSuffix.Trim.Length > 0) Then
                cmd.Parameters.Add("@Suffix", SqlDbType.VarChar, Me.TrimTrunc(NewSuffix, 8).Length).Value = Me.TrimTrunc(NewSuffix, 8)
            Else
                cmd.Parameters.Add("@Suffix", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTitle(ByVal NewTitle As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserTitle")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            If (NewTitle.Trim.Length > 0) Then
                cmd.Parameters.Add("@Title", SqlDbType.VarChar, Me.TrimTrunc(NewTitle, &H10).Length).Value = Me.TrimTrunc(NewTitle, &H10)
            Else
                cmd.Parameters.Add("@Title", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateUserName(ByVal NewUserName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserUserName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            cmd.Parameters.Add("@UserName", SqlDbType.VarChar, Me.TrimTrunc(NewUserName, &H20).Length).Value = Me.TrimTrunc(NewUserName, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWebLoginID(ByVal NewWebLoginID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateUserWebLoginID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
            If (NewWebLoginID > 0) Then
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = NewWebLoginID
            Else
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        ''' <summary>
        ''' Updates the StartTime field for this record.
        ''' </summary>
        ''' <param name="NewStartTime">The new value for theStartTime field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateStartTime(ByVal NewStartTime As Date, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateUserStartTime")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@UserID", sqlDBType.int).value = _UserID
            If IsDate(NewStartTime) Then
                cmd.Parameters.Add("@StartTime", SqlDbType.DateTime).Value = NewStartTime
            Else
                cmd.Parameters.Add("@StartTime", SqlDbType.DateTime).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the StopTime field for this record.
        ''' </summary>
        ''' <param name="NewStopTime">The new value for theStopTime field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateStopTime(ByVal NewStopTime As Date, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateUserStopTime")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@UserID", sqlDBType.int).value = _UserID
            If IsDate(NewStopTime) Then
                cmd.Parameters.Add("@StopTime", SqlDbType.DateTime).Value = NewStopTime
            Else
                cmd.Parameters.Add("@StopTime", SqlDbType.DateTime).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the LunchStartTime field for this record.
        ''' </summary>
        ''' <param name="NewLunchStartTime">The new value for theLunchStartTime field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateLunchStartTime(ByVal NewLunchStartTime As Date, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateUserLunchStartTime")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@UserID", sqlDBType.int).value = _UserID
            If IsDate(NewLunchStartTime) Then
                cmd.Parameters.Add("@LunchStartTime", SqlDbType.DateTime).Value = NewLunchStartTime
            Else
                cmd.Parameters.Add("@LunchStartTime", SqlDbType.DateTime).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the LunchStopTime field for this record.
        ''' </summary>
        ''' <param name="NewLunchStopTime">The new value for theLunchStopTime field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateLunchStopTime(ByVal NewLunchStopTime As Date, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateUserLunchStopTime")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@UserID", sqlDBType.int).value = _UserID
            If IsDate(NewLunchStopTime) Then
                cmd.Parameters.Add("@LunchStopTime", SqlDbType.DateTime).Value = NewLunchStopTime
            Else
                cmd.Parameters.Add("@LunchStopTime", SqlDbType.DateTime).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateInfoID(ByVal NewInfoID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateUserInfoID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@UserID", sqlDBType.int).value = _UserID
            If NewInfoID > 0 Then
                cmd.Parameters.Add("@InfoID", SqlDbType.int).value = NewInfoID
            Else
                cmd.Parameters.Add("@InfoID", SqlDbType.int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateDepartmentID(ByVal NewDepartmentID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateUserDepartmentID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = _UserID
            If NewDepartmentID > 0 Then
                cmd.Parameters.Add("@DepartmentID", SqlDbType.Int).Value = NewDepartmentID
            Else
                cmd.Parameters.Add("@DepartmentID", SqlDbType.Int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
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

        Public Property Email As String
            Get
                Return Me._Email
            End Get
            Set(ByVal value As String)
                Me._Email = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property EmploymentEnd As DateTime
            Get
                Return Me._EmploymentEnd
            End Get
            Set(ByVal value As DateTime)
                Me._EmploymentEnd = value
            End Set
        End Property

        Public Property EmploymentStart As DateTime
            Get
                Return Me._EmploymentStart
            End Get
            Set(ByVal value As DateTime)
                Me._EmploymentStart = value
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

        Public Property FirstName As String
            Get
                Return Me._FirstName
            End Get
            Set(ByVal value As String)
                Me._FirstName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property ForcePasswordReset As Boolean
            Get
                Return Me._ForcePasswordReset
            End Get
            Set(ByVal value As Boolean)
                Me._ForcePasswordReset = value
            End Set
        End Property

        Public Property LastName As String
            Get
                Return Me._LastName
            End Get
            Set(ByVal value As String)
                Me._LastName = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property MiddleName As String
            Get
                Return Me._MiddleName
            End Get
            Set(ByVal value As String)
                Me._MiddleName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property NameTag As String
            Get
                Return Me.LabelText
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

        Public Property PictureID As Long
            Get
                Return Me._PictureID
            End Get
            Set(ByVal value As Long)
                Me._PictureID = value
            End Set
        End Property

        Public Property PositionID As Long
            Get
                Return Me._PositionID
            End Get
            Set(ByVal value As Long)
                Me._PositionID = value
            End Set
        End Property

        Public Property Signature As String
            Get
                Return Me._Signature
            End Get
            Set(ByVal value As String)
                Me._Signature = value
            End Set
        End Property

        Public Property Suffix As String
            Get
                Return Me._Suffix
            End Get
            Set(ByVal value As String)
                Me._Suffix = Me.TrimTrunc(value, 8)
            End Set
        End Property

        Public Property Title As String
            Get
                Return Me._Title
            End Get
            Set(ByVal value As String)
                Me._Title = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public ReadOnly Property UserID As Long
            Get
                Return Me._UserID
            End Get
        End Property

        Public Property UserName As String
            Get
                Return Me._UserName
            End Get
            Set(ByVal value As String)
                Me._UserName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property WebLoginID As Long
            Get
                Return Me._WebLoginID
            End Get
            Set(ByVal value As Long)
                Me._WebLoginID = value
            End Set
        End Property
        ''' <summary>
        ''' Returns/Sets the StartTime field for the currently loaded record
        ''' </summary>
        Public Property StartTime() As Date
            Get
                Return _StartTime
            End Get
            Set(ByVal value As Date)
                _StartTime = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the StopTime field for the currently loaded record
        ''' </summary>
        Public Property StopTime() As Date
            Get
                Return _StopTime
            End Get
            Set(ByVal value As Date)
                _StopTime = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the LunchStartTime field for the currently loaded record
        ''' </summary>
        Public Property LunchStartTime() As Date
            Get
                Return _LunchStartTime
            End Get
            Set(ByVal value As Date)
                _LunchStartTime = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the LunchStopTime field for the currently loaded record
        ''' </summary>
        Public Property LunchStopTime() As Date
            Get
                Return _LunchStopTime
            End Get
            Set(ByVal value As Date)
                _LunchStopTime = value
            End Set
        End Property

        Public Property InfoID() As Long
            Get
                Return _InfoID
            End Get
            Set(ByVal value As Long)
                _InfoID = value
            End Set
        End Property
        Public Property DepartmentID() As Long
            Get
                Return _DepartmentID
            End Get
            Set(ByVal value As Long)
                _DepartmentID = value
            End Set
        End Property



        ' Fields
        Private _Active As Boolean
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Email As String
        Private _EmploymentEnd As DateTime
        Private _EmploymentStart As DateTime
        Private _Extension As String
        Private _FirstName As String
        Private _ForcePasswordReset As Boolean
        Private _LastName As String
        Private _MiddleName As String
        Private _PasswordHashSum As Long
        Private _PictureID As Long
        Private _PositionID As Long
        Private _Signature As String
        Private _Suffix As String
        Private _Title As String
        Private _UserID As Long
        Private _UserName As String
        Private _WebLoginID As Long
        Private _StartTime As Date = DateTime.Now
        Private _StopTime As Date = DateTime.Now
        Private _LunchStartTime As Date = DateTime.Now
        Private _LunchStopTime As Date = DateTime.Now
        Private _InfoID As Long = 0
        Private _DepartmentID As Long = 0
        Private Const EmailMaxLength As Integer = &HFF
        Private Const ExtensionMaxLength As Integer = &H10
        Private Const FirstNameMaxLength As Integer = &H20
        Private Const LastNameMaxLength As Integer = &H40
        Private Const MiddleNameMaxLength As Integer = &H20
        Private Const SuffixMaxLength As Integer = 8
        Private Const TitleMaxLength As Integer = &H10
        Private Const UserNameMaxLength As Integer = &H20
    End Class
End Namespace

