$directory = "d:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n"
$arbFiles = Get-ChildItem -Path $directory -Filter "app_*.arb"

$newKeys = @{
    "errorPleaseEnterAmountFor" = "Please enter amount for {activityName}"
    "@errorPleaseEnterAmountFor" = @{
        "placeholders" = @{
            "activityName" = @{
                "type" = "String"
            }
        }
    }
    "errorNameOrTypeRequiredFor" = "Name or Type required for {activityName}"
    "@errorNameOrTypeRequiredFor" = @{
        "placeholders" = @{
            "activityName" = @{
                "type" = "String"
            }
        }
    }
}

foreach ($file in $arbFiles) {
    try {
        $jsonContent = Get-Content -Path $file.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
        
        $modified = $false
        
        # Check and add keys manually because PSObject is a bit tricky with dynamic properties
        if (-not $jsonContent.PSObject.Properties.Match("errorPleaseEnterAmountFor").Count) {
            $jsonContent | Add-Member -MemberType NoteProperty -Name "errorPleaseEnterAmountFor" -Value "Please enter amount for {activityName}"
            $modified = $true
        }
        
        if (-not $jsonContent.PSObject.Properties.Match("@errorPleaseEnterAmountFor").Count) {
            $metaObj = [PSCustomObject]@{
                placeholders = [PSCustomObject]@{
                    activityName = [PSCustomObject]@{
                        type = "String"
                    }
                }
            }
            $jsonContent | Add-Member -MemberType NoteProperty -Name "@errorPleaseEnterAmountFor" -Value $metaObj
            $modified = $true
        }

        if (-not $jsonContent.PSObject.Properties.Match("errorNameOrTypeRequiredFor").Count) {
            $jsonContent | Add-Member -MemberType NoteProperty -Name "errorNameOrTypeRequiredFor" -Value "Name or Type required for {activityName}"
            $modified = $true
        }

        if (-not $jsonContent.PSObject.Properties.Match("@errorNameOrTypeRequiredFor").Count) {
            $metaObj = [PSCustomObject]@{
                placeholders = [PSCustomObject]@{
                    activityName = [PSCustomObject]@{
                        type = "String"
                    }
                }
            }
            $jsonContent | Add-Member -MemberType NoteProperty -Name "@errorNameOrTypeRequiredFor" -Value $metaObj
            $modified = $true
        }

        if ($modified) {
            $jsonContent | ConvertTo-Json -Depth 10 | Set-Content -Path $file.FullName -Encoding UTF8
            Write-Host "Updated $($file.Name)"
        } else {
            Write-Host "No changes needed for $($file.Name)"
        }
    } catch {
        Write-Host "Error processing $($file.Name): $_"
    }
}
