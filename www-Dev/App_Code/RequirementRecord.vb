Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class RequirementRecord

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
        ''' <param name="lngRequirementID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngRequirementID As Long, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Load(Me._RequirementID)
        End Sub

        ''' <summary>
        '''  Adds a new Requirement record to the database.
        ''' </summary>
        ''' <param name="lngRequirementTypeID">The value for the RequirementTypeID portion of the record</param>
        ''' <param name="strRequirementName">The value for the RequirementName portion of the record</param>
        ''' <param name="blnActive">The value for the Active portion of the record</param>
        Public Sub Add(ByVal lngRequirementTypeID As Long, ByVal strRequirementName As String, ByVal blnActive As Boolean)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddRequirement")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngRequirementID As Long = 0
                cmd.Parameters.Add("@RequirementTypeID", SqlDbType.Int).Value = lngRequirementTypeID
                cmd.Parameters.Add("@RequirementName", SqlDbType.VarChar, TrimTrunc(strRequirementName, RequirementNameMaxLength).Length).Value = TrimTrunc(strRequirementName, RequirementNameMaxLength)
                cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = blnActive
                cnn.Open()
                cmd.Connection = cnn
                lngRequirementID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngRequirementID > 0 Then
                    Load(lngRequirementID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a Requirement record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngRequirementID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetRequirement")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RequirementID", SqlDbType.Int).Value = lngRequirementID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._RequirementID = CType(dtr("RequirementID"), Long)
                    Me._RequirementTypeID = CType(dtr("RequirementTypeID"), Long)
                    Me._RequirementName = dtr("RequirementName").ToString
                    Me._Active = CType(dtr("Active"), Boolean)
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
                Dim obj As New RequirementRecord(Me._RequirementID, Me._ConnectionString)
                obj.Load(Me._RequirementID)
                If obj.RequirementTypeID <> Me._RequirementTypeID Then
                    UpdateRequirementTypeID(Me._RequirementTypeID, cnn)
                    strTemp = "RequirementTypeID Changed to '" & Me._RequirementTypeID & "' from '" & obj.RequirementTypeID & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.RequirementName <> Me._RequirementName Then
                    UpdateRequirementName(Me._RequirementName, cnn)
                    strTemp = "RequirementName Changed to '" & Me._RequirementName & "' from '" & obj.RequirementName & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                If obj.Active <> Me._Active Then
                    UpdateActive(Me._Active, cnn)
                    strTemp = "Active Changed to '" & Me._Active & "' from '" & obj.Active & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(Me._RequirementID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded Requirement Record
        ''' </summary>
        Public Sub Delete()
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveRequirement")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RequirementID", SqlDbType.Int).Value = Me._RequirementID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(Me._RequirementID)
            End If
        End Sub

#End Region


#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the RequirementTypeID field for the currently loaded record
        ''' </summary>
        Public Property RequirementTypeID() As Long
            Get
                Return Me._RequirementTypeID
            End Get
            Set(ByVal value As Long)
                Me._RequirementTypeID = value
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the RequirementName field for the currently loaded record
        ''' </summary>
        Public Property RequirementName() As String
            Get
                Return Me._RequirementName
            End Get
            Set(ByVal value As String)
                Me._RequirementName = TrimTrunc(value, RequirementNameMaxLength)
            End Set
        End Property

        ''' <summary>
        ''' Returns/Sets the Active field for the currently loaded record
        ''' </summary>
        Public Property Active() As Boolean
            Get
                Return Me._Active
            End Get
            Set(ByVal value As Boolean)
                Me._Active = value
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
        ''' Returns the RequirementID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property RequirementID() As Long
            Get
                Return Me._RequirementID
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
            Me._RequirementID = 0
            Me._RequirementTypeID = 0
            Me._RequirementName = ""
            Me._Active = False
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
        ''' Updates the RequirementTypeID field for this record.
        ''' </summary>
        ''' <param name="NewRequirementTypeID">The new value for theRequirementTypeID field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateRequirementTypeID(ByVal NewRequirementTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRequirementRequirementTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RequirementID", SqlDbType.Int).Value = Me._RequirementID
            cmd.Parameters.Add("@RequirementTypeID", SqlDbType.Int).Value = NewRequirementTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the RequirementName field for this record.
        ''' </summary>
        ''' <param name="NewRequirementName">The new value for theRequirementName field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateRequirementName(ByVal NewRequirementName As String, ByRef cnn As SqlClient.sqlConnection)
            Dim cmd As New SqlCommand("spUpdateRequirementRequirementName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RequirementID", SqlDbType.Int).Value = Me._RequirementID
            cmd.Parameters.Add("@RequirementName", SqlDbType.varchar, TrimTrunc(NewRequirementName, RequirementNameMaxLength).Length).value = TrimTrunc(NewRequirementName, RequirementNameMaxLength)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery()
        End Sub

        ''' <summary>
        ''' Updates the Active field for this record.
        ''' </summary>
        ''' <param name="NewActive">The new value for theActive field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateActive(ByVal NewActive As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRequirementActive")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RequirementID", SqlDbType.Int).Value = Me._RequirementID
            cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = NewActive
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
            Dim obj As New RequirementRecord(Me._RequirementID, Me._ConnectionString)
            obj.Load(Me._RequirementID)
            If obj.RequirementTypeID <> Me._RequirementTypeID Then
                blnReturn = True
            End If
            If obj.RequirementName <> Me._RequirementName Then
                blnReturn = True
            End If
            If obj.Active <> Me._Active Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region

#Region "Private Constants"

        Private Const RequirementNameMaxLength As Integer = 50

#End Region

#Region "Private Members"

        Private _RequirementID As Long = 0
        Private _RequirementTypeID As Long = 0
        Private _RequirementName As String = ""
        Private _Active As Boolean = False
        Private _ConnectionString As String = ""

#End Region

    End Class
End Namespace
