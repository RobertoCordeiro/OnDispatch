Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class WarrantyTermRecord
        ' Methods
        Public Sub New()
            Me._WarrantyTermID = 0
            Me._CreatedBy = 0
            Me._Term = ""
            Me._Units = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._WarrantyTermID = 0
            Me._CreatedBy = 0
            Me._Term = ""
            Me._Units = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngWarrantyTermID As Long, ByVal strConnectionString As String)
            Me._WarrantyTermID = 0
            Me._CreatedBy = 0
            Me._Term = ""
            Me._Units = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._WarrantyTermID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strTerm As String, ByVal lngUnits As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddWarrantyTerm")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngWarrantyTermID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Term", SqlDbType.VarChar, Me.TrimTrunc(strTerm, &H40).Length).Value = Me.TrimTrunc(strTerm, &H40)
                cmd.Parameters.Add("@Units", SqlDbType.Int).Value = lngUnits
                cnn.Open
                cmd.Connection = cnn
                lngWarrantyTermID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngWarrantyTermID > 0) Then
                    Me.Load(lngWarrantyTermID)
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
            Me._WarrantyTermID = 0
            Me._CreatedBy = 0
            Me._Term = ""
            Me._Units = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveWarrantyTerm")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WarrantyTermID", SqlDbType.Int).Value = Me._WarrantyTermID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._WarrantyTermID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New WarrantyTermRecord(Me._WarrantyTermID, Me._ConnectionString)
            obj.Load(Me._WarrantyTermID)
            If (obj.Term <> Me._Term) Then
                blnReturn = True
            End If
            If (obj.Units <> Me._Units) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngWarrantyTermID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetWarrantyTerm")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@WarrantyTermID", SqlDbType.Int).Value = lngWarrantyTermID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._WarrantyTermID = Conversions.ToLong(dtr.Item("WarrantyTermID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Term = dtr.Item("Term").ToString
                    Me._Units = Conversions.ToLong(dtr.Item("Units"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
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
                Dim obj As New WarrantyTermRecord(Me._WarrantyTermID, Me._ConnectionString)
                obj.Load(Me._WarrantyTermID)
                If (obj.Term <> Me._Term) Then
                    Me.UpdateTerm(Me._Term, (cnn))
                    strTemp = String.Concat(New String() { "Term Changed to '", Me._Term, "' from '", obj.Term, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Units <> Me._Units) Then
                    Me.UpdateUnits(Me._Units, (cnn))
                    strTemp = String.Concat(New String() { "Units Changed to '", Conversions.ToString(Me._Units), "' from '", Conversions.ToString(obj.Units), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._WarrantyTermID)
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

        Private Sub UpdateTerm(ByVal NewTerm As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWarrantyTermTerm")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WarrantyTermID", SqlDbType.Int).Value = Me._WarrantyTermID
            cmd.Parameters.Add("@Term", SqlDbType.VarChar, Me.TrimTrunc(NewTerm, &H40).Length).Value = Me.TrimTrunc(NewTerm, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateUnits(ByVal NewUnits As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateWarrantyTermUnits")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@WarrantyTermID", SqlDbType.Int).Value = Me._WarrantyTermID
            cmd.Parameters.Add("@Units", SqlDbType.Int).Value = NewUnits
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
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

        Public Property Term As String
            Get
                Return Me._Term
            End Get
            Set(ByVal value As String)
                Me._Term = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property Units As Long
            Get
                Return Me._Units
            End Get
            Set(ByVal value As Long)
                Me._Units = value
            End Set
        End Property

        Public ReadOnly Property WarrantyTermID As Long
            Get
                Return Me._WarrantyTermID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Term As String
        Private _Units As Long
        Private _WarrantyTermID As Long
        Private Const TermMaxLength As Integer = &H40
    End Class
End Namespace

