Function Find-WhatDayIsThis {
    <#
        .SYNOPSIS
        PowerShell function to determine the day of the week.

        .DESCRIPTION
        PowerShell function to determine the day of the week.

        Can be used independently or as part of something grander.

        .EXAMPLE
        PS> Find-WhatDayIsThis

        Outputs a nice message about what day we find ourselves on.

        .EXAMPLE
        PS> Find-WhatDayIsThis -raw

        Just give me the day, useful for integrating into other scripts and functions.

    #>

    param (
        [Parameter()]
        [switch]$raw
    )

    if ($raw) {
        (Get-Date).DayOfWeek
    }
    else {
        Write-Output ("-------------------------------------")
        Write-Output ("Today we are doing {0}!" -f (Get-Date).DayOfWeek)
        Write-Output ("-------------------------------------")
    }
}