
$files = @(
    "app_de.arb", "app_es.arb", "app_fr.arb", "app_id.arb", 
    "app_it.arb", "app_nl.arb", "app_pt.arb", "app_tr.arb", 
    "app_el.arb", "app_sv.arb", "app_da.arb", "app_cs.arb"
)

$jsonToAdd = @"
,
    "profileRecentScan": "Recent Scan",
    "profileHistory": "History",
    "profileMyFavorites": "My Favourites",
    "shareDownloadNow": "Download now: ",
    "dialogShareTitle": "Share {appName}",
    "@dialogShareTitle": {
        "placeholders": {
            "appName": {
                "type": "String"
            }
        }
    }
"@

foreach ($file in $files) {
    $path = "d:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n\$file"
    if (Test-Path $path) {
        $content = Get-Content $path -Raw -Encoding UTF8
        $content = $content.TrimEnd()
        if ($content.EndsWith("}")) {
            $content = $content.Substring(0, $content.Length - 1) + $jsonToAdd + "`n}"
            Set-Content -Path $path -Value $content -Encoding UTF8
            Write-Host "Updated $file"
        } else {
            Write-Host "Skipping ${file}: Does not end with }"
        }
    } else {
        Write-Host "File not found: $path"
    }
}
