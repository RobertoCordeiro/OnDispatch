Imports System.ComponentModel
Imports System.Drawing
Imports Telerik.Reporting
Imports Telerik.Reporting.Drawing

Partial Public Class srptParts
    Inherits Report
    Public Sub New()
        InitializeComponent()
        SqlDataAdapter1.SelectCommand.Connection.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("DBCnn")
    End Sub
    Public Sub New(ByVal ConnStr As String)
        InitializeComponent()
        SqlDataAdapter1.SelectCommand.Connection.ConnectionString = ConnStr
    End Sub
    Public Property Param1() As Integer
        Get
            Return SqlDataAdapter1.SelectCommand.Parameters(0).Value
        End Get
        Set(ByVal value As Integer)
            SqlDataAdapter1.SelectCommand.Parameters(0).Value = value
        End Set
    End Property

    Private Sub SqlDataAdapter1_RowUpdated(ByVal sender As System.Object, ByVal e As System.Data.SqlClient.SqlRowUpdatedEventArgs) Handles SqlDataAdapter1.RowUpdated

    End Sub
End Class