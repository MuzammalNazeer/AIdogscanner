$l10n_dir = "d:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n"
$files = Get-ChildItem -Path $l10n_dir -Filter "app_*.arb"

$updates = @{
    "gpsAlertsDescription" = "Get instant pet location updates, avoiding the hassle of traditional emails"
    "vetContactsDescription" = "Contacts of the vet, co-owner, and caretaker in `n case the main phone isn't available"
    "messengerDescription" = "An alternative way to contact the owner if it is impossible to call them"
}

foreach ($file in $files) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $json = $content | ConvertFrom-Json
        
        $json.gpsAlertsDescription = $updates["gpsAlertsDescription"]
        $json.vetContactsDescription = $updates["vetContactsDescription"]
        $json.messengerDescription = $updates["messengerDescription"]
        
        $jsonString = $json | ConvertTo-Json -Depth 10
        [System.IO.File]::WriteAllText($file.FullName, $jsonString)
        Write-Host "Updated $($file.Name)"
    } catch {
        Write-Host "Error updating $($file.Name): $_"
    }
}
