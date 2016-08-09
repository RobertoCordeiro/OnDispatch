Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web

Namespace BridgesInterface

    Public Class Email

        'Methods

        Public Sub New(ByVal strHost As String)
            MyBase.New()
            Me._SendTo = ""
            Me._SendFrom = ""
            Me._Subject = ""
            Me._Body = ""
            Me._CC = ""
            Me._Host = ""
            Me._HTMLBody = 1
            Me._BCC = ""
            Me._Host = strHost
        End Sub


        Public Sub Send()
            Dim msg As System.Net.Mail.MailMessage = New System.Net.Mail.MailMessage()
            Dim client As System.Net.Mail.SmtpClient = New System.Net.Mail.SmtpClient(Me._Host)

            msg.To.Add(Me._SendTo)
            If Not (Not ((Me._CC.Trim().Length > 0))) Then
                msg.To.Add(Me._CC)
            End If
            msg.From = New System.Net.Mail.MailAddress(Me._SendFrom)
            msg.ReplyTo = New System.Net.Mail.MailAddress(Me._SendFrom)
            If Not (Not ((Me._BCC.Trim().Length > 0))) Then
                msg.Bcc.Add(New System.Net.Mail.MailAddress(Me._BCC))
            End If
            msg.Subject = Me._Subject
            msg.IsBodyHtml = Me._HTMLBody
            msg.Body = Me._Body
            Try
                client.Send(msg)
            Catch ex As Exception
            End Try
        End Sub

        Public Sub Send(ByVal strSendTo As String, ByVal strSendFrom As String, ByVal strSubject As String, ByVal strBody As String)
            Me.ClearValues()
            Me._SendTo = strSendTo
            Me._SendFrom = strSendFrom
            Me._Subject = strSubject
            Me._Body = strBody
            Me.Send()
        End Sub

        Private Sub ClearValues()
            Me._SendTo = ""
            Me._SendFrom = ""
            Me._Subject = ""
            Me._Body = ""
            Me._CC = ""
            Me._HTMLBody = 1
        End Sub

        'Properties

        Public Property BCC() As String
            Get
                Return Me._BCC
            End Get
            Set(ByVal value As String)
                Me._BCC = value
            End Set
        End Property

        Public Property HTMLBody() As Boolean
            Get
                Return Me._HTMLBody
            End Get
            Set(ByVal value As Boolean)
                Me._HTMLBody = value
            End Set
        End Property

        Public Property SendTo() As String
            Get
                Return Me._SendTo
            End Get
            Set(ByVal value As String)
                Me._SendTo = value
            End Set
        End Property

        Public Property SendFrom() As String
            Get
                Return Me._SendFrom
            End Get
            Set(ByVal value As String)
                Me._SendFrom = value
            End Set
        End Property

        Public Property Subject() As String
            Get
                Return Me._Subject
            End Get
            Set(ByVal value As String)
                Me._Subject = value
            End Set
        End Property

        Public Property Body() As String
            Get
                Return Me._Body
            End Get
            Set(ByVal value As String)
                Me._Body = value
            End Set
        End Property

        Public Property CC() As String
            Get
                Return Me._CC
            End Get
            Set(ByVal value As String)
                Me._CC = value
            End Set
        End Property

        Public Property Host() As String
            Get
                Return Me._Host
            End Get
            Set(ByVal value As String)
                Me._Host = value
            End Set
        End Property


        ' Fields
        Private _SendTo As String
        Private _SendFrom As String
        Private _Subject As String
        Private _Body As String
        Private _CC As String
        Private _Host As String
        Private _HTMLBody As Boolean
        Private _BCC As String


    End Class

End Namespace
