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