Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class CustomerRecord
        ' Methods
        Public Sub New()
            Me._CustomerID = 0
            Me._PictureID = 0
            Me._CreatedBy = 0
            Me._GenderID = 1
            Me._Company = ""
            Me._Title = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Suffix = ""
            Me._Email = ""
            Me._WebSite = ""
            Me._TaxExempt = False
            Me._BirthMonthID = 0
            Me._BirthDay = 0
            Me._BirthYear = 0
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._Ref1Label = ""
            Me._Ref2Label = ""
            Me._Ref3Label = ""
            Me._Ref4Label = ""
            Me._InternalEmail = ""
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CustomerID = 0
            Me._PictureID = 0
            Me._CreatedBy = 0
            Me._GenderID = 1
            Me._Company = ""
            Me._Title = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Suffix = ""
            Me._Email = ""
            Me._WebSite = ""
            Me._TaxExempt = False
            Me._BirthMonthID = 0
            Me._BirthDay = 0
            Me._BirthYear = 0
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._Ref1Label = ""
            Me._Ref2Label = ""
            Me._Ref3Label = ""
            Me._Ref4Label = ""
            Me._InternalEmail = ""
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCustomerID As Long, ByVal strConnectionString As String)
            Me._CustomerID = 0
            Me._PictureID = 0
            Me._CreatedBy = 0
            Me._GenderID = 1
            Me._Company = ""
            Me._Title = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Suffix = ""
            Me._Email = ""
            Me._WebSite = ""
            Me._TaxExempt = False
            Me._BirthMonthID = 0
            Me._BirthDay = 0
            Me._BirthYear = 0
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._Ref1Label = ""
            Me._Ref2Label = ""
            Me._Ref3Label = ""
            Me._Ref4Label = ""
            Me._InternalEmail = ""
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._CustomerID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngInfoID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCustomer")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngCustomerID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = lngInfoID
                cnn.Open()
                cmd.Connection = cnn
                lngCustomerID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngCustomerID > 0) Then
                    Me.Load(lngCustomerID)
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
            Me._InternalEmail = ""
            Me._CustomerID = 0
            Me._PictureID = 0
            Me._CreatedBy = 0
            Me._GenderID = 1
            Me._Company = ""
            Me._Title = ""
            Me._FirstName = ""
            Me._MiddleName = ""
            Me._LastName = ""
            Me._Suffix = ""
            Me._Email = ""
            Me._WebSite = ""
            Me._Ref1Label = ""
            Me._Ref2Label = ""
            Me._Ref3Label = ""
            Me._Ref4Label = ""
            Me._TaxExempt = False
            Me._BirthMonthID = 0
            Me._BirthDay = 0
            Me._BirthYear = 0
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._InfoID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCustomer")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CustomerID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New CustomerRecord(Me._CustomerID, Me._ConnectionString)
            obj.Load(Me._CustomerID)
            If (obj.PictureID <> Me._PictureID) Then
                blnReturn = True
            End If
            If (obj.Ref1Label <> Me._Ref1Label) Then
                blnReturn = True
            End If
            If (obj.Ref2Label <> Me._Ref2Label) Then
                blnReturn = True
            End If
            If (obj.Ref3Label <> Me._Ref3Label) Then
                blnReturn = True
            End If
            If (obj.Ref4Label <> Me._Ref4Label) Then
                blnReturn = True
            End If
            If (obj.GenderID <> Me._GenderID) Then
                blnReturn = True
            End If
            If (obj.Company <> Me._Company) Then
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
            If (obj.WebSite <> Me._WebSite) Then
                blnReturn = True
            End If
            If (obj.TaxExempt <> Me._TaxExempt) Then
                blnReturn = True
            End If
            If (obj.BirthMonthID <> Me._BirthMonthID) Then
                blnReturn = True
            End If
            If (obj.BirthDay <> Me._BirthDay) Then
                blnReturn = True
            End If
            If (obj.BirthYear <> Me._BirthYear) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            If (obj.InternalEmail <> Me._InternalEmail) Then
                blnReturn = True
            End If
            If obj.InfoID <> Me._InfoID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCustomerID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomer")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("PictureID"))) Then
                        Me._PictureID = Conversions.ToLong(dtr.Item("PictureID"))
                    Else
                        Me._PictureID = 0
                    End If
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._GenderID = Conversions.ToInteger(dtr.Item("GenderID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Company"))) Then
                        Me._Company = dtr.Item("Company").ToString
                    Else
                        Me._Company = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Title"))) Then
                        Me._Title = dtr.Item("Title").ToString
                    Else
                        Me._Title = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("FirstName"))) Then
                        Me._FirstName = dtr.Item("FirstName").ToString
                    Else
                        Me._FirstName = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("MiddleName"))) Then
                        Me._MiddleName = dtr.Item("MiddleName").ToString
                    Else
                        Me._MiddleName = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("LastName"))) Then
                        Me._LastName = dtr.Item("LastName").ToString
                    Else
                        Me._LastName = ""
                    End If
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
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WebSite"))) Then
                        Me._WebSite = dtr.Item("WebSite").ToString
                    Else
                        Me._WebSite = ""
                    End If
                    Me._TaxExempt = Conversions.ToBoolean(dtr.Item("TaxExempt"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("BirthMonthID"))) Then
                        Me._BirthMonthID = Conversions.ToInteger(dtr.Item("BirthMonthID"))
                    Else
                        Me._BirthMonthID = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("BirthDay"))) Then
                        Me._BirthDay = Conversions.ToInteger(dtr.Item("BirthDay"))
                    Else
                        Me._BirthDay = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("BirthYear"))) Then
                        Me._BirthYear = Conversions.ToInteger(dtr.Item("BirthYear"))
                    Else
                        Me._BirthYear = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Ref1Label"))) Then
                        Me._Ref1Label = dtr.Item("Ref1Label").ToString
                    Else
                        Me._Ref1Label = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Ref2Label"))) Then
                        Me._Ref2Label = dtr.Item("Ref2Label").ToString
                    Else
                        Me._Ref2Label = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Ref3Label"))) Then
                        Me._Ref3Label = dtr.Item("Ref3Label").ToString
                    Else
                        Me._Ref3Label = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Ref4Label"))) Then
                        Me._Ref4Label = dtr.Item("Ref4Label").ToString
                    Else
                        Me._Ref4Label = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("InternalEmail"))) Then
                        Me._InternalEmail = dtr.Item("InternalEmail").ToString
                    Else
                        Me._InternalEmail = ""
                    End If
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._InfoID = Conversions.ToInteger(dtr.Item("InfoID"))
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
                Dim obj As New CustomerRecord(Me._CustomerID, Me._ConnectionString)
                obj.Load(Me._CustomerID)
                If (obj.PictureID <> Me._PictureID) Then
                    Me.UpdatePictureID(Me._PictureID, (cnn))
                    strTemp = String.Concat(New String() { "PictureID Changed to '", Conversions.ToString(Me._PictureID), "' from '", Conversions.ToString(obj.PictureID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.GenderID <> Me._GenderID) Then
                    Me.UpdateGenderID(Me._GenderID, (cnn))
                    strTemp = String.Concat(New String() { "GenderID Changed to '", Conversions.ToString(Me._GenderID), "' from '", Conversions.ToString(obj.GenderID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Ref1Label <> Me._Ref1Label) Then
                    Me.UpdateRef1Label(Me._Ref1Label, (cnn))
                    strTemp = String.Concat(New String() { "Ref1Label Changed to '", Me._Ref1Label, "' from '", obj.Ref1Label, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Ref2Label <> Me._Ref2Label) Then
                    Me.UpdateRef2Label(Me._Ref2Label, (cnn))
                    strTemp = String.Concat(New String() { "Ref2Label Changed to '", Me._Ref2Label, "' from '", obj.Ref2Label, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Ref3Label <> Me._Ref3Label) Then
                    Me.UpdateRef3Label(Me._Ref3Label, (cnn))
                    strTemp = String.Concat(New String() { "Ref3Label Changed to '", Me._Ref3Label, "' from '", obj.Ref3Label, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Ref4Label <> Me._Ref4Label) Then
                    Me.UpdateRef4Label(Me._Ref4Label, (cnn))
                    strTemp = String.Concat(New String() { "Ref4Label Changed to '", Me._Ref4Label, "' from '", obj.Ref4Label, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Company <> Me._Company) Then
                    Me.UpdateCompany(Me._Company, (cnn))
                    strTemp = String.Concat(New String() { "Company Changed to '", Me._Company, "' from '", obj.Company, "'" })
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
                If (obj.WebSite <> Me._WebSite) Then
                    Me.UpdateWebSite(Me._WebSite, (cnn))
                    strTemp = String.Concat(New String() { "WebSite Changed to '", Me._WebSite, "' from '", obj.WebSite, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TaxExempt <> Me._TaxExempt) Then
                    Me.UpdateTaxExempt(Me._TaxExempt, (cnn))
                    strTemp = String.Concat(New String() { "TaxExempt Changed to '", Conversions.ToString(Me._TaxExempt), "' from '", Conversions.ToString(obj.TaxExempt), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BirthMonthID <> Me._BirthMonthID) Then
                    Me.UpdateBirthMonthID(Me._BirthMonthID, (cnn))
                    strTemp = String.Concat(New String() { "BirthMonthID Changed to '", Conversions.ToString(Me._BirthMonthID), "' from '", Conversions.ToString(obj.BirthMonthID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BirthDay <> Me._BirthDay) Then
                    Me.UpdateBirthDay(Me._BirthDay, (cnn))
                    strTemp = String.Concat(New String() { "BirthDay Changed to '", Conversions.ToString(Me._BirthDay), "' from '", Conversions.ToString(obj.BirthDay), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BirthYear <> Me._BirthYear) Then
                    Me.UpdateBirthYear(Me._BirthYear, (cnn))
                    strTemp = String.Concat(New String() { "BirthYear Changed to '", Conversions.ToString(Me._BirthYear), "' from '", Conversions.ToString(obj.BirthYear), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.InternalEmail <> Me._InternalEmail) Then
                    Me.UpdateInternalEmail(Me._InternalEmail, (cnn))
                    strTemp = String.Concat(New String() { "InternalEmail Changed to '", Me._InternalEmail, "' from '", obj.InternalEmail, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.InfoID <> Me._InfoID Then
                    UpdateInfoID(Me._InfoID, cnn)
                    strTemp = "InfoID Changed to '" & Me._InfoID & "' from '" & obj.InfoID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close
                Me.Load(Me._CustomerID)
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
            Dim cmd As New SqlCommand("spUpdateCustomerActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBirthDay(ByVal NewBirthDay As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerBirthDay")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewBirthDay > 0) Then
                cmd.Parameters.Add("@BirthDay", SqlDbType.TinyInt).Value = NewBirthDay
            Else
                cmd.Parameters.Add("@BirthDay", SqlDbType.TinyInt).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBirthMonthID(ByVal NewBirthMonthID As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerBirthMonthID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewBirthMonthID > 0) Then
                cmd.Parameters.Add("@BirthMonthID", SqlDbType.TinyInt).Value = NewBirthMonthID
            Else
                cmd.Parameters.Add("@BirthMonthID", SqlDbType.TinyInt).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBirthYear(ByVal NewBirthYear As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerBirthYear")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewBirthYear > 0) Then
                cmd.Parameters.Add("@BirthYear", SqlDbType.SmallInt).Value = NewBirthYear
            Else
                cmd.Parameters.Add("@BirthYear", SqlDbType.SmallInt).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCompany(ByVal NewCompany As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerCompany")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewCompany.Trim.Length > 0) Then
                cmd.Parameters.Add("@Company", SqlDbType.VarChar, Me.TrimTrunc(NewCompany, &H80).Length).Value = Me.TrimTrunc(NewCompany, &H80)
            Else
                cmd.Parameters.Add("@Company", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateEmail(ByVal NewEmail As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerEmail")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewEmail.Trim.Length > 0) Then
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, Me.TrimTrunc(NewEmail, &HFF).Length).Value = Me.TrimTrunc(NewEmail, &HFF)
            Else
                cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateFirstName(ByVal NewFirstName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerFirstName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewFirstName.Trim.Length > 0) Then
                cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, Me.TrimTrunc(NewFirstName, &H20).Length).Value = Me.TrimTrunc(NewFirstName, &H20)
            Else
                cmd.Parameters.Add("@FirstName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateGenderID(ByVal NewGenderID As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerGenderID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            cmd.Parameters.Add("@GenderID", SqlDbType.TinyInt).Value = NewGenderID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateInternalEmail(ByVal NewInternalEmail As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerInternalEmail")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewInternalEmail.Trim.Length > 0) Then
                cmd.Parameters.Add("@InternalEmail", SqlDbType.VarChar, Me.TrimTrunc(NewInternalEmail, &HFF).Length).Value = Me.TrimTrunc(NewInternalEmail, &HFF)
            Else
                cmd.Parameters.Add("@InternalEmail", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLastName(ByVal NewLastName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerLastName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewLastName.Trim.Length > 0) Then
                cmd.Parameters.Add("@LastName", SqlDbType.VarChar, Me.TrimTrunc(NewLastName, &H40).Length).Value = Me.TrimTrunc(NewLastName, &H40)
            Else
                cmd.Parameters.Add("@LastName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMiddleName(ByVal NewMiddleName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerMiddleName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewMiddleName.Trim.Length > 0) Then
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar, Me.TrimTrunc(NewMiddleName, &H20).Length).Value = Me.TrimTrunc(NewMiddleName, &H20)
            Else
                cmd.Parameters.Add("@MiddleName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePictureID(ByVal NewPictureID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerPictureID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewPictureID > 0) Then
                cmd.Parameters.Add("@PictureID", SqlDbType.Int).Value = NewPictureID
            Else
                cmd.Parameters.Add("@PictureID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateRef1Label(ByVal NewRef1Label As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerRef1Label")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewRef1Label.Trim.Length > 0) Then
                cmd.Parameters.Add("@Ref1Label", SqlDbType.VarChar, Me.TrimTrunc(NewRef1Label, &H20).Length).Value = Me.TrimTrunc(NewRef1Label, &H20)
            Else
                cmd.Parameters.Add("@Ref1Label", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateRef2Label(ByVal NewRef2Label As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerRef2Label")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewRef2Label.Trim.Length > 0) Then
                cmd.Parameters.Add("@Ref2Label", SqlDbType.VarChar, Me.TrimTrunc(NewRef2Label, &H20).Length).Value = Me.TrimTrunc(NewRef2Label, &H20)
            Else
                cmd.Parameters.Add("@Ref2Label", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateRef3Label(ByVal NewRef3Label As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerRef3Label")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewRef3Label.Trim.Length > 0) Then
                cmd.Parameters.Add("@Ref3Label", SqlDbType.VarChar, Me.TrimTrunc(NewRef3Label, &H20).Length).Value = Me.TrimTrunc(NewRef3Label, &H20)
            Else
                cmd.Parameters.Add("@Ref3Label", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateRef4Label(ByVal NewRef4Label As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerRef4Label")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            cmd.Parameters.Add("@Ref4Label", SqlDbType.VarChar, Me.TrimTrunc(NewRef4Label, &H20).Length).Value = Me.TrimTrunc(NewRef4Label, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSuffix(ByVal NewSuffix As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerSuffix")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewSuffix.Trim.Length > 0) Then
                cmd.Parameters.Add("@Suffix", SqlDbType.VarChar, Me.TrimTrunc(NewSuffix, 8).Length).Value = Me.TrimTrunc(NewSuffix, 8)
            Else
                cmd.Parameters.Add("@Suffix", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTaxExempt(ByVal NewTaxExempt As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerTaxExempt")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            cmd.Parameters.Add("@TaxExempt", SqlDbType.Bit).Value = NewTaxExempt
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTitle(ByVal NewTitle As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerTitle")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewTitle.Trim.Length > 0) Then
                cmd.Parameters.Add("@Title", SqlDbType.VarChar, Me.TrimTrunc(NewTitle, &H10).Length).Value = Me.TrimTrunc(NewTitle, &H10)
            Else
                cmd.Parameters.Add("@Title", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWebSite(ByVal NewWebSite As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerWebSite")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
            If (NewWebSite.Trim.Length > 0) Then
                cmd.Parameters.Add("@WebSite", SqlDbType.VarChar, Me.TrimTrunc(NewWebSite, &HFF).Length).Value = Me.TrimTrunc(NewWebSite, &HFF)
            Else
                cmd.Parameters.Add("@WebSite", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateInfoID(ByVal NewInfoID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateCustomerInfoID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@CustomerID", sqlDBType.int).value = _CustomerID
            cmd.Parameters.Add("@InfoID", SqlDbType.int).value = NewInfoID
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

        Public Property BirthDay As Integer
            Get
                Return Me._BirthDay
            End Get
            Set(ByVal value As Integer)
                Me._BirthDay = value
            End Set
        End Property

        Public Property BirthMonthID As Integer
            Get
                Return Me._BirthMonthID
            End Get
            Set(ByVal value As Integer)
                Me._BirthMonthID = value
            End Set
        End Property

        Public Property BirthYear As Integer
            Get
                Return Me._BirthYear
            End Get
            Set(ByVal value As Integer)
                Me._BirthYear = value
            End Set
        End Property

        Public Property Company As String
            Get
                Return Me._Company
            End Get
            Set(ByVal value As String)
                Me._Company = Me.TrimTrunc(value, &H80)
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

        Public ReadOnly Property CustomerID As Long
            Get
                Return Me._CustomerID
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

        Public Property FirstName As String
            Get
                Return Me._FirstName
            End Get
            Set(ByVal value As String)
                Me._FirstName = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property GenderID As Integer
            Get
                Return Me._GenderID
            End Get
            Set(ByVal value As Integer)
                Me._GenderID = value
            End Set
        End Property

        Public Property InternalEmail As String
            Get
                Return Me._InternalEmail
            End Get
            Set(ByVal value As String)
                Me._InternalEmail = Me.TrimTrunc(value, &HFF)
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

        Public Property PictureID As Long
            Get
                Return Me._PictureID
            End Get
            Set(ByVal value As Long)
                Me._PictureID = value
            End Set
        End Property

        Public Property Ref1Label As String
            Get
                Return Me._Ref1Label
            End Get
            Set(ByVal value As String)
                Me._Ref1Label = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property Ref2Label As String
            Get
                Return Me._Ref2Label
            End Get
            Set(ByVal value As String)
                Me._Ref2Label = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property Ref3Label As String
            Get
                Return Me._Ref3Label
            End Get
            Set(ByVal value As String)
                Me._Ref3Label = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public Property Ref4Label As String
            Get
                Return Me._Ref4Label
            End Get
            Set(ByVal value As String)
                Me._Ref4Label = Me.TrimTrunc(value, &H20)
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

        Public Property TaxExempt As Boolean
            Get
                Return Me._TaxExempt
            End Get
            Set(ByVal value As Boolean)
                Me._TaxExempt = value
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

        Public Property WebSite As String
            Get
                Return Me._WebSite
            End Get
            Set(ByVal value As String)
                Me._WebSite = Me.TrimTrunc(value, &HFF)
            End Set
        End Property

        Public Property InfoID() As Long
            Get
                Return _InfoID
            End Get
            Set(ByVal value As Long)
                Me._InfoID = value
            End Set
        End Property


        ' Fields
        Private _Active As Boolean
        Private _BirthDay As Integer
        Private _BirthMonthID As Integer
        Private _BirthYear As Integer
        Private _Company As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerID As Long
        Private _DateCreated As DateTime
        Private _Email As String
        Private _FirstName As String
        Private _GenderID As Integer
        Private _InternalEmail As String
        Private _LastName As String
        Private _MiddleName As String
        Private _PictureID As Long
        Private _Ref1Label As String
        Private _Ref2Label As String
        Private _Ref3Label As String
        Private _Ref4Label As String
        Private _Suffix As String
        Private _TaxExempt As Boolean
        Private _Title As String
        Private _WebSite As String
        Private _InfoID As Long = 0
        Private Const CompanyMaxLength As Integer = &H80
        Private Const EmailMaxLength As Integer = &HFF
        Private Const FirstNameMaxLength As Integer = &H20
        Private Const InternalEmailMaxLength As Integer = &HFF
        Private Const LastNameMaxLength As Integer = &H40
        Private Const MiddleNameMaxLength As Integer = &H20
        Private Const Ref1LabelMaxLength As Integer = &H20
        Private Const Ref2LabelMaxLength As Integer = &H20
        Private Const Ref3LabelMaxLength As Integer = &H20
        Private Const Ref4LabelMaxLength As Integer = &H20
        Private Const SuffixMaxLength As Integer = 8
        Private Const TitleMaxLength As Integer = &H10
        Private Const WebSiteMaxLength As Integer = &HFF
    End Class
End Namespace

