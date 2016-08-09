Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class LayerResumeTypeAssignmentRecord


        Public Sub New(ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Me._LayerID = 0
            Me._ResumeTypeID = 0
        End Sub
        Public Sub New()
            ClearValues()
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object and loads by the passed in Primary Key
        ''' </summary>
        ''' <param name="lngLayerResumeTypeAssignmentID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngLayerResumeTypeAssignmentID As Long, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Load(Me._LayerResumeTypeAssignmentID)
        End Sub

        ''' <summary>
        '''  Adds a new LayerResumeTypeAssignment record to the database.
        ''' </summary>
        ''' <param name="lngLayerID">The value for the LayerID portion of the record</param>
        ''' <param name="lngResumeTypeID">The value for the ResumeTypeID portion of the record</param>
        Public Sub Add(ByVal lngLayerID As Long, ByVal lngResumeTypeID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddLayerResumeTypeAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngLayerResumeTypeAssignmentID As Long = 0
                cmd.Parameters.Add("@LayerID", SqlDbType.Int).Value = lngLayerID
                cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = lngResumeTypeID
                cnn.Open()
                cmd.Connection = cnn
                lngLayerResumeTypeAssignmentID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngLayerResumeTypeAssignmentID > 0 Then
                    Load(lngLayerResumeTypeAssignmentID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a LayerResumeTypeAssignment record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngLayerResumeTypeAssignmentID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetLayerResumeTypeAssignment")
                Dim dtr As SqlClient.SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@LayerResumeTypeAssignmentID", SqlDbType.Int).Value = lngLayerResumeTypeAssignmentID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._LayerResumeTypeAssignmentID = CType(dtr("LayerResumeTypeAssignmentID"), Long)
                    Me._LayerID = CType(dtr("LayerID"), Long)
                    Me._ResumeTypeID = CType(dtr("ResumeTypeID"), Long)
                Else
                    ClearValues()
                End If
                cnn.Close()
            End If
        End Sub

        ''' <summary>
        ''' Saves any changes to the record since it was last loaded
        ''' </summary>
        ''' <param name="strChangeLog">The string variable you want manipulated that returns a log of changes.</param>
        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open()
                Dim obj As New LayerResumeTypeAssignmentRecord(Me._LayerResumeTypeAssignmentID, Me._ConnectionString)
                obj.Load(Me._LayerResumeTypeAssignmentID)
                If obj.LayerID <> Me._LayerID Then
                    UpdateLayerID(Me._LayerID, cnn)
                    strTemp = "LayerID Changed to '" & Me._LayerID & "' from '" & obj.LayerID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ResumeTypeID <> Me._ResumeTypeID Then
                    UpdateResumeTypeID(Me._ResumeTypeID, cnn)
                    strTemp = "ResumeTypeID Changed to '" & Me._ResumeTypeID & "' from '" & obj.ResumeTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(Me._LayerResumeTypeAssignmentID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded LayerResumeTypeAssignment Record
        ''' </summary>
        Public Sub Delete()
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveLayerResumeTypeAssignment")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@LayerResumeTypeAssignmentID", SqlDbType.Int).Value = Me._LayerResumeTypeAssignmentID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(Me._LayerResumeTypeAssignmentID)
            End If
        End Sub

        ''' <summary>
        ''' Clears all values except for the connection string
        ''' </summary>
        Private Sub ClearValues()
            Me._LayerResumeTypeAssignmentID = 0
            Me._LayerID = 0
            Me._ResumeTypeID = 0
        End Sub


        
        ''' <summary>
        ''' Returns the LayerResumeTypeAssignmentID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property LayerResumeTypeAssignmentID() As Long
            Get
                Return Me._LayerResumeTypeAssignmentID
            End Get
        End Property

        ''' <summary>
        ''' Returns a boolean value indicating if the object has changed
        ''' since the last time it was loaded.
        ''' </summary>
        Public ReadOnly Property Modified() As Boolean
            Get
                Return HasChanged()
            End Get
        End Property



        ''' <summary>
        ''' Returns a boolean indicating if the object has changed
        ''' </summary>
        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New LayerResumeTypeAssignmentRecord(Me._LayerResumeTypeAssignmentID, Me._ConnectionString)
            obj.Load(Me._LayerResumeTypeAssignmentID)
            If obj.LayerID <> Me._LayerID Then
                blnReturn = True
            End If
            If obj.ResumeTypeID <> Me._ResumeTypeID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        ''' <summary>
        ''' Appends a line to a change log
        ''' </summary>
        ''' <param name="strLog">The log to append to</param>
        ''' <param name="strNewLine">The line to append to the log</param>
        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If strLog.Length > 0 Then
                strReturn = strLog & Environment.NewLine
            End If
            strReturn &= strNewLine
            strLog = strReturn
        End Sub

        ''' <summary>
        ''' Updates the LayerID field for this record.
        ''' </summary>
        ''' <param name="NewLayerID">The new value for theLayerID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateLayerID(ByVal NewLayerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateLayerResumeTypeAssignmentLayerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@LayerResumeTypeAssignmentID", SqlDbType.Int).Value = Me._LayerResumeTypeAssignmentID
            cmd.Parameters.Add("@LayerID", SqlDbType.Int).Value = NewLayerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ResumeTypeID field for this record.
        ''' </summary>
        ''' <param name="NewResumeTypeID">The new value for theResumeTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateResumeTypeID(ByVal NewResumeTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateLayerResumeTypeAssignmentResumeTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@LayerResumeTypeAssignmentID", SqlDbType.Int).Value = Me._LayerResumeTypeAssignmentID
            cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = NewResumeTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        Public Property LayerID() As Long
            Get
                Return Me._LayerID
            End Get
            Set(ByVal value As Long)
                Me._LayerID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the ResumeTypeID field for the currently loaded record
        ''' </summary>
        Public Property ResumeTypeID() As Long
            Get
                Return Me._ResumeTypeID
            End Get
            Set(ByVal value As Long)
                Me._ResumeTypeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the connection string to the database
        ''' </summary>
        Public Property ConnectionString() As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property


        Private _LayerResumeTypeAssignmentID As Long = 0
        Private _LayerID As Long = 0
        Private _ResumeTypeID As Long = 0
        Private _ConnectionString As String = ""
    End Class
End Namespace