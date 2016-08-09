Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface

    Public Class Validators

        'Methods

        Public Sub New()
            MyBase.New()
        End Sub


        Public Function IsValidEmail(ByVal strEmail As String) As Boolean
            Return System.Text.RegularExpressions.Regex.IsMatch(strEmail, "^[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$")
        End Function


        Public Function IsValidPasswordFormat(ByVal strPassword As String) As Boolean
            If Not (Not ((strPassword.Trim().Length >= 8))) Then
                Return System.Text.RegularExpressions.Regex.IsMatch(strPassword.Trim(), "(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{8,32})$")
            End If
            Return False
        End Function


        Public Function IsValidUrl(ByVal strUrl As String) As Boolean
            Return System.Text.RegularExpressions.Regex.IsMatch(strUrl, "^(ht|f)tp(s?)\:\/\/[a-zA-Z0-9\-\._]+(\.[a-zA-Z0-9\-\._]+){2,}(\/?)([a-zA-Z0-9\-\.\?\,\'\/\\\+&%\$#_]*)?$")
        End Function



    End Class

End Namespace