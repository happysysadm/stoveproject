function Get-WindDirection {

<#
.Synopsis
   Returns wind direction
.DESCRIPTION
   Returns wind direction and the italianate wind name
.EXAMPLE
   Get-WindDirection -degress 90
.NOTES
   happysysadm.com
   @sysadm2010
#>

    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Degrees
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateRange(0,360)][int]$Degree
    )
    Begin {
        $WindCompassDirection = @("North","North Northeast","Northeast","East Northeast","East","East Southeast", "Southeast", "South Southeast","South","South Southwest","Southwest","West Southwest","West","West Northwest","Northwest","North Northwest","North")
        $WindCompassName = @('Tramontana','Tramontana-Grecale','Grecale','Grecale-Levante','Levante','Levante-Scirocco','Scirocco','Scirocco-Ostro','Ostro','Ostro-Libeccio','Libeccio','Libeccio-Ponente','Ponente','Ponente-Mastrale','Maestrale','Maestrale-Tramontana','Tramontana')
        }

    Process {
        $Sector = $Degree/22.5  #Divide the angle by 22.5 because 360deg/16 directions = 22.5deg/direction change
        Write-Verbose "$Degree is in $Sector sector."
        $Value = "" | Select-Object -Property Direction,Name
        $Value.Direction = $WindCompassDirection[$Sector]
        $Value.Name = $WindCompassName[$Sector]
        return $Value
        }

    End {}
   
}