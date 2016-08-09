Imports System.ComponentModel
Imports System.Drawing
Imports Telerik.Reporting
Imports Telerik.Reporting.Drawing
Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.Runtime.CompilerServices

Partial Public Class InvoiceSingleTicket
    Inherits Report
    Public Sub New()
        InitializeComponent()
        SqlDataAdapter1.SelectCommand.Connection.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("DBCnn")
    End Sub
    Public Sub New(ByVal ConnStr As String)
        InitializeComponent()
        SqlDataAdapter1.SelectCommand.Connection.ConnectionString = ConnStr
    End Sub

    Private Sub srptParts_NeedDataSource(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles srptParts.NeedDataSource

    End Sub
    Public Property Param1() As Integer
        Get
            Return SqlDataAdapter1.SelectCommand.Parameters(0).Value
        End Get
        Set(ByVal value As Integer)
            SqlDataAdapter1.SelectCommand.Parameters(0).Value = value
        End Set
    End Property

    
End Class