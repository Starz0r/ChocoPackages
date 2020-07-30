#import-module au

. $PSScriptRoot\..\..\scripts\all.ps1

$releases = 'https://github.com/TranslucentTB/TranslucentTB/releases/latest'

function global:au_SearchReplace {
    @{}
}

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge
}

function global:au_AfterUpdate {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regexUrl = '/download/(?<version>[\d\.]+)/TranslucentTB-Setup.exe$'

    $url32 = $page.links | Where-Object href -match $regexUrl | Select-Object -First 1 -expand href
    $version = $matches.version

    return @{
        URL32   = "https://github.com/$url32"
        Version = $version
    }
}

Update-Package -ChecksumFor none