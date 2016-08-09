Imports System

Namespace BridgesInterface
    Public Class UserPermissions
        ' Methods
        Public Sub New()
            Me._EditAutoFills = False
            Me._EditTypes = False
            Me._EditUsers = False
            Me._EditRoles = False
            Me._EditCustomers = False
            Me._ViewInvoiceReport = False
            Me._EditCompanyInfo = False
            Me._EditCouriers = False
            Me.ClearValues
        End Sub

        Public Sub New(ByVal rolInput As RoleRecord)
            Me._EditAutoFills = False
            Me._EditTypes = False
            Me._EditUsers = False
            Me._EditRoles = False
            Me._EditCustomers = False
            Me._ViewInvoiceReport = False
            Me._EditCompanyInfo = False
            Me._EditCouriers = False
            Me._EditAutoFills = rolInput.EditAutoFills
            Me._EditTypes = rolInput.EditTypes
            Me._EditUsers = rolInput.EditUsers
            Me._EditRoles = rolInput.EditRoles
            Me._EditCustomers = rolInput.EditCustomers
            Me._EditCompanyInfo = rolInput.EditCompanyInfo
            Me._EditCouriers = rolInput.EditCouriers
        End Sub

        Public Sub New(ByVal blnEditAutoFills As Boolean, ByVal blnEditTypes As Boolean, ByVal blnEditUsers As Boolean, ByVal blnEditRoles As Boolean, ByVal blnEditCustomers As Boolean, ByVal blnEditCOmpanyInfo As Boolean, ByVal blnEditCouriers As Boolean)
            Me._EditAutoFills = False
            Me._EditTypes = False
            Me._EditUsers = False
            Me._EditRoles = False
            Me._EditCustomers = False
            Me._ViewInvoiceReport = False
            Me._EditCompanyInfo = False
            Me._EditCouriers = False
            Me._EditAutoFills = blnEditAutoFills
            Me._EditTypes = blnEditTypes
            Me._EditUsers = blnEditUsers
            Me._EditRoles = blnEditRoles
            Me._EditCompanyInfo = blnEditCOmpanyInfo
            Me._EditCouriers = blnEditCouriers
            Me._EditCustomers = blnEditCustomers
        End Sub

        Public Sub Append(ByVal RolInput As RoleRecord)
            If RolInput.EditAutoFills Then
                Me._EditAutoFills = True
            End If
            If RolInput.EditRoles Then
                Me._EditRoles = True
            End If
            If RolInput.EditTypes Then
                Me._EditTypes = True
            End If
            If RolInput.EditUsers Then
                Me._EditUsers = True
            End If
            If RolInput.EditCustomers Then
                Me._EditCustomers = True
            End If
            If RolInput.ViewInvoiceReport Then
                Me._ViewInvoiceReport = True
            End If
            If RolInput.EditCompanyInfo Then
                Me._EditCompanyInfo = True
            End If
            If RolInput.EditCouriers Then
                Me._EditCouriers = True
            End If
        End Sub

        Private Sub ClearValues()
            Me._EditAutoFills = False
            Me._EditTypes = False
            Me._EditUsers = False
            Me._EditRoles = False
            Me._EditCustomers = False
            Me._EditCompanyInfo = False
            Me._EditCouriers = False
        End Sub


        ' Properties
        Public ReadOnly Property EditAutoFills As Boolean
            Get
                Return Me._EditAutoFills
            End Get
        End Property

        Public ReadOnly Property EditCompanyInfo As Boolean
            Get
                Return Me._EditCompanyInfo
            End Get
        End Property

        Public ReadOnly Property EditCouriers As Boolean
            Get
                Return Me._EditCouriers
            End Get
        End Property

        Public ReadOnly Property EditCustomers As Boolean
            Get
                Return Me._EditCustomers
            End Get
        End Property

        Public ReadOnly Property EditRoles As Boolean
            Get
                Return Me._EditRoles
            End Get
        End Property

        Public ReadOnly Property EditTypes As Boolean
            Get
                Return Me._EditTypes
            End Get
        End Property

        Public ReadOnly Property EditUsers As Boolean
            Get
                Return Me._EditUsers
            End Get
        End Property

        Public ReadOnly Property ViewInvoiceReport As Boolean
            Get
                Return Me._ViewInvoiceReport
            End Get
        End Property


        ' Fields
        Private _EditAutoFills As Boolean
        Private _EditCompanyInfo As Boolean
        Private _EditCouriers As Boolean
        Private _EditCustomers As Boolean
        Private _EditRoles As Boolean
        Private _EditTypes As Boolean
        Private _EditUsers As Boolean
        Private _ViewInvoiceReport As Boolean
    End Class
End Namespace

