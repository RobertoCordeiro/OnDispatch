Imports System.ComponentModel
Imports System.Drawing
Imports Telerik.Reporting
Imports Telerik.Reporting.Drawing

Partial Public Class Report1
    Inherits Report
    Public Sub New()
        InitializeComponent()

        'TODO: This line of code loads data into the 'BridgesDataSet.BridgesDataSetTable' table. You can move, or remove it, as needed.
        Try
            Me.BridgesDataSetTableAdapter1.fill(Me.BridgesDataSet.BridgesDataSetTable)
        Catch ex As System.Exception
            'An error has occurred while filling the data set. Please check the exception for more information.
            System.Diagnostics.Debug.WriteLine(ex.Message)
        End Try
    End Sub
End Class