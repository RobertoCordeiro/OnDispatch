Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace BridgesInterface
    Public Class ZipCodeRecord
        ' Methods
        Public Sub New()
            Me._ZipCodeID = 0
            Me._CreatedBy = 0
            Me._StateID = 0
            Me._CityTypeID = 0
            Me._ZipCode = ""
            Me._City = ""
            Me._AreaCode = ""
            Me._CityAliasName = ""
            Me._CityAliasAbbr = ""
            Me._CountyName = ""
            Me._StateFIPS = 0
            Me._CountyFIPS = 0
            Me._TimeZone = 0
            Me._DayLightSavings = True
            Me._Latitude = 0
            Me._Longitude = 0
            Me._Elevation = 0
            Me._MSA2000 = 0
            Me._PMSA = 0
            Me._CBSA = 0
            Me._CBSADiv = 0
            Me._CBSATitle = ""
            Me._PersonsPerHouseHold = 0
            Me._Population = 0
            Me._CountiesArea = 0
            Me._HouseHolds = 0
            Me._WhitePopulation = 0
            Me._BlackPopulation = 0
            Me._HispanicPopulation = 0
            Me._IncomePerHouseHold = 0
            Me._AverageHouseValue = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me.ClearValues
        End Sub

        Public Sub New(ByVal strConnectionString As String)
            Me._ZipCodeID = 0
            Me._CreatedBy = 0
            Me._StateID = 0
            Me._CityTypeID = 0
            Me._ZipCode = ""
            Me._City = ""
            Me._AreaCode = ""
            Me._CityAliasName = ""
            Me._CityAliasAbbr = ""
            Me._CountyName = ""
            Me._StateFIPS = 0
            Me._CountyFIPS = 0
            Me._TimeZone = 0
            Me._DayLightSavings = True
            Me._Latitude = 0
            Me._Longitude = 0
            Me._Elevation = 0
            Me._MSA2000 = 0
            Me._PMSA = 0
            Me._CBSA = 0
            Me._CBSADiv = 0
            Me._CBSATitle = ""
            Me._PersonsPerHouseHold = 0
            Me._Population = 0
            Me._CountiesArea = 0
            Me._HouseHolds = 0
            Me._WhitePopulation = 0
            Me._BlackPopulation = 0
            Me._HispanicPopulation = 0
            Me._IncomePerHouseHold = 0
            Me._AverageHouseValue = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
        End Sub

        Public Sub New(ByVal lngZipCodeID As Long, ByVal strConnectionString As String)
            Me._ZipCodeID = 0
            Me._CreatedBy = 0
            Me._StateID = 0
            Me._CityTypeID = 0
            Me._ZipCode = ""
            Me._City = ""
            Me._AreaCode = ""
            Me._CityAliasName = ""
            Me._CityAliasAbbr = ""
            Me._CountyName = ""
            Me._StateFIPS = 0
            Me._CountyFIPS = 0
            Me._TimeZone = 0
            Me._DayLightSavings = True
            Me._Latitude = 0
            Me._Longitude = 0
            Me._Elevation = 0
            Me._MSA2000 = 0
            Me._PMSA = 0
            Me._CBSA = 0
            Me._CBSADiv = 0
            Me._CBSATitle = ""
            Me._PersonsPerHouseHold = 0
            Me._Population = 0
            Me._CountiesArea = 0
            Me._HouseHolds = 0
            Me._WhitePopulation = 0
            Me._BlackPopulation = 0
            Me._HispanicPopulation = 0
            Me._IncomePerHouseHold = 0
            Me._AverageHouseValue = 0
            Me._DateCreated = DateTime.Now
            Me._ConnectionString = ""
            Me._ConnectionString = strConnectionString
            Me.Load(Me._ZipCodeID)
        End Sub

        Public Sub Add(ByVal lngCreatedBy As Long, ByVal lngStateID As Long, ByVal lngCityTypeID As Long, ByVal strZipCode As String, ByVal strCity As String, ByVal strAreaCode As String, ByVal dblLatitude As Double, ByVal dblLongitude As Double)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spAddZipCode")
                cmd.CommandType = CommandType.StoredProcedure
                Dim lngZipCodeID As Long = 0
                cmd.Parameters.Add("@CreatedBy", SqlDbType.Int).Value = lngCreatedBy
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = lngStateID
                cmd.Parameters.Add("@CityTypeID", SqlDbType.Int).Value = lngCityTypeID
                cmd.Parameters.Add("@ZipCode", SqlDbType.VarChar, Me.TrimTrunc(strZipCode, &H10).Length).Value = Me.TrimTrunc(strZipCode, &H10)
                cmd.Parameters.Add("@City", SqlDbType.VarChar, Me.TrimTrunc(strCity, &H40).Length).Value = Me.TrimTrunc(strCity, &H40)
                cmd.Parameters.Add("@AreaCode", SqlDbType.VarChar, Me.TrimTrunc(strAreaCode, 3).Length).Value = Me.TrimTrunc(strAreaCode, 3)
                cmd.Parameters.Add("@Latitude", SqlDbType.Float).Value = dblLatitude
                cmd.Parameters.Add("@Longitude", SqlDbType.Float).Value = dblLongitude
                cnn.Open
                cmd.Connection = cnn
                lngZipCodeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngZipCodeID > 0) Then
                    Me.Load(lngZipCodeID)
                End If
            End If
        End Sub

        Private Sub AppendChangeLog(ByRef strLog As String, ByVal strNewLine As String)
            Dim strReturn As String = ""
            If (strLog.Length > 0) Then
                strReturn = (strLog & Environment.NewLine)
            End If
            strReturn = (strReturn & strNewLine)
            strLog = strReturn
        End Sub

        Private Sub ClearValues()
            Me._ZipCodeID = 0
            Me._CreatedBy = 0
            Me._StateID = 0
            Me._CityTypeID = 0
            Me._ZipCode = ""
            Me._City = ""
            Me._AreaCode = ""
            Me._CityAliasName = ""
            Me._CityAliasAbbr = ""
            Me._CountyName = ""
            Me._StateFIPS = 0
            Me._CountyFIPS = 0
            Me._TimeZone = 0
            Me._DayLightSavings = True
            Me._Latitude = 0
            Me._Longitude = 0
            Me._Elevation = 0
            Me._MSA2000 = 0
            Me._PMSA = 0
            Me._CBSA = 0
            Me._CBSADiv = 0
            Me._CBSATitle = ""
            Me._PersonsPerHouseHold = 0
            Me._Population = 0
            Me._CountiesArea = 0
            Me._HouseHolds = 0
            Me._WhitePopulation = 0
            Me._BlackPopulation = 0
            Me._HispanicPopulation = 0
            Me._IncomePerHouseHold = 0
            Me._AverageHouseValue = 0
            Me._DateCreated = DateTime.Now
        End Sub

        Public Sub Delete()
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spRemoveZipCode")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
                cnn.Open
                cmd.Connection = cnn
                cmd.ExecuteNonQuery
                cnn.Close
                Me.Load(Me._ZipCodeID)
            End If
        End Sub

        Private Function GetLocalTime() As DateTime
            Dim datReturn As DateTime = DateTime.Now
            If ((Me._ConnectionString.Trim.Length > 0) AndAlso (Me._ZipCodeID > 0)) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetZipCodeTime")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ZipCode", SqlDbType.VarChar, Me._ZipCode.Trim.Length).Value = Me._ZipCode.Trim
                cnn.Open
                cmd.Connection = cnn
                Try 
                    datReturn = Conversions.ToDate(cmd.ExecuteScalar)
                Catch exception1 As Exception
                    ProjectData.SetProjectError(exception1)
                    Dim ex As Exception = exception1
                    datReturn = DateTime.Now
                    ProjectData.ClearProjectError
                End Try
                cnn.Close
            End If
            Return datReturn
        End Function

        Private Function HasChanged() As Boolean
            Dim blnReturn As Boolean = False
            Dim obj As New ZipCodeRecord(Me._ZipCodeID, Me._ConnectionString)
            If (obj.StateID <> Me._StateID) Then
                blnReturn = True
            End If
            If (obj.CityTypeID <> Me._CityTypeID) Then
                blnReturn = True
            End If
            If (obj.ZipCode <> Me._ZipCode) Then
                blnReturn = True
            End If
            If (obj.City <> Me._City) Then
                blnReturn = True
            End If
            If (obj.AreaCode <> Me._AreaCode) Then
                blnReturn = True
            End If
            If (obj.CityAliasName <> Me._CityAliasName) Then
                blnReturn = True
            End If
            If (obj.CityAliasAbbr <> Me._CityAliasAbbr) Then
                blnReturn = True
            End If
            If (obj.CountyName <> Me._CountyName) Then
                blnReturn = True
            End If
            If (obj.StateFIPS <> Me._StateFIPS) Then
                blnReturn = True
            End If
            If (obj.CountyFIPS <> Me._CountyFIPS) Then
                blnReturn = True
            End If
            If (obj.TimeZone <> Me._TimeZone) Then
                blnReturn = True
            End If
            If (obj.DayLightSavings <> Me._DayLightSavings) Then
                blnReturn = True
            End If
            If (obj.Latitude <> Me._Latitude) Then
                blnReturn = True
            End If
            If (obj.Longitude <> Me._Longitude) Then
                blnReturn = True
            End If
            If (obj.Elevation <> Me._Elevation) Then
                blnReturn = True
            End If
            If (obj.MSA2000 <> Me._MSA2000) Then
                blnReturn = True
            End If
            If (obj.PMSA <> Me._PMSA) Then
                blnReturn = True
            End If
            If (obj.CBSA <> Me._CBSA) Then
                blnReturn = True
            End If
            If (obj.CBSADiv <> Me._CBSADiv) Then
                blnReturn = True
            End If
            If (obj.CBSATitle <> Me._CBSATitle) Then
                blnReturn = True
            End If
            If (obj.PersonsPerHouseHold <> Me._PersonsPerHouseHold) Then
                blnReturn = True
            End If
            If (obj.Population <> Me._Population) Then
                blnReturn = True
            End If
            If (obj.CountiesArea <> Me._CountiesArea) Then
                blnReturn = True
            End If
            If (obj.HouseHolds <> Me._HouseHolds) Then
                blnReturn = True
            End If
            If (obj.WhitePopulation <> Me._WhitePopulation) Then
                blnReturn = True
            End If
            If (obj.BlackPopulation <> Me._BlackPopulation) Then
                blnReturn = True
            End If
            If (obj.HispanicPopulation <> Me._HispanicPopulation) Then
                blnReturn = True
            End If
            If (obj.IncomePerHouseHold <> Me._IncomePerHouseHold) Then
                blnReturn = True
            End If
            If (obj.AverageHouseValue <> Me._AverageHouseValue) Then
                blnReturn = True
            End If
            Return blnReturn
        End Function

        Public Sub Load(ByVal lngZipCodeID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetZipCode")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = lngZipCodeID
                cnn.Open
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ZipCodeID = Conversions.ToLong(dtr.Item("ZipCodeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._StateID = Conversions.ToLong(dtr.Item("StateID"))
                    Me._CityTypeID = Conversions.ToLong(dtr.Item("CityTypeID"))
                    Me._ZipCode = dtr.Item("ZipCode").ToString
                    Me._City = dtr.Item("City").ToString
                    Me._AreaCode = dtr.Item("AreaCode").ToString
                    Me._CityAliasName = dtr.Item("CityAliasName").ToString
                    Me._CityAliasAbbr = dtr.Item("CityAliasAbbr").ToString
                    Me._CountyName = dtr.Item("CountyName").ToString
                    Me._StateFIPS = Conversions.ToLong(dtr.Item("StateFIPS"))
                    Me._CountyFIPS = Conversions.ToLong(dtr.Item("CountyFIPS"))
                    Me._TimeZone = Conversions.ToLong(dtr.Item("TimeZone"))
                    Me._DayLightSavings = Conversions.ToBoolean(dtr.Item("DayLightSavings"))
                    Me._Latitude = Conversions.ToDouble(dtr.Item("Latitude"))
                    Me._Longitude = Conversions.ToDouble(dtr.Item("Longitude"))
                    Me._Elevation = Conversions.ToLong(dtr.Item("Elevation"))
                    Me._MSA2000 = Conversions.ToLong(dtr.Item("MSA2000"))
                    Me._PMSA = Conversions.ToLong(dtr.Item("PMSA"))
                    Me._CBSA = Conversions.ToLong(dtr.Item("CBSA"))
                    Me._CBSADiv = Conversions.ToLong(dtr.Item("CBSADiv"))
                    Me._CBSATitle = dtr.Item("CBSATitle").ToString
                    Me._PersonsPerHouseHold = Conversions.ToDouble(dtr.Item("PersonsPerHouseHold"))
                    Me._Population = Conversions.ToLong(dtr.Item("Population"))
                    Me._CountiesArea = Conversions.ToLong(dtr.Item("CountiesArea"))
                    Me._HouseHolds = Conversions.ToLong(dtr.Item("HouseHolds"))
                    Me._WhitePopulation = Conversions.ToLong(dtr.Item("WhitePopulation"))
                    Me._BlackPopulation = Conversions.ToLong(dtr.Item("BlackPopulation"))
                    Me._HispanicPopulation = Conversions.ToLong(dtr.Item("HispanicPopulation"))
                    Me._IncomePerHouseHold = Conversions.ToDouble(dtr.Item("IncomePerHouseHold"))
                    Me._AverageHouseValue = Conversions.ToDouble(dtr.Item("AverageHouseValue"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues
                End If
                cnn.Close
            End If
        End Sub

        Public Sub Load(ByVal lngZipCodeID As Long, ByVal lngStateID As Long)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetZipCodeByStateID")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = lngZipCodeID
                cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = lngStateID
                cnn.Open()
                cmd.Connection = cnn
                Dim dtr As SqlDataReader = cmd.ExecuteReader
                If dtr.Read Then
                    Me._ZipCodeID = Conversions.ToLong(dtr.Item("ZipCodeID"))
                    Me._CreatedBy = Conversions.ToLong(dtr.Item("CreatedBy"))
                    Me._StateID = Conversions.ToLong(dtr.Item("StateID"))
                    Me._CityTypeID = Conversions.ToLong(dtr.Item("CityTypeID"))
                    Me._ZipCode = dtr.Item("ZipCode").ToString
                    Me._City = dtr.Item("City").ToString
                    Me._AreaCode = dtr.Item("AreaCode").ToString
                    Me._CityAliasName = dtr.Item("CityAliasName").ToString
                    Me._CityAliasAbbr = dtr.Item("CityAliasAbbr").ToString
                    Me._CountyName = dtr.Item("CountyName").ToString
                    Me._StateFIPS = Conversions.ToLong(dtr.Item("StateFIPS"))
                    Me._CountyFIPS = Conversions.ToLong(dtr.Item("CountyFIPS"))
                    Me._TimeZone = Conversions.ToLong(dtr.Item("TimeZone"))
                    Me._DayLightSavings = Conversions.ToBoolean(dtr.Item("DayLightSavings"))
                    Me._Latitude = Conversions.ToDouble(dtr.Item("Latitude"))
                    Me._Longitude = Conversions.ToDouble(dtr.Item("Longitude"))
                    Me._Elevation = Conversions.ToLong(dtr.Item("Elevation"))
                    Me._MSA2000 = Conversions.ToLong(dtr.Item("MSA2000"))
                    Me._PMSA = Conversions.ToLong(dtr.Item("PMSA"))
                    Me._CBSA = Conversions.ToLong(dtr.Item("CBSA"))
                    Me._CBSADiv = Conversions.ToLong(dtr.Item("CBSADiv"))
                    Me._CBSATitle = dtr.Item("CBSATitle").ToString
                    Me._PersonsPerHouseHold = Conversions.ToDouble(dtr.Item("PersonsPerHouseHold"))
                    Me._Population = Conversions.ToLong(dtr.Item("Population"))
                    Me._CountiesArea = Conversions.ToLong(dtr.Item("CountiesArea"))
                    Me._HouseHolds = Conversions.ToLong(dtr.Item("HouseHolds"))
                    Me._WhitePopulation = Conversions.ToLong(dtr.Item("WhitePopulation"))
                    Me._BlackPopulation = Conversions.ToLong(dtr.Item("BlackPopulation"))
                    Me._HispanicPopulation = Conversions.ToLong(dtr.Item("HispanicPopulation"))
                    Me._IncomePerHouseHold = Conversions.ToDouble(dtr.Item("IncomePerHouseHold"))
                    Me._AverageHouseValue = Conversions.ToDouble(dtr.Item("AverageHouseValue"))
                    Me._DateCreated = Conversions.ToDate(dtr.Item("DateCreated"))
                Else
                    Me.ClearValues()
                End If
                cnn.Close()
            End If
        End Sub



        Public Sub Load(ByVal strZipCode As String)
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim cnn As New SqlConnection(Me._ConnectionString)
                Dim cmd As New SqlCommand("spGetZipCodeByZipCode")
                Dim lngZipCodeID As Long = 0
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("ZipCode", SqlDbType.VarChar, strZipCode.Trim.Length).Value = strZipCode.Trim
                cnn.Open
                cmd.Connection = cnn
                lngZipCodeID = Conversions.ToLong(cmd.ExecuteScalar)
                cnn.Close
                If (lngZipCodeID > 0) Then
                    Me.Load(lngZipCodeID)
                End If
            End If
        End Sub

        Public Sub Save(ByRef strChangeLog As String)
            strChangeLog = ""
            If (Me._ConnectionString.Trim.Length > 0) Then
                Dim strTemp As String = ""
                Dim cnn As New SqlConnection(Me._ConnectionString)
                cnn.Open
                Dim obj As New ZipCodeRecord(Me._ZipCodeID, Me._ConnectionString)
                If (obj.StateID <> Me._StateID) Then
                    Me.UpdateStateID(Me._StateID, (cnn))
                    strTemp = String.Concat(New String() { "StateID Changed to '", Conversions.ToString(Me._StateID), "' from '", Conversions.ToString(obj.StateID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CityTypeID <> Me._CityTypeID) Then
                    Me.UpdateCityTypeID(Me._CityTypeID, (cnn))
                    strTemp = String.Concat(New String() { "CityTypeID Changed to '", Conversions.ToString(Me._CityTypeID), "' from '", Conversions.ToString(obj.CityTypeID), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.ZipCode <> Me._ZipCode) Then
                    Me.UpdateZipCode(Me._ZipCode, (cnn))
                    strTemp = String.Concat(New String() { "ZipCode Changed to '", Me._ZipCode, "' from '", obj.ZipCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.City <> Me._City) Then
                    Me.UpdateCity(Me._City, (cnn))
                    strTemp = String.Concat(New String() { "City Changed to '", Me._City, "' from '", obj.City, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AreaCode <> Me._AreaCode) Then
                    Me.UpdateAreaCode(Me._AreaCode, (cnn))
                    strTemp = String.Concat(New String() { "AreaCode Changed to '", Me._AreaCode, "' from '", obj.AreaCode, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CityAliasName <> Me._CityAliasName) Then
                    Me.UpdateCityAliasName(Me._CityAliasName, (cnn))
                    strTemp = String.Concat(New String() { "CityAliasName Changed to '", Me._CityAliasName, "' from '", obj.CityAliasName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CityAliasAbbr <> Me._CityAliasAbbr) Then
                    Me.UpdateCityAliasAbbr(Me._CityAliasAbbr, (cnn))
                    strTemp = String.Concat(New String() { "CityAliasAbbr Changed to '", Me._CityAliasAbbr, "' from '", obj.CityAliasAbbr, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CountyName <> Me._CountyName) Then
                    Me.UpdateCountyName(Me._CountyName, (cnn))
                    strTemp = String.Concat(New String() { "CountyName Changed to '", Me._CountyName, "' from '", obj.CountyName, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.StateFIPS <> Me._StateFIPS) Then
                    Me.UpdateStateFIPS(Me._StateFIPS, (cnn))
                    strTemp = String.Concat(New String() { "StateFIPS Changed to '", Conversions.ToString(Me._StateFIPS), "' from '", Conversions.ToString(obj.StateFIPS), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CountyFIPS <> Me._CountyFIPS) Then
                    Me.UpdateCountyFIPS(Me._CountyFIPS, (cnn))
                    strTemp = String.Concat(New String() { "CountyFIPS Changed to '", Conversions.ToString(Me._CountyFIPS), "' from '", Conversions.ToString(obj.CountyFIPS), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.TimeZone <> Me._TimeZone) Then
                    Me.UpdateTimeZone(Me._TimeZone, (cnn))
                    strTemp = String.Concat(New String() { "TimeZone Changed to '", Conversions.ToString(Me._TimeZone), "' from '", Conversions.ToString(obj.TimeZone), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.DayLightSavings <> Me._DayLightSavings) Then
                    Me.UpdateDayLightSavings(Me._DayLightSavings, (cnn))
                    strTemp = String.Concat(New String() { "DayLightSavings Changed to '", Conversions.ToString(Me._DayLightSavings), "' from '", Conversions.ToString(obj.DayLightSavings), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Latitude <> Me._Latitude) Then
                    Me.UpdateLatitude(Me._Latitude, (cnn))
                    strTemp = String.Concat(New String() { "Latitude Changed to '", Conversions.ToString(Me._Latitude), "' from '", Conversions.ToString(obj.Latitude), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Longitude <> Me._Longitude) Then
                    Me.UpdateLongitude(Me._Longitude, (cnn))
                    strTemp = String.Concat(New String() { "Longitude Changed to '", Conversions.ToString(Me._Longitude), "' from '", Conversions.ToString(obj.Longitude), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Elevation <> Me._Elevation) Then
                    Me.UpdateElevation(Me._Elevation, (cnn))
                    strTemp = String.Concat(New String() { "Elevation Changed to '", Conversions.ToString(Me._Elevation), "' from '", Conversions.ToString(obj.Elevation), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.MSA2000 <> Me._MSA2000) Then
                    Me.UpdateMSA2000(Me._MSA2000, (cnn))
                    strTemp = String.Concat(New String() { "MSA2000 Changed to '", Conversions.ToString(Me._MSA2000), "' from '", Conversions.ToString(obj.MSA2000), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PMSA <> Me._PMSA) Then
                    Me.UpdatePMSA(Me._PMSA, (cnn))
                    strTemp = String.Concat(New String() { "PMSA Changed to '", Conversions.ToString(Me._PMSA), "' from '", Conversions.ToString(obj.PMSA), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CBSA <> Me._CBSA) Then
                    Me.UpdateCBSA(Me._CBSA, (cnn))
                    strTemp = String.Concat(New String() { "CBSA Changed to '", Conversions.ToString(Me._CBSA), "' from '", Conversions.ToString(obj.CBSA), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CBSADiv <> Me._CBSADiv) Then
                    Me.UpdateCBSADiv(Me._CBSADiv, (cnn))
                    strTemp = String.Concat(New String() { "CBSADiv Changed to '", Conversions.ToString(Me._CBSADiv), "' from '", Conversions.ToString(obj.CBSADiv), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CBSATitle <> Me._CBSATitle) Then
                    Me.UpdateCBSATitle(Me._CBSATitle, (cnn))
                    strTemp = String.Concat(New String() { "CBSATitle Changed to '", Me._CBSATitle, "' from '", obj.CBSATitle, "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.PersonsPerHouseHold <> Me._PersonsPerHouseHold) Then
                    Me.UpdatePersonsPerHouseHold(Me._PersonsPerHouseHold, (cnn))
                    strTemp = String.Concat(New String() { "PersonsPerHouseHold Changed to '", Conversions.ToString(Me._PersonsPerHouseHold), "' from '", Conversions.ToString(obj.PersonsPerHouseHold), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.Population <> Me._Population) Then
                    Me.UpdatePopulation(Me._Population, (cnn))
                    strTemp = String.Concat(New String() { "Population Changed to '", Conversions.ToString(Me._Population), "' from '", Conversions.ToString(obj.Population), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.CountiesArea <> Me._CountiesArea) Then
                    Me.UpdateCountiesArea(Me._CountiesArea, (cnn))
                    strTemp = String.Concat(New String() { "CountiesArea Changed to '", Conversions.ToString(Me._CountiesArea), "' from '", Conversions.ToString(obj.CountiesArea), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.HouseHolds <> Me._HouseHolds) Then
                    Me.UpdateHouseHolds(Me._HouseHolds, (cnn))
                    strTemp = String.Concat(New String() { "HouseHolds Changed to '", Conversions.ToString(Me._HouseHolds), "' from '", Conversions.ToString(obj.HouseHolds), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.WhitePopulation <> Me._WhitePopulation) Then
                    Me.UpdateWhitePopulation(Me._WhitePopulation, (cnn))
                    strTemp = String.Concat(New String() { "WhitePopulation Changed to '", Conversions.ToString(Me._WhitePopulation), "' from '", Conversions.ToString(obj.WhitePopulation), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.BlackPopulation <> Me._BlackPopulation) Then
                    Me.UpdateBlackPopulation(Me._BlackPopulation, (cnn))
                    strTemp = String.Concat(New String() { "BlackPopulation Changed to '", Conversions.ToString(Me._BlackPopulation), "' from '", Conversions.ToString(obj.BlackPopulation), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.HispanicPopulation <> Me._HispanicPopulation) Then
                    Me.UpdateHispanicPopulation(Me._HispanicPopulation, (cnn))
                    strTemp = String.Concat(New String() { "HispanicPopulation Changed to '", Conversions.ToString(Me._HispanicPopulation), "' from '", Conversions.ToString(obj.HispanicPopulation), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.IncomePerHouseHold <> Me._IncomePerHouseHold) Then
                    Me.UpdateIncomePerHouseHold(Me._IncomePerHouseHold, (cnn))
                    strTemp = String.Concat(New String() { "IncomePerHouseHold Changed to '", Conversions.ToString(Me._IncomePerHouseHold), "' from '", Conversions.ToString(obj.IncomePerHouseHold), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                If (obj.AverageHouseValue <> Me._AverageHouseValue) Then
                    Me.UpdateAverageHouseValue(Me._AverageHouseValue, (cnn))
                    strTemp = String.Concat(New String() { "AverageHouseValue Changed to '", Conversions.ToString(Me._AverageHouseValue), "' from '", Conversions.ToString(obj.AverageHouseValue), "'" })
                    Me.AppendChangeLog((strChangeLog), strTemp)
                End If
                cnn.Close
                Me.Load(Me._ZipCodeID)
            Else
                Me.ClearValues
            End If
        End Sub

        Private Function TrimTrunc(ByVal strInput As String, ByVal intMaxLength As Integer) As String
            Dim strReturn As String = strInput
            If (strReturn.Trim.Length <= intMaxLength) Then
                Return strReturn.Trim
            End If
            Return strReturn.Substring(0, intMaxLength).Trim
        End Function

        Private Sub UpdateAreaCode(ByVal NewAreaCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeAreaCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@AreaCode", SqlDbType.VarChar, Me.TrimTrunc(NewAreaCode, 3).Length).Value = Me.TrimTrunc(NewAreaCode, 3)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateAverageHouseValue(ByVal NewAverageHouseValue As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeAverageHouseValue")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@AverageHouseValue", SqlDbType.Money).Value = NewAverageHouseValue
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateBlackPopulation(ByVal NewBlackPopulation As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeBlackPopulation")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@BlackPopulation", SqlDbType.Int).Value = NewBlackPopulation
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCBSA(ByVal NewCBSA As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCBSA")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@CBSA", SqlDbType.Int).Value = NewCBSA
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCBSADiv(ByVal NewCBSADiv As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCBSADiv")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@CBSADiv", SqlDbType.Int).Value = NewCBSADiv
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCBSATitle(ByVal NewCBSATitle As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCBSATitle")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            If (NewCBSATitle.Trim.Length > 0) Then
                cmd.Parameters.Add("@CBSATitle", SqlDbType.VarChar, Me.TrimTrunc(NewCBSATitle, &H40).Length).Value = Me.TrimTrunc(NewCBSATitle, &H40)
            Else
                cmd.Parameters.Add("@CBSATitle", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCity(ByVal NewCity As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCity")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@City", SqlDbType.VarChar, Me.TrimTrunc(NewCity, &H40).Length).Value = Me.TrimTrunc(NewCity, &H40)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCityAliasAbbr(ByVal NewCityAliasAbbr As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCityAliasAbbr")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            If (NewCityAliasAbbr.Trim.Length > 0) Then
                cmd.Parameters.Add("@CityAliasAbbr", SqlDbType.VarChar, Me.TrimTrunc(NewCityAliasAbbr, &H40).Length).Value = Me.TrimTrunc(NewCityAliasAbbr, &H40)
            Else
                cmd.Parameters.Add("@CityAliasAbbr", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCityAliasName(ByVal NewCityAliasName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCityAliasName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            If (NewCityAliasName.Trim.Length > 0) Then
                cmd.Parameters.Add("@CityAliasName", SqlDbType.VarChar, Me.TrimTrunc(NewCityAliasName, &H40).Length).Value = Me.TrimTrunc(NewCityAliasName, &H40)
            Else
                cmd.Parameters.Add("@CityAliasName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCityTypeID(ByVal NewCityTypeID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCityTypeID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@CityTypeID", SqlDbType.Int).Value = NewCityTypeID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCountiesArea(ByVal NewCountiesArea As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCountiesArea")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@CountiesArea", SqlDbType.Int).Value = NewCountiesArea
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCountyFIPS(ByVal NewCountyFIPS As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCountyFIPS")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@CountyFIPS", SqlDbType.Int).Value = NewCountyFIPS
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateCountyName(ByVal NewCountyName As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeCountyName")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            If (NewCountyName.Trim.Length > 0) Then
                cmd.Parameters.Add("@CountyName", SqlDbType.VarChar, Me.TrimTrunc(NewCountyName, &H40).Length).Value = Me.TrimTrunc(NewCountyName, &H40)
            Else
                cmd.Parameters.Add("@CountyName", SqlDbType.VarChar).Value = DBNull.Value
            End If
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateDayLightSavings(ByVal NewDayLightSavings As Boolean, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeDayLightSavings")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@DayLightSavings", SqlDbType.Bit).Value = NewDayLightSavings
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateElevation(ByVal NewElevation As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeElevation")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@Elevation", SqlDbType.Int).Value = NewElevation
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateHispanicPopulation(ByVal NewHispanicPopulation As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeHispanicPopulation")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@HispanicPopulation", SqlDbType.Int).Value = NewHispanicPopulation
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateHouseHolds(ByVal NewHouseHolds As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeHouseHolds")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@HouseHolds", SqlDbType.Int).Value = NewHouseHolds
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateIncomePerHouseHold(ByVal NewIncomePerHouseHold As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeIncomePerHouseHold")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@IncomePerHouseHold", SqlDbType.Money).Value = NewIncomePerHouseHold
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLatitude(ByVal NewLatitude As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeLatitude")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@Latitude", SqlDbType.Float).Value = NewLatitude
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateLongitude(ByVal NewLongitude As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeLongitude")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@Longitude", SqlDbType.Float).Value = NewLongitude
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateMSA2000(ByVal NewMSA2000 As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeMSA2000")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@MSA2000", SqlDbType.Int).Value = NewMSA2000
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePersonsPerHouseHold(ByVal NewPersonsPerHouseHold As Double, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodePersonsPerHouseHold")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@PersonsPerHouseHold", SqlDbType.Float).Value = NewPersonsPerHouseHold
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePMSA(ByVal NewPMSA As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodePMSA")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@PMSA", SqlDbType.Int).Value = NewPMSA
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdatePopulation(ByVal NewPopulation As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodePopulation")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@Population", SqlDbType.Int).Value = NewPopulation
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateStateFIPS(ByVal NewStateFIPS As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeStateFIPS")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@StateFIPS", SqlDbType.Int).Value = NewStateFIPS
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateStateID(ByVal NewStateID As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeStateID")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@StateID", SqlDbType.Int).Value = NewStateID
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateTimeZone(ByVal NewTimeZone As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeTimeZone")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@TimeZone", SqlDbType.Int).Value = NewTimeZone
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateWhitePopulation(ByVal NewWhitePopulation As Long, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeWhitePopulation")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@WhitePopulation", SqlDbType.Int).Value = NewWhitePopulation
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub

        Private Sub UpdateZipCode(ByVal NewZipCode As String, ByRef cnn As SqlConnection)
            Dim cmd As New SqlCommand("spUpdateZipCodeZipCode")
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@ZipCodeID", SqlDbType.Int).Value = Me._ZipCodeID
            cmd.Parameters.Add("@ZipCode", SqlDbType.VarChar, Me.TrimTrunc(NewZipCode, &H10).Length).Value = Me.TrimTrunc(NewZipCode, &H10)
            cmd.Connection = cnn
            cmd.ExecuteNonQuery
        End Sub


        ' Properties
        Public Property AreaCode As String
            Get
                Return Me._AreaCode
            End Get
            Set(ByVal value As String)
                Me._AreaCode = Me.TrimTrunc(value, 3)
            End Set
        End Property

        Public Property AverageHouseValue As Double
            Get
                Return Me._AverageHouseValue
            End Get
            Set(ByVal value As Double)
                Me._AverageHouseValue = value
            End Set
        End Property

        Public Property BlackPopulation As Long
            Get
                Return Me._BlackPopulation
            End Get
            Set(ByVal value As Long)
                Me._BlackPopulation = value
            End Set
        End Property

        Public Property CBSA As Long
            Get
                Return Me._CBSA
            End Get
            Set(ByVal value As Long)
                Me._CBSA = value
            End Set
        End Property

        Public Property CBSADiv As Long
            Get
                Return Me._CBSADiv
            End Get
            Set(ByVal value As Long)
                Me._CBSADiv = value
            End Set
        End Property

        Public Property CBSATitle As String
            Get
                Return Me._CBSATitle
            End Get
            Set(ByVal value As String)
                Me._CBSATitle = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property City As String
            Get
                Return Me._City
            End Get
            Set(ByVal value As String)
                Me._City = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property CityAliasAbbr As String
            Get
                Return Me._CityAliasAbbr
            End Get
            Set(ByVal value As String)
                Me._CityAliasAbbr = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property CityAliasName As String
            Get
                Return Me._CityAliasName
            End Get
            Set(ByVal value As String)
                Me._CityAliasName = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public Property CityTypeID As Long
            Get
                Return Me._CityTypeID
            End Get
            Set(ByVal value As Long)
                Me._CityTypeID = value
            End Set
        End Property

        Public Property ConnectionString As String
            Get
                Return Me._ConnectionString
            End Get
            Set(ByVal value As String)
                Me._ConnectionString = value
            End Set
        End Property

        Public Property CountiesArea As Long
            Get
                Return Me._CountiesArea
            End Get
            Set(ByVal value As Long)
                Me._CountiesArea = value
            End Set
        End Property

        Public Property CountyFIPS As Long
            Get
                Return Me._CountyFIPS
            End Get
            Set(ByVal value As Long)
                Me._CountyFIPS = value
            End Set
        End Property

        Public Property CountyName As String
            Get
                Return Me._CountyName
            End Get
            Set(ByVal value As String)
                Me._CountyName = Me.TrimTrunc(value, &H40)
            End Set
        End Property

        Public ReadOnly Property CreatedBy As Long
            Get
                Return Me._CreatedBy
            End Get
        End Property

        Public ReadOnly Property DateCreated As DateTime
            Get
                Return Me._DateCreated
            End Get
        End Property

        Public Property DayLightSavings As Boolean
            Get
                Return Me._DayLightSavings
            End Get
            Set(ByVal value As Boolean)
                Me._DayLightSavings = value
            End Set
        End Property

        Public Property Elevation As Long
            Get
                Return Me._Elevation
            End Get
            Set(ByVal value As Long)
                Me._Elevation = value
            End Set
        End Property

        Public Property HispanicPopulation As Long
            Get
                Return Me._HispanicPopulation
            End Get
            Set(ByVal value As Long)
                Me._HispanicPopulation = value
            End Set
        End Property

        Public Property HouseHolds As Long
            Get
                Return Me._HouseHolds
            End Get
            Set(ByVal value As Long)
                Me._HouseHolds = value
            End Set
        End Property

        Public Property IncomePerHouseHold As Double
            Get
                Return Me._IncomePerHouseHold
            End Get
            Set(ByVal value As Double)
                Me._IncomePerHouseHold = value
            End Set
        End Property

        Public Property Latitude As Double
            Get
                Return Me._Latitude
            End Get
            Set(ByVal value As Double)
                Me._Latitude = value
            End Set
        End Property

        Public ReadOnly Property LocalTime As DateTime
            Get
                Return Me.GetLocalTime
            End Get
        End Property

        Public Property Longitude As Double
            Get
                Return Me._Longitude
            End Get
            Set(ByVal value As Double)
                Me._Longitude = value
            End Set
        End Property

        Public ReadOnly Property Modified As Boolean
            Get
                Return Me.HasChanged
            End Get
        End Property

        Public Property MSA2000 As Long
            Get
                Return Me._MSA2000
            End Get
            Set(ByVal value As Long)
                Me._MSA2000 = value
            End Set
        End Property

        Public Property PersonsPerHouseHold As Double
            Get
                Return Me._PersonsPerHouseHold
            End Get
            Set(ByVal value As Double)
                Me._PersonsPerHouseHold = value
            End Set
        End Property

        Public Property PMSA As Long
            Get
                Return Me._PMSA
            End Get
            Set(ByVal value As Long)
                Me._PMSA = value
            End Set
        End Property

        Public Property Population As Long
            Get
                Return Me._Population
            End Get
            Set(ByVal value As Long)
                Me._Population = value
            End Set
        End Property

        Public Property StateFIPS As Long
            Get
                Return Me._StateFIPS
            End Get
            Set(ByVal value As Long)
                Me._StateFIPS = value
            End Set
        End Property

        Public Property StateID As Long
            Get
                Return Me._StateID
            End Get
            Set(ByVal value As Long)
                Me._StateID = value
            End Set
        End Property

        Public Property TimeZone As Long
            Get
                Return Me._TimeZone
            End Get
            Set(ByVal value As Long)
                Me._TimeZone = value
            End Set
        End Property

        Public Property WhitePopulation As Long
            Get
                Return Me._WhitePopulation
            End Get
            Set(ByVal value As Long)
                Me._WhitePopulation = value
            End Set
        End Property

        Public Property ZipCode As String
            Get
                Return Me._ZipCode
            End Get
            Set(ByVal value As String)
                Me._ZipCode = Me.TrimTrunc(value, &H10)
            End Set
        End Property

        Public ReadOnly Property ZipCodeID As Long
            Get
                Return Me._ZipCodeID
            End Get
        End Property


        ' Fields
        Private _AreaCode As String
        Private _AverageHouseValue As Double
        Private _BlackPopulation As Long
        Private _CBSA As Long
        Private _CBSADiv As Long
        Private _CBSATitle As String
        Private _City As String
        Private _CityAliasAbbr As String
        Private _CityAliasName As String
        Private _CityTypeID As Long
        Private _ConnectionString As String
        Private _CountiesArea As Long
        Private _CountyFIPS As Long
        Private _CountyName As String
        Private _CreatedBy As Long
        Private _DateCreated As DateTime
        Private _DayLightSavings As Boolean
        Private _Elevation As Long
        Private _HispanicPopulation As Long
        Private _HouseHolds As Long
        Private _IncomePerHouseHold As Double
        Private _Latitude As Double
        Private _Longitude As Double
        Private _MSA2000 As Long
        Private _PersonsPerHouseHold As Double
        Private _PMSA As Long
        Private _Population As Long
        Private _StateFIPS As Long
        Private _StateID As Long
        Private _TimeZone As Long
        Private _WhitePopulation As Long
        Private _ZipCode As String
        Private _ZipCodeID As Long
        Private Const AreaCodeMaxLength As Integer = 3
        Private Const CBSATitleMaxLength As Integer = &H40
        Private Const CityAliasAbbrMaxLength As Integer = &H40
        Private Const CityAliasNameMaxLength As Integer = &H40
        Private Const CityMaxLength As Integer = &H40
        Private Const CountyNameMaxLength As Integer = &H40
        Private Const ZipCodeMaxLength As Integer = &H10
    End Class
End Namespace

