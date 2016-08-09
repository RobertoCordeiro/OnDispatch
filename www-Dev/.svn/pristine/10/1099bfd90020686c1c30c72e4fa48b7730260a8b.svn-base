Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class TicketNoteRecord
        ' Methods
        Public Sub New()
            Me._TicketNoteID = 0
            Me._TicketID = 0
            Me._WebLoginID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._PartnerVisible = False
            Me._CustomerVisible = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._Acknowledged = False
            Me._SourceID = Sources.Unknown
            Me._ObjectID = &H2C
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._TicketNoteID = 0
            Me._TicketID = 0
            Me._WebLoginID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._PartnerVisible = False
            Me._CustomerVisible = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._Acknowledged = False
            Me._SourceID = Sources.Unknown
            Me._ObjectID = &H2C
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngTicketNoteID As Long, ByVal strConnectionString As String)
            Me._TicketNoteID = 0
            Me._TicketID = 0
            Me._WebLoginID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._PartnerVisible = False
            Me._CustomerVisible = False
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._Acknowledged = False
            Me._SourceID = Sources.Unknown
            Me._ObjectID = &H2C
            Me._ConnectionString = strConnectionString
            Me.Load(Me._TicketNoteID)
        End Sub

        Public Sub Add(ByVal lngTicketID As Long, ByVal lngWebLoginID As Long, ByVal lngCreatedBy As Long, ByVal strNoteBody As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddTicketNote")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngTicketNoteID As Long = 0
                cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = lngTicketID
                cmd.Parameters.Add("@WebLoginID", SqlDbType.Int).Value = lngWebLoginID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@NoteBody", SqlDbType.Text).Value = strNoteBody
                cnn.Open
                cmd.Connection = cnn
                lngTicketNoteID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngTicketNoteID > 0) Then
                    Me.Load(lngTicketNoteID)
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
            Me._Acknowledged = False
            Me._SourceID = Sources.Unknown
            Me._TicketNoteID = 0
            Me._TicketID = 0
            Me._WebLoginID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._PartnerVisible = False
            Me._CustomerVisible = False
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveTicketNote")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketNoteID", SqlDbType.Int).Value = Me._TicketNoteID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._TicketNoteID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New TicketNoteRecord(Me._TicketNoteID, Me._ConnectionString)
            obj.Load(Me._TicketNoteID)
            If (obj.NoteBody <> Me._NoteBody) Then
                blnReturn = True
            End If
            If (obj.PartnerVisible <> Me._PartnerVisible) Then
                blnReturn = True
            End If
            If (obj.CustomerVisible <> Me._CustomerVisible) Then
                blnReturn = True
            End If
            If (obj.Acknowledged <> Me._Acknowledged) Then
                blnReturn = True
            End If
            If (obj.SourceID <> Me._SourceID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngTicketNoteID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetTicketNote")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@TicketNoteID", SqlDbType.Int).Value = lngTicketNoteID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._TicketNoteID = Conversions.ToLong(dtr.Item("TicketNoteID"))
                    Me._TicketID = Conversions.ToLong(dtr.Item("TicketID"))
                    Me._WebLoginID = Conversions.ToLong(dtr.Item("WebLoginID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._NoteBody = dtr.Item("NoteBody").ToString
                    Me._PartnerVisible = Conversions.ToBoolean(dtr.Item("PartnerVisible"))
                    Me._CustomerVisible = Conversions.ToBoolean(dtr.Item("CustomerVisible"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._Acknowledged = Conversions.ToBoolean(dtr.Item("Acknowledged"))
                    Me._SourceID = DirectCast(Conversions.ToInteger(dtr.Item("SourceID")), Sources)
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
                Dim obj As New TicketNoteRecord(Me._TicketNoteID, Me._ConnectionString)
                obj.Load(Me._TicketNoteID)
                If (obj.NoteBody <> Me._NoteBody) Then
                    Me.UpdateNoteBody(Me._NoteBody, (cnn))
                    strTemp = String.Concat(New String() { "NoteBody Changed to '", Me._NoteBody, "' from '", obj.NoteBody, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerVisible <> Me._PartnerVisible) Then
                    Me.UpdatePartnerVisible(Me._PartnerVisible, (cnn))
                    strTemp = String.Concat(New String() { "PartnerVisible Changed to '", Conversions.ToString(Me._PartnerVisible), "' from '", Conversions.ToString(obj.PartnerVisible), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CustomerVisible <> Me._CustomerVisible) Then
                    Me.UpdateCustomerVisible(Me._CustomerVisible, (cnn))
                    strTemp = String.Concat(New String() { "CustomerVisible Changed to '", Conversions.ToString(Me._CustomerVisible), "' from '", Conversions.ToString(obj.CustomerVisible), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Acknowledged <> Me._Acknowledged) Then
                    Me.UpdateAcknowledged(Me._Acknowledged, (cnn))
                    strTemp = String.Concat(New String() { "Acknowledged Changed to '", Conversions.ToString(Me._Acknowledged), "' from '", Conversions.ToString(obj.Acknowledged), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.SourceID <> Me._SourceID) Then
                    Me.UpdateSourceID(Me._SourceID, (cnn))
                    strTemp = String.Concat(New String() { "SourceID Changed to '", Conversions.ToString(CInt(Me._SourceID)), "' from '", Conversions.ToString(CInt(obj.SourceID)), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._TicketNoteID)
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

        Private Sub UpdateAcknowledged(ByVal NewAcknowledged As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketNoteAcknowledged")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketNoteID", SqlDbType.Int).Value = Me._TicketNoteID
            cmd.Parameters.Add("@Acknowledged", SqlDbType.Bit).Value = NewAcknowledged
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCustomerVisible(ByVal NewCustomerVisible As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketNoteCustomerVisible")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketNoteID", SqlDbType.BigInt).Value = Me._TicketNoteID
            cmd.Parameters.Add("@CustomerVisible", SqlDbType.Bit).Value = NewCustomerVisible
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateNoteBody(ByVal NewNoteBody As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketNoteNoteBody")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketNoteID", SqlDbType.BigInt).Value = Me._TicketNoteID
            cmd.Parameters.Add("@NoteBody", SqlDbType.Text).Value = NewNoteBody
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerVisible(ByVal NewPartnerVisible As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketNotePartnerVisible")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketNoteID", SqlDbType.BigInt).Value = Me._TicketNoteID
            cmd.Parameters.Add("@PartnerVisible", SqlDbType.Bit).Value = NewPartnerVisible
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateSourceID(ByVal NewSourceID As Sources, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateTicketNoteSourceID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@TicketNoteID", SqlDbType.Int).Value = Me._TicketNoteID
            cmd.Parameters.Add("@SourceID", SqlDbType.Int).Value = CInt(NewSourceID)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property Acknowledged As Boolean
            Get
                Return Me._Acknowledged
            End Get
            Set(ByVal value As Boolean)
                Me._Acknowledged = value
            End Set
        End Property

        Public ReadOnly Property ActionObjectID As Long
            Get
                Return Me._ObjectID
            End Get
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

        Public Property CustomerVisible As Boolean
            Get
                Return Me._CustomerVisible
            End Get
            Set(ByVal value As Boolean)
                Me._CustomerVisible = value
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

        Public Property NoteBody As String
            Get
                Return Me._NoteBody
            End Get
            Set(ByVal value As String)
                Me._NoteBody = value
            End Set
        End Property

        Public Property PartnerVisible As Boolean
            Get
                Return Me._PartnerVisible
            End Get
            Set(ByVal value As Boolean)
                Me._PartnerVisible = value
            End Set
        End Property

        Public Property SourceID As Sources
            Get
                Return Me._SourceID
            End Get
            Set(ByVal value As Sources)
                Me._SourceID = value
            End Set
        End Property

        Public ReadOnly Property TicketID As Long
            Get
                Return Me._TicketID
            End Get
        End Property

        Public ReadOnly Property TicketNoteID As Long
            Get
                Return Me._TicketNoteID
            End Get
        End Property

        Public ReadOnly Property WebLoginID As Long
            Get
                Return Me._WebLoginID
            End Get
        End Property


        ' Fields
        Private _Acknowledged As Boolean
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerVisible As Boolean
        Private _DateCreated As DateTime
        Private _NoteBody As String
        Private _ObjectID As Long
        Private _PartnerVisible As Boolean
        Private _SourceID As Sources
        Private _TicketID As Long
        Private _TicketNoteID As Long
        Private _WebLoginID As Long

        ' Nested Types
        Public Enum Sources
            ' Fields
            Employee = 5
            Customer = 4
            Internal = 3
            Partner = 2
            Unknown = 1
        End Enum
    End Class
End Namespace

