function Get-WindForce {

<#
.Synopsis
   Returns wind force from speed in m/s
.DESCRIPTION
   Returns wind force in a give language from speed in m/s
.EXAMPLE
   Get-WindForce -speed 2 -language EN
.EXAMPLE
   Get-WindForce -speed 31.5 -language IT
.EXAMPLE
    15,40 | Get-WindForce -Language FR -Verbose
.NOTES
   happysysadm.com
   @sysadm2010
#>
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Speed of wind in m/s
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [double]$Speed,

        # Language to use for the output of the wind force
        [string]$Language = 'EN'
    )
    
    Process {
    
        Write-Verbose "working on $speed m/s"
        $windforce = switch ($speed) {
            {$_ -lt 0.3} { @('Calm','Calma','Calme','WindStille') }
            {($_ -ge 0.3) -and ($_ -le 1.5)} { @('Light air','Bava di vento','Très légère brise','Leichter Zug') }
            {($_ -ge 1.6) -and ($_ -le 3.3)} { @('Light breeze','Brezza leggera','Légère brise','Leichte Brise') }
            {($_ -ge 3.4) -and ($_ -le 5.5)} { @('Gentle breeze','Brezza testa','Petite brise','Schwache Brise') }
            {($_ -ge 5.6) -and ($_ -le 7.9)} { @('Moderate breeze','Vento moderato','Jolie brise','Mäßige Brise') }
            {($_ -ge 8) -and ($_ -le 10.7)} { @('Fresh breeze','Vento teso','Bonne brise','Frische Brise') }
            {($_ -ge 10.8) -and ($_ -le 13.8)} { @('Strong breeze','Vento fresco','Vent frais','Starker Wind') }
            {($_ -ge 13.9) -and ($_ -le 17.1)} { @('Near gale','Vento forte','Grand frais','Steifer Wind') } 
            {($_ -ge 17.2) -and ($_ -le 20.7)} { @('Gale','Burrasca','Coup de vent','Stürmischer Wind') }
            {($_ -ge 20.8) -and ($_ -le 24.4)} { @('Strong gale','Burrasca forte','Fort coup de vent','Sturm') }
            {($_ -ge 24.5) -and ($_ -le 28.4)} { @('Storm','Tempesta','Tempête','Schwerer Sturm') }
            {($_ -ge 28.5) -and ($_ -le 32.6)} { @('Violent storm','Fortunale','Violent tempête','Orkanartiger Sturm') }
            {$_ -ge 32.7} { @('Hurricane','Uragano','Ouragan','Orkan') }
            default { 'NA','NA','NA','NA' }
            }

        Write-Verbose "Printing in choosen language: $Language"
        switch ($language) {
            'EN' {$windforce[0]}
            'IT' {$windforce[1]}
            'FR' {$windforce[2]}
            'DE' {$windforce[3]}
            Default {$windforce[0]}
            }

    }
   
}