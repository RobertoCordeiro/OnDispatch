Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class InvoiceRecord
        ' Methods
        Public Sub New()
            Me._InvoiceID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._InternalDescription = ""
            Me._BillName = ""
            Me._BillCompany = ""
            Me._BillStreet = ""
            Me._BillExtended = ""
            Me._BillCity = ""
            Me._BillState = ""
            Me._BillZipCode = ""
            Me._ShipName = ""
            Me._ShipCompany = ""
            Me._ShipStreet = ""
            Me._ShipExtended = ""
            Me._ShipCity = ""
            Me._ShipState = ""
            Me._ShipZipCode = ""
            Me._Total = 0
            Me._DateCreated = New DateTime
            Me._Paid = False
            Me._Notes = ""
            Me._InvoiceNumber = ""
            Me._ConnectionString = ""
            Me._IsVendorPayment = False
            Me._PartnerID = 0
            Me._IsVendorPartInvoice = False
            Me._CustWebInvoice = False
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._InvoiceID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._InternalDescription = ""
            Me._BillName = ""
            Me._BillCompany = ""
            Me._BillStreet = ""
            Me._BillExtended = ""
            Me._BillCity = ""
            Me._BillState = ""
            Me._BillZipCode = ""
            Me._ShipName = ""
            Me._ShipCompany = ""
            Me._ShipStreet = ""
            Me._ShipExtended = ""
            Me._ShipCity = ""
            Me._ShipState = ""
            Me._ShipZipCode = ""
            Me._Total = 0
            Me._DateCreated = New DateTime
            Me._Paid = False
            Me._Notes = ""
            Me._InvoiceNumber = ""
            Me._ConnectionString = ""
            Me._IsVendorPayment = False
            Me._PartnerID = 0
            Me._IsVendorPartInvoice = False
            Me._CustWebInvoice = False
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngInvoiceID As Long, ByVal strConnectionString As String)
            Me._InvoiceID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._InternalDescription = ""
            Me._BillName = ""
            Me._BillCompany = ""
            Me._BillStreet = ""
            Me._BillExtended = ""
            Me._BillCity = ""
            Me._BillState = ""
            Me._BillZipCode = ""
            Me._ShipName = ""
            Me._ShipCompany = ""
            Me._ShipStreet = ""
            Me._ShipExtended = ""
            Me._ShipCity = ""
            Me._ShipState = ""
            Me._ShipZipCode = ""
            Me._Total = 0
            Me._DateCreated = New DateTime
            Me._Paid = False
            Me._Notes = ""
            Me._InvoiceNumber = ""
            Me._ConnectionString = ""
            Me._IsVendorPayment = False
            Me._PartnerID = 0
            Me._IsVendorPartInvoice = False
            Me._CustWebInvoice = False
            Me._ConnectionString = strConnectionString
            Me.Load(lngInvoiceID)
        End Sub

        Public Sub Add(ByVal lngCustomerID As Long, ByVal lngCreatedBy As Long, ByVal strInternalDescription As String)
            Dim lngInvoiceID As Long = 0
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand("spAddInvoice")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
            cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
            If (strInternalDescription.Trim.Length <= &H80) Then
                cmd.Parameters.Add("@InternalDescription", SqlDbType.VarChar, strInternalDescription.Trim.Length).Value = strInternalDescription.Trim
            Else
                cmd.Parameters.Add("@InternalDescription", SqlDbType.VarChar, &H80).Value = strInternalDescription.Substring(0, &H80)
            End If
            cnn.Open
            cmd.Connection = cnn
            lngInvoiceID = Conversions.ToLong(cmd.ExecuteScalar)
            cnn.Close
            If (lngInvoiceID > 0) Then
                Me.Load(lngInvoiceID)
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
            Me._Notes = ""
            Me._InvoiceID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._InternalDescription = ""
            Me._BillName = ""
            Me._BillCompany = ""
            Me._BillStreet = ""
            Me._BillExtended = ""
            Me._BillCity = ""
            Me._BillState = ""
            Me._BillZipCode = ""
            Me._ShipName = ""
            Me._ShipCompany = ""
            Me._ShipStreet = ""
            Me._ShipExtended = ""
            Me._ShipCity = ""
            Me._ShipState = ""
            Me._ShipZipCode = ""
            Me._Total = 0
            Me._DateCreated = New DateTime
            Me._InvoiceNumber = ""
            Me._Paid = False
            Me._IsVendorPayment = False
            Me._PartnerID = 0
            Me._IsVendorPartInvoice = False
            Me._CustWebInvoice = False
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveInvoice")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
                cnn.Open
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._InvoiceID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim inv As New InvoiceRecord(Me._InvoiceID, Me._ConnectionString)
            If (inv.InternalDescription <> Me._InternalDescription) Then
                blnReturn = True
            End If
            If (inv.BillName <> Me._BillName) Then
                blnReturn = True
            End If
            If (inv.BillCompany <> Me._BillCompany) Then
                blnReturn = True
            End If
            If (inv.BillStreet <> Me._BillStreet) Then
                blnReturn = True
            End If
            If (inv.BillExtended <> Me._BillExtended) Then
                blnReturn = True
            End If
            If (inv.BillCity <> Me._BillCity) Then
                blnReturn = True
            End If
            If (inv.BillState <> Me._BillState) Then
                blnReturn = True
            End If
            If (inv.BillZipCode <> Me._BillZipCode) Then
                blnReturn = True
            End If
            If (inv.ShipName <> Me._ShipName) Then
                blnReturn = True
            End If
            If (inv.ShipCompany <> Me._ShipCompany) Then
                blnReturn = True
            End If
            If (inv.ShipStreet <> Me._ShipStreet) Then
                blnReturn = True
            End If
            If (inv.ShipExtended <> Me._ShipExtended) Then
                blnReturn = True
            End If
            If (inv.ShipCity <> Me._ShipCity) Then
                blnReturn = True
            End If
            If (inv.ShipState <> Me._ShipState) Then
                blnReturn = True
            End If
            If (inv.ShipZipCode <> Me._ShipZipCode) Then
                blnReturn = True
            End If
            If (inv.InvoiceNumber <> Me._InvoiceNumber) Then
                blnReturn = True
            End If
            If (inv.IsVendorPayment <> Me._IsVendorPayment) Then
                blnReturn = True
            End If
            If (inv.PartnerID <> Me._PartnerID) Then
                blnReturn = True
            End If
            If inv.IsVendorPartInvoice <> _IsVendorPartInvoice Then
                blnReturn = True
            End If
            If inv.CustWebInvoice <> _CustWebInvoice Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngInvoiceID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetInvoice")
                cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = lngInvoiceID
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._InvoiceID = Conversions.ToLong(dtr.Item("InvoiceID"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._InternalDescription = dtr.Item("InternalDescription").ToString
                    Me._BillName = dtr.Item("BillName").ToString
                    Me._BillCompany = dtr.Item("BillCompany").ToString
                    Me._BillStreet = dtr.Item("BillStreet").ToString
                    Me._BillExtended = dtr.Item("BillExtended").ToString
                    Me._BillCity = dtr.Item("BillCity").ToString
                    Me._BillState = dtr.Item("BillState").ToString
                    Me._BillZipCode = dtr.Item("BilLZipCode").ToString
                    Me._ShipName = dtr.Item("ShipName").ToString
                    Me._ShipCompany = dtr.Item("ShipCompany").ToString
                    Me._ShipStreet = dtr.Item("ShipStreet").ToString
                    Me._ShipExtended = dtr.Item("ShipExtended").ToString
                    Me._ShipCity = dtr.Item("ShipCity").ToString
                    Me._ShipState = dtr.Item("ShipState").ToString
                    Me._ShipZipCode = dtr.Item("ShipZipCode").ToString
                    Me._Total = Conversions.ToDouble(dtr.Item("Total"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._Notes = dtr.Item("Notes").ToString
                    Me._InvoiceNumber = dtr.Item("InvoiceNumber").ToString
                    Me._Paid = Convert.ToBoolean(RuntimeHelpers.GetObjectValue(dtr.Item("Paid")))
                    Me._IsVendorPayment = Convert.ToBoolean(RuntimeHelpers.GetObjectValue(dtr.Item("IsVendorPayment")))
                    Me._PartnerID = Conversions.ToLong(dtr.Item("PartnerID"))
                    Me._IsVendorPartInvoice = Convert.ToBoolean(RuntimeHelpers.GetObjectValue(dtr.Item("IsVendorPartInvoice")))
                    Me._CustWebInvoice = dtr.Item("CustWebInvoice").ToString
                Else
                    Me.ClearValues()
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim inv As New InvoiceRecord(Me._InvoiceID, Me._ConnectionString)
                Dim strTemp As String = ""
                strChangeLog = ""
                cnn.Open
                If (inv.InternalDescription <> Me._InternalDescription) Then
                    Me.UpdateInternalDescription(Me._InternalDescription, (cnn))
                    strTemp = String.Concat(New String() { "Internal Description changed from '", inv.InternalDescription, "' to '", Me._InternalDescription.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.BillName <> Me._BillName) Then
                    Me.UpdateBillName(Me._BillName, (cnn))
                    strTemp = String.Concat(New String() { "Billing name changed from '", inv.BillName, "' to '", Me._BillName.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.BillCompany <> Me._BillCompany) Then
                    Me.UpdateBillCompany(Me._BillCompany, (cnn))
                    strTemp = String.Concat(New String() { "Billing company changed from '", inv.BillCompany, "' to '", Me._BillCompany.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.Notes <> Me._Notes) Then
                    Me.UpdateNotes(Me._Notes, (cnn))
                    strTemp = String.Concat(New String() { "Notes have been changed from '", inv.Notes, "' to '", Me._Notes, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.BillStreet <> Me._BillStreet) Then
                    Me.UpdateBillStreet(Me._BillStreet, (cnn))
                    strTemp = String.Concat(New String() { "Billing street changed from '", inv.BillStreet, "' to '", Me._BillStreet.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.BillExtended <> Me._BillExtended) Then
                    Me.UpdateBillExtended(Me._BillExtended, (cnn))
                    strTemp = String.Concat(New String() { "Billing extended changed from '", inv.BillExtended, "' to '", Me._BillExtended.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.BillCity <> Me._BillCity) Then
                    Me.UpdateBillCity(Me._BillCity, (cnn))
                    strTemp = String.Concat(New String() { "Billing city changed from '", inv.BillCity, "' to '", Me._BillCity.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.BillState <> Me._BillState) Then
                    Me.UpdateBillState(Me._BillState, (cnn))
                    strTemp = String.Concat(New String() { "Billing state changed from '", inv.BillState, " to '", Me._BillState.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.BillZipCode <> Me._BillZipCode) Then
                    Me.UpdateBillZipCode(Me._BillZipCode, (cnn))
                    strTemp = String.Concat(New String() { "Billing zip code changed from '", inv.BillZipCode, " to '", Me._BillZipCode.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.ShipName <> Me._ShipName) Then
                    Me.UpdateShipName(Me._ShipName, (cnn))
                    strTemp = String.Concat(New String() { "Shipping name changed from '", inv.ShipName, "' to '", Me._ShipName.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.ShipCompany <> Me._ShipCompany) Then
                    Me.UpdateShipCompany(Me._ShipCompany, (cnn))
                    strTemp = String.Concat(New String() { "Shipping company changed from '", inv.ShipCompany, "' to '", Me._ShipCompany.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.ShipStreet <> Me._ShipStreet) Then
                    Me.UpdateShipStreet(Me._ShipStreet, (cnn))
                    strTemp = String.Concat(New String() { "Shipping street changed from '", inv.ShipStreet, "' to '", Me._ShipStreet.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.ShipExtended <> Me._ShipExtended) Then
                    Me.UpdateShipExtended(Me._ShipExtended, (cnn))
                    strTemp = String.Concat(New String() { "Shipping extended changed from '", inv.ShipExtended, "' to '", Me._ShipExtended.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.ShipCity <> Me._ShipCity) Then
                    Me.UpdateShipCity(Me._ShipCity, (cnn))
                    strTemp = String.Concat(New String() { "Shipping city changed from '", inv.ShipCity, "' to '", Me._ShipCity.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.ShipState <> Me._ShipState) Then
                    Me.UpdateShipState(Me._ShipState, (cnn))
                    strTemp = String.Concat(New String() { "Shipping state changed from '", inv.ShipState, " to '", Me._ShipState.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.ShipZipCode <> Me._ShipZipCode) Then
                    Me.UpdateShipZipCode(Me._ShipZipCode, (cnn))
                    strTemp = String.Concat(New String() { "Shipping zip code changed from '", inv.ShipZipCode, " to '", Me._ShipZipCode.Trim, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.InvoiceNumber <> Me._InvoiceNumber) Then
                    Me.UpdateInvoiceInvoiceNumber(Me._InvoiceNumber, (cnn))
                    strTemp = String.Concat(New String() {"Invoice Number changed from '", inv.InvoiceNumber, "' to '", Me._InvoiceNumber.Trim, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.IsVendorPayment <> Me._IsVendorPayment) Then
                    Me.UpdateInvoiceIsVendorPayment(Me._IsVendorPayment, (cnn))
                    strTemp = String.Concat(New String() {"IsVendorPayment changed from '", inv.IsVendorPayment, "' to '", Me._IsVendorPayment, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (inv.PartnerID <> Me._PartnerID) Then
                    Me.UpdateInvoicePartnerID(Me._PartnerID, (cnn))
                    strTemp = String.Concat(New String() {"PartnerID changed from '", inv.PartnerID, "' to '", Me._PartnerID, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If inv.IsVendorPartInvoice <> _IsVendorPartInvoice Then
                    UpdateIsVendorPartInvoice(_IsVendorPartInvoice, cnn)
                    strTemp = "IsVendorPartInvoice Changed to '" & _IsVendorPartInvoice & "' from '" & inv.IsVendorPartInvoice & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If inv.CustWebInvoice <> _CustWebInvoice Then
                    UpdateCustWebInvoice(_CustWebInvoice, cnn)
                    strTemp = "CustWebInvoice Changed to '" & _CustWebInvoice & "' from '" & inv.CustWebInvoice & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close
                Me.Load(Me._InvoiceID)
            End If
        End Sub

        Private Sub UpdateBillCity(ByVal NewBillCity As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceBillCity")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewBillCity.Trim.Length > 0) Then
                If (NewBillCity.Trim.Length <= &H80) Then
                    cmd.Parameters.Add("@BillCity", SqlDbType.VarChar, NewBillCity.Trim.Length).Value = NewBillCity.Trim
                Else
                    cmd.Parameters.Add("@BillCity", SqlDbType.VarChar, &H80).Value = NewBillCity.Trim.Substring(0, &H80)
                End If
            Else
                cmd.Parameters.Add("@BillCity", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBillCompany(ByVal NewBillCompany As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceBillCompany")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewBillCompany.Trim.Length > 0) Then
                If (NewBillCompany.Trim.Length <= &H80) Then
                    cmd.Parameters.Add("@BillCompany", SqlDbType.VarChar, NewBillCompany.Trim.Length).Value = NewBillCompany.Trim
                Else
                    cmd.Parameters.Add("@BillCompany", SqlDbType.VarChar, &H80).Value = NewBillCompany.Trim.Substring(0, &H80)
                End If
            Else
                cmd.Parameters.Add("@BillCompany", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBillExtended(ByVal NewBillExtended As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceBillExtended")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewBillExtended.Trim.Length > 0) Then
                If (NewBillExtended.Trim.Length <= &HFF) Then
                    cmd.Parameters.Add("@BillExtended", SqlDbType.VarChar, NewBillExtended.Trim.Length).Value = NewBillExtended.Trim
                Else
                    cmd.Parameters.Add("@BillExtended", SqlDbType.VarChar, &HFF).Value = NewBillExtended.Trim.Substring(0, &HFF)
                End If
            Else
                cmd.Parameters.Add("@BillExtended", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBillName(ByVal NewBillName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceBillName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewBillName.Trim.Length > 0) Then
                If (NewBillName.Trim.Length <= &HC0) Then
                    cmd.Parameters.Add("@BillName", SqlDbType.VarChar, NewBillName.Trim.Length).Value = NewBillName.Trim
                Else
                    cmd.Parameters.Add("@BillName", SqlDbType.VarChar, &HC0).Value = NewBillName.Trim.Substring(0, &HC0)
                End If
            Else
                cmd.Parameters.Add("@BillName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBillState(ByVal NewBillState As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceBillState")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewBillState.Trim.Length > 0) Then
                If (NewBillState.Trim.Length <= &H20) Then
                    cmd.Parameters.Add("@BillState", SqlDbType.Char, 2).Value = NewBillState.Trim
                Else
                    cmd.Parameters.Add("@BillState", SqlDbType.Char, 2).Value = NewBillState.Trim.Substring(0, &H20)
                End If
            Else
                cmd.Parameters.Add("@BillState", SqlDbType.Char).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBillStreet(ByVal NewBillStreet As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceBillStreet")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewBillStreet.Trim.Length > 0) Then
                If (NewBillStreet.Trim.Length <= &HFF) Then
                    cmd.Parameters.Add("@BillStreet", SqlDbType.VarChar, NewBillStreet.Trim.Length).Value = NewBillStreet.Trim
                Else
                    cmd.Parameters.Add("@BillStreet", SqlDbType.VarChar, &HFF).Value = NewBillStreet.Trim.Substring(0, &HFF)
                End If
            Else
                cmd.Parameters.Add("@BillStreet", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBillZipCode(ByVal NewBillZipCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceBillZipCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewBillZipCode.Trim.Length > 0) Then
                If (NewBillZipCode.Trim.Length <= &H10) Then
                    cmd.Parameters.Add("@BillZipCode", SqlDbType.VarChar, NewBillZipCode.Trim.Length).Value = NewBillZipCode.Trim
                Else
                    cmd.Parameters.Add("@BillZipCode", SqlDbType.VarChar, &H10).Value = NewBillZipCode.Trim.Substring(0, &H10)
                End If
            Else
                cmd.Parameters.Add("@BillZipCode", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateInternalDescription(ByVal NewInternalDescription As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceInternalDescription")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewInternalDescription.Trim.Length > 0) Then
                If (NewInternalDescription.Trim.Length <= &H80) Then
                    cmd.Parameters.Add("@InternalDescription", SqlDbType.VarChar, NewInternalDescription.Trim.Length).Value = NewInternalDescription.Trim
                Else
                    cmd.Parameters.Add("@InternalDescription", SqlDbType.VarChar, &H80).Value = NewInternalDescription.Trim.Substring(0, &H80)
                End If
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
            End If
        End Sub

        Private Sub UpdateNotes(ByVal NewNotes As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceNotes")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewNotes.Trim.Length > 0) Then
                cmd.Parameters.Add("@Notes", SqlDbType.Text, NewNotes.Trim.Length).Value = NewNotes.Trim
            Else
                cmd.Parameters.Add("@Notes", SqlDbType.Text).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateShipCity(ByVal NewShipCity As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceShipCity")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewShipCity.Trim.Length > 0) Then
                If (NewShipCity.Trim.Length <= &H80) Then
                    cmd.Parameters.Add("@ShipCity", SqlDbType.VarChar, NewShipCity.Trim.Length).Value = NewShipCity.Trim
                Else
                    cmd.Parameters.Add("@ShipCity", SqlDbType.VarChar, &H80).Value = NewShipCity.Trim.Substring(0, &H80)
                End If
            Else
                cmd.Parameters.Add("@ShipCity", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateShipCompany(ByVal NewShipCompany As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceShipCompany")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewShipCompany.Trim.Length > 0) Then
                If (NewShipCompany.Trim.Length <= &H80) Then
                    cmd.Parameters.Add("@ShipCompany", SqlDbType.VarChar, NewShipCompany.Trim.Length).Value = NewShipCompany.Trim
                Else
                    cmd.Parameters.Add("@ShipCompany", SqlDbType.VarChar, &H80).Value = NewShipCompany.Trim.Substring(0, &H80)
                End If
            Else
                cmd.Parameters.Add("@ShipCompany", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateShipExtended(ByVal NewShipExtended As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceShipExtended")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewShipExtended.Trim.Length > 0) Then
                If (NewShipExtended.Trim.Length <= &HFF) Then
                    cmd.Parameters.Add("@ShipExtended", SqlDbType.VarChar, NewShipExtended.Trim.Length).Value = NewShipExtended.Trim
                Else
                    cmd.Parameters.Add("@ShipExtended", SqlDbType.VarChar, &HFF).Value = NewShipExtended.Trim.Substring(0, &HFF)
                End If
            Else
                cmd.Parameters.Add("@ShipExtended", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateShipName(ByVal NewShipName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceShipName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewShipName.Trim.Length > 0) Then
                If (NewShipName.Trim.Length <= &HC0) Then
                    cmd.Parameters.Add("@ShipName", SqlDbType.VarChar, NewShipName.Trim.Length).Value = NewShipName.Trim
                Else
                    cmd.Parameters.Add("@ShipName", SqlDbType.VarChar, &HC0).Value = NewShipName.Trim.Substring(0, &HC0)
                End If
            Else
                cmd.Parameters.Add("@ShipName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateShipState(ByVal NewShipState As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceShipState")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewShipState.Trim.Length > 0) Then
                If (NewShipState.Trim.Length <= &H20) Then
                    cmd.Parameters.Add("@ShipState", SqlDbType.Char, 2).Value = NewShipState.Trim
                Else
                    cmd.Parameters.Add("@ShipState", SqlDbType.Char, 2).Value = NewShipState.Trim.Substring(0, &H20)
                End If
            Else
                cmd.Parameters.Add("@ShipState", SqlDbType.Char).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateShipStreet(ByVal NewShipStreet As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceShipStreet")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewShipStreet.Trim.Length > 0) Then
                If (NewShipStreet.Trim.Length <= &HFF) Then
                    cmd.Parameters.Add("@ShipStreet", SqlDbType.VarChar, NewShipStreet.Trim.Length).Value = NewShipStreet.Trim
                Else
                    cmd.Parameters.Add("@ShipStreet", SqlDbType.VarChar, &HFF).Value = NewShipStreet.Trim.Substring(0, &HFF)
                End If
            Else
                cmd.Parameters.Add("@ShipStreet", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateShipZipCode(ByVal NewShipZipCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceShipZipCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewShipZipCode.Trim.Length > 0) Then
                If (NewShipZipCode.Trim.Length <= &H10) Then
                    cmd.Parameters.Add("@ShipZipCode", SqlDbType.VarChar, NewShipZipCode.Trim.Length).Value = NewShipZipCode.Trim
                Else
                    cmd.Parameters.Add("@ShipZipCode", SqlDbType.VarChar, &H10).Value = NewShipZipCode.Trim.Substring(0, &H10)
                End If
            Else
                cmd.Parameters.Add("@ShipZipCode", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateInvoiceInvoiceNumber(ByVal NewInvoiceNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceInvoiceNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            If (NewInvoiceNumber.Trim.Length > 0) Then
                If (NewInvoiceNumber.Trim.Length <= &HC0) Then
                    cmd.Parameters.Add("@InvoiceNumber", SqlDbType.VarChar, NewInvoiceNumber.Trim.Length).Value = NewInvoiceNumber.Trim
                Else
                    cmd.Parameters.Add("@InvoiceNumber", SqlDbType.VarChar, &HC0).Value = NewInvoiceNumber.Trim.Substring(0, &HC0)
                End If
            Else
                cmd.Parameters.Add("@InvoiceNumber", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateInvoicePaid(ByVal NewPaid As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoicePaid")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            cmd.Parameters.Add("@Paid", SqlDbType.Bit).Value = NewPaid
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateInvoiceIsVendorPayment(ByVal NewIsVendorPayment As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceIsVendorPayment")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            cmd.Parameters.Add("@IsVendorPayment", SqlDbType.Bit).Value = NewIsVendorPayment
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateInvoicePartnerID(ByVal NewPartnerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoicePartnerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = Me._InvoiceID
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = NewPartnerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateIsVendorPartInvoice(ByVal NewIsVendorPartInvoice As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceIsVendorPartInvoice")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = _InvoiceID
            cmd.Parameters.Add("@IsVendorPartInvoice", SqlDbType.Bit).Value = NewIsVendorPartInvoice
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateCustWebInvoice(ByVal NewCustWebInvoice As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateInvoiceCustWebInvoice")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@InvoiceID", SqlDbType.Int).Value = _InvoiceID
            cmd.Parameters.Add("@CustWebInvoice", SqlDbType.Bit).Value = NewCustWebInvoice
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub



        ' Properties
        Public Property BillCity As String
            Get
                Return Me._BillCity
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H80) Then
                    Me._BillCity = value.Trim
                Else
                    Me._BillCity = value.Trim.Substring(0, &H80)
                End If
            End Set
        End Property

        Public Property BillCompany As String
            Get
                Return Me._BillCompany
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H80) Then
                    Me._BillCompany = value.Trim
                Else
                    Me._BillCompany = value.Trim.Substring(0, &H80)
                End If
            End Set
        End Property

        Public Property BillExtended As String
            Get
                Return Me._BillExtended
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HFF) Then
                    Me._BillExtended = value.Trim
                Else
                    Me._BillExtended = value.Trim.Substring(0, &HFF)
                End If
            End Set
        End Property

        Public Property BillName As String
            Get
                Return Me._BillName
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HC0) Then
                    Me._BillName = value.Trim
                Else
                    Me._BillName = value.Trim.Substring(0, &HC0)
                End If
            End Set
        End Property

        Public Property BillState As String
            Get
                Return Me._BillState
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H20) Then
                    Me._BillState = value.Trim
                Else
                    Me._BillState = value.Trim.Substring(0, &H20)
                End If
            End Set
        End Property

        Public Property BillStreet As String
            Get
                Return Me._BillStreet
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HFF) Then
                    Me._BillStreet = value.Trim
                Else
                    Me._BillStreet = value.Trim.Substring(0, &HFF)
                End If
            End Set
        End Property

        Public Property BillZipCode As String
            Get
                Return Me._BillZipCode
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H10) Then
                    Me._BillZipCode = value.Trim
                Else
                    Me._BillZipCode = value.Trim.Substring(0, &H10)
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

        Public Property InternalDescription As String
            Get
                Return Me._InternalDescription
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H80) Then
                    Me._InternalDescription = value.Trim
                Else
                    Me._InternalDescription = value.Trim.Substring(0, &H80)
                End If
            End Set
        End Property

        Public ReadOnly Property InvoiceID() As Long
            Get
                Return Me._InvoiceID
            End Get
        End Property
        Public Property PartnerID() As Long
            Get
                Return Me._PartnerID
            End Get
            Set(ByVal value As Long)
                Me._PartnerID = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property Notes As String
            Get
                Return Me._Notes
            End Get
            Set(ByVal value As String)
                Me._Notes = value.Trim
            End Set
        End Property

        Public Property InvoiceNumber() As String
            Get
                Return Me._InvoiceNumber
            End Get
            Set(ByVal value As String)
                Me._InvoiceNumber = value.Trim
            End Set
        End Property

        Public Property Paid() As Boolean
            Get
                Return Me._Paid
            End Get
            Set(ByVal value As Boolean)
                Me._Paid = value
            End Set
        End Property
        Public Property IsVendorPayment() As Boolean
            Get
                Return Me._IsVendorPayment
            End Get
            Set(ByVal value As Boolean)
                Me._IsVendorPayment = value
            End Set
        End Property

        Public Property ShipCity As String
            Get
                Return Me._ShipCity
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H80) Then
                    Me._ShipCity = value.Trim
                Else
                    Me._ShipCity = value.Trim.Substring(0, &H80)
                End If
            End Set
        End Property

        Public Property ShipCompany As String
            Get
                Return Me._ShipCompany
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H80) Then
                    Me._ShipCompany = value.Trim
                Else
                    Me._ShipCompany = value.Trim.Substring(0, &H80)
                End If
            End Set
        End Property

        Public Property ShipExtended As String
            Get
                Return Me._ShipExtended
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HFF) Then
                    Me._ShipExtended = value.Trim
                Else
                    Me._ShipExtended = value.Trim.Substring(0, &HFF)
                End If
            End Set
        End Property

        Public Property ShipName As String
            Get
                Return Me._ShipName
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HC0) Then
                    Me._ShipName = value.Trim
                Else
                    Me._ShipName = value.Trim.Substring(0, &HC0)
                End If
            End Set
        End Property

        Public Property ShipState As String
            Get
                Return Me._ShipState
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H20) Then
                    Me._ShipState = value.Trim
                Else
                    Me._ShipState = value.Trim.Substring(0, &H20)
                End If
            End Set
        End Property

        Public Property ShipStreet As String
            Get
                Return Me._ShipStreet
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HFF) Then
                    Me._ShipStreet = value.Trim
                Else
                    Me._ShipStreet = value.Trim.Substring(0, &HFF)
                End If
            End Set
        End Property

        Public Property ShipZipCode As String
            Get
                Return Me._ShipZipCode
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &H10) Then
                    Me._ShipZipCode = value.Trim
                Else
                    Me._ShipZipCode = value.Trim.Substring(0, &H10)
                End If
            End Set
        End Property

        Public ReadOnly Property Total As Double
            Get
                Return Me._Total
            End Get
        End Property

        Public Property IsVendorPartInvoice() As Boolean
            Get
                Return _IsVendorPartInvoice
            End Get
            Set(ByVal value As Boolean)
                _IsVendorPartInvoice = value
            End Set
        End Property

        Public Property CustWebInvoice() As Boolean
            Get
                Return _CustWebInvoice
            End Get
            Set(ByVal value As Boolean)
                _CustWebInvoice = value
            End Set
        End Property


        ' Fields
        Private _BillCity As String
        Private _BillCompany As String
        Private _BillExtended As String
        Private _BillName As String
        Private _BillState As String
        Private _BillStreet As String
        Private _BillZipCode As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerID As Long
        Private _DateCreated As DateTime
        Private _InternalDescription As String
        Private _InvoiceID As Long
        Private _Notes As String
        Private _Paid As Boolean
        Private _ShipCity As String
        Private _ShipCompany As String
        Private _ShipExtended As String
        Private _ShipName As String
        Private _ShipState As String
        Private _ShipStreet As String
        Private _ShipZipCode As String
        Private _InvoiceNumber As String
        Private _Total As Double
        Private _IsVendorPayment As Boolean
        Private _PartnerID As Integer
        Private _IsVendorPartInvoice As Boolean
        Private _CustWebInvoice As Boolean
        Private Const BillCityMaxLength As Integer = &H80
        Private Const BillCompanyMaxLength As Integer = &H80
        Private Const BillExtendedMaxLength As Integer = &HFF
        Private Const BillNameMaxLength As Integer = &HC0
        Private Const BillStateMaxLength As Integer = &H20
        Private Const BillStreetMaxLength As Integer = &HFF
        Private Const BillZipCodeMaxLength As Integer = &H10
        Private Const InternalDescriptionMaxLength As Integer = &H80
        Private Const ShipCityMaxLength As Integer = &H80
        Private Const ShipCompanyMaxLength As Integer = &H80
        Private Const ShipExtendedMaxLength As Integer = &HFF
        Private Const ShipNameMaxLength As Integer = &HC0
        Private Const ShipStateMaxLength As Integer = &H20
        Private Const ShipStreetMaxLength As Integer = &HFF
        Private Const ShipZipCodeMaxLength As Integer = &H10

    End Class
End Namespace

