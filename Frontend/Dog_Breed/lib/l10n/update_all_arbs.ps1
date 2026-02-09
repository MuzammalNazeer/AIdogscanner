$l10nDir = "d:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n"
Write-Host "Starting update of all ARB files..."
$masterFile = Join-Path $l10nDir "app_en.arb"
$targetFiles = @(
    "app_de.arb", "app_es.arb", "app_fr.arb", "app_id.arb", 
    "app_it.arb", "app_nl.arb", "app_pt.arb", "app_tr.arb", 
    "app_el.arb", "app_sv.arb", "app_da.arb", "app_cs.arb",
    "app_pl.arb", "app_fi.arb"
)

# Load master data
$masterJson = Get-Content $masterFile -Raw | ConvertFrom-Json

Write-Host "Loaded master file: app_en.arb"

foreach ($targetFile in $targetFiles) {
    $targetPath = Join-Path $l10nDir $targetFile
    
    if (-not (Test-Path $targetPath)) {
        Write-Host "Warning: $targetFile not found. Skipping."
        continue
    }

    $targetJson = Get-Content $targetPath -Raw | ConvertFrom-Json
    $addedCount = 0
    $updatedCount = 0

    # We need to create a Hashtable or OrderedDictionary to manipulate keys easily
    # Since ConvertFrom-Json returns a PSCustomObject, we can iterate its properties
    
    # Create a new dictionary for the target to ensure we can add keys
    $newTargetData = [ordered]@{}
    
    # Copy existing target data
    foreach ($prop in $targetJson.PSObject.Properties) {
        $newTargetData[$prop.Name] = $prop.Value
    }

    # Add missing keys from master
    foreach ($prop in $masterJson.PSObject.Properties) {
        $key = $prop.Name
        $value = $prop.Value

        if (-not $newTargetData.Contains($key)) {
            $newTargetData[$key] = $value
            $addedCount++
        } elseif ($key -eq "rescannedSuccess") {
            # Check for placeholder mismatch
            $currentVal = $newTargetData[$key]
            if ($currentVal -like "*{breed}*" -and $currentVal -notlike "*{breedName}*") {
                $newTargetData[$key] = $currentVal.Replace("{breed}", "{breedName}")
                
                # Update metadata if exists
                if ($newTargetData.Contains("@rescannedSuccess")) {
                    $meta = $newTargetData["@rescannedSuccess"]
                    # This is tricky in PS with nested objects from JSON
                    # Simpler to just overwrite metadata with master's if we change the key
                    if ($masterJson.PSObject.Properties["@rescannedSuccess"]) {
                        $newTargetData["@rescannedSuccess"] = $masterJson."@rescannedSuccess"
                    }
                }
                $updatedCount++
            }
        }
    }
    
    # Ensure metadata keys are present
    foreach ($prop in $masterJson.PSObject.Properties) {
        $key = $prop.Name
        if ($key.StartsWith("@")) {
            $parentKey = $key.Substring(1)
            if ($newTargetData.Contains($parentKey) -and -not $newTargetData.Contains($key)) {
                $newTargetData[$key] = $prop.Value
                $addedCount++
            }
        }
    }

    # Save back to file
    $newTargetData | ConvertTo-Json -Depth 10 | Set-Content $targetPath -Encoding UTF8
    Write-Host "Updated $targetFile : Added $addedCount keys, Modified $updatedCount keys."
}
