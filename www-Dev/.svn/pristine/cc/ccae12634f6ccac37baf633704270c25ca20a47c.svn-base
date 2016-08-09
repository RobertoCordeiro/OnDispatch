Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class PartnerNoteRecord
        ' Methods
        Public Sub New()
            Me._PartnerNoteID = 0
            Me._PartnerID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._DateCreated = DateTime.Now
            Me._BillingNotes = 0
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._PartnerNoteID = 0
            Me._PartnerID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._DateCreated = DateTime.Now
            Me._BillingNotes = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngPartnerNoteID As Long, ByVal strConnectionString As String)
            Me._PartnerNoteID = 0
            Me._PartnerID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._DateCreated = DateTime.Now
            Me._BillingNotes = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._PartnerNoteID)
        End Sub

        Public Sub Add(ByVal lngPartnerID As Long, ByVal lngCreatedBy As Long, ByVal strNoteBody As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerNote")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerNoteID As Long = 0
                cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = lngPartnerID
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@NoteBody", SqlDbType.Text).Value = strNoteBody
                cnn.Open
                cmd.Connection = cnn
                lngPartnerNoteID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngPartnerNoteID > 0) Then
                    Me.Load(lngPartnerNoteID)
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
            Me._PartnerNoteID = 0
            Me._PartnerID = 0
            Me._CreatedBy = 0
            Me._NoteBody = ""
            Me._DateCreated = DateTime.Now
            Me._BillingNotes = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerNote")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerNoteID", SqlDbType.Int).Value = Me._PartnerNoteID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._PartnerNoteID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New PartnerNoteRecord(Me._PartnerNoteID, Me._ConnectionString)
            obj.Load(Me._PartnerNoteID)
            If (obj.NoteBody <> Me._NoteBody) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngPartnerNoteID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerNote")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerNoteID", SqlDbType.Int).Value = lngPartnerNoteID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerNoteID = Conversions.ToLong(dtr.Item("PartnerNoteID"))
                    Me._PartnerID = Conversions.ToLong(dtr.Item("PartnerID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._NoteBody = dtr.Item("NoteBody").ToString
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._BillingNotes = Conversions.ToBoolean(dtr.Item("BillingNotes"))
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
                Dim obj As New PartnerNoteRecord(Me._PartnerNoteID, Me._ConnectionString)
                obj.Load(Me._PartnerNoteID)
                If (obj.NoteBody <> Me._NoteBody) Then
                    Me.UpdateNoteBody(Me._NoteBody, (cnn))
                    strTemp = String.Concat(New String() { "NoteBody Changed to '", Me._NoteBody, "' from '", obj.NoteBody, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._PartnerNoteID)
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

        Private Sub UpdateNoteBody(ByVal NewNoteBody As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerNoteNoteBody")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerNoteID", SqlDbType.BigInt).Value = Me._PartnerNoteID
            cmd.Parameters.Add("@NoteBody", SqlDbType.Text).Value = NewNoteBody
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBillingNotes(ByVal NewBillingNotes As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerNoteBillingNotes")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerNoteID", SqlDbType.BigInt).Value = Me._PartnerNoteID
            cmd.Parameters.Add("@BillingNotes", SqlDbType.Bit).Value = NewBillingNotes
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ' Properties
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

        Public ReadOnly Property PartnerID As Long
            Get
                Return Me._PartnerID
            End Get
        End Property

        Public ReadOnly Property PartnerNoteID As Long
            Get
                Return Me._PartnerNoteID
            End Get
        End Property

        Public Property BillingNotes() As Boolean
            Get
                Return Me._BillingNotes
            End Get
            Set(ByVal value As Boolean)
                Me._BillingNotes = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _NoteBody As String
        Private _PartnerID As Long
        Private _PartnerNoteID As Long
        Private _BillingNotes As Boolean
    End Class
End Namespace

