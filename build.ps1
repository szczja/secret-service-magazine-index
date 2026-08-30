# make-index-links.ps1
#
# Pliki wejściowe:
#   indeks.md
#   url.yaml
#
# Plik wyjściowy:
#   indeks_with_urls.md

$ErrorActionPreference = 'Stop'

$InputFile  = Join-Path $PSScriptRoot 'indeks.md'
$YamlFile   = Join-Path $PSScriptRoot 'url.yaml'
$OutputFile = Join-Path $PSScriptRoot 'indeks_with_urls.md'

# ------------------------------------------------------------
# Wczytanie url.yaml
# ------------------------------------------------------------

$yamlLines = Get-Content -LiteralPath $YamlFile -Encoding UTF8

$baseUrl = $null
$issues = @{}
$inIssues = $false

foreach ($line in $yamlLines) {

    # base_url: "..."
    if ($line -match '^\s*base_url:\s*"([^"]+)"') {
        $baseUrl = $matches[1]
        continue
    }

    # issues:
    if ($line -match '^\s*issues:\s*$') {
        $inIssues = $true
        continue
    }

    if ($inIssues -and
        $line -match '^\s*(\d+):\s*(.+?)\s*$') {

        $number = [int]$matches[1]
        $archiveId = $matches[2].Trim()

        # Usuwamy ewentualne cudzysłowy
        $archiveId = $archiveId.Trim('"').Trim("'")

        $issues[$number] = $archiveId
    }
}

if (-not $baseUrl) {
    throw "Nie znaleziono base_url w pliku url.yaml."
}

if ($issues.Count -eq 0) {
    throw "Nie znaleziono mapowania issues w pliku url.yaml."
}

# ------------------------------------------------------------
# Funkcja tworząca URL
# ------------------------------------------------------------

function New-ArchiveUrl {
    param(
        [int]$IssueNumber,
        [int]$Page
    )

    if (-not $issues.ContainsKey($IssueNumber)) {
        Write-Warning "Brak numeru SS $IssueNumber w url.yaml."
        return $null
    }

    $archiveId = $issues[$IssueNumber]

    $url = $baseUrl
    $url = $url.Replace('{archive_id}', $archiveId)
    $url = $url.Replace('{page}', [string]$Page)

    return $url
}

# ------------------------------------------------------------
# Przetwarzanie indeks.md
# ------------------------------------------------------------

$lines = Get-Content -LiteralPath $InputFile -Encoding UTF8

$result = New-Object System.Collections.Generic.List[string]

foreach ($line in $lines) {

    # Przetwarzamy wyłącznie wiersze tabeli:
    #
    # | NAZWA GRY | NUMER | STRONA |
    #
    if ($line -match '^\|\s*(.*?)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*$') {

        $game  = $matches[1].Trim()
        $issue = [int]$matches[2]
        $page  = [int]$matches[3]

        $url = New-ArchiveUrl -IssueNumber $issue -Page $page

        if ($url) {
            # Zabezpieczenie tekstu linku przed znakami Markdown.
            $linkText = $game.Replace('\', '\\')
            $linkText = $linkText.Replace('[', '\[')
            $linkText = $linkText.Replace(']', '\]')

            $result.Add("| [$linkText]($url) | $issue | $page |")
        }
        else {
            # Jeżeli brak mapowania, zachowujemy oryginalny wiersz.
            $result.Add($line)
        }
    }
    else {
        # Nagłówek tabeli i pozostałe wiersze pozostają bez zmian.
        $result.Add($line)
    }
}

# ------------------------------------------------------------
# Zapis UTF-8
# ------------------------------------------------------------

[System.IO.File]::WriteAllLines(
    $OutputFile,
    $result,
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host ""
Write-Host "Gotowe." -ForegroundColor Green
Write-Host "Plik: $OutputFile"