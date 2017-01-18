<#
.Synopsis
   Get-LiveWeather is a function that retrieves current weather information from OpenWeatherMap
.EXAMPLE
    Get-LiveWeather -City 'San Francisco' -key 'yourkey'
.EXAMPLE
   Get-LiveWeather -City 'Paris','London','Roma','Berlin' -Unit Metric -Key 'yourkey' | ft * -AutoSize
.EXAMPLE
   (Invoke-RestMethod https://restcountries.eu/rest/v1/all).capital | Get-LiveWeather -Unit Metric -Key 'yourkey' | ft * -AutoSize
.NOTES
   happysysadm.com
   @sysadm2010
#>
function Get-LiveWeather
{
    [CmdletBinding()]
    Param
    (
        # City Name
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]]$City,

        # Standard, metric, or imperial units
         [ValidateSet("Standard","Metric","Imperial")]
        [string]$Unit='Standard',

        # Openweather key
        [Parameter(Mandatory=$true)]
        [string]$Key
    )
    Process
    {
    foreach($Cityname in $City)
        {
        $ok = $false
        try{
            $city_id = (Invoke-RestMethod "api.openweathermap.org/data/2.5/weather?q=$cityname&APPID=$key&units=$Unit" -ErrorAction Stop).id
            $ok = $true
        }
        catch{
            Write-Error "$Cityname not found...."
        }
        if($ok) {
            $Weather = Start-RoboCommand -Command 'Invoke-RestMethod' `
                            -Args @{ URI = "api.openweathermap.org/data/2.5/weather?id=$city_ID&APPID=$app_ID&units=$Unit" } `                            -Count 5 -DelaySec 4 -LogFile error.log
            [double]$WeatherWind = $Weather.wind.speed
            $CityWeatherObject = [PSCustomObject]@{
                "City_Name" = $Cityname
                "Temperature" = $Weather.main.temp
                "Humidity" = $Weather.main.humidity
                "Pressure" = $Weather.main.pressure
                "Weather-description" = $Weather.weather.description
                "Wind_Speed" = $WeatherWind
                "Wind_Direction" = (Get-WindDirection $Weather.wind.deg).direction
                "Wind_Italianate_Name" = (Get-WindDirection $Weather.wind.deg).name
                "Wind_Degrees" = $Weather.wind.deg
                "Wind_Force" = Get-WindForce $WeatherWind -Language EN
                }
            $CityWeatherObject
            }
        }
    }
}