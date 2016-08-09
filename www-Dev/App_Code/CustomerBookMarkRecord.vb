Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class CustomerBookMarkRecord
        ' Methods
        Public Sub New()
            Me._UserID = 0
            Me._CustomerID = 0
            Me._Title = ""
            Me._Expires = True
            Me._DateExpires = DateTime.Now.AddDays(90)
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionstring As String)
            Me._UserID = 0
            Me._CustomerID = 0
            Me._Title = ""
            Me._Expires = True
            Me._DateExpires = DateTime.Now.AddDays(90)
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionstring
        End Sub

        Public Sub New(ByVal lngUserID As Long, ByVal lngCustomerID As Long, ByVal strConnectionstring As String)
            Me._UserID = 0
            Me._CustomerID = 0
            Me._Title = ""
            Me._Expires = True
            Me._DateExpires = DateTime.Now.AddDays(90)
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionstring
            Me.Load(lngUserID, lngCustomerID)
        End Sub

        Public Sub New(ByVal lngUserID As Long, ByVal lngCustomerID As Long, ByVal strTitle As String, ByVal blnExpires As Boolean, ByVal datDateExpires As DateTime, ByVal strConnectionString As String)
            Me._UserID = 0
            Me._CustomerID = 0
            Me._Title = ""
            Me._Expires = True
            Me._DateExpires = DateTime.Now.AddDays(90)
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Add(lngUserID, lngCustomerID, strTitle, blnExpires, datDateExpires)
        End Sub

        Public Sub Add(ByVal lngUserID As Long, ByVal lngCustomerID As Long, ByVal strTitle As String, ByVal blnExpires As Boolean, ByVal datDateExpires As DateTime)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddCustomerBookmark")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = lngUserID
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                If (strTitle.Trim.Length > &H10) Then
                    strTitle = strTitle.Trim.Substring(0, &H10)
                End If
                cmd.Parameters.Add("@Title", SqlDbType.VarChar, strTitle.Trim.Length).Value = strTitle.Trim
                cmd.Parameters.Add("@Expires", SqlDbType.Bit).Value = blnExpires
                cmd.Parameters.Add("@DateExpires", SqlDbType.DateTime).Value = datDateExpires
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(lngUserID, lngCustomerID)
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
            Me._CustomerID = 0
            Me._Title = ""
            Me._Expires = False
            Me._DateExpires = DateTime.Now.AddDays(30)
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveCustomerBookmark")
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
            Me.Load(Me._UserID, Me._CustomerID)
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim ref As New CustomerBookMarkRecord(Me._UserID, Me._CustomerID, Me._ConnectionString)
                If (ref.Title <> Me._Title) Then
                    blnReturn = True
                End If
                If (ref.Expires <> Me._Expires) Then
                    blnReturn = True
                End If
                If (DateTime.Compare(ref.DateExpires, Me._DateExpires) <> 0) Then
                    blnReturn = True
                End If
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngUserID As Long, ByVal lngCustomerID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetCustomerBookmark")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = lngUserID
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = lngCustomerID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._UserID = Conversions.ToLong(dtr.Item("UserID"))
                    Me._CustomerID = Conversions.ToLong(dtr.Item("CustomerID"))
                    Me._Title = dtr.Item("Title").ToString
                    Me._Expires = Conversions.ToBoolean(dtr.Item("Expires"))
                    Me._DateExpires = Conversions.ToDate(dtr.Item("DateExpires"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            Dim strTemp As String = ""
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim ref As New CustomerBookMarkRecord(Me._UserID, Me._CustomerID, Me._ConnectionString)
                If (ref.Title <> Me._Title) Then
                    Me.UpdateTitle(Me._Title)
                    strTemp = String.Concat(New String() { "Changed title from '", ref.Title, "' to '", Me._Title, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (ref.Expires <> Me._Expires) Then
                    Me.UpdateExpires(Me._Expires)
                    strTemp = ("Changed expires from " & ref.Expires.ToString & " to " & Me._Expires.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (DateTime.Compare(ref.DateExpires, Me._DateExpires) <> 0) Then
                    Me.UpdateDateExpires(Me._DateExpires)
                    strTemp = ("Changed Date Expires from " & ref.DateExpires.ToString & " to " & Me._DateExpires.ToString)
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
            End If
        End Sub

        Private Sub UpdateDateExpires(ByVal NewDateExpires As DateTime)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerBookmarkDateExpires")
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
                cmd.Parameters.Add("@DateExpires", SqlDbType.DateTime).Value = NewDateExpires
                cmd.CommandType = CommandType.StoredProcedure
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateExpires(ByVal NewExpires As Boolean)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerBookmarkExpires")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
                cmd.Parameters.Add("Expires", SqlDbType.Bit).Value = NewExpires
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
        End Sub

        Private Sub UpdateTitle(ByVal NewTitle As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spUpdateCustomerBookmarkExpires")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Me._UserID
                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = Me._CustomerID
                If (NewTitle.Trim.Length > &H10) Then
                    NewTitle = NewTitle.Trim.Substring(0, &H10)
                End If
                cmd.Parameters.Add("Title", SqlDbType.VarChar, NewTitle.Trim.Length).Value = NewTitle.Trim
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
            End If
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

        Public ReadOnly Property CustomerID As Long
            Get
                Return Me._CustomerID
            End Get
        End Property

        Public Property DateExpires As DateTime
            Get
                Return Me._DateExpires
            End Get
            Set(ByVal value As DateTime)
                Me._DateExpires = value
            End Set
        End Property

        Public Property Expires As Boolean
            Get
                Return Me._Expires
            End Get
            Set(ByVal value As Boolean)
                Me._Expires = value
            End Set
        End Property

        Public Property Title As String
            Get
                Return Me._Title
            End Get
            Set(ByVal value As String)
                If (value.Trim.Length > &H10) Then
                    Me._Title = value.Trim.Substring(0, &H10)
                Else
                    Me._Title = value.Trim
                End If
            End Set
        End Property

        Public ReadOnly Property UserID As Long
            Get
                Return Me._UserID
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CustomerID As Long
        Private _DateExpires As DateTime
        Private _Expires As Boolean
        Private _Title As String
        Private _UserID As Long
        Private Const TitleMaxLength As Integer = &H10
    End Class
End Namespace

