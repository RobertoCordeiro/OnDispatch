Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices

Namespace BridgesInterface
    Public Class RequirementTypeRecord

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
        ''' <param name="lngRequirementTypeID">The primary key of the record you wish to load</param>
        ''' <param name="strConnectionString">The connection string to the database</param>
        ''' <remarks></remarks>
        Public Sub New(ByVal lngRequirementTypeID As Long, ByVal strConnectionString As String)
            Me._ConnectionString = strConnectionString
            Load(Me._RequirementTypeID)
        End Sub

        ''' <summary>
        '''  Adds a new RequirementType record to the database.
        ''' </summary>
        ''' <param name="strRequirementType">The value for the RequirementType portion of the record</param>
        Public Sub Add(ByVal strRequirementType As String)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddRequirementType")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngRequirementTypeID As Long = 0
                cmd.Parameters.Add("@RequirementType", SqlDbType.VarChar, TrimTrunc(strRequirementType, RequirementTypeMaxLength).Length).Value = TrimTrunc(strRequirementType, RequirementTypeMaxLength)
                cnn.Open()
                cmd.Connection = cnn
                lngRequirementTypeID = CType(cmd.ExecuteScalar, Long)
                cnn.Close()
                If lngRequirementTypeID > 0 Then
                    Load(lngRequirementTypeID)
                End If
            End If
        End Sub

        ''' <summary>
        ''' Loads a RequirementType record by its primary key
        ''' </summary>
        Public Sub Load(ByVal lngRequirementTypeID As Long)
            If Me._ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetRequirementType")
                Dim dtr As SqlDataReader
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RequirementTypeID", SqlDbType.Int).Value = lngRequirementTypeID
                cnn.Open()
                cmd.Connection = cnn
                dtr = cmd.ExecuteReader
                If dtr.Read Then
                    Me._RequirementTypeID = CType(dtr("RequirementTypeID"), Long)
                    Me._RequirementType = dtr("RequirementType").ToString
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
                Dim obj As New RequirementTypeRecord(Me._RequirementTypeID, Me._ConnectionString)
                obj.Load(Me._RequirementTypeID)
                If obj.RequirementType <> Me._RequirementType Then
                    UpdateRequirementType(Me._RequirementType, cnn)
                    strTemp = "RequirementType Changed to '" & Me._RequirementType & "' from '" & obj.RequirementType & "'"
                    AppendChangeLog(strChangeLog, strTemp)
                End If
                cnn.Close()
                Load(Me._RequirementTypeID)
            Else
                ClearValues()
            End If
        End Sub

        ''' <summary>
        ''' Deletes the currently loaded RequirementType Record
        ''' </summary>
        Public Sub Delete()
            If _ConnectionString.Trim.Length > 0 Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveRequirementType")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RequirementTypeID", SqlDbType.Int).Value = Me._RequirementTypeID
                cnn.Open()
                cmd.Connection = cnn
                cmd.ExecuteNonQuery()
                cnn.Close()
                Load(Me._RequirementTypeID)
            End If
        End Sub

#End Region



#Region "Read/Write Properties"

        ''' <summary>
        ''' Returns/Sets the RequirementType field for the currently loaded record
        ''' </summary>
        Public Property RequirementType() As String
            Get
                Return Me._RequirementType
            End Get
            Set(ByVal value As String)
                Me._RequirementType = TrimTrunc(value, RequirementTypeMaxLength)
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
        ''' Returns the RequirementTypeID field for the currently loaded record
        ''' </summary>
        Public ReadOnly Property RequirementTypeID() As Long
            Get
                Return Me._RequirementTypeID
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
            Me._RequirementTypeID = 0
            Me._RequirementType = ""
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
        ''' Updates the RequirementType field for this record.
        ''' </summary>
        ''' <param name="NewRequirementType">The new value for theRequirementType field</param>
        ''' <param name="cnn">The Connection to use</param>
        Private Sub UpdateRequirementType(ByVal NewRequirementType As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateRequirementTypeRequirementType")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@RequirementTypeID", SqlDbType.Int).Value = Me._RequirementTypeID
            cmd.Parameters.Add("@RequirementType", SqlDbType.VarChar, TrimTrunc(NewRequirementType, RequirementTypeMaxLength).Length).Value = TrimTrunc(NewRequirementType, RequirementTypeMaxLength)
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
            Dim obj As New RequirementTypeRecord(Me._RequirementTypeID, Me._ConnectionString)
            obj.Load(Me._RequirementTypeID)
            If obj.RequirementType <> Me._RequirementType Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

#End Region


#Region "Private Constants"

        Private Const RequirementTypeMaxLength As Integer = 50

#End Region

#Region "Private Members"

        Private _RequirementTypeID As Long = 0
        Private _RequirementType As String = ""
        Private _ConnectionString As String = ""

#End Region
    End Class
End Namespace
