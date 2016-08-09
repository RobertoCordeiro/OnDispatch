Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class PartnerAgentResumeTypeRecord

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
        ''' <param name="lngPartnerAgentResumeTypeID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngPartnerAgentResumeTypeID As Long, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Load(_PartnerAgentResumeTypeID)
        End Sub

        ''' <summary>
        '''  Adds a new PartnerResumeType record to the database.
        ''' </summary>
        ''' <param name="lngPartnerAgentID">The value for the PartnerID portion of the record</param>
        ''' <param name="lngResumeTypeID">The value for the ResumeTypeID portion of the record</param>
        Public Sub Add(ByVal lngPartnerAgentID As Long, ByVal lngResumeTypeID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddPartnerAgentResumeType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngPartnerAgentResumeTypeID As Long = 0
                cmd.Parameters.Add("@PartnerAgentID", SqlDbType.Int).Value = lngPartnerAgentID
                cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = lngResumeTypeID
                cnn.Open()
                cmd.Connection = cnn
                lngPartnerAgentResumeTypeID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngPartnerAgentResumeTypeID > 0 Then
                    Load(lngPartnerAgentResumeTypeID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a PartnerResumeType record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngPartnerAgentResumeTypeID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetPartnerAgentResumeType")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentResumeTypeID", SqlDbType.Int).Value = lngPartnerAgentResumeTypeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._PartnerAgentResumeTypeID = CType(dtr("PartnerAgentResumeTypeID"), Long)
                    Me._PartnerAgentID = CType(dtr("PartnerAgentID"), Long)
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
                Dim cnn As New SqlClient.SqlConnection(Me._ConnectionString)
                cnn.Open()
                Dim obj As New PartnerAgentResumeTypeRecord(Me._PartnerAgentResumeTypeID, Me._ConnectionString)
                obj.Load(Me._PartnerAgentResumeTypeID)
                If obj.PartnerID <> Me._PartnerAgentID Then
                    UpdatePartnerID(Me._PartnerAgentID, cnn)
                    strTemp = "PartnerID Changed to '" & Me._PartnerAgentID & "' from '" & obj.PartnerID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.ResumeTypeID <> Me._ResumeTypeID Then
                    UpdateResumeTypeID(Me._ResumeTypeID, cnn)
                    strTemp = "ResumeTypeID Changed to '" & Me._ResumeTypeID & "' from '" & obj.ResumeTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(Me._PartnerAgentResumeTypeID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded PartnerResumeType Record
        ''' </summary>
        Public Sub Delete()
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(_ConnectionString)
                Dim cmd As New SqlCommand("spRemovePartnerAgentResumeType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PartnerAgentResumeTypeID", SqlDbType.Int).Value = Me._PartnerAgentResumeTypeID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(Me._PartnerAgentResumeTypeID)
            End If
        End Sub

#End Region


#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the PartnerID field for the currently loaded record
        ''' </summary>
        Public Property PartnerID() As Long
            Get
                Return Me._PartnerAgentID
            End Get
            Set(ByVal value As Long)
                Me._PartnerAgentID = value
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

#End Region

#Region "ReadOnly Properties"

        ''' <summary>
        ''' Returns the PartnerResumeTypeID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property PartnerAgentResumeTypeID() As Long
            Get
                Return Me._PartnerAgentResumeTypeID
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

#Region "Private Sub-Routines"

        ''' <summary>
        ''' Clears all values except for the connection string
        ''' </summary>
        Private Sub ClearValues()
            Me._PartnerAgentResumeTypeID = 0
            Me._PartnerAgentID = 0
            Me._ResumeTypeID = 0
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
        ''' Updates the PartnerID field for this record.
        ''' </summary>
        ''' <param name="NewPartnerID">The new value for thePartnerID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdatePartnerID(ByVal NewPartnerID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentResumeTypePartnerID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentResumeTypeID", SqlDbType.Int).Value = Me._PartnerAgentResumeTypeID
            cmd.Parameters.Add("@PartnerID", SqlDbType.Int).Value = NewPartnerID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the ResumeTypeID field for this record.
        ''' </summary>
        ''' <param name="NewResumeTypeID">The new value for theResumeTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateResumeTypeID(ByVal NewResumeTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdatePartnerAgentResumeTypeResumeTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PartnerAgentResumeTypeID", SqlDbType.Int).Value = Me._PartnerAgentResumeTypeID
            cmd.Parameters.Add("@ResumeTypeID", SqlDbType.Int).Value = NewResumeTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

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
            Dim obj As New PartnerAgentResumeTypeRecord(Me._PartnerAgentResumeTypeID, Me._ConnectionString)
            obj.Load(Me._PartnerAgentResumeTypeID)
            If obj.PartnerID <> Me._PartnerAgentID Then
                blnReturn = True
            End If
            If obj.ResumeTypeID <> Me._ResumeTypeID Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region

#Region "Private Members"

        Private _PartnerAgentResumeTypeID As Long = 0
        Private _PartnerAgentID As Long = 0
        Private _ResumeTypeID As Long = 0
        Private _ConnectionString As String = ""

#End Region

    End Class
End Namespace
