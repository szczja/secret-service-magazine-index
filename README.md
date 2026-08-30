# Secret Service Game Index

An index of games listed in the Polish **Secret Service** magazine, reconstructed from scanned source tables.

This is an experimental project for testing ChatGPT-driven extraction and processing of structured data from scanned magazine pages.

## Project structure

- `Skany/` — source PNG scans.
- `indeks.md` — the main game index.
- `postep-skanowania.md` — processing status of every scan.
- `url.yaml` — mapping between `Secret Service` issue numbers and their Internet Archive identifiers.
- `build.ps1` — generates `indeks_with_urls.md` from `indeks.md`.
- `indeks_with_urls.md` — generated index with links to the corresponding pages on Internet Archive.
- `prompt.md` — processing and data-entry rules.

## Index format

`indeks.md` contains exactly three columns:

| Game Title      | SS Issue | Page |
| --------------- | -------: | ---: |
| 11A SIDE SOCCER |       15 |    9 |
| 11th HOUR       |       33 |   40 |

The original spelling and capitalization are preserved. Multi-line titles are combined into a single title. Uncertain text is marked with `?????` rather than guessed.

## Processing scans

Scans are processed sequentially:

1. Find PNG files directly inside `Skany/`.
2. Select the first file marked `do zrobienia`.
3. Read only that scan.
4. Add its entries to `indeks.md` in source order.
5. Update its status in `postep-skanowania.md`.
6. Do not reprocess files already marked `gotowe` unless explicitly requested.

The index is updated before the corresponding scan is marked as completed.

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

The generated links point to the corresponding magazine pages on Internet Archive.

## Data quality

The project intentionally does not normalize or correct source data based on external knowledge.

When a scan is unclear:

- uncertain text is marked `?????`;
- partial uncertainty is represented directly, e.g. `4?????`;
- duplicates from the source are retained;
- unreadable scans are marked `wymaga sprawdzenia`.

This keeps the index traceable to the scanned source material.

## Current progress

Processed scans are tracked in `postep-skanowania.md`. The file records the status and number of entries extracted from each scan.

## License

The code and scripts in this repository are licensed under the GNU General Public License v3.0.

The scanned magazine material is not covered by this license and remains subject to the rights of its respective copyright holders.

The game index is a derived reference dataset created from the scanned source material.
