Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ActionObjectRecord
        ' Methods
        Public Sub New()
            Me._ObjectID = -1
            Me._ObjectKeyName = ""
            Me._ObjectName = ""
            Me._ObjectHandle = ""
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal lngObjectID As Long, ByVal strConnectionstring As String)
            Me._ObjectID = -1
            Me._ObjectKeyName = ""
            Me._ObjectName = ""
            Me._ObjectHandle = ""
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionstring
            Me.Load(lngObjectID)
        End Sub

        Private Sub ClearValues()
            Me._ObjectID = -1
            Me._ObjectKeyName = ""
            Me._ObjectName = ""
            Me._ObjectHandle = ""
        End Sub

        Public Sub Load(ByVal lngObjectID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetActionObject")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ObjectID", SqlDbType.Int).Value = lngObjectID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ObjectID = Conversions.ToLong(dtr.Item("ObjectID"))
                    Me._ObjectKeyName = dtr.Item("ObjectKeyName").ToString
                    Me._ObjectName = dtr.Item("ObjectName").ToString
                    Me._ObjectHandle = dtr.Item("ObjectHandle").ToString
                End If
                cnn.Close
            Else
                Me.ClearValues
            End If
        End Sub


        ' Properties
        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value.Trim
            End Set
        End Property

        Public ReadOnly Property ObjectHandle As String
            Get
                Return Me._ObjectHandle
            End Get
        End Property

        Public ReadOnly Property ObjectID As Long
            Get
                Return Me._ObjectID
            End Get
        End Property

        Public ReadOnly Property ObjectKeyName As String
            Get
                Return Me._ObjectKeyName
            End Get
        End Property

        Public ReadOnly Property ObjectName As String
            Get
                Return Me._ObjectName
            End Get
        End Property


        ' Fields
        Private _ConnectionString As String
        Private _ObjectHandle As String
        Private _ObjectID As Long
        Private _ObjectKeyName As String
        Private _ObjectName As String

        ' Nested Types
        Public Enum ActionObjects
            ' Fields
            Application = 2
            CompanyInfo = 13
            CustomerAddresses = 8
            CustomerIdentifications = 9
            CustomerPhoneNumbers = 7
            Customers = 6
            EntityTypes = &H13
            FAQ = &H1A
            FaqQuestion = &H1B
            InvoiceItems = 11
            Invoices = 10
            Manufacturer = &H1C
            Model = 30
            None = 0
            PartnerAddress = &H27
            PartnerPhoneNumber = &H26
            PaymentMethods = 12
            Payments = 14
            PersonalTitles = &H10
            Pictures = 3
            ProductType = &H1D
            ResumeAddresses = &H18
            ResumePhones = &H16
            ResumeRate = &H19
            Resumes = &H17
            Roles = 15
            Service = &H20
            ServiceType = &H1F
            ShippingLabel = &H24
            SkillSetQuestionAssigmnet = &H25
            Suffixes = &H11
            Ticket = &H21
            TicketComponent = &H23
            TicketPhoneNumber = &H22
            User = 1
            UserAddresses = 4
            UserPhoneNumbers = 5
            Vendors = &H12
            VendorTypes = 20
            WebLogins = &H15
        End Enum
    End Class
End Namespace

