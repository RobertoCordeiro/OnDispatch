Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class CustomerIdentificationRecord
        ' Methods
        Public Sub New()
            Me._CustomerIdentificationID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._IdentificationTypeID = 0
            Me._IdentificationSequence = ""
            Me._Active = False
            Me._Expires = New DateTime
            Me._DateCreated = DateTime.Now
            Me._PictureID = 0
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._CustomerIdentificationID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._IdentificationTypeID = 0
            Me._IdentificationSequence = ""
            Me._Active = False
            Me._Expires = New DateTime
            Me._DateCreated = DateTime.Now
            Me._PictureID = 0
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngCustomerIdentificationID As Long, ByVal strConnectionstring As String)
            Me._CustomerIdentificationID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._IdentificationTypeID = 0
            Me._IdentificationSequence = ""
            Me._Active = False
            Me._Expires = New DateTime
            Me._DateCreated = DateTime.Now
            Me._PictureID = 0
            Me._ConnectionString = strConnectionstring
            Me.Load(lngCustomerIdentificationID)
        End Sub

        Public Sub New(ByVal lngCustomerID As Long, ByVal lngCreatedBy As Long, ByVal lngIdentificationTypeID As Long, ByVal strIdentificationSequence As String, ByVal strConnectionString As String)
            Me._CustomerIdentificationID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._IdentificationTypeID = 0
            Me._IdentificationSequence = ""
            Me._Active = False
            Me._Expires = New DateTime
            Me._DateCreated = DateTime.Now
            Me._PictureID = 0
            Me._ConnectionString = strConnectionString
            Me.Add(lngCustomerID, lngCreatedBy, lngIdentificationTypeID, strIdentificationSequence)
        End Sub

        Public Sub Add(ByVal lngCustomerID As Long, ByVal lngCreatedBy As Long, ByVal lngIdentificationTypeID As Long, ByVal strIdentificationSequence As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCustomerIdentification")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@IdentificationTypeID", SqlDbType.Int).Value = lngIdentificationTypeID
                If (strIdentificationSequence.Trim.Length <= &HFF) Then
                    cmd.Parameters.Add("@IdentificationSequence", SqlDbType.VarChar, strIdentificationSequence.Trim.Length).Value = strIdentificationSequence.Trim
                Else
                    cmd.Parameters.Add("@IdentificationSequence", SqlDbType.VarChar, &HFF).Value = strIdentificationSequence.Trim.Substring(0, &HFF)
                End If
                cnn.Open
                cmd.Connection = cnn
                Me.Load(Conversions.ToLong(cmd.ExecuteScalar))
                cnn.Close
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
            Me._CustomerIdentificationID = 0
            Me._CustomerID = 0
            Me._CreatedBy = 0
            Me._IdentificationTypeID = 0
            Me._IdentificationSequence = ""
            Me._Active = False
            Me._Expires = New DateTime
            Me._DateCreated = DateTime.Now
            Me._PictureID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCustomerIdentification")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerIdentificationID", SqlDbType.Int)
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._CustomerIdentificationID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim cir As New CustomerIdentificationRecord(Me._CustomerIdentificationID, Me._ConnectionString)
            If (cir.IdentificationTypeID <> Me._IdentificationTypeID) Then
                blnReturn = True
            End If
            If (cir.PictureID <> Me._PictureID) Then
                blnReturn = True
            End If
            If (cir.IdentificationSequence <> Me._IdentificationSequence) Then
                blnReturn = True
            End If
            If (cir.Active <> Me._Active) Then
                blnReturn = True
            End If
            If (DateTime.Compare(cir.Expires, Me._Expires) <> 0) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngCustomerIdentificationID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerIdentification")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CustomerIdentificationID", SqlDbType.Int).Value = lngCustomerIdentificationID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._CustomerIdentificationID = Conversions.ToLong(dtr.Item("CustomerIdentificationID"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._IdentificationTypeID = Conversions.ToLong(dtr.Item("IdentificationTypeID"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("PictureID"))) Then
                        Me._PictureID = Conversions.ToLong(dtr.Item("PictureID"))
                    Else
                        Me._PictureID = 0
                    End If
                    Me._IdentificationSequence = dtr.Item("IdentificationSequence").ToString
                    Me._Active = Conversions.ToBoolean(dtr.Item("Active"))
                    If Not Information.IsDBNull(RuntimeHelpers.GetObjectValue(dtr.Item("Expires"))) Then
                        Me._Expires = Conversions.ToDate(dtr.Item("Expires"))
                    Else
                        Me._Expires = New DateTime
                    End If
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cir As New CustomerIdentificationRecord(Me._CustomerIdentificationID, Me._ConnectionString)
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim strTemp As String = ""
                strChangeLog = ""
                cnn.Open
                If (cir.IdentificationTypeID <> Me._IdentificationTypeID) Then
                    Me.UpdateIdentificationTypeID(Me._IdentificationTypeID, (cnn))
                    Dim itr As New IdentificationTypeRecord(cir.IdentificationTypeID, Me._ConnectionString)
                    strTemp = ("Changed Identification Type from '" & itr.IdentificationType & "' to '")
                    itr = New IdentificationTypeRecord(Me._IdentificationTypeID, Me._ConnectionString)
                    strTemp = (strTemp & itr.IdentificationType & "'")
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.PictureID <> Me._PictureID) Then
                    Me.UpdatePictureID(Me._PictureID, (cnn))
                    strTemp = String.Concat(New String() { "Changed picture reference from {", cir.PictureID.ToString, "} to {", Me._PictureID.ToString, "}" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.IdentificationSequence <> Me._IdentificationSequence) Then
                    Me.UpdateIdentificationSequence(Me._IdentificationSequence, (cnn))
                    strTemp = String.Concat(New String() { "Changed identification sequence from '", cir.IdentificationSequence, "' to '", Me._IdentificationSequence, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (cir.Active <> Me._Active) Then
                    Me.UpdateActive(Me._Active, (cnn))
                    strTemp = ("Changed active from " & cir.Active.ToString & " to " & Me._Active.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(cir.Expires, Me._Expires) <> 0) Then
                    Me.UpdateExpires(Me._Expires, (cnn))
                    strTemp = String.Concat(New String() { strTemp, "Changed expires from '", cir.Expires.ToString, "' to '", Me._Expires.ToString, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._CustomerIdentificationID)
            End If
        End Sub

        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerIdentificationActive")
            cmd.Parameters.Add("@CustomerIdentificationID", SqlDbType.Int).Value = Me._CustomerIdentificationID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateExpires(ByVal NewExpires As DateTime, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerIdentification")
            cmd.Parameters.Add("@CustomerIdentificationID", SqlDbType.Int).Value = Me._CustomerIdentificationID
            If (DateTime.Compare(NewExpires, DateTime.MinValue) <> 0) Then
                cmd.Parameters.Add("@Expires", SqlDbType.DateTime).Value = NewExpires
            Else
                cmd.Parameters.Add("@Expires", SqlDbType.DateTime).Value = DBNull.Value
            End If
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateIdentificationSequence(ByVal NewIdentificationSequence As String, ByRef cnn As SqlConnection)
            If (NewIdentificationSequence.Trim.Length > &HFF) Then
                NewIdentificationSequence = NewIdentificationSequence.Trim.Substring(0, &HFF)
            End If
            Dim cmd As New SqlCommand("spUpdateCustomerIdentificationIdentificationSequence")
            cmd.Parameters.Add("@CustomerIdentificationID", SqlDbType.Int).Value = Me._CustomerIdentificationID
            cmd.Parameters.Add("@IdentificationSequence", SqlDbType.VarChar, NewIdentificationSequence.Trim.Length).Value = NewIdentificationSequence.Trim
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateIdentificationTypeID(ByVal NewIdentificationTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerIdentificationIdentificationTypeID")
            cmd.Parameters.Add("@CustomerIdentificationID", SqlDbType.Int).Value = Me._CustomerIdentificationID
            cmd.Parameters.Add("@IdentificationTypeID", SqlDbType.Int).Value = NewIdentificationTypeID
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePictureID(ByVal NewPictureID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateCustomerIdentification")
            cmd.Parameters.Add("@CustomerIdentificationID", SqlDbType.Int).Value = Me._CustomerIdentificationID
            If (NewPictureID > 0) Then
                cmd.Parameters.Add("@PictureID", SqlDbType.Int).Value = NewPictureID
            Else
                cmd.Parameters.Add("@PictureID", SqlDbType.Int).Value = DBNull.Value
            End If
            cmd.CommandType = CommandType.StoredProcedure
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

        Public ReadOnly Property CustomerIdentificationID As Long
            Get
                Return Me._CustomerIdentificationID
            End Get
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property Expires As DateTime
            Get
                Return Me._Expires
            End Get
            Set(ByVal value As DateTime)
                Me._Expires = value
            End Set
        End Property

        Public Property IdentificationSequence As String
            Get
                Return Me._IdentificationSequence
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length <= &HFF) Then
                    Me._IdentificationSequence = value.Trim
                Else
                    Me._IdentificationSequence = value.Trim.Substring(0, &HFF)
                End If
            End Set
        End Property

        Public Property IdentificationTypeID As Long
            Get
                Return Me._IdentificationTypeID
            End Get
            Set(ByVal value As Long)
                Me._IdentificationTypeID = value
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


        ' Fields
        Private _Active As Boolean
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerID As Long
        Private _CustomerIdentificationID As Long
        Private _DateCreated As DateTime
        Private _Expires As DateTime
        Private _IdentificationSequence As String
        Private _IdentificationTypeID As Long
        Private _PictureID As Long
        Private Const IdentificationSequenceMaxLength As Integer = &HFF
    End Class
End Namespace

