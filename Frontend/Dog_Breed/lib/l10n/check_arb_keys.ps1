
$enFile = "d:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n\app_en.arb"
$l10nDir = "d:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n"

if (-not (Test-Path $enFile)) {
    Write-Error "app_en.arb not found!"
    exit 1
}

$enJson = Get-Content $enFile -Raw | ConvertFrom-Json
$enKeys = $enJson.PSObject.Properties.Name | Where-Object { $_ -notmatch "^@" }

$arbFiles = Get-ChildItem $l10nDir -Filter "app_*.arb"

foreach ($file in $arbFiles) {
    if ($file.Name -eq "app_en.arb") { continue }
    
    $lang = $file.Name.Replace("app_", "").Replace(".arb", "")
    $content = Get-Content $file.FullName -Raw
    
    try {
        $json = $content | ConvertFrom-Json
        $keys = $json.PSObject.Properties.Name
        
        $missing = $enKeys | Where-Object { $keys -notcontains $_ }
        
        if ($missing) {
            Write-Host "Language: $lang - Missing keys:"
            foreach ($key in $missing) {
                Write-Host "  $key"
            }
        } else {
            Write-Host "Language: $lang - OK"
        }
    } catch {
        Write-Error "Error parsing $($file.Name): $_"
    }
}
