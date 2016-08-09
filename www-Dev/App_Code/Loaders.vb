Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.OleDb



Public Class Loaders

    ' Methods
    Public Sub New(ByVal strConnectionString As String)
        Me._ConnectionString = strConnectionString
    End Sub

    Private Sub FillAndSort(ByVal blnSortable As Boolean, ByVal dgv As DataGrid, ByVal ds As DataSet, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        If blnSortable Then
            dgv.AllowSorting = True
            If Not Information.IsNothing(e) Then
                Dim dv As New DataView
                Dim strDirection As String = " asc"
                dv = ds.Tables.Item(0).DefaultView
                If ((e.SortExpression = strCurrentSort) AndAlso (strCurrentSortDirection = " asc")) Then
                    strDirection = " desc"
                End If
                dv.Sort = (e.SortExpression & strDirection)
                dgv.DataSource = dv
                dgv.DataBind()
            Else
                dgv.DataSource = ds
                dgv.DataBind()
            End If
        Else
            dgv.AllowSorting = False
            dgv.DataSource = ds
            dgv.DataBind()
        End If
    End Sub

    Public Sub LoadLongStringParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As String, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.VarChar, strParameter2Value.Trim.Length).Value = strParameter2Value.Trim
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadLongThreeStringParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As String, ByVal strParameter3Name As String, ByVal strParameter3Value As String, ByVal strParameter4Name As String, ByVal strParameter4Value As String, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.VarChar, strParameter2Value.Trim.Length).Value = strParameter2Value.Trim
        cmd.Parameters.Add(strParameter3Name, SqlDbType.VarChar, strParameter3Value.Trim.Length).Value = strParameter3Value.Trim
        cmd.Parameters.Add(strParameter4Name, SqlDbType.VarChar, strParameter4Value.Trim.Length).Value = strParameter4Value.Trim
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadTwoLongStringParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal strParameter3Value As String, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.VarChar, strParameter3Value.Trim.Length).Value = strParameter3Value.Trim
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadTwoStringLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal strParameter1Value As String, ByVal strParameter2Name As String, ByVal strParameter2Value As String, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.VarChar, strParameter1Value.Trim.Length).Value = strParameter1Value.Trim
        cmd.Parameters.Add(strParameter2Name, SqlDbType.VarChar, strParameter2Value.Trim.Length).Value = strParameter2Value.Trim
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadTwoStringLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal strParameter1Value As String, ByVal strParameter2Name As String, ByVal strParameter2Value As String, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.VarChar, strParameter1Value.Trim.Length).Value = strParameter1Value.Trim
        cmd.Parameters.Add(strParameter2Name, SqlDbType.VarChar, strParameter2Value.Trim.Length).Value = strParameter2Value.Trim
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub




    Public Sub LoadStringParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal strParameter1Value As String, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.VarChar, strParameter1Value.Trim.Length).Value = strParameter1Value.Trim
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadStringDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal strParameter1Value As String, ByVal strParameter2Name As String, ByVal strParameter2Value As DateTime, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.VarChar, strParameter1Value.Trim.Length).Value = strParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(strParameter2Value)).Value = strParameter2Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub


    Public Sub LoadLongStringParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As String, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.VarChar, strParameter2Value.Trim.Length).Value = strParameter2Value.Trim
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub
    
    Public Sub LoadLongDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As DateTime, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(strParameter2Value)).Value = strParameter2Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadLongTwoDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As DateTime, ByVal strParameter3Name As String, ByVal strParameter3Value As DateTime, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(strParameter2Value)).Value = strParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.DateTime, Len(strParameter3Value)).Value = strParameter3Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadLongTwoDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As DateTime, ByVal strParameter3Name As String, ByVal strParameter3Value As DateTime, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(strParameter2Value)).Value = strParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.DateTime, Len(strParameter3Value)).Value = strParameter3Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadTwoLongDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameterAName As String, ByVal lngParameterAValue As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As DateTime, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameterAName, SqlDbType.Int).Value = lngParameterAValue
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(strParameter2Value)).Value = strParameter2Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadTwoLongDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameterAName As String, ByVal lngParameterAValue As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As DateTime, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)

        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameterAName, SqlDbType.Int).Value = lngParameterAValue
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(strParameter2Value)).Value = strParameter2Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadTwoLongTwoDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameterAName As String, ByVal lngParameterAValue As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As DateTime, ByVal strParameter3Name As String, ByVal strParameter3Value As DateTime, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameterAName, SqlDbType.Int).Value = lngParameterAValue
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(strParameter2Value)).Value = strParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.DateTime, Len(strParameter3Value)).Value = strParameter3Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadTwoLongTwoDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameterAName As String, ByVal lngParameterAValue As Long, ByVal strParameter2Name As String, ByVal strParameter2Value As DateTime, ByVal strParameter3Name As String, ByVal strParameter3Value As DateTime, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)

        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameterAName, SqlDbType.Int).Value = lngParameterAValue
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(strParameter2Value)).Value = strParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.DateTime, Len(strParameter3Value)).Value = strParameter3Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadSimpleDataGrid(ByVal strStoredProcedure As String, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadSimpleDataGrid(ByVal strStoredProcedure As String, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadSimpleDropDownList(ByVal strStoredProcedure As String, ByVal strTextColumnName As String, ByVal strDataColumnName As String, ByRef drp As DropDownList)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As SqlDataReader = cmd.ExecuteReader
        drp.Items.Clear()
        Do While dtr.Read
            Dim itm As New ListItem
            itm.Text = Conversions.ToString(dtr.Item(strTextColumnName))
            itm.Value = Conversions.ToString(dtr.Item(strDataColumnName))
            drp.Items.Add(itm)
        Loop
        dtr.Close()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadSingleDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameterName As String, ByVal datParameterValue As DateTime, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameterName, SqlDbType.DateTime).Value = datParameterValue
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadLongDateParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal datParameter1Value As Long, ByVal strParameter2Name As String, ByVal datParameter2Value As DateTime, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = datParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(datParameter2Value)).Value = datParameter2Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub


    Public Sub LoadSingleLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameterName As String, ByVal lngParameterValue As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameterName, SqlDbType.Int).Value = lngParameterValue
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadSingleLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameterName As String, ByVal lngParameterValue As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameterName, SqlDbType.Int).Value = lngParameterValue
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadSingleLongParameterDropDownList(ByVal strStoredProcedure As String, ByVal strParameterName As String, ByVal lngParameterValue As Long, ByVal strTextColumnName As String, ByVal strDataColumnName As String, ByRef drp As DropDownList)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.Parameters.Add(strParameterName, SqlDbType.Int).Value = lngParameterValue
        cmd.CommandType = CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As SqlDataReader = cmd.ExecuteReader
        drp.Items.Clear()
        Do While dtr.Read
            Dim itm As New ListItem
            itm.Text = Conversions.ToString(dtr.Item(strTextColumnName))
            itm.Value = Conversions.ToString(dtr.Item(strDataColumnName))
            drp.Items.Add(itm)
        Loop
        dtr.Close()
        cnn.Close()
        cmd.Dispose()
    End Sub
    
    Public Sub LoadSingleDateParameterDropDownList(ByVal strStoredProcedure As String, ByVal strParameterName As String, ByVal datParameterValue As DateTime, ByVal strTextColumnName As String, ByVal strDataColumnName As String, ByRef drp As DropDownList)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.Parameters.Add(strParameterName, SqlDbType.DateTime, Len(datParameterValue)).Value = datParameterValue
        cmd.CommandType = CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As SqlDataReader = cmd.ExecuteReader
        drp.Items.Clear()
        Do While dtr.Read
            Dim itm As New ListItem
            itm.Text = Conversions.ToString(dtr.Item(strTextColumnName))
            itm.Value = Conversions.ToString(dtr.Item(strDataColumnName))
            drp.Items.Add(itm)
        Loop
        dtr.Close()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadLongDateParameterDropDownList(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal datParameter2Value As DateTime, ByVal strTextColumnName As String, ByVal strDataColumnName As String, ByRef drp As DropDownList)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.DateTime, Len(datParameter2Value)).Value = datParameter2Value
        cmd.CommandType = CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As SqlDataReader = cmd.ExecuteReader
        drp.Items.Clear()
        Do While dtr.Read
            Dim itm As New ListItem
            itm.Text = Conversions.ToString(dtr.Item(strTextColumnName))
            itm.Value = Conversions.ToString(dtr.Item(strDataColumnName))
            drp.Items.Add(itm)
        Loop
        dtr.Close()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadTwoLongDateParameterDropDownList(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal datParameter3Value As DateTime, ByVal strTextColumnName As String, ByVal strDataColumnName As String, ByRef drp As DropDownList)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.DateTime, Len(datParameter3Value)).Value = datParameter3Value
        cmd.CommandType = CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As SqlDataReader = cmd.ExecuteReader
        drp.Items.Clear()
        Do While dtr.Read
            Dim itm As New ListItem
            itm.Text = Conversions.ToString(dtr.Item(strTextColumnName))
            itm.Value = Conversions.ToString(dtr.Item(strDataColumnName))
            drp.Items.Add(itm)
        Loop
        dtr.Close()
        cnn.Close()
        cmd.Dispose()
    End Sub
    Public Sub LoadTwoLongParameterDropDownList(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strTextColumnName As String, ByVal strDataColumnName As String, ByRef drp As DropDownList)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.CommandType = CommandType.StoredProcedure
        cnn.Open()
        cmd.Connection = cnn
        Dim dtr As SqlDataReader = cmd.ExecuteReader
        drp.Items.Clear()
        Do While dtr.Read
            Dim itm As New ListItem
            itm.Text = Conversions.ToString(dtr.Item(strTextColumnName))
            itm.Value = Conversions.ToString(dtr.Item(strDataColumnName))
            drp.Items.Add(itm)
        Loop
        dtr.Close()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadSingleLongParameterRepeater(ByVal strStoredProcedure As String, ByVal strParameterName As String, ByVal lngParameterValue As Long, ByRef rpt As Repeater)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameterName, SqlDbType.Int).Value = lngParameterValue
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        rpt.DataSource = ds
        rpt.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadTwoLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadTwoLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub

    

    Public Sub LoadThreeLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadThreeLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub
    
    Public Sub LoadFourLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadFourLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub
    
    Public Sub LoadFiveLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub


    Public Sub LoadFiveLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub
    

    Public Sub LoadSixLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByVal strParameter6Name As String, ByVal lngParameter6Value As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Parameters.Add(strParameter6Name, SqlDbType.Int).Value = lngParameter6Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadSixLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByVal strParameter6Name As String, ByVal lngParameter6Value As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Parameters.Add(strParameter6Name, SqlDbType.Int).Value = lngParameter6Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub
    

    Public Sub LoadSevenLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByVal strParameter6Name As String, ByVal lngParameter6Value As Long, ByVal strParameter7Name As String, ByVal lngParameter7Value As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Parameters.Add(strParameter6Name, SqlDbType.Int).Value = lngParameter6Value
        cmd.Parameters.Add(strParameter7Name, SqlDbType.Int).Value = lngParameter7Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadSevenLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByVal strParameter6Name As String, ByVal lngParameter6Value As Long, ByVal strParameter7Name As String, ByVal lngParameter7Value As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Parameters.Add(strParameter6Name, SqlDbType.Int).Value = lngParameter6Value
        cmd.Parameters.Add(strParameter7Name, SqlDbType.Int).Value = lngParameter7Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadEightLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByVal strParameter6Name As String, ByVal lngParameter6Value As Long, ByVal strParameter7Name As String, ByVal lngParameter7Value As Long, ByVal strParameter8Name As String, ByVal lngParameter8Value As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Parameters.Add(strParameter6Name, SqlDbType.Int).Value = lngParameter6Value
        cmd.Parameters.Add(strParameter7Name, SqlDbType.Int).Value = lngParameter7Value
        cmd.Parameters.Add(strParameter8Name, SqlDbType.Int).Value = lngParameter8Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadEightLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByVal strParameter6Name As String, ByVal lngParameter6Value As Long, ByVal strParameter7Name As String, ByVal lngParameter7Value As Long, ByVal strParameter8Name As String, ByVal lngParameter8Value As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Parameters.Add(strParameter6Name, SqlDbType.Int).Value = lngParameter6Value
        cmd.Parameters.Add(strParameter7Name, SqlDbType.Int).Value = lngParameter7Value
        cmd.Parameters.Add(strParameter8Name, SqlDbType.Int).Value = lngParameter8Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadNineLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByVal strParameter6Name As String, ByVal lngParameter6Value As Long, ByVal strParameter7Name As String, ByVal lngParameter7Value As Long, ByVal strParameter8Name As String, ByVal lngParameter8Value As Long, ByVal strParameter9Name As String, ByVal lngParameter9Value As Long, ByRef dgv As DataGrid)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Parameters.Add(strParameter6Name, SqlDbType.Int).Value = lngParameter6Value
        cmd.Parameters.Add(strParameter7Name, SqlDbType.Int).Value = lngParameter7Value
        cmd.Parameters.Add(strParameter8Name, SqlDbType.Int).Value = lngParameter8Value
        cmd.Parameters.Add(strParameter9Name, SqlDbType.Int).Value = lngParameter9Value

        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        dgv.DataSource = ds
        dgv.DataBind()
        cnn.Close()
        cmd.Dispose()
    End Sub

    Public Sub LoadNineLongParameterDataGrid(ByVal strStoredProcedure As String, ByVal strParameter1Name As String, ByVal lngParameter1Value As Long, ByVal strParameter2Name As String, ByVal lngParameter2Value As Long, ByVal strParameter3Name As String, ByVal lngParameter3Value As Long, ByVal strParameter4Name As String, ByVal lngParameter4Value As Long, ByVal strParameter5Name As String, ByVal lngParameter5Value As Long, ByVal strParameter6Name As String, ByVal lngParameter6Value As Long, ByVal strParameter7Name As String, ByVal lngParameter7Value As Long, ByVal strParameter8Name As String, ByVal lngParameter8Value As Long, ByVal strParameter9Name As String, ByVal lngParameter9Value As Long, ByRef dgv As DataGrid, ByVal blnSortable As Boolean, ByVal e As DataGridSortCommandEventArgs, ByVal strCurrentSort As String, ByVal strCurrentSortDirection As String)
        Dim cnn As New SqlConnection(Me._ConnectionString)
        Dim da As New SqlDataAdapter
        Dim ds As New DataSet
        cnn.Open()
        Dim cmd As New SqlCommand(strStoredProcedure)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add(strParameter1Name, SqlDbType.Int).Value = lngParameter1Value
        cmd.Parameters.Add(strParameter2Name, SqlDbType.Int).Value = lngParameter2Value
        cmd.Parameters.Add(strParameter3Name, SqlDbType.Int).Value = lngParameter3Value
        cmd.Parameters.Add(strParameter4Name, SqlDbType.Int).Value = lngParameter4Value
        cmd.Parameters.Add(strParameter5Name, SqlDbType.Int).Value = lngParameter5Value
        cmd.Parameters.Add(strParameter6Name, SqlDbType.Int).Value = lngParameter6Value
        cmd.Parameters.Add(strParameter7Name, SqlDbType.Int).Value = lngParameter7Value
        cmd.Parameters.Add(strParameter8Name, SqlDbType.Int).Value = lngParameter8Value
        cmd.Parameters.Add(strParameter9Name, SqlDbType.Int).Value = lngParameter9Value
        cmd.Connection = cnn
        da.SelectCommand = cmd
        da.Fill(ds)
        Me.FillAndSort(blnSortable, dgv, ds, e, strCurrentSort, strCurrentSortDirection)
        cnn.Close()
        cmd.Dispose()
    End Sub

    

    Public Sub RunFolderCode1(ByRef cnn As SqlConnection, ByVal DTicketID As Integer)
        Dim cn As New SqlConnection(Me._ConnectionString)
        Dim cmd As New SqlCommand("spTicketFolderCode")
        cmd.Parameters.Add("@TicketID", SqlDbType.Int).Value = DTicketID
        cmd.CommandType = CommandType.StoredProcedure
        cn.Open()
        cmd.Connection = cn
        cmd.ExecuteNonQuery()
        cn.Close()
        cmd.Dispose()
    End Sub

    Public Sub ExportGrid(ByVal strFileName As String, ByVal dg As DataGrid)

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.Buffer = True
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" & strFileName)
        HttpContext.Current.Response.Charset = ""
        'Response.Cache.SetCacheability(HttpCacheability.NoCache)
        HttpContext.Current.Response.AddHeader("Cache-Control", "max-age=0")
        HttpContext.Current.Response.ContentType = "application/vnd.ms-excel"
        Dim sw As New System.IO.StringWriter
        Dim hw As New HtmlTextWriter(sw)
        clearControls(dg)
        dg.RenderControl(hw)

        'style to format numbers to string 

        Dim style As String = "<style> .textmode{mso-number-format:\@;}</style>"

        HttpContext.Current.Response.Write(style)
        HttpContext.Current.Response.Output.Write(sw.ToString())
        HttpContext.Current.Response.Flush()
        HttpContext.Current.Response.End()
    End Sub

    Private Sub ClearControls(ByVal ctrl As Control)

        Dim i As Integer
        For i = ctrl.Controls.Count - 1 To 0 Step i - 1
            ClearControls(ctrl.Controls(i))
        Next

        Dim ctrlType As Type = ctrl.GetType()
        If Not ctrlType.Name = "TableCell" Then
            If Not ctrl.GetType().GetProperty("SelectedItem") Is Nothing Then
                Dim literal As LiteralControl = New LiteralControl
                ctrl.Parent.Controls.Add(literal)

                Try
                    literal.Text = CType(ctrl.GetType().GetProperty("SelectedItem").GetValue(ctrl, Nothing), String)
                Catch

                End Try

                ctrl.Parent.Controls.Remove(ctrl)
            ElseIf Not ctrl.GetType().GetProperty("Text") Is Nothing Then
                Dim literal As LiteralControl = New LiteralControl
                ctrl.Parent.Controls.Add(literal)
                literal.Text = CType(ctrl.GetType().GetProperty("Text").GetValue(ctrl, Nothing), String)
                ctrl.Parent.Controls.Remove(ctrl)
            End If

        End If

    End Sub

    Public Function FirstDateOfWeek(ByVal year1 As Integer, ByVal weekOfYear As Integer) As DateTime
        Dim datDate As Date
        Dim year2 As Integer = Year(CType(Date.Now, String))
        Dim jan1 As New DateTime(year2, 1, 1)
        Dim intMonth As Integer
        Dim intDay As Integer
        Dim intYear As Integer
        Dim strYear As String
        Dim strLastDigit As String

        datDate = DateAdd("ww", (weekOfYear - 1), jan1)
        intMonth = Month(datDate)
        intDay = Day(datDate)
        intYear = Year(datDate)
        strLastDigit = Right(CType(intYear, String), 1)
        If year1 > CType(strLastDigit, Integer) Then
            strYear = "200"
            strYear = strYear & year1
        Else
            strYear = Left(CType(intYear, String), 3)
            strYear = strYear & year1
        End If
        

        Return intMonth & "/" & intDay & "/" & strYear

    End Function

    ' Properties
    Public Property ConnectionString() As Object
        Get
            Return Me._ConnectionString
        End Get
        Set(ByVal value As Object)
            Me._ConnectionString = Conversions.ToString(value)
        End Set
    End Property


    ' Fields
    Private _ConnectionString As String = ""





End Class
