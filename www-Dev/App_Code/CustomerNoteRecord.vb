Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CustomerNoteRecord
        ' Methods
        Public Sub New()
            Me._CustomerNoteID = 0
            Me._CreatedBy = 0
            Me._CustomerID = 0
            Me._NoteBody = ""
            Me._CustomerAccessible = False
            Me._ProviderAccessible = False
            Me._ClientAccessible = False
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CustomerNoteID = 0
            Me._CreatedBy = 0
            Me._CustomerID = 0
            Me._NoteBody = ""
            Me._CustomerAccessible = False
            Me._ProviderAccessible = False
            Me._ClientAccessible = False
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCustomerNoteID As Long, ByVal strConnectionstring As String)
            Me._CustomerNoteID = 0
            Me._CreatedBy = 0
            Me._CustomerID = 0
            Me._NoteBody = ""
            Me._CustomerAccessible = False
            Me._ProviderAccessible = False
            Me._ClientAccessible = False
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionstring
            Me.Load(lngCustomerNoteID)
        End Sub

        Public Sub New(ByVal lngCustomerID As Long, ByVal lngCreatedBy As Long, ByVal strNoteBody As String, ByVal blnCustomerAccessible As Boolean, ByVal blnProviderAccessible As Boolean, ByVal blnClientAccessible As Boolean, ByVal strConnectionString As String)
            Me._CustomerNoteID = 0
            Me._CreatedBy = 0
            Me._CustomerID = 0
            Me._NoteBody = ""
            Me._CustomerAccessible = False
            Me._ProviderAccessible = False
            Me._ClientAccessible = False
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Add(lngCustomerID, lngCreatedBy, strNoteBody, blnCustomerAccessible, blnProviderAccessible, blnClientAccessible)
        End Sub

        Public Sub Add(ByVal lngCustomerID As Long, ByVal lngCreatedBy As Long, ByVal strNoteBody As String, ByVal blnCustomerAccessible As Boolean, ByVal blnProviderAccessible As Boolean, ByVal blnClientAccessible As Boolean)
            Dim lngCustomerNoteID As Long = 0
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCustomerNote")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@NoteBody", SqlDbType.Text, strNoteBody.Length).Value = strNoteBody
                cmd.Parameters.Add("@CustomerAccessible", SqlDbType.Bit).Value = blnCustomerAccessible
                cmd.Parameters.Add("@ProviderAccessible", SqlDbType.Bit).Value = blnProviderAccessible
                cmd.Parameters.Add("@ClientAccessible", SqlDbType.Bit).Value = blnClientAccessible
                cnn.Open
                cmd.Connection = cnn
                lngCustomerNoteID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngCustomerNoteID > 0) Then
                    Me.Load(lngCustomerNoteID)
                Else
                    Me.ClearValues
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
            Me._CustomerNoteID = 0
            Me._CreatedBy = 0
            Me._CustomerID = 0
            Me._NoteBody = ""
            Me._CustomerAccessible = False
            Me._ProviderAccessible = False
            Me._ClientAccessible = False
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCustomerNote")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerNoteID", SqlDbType.Int).Value = Me._CustomerNoteID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CustomerNoteID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean
            Dim cnr As New CustomerNoteRecord(Me._CustomerNoteID, Me._ConnectionString)
            If (cnr.NoteBody <> Me._NoteBody) Then
                blnReturn = True
            End If
            If (cnr.ClientAccessible <> Me._ClientAccessible) Then
                blnReturn = True
            End If
            If (cnr.CustomerAccessible <> Me._CustomerAccessible) Then
                blnReturn = True
            End If
            If (cnr.ProviderAccessible <> Me._ProviderAccessible) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCustomerNoteID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerNote")
                cmd.Parameters.Add("@CustomerNoteID", SqlDbType.Int).Value = lngCustomerNoteID
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CustomerNoteID = Conversions.ToLong(dtr.Item("CustomerNoteID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._NoteBody = dtr.Item("NoteBody").ToString
                    Me._CustomerAccessible = Conversions.ToBoolean(dtr.Item("CustomerAccessible"))
                    Me._ProviderAccessible = Conversions.ToBoolean(dtr.Item("ProviderAccessible"))
                    Me._ClientAccessible = Conversions.ToBoolean(dtr.Item("ClientAccessible"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (((Me._ConnectionString.Trim.Length > 0) AndAlso (Me._CustomerNoteID > 0)) AndAlso Me.HasChanged) Then
                Dim strTemp As String = ""
                Dim cnr As New CustomerNoteRecord(Me._CustomerNoteID, Me._ConnectionString)
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                If (cnr.NoteBody <> Me._NoteBody) Then
                    Me.UpdateNoteBody(Me._NoteBody, (cnn))
                    strTemp = String.Concat(New String() { "Changed the body of the note from '", cnr.NoteBody, "' to '", Me._NoteBody, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cnr.ProviderAccessible <> Me._ProviderAccessible) Then
                    Me.UpdateProviderAccessible(Me._ProviderAccessible, (cnn))
                    strTemp = ("Changed Provider Accessible from " & cnr.ProviderAccessible.ToString & " to " & Me._ProviderAccessible.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cnr.ClientAccessible <> Me._ClientAccessible) Then
                    Me.UpdateClientAccessible(Me._ClientAccessible, (cnn))
                    strTemp = ("Changed Client Accessible from " & cnr.ClientAccessible.ToString & " to " & Me._ClientAccessible.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cnr.CustomerAccessible <> Me._CustomerAccessible) Then
                    Me.UpdateCustomerAccessible(Me._CustomerAccessible, (cnn))
                    strTemp = ("Changed Customer Accessible from " & cnr.CustomerAccessible.ToString & " to " & Me._CustomerAccessible.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
            End If
        End Sub

        Private Sub UpdateClientAccessible(ByVal NewClientAccessible As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerNoteClientAccessible")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerNoteID", SqlDbType.Int).Value = Me._CustomerNoteID
            cmd.Parameters.Add("@ClientAccessible", SqlDbType.Bit).Value = NewClientAccessible
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCustomerAccessible(ByVal NewCustomerAccessible As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerNoteCustomerAccessible")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerNoteID", SqlDbType.Int).Value = Me._CustomerNoteID
            cmd.Parameters.Add("@CustomerAccessible", SqlDbType.Bit).Value = NewCustomerAccessible
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateNoteBody(ByVal NewNoteBody As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerNoteNoteBody")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerNoteID", SqlDbType.Int).Value = Me._CustomerNoteID
            cmd.Parameters.Add("NoteBody", SqlDbType.Text, NewNoteBody.Trim.Length).Value = NewNoteBody.Trim
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateProviderAccessible(ByVal NewProviderAccessible As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerNoteProviderAccessible")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@CustomerNoteID", SqlDbType.Int).Value = Me._CustomerNoteID
            cmd.Parameters.Add("@ProviderAccessible", SqlDbType.Bit).Value = NewProviderAccessible
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property ClientAccessible As Boolean
            Get
                Return Me._ClientAccessible
            End Get
            Set(ByVal value As Boolean)
                Me._ClientAccessible = value
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

        Public Property CustomerAccessible As Boolean
            Get
                Return Me._CustomerAccessible
            End Get
            Set(ByVal value As Boolean)
                Me._CustomerAccessible = value
            End Set
        End Property

        Public ReadOnly Property CustomerID As Long
            Get
                Return Me._CustomerID
            End Get
        End Property

        Public ReadOnly Property CustomerNoteID As Long
            Get
                Return Me._CustomerNoteID
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property NoteBody As String
            Get
                Return Me._NoteBody
            End Get
            Set(ByVal value As String)
                Me._NoteBody = value.Trim
            End Set
        End Property

        Public Property ProviderAccessible As Boolean
            Get
                Return Me._ProviderAccessible
            End Get
            Set(ByVal value As Boolean)
                Me._ProviderAccessible = value
            End Set
        End Property


        ' Fields
        Private _ClientAccessible As Boolean
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerAccessible As Boolean
        Private _CustomerID As Long
        Private _CustomerNoteID As Long
        Private _NoteBody As String
        Private _ProviderAccessible As Boolean
    End Class
End Namespace

