

$anchors = Get-ChildItem bucket/ |
ForEach-Object {
    $timeEST = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date -Date $_.LastWriteTime),'Eastern Standard Time').ToString('d--M--yyyy_hh:mm:ss_tt')
    New-Object -TypeName PSObject -Property @{
        Name = $_.Basename
        Version = ( Get-Content $_ | ConvertFrom-Json ).version
        Time = $timeEST
    }
}

$linesToWrite = @"
# Scoop files
#### Scoop files for various Windows applications.
---
| Repository | Status | GitHub | Docker | Tag | Size | Layers |
| --- | --- | :---: | :---: | :--- | :---: | :---: |
| [![](https://img.shields.io/badge/scoop-packages-grey)](https://github.com/forwardcomputers/scoop-packages) | [![](https://img.shields.io/github/actions/workflow/status/forwardcomputers/scoop-packages/schedule.yml?label)](https://github.com/forwardcomputers/scoop-packages/actions) | [![](https://img.shields.io/badge/github--grey?label=&logo=github&logoColor=white)](https://github.com/forwardcomputers/scoop-packages) | |
"@
Set-Content -Encoding ASCII -Force -Path README.md -Value $linesToWrite

ForEach($anchor in $anchors) {
    $newName=$($anchor.Name).Normalize("FormD") -replace '-', '_'
    $linesToWrite = "| [![](https://img.shields.io/badge/$newName-grey)](https://github.com/forwardcomputers/scoop-packages/tree/main/$($anchor.Name)) | ![](https://img.shields.io/badge/$($timeEST)-blue) | [![](https://img.shields.io/badge/github--grey?label=&logo=github&logoColor=white)](https://github.com/forwardcomputers/scoop-packages/tree/main/$($anchor.Name)) | | [![](https://img.shields.io/badge/v$($anchor.Version)-blue)](https://github.com/forwardcomputers/scoop-packages/tree/main/$($anchor.Name))"
    Add-Content -Encoding ASCII -Force -Path README.md -Value $linesToWrite
}
