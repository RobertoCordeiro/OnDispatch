Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class ServiceTypeRecord
        ' Methods
        Public Sub New()
            Me._ServiceTypeID = 0
            Me._CreatedBy = 0
            Me._CustomerID = 0
            Me._ServiceType = ""
            Me._Notes = ""
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._LayerID = 0
            Me._SurveyID = 0
            Me._ApplyPartMarkup = 0.0
            Me._ConnectionString = ""
            Me._Internal = False
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ServiceTypeID = 0
            Me._CreatedBy = 0
            Me._CustomerID = 0
            Me._ServiceType = ""
            Me._Notes = ""
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._LayerID = 0
            Me._SurveyID = 0
            Me._ApplyPartMarkup = 0.0
            Me._Internal = False
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngServiceTypeID As Long, ByVal strConnectionString As String)
            Me._ServiceTypeID = 0
            Me._CreatedBy = 0
            Me._CustomerID = 0
            Me._ServiceType = ""
            Me._Notes = ""
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._LayerID = 0
            Me._SurveyID = 0
            Me._ApplyPartMarkup = 0.0
            Me._Internal = False
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ServiceTypeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngCustomerID As Long, ByVal strServiceType As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddServiceType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngServiceTypeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cmd.Parameters.Add("@ServiceType", SqlDbType.VarChar, Me.TrimTrunc(strServiceType, &H20).Length).Value = Me.TrimTrunc(strServiceType, &H20)
                cnn.Open
                cmd.Connection = cnn
                lngServiceTypeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngServiceTypeID > 0) Then
                    Me.Load(lngServiceTypeID)
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
            Me._ServiceTypeID = 0
            Me._CreatedBy = 0
            Me._CustomerID = 0
            Me._ServiceType = ""
            Me._Notes = ""
            Me._Active = False
            Me._DateCreated = DateTime.Now
            Me._LayerID = 0
            Me._SurveyID = 0
            Me._ApplyPartMarkup = 0.0
            Me._Internal = False
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveServiceType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = Me._ServiceTypeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ServiceTypeID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ServiceTypeRecord(Me._ServiceTypeID, Me._ConnectionString)
            obj.Load(Me._ServiceTypeID)
            If (obj.CustomerID <> Me._CustomerID) Then
                blnReturn = True
            End If
            If (obj.ServiceType <> Me._ServiceType) Then
                blnReturn = True
            End If
            If (obj.Notes <> Me._Notes) Then
                blnReturn = True
            End If
            If (obj.Active <> Me._Active) Then
                blnReturn = True
            End If
            If obj.LayerID <> Me._LayerID Then
                blnReturn = True
            End If
            If obj.SurveyID <> Me._SurveyID Then
                blnReturn = True
            End If
            If obj.ApplyPartMarkup <> _ApplyPartMarkup Then
                blnReturn = True
            End If
            If (obj.Internal <> Me._Internal) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngServiceTypeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetServiceType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = lngServiceTypeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ServiceTypeID = Conversions.ToLong(dtr.Item("ServiceTypeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._ServiceType = dtr.Item("ServiceType").ToString
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Notes"))) Then
                        Me._Notes = dtr.Item("Notes").ToString
                    Else
                        Me._Notes = ""
                    End If
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    Me._Internal = Conversions.ToBoolean(dtr.Item("Internal"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    If Not IsDBNull(dtr.Item("LayerID")) Then
                        Me._LayerID = CType(dtr.Item("LayerID"), Long)
                    End If
                    If Not IsDBNull(dtr.Item("SurveyID")) Then
                        Me._SurveyID = CType(dtr.Item("SurveyID"), Long)
                    End If
                    If Not IsDBNull(dtr.Item("ApplyPartMarkup")) Then
                        Me._ApplyPartMarkup = CType(dtr.Item("ApplyPartMarkup"), Decimal)
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
                cnn.Open
                Dim obj As New ServiceTypeRecord(Me._ServiceTypeID, Me._ConnectionString)
                obj.Load(Me._ServiceTypeID)
                If (obj.CustomerID <> Me._CustomerID) Then
                    Me.UpdateCustomerID(Me._CustomerID, (cnn))
                    strTemp = String.Concat(New String() { "CustomerID Changed to '", Conversions.ToString(Me._CustomerID), "' from '", Conversions.ToString(obj.CustomerID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ServiceType <> Me._ServiceType) Then
                    Me.UpdateServiceType(Me._ServiceType, (cnn))
                    strTemp = String.Concat(New String() { "ServiceType Changed to '", Me._ServiceType, "' from '", obj.ServiceType, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Notes <> Me._Notes) Then
                    Me.UpdateNotes(Me._Notes, (cnn))
                    strTemp = String.Concat(New String() { "Notes Changed to '", Me._Notes, "' from '", obj.Notes, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = String.Concat(New String() { "Active Changed to '", Conversions.ToString(Me._Active), "' from '", Conversions.ToString(obj.Active), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.LayerID <> _LayerID Then
                    UpdateLayerID(_LayerID, cnn)
                    strTemp = String.Concat(New String() {"LayerID Changed to '", Conversions.ToString(Me._LayerID), "' from '", Conversions.ToString(obj.LayerID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.SurveyID <> _SurveyID Then
                    UpdateSurveyID(_SurveyID, cnn)
                    strTemp = String.Concat(New String() {"SurveyID Changed to '", Conversions.ToString(Me._SurveyID), "' from '", Conversions.ToString(obj.SurveyID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If obj.ApplyPartMarkup <> _ApplyPartMarkup Then
                    UpdateApplyPartMarkup(_ApplyPartMarkup, cnn)
                    strTemp = "ApplyPartMarkup Changed to '" & _ApplyPartMarkup & "' from '" & obj.ApplyPartMarkup & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If (obj.Internal <> Me._Internal) Then
                    Me.UpdateInternal(Me._Internal, (cnn))
                    strTemp = String.Concat(New String() {"Internal Changed to '", Conversions.ToString(Me._Internal), "' from '", Conversions.ToString(obj.Internal), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ServiceTypeID)
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
            Dim cmd As New SqlCommand("spUpdateServiceTypeActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = Me._ServiceTypeID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCustomerID(ByVal NewCustomerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceTypeCustomerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = Me._ServiceTypeID
            cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = NewCustomerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateNotes(ByVal NewNotes As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceTypeNotes")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = Me._ServiceTypeID
            If (NewNotes.Trim.Length > 0) Then
                cmd.Parameters.Add("@Notes", SqlDbType.Text).Value = NewNotes
            Else
                cmd.Parameters.Add("@Notes", SqlDbType.Text).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateServiceType(ByVal NewServiceType As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceTypeServiceType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = Me._ServiceTypeID
            cmd.Parameters.Add("@ServiceType", SqlDbType.VarChar, Me.TrimTrunc(NewServiceType, &H20).Length).Value = Me.TrimTrunc(NewServiceType, &H20)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub
        Private Sub UpdateLayerID(ByVal NewLayerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateServiceTypeLayerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = Me._ServiceTypeID
            cmd.Parameters.Add("@LayerID", SqlDbType.Int).Value = NewLayerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateSurveyID(ByVal NewSurveyID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateServiceTypeSurveyID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = Me._ServiceTypeID
            cmd.Parameters.Add("@SurveyID", SqlDbType.Int).Value = NewSurveyID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateApplyPartMarkup(ByVal NewApplyPartMarkup As Decimal, ByRef cnn As SqlClient.SqlConnection)
            Dim cmd As New SqlClient.SqlCommand("spUpdateApplyPartMarkup")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = Me._ServiceTypeID
            cmd.Parameters.Add("@ApplyPartMarkup", SqlDbType.Float).Value = NewApplyPartMarkup
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateInternal(ByVal NewInternal As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateServiceTypeInternal")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ServiceTypeID", SqlDbType.Int).Value = Me._ServiceTypeID
            cmd.Parameters.Add("@Internal", SqlDbType.Bit).Value = NewInternal
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ' Properties
        Public Property LayerID() As Long
            Get
                Return Me._LayerID
            End Get
            Set(ByVal value As Long)
                Me._LayerID = value
            End Set
        End Property
        Public Property SurveyID() As Long
            Get
                Return Me._SurveyID
            End Get
            Set(ByVal value As Long)
                Me._SurveyID = value
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

        Public ReadOnly Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public Property CustomerID As Long
            Get
                Return Me._CustomerID
            End Get
            Set(ByVal value As Long)
                Me._CustomerID = value
            End Set
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

        Public Property Notes As String
            Get
                Return Me._Notes
            End Get
            Set(ByVal value As String)
                Me._Notes = value
            End Set
        End Property

        Public Property ServiceType As String
            Get
                Return Me._ServiceType
            End Get
            Set(ByVal value As String)
                Me._ServiceType = Me.TrimTrunc(value, &H20)
            End Set
        End Property

        Public ReadOnly Property ServiceTypeID As Long
            Get
                Return Me._ServiceTypeID
            End Get
        End Property
        Public Property ApplyPartMarkup() As Decimal
            Get
                Return _ApplyPartMarkup
            End Get
            Set(ByVal value As Decimal)
                Me._ApplyPartMarkup = value
            End Set
        End Property
        Public Property Internal() As Boolean
            Get
                Return Me._Internal
            End Get
            Set(ByVal value As Boolean)
                Me._Internal = value
            End Set
        End Property


        ' Fields
        Private _Active As Boolean
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerID As Long
        Private _DateCreated As DateTime
        Private _Notes As String
        Private _ServiceType As String
        Private _ServiceTypeID As Long
        Private _LayerID As Long = 0
        Private _SurveyID As Long = 0
        Private _ApplyPartMarkup As Decimal = 0.0
        Private _Internal As Boolean
        Private Const ServiceTypeMaxLength As Integer = &H20
    End Class
End Namespace

