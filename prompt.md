Zbuduj i konsekwentnie uzupełniaj indeks gier na podstawie skanów `.png` z folderu `Skany`.



Prowadź dwa pliki Markdown w głównym katalogu projektu:



\- `indeks.md` — właściwy indeks, wyłącznie trzy kolumny.

\- `postep-skanowania.md` — rejestr wszystkich plików i ich stanu przetworzenia.



Nie zmieniaj ani nie usuwaj innych plików.



\## Pliki i kolejność pracy



1\. Odszukaj wszystkie pliki `.png` bezpośrednio w folderze `Skany`.

2\. Jeśli `postep-skanowania.md` nie istnieje, utwórz go i dodaj do niego wszystkie znalezione pliki, po jednym wierszu, ze statusem `do zrobienia`.

3\. Przy poleceniu „przetwórz kolejny plik” wybierz pierwszy plik o statusie `do zrobienia`, przeanalizuj wyłącznie ten jeden skan i zaktualizuj oba pliki.

4\. Nie przetwarzaj ponownie pliku oznaczonego jako `gotowe`, chyba że wyraźnie o to poproszę.

5\. Najpierw bezpiecznie zapisz wpisy do `indeks.md`, a dopiero potem zmień status pliku w `postep-skanowania.md`.



\## Znaczenie tabel na skanach



Każdy skan zawiera tabelę:



| Tytuł gry | Numer SS | Str. |

| --- | ---: | ---: |



\- `Numer SS` oznacza numer magazynu „Secret Service”.

\- `Str.` oznacza numer strony tego magazynu.

\- Każdy kompletny wpis musi zawierać tytuł, numer SS i stronę.



\## Dokładne odczytywanie



\- Odczytuj tabelę wizualnie z obrazu. OCR może pomóc, ale nie wolno na nim polegać bez sprawdzenia obrazu.

\- Analizuj skan w oryginalnej jakości. W razie potrzeby przybliż fragmenty, aby zweryfikować drobny druk, cyfry i granice wierszy.

\- Traktuj numer SS i stronę jako zakończenie jednego logicznego wpisu.

\- Tytuł może być zapisany w kilku liniach. Połącz wszystkie jego linie w jeden tytuł, pojedynczymi spacjami.

\- Linia zaczynająca się od myślnika jest kontynuacją tytułu, a nie osobnym wpisem. Zachowaj myślnik jako część tytułu, np. `WING COMMANDER 3 - HEART OF THE TIGER`.

\- Nie dodawaj łamań wiersza wewnątrz tytułu w `indeks.md`.

\- Nie usuwaj powtórzeń. Dwa identyczne tytuły w źródle to dwa oddzielne wpisy, jeśli występują w osobnych wierszach lub mają inne wartości SS/strony.

\- Nie poprawiaj tytułów „z pamięci”, nie normalizuj pisowni i nie zgaduj brakujących danych.



Przykłady:



\- `ZONE 66 | 10 | 22` jest poprawnym odczytem pierwszego wiersza skanu `Zrzut ekranu 2026-08-29 201518.png`.

\- Dwuliniowy tytuł `WOODRUFF AND THE SCHNIBBLE / OF AZIMUTH` należy zapisać jako `WOODRUFF AND THE SCHNIBBLE OF AZIMUTH | 25 | 44`.

\- Jeśli ten sam tytuł widnieje ponownie w tabeli, zachowaj również drugi wpis.



\## Niepewności i kontrola jakości



Nie zgaduj. Każdą niepewność oznacz dosłownie przez `?????` w odpowiedniej komórce:



\- niepewny fragment tytułu: `WOLF ?????`

\- niepewny cały tytuł: `?????`

\- niepewny numer SS lub strony: `?????`

\- częściowo niepewna liczba: `4?????`



Po odczytaniu skanu wykonaj kontrolę:



1\. sprawdź, czy każdy widoczny logiczny wpis ma trzy wartości;

2\. porównaj liczbę wpisów z liczbą par `Numer SS` + `Str.` widocznych w tabeli;

3\. upewnij się, że nie pomylono kontynuacji długiego tytułu z nowym wpisem;

4\. oznacz `?????` przy każdej niejasności, zamiast dopowiadać dane.



Jeżeli skan jest czytelny częściowo, ale wszystkie możliwe wpisy zapisano z oznaczeniami `?????`, uznaj go za ukończony. Status `wymaga sprawdzenia` stosuj tylko wtedy, gdy pliku nie można rzetelnie odczytać w całości, np. jest uszkodzony lub jego fragment jest niewidoczny.



\## Format `indeks.md`



Jeżeli plik nie istnieje, utwórz go dokładnie w tym formacie:



```md

| Tytuł gry | Numer SS | Str. |

| --- | ---: | ---: |

```



Dopisywane rekordy zapisuj tak:



```md

| ZONE 66 | 10 | 22 |

| WOODRUFF AND THE SCHNIBBLE OF AZIMUTH | 25 | 44 |

```



Zasady:



\- `indeks.md` ma zawierać tylko nagłówek i dane tabeli — bez źródeł, komentarzy, nazw plików i dodatkowych kolumn.

\- Zachowaj kolejność wpisów od góry do dołu na skanie.

\- Kolejne przetworzone pliki dopisuj na końcu indeksu.

\- Zabezpieczaj pionową kreskę w tytule jako `\\|`, aby nie uszkodzić tabeli Markdown.

\- Nie twórz duplikatów przez ponowne przetworzenie tego samego pliku.



\## Format `postep-skanowania.md`



Jeżeli plik nie istnieje, utwórz go dokładnie w tym formacie:



```md

| Plik | Status | Wpisy | Uwagi |

| --- | --- | ---: | --- |

```



Znaczenie kolumn:



\- `Plik` — dokładna nazwa pliku PNG.

\- `Status` — `do zrobienia`, `gotowe` albo `wymaga sprawdzenia`.

\- `Wpisy` — liczba wpisów zapisanych z tego skanu.

\- `Uwagi` — `—`, liczba wpisów zawierających `?????`, albo krótki opis problemu.



Przykładowe wiersze:



```md

| Zrzut ekranu 2026-08-29 201518.png | gotowe | 8 | — |

| Zrzut ekranu 2026-08-29 201320.png | gotowe | 91 | 2 wpisy z `?????` |

| Zrzut ekranu 2026-08-29 201309.png | do zrobienia | — | — |

```



\## Raport po każdym pliku



Po zakończeniu przetwarzania jednego skanu podaj krótko:



\- nazwę pliku;

\- liczbę dodanych wpisów;

\- status;

\- listę wpisów zawierających `?????`, jeśli występują.



Nie przechodź samodzielnie do następnego pliku, chyba że wyraźnie poproszę o przetworzenie wszystkich pozostałych skanów.

