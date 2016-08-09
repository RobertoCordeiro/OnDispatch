Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class NewsArticleRecord
        ' Methods
        Public Sub New()
            Me._NewsArticleID = 0
            Me._CreatedBy = 0
            Me._ArticleSubject = ""
            Me._ArticleText = ""
            Me._ExpiresAfter = 0
            Me._CustomerViewable = False
            Me._PartnerViewable = False
            Me._DateCreated = DateTime.Now
            Me._CountryID = 0
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._NewsArticleID = 0
            Me._CreatedBy = 0
            Me._ArticleSubject = ""
            Me._ArticleText = ""
            Me._ExpiresAfter = 0
            Me._CustomerViewable = False
            Me._PartnerViewable = False
            Me._DateCreated = DateTime.Now
            Me._CountryID = 0
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngNewsArticleID As Long, ByVal strConnectionString As String)
            Me._NewsArticleID = 0
            Me._CreatedBy = 0
            Me._ArticleSubject = ""
            Me._ArticleText = ""
            Me._ExpiresAfter = 0
            Me._CustomerViewable = False
            Me._PartnerViewable = False
            Me._DateCreated = DateTime.Now
            Me._CountryID = 0
            Me._InfoID = 0
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._NewsArticleID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strArticleSubject As String, ByVal strArticleText As String, ByVal lngExpiresAfter As Long, ByVal blnCustomerViewable As Boolean, ByVal blnPartnerViewable As Boolean, ByVal lngCountryID As Long, ByVal lngInfoID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddNewsArticle")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngNewsArticleID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@ArticleSubject", SqlDbType.VarChar, Me.TrimTrunc(strArticleSubject, &H80).Length).Value = Me.TrimTrunc(strArticleSubject, &H80)
                cmd.Parameters.Add("@ArticleText", SqlDbType.Text).Value = strArticleText
                cmd.Parameters.Add("@ExpiresAfter", SqlDbType.Int).Value = lngExpiresAfter
                cmd.Parameters.Add("@CustomerViewable", SqlDbType.Bit).Value = blnCustomerViewable
                cmd.Parameters.Add("@PartnerViewable", SqlDbType.Bit).Value = blnPartnerViewable
                cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = lngCountryID
                cmd.Parameters.Add("@InfoID", sqlDbType.Int).value = lngInfoID
                cnn.Open()
                cmd.Connection = cnn
                lngNewsArticleID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close()
                If (lngNewsArticleID > 0) Then
                    Me.Load(lngNewsArticleID)
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
            Me._NewsArticleID = 0
            Me._CreatedBy = 0
            Me._ArticleSubject = ""
            Me._ArticleText = ""
            Me._ExpiresAfter = 0
            Me._CustomerViewable = False
            Me._PartnerViewable = False
            Me._DateCreated = DateTime.Now
            Me._CountryID = 0
            Me._InfoID = 0
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveNewsArticle")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@NewsArticleID", SqlDbType.Int).Value = Me._NewsArticleID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._NewsArticleID)
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New NewsArticleRecord(Me._NewsArticleID, Me._ConnectionString)
            obj.Load(Me._NewsArticleID)
            If (obj.ArticleSubject <> Me._ArticleSubject) Then
                blnReturn = True
            End If
            If (obj.ArticleText <> Me._ArticleText) Then
                blnReturn = True
            End If
            If (obj.ExpiresAfter <> Me._ExpiresAfter) Then
                blnReturn = True
            End If
            If (obj.CustomerViewable <> Me._CustomerViewable) Then
                blnReturn = True
            End If
            If (obj.PartnerViewable <> Me._PartnerViewable) Then
                blnReturn = True
            End If
            If (obj.CountryID <> Me._CountryID) Then
                blnReturn = True
            End If
            If (obj.InfoID <> Me._InfoID) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngNewsArticleID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetNewsArticle")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@NewsArticleID", SqlDbType.Int).Value = lngNewsArticleID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._NewsArticleID = Conversions.ToLong(dtr.Item("NewsArticleID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._ArticleSubject = dtr.Item("ArticleSubject").ToString
                    Me._ArticleText = dtr.Item("ArticleText").ToString
                    Me._ExpiresAfter = Conversions.ToLong(dtr.Item("ExpiresAfter"))
                    Me._CustomerViewable = Conversions.ToBoolean(dtr.Item("CustomerViewable"))
                    Me._PartnerViewable = Conversions.ToBoolean(dtr.Item("PartnerViewable"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                    Me._CountryID = Conversions.ToLong(dtr.Item("CountryID"))
                    Me._InfoID = Conversions.Tolong(dtr.Item("InfoID"))
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
                Dim obj As New NewsArticleRecord(Me._NewsArticleID, Me._ConnectionString)
                obj.Load(Me._NewsArticleID)
                If (obj.ArticleSubject <> Me._ArticleSubject) Then
                    Me.UpdateArticleSubject(Me._ArticleSubject, (cnn))
                    strTemp = String.Concat(New String() { "ArticleSubject Changed to '", Me._ArticleSubject, "' from '", obj.ArticleSubject, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ArticleText <> Me._ArticleText) Then
                    Me.UpdateArticleText(Me._ArticleText, (cnn))
                    strTemp = String.Concat(New String() { "ArticleText Changed to '", Me._ArticleText, "' from '", obj.ArticleText, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ExpiresAfter <> Me._ExpiresAfter) Then
                    Me.UpdateExpiresAfter(Me._ExpiresAfter, (cnn))
                    strTemp = String.Concat(New String() { "ExpiresAfter Changed to '", Conversions.ToString(Me._ExpiresAfter), "' from '", Conversions.ToString(obj.ExpiresAfter), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CustomerViewable <> Me._CustomerViewable) Then
                    Me.UpdateCustomerViewable(Me._CustomerViewable, (cnn))
                    strTemp = String.Concat(New String() { "CustomerViewable Changed to '", Conversions.ToString(Me._CustomerViewable), "' from '", Conversions.ToString(obj.CustomerViewable), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PartnerViewable <> Me._PartnerViewable) Then
                    Me.UpdatePartnerViewable(Me._PartnerViewable, (cnn))
                    strTemp = String.Concat(New String() { "PartnerViewable Changed to '", Conversions.ToString(Me._PartnerViewable), "' from '", Conversions.ToString(obj.PartnerViewable), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CountryID <> Me._CountryID) Then
                    Me.UpdateCountryID(Me._CountryID, (cnn))
                    strTemp = String.Concat(New String() {"CountryID Changed to '", Conversions.ToString(Me._CountryID), "' from '", Conversions.ToString(obj.CountryID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.InfoID <> Me._InfoID) Then
                    Me.UpdateInfoID(Me._InfoID, (cnn))
                    strTemp = String.Concat(New String() {"InfoID Changed to '", Conversions.ToString(Me._InfoID), "' from '", Conversions.ToString(obj.InfoID), "'"})
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._NewsArticleID)
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

        Private Sub UpdateArticleSubject(ByVal NewArticleSubject As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateNewsArticleArticleSubject")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@NewsArticleID", SqlDbType.Int).Value = Me._NewsArticleID
            cmd.Parameters.Add("@ArticleSubject", SqlDbType.VarChar, Me.TrimTrunc(NewArticleSubject, &H80).Length).Value = Me.TrimTrunc(NewArticleSubject, &H80)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateArticleText(ByVal NewArticleText As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateNewsArticleArticleText")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@NewsArticleID", SqlDbType.Int).Value = Me._NewsArticleID
            cmd.Parameters.Add("@ArticleText", SqlDbType.Text).Value = NewArticleText
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCustomerViewable(ByVal NewCustomerViewable As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateNewsArticleCustomerViewable")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@NewsArticleID", SqlDbType.Int).Value = Me._NewsArticleID
            cmd.Parameters.Add("@CustomerViewable", SqlDbType.Bit).Value = NewCustomerViewable
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateExpiresAfter(ByVal NewExpiresAfter As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateNewsArticleExpiresAfter")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@NewsArticleID", SqlDbType.Int).Value = Me._NewsArticleID
            cmd.Parameters.Add("@ExpiresAfter", SqlDbType.Int).Value = NewExpiresAfter
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePartnerViewable(ByVal NewPartnerViewable As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateNewsArticlePartnerViewable")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@NewsArticleID", SqlDbType.Int).Value = Me._NewsArticleID
            cmd.Parameters.Add("@PartnerViewable", SqlDbType.Bit).Value = NewPartnerViewable
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCountryID(ByVal NewCountryID As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateNewsCountryID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@NewsArticleID", SqlDbType.Int).Value = Me._NewsArticleID
            cmd.Parameters.Add("@CountryID", SqlDbType.Int).Value = NewCountryID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub
        Private Sub UpdateInfoID(ByVal NewInfoID As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateNewsCountryID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@NewsArticleID", SqlDbType.Int).Value = Me._NewsArticleID
            cmd.Parameters.Add("@InfoID", SqlDbType.Int).Value = NewInfoID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub


        ' Properties
        Public Property ArticleSubject As String
            Get
                Return Me._ArticleSubject
            End Get
            Set(ByVal value As String)
                Me._ArticleSubject = Me.TrimTrunc(value, &H80)
            End Set
        End Property

        Public Property ArticleText As String
            Get
                Return Me._ArticleText
            End Get
            Set(ByVal value As String)
                Me._ArticleText = value
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

        Public Property CustomerViewable As Boolean
            Get
                Return Me._CustomerViewable
            End Get
            Set(ByVal value As Boolean)
                Me._CustomerViewable = value
            End Set
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property ExpiresAfter As Long
            Get
                Return Me._ExpiresAfter
            End Get
            Set(ByVal value As Long)
                Me._ExpiresAfter = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public ReadOnly Property NewsArticleID As Long
            Get
                Return Me._NewsArticleID
            End Get
        End Property

        Public Property CountryID() As Long
            Get
                Return Me._CountryID
            End Get
            Set(ByVal value As Long)
                Me._CountryID = value
            End Set
        End Property
        Public Property InfoID() As Long
            Get
                Return Me._InfoID
            End Get
            Set(ByVal value As Long)
                Me._InfoID = value
            End Set
        End Property

        Public Property PartnerViewable As Boolean
            Get
                Return Me._PartnerViewable
            End Get
            Set(ByVal value As Boolean)
                Me._PartnerViewable = value
            End Set
        End Property


        ' Fields
        Private _ArticleSubject As String
        Private _ArticleText As String
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _CustomerViewable As Boolean
        Private _DateCreated As DateTime
        Private _ExpiresAfter As Long
        Private _NewsArticleID As Long
        Private _PartnerViewable As Boolean
        Private _CountryID As Long
        Private _InfoID As Long
        Private Const ArticleSubjectMaxLength As Integer = &H80
    End Class
End Namespace

