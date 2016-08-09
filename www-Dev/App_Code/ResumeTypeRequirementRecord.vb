Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class ResumeTypeRequirementRecord

#Region "Public Sub-Routines"

        ''' <summary>
        ''' Overloaded, initializes the object
        ''' </summary>
        Public Sub New()
            ClearValues()
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object with a given connection string
        ''' </summary>
        ''' <param name="strConnectionString">The connection string to the database the customer is contained in</param>
        Public Sub New(ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
        End Sub

        ''' <summary>
        ''' Overloaded, Initializes the object and loads by the passed in Primary Key
        ''' </summary>
        ''' <param name="lngResumeTypeRequirementID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngResumeTypeRequirementID As Long, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Load(Me._ResumeTypeRequirementID)
        End Sub

        ''' <summary>
        '''  Adds a new ResumeTypeRequirement record to the database.
        ''' </summary>
        ''' <param name="lngResumeTypeID">The value for the ResumeTypeID portion of the record</param>
        ''' <param name="lngRequirementID">The value for the RequirementID portion of the record</param>
        Public Sub Add(ByVal lngResumeTypeID As Long, ByVal lngRequirementID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddResumeTypeRequirement")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngResumeTypeRequirementID As Long = 0
                cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = lngResumeTypeID
                cmd.Parameters.Add("@RequirementID", SqlDbType.Int).Value = lngRequirementID
                cnn.Open()
                cmd.Connection = cnn
                lngResumeTypeRequirementID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngResumeTypeRequirementID > 0 Then
                    Load(lngResumeTypeRequirementID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a ResumeTypeRequirement record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngResumeTypeRequirementID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetResumeTypeRequirement")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeTypeRequirementID", SqlDbType.Int).Value = lngResumeTypeRequirementID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ResumeTypeRequirementID = CType(dtr("ResumeTypeRequirementID"), Long)
                    Me._ResumeTypeID = CType(dtr("ResumeTypeID"), Long)
                    Me._RequirementID = CType(dtr("RequirementID"), Long)
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
                Dim obj As New ResumeTypeRequirementRecord(Me._ResumeTypeRequirementID, Me._ConnectionString)
                obj.Load(Me._ResumeTypeRequirementID)
                If obj.ResumeTypeID <> Me._ResumeTypeID Then
                    UpdateResumeTypeID(Me._ResumeTypeID, cnn)
                    strTemp = "ResumeTypeID Changed to '" & Me._ResumeTypeID & "' from '" & obj.ResumeTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.RequirementID <> Me._RequirementID Then
                    UpdateRequirementID(Me._RequirementID, cnn)
                    strTemp = "RequirementID Changed to '" & Me._RequirementID & "' from '" & obj.RequirementID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(Me._ResumeTypeRequirementID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded ResumeTypeRequirement Record
        ''' </summary>
        Public Sub Delete()
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveResumeTypeRequirement")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ResumeTypeRequirementID", SqlDbType.Int).Value = Me._ResumeTypeRequirementID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(Me._ResumeTypeRequirementID)
            End If
        End Sub

#End Region


#Region "Read/Write Properties"

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
        ''' Returns/Sets the RequirementID field for the currently loaded record
        ''' </summary>
        Public Property RequirementID() As Long
            Get
                Return Me._RequirementID
            End Get
            Set(ByVal value As Long)
                Me._RequirementID = value
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

#End Region

#Region "ReadOnly Properties"

        ''' <summary>
        ''' Returns the ResumeTypeRequirementID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property ResumeTypeRequirementID() As Long
            Get
                Return Me._ResumeTypeRequirementID
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

#End Region

#Region "Private Functions"

        ''' <summary>
        ''' Returns a string that has been trimmed and trunced down to its max length
        ''' </summary>
        ''' <param name="strInput">The string to manipulate</param>
        ''' <param name="intMaxLength">The maximum length the string can be</param>
        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If strReturn.Trim.Length <= intMaxLength Then
                strReturn = strReturn.Trim
            Else
                strReturn = strReturn.Substring(0, intMaxLength)
                strReturn = strReturn.Trim
            End If
            Return strReturn
        End Function

        ''' <summary>
        ''' Returns a boolean indicating if the object has changed
        ''' </summary>
        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ResumeTypeRequirementRecord(Me._ResumeTypeRequirementID, Me._ConnectionString)
            obj.Load(Me._ResumeTypeRequirementID)
            If obj.ResumeTypeID <> Me._ResumeTypeID Then
                blnReturn = True
            End If
            If obj.RequirementID <> Me._RequirementID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region
#Region "Private Sub-Routines"

        ''' <summary>
        ''' Clears all values except for the connection string
        ''' </summary>
        Private Sub ClearValues()
            Me._ResumeTypeRequirementID = 0
            Me._ResumeTypeID = 0
            Me._RequirementID = 0
        End Sub

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
        ''' Updates the ResumeTypeID field for this record.
        ''' </summary>
        ''' <param name="NewResumeTypeID">The new value for theResumeTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateResumeTypeID(ByVal NewResumeTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeTypeRequirementResumeTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeTypeRequirementID", SqlDbType.Int).Value = Me._ResumeTypeRequirementID
            cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = NewResumeTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the RequirementID field for this record.
        ''' </summary>
        ''' <param name="NewRequirementID">The new value for theRequirementID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateRequirementID(ByVal NewRequirementID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateResumeTypeRequirementRequirementID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ResumeTypeRequirementID", SqlDbType.Int).Value = Me._ResumeTypeRequirementID
            cmd.Parameters.Add("@RequirementID", SqlDbType.Int).Value = NewRequirementID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

#End Region


#Region "Private Members"

        Private _ResumeTypeRequirementID As Long = 0
        Private _ResumeTypeID As Long = 0
        Private _RequirementID As Long = 0
        Private _ConnectionString As String = ""

#End Region
    End Class
End Namespace
