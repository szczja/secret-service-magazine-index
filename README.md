# Secret Service Game Index

An index of games listed in the Polish **Secret Service** magazine, reconstructed from scanned source tables.

The project currently contains **868 indexed entries** from processed scans. Each entry records the game title, magazine issue number, and page number. Duplicate entries are preserved when they occur in the source material. fileciteturn0file3L1-L29

## Project structure

- `Skany/` — source PNG scans.
- `indeks.md` — the main game index.
- `postep-skanowania.md` — processing status of every scan.
- `url.yaml` — mapping between `Secret Service` issue numbers and their Internet Archive identifiers.
- `build.ps1` — generates `indeks_with_urls.md` from `indeks.md`.
- `indeks_with_urls.md` — index with links to the corresponding pages on Internet Archive.
- `prompt.md` — processing and data-entry rules.

## Index format

`indeks.md` contains exactly three columns:

| Game Title | SS Issue | Page |
| --- | ---: | ---: |
| 11A SIDE SOCCER | 15 | 9 |
| 11th HOUR | 33 | 40 |

The original spelling and capitalization are preserved. Multi-line titles are combined into a single title. Uncertain text is marked with `?????` rather than guessed. fileciteturn0file0L39-L73 fileciteturn0file0L91-L105

## Processing scans

Scans are processed sequentially:

1. Find PNG files directly inside `Skany/`.
2. Select the first file marked `do zrobienia`.
3. Read only that scan.
4. Add its entries to `indeks.md` in source order.
5. Update its status in `postep-skanowania.md`.
6. Do not reprocess files already marked `gotowe` unless explicitly requested.

The index is updated before the corresponding scan is marked as completed. fileciteturn0file0L19-L31

## Source links

`url.yaml` maps each `Secret Service` issue number to its Internet Archive identifier. `build.ps1` uses this mapping together with the issue and page numbers from `indeks.md` to generate direct archive links.

Run:

```powershell
.\build.ps1
```

This produces:

```text
indeks_with_urls.md
```

The generated links point to the corresponding magazine page on Internet Archive.

## Data quality

The project intentionally does not normalize or correct source data from external knowledge.

When a scan is unclear:

- uncertain text is marked `?????`;
- partial uncertainty is represented directly, e.g. `4?????`;
- duplicates from the source are retained;
- unreadable scans are marked `wymaga sprawdzenia`.

This keeps the index traceable to the scanned source material. fileciteturn0file0L91-L123

## Current progress

Processed scans are tracked in `postep-skanowania.md`. The current state contains completed scans as well as remaining scans awaiting processing. fileciteturn0file2L3-L38
