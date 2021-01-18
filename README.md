# **MCDM**
Celem tej aplikacji jest podejmowanie decyzji w oparciu o wiele kryteriów (MCDM). Ta aplikacja używa języka R jako „silnika” do obliczeń i analiz. Jest to implementacja pakietu MCDM.
Obecnie obsługiwane metody są następujące:

* Multi-Objective Optimization poprzez analizę współczynników (MOORA) i „Full Multiplicative Form” (Multi-MOORA).
* Technika kolejności preferencji według podobieństwa do rozwiązania idealnego (TOPSIS) Metoda z liniową transformacją maksimum jako procedurą normalizacyjną.
* Technika kolejności preferencji według podobieństwa do idealnego rozwiązania (TOPSIS) Metoda z procedurą normalizacji wektorów.
* Metoda VIKOR.
* Metoda ważonej sumy sumarycznej (WASPAS).
* Meta Ranking rankingów uzyskanych z metod MMOORA, TOPSIS, VIKOR i WASPAS. Proponowane są dwa rankingi meta, czyli suma rankingów i rankingi zagregowane.

## Główne funkcje z zmiennymi

Funkcja MetaRanking_custom opiera się głównie na parametrach `decision`, `weights`, `cb`, `lambda`, `v`, `AB`, `CD`.
- MMoora = MMOORA(decision, weights, cb)
- TopsisV = TOPSISVector(decision, weights, cb)
- TopsisL = TOPSISLinear(decision, weights, cb)
- Vikor = VIKOR(decision, weights, cb, v)
- Waspas = WASPAS(decision, weights, cb, lambda)

## Przykładowe dane
Dane zostały tutaj pobrane z dokumentu Profesora Witczaka. Na ich podstawie można przeanalizować:
- Rentowność operacyjną: zysk operacyjny / przychody.
- Rentowność netto: zysk netto / przychody.
- ROE (zwrot z kapitału): zysk netto / stan kapitału własnego pod koniec minionego roku obrotowego.
- ROA (zwrot z aktywów): zysk netto / stan aktywów pod koniec minionego roku obrotowego.
- Wypłacalność natychmiastową: środki pieniężne / zobowiązania krótkoterminowe.
- Płynność bieżącą: aktywa obrotowe / zobowiązania krótkoterminowe.
- Złotą regułę bilansową: kapitał własny / aktywa trwałe (reguła jest wypełniona, gdy wskaźnik ma wartość wyżsżą niż 1 pkt).
- Rotację aktywów: pomaga określić, w jaki sposób pozycjonować swoje inwestycje, aby wykorzystać wzrost zarówno akcji, jak i obligacji, jednocześnie w dużej mierze unikając tych niefortunnych okresów dużych spadków na rynku.
- Zadłużenie ogólne: zobowiązania / suma bilansowa.
Są tam również dodatkowe pliki "Comma Separated Value", które można wgrać do programu i testować na nich jak zachowa się algorytm.

## Jak przygotować zbiór danych?
Możliwości jest wiele, można zrobić to w dowolnym programie typu **Excel** czy **OpenOffice**, można skorzystać z różnych baz danych i pozmieniać je na własne potrzeby. Serdecznie polecam ![archive.ics.uci.edu](https://archive.ics.uci.edu/ml/index.php), bądź ![kaggle.com](https://www.kaggle.com/). Po tym gdy już się wybierze dane, trzeba zrobić jedną tabelkę z alternatywami, najlepiej numerując każdy wiersz. Plik trzeba zapisać w formacie `.csv` inaczej *Comma Separated Value* i upewnić się, że zmienne oddzielane są przecinkiem. Później można wszystko wgrać do programu i analizować dane, jeśli wszystko się dobrze podało. Trzeba również pamiętać o tym, aby suma ważenia wynosiła 1, w innym przypadku program nie zadziała.

### Wdrażanie metody MULTIMOORA w wielokryterialnych problemach decyzyjnych.
- Funkcja `MMOORA` implementuje zarówno optymalizację wielocelową poprzez analizę racji (MOORA), jak i "pełną formę multiplikatywną" (MULTIMOORA).
- Parametr `decision` to macierz decyzyjna `m x n` z wartościami `m` alternatyw dla kryteriów `n`. Inaczej macierz z wszystkimi alternatywami.
- Parametr `weights` to wektor o długości `n`, zawierający wagi dla kryteriów. Suma wag musi wynosić 1. Inaczej wektor z wartościami liczbowymi wag.
- Parametr `cb` to wektor długości `n`. Każdy składnik to albo `cb(i)='max'`, jeśli kryterium `i(x)` to korzyść, albo `cb(i)='min'`, jeśli kryterium `i(x)` to koszt. Inaczej wektor z „typem” kryteriów (korzyść = „max”, koszt = „min”).
- `MMOORA` zwraca ramkę danych, która zawiera wyniki i cztery obliczone rankingi (system współczynników, punkt odniesienia, forma multiplikatywna i ranking Multi-MOORA).
- Źródła: Brauers, W. K. M.; Zavadskas, E. K. Project management by MULTIMOORA as an instrument for transition economies. Technological and Economic Development of Economy, 16(1), 5-24, 2010.

Metoda MMOORA w kilku krokach:
- Sprawdzanie argumentów.
- Normalizacja i ważenie.
- System racji.
- Punkt odniesienia.
- Forma multiplikatywna.
- Ranking i alternatywy.

### Wdrożenie metody TOPSISLinear dla wielokryterialnych problemów decyzyjnych.
- Funkcja `TOPSISLinear` implementuje technikę kolejności preferencji przez podobieństwo do idealnego rozwiązania (TOPSIS) z liniową transformacją maksimum jako procedurą normalizacji.
- Parametr `decision` to macierz decyzyjna `m x n` z wartościami `m` alternatyw dla kryteriów `n`. Inaczej macierz z wszystkimi alternatywami.
- Parametr `weights` to wektor o długości `n`, zawierający wagi dla kryteriów. Suma wag musi wynosić 1. Wektor z wartościami liczbowymi wag.
- Parametr `cb` to wektor długości `n`. Każdy składnmik to albo `cb(i)='max'`, jeśli kryterium `i(x)` to korzyść, albo `cb(i)='min'` jeśli kryterium `i(x)` to koszt. Wektor z „typem” kryteriów (korzyść = „max”, koszt = „min”).
- `TOPSISLinear` zwraca ramkę danych, która zawiera wynik indeksu R i ranking alternatyw.
- Źródła: Garcia Cascales, M.S.; Lamata, M.T. On rank reversal and TOPSIS Method. Mathematical and Computer Modelling, 56(5-6), 123-132, 2012.

Metoda w kilku krokach:
- Sprawdzanie argumentów.
- Normalizacja i ważenie.
- Idealne rozwiązania.
- Odległości do idealnych rozwiązań.
- Indeks R.
- Oceń alternatywy.

### Wdrożenie metody TOPSISVector w przypadku wielokryterialnych problemów decyzyjnych
- Funkcja `TOPSISVector` implementuje technikę kolejności preferencji według metody podobieństwa idealnego rozwiązania (TOPSIS) z procedurą normalizacji wektorowej.
- Parametr `decision` to macierz decyzyjna `m x n`, z wartościami alternatyw `m` dla kryteriów `n`. Inaczej macierz z wszystkimi alternatywami.
- Parametr `weights` to wektor o długości `n` zawierającej wagi kryteriów. Suma wag musi wynosić 1. Inaczej wektor z wartościami liczbowymi wag.
- Parametr `cb` to wektor długości `n`. Każdy składnik to albo `cb(i)='max'`, jeśli kryterium `i(x)` to korzyść, albo `cb(i)='min'`, jeśli `i(x)` kryterium to koszt. Inaczej wektor z „typem” kryteriów (korzyść = „max”, koszt = „min”).
- `TOPSISVector` zwraca ramkę danych, która zawiera wynik indeksu R i ranking alternatyw.
- Źródła: Hwang, C.L.; Yoon, K. Multiple Attribute Decision Making.

Metoda w kilku krokach:
- Normalizacja i ważenie.
- Idealne rozwiązania.
- Odległości do idealnych rozwiązań.
- Indeks R.
- Oceń alternatywy.

### Wdrożenie metody VIKOR do wielokryterialnych problemów decyzyjnych.
- Funkcja `VIKOR` implementuje metodę "VIseKriterijumska Optimizacija I Kompromisno Resenje" (VIKOR).
- Parametr `decision` to macierz decyzyjna `m x n` z wartościami `m` alternatyw dla kryteriów `n`. Macierz ze wszystkimi alternatywami.
- Parametr `weights` to wektor o długości `n`, zawierający wagi dla kryteriów. Suma wag musi wynosić 1. Wektor z wartościami liczbowymi wag.
- Parametr `cb` to wektor długości `n`. Każdy składnik to albo `cb(i)='max'`, jeśli kryterium `i(x)` to koszt. Wektor z „typem” kryteriów (korzyść = „max”, koszt = „min”).
- Parametr `v` to wartość A w `[0,1]`. Jest używany do oblcizania wskaźnika Q. Wartość rzeczywistą liczbą parametru „v” do obliczenia Q.
- `VIKOR` zwraca ramkę danych, która zawiera wynik wskaźników S, R i Q oraz ranking alternatyw według indeksu Q.
- Źródła: Opricovic, S.; Tzeng, G.H. Compromise solution by MCDM methods: A comparative analysis of VIKOR and TOPSIS. European Journal of Operational Research, 156(2), 445-455, 2004.

Metoda w kilku krokach:
- Sprawdzanie parametrów.
- Idealne rozwiązania.
- Indeks S i R.
- Indeks Q. Jeśli v = 0, jeśli v = 1, inny przypadek.
- Sprawdzanie, czy Q jest poprawne.
- Ranking alternatyw.

### Wdrożenie metody WASPAS dla wielokryterialnych problemów decyzyjnych.
- Funkcja `WASPAS` implementuje metodę Weighted Aggregated Sum Product Assessment (WASPAS).
- Parametr `decision` to macierz decyzyjna `m x n` z wartościami `m` alternatyw dla kryeriów `n`. Inaczej macierz ze wszystkimi alternatywami.
- Parametr `weights` to wektor o długości `n`, zawierjący wagi dla kryeriów. Suma wag musi wynosić 1. Inaczej wektor z wartościami liczbowymi wag.
- Parametr `cb` to wektor długości `n`. Każdy składnik to albo `cb(i)='max'`, jeśli kryterium `i(x)` to korzyść, albo `cb(i)='min'`, jeśli kryterium `i(x)` to koszt. Inaczej wektor z „typem” kryteriów (korzyść = „max”, koszt = „min”).
- Parametr `lambda` to wartość `A` w `[0,1]`. Jest używany do obliczania wskaźnika `W`. Inaczej wartość z liczbą rzeczywistą parametru „lambda” do obliczenia **W**.
- `WASPAS` zwraca ramkę danych, która zawiera wynik **WSM**, **WPM** i **indeks Q** oraz ranking alternatyw.
- Źródła: Zavadskas, E. K.; Turskis, Z.; Antucheviciene, J.; Zakarevicius, A. Optimization of Weighted Aggregated Sum Product Assessment. Electronics and Electrical Engineering, 122(6), 3-6, 2012.

Metoda WASPAS w kilku krokach:
- Sprawdzanie argumentów.
- Normalizacja.
- WSM.
- WPM.
- Indeks Q.
- Ranking alternatyw.

### Implementacja funkcji MetaRanking dla wielokryterialnych problemów decyzyjnych.
- Funkcja `MetaRanking` wewnętrznie wywołuje funkcje `MMOORA`, `RIM`, `TOPSISLinear`, `TOPSISVector`, `VIKOR`, `WASPAS` oraz następnie oblicza sumę ich rankingów i zagregowany ranking stosując pakiet `RankAggreg`.
- Parametr `decision` to macierz decyzyjna `m x n` z wartościami `m` alternatyw dla kryteriów `n`. Inaczej macierz ze wszystkimi alternatywami.
- Parametr `weights` to wektor o długości `n`, zawierający wagi dla kryteriów. Suma wag musi wynosić 1. Inaczej wektor z wartościami liczbowymi wag.
- Parametr `cb` to wektor długości `n`. Każdy składnik to albo `cb(i)='max'`, jeśli kryterium `i(x)` to korzyść, albo `cb(i)='min'`, jeśli kryterium `i(x)` to koszt. Inaczej wektor z „typem” kryteriów (korzyść = „max”, koszt = „min”).
- Parametr `lambda` to wartość **A** w `[0,1]`. Służy do obliczania wskaźnika W dla metody WASPAS. Inaczej wartość z liczbą rzeczywistą parametru „lambda” do obliczenia W.
- Parametr `v` Wartość A w [0,1]. Jest używany do obliczania wskaźnika Q dla metody VIKOR. Inaczej wartość z liczbą rzeczywistą parametru „v” do obliczenia Q.
- Parametr `AB` to macierz. `AB[1,]` odpowiada ekstremum A, a `AB[2]` reprezentuje ekstremum B dziedziny każdego kryerium. Inaczej macierz z zakresem [A,B] wszechświata dyskursu.
- Parametr `CD` to macierz. `CD[1,]` odpowiada ekstremum C, a `CD[2]` reprezentuje ekstremum D idealnego odniesienia każdego kryterium. Inaczej macierz z ideałem odniesienia [C,D].
- `MetaRanking` zwraca ramkę danych, która zawiera rankingi metod `Multi-MOORA`, `RIM`, `TOPSISLinear`, `TOPSISVector`, `VIKOR`, `WASPAS` i obu alternatyw `MetaRanking`.

Metoda Multi-MOORA w krokach:
- RIM.
- Metoda TOPSIS.
- Metoda VIKOR.
- Metoda WASPAS.
- Meta-Ranking.
- Ranking zbiorczy.