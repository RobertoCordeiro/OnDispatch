﻿Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class GenderRecord
        ' Methods
        Public Sub New()
            Me._GenderID = 0
            Me._CreatedBy = 0
            Me._Gender = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._GenderID = 0
            Me._CreatedBy = 0
            Me._Gender = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngGenderID As Long, ByVal strConnectionString As String)
            Me._GenderID = 0
            Me._CreatedBy = 0
            Me._Gender = ""
            Me._DateCreated = New DateTime
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(CLng(Me._GenderID))
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal strGender As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddGender")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngGenderID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@Gender", SqlDbType.VarChar, Me.TrimTrunc(strGender, &H10).Length).Value = Me.TrimTrunc(strGender, &H10)
                cnn.Open
                cmd.Connection = cnn
                lngGenderID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngGenderID > 0) Then
                    Me.Load(lngGenderID)
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
            Me._GenderID = 0
            Me._CreatedBy = 0
            Me._Gender = ""
            Me._DateCreated = New DateTime
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveGender")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@GenderID", SqlDbType.Int).Value = Me._GenderID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(CLng(Me._GenderID))
            End If
        End Sub

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New GenderRecord(CLng(Me._GenderID), Me._ConnectionString)
            If (obj.Gender <> Me._Gender) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngGenderID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetGender")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@GenderID", SqlDbType.Int).Value = lngGenderID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._GenderID = Conversions.ToInteger(dtr.Item("GenderID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._Gender = dtr.Item("Gender").ToString
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
                Dim obj As New GenderRecord(CLng(Me._GenderID), Me._ConnectionString)
                If (obj.Gender <> Me._Gender) Then
                    Me.UpdateGender(Me._Gender, (cnn))
                    strTemp = String.Concat(New String() { "Gender Changed from '", Me._Gender, "' to '", obj.Gender, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(CLng(Me._GenderID))
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

        Private Sub UpdateGender(ByVal NewGender As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateGenderGender")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@GenderID", SqlDbType.TinyInt).Value = Me._GenderID
            cmd.Parameters.Add("@Gender", SqlDbType.VarChar, Me.TrimTrunc(NewGender, &H10).Length).Value = Me.TrimTrunc(NewGender, &H10)
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

        Public Property Gender As String
            Get
                Return Me._Gender
            End Get
            Set(ByVal value As String)
                Me._Gender = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public ReadOnly Property GenderID As Integer
            Get
                Return Me._GenderID
            End Get
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Gender As String
        Private _GenderID As Integer
        Private Const GenderMaxLength As Integer = &H10
    End Class
End Namespace

