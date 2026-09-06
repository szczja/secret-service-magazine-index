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
$offsets = @{}
$inIssues = $false
$inOffsets = $false
$currentOffsetIssue = $null

foreach ($line in $yamlLines) {

    # base_url: "..."
    if ($line -match '^\s*base_url:\s*"([^"]+)"') {
        $baseUrl = $matches[1]
        continue
    }

    # offsets:
    if ($line -match '^\s*offsets:\s*$') {
        $inOffsets = $true
        $inIssues = $false
        continue
    }

    # issues:
    if ($line -match '^\s*issues:\s*$') {
        $inIssues = $true
        $inOffsets = $false
        continue
    }

    if ($inOffsets) {
        # Numerowany wpis offsetów, np. "  1:"
        if ($line -match '^\s+(\d+):\s*$') {
            $currentOffsetIssue = [int]$matches[1]
            $offsets[$currentOffsetIssue] = @{
                InitialOffset = 0
                PageOffsets   = New-Object System.Collections.Generic.List[object]
            }
            continue
        }

        if ($null -ne $currentOffsetIssue -and
            $line -match '^\s+initial_offset:\s*(-?\d+)\s*$') {
            $offsets[$currentOffsetIssue].InitialOffset = [int]$matches[1]
            continue
        }

        # Aktywna reguła page_offsets.
        # Przykład:
        #   - from_page: 19
        #     offset: 16
        #
        # UWAGA: ten warunek musi być przed warunkiem dla "offset".
        # Zakomentowane przykłady zaczynające się od "#" są ignorowane.
        if ($null -ne $currentOffsetIssue -and
            $line -match '^\s*-\s*from_page:\s*(\d+)\s*$') {
            $fromPage = [int]$matches[1]
            $offsets[$currentOffsetIssue].PageOffsets.Add(@{
                FromPage = $fromPage
                Offset   = 0
            })
            continue
        }

        if ($null -ne $currentOffsetIssue -and
            $line -match '^\s+offset:\s*(-?\d+)\s*$') {
            $rules = $offsets[$currentOffsetIssue].PageOffsets
            if ($rules.Count -eq 0) {
                throw "offset bez poprzedzającego from_page dla numeru SS $currentOffsetIssue."
            }
            $rules[$rules.Count - 1].Offset = [int]$matches[1]
            continue
        }
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

function Get-PageOffset {
    param(
        [int]$IssueNumber,
        [int]$Page
    )

    # Domyślnie brak przesunięcia. Dzięki temu brak wpisu w offsets
    # nie zmienia dotychczasowego zachowania skryptu.
    if (-not $offsets.ContainsKey($IssueNumber)) {
        return 0
    }

    $config = $offsets[$IssueNumber]
    $totalOffset = [int]$config.InitialOffset

    # Każdy aktywny offset obowiązuje od podanej strony drukowanej
    # i jest dodawany do offsetu początkowego.
    foreach ($rule in $config.PageOffsets) {
        if ($Page -ge [int]$rule.FromPage) {
            $totalOffset += [int]$rule.Offset
        }
    }

    return $totalOffset
}

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
    $pdfPage = $Page + (Get-PageOffset -IssueNumber $IssueNumber -Page $Page)

    $url = $baseUrl
    $url = $url.Replace('{archive_id}', $archiveId)
    $url = $url.Replace('{page}', [string]$pdfPage)

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