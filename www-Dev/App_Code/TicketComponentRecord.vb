Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class TicketComponentRecord
        ' Methods
        Public Sub New()
            Me._TicketComponentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._Consumable = True
            Me._Code = ""
            Me._Component = ""
            Me._SerialNumber = ""
            Me._Notes = ""
            Me._DateDelivered = New DateTime
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._WorkOrderID = 0
            Me._Qty = 0
            Me._PartAmount = 0
            Me._DateOrdered = New DateTime
            Me._Tax = 0
            Me._Shipping = 0
            Me._SuppliedBy = 0
            Me._BillCustomer = True
            Me._BillShipping = True
            Me._BillTaxes = True
            Me._NeedReturned = False
            Me._RMA = ""
            Me._Markup = 0
            Me._CoreCharge = 0
            Me._InvoiceID = 0
            Me._ChargeTechCoreAmount = False
            Me._Paid = 0
            Me._SupplierInvoiceID = 0
            Me.ClearValues()
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._TicketComponentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._Consumable = True
            Me._Code = ""
            Me._Component = ""
            Me._SerialNumber = ""
            Me._Notes = ""
            Me._DateDelivered = New DateTime
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._WorkOrderID = 0
            Me._PartAmount = 0
            Me._Qty = 0
            Me._DateOrdered = New DateTime
            Me._Tax = 0
            Me._Shipping = 0
            Me._SuppliedBy = 0
            Me._BillCustomer = True
            Me._BillShipping = True
            Me._BillTaxes = True
            Me._NeedReturned = False
            Me._RMA = ""
            Me._Markup = 0
            Me._CoreCharge = 0
            Me._InvoiceID = 0
            Me._ChargeTechCoreAmount = False
            Me._Paid = 0
            Me._SupplierInvoiceID = 0
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngTicketComponentID As Long, ByVal strConnectionString As String)
            Me._TicketComponentID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._Consumable = False
            Me._Code = ""
            Me._Component = ""
            Me._SerialNumber = ""
            Me._Notes = ""
            Me._DateDelivered = New DateTime
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._WorkOrderID = 0
            Me._PartAmount = 0
            Me._Qty = 0
            Me._DateOrdered = New DateTime
            Me._Tax = 0
            Me._Shipping = 0
            Me._SuppliedBy = 0
            Me._BillCustomer = True
            Me._BillShipping = True
            Me._BillTaxes = True
            Me._NeedReturned = False
            Me._RMA = ""
            Me._Markup = 0
            Me._CoreCharge = 0
            Me._InvoiceID = 0
            Me._ChargeTechCoreAmount = False
            Me._Paid = 0
            Me._SupplierInvoiceID = 0
            Me._ConnectionString = strConnectionString
            Me.Load(Me._TicketComponentID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngTicketID As Long, ByVal blnConsumable As Boolean, ByVal strComponent As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddTicketComponent")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketComponentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cmd.Parameters.Add("@Consumable", SqlDbType.Bit).Value = blnConsumable
                cmd.Parameters.Add("@Component", SqlDbType.VarChar, Me.TrimTrunc(strComponent, &H80).Length).Value = Me.TrimTrunc(strComponent, &H80)
                cnn.Open()
                cmd.Connection = cnn
                lngTicketComponentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngTicketComponentID > 0) Then
                    Me.Load(lngTicketComponentID)
                End If
            End If
        End Sub
        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngTicketID As Long, ByVal blnConsumable As Boolean, ByVal strComponent As String, ByVal lngQty As Long, ByVal dblPartAmount As Double, ByVal dblTax As Double, ByVal dblShipping As Double, ByVal datDateOrdered As Date, ByVal lngSuppliedBy As Long, ByVal strSerialNumber As String, ByVal blnBillCustomer As Boolean, ByVal blnBillShipping As Boolean, ByVal blnBillTaxes As Boolean, ByVal blnNeedReturned As Boolean, ByVal dblMarkup As Double, ByVal dblCoreCharge As Double, ByVal blnChargeTechCoreAmount As Boolean)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddTicketComponentAll")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketComponentID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cmd.Parameters.Add("@Consumable", SqlDbType.Bit).Value = blnConsumable
                cmd.Parameters.Add("@Component", SqlDbType.VarChar, Me.TrimTrunc(strComponent, &H80).Length).Value = Me.TrimTrunc(strComponent, &H80)
                cmd.Parameters.Add("@Qty", SqlDbType.Int).Value = lngQty
                cmd.Parameters.Add("@PartAmount", SqlDbType.SmallMoney).Value = dblPartAmount
                cmd.Parameters.Add("@Tax", SqlDbType.SmallMoney).Value = dblTax
                cmd.Parameters.Add("@Shipping", SqlDbType.SmallMoney).Value = dblShipping
                cmd.Parameters.Add("@SuppliedBy", SqlDbType.Int).Value = lngSuppliedBy
                cmd.Parameters.Add("@SerialNumber", SqlDbType.VarChar, Me.TrimTrunc(strSerialNumber, &H80).Length).Value = Me.TrimTrunc(strSerialNumber, &H80)
                cmd.Parameters.Add("@BillCustomer", SqlDbType.Bit).Value = blnBillCustomer
                cmd.Parameters.Add("@BillShipping", SqlDbType.Bit).Value = blnBillShipping
                cmd.Parameters.Add("@BillTaxes", SqlDbType.Bit).Value = blnBillTaxes
                cmd.Parameters.Add("@NeedReturned", SqlDbType.Bit).Value = blnNeedReturned
                cmd.Parameters.Add("@Markup", SqlDbType.Bit).Value = dblMarkup
                cmd.Parameters.Add("@CoreCharge", SqlDbType.SmallMoney).Value = dblCoreCharge
                cmd.Parameters.Add("@ChargeTechCoreAmount", SqlDbType.Bit).Value = blnChargeTechCoreAmount
                cnn.Open()
                cmd.Connection = cnn
                lngTicketComponentID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngTicketComponentID > 0) Then
                    Me.Load(lngTicketComponentID)
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
            Me._TicketComponentID = 0
            Me._WorkOrderID = 0
            Me._CreatedBy = 0
            Me._TicketID = 0
            Me._Consumable = False
            Me._Code = ""
            Me._Component = ""
            Me._SerialNumber = ""
            Me._Notes = ""
            Me._DateDelivered = New DateTime
            Me._DateCreated = DateTime.Now
            Me._DateOrdered = New DateTime
            Me._PartAmount = 0
            Me._Tax = 0
            Me._Shipping = 0
            Me._SuppliedBy = 0
            Me._BillCustomer = False
            Me._BillShipping = False
            Me._BillTaxes = False
            Me._NeedReturned = False
            Me._RMA = ""
            Me._Markup = 0
            Me._CoreCharge = 0
            Me._InvoiceID = 0
            Me._ChargeTechCoreAmount = False
            Me._Paid = 0
            Me._SupplierInvoiceID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveTicketComponent")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Me.Load(Me._TicketComponentID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New TicketComponentRecord(Me._TicketComponentID, Me._ConnectionString)
            obj.Load(Me._TicketComponentID)
            If (obj.Consumable <> Me._Consumable) Then
                blnReturn = True
            End If
            If (obj.Code <> Me._Code) Then
                blnReturn = True
            End If
            If (obj.Component <> Me._Component) Then
                blnReturn = True
            End If
            If (obj.SerialNumber <> Me._SerialNumber) Then
                blnReturn = True
            End If
            If (obj.Notes <> Me._Notes) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DateDelivered, Me._DateDelivered) <> 0) Then
                blnReturn = True
            End If
            If (obj.WorkOrderID <> Me._WorkOrderID) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DateCreated, Me._DateCreated) <> 0) Then
                blnReturn = True
            End If
            If (DateTime.Compare(obj.DateOrdered, Me._DateOrdered) <> 0) Then
                blnReturn = True
            End If
            If (obj.Qty <> Me._Qty) Then
                blnReturn = True
            End If
            If (obj.SuppliedBy <> Me._SuppliedBy) Then
                blnReturn = True
            End If
            If (obj.PartAmount <> Me._PartAmount) Then
                blnReturn = True
            End If
            If (obj.Tax <> Me._Tax) Then
                blnReturn = True
            End If
            If (obj.Shipping <> Me._Shipping) Then
                blnReturn = True
            End If
            If (obj.BillCustomer <> Me._BillCustomer) Then
                blnReturn = True
            End If
            If (obj.BillShipping <> Me._BillShipping) Then
                blnReturn = True
            End If
            If (obj.BillTaxes <> Me._BillTaxes) Then
                blnReturn = True
            End If
            If (obj.NeedReturned <> Me._NeedReturned) Then
                blnReturn = True
            End If
            If (obj.RMA <> Me._RMA) Then
                blnReturn = True
            End If
            If (obj.MarkUp <> Me._Markup) Then
                blnReturn = True
            End If
            If obj.CoreCharge <> _CoreCharge Then
                blnReturn = True
            End If
            If obj.InvoiceID <> _InvoiceID Then
                blnReturn = True
            End If
            If obj.ChargeTechCoreAmount <> _ChargeTechCoreAmount Then
                blnReturn = True
            End If
            If (obj.Paid <> Me._Paid) Then
                blnReturn = True
            End If
            If obj.SupplierInvoiceID <> _SupplierInvoiceID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngTicketComponentID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetTicketComponent")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = lngTicketComponentID
                cnn.Open()
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then

                    Me._TicketComponentID = Conversions.ToLong(dtr.Item("TicketComponentID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._TicketID = Conversions.ToLong(dtr.Item("TicketID"))
                    Me._Consumable = Conversions.ToBoolean(dtr.Item("Consumable"))
                    If Not DBNull.Value.Equals(dtr.Item("BillCustomer")) Then
                        Me._BillCustomer = Conversions.ToBoolean(dtr.Item("BillCustomer"))
                    End If
                    If Not DBNull.Value.Equals(dtr.Item("BillShipping")) Then
                        Me._BillShipping = Conversions.ToBoolean(dtr.Item("BillShipping"))
                    End If
                    If Not DBNull.Value.Equals(dtr.Item("BillTaxes")) Then
                        Me._BillTaxes = Conversions.ToBoolean(dtr.Item("BillTaxes"))
                    End If
                    If Not DBNull.Value.Equals(dtr.Item("NeedReturned")) Then
                        Me._NeedReturned = Conversions.ToBoolean(dtr.Item("NeedReturned"))
                    End If
                    If Not DBNull.Value.Equals(dtr.Item("Qty")) Then
                        Me._Qty = Conversions.ToInteger(dtr.Item("Qty"))
                    End If
                    If Not DBNull.Value.Equals(dtr.Item("SuppliedBy")) Then
                        Me._SuppliedBy = Conversions.ToInteger(dtr.Item("SuppliedBy"))
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Code"))) Then
                        Me._Code = dtr.Item("Code").ToString
                    Else
                        Me._Code = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("MarkUp"))) Then
                        Me._Markup = dtr.Item("MarkUp").ToString
                    Else
                        Me._Markup = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("RMA"))) Then
                        Me._RMA = dtr.Item("RMA").ToString
                    Else
                        Me._RMA = ""
                    End If
                    Me._Component = dtr.Item("Component").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("SerialNumber"))) Then
                        Me._SerialNumber = dtr.Item("SerialNumber").ToString
                    Else
                        Me._SerialNumber = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Notes"))) Then
                        Me._Notes = dtr.Item("Notes").ToString
                    Else
                        Me._Notes = ""
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("DateDelivered"))) Then
                        Me._DateDelivered = Conversions.ToDate(dtr.Item("DateDelivered"))
                    Else
                        Me._DateDelivered = New DateTime
                    End If
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("WorkOrderID"))) Then
                        Me._WorkOrderID = Conversions.ToLong(dtr.Item("WorkOrderID"))
                    Else
                        Me._WorkOrderID = 0
                    End If
                    
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("DateOrdered"))) Then
                        Me._DateOrdered = Conversions.ToDate(dtr.Item("DateOrdered"))
                    Else
                        Me._DateOrdered = New DateTime
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("PartAmount"))) Then
                        Me._PartAmount = Conversions.ToDouble(dtr.Item("PartAmount"))
                    Else
                        Me._PartAmount = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Tax"))) Then
                        Me._Tax = Conversions.ToDouble(dtr.Item("Tax"))
                    Else
                        Me._Tax = 0
                    End If
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Shipping"))) Then
                        Me._Shipping = Conversions.ToDouble(dtr.Item("Shipping"))
                    Else
                        Me._Shipping = 0
                    End If
                    _CoreCharge = CType(dtr("CoreCharge"), Double)

                    If Not IsDBNull(dtr("InvoiceID")) Then
                        _InvoiceID = CType(dtr("InvoiceID"), Long)
                    Else
                        _InvoiceID = 0
                    End If

                    _ChargeTechCoreAmount = CType(dtr("ChargeTechCoreAmount"), Boolean)

                    If Not DBNull.Value.Equals(dtr.Item("Paid")) Then
                        Me._Paid = Conversions.ToBoolean(dtr.Item("Paid"))
                    End If

                    If Not IsDBNull(dtr("SupplierInvoiceID")) Then
                        _SupplierInvoiceID = CType(dtr("SupplierInvoiceID"), Long)
                    Else
                        _SupplierInvoiceID = 0
                    End If

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
                cnn.Open()
                Dim obj As New TicketComponentRecord(Me._TicketComponentID, Me._ConnectionString)
                obj.Load(Me._TicketComponentID)
                If (obj.Consumable <> Me._Consumable) Then
                    Me.UpdateConsumable(Me._Consumable, (cnn))
                    strTemp = String.Concat(New String() {"Consumable Changed to '", Conversions.ToString(Me._Consumable), "' from '", Conversions.ToString(obj.Consumable), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Qty <> Me._Qty) Then
                    Me.UpdateQty(Me._Qty, (cnn))
                    strTemp = String.Concat(New String() {"Qty Changed to '", Me._Qty, "' from '", obj.Qty, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SuppliedBy <> Me._SuppliedBy) Then
                    Me.UpdateSuppliedBy(Me._SuppliedBy, (cnn))
                    strTemp = String.Concat(New String() {"SuppliedBy Changed to '", Me._SuppliedBy, "' from '", obj.SuppliedBy, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Code <> Me._Code) Then
                    Me.UpdateCode(Me._Code, (cnn))
                    strTemp = String.Concat(New String() {"Code Changed to '", Me._Code, "' from '", obj.Code, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Component <> Me._Component) Then
                    Me.UpdateComponent(Me._Component, (cnn))
                    strTemp = String.Concat(New String() {"Component Changed to '", Me._Component, "' from '", obj.Component, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WorkOrderID <> Me._WorkOrderID) Then
                    Me.UpdateWorkOrderID(Me._WorkOrderID, (cnn))
                    strTemp = String.Concat(New String() {"WorkOrderID Changed to '", Conversions.ToString(Me._WorkOrderID), "' from '", Conversions.ToString(obj.WorkOrderID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SerialNumber <> Me._SerialNumber) Then
                    Me.UpdateSerialNumber(Me._SerialNumber, (cnn))
                    strTemp = String.Concat(New String() {"SerialNumber Changed to '", Me._SerialNumber, "' from '", obj.SerialNumber, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Notes <> Me._Notes) Then
                    Me.UpdateNotes(Me._Notes, (cnn))
                    strTemp = String.Concat(New String() {"Notes Changed to '", Me._Notes, "' from '", obj.Notes, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.DateDelivered, Me._DateDelivered) <> 0) Then
                    Me.UpdateDateDelivered((Me._DateDelivered), (cnn))
                    strTemp = String.Concat(New String() {"DateDelivered Changed to '", Conversions.ToString(Me._DateDelivered), "' from '", Conversions.ToString(obj.DateDelivered), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(obj.DateOrdered, Me._DateOrdered) <> 0) Then
                    Me.UpdateDateOrdered((Me._DateOrdered), (cnn))
                    strTemp = String.Concat(New String() {"DateOrdered Changed to '", Conversions.ToString(Me._DateOrdered), "' from '", Conversions.ToString(obj.DateOrdered), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartAmount <> Me._PartAmount) Then
                    Me.UpdatePartAmount((Me._PartAmount), (cnn))
                    strTemp = String.Concat(New String() {"PartAmount Changed to '", Conversions.ToString(Me._PartAmount), "' from '", Conversions.ToString(obj.PartAmount), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Tax <> Me._Tax) Then
                    Me.UpdateTax((Me._Tax), (cnn))
                    strTemp = String.Concat(New String() {"Tax Changed to '", Conversions.ToString(Me._Tax), "' from '", Conversions.ToString(obj.Tax), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Shipping <> Me._Shipping) Then
                    Me.UpdateShipping((Me._Shipping), (cnn))
                    strTemp = String.Concat(New String() {"Shipping Changed to '", Conversions.ToString(Me._Shipping), "' from '", Conversions.ToString(obj.Shipping), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BillCustomer <> Me._BillCustomer) Then
                    Me.UpdateBillCustomer(Me._BillCustomer, (cnn))
                    strTemp = String.Concat(New String() {"BillCustomer Changed to '", Conversions.ToString(Me._BillCustomer), "' from '", Conversions.ToString(obj.BillCustomer), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BillShipping <> Me._BillShipping) Then
                    Me.UpdateBillShipping(Me._BillShipping, (cnn))
                    strTemp = String.Concat(New String() {"BillShipping Changed to '", Conversions.ToString(Me._BillShipping), "' from '", Conversions.ToString(obj.BillShipping), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BillTaxes <> Me._BillTaxes) Then
                    Me.UpdateBillTaxes(Me._BillTaxes, (cnn))
                    strTemp = String.Concat(New String() {"BillTaxes Changed to '", Conversions.ToString(Me._BillTaxes), "' from '", Conversions.ToString(obj.BillTaxes), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.NeedReturned <> Me._NeedReturned) Then
                    Me.UpdateNeedReturned(Me._NeedReturned, (cnn))
                    strTemp = String.Concat(New String() {"NeedReturned Changed to '", Conversions.ToString(Me._NeedReturned), "' from '", Conversions.ToString(obj.NeedReturned), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.RMA <> Me._RMA) Then
                    Me.UpdateRMA(Me._RMA, (cnn))
                    strTemp = String.Concat(New String() {"RMA Changed to '", Conversions.ToString(Me._RMA), "' from '", obj.RMA, "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MarkUp <> Me._Markup) Then
                    Me.UpdateMarkUp(Me._Markup, (cnn))
                    strTemp = String.Concat(New String() {"MarkUP Changed to '", Conversions.ToString(Me._Markup), "' from '", Conversions.ToString(obj.MarkUp), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.CoreCharge <> _CoreCharge Then
                    Me.UpdateCoreCharge(_CoreCharge, cnn)
                    strTemp = "CoreCharge Changed to '" & _CoreCharge & "' from '" & obj.CoreCharge & "'"
                    Me.AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.InvoiceID <> _InvoiceID Then
                    Me.UpdateInvoiceID(_InvoiceID, cnn)
                    strTemp = "InvoiceID Changed to '" & _InvoiceID & "' from '" & obj.InvoiceID & "'"
                    Me.AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ChargeTechCoreAmount <> _ChargeTechCoreAmount Then
                    Me.UpdateChargeTechCoreAmount(_ChargeTechCoreAmount, cnn)
                    strTemp = "ChargeTechCoreAmount Changed to '" & _ChargeTechCoreAmount & "' from '" & obj.ChargeTechCoreAmount & "'"
                    Me.AppendChangeLog(strChangeLog, strTemp)
                End If
                If (obj.Paid <> Me._Paid) Then
                    Me.UpdatePaid(Me._Paid, (cnn))
                    strTemp = String.Concat(New String() {"Paid Changed to '", Conversions.ToString(Me._Paid), "' from '", Conversions.ToString(obj.Paid), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.SupplierInvoiceID <> _SupplierInvoiceID Then
                    Me.UpdateSupplierInvoiceID(_SupplierInvoiceID, cnn)
                    strTemp = "SupplierInvoiceID Changed to '" & _SupplierInvoiceID & "' from '" & obj.SupplierInvoiceID & "'"
                    Me.AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Me.Load(Me._TicketComponentID)
            Else
                Me.ClearValues()
            End If
        End Sub

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function

        Private Sub UpdateQty(ByVal NewQty As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentQty")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If (NewQty.ToString.Trim.Length > 0) Then
                cmd.Parameters.Add("@Qty", SqlDbType.Int, NewQty).Value = NewQty
            Else
                cmd.Parameters.Add("@Qty", SqlDbType.Int).Value = 1
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateSuppliedBy(ByVal NewSupplieBy As Integer, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentSuppliedBy")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If (NewSupplieBy.ToString.Trim.Length > 0) Then
                cmd.Parameters.Add("@SuppliedBy", SqlDbType.Int, NewSupplieBy).Value = NewSupplieBy
            Else
                cmd.Parameters.Add("@SuppliedBy", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateCode(ByVal NewCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If (NewCode.Trim.Length > 0) Then
                cmd.Parameters.Add("@Code", SqlDbType.VarChar, Me.TrimTrunc(NewCode, &H80).Length).Value = Me.TrimTrunc(NewCode, &H80)
            Else
                cmd.Parameters.Add("@Code", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateComponent(ByVal NewComponent As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentComponent")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            cmd.Parameters.Add("@Component", SqlDbType.VarChar, Me.TrimTrunc(NewComponent, &H80).Length).Value = Me.TrimTrunc(NewComponent, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateConsumable(ByVal NewConsumable As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentConsumable")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            cmd.Parameters.Add("@Consumable", SqlDbType.Bit).Value = NewConsumable
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateDateDelivered(ByRef NewDateDelivered As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentDateDelivered")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            Dim datNothing As New DateTime
            If (DateTime.Compare(NewDateDelivered, datNothing) <> 0) Then
                cmd.Parameters.Add("@DateDelivered", SqlDbType.DateTime).Value = CDate(NewDateDelivered)
            Else
                cmd.Parameters.Add("@DateDelivered", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateNotes(ByVal NewNotes As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentNotes")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If (NewNotes.Trim.Length > 0) Then
                cmd.Parameters.Add("@Notes", SqlDbType.Text).Value = NewNotes
            Else
                cmd.Parameters.Add("@Notes", SqlDbType.Text).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateSerialNumber(ByVal NewSerialNumber As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentSerialNumber")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If (NewSerialNumber.Trim.Length > 0) Then
                cmd.Parameters.Add("@SerialNumber", SqlDbType.VarChar, Me.TrimTrunc(NewSerialNumber, &HFF).Length).Value = Me.TrimTrunc(NewSerialNumber, &HFF)
            Else
                cmd.Parameters.Add("@SerialNumber", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateWorkOrderID(ByVal NewWorkOrderID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentWorkOrderID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If (NewWorkOrderID > 0) Then
                cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = NewWorkOrderID
            Else
                cmd.Parameters.Add("@WorkOrderID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdateDateOrdered(ByVal NewDateOrdered As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentDateOrdered")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If IsDate(NewDateOrdered) Then
                cmd.Parameters.Add("@DateOrdered", SqlDbType.DateTime).Value = NewDateOrdered
            Else
                cmd.Parameters.Add("@DateOrdered", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateTax(ByVal NewTax As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentTax")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If NewTax >= 0 Then
                cmd.Parameters.Add("@Tax", SqlDbType.SmallMoney).Value = NewTax

            Else
                cmd.Parameters.Add("@Tax", SqlDbType.SmallMoney).Value = 0

            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdatePartAmount(ByVal NewPartAmount As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentPartAmount")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If NewPartAmount >= 0 Then
                cmd.Parameters.Add("@PartAmount", SqlDbType.SmallMoney).Value = NewPartAmount

            Else
                cmd.Parameters.Add("@PartAmount", SqlDbType.SmallMoney).Value = 0

            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateShipping(ByVal NewShipping As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketComponentShipping")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If NewShipping >= 0 Then
                cmd.Parameters.Add("@Shipping", SqlDbType.SmallMoney).Value = NewShipping

            Else
                cmd.Parameters.Add("@Shipping", SqlDbType.SmallMoney).Value = 0

            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateBillCustomer(ByVal NewBillCustomer As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketComponentBillCustomer")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            cmd.Parameters.Add("@BillCustomer", SqlDbType.Bit).Value = NewBillCustomer
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateBillShipping(ByVal NewBillShipping As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketComponentBillShipping")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            cmd.Parameters.Add("@BillShipping", SqlDbType.Bit).Value = NewBillShipping
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateBillTaxes(ByVal NewBillTaxes As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketComponentBillTaxes")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            cmd.Parameters.Add("@BillTaxes", SqlDbType.Bit).Value = NewBillTaxes
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateNeedReturned(ByVal NewNeedReturned As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketComponentNeedsReturned")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            cmd.Parameters.Add("@NeedReturned", SqlDbType.Bit).Value = NewNeedReturned
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateRMA(ByVal NewRMA As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketComponentRMA")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If NewRMA.Trim.Length > 0 Then
                cmd.Parameters.Add("@RMA", SqlDbType.NVarChar).Value = NewRMA
            Else
                cmd.Parameters.Add("@RMA", SqlDbType.NVarChar).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateMarkUp(ByVal NewMarkUp As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketComponentMarkUp")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            If NewMarkUp.Trim.Length > 0 Then
                cmd.Parameters.Add("@MarkUp", SqlDbType.NVarChar).Value = NewMarkUp
            Else
                cmd.Parameters.Add("@MarkUp", SqlDbType.NVarChar).Value = "0"
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateCoreCharge(ByVal NewCoreCharge As Double, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketComponentCoreCharge")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketComponentID", sqlDBType.int).value = _TicketComponentID
            cmd.Parameters.Add("@CoreCharge", SqlDbType.smallmoney).value = NewCoreCharge
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the InvoiceID field for this record.
        ''' </summary>
        ''' <param name="NewInvoiceID">The new value for theInvoiceID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateInvoiceID(ByVal NewInvoiceID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketComponentInvoiceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketComponentID", sqlDBType.int).value = _TicketComponentID
            If NewInvoiceID > 0 Then
                cmd.Parameters.Add("@InvoiceID", SqlDbType.int).value = NewInvoiceID
            Else
                cmd.Parameters.Add("@InvoiceID", SqlDbType.int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateSupplierInvoiceID(ByVal NewInvoiceID As Long, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketComponentSupplierInvoiceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = _TicketComponentID
            If NewInvoiceID > 0 Then
                cmd.Parameters.Add("@SupplierInvoiceID", SqlDbType.Int).Value = NewInvoiceID
            Else
                cmd.Parameters.Add("@SupplierInvoiceID", SqlDbType.Int).Value = System.DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ChargeTechCoreAmount field for this record.
        ''' </summary>
        ''' <param name="NewChargeTechCoreAmount">The new value for theChargeTechCoreAmount field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateChargeTechCoreAmount(ByVal NewChargeTechCoreAmount As Boolean, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New sqlClient.sqlCommand("spUpdateTicketComponentChargeTechCoreAmount")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.parameters.Add("@TicketComponentID", sqlDBType.int).value = _TicketComponentID
            cmd.Parameters.Add("@ChargeTechCoreAmount", SqlDbType.bit).value = NewChargeTechCoreAmount
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Private Sub UpdatePaid(ByVal NewPaid As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateTicketComponentPaid")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketComponentID", SqlDbType.Int).Value = Me._TicketComponentID
            cmd.Parameters.Add("@Paid", SqlDbType.Bit).Value = NewPaid
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub


        ' Properties
        Public Property Code() As String
            Get
                Return Me._Code
            End Get
            Set(ByVal value As String)
                Me._Code = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property Component() As String
            Get
                Return Me._Component
            End Get
            Set(ByVal value As String)
                Me._Component = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property ConnectionString() As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

        Public Property Consumable() As Boolean
            Get
                Return Me._Consumable
            End Get
            Set(ByVal value As Boolean)
                Me._Consumable = value
            End Set
        End Property
        Public Property BillCustomer() As Boolean
            Get
                Return Me._BillCustomer
            End Get
            Set(ByVal value As Boolean)
                Me._BillCustomer = value
            End Set
        End Property
        Public Property BillShipping() As Boolean
            Get
                Return Me._BillShipping
            End Get
            Set(ByVal value As Boolean)
                Me._BillShipping = value
            End Set
        End Property
        Public Property BillTaxes() As Boolean
            Get
                Return Me._BillTaxes
            End Get
            Set(ByVal value As Boolean)
                Me._BillTaxes = value
            End Set
        End Property
        Public Property NeedReturned() As Boolean
            Get
                Return Me._NeedReturned
            End Get
            Set(ByVal value As Boolean)
                Me._NeedReturned = value
            End Set
        End Property

        Public ReadOnly Property CreatedBy() As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public ReadOnly Property DateCreated() As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property DateDelivered() As DateTime
            Get
                Return Me._DateDelivered
            End Get
            Set(ByVal value As DateTime)
                Me._DateDelivered = value
            End Set
        End Property

        Public ReadOnly Property Modified() As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property Notes() As String
            Get
                Return Me._Notes
            End Get
            Set(ByVal value As String)
                Me._Notes = value
            End Set
        End Property

        Public Property SerialNumber() As String
            Get
                Return Me._SerialNumber
            End Get
            Set(ByVal value As String)
                Me._SerialNumber = Me.TrimTrunc(value, &HFF)

            End Set
        End Property
        Public Property RMA() As String
            Get
                Return Me._RMA
            End Get
            Set(ByVal value As String)
                Me._RMA = Me.TrimTrunc(value, &HFF)

            End Set
        End Property

        Public ReadOnly Property TicketComponentID() As Long
            Get
                Return Me._TicketComponentID
            End Get
        End Property

        Public ReadOnly Property TicketID() As Long
            Get
                Return Me._TicketID
            End Get
        End Property

        Public Property WorkOrderID() As Long
            Get
                Return Me._WorkOrderID
            End Get
            Set(ByVal value As Long)
                Me._WorkOrderID = value
            End Set
        End Property
        Public Property Qty() As Long
            Get
                Return Me._Qty
            End Get
            Set(ByVal value As Long)
                Me._Qty = value
            End Set
        End Property
        Public Property SuppliedBy() As Long
            Get
                Return Me._SuppliedBy
            End Get
            Set(ByVal value As Long)
                Me._SuppliedBy = value
            End Set
        End Property
        Public Property DateOrdered() As DateTime
            Get
                Return Me._DateOrdered
            End Get
            Set(ByVal value As DateTime)
                Me._DateOrdered = value
            End Set
        End Property
        Public Property PartAmount() As Double
            Get
                Return Me._PartAmount
            End Get
            Set(ByVal value As Double)
                Me._PartAmount = value
            End Set
        End Property
        Public Property Tax() As Double
            Get
                Return Me._Tax
            End Get
            Set(ByVal value As Double)
                Me._Tax = value
            End Set
        End Property
        Public Property Shipping() As Double
            Get
                Return Me._Shipping
            End Get
            Set(ByVal value As Double)
                Me._Shipping = value
            End Set
        End Property
        Public Property MarkUp() As Double
            Get
                Return Me._Markup
            End Get
            Set(ByVal value As Double)
                Me._Markup = value
            End Set
        End Property
        Public Property CoreCharge() As Double
            Get
                Return _CoreCharge
            End Get
            Set(ByVal value As Double)
                _CoreCharge = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the InvoiceID field for the currently loaded record
        ''' </summary>
        Public Property InvoiceID() As Long
            Get
                Return _InvoiceID
            End Get
            Set(ByVal value As Long)
                _InvoiceID = value
            End Set
        End Property
        Public Property SupplierInvoiceID() As Long
            Get
                Return _SupplierInvoiceID
            End Get
            Set(ByVal value As Long)
                _SupplierInvoiceID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ChargeTechCoreAmount field for the currently loaded record
        ''' </summary>
        Public Property ChargeTechCoreAmount() As Boolean
            Get
                Return _ChargeTechCoreAmount
            End Get
            Set(ByVal value As Boolean)
                _ChargeTechCoreAmount = value
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


        ' Fields
        Private _Code As String
        Private _Component As String
        Private _ConnectionString As String
        Private _Consumable As Boolean
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _DateDelivered As DateTime
        Private _Notes As String
        Private _SerialNumber As String
        Private _TicketComponentID As Long
        Private _SuppliedBy As Long
        Private _TicketID As Long
        Private _WorkOrderID As Long
        Private _PartAmount As Double
        Private _Qty As Long
        Private _DateOrdered As DateTime
        Private _Tax As Double
        Private _Shipping As Double
        Private _Markup As Double
        Private _BillCustomer As Boolean
        Private _BillShipping As Boolean
        Private _BillTaxes As Boolean
        Private _NeedReturned As Boolean
        Private _RMA As String
        Private _CoreCharge As Double
        Private _InvoiceID As Long
        Private _ChargeTechCoreAmount As Boolean
        Private _Paid As Boolean
        Private _SupplierInvoiceID As Long
        Private Const CodeMaxLength As Integer = &H80
        Private Const ComponentMaxLength As Integer = &H80
        Private Const SerialNumberMaxLength As Integer = &HFF
    End Class
End Namespace

