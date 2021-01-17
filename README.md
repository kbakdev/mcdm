# **MCDM**
Celem tej aplikacji jest podejmowanie decyzji w oparciu o wiele kryteriów (MCDM). Ta aplikacja używa języka R jako „silnika” do obliczeń i analiz. Jest to implementacja pakietu MCDM.
Obecnie obsługiwane metody są następujące:

* Multi-Objective Optimization poprzez analizę współczynników (MOORA) i „Full Multiplicative Form” (Multi-MOORA).
* Technika kolejności preferencji według podobieństwa do rozwiązania idealnego (TOPSIS) Metoda z liniową transformacją maksimum jako procedurą normalizacyjną.
* Technika kolejności preferencji według podobieństwa do idealnego rozwiązania (TOPSIS) Metoda z procedurą normalizacji wektorów.
* Metoda VIKOR.
* Metoda ważonej sumy sumarycznej (WASPAS).
* Meta Ranking rankingów uzyskanych z metod MMOORA, TOPSIS, VIKOR i WASPAS. Proponowane są dwa rankingi meta, czyli suma rankingów i rankingi zagregowane.

## spolki-miesne.csv / spolki-zywnosciowe.csv
Dane zostały tutaj pobrane z dokumentu Pana Witczaka. Na ich podstawie można przeanalizować:
- Rentowność operacyjną
- Rentowność netto
- ROE
- ROA
- Wypłacalność natychmiastową
- Płynność bieżącą
- Złotą regułę
- Rotację aktywów
- Zadłużenie

## zbior_danych_prosty.csv / zbior_danych.csv / test.csv
Te pliki służą jako podstawowe pliki "Comma Separated Value", które można wgrać do programu i testować na nich jak zachowa się algorytm.