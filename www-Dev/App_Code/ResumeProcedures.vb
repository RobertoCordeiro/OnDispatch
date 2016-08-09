Imports System

Namespace BridgesInterface
    Public Class ResumeProcedures
        ' Methods
        Public Sub New()
            Me._ConnectionString = ""
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
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


        ' Fields
        Private _ConnectionString As String
    End Class
End Namespace

