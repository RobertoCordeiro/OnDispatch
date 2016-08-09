Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class PictureRecord
        ' Methods
        Public Sub New()
            Me._PictureID = -1
            Me._CreatedBy = -1
            Me._PicturePath = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub New(ByVal lngPictureID As Long, ByVal strConnectionstring As String)
            Me._PictureID = -1
            Me._CreatedBy = -1
            Me._PicturePath = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = strConnectionstring
            Me.Load(lngPictureID)
        End Sub

        Public Sub New(ByVal strPicturePath As String, ByVal strConnectionString As String)
            Me._PictureID = -1
            Me._CreatedBy = -1
            Me._PicturePath = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = strConnectionString
            Me.Load(strPicturePath)
        End Sub

        Public Sub New(ByVal imgImage As Image, ByVal lngUserID As Long, ByVal strPicturePath As String, ByVal strConnectionString As String)
            Me._PictureID = -1
            Me._CreatedBy = -1
            Me._PicturePath = ""
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = strConnectionString
            Me.Load(Me.Add(imgImage, lngUserID, strPicturePath))
        End Sub

        Public Function Add(ByVal imgImage As Image, ByVal lngUserID As Long, ByVal strPicturePath As String) As Long
            Dim ms As New MemoryStream
            imgImage.Save(ms, imgImage.RawFormat)
            Dim arrPicture As Byte() = ms.GetBuffer
            ms.Close
            Dim lngReturn As Long = 0
            Dim cnn As New SqlConnection(Me._ConnectionString)
            Dim cmd As New SqlCommand("spAddPicture")
            cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngUserID
            cmd.Parameters.Add("@ImageData", SqlDbType.Image).Value = arrPicture
            If (strPicturePath.Length > &HFF) Then
                strPicturePath = strPicturePath.Substring(0, &HFF)
            End If
            cmd.Parameters.Add("@PicturePath", SqlDbType.VarChar, strPicturePath.Length).Value = strPicturePath
            cmd.CommandType = CommandType.StoredProcedure
            cnn.Open
            cmd.Connection = cnn
            lngReturn = Convert.ToInt32(RuntimeHelpers.GetObjectValue(cmd.ExecuteScalar))
            cnn.Close
            Return lngReturn
        End Function

        Private Sub ClearValues()
            Me._PictureID = -1
            Me._CreatedBy = -1
            Me._Image = Nothing
            Me._PicturePath = ""
            Me._DateCreated = DateTime.Now
        End Sub

        Public Function Delete() As Boolean
            If (Me._ConnectionString.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemovePicture")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PictureID", SqlDbType.Int).Value = Me._PictureID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._PictureID)
            End If
            Return (Me._PictureID > 0)
        End Function

        Public Sub Load(ByVal lngPictureID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPicture")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PictureID", SqlDbType.Int).Value = lngPictureID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PictureID = Convert.ToInt32(RuntimeHelpers.GetObjectValue(dtr.Item("PictureID")))
                    Me._CreatedBy = Convert.ToInt32(RuntimeHelpers.GetObjectValue(dtr.Item("CreatedBy")))
                    Dim arrPicture As Byte() = DirectCast(dtr.Item("ImageData"), Byte())
                    Dim ms As New MemoryStream(arrPicture)
                    Me._Image = Drawing.Image.FromStream(ms)
                    ms.Close
                    Me._PicturePath = dtr.Item("PicturePath").ToString
                    Me._DateCreated = Convert.ToDateTime(RuntimeHelpers.GetObjectValue(dtr.Item("DateCreated")))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Load(ByVal strPicturePath As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim lngPictureID As Long = -1
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPictureIDByPicturePath")
                cmd.CommandType = CommandType.StoredProcedure
                If (strPicturePath.Length > &HFF) Then
                    strPicturePath = strPicturePath.Substring(0, &HFF)
                End If
                cmd.Parameters.Add("@PicturePath", SqlDbType.VarChar, strPicturePath.Length).Value = strPicturePath
                cnn.Open
                cmd.Connection = cnn
                lngPictureID = Convert.ToInt32(RuntimeHelpers.GetObjectValue(cmd.ExecuteScalar))
                cnn.Close
                If (lngPictureID > 0) Then
                    Me.Load(lngPictureID)
                Else
                    Me.ClearValues
                End If
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

        Public Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
            Set(ByVal value As Long)
                Me._CreatedBy = value
            End Set
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property Image As Image
            Get
                Return Me._Image
            End Get
            Set(ByVal value As Image)
                Me._Image = value
            End Set
        End Property

        Public ReadOnly Property PictureID As Long
            Get
                Return Me._PictureID
            End Get
        End Property

        Public Property PicturePath As String
            Get
                Return Me._PicturePath
            End Get
            Set(ByVal value As String)
                Me._PicturePath = value
            End Set
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _Image As Image
        Private _PictureID As Long
        Private _PicturePath As String
        Private Const PicturePathMaxLength As Integer = &HFF
    End Class
End Namespace

