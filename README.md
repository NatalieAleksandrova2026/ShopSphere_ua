# ShopSphere — Umfassende Geschäftsanalyse eines globalen Online-Marktplatzes

**Abschlussprojekt im Bereich Datenanalyse:** SQL → Tableau → Handlungsempfehlungen für die CEO

[![SQL](https://img.shields.io/badge/SQL-SQLite-blue)]()
[![Tableau](https://img.shields.io/badge/Visualization-Tableau-orange)]()
[![Report](https://img.shields.io/badge/Report-Deutsch-green)]()

---

## Über das Projekt

ShopSphere ist ein globaler Online-Marktplatz, der Produkte aus 7 Kategorien in 5 Regionen weltweit verkauft. Die CEO des Unternehmens wandte sich mit dem Anliegen an das Analyseteam, das Geschäft jenseits oberflächlicher Wachstumszahlen tiefer zu verstehen: Wohin fließt das Marketingbudget, und ist es effizient eingesetzt? Wer sind die wertvollsten Kunden? Welche Kategorien sind wirklich profitabel? Welche Regionen bestimmen das künftige Wachstum? Und hat das Experiment des Produktteams mit dem neuen Checkout-Design funktioniert?

Dieses Repository enthält den vollständigen Analysezyklus — von SQL-Abfragen auf Rohdaten bis hin zu fertigen interaktiven Dashboards und konkreten Handlungsempfehlungen für die Geschäftsleitung.

## 🔗 Live-Dashboard auf Tableau Public

**[Interaktives Dashboard CEO_Dashboard öffnen →](https://public.tableau.com/app/profile/natalie.alexandrova2389/viz/ShopSphere_17843895943230/CEO_Dashboard)**

## Inhalt des Repositorys

```
ShopSphere_ua/
├── report.md               — finaler Analysebericht (auf Deutsch)
├── README.md                — diese Datei (Ukrainisch)
├── README_de.md              — diese Datei (Deutsch)
├── Tableau/
│   ├── Screenshot_*.png      — Screenshots aller 14 Diagramme und Dashboards
│   ├── Case_Marketing.png    — Screenshot des Dashboards Case_A_Marketing
│   └── Tableau_link/
│       └── ShopSphere.twbx   — Tableau-Arbeitsmappe (alle Blätter und Dashboards)
└── SQL/
    ├── queries.sql           — Texte aller SQL-Abfragen des Projekts
    └── data/                 — Abfrageergebnisse (CSV / Excel)
```

## Aufbau der Analyse

Das Projekt gliedert sich in fünf Kapitel, die jeweils unterschiedliche Fähigkeiten eines Datenanalysten prüfen:

| Kapitel | Inhalt |
|---|---|
| **1. SQL** | Datenaufbereitung: JOIN, Unterabfragen, CTE, Fensterfunktionen (`NTILE`) — Abfragetexte in [`SQL/queries.sql`](./SQL/queries.sql) |
| **2. Visualisierungen** | 6 zentrale Diagramme in Tableau — Saisonalität, ROI der Kanäle, Kategorien, Regionen, Pareto-Prinzip, Conversion-Funnel |
| **3. Dashboards** | Zwei interaktive Dashboards mit funktionsfähigen Filtern: Haupt-Dashboard für die CEO sowie ein eigenes Dashboard für den Marketing-Case |
| **4. Business Cases** | Drei strategische Cases (Marketingbudget, Kategorien-Profitabilität, Rabatte) + Profil der Top-5-%-Kunden |
| **5. A/B-Experiment** | Statistische Analyse des Checkout-Tests inklusive methodischer Vorbehalte |

## Wichtigste Erkenntnisse

- 📊 **5 % der Kunden erwirtschaften 35 % des gesamten Unternehmensumsatzes**
- 💸 **Das größte Marketingbudget fließt in den am wenigsten effizienten Kanal** (Paid Search: höchste Ausgaben, niedrigster ROI)
- 🌏 **Südostasien wächst fünfmal schneller als Nordamerika**, obwohl Letzteres beim absoluten Umsatz führt
- 🏷️ **Rabatt-Kunden erwirtschaften über die gesamte Kundenbeziehung dreimal weniger Umsatz** als übrige Kunden
- 🧪 **A/B-Test des Checkouts:** Die Gesamtverbesserung von +2 % verschleiert die eigentliche Lage — +19,2 % bei Neukunden gegenüber +0,9 % bei den übrigen 93 % der Bestellungen (eine klassische Lehre darüber, wann einem Durchschnittswert nicht zu trauen ist)

Die vollständige Liste der Handlungsempfehlungen findet sich im Kapitel **"Schlussfolgerungen und Handlungsempfehlungen"** der Datei [`report.md`](./report.md).

## Verwendete Tools

- **SQL (SQLite)** — Datenaufbereitung und Aggregation
- **Tableau** — Visualisierungen und interaktive Dashboards ([Tableau Public](https://public.tableau.com/app/profile/natalie.alexandrova2389/viz/ShopSphere_17843895943230/CEO_Dashboard) + lokale Datei [`ShopSphere.twbx`](./Tableau/Tableau_link/ShopSphere.twbx))

## So nutzt man dieses Repository

1. Beginne mit dem Bericht [`report.md`](./report.md) — er enthält den vollständigen Analysetext mit Tabellen, Schlussfolgerungen und eingebetteten Diagramm-Screenshots
2. Um die Dashboards "live" zu sehen und selbst mit den Filtern zu arbeiten, öffne **[Tableau Public](https://public.tableau.com/app/profile/natalie.alexandrova2389/viz/ShopSphere_17843895943230/CEO_Dashboard)**
3. Die Texte aller SQL-Abfragen samt Erläuterung der Logik finden sich in [`SQL/queries.sql`](./SQL/queries.sql), die Abfrageergebnisse in [`SQL/data/`](./SQL/data)
4. Die Original-Screenshots in hoher Auflösung liegen im Ordner [`Tableau/`](./Tableau)

## Autorin

Nataliia Aleksandrova · 2026

---

*Dieses Projekt wurde im Rahmen eines Datenanalyse-Kurses als Simulation des vollständigen Arbeitszyklus eines Analysten erstellt: von Rohdatentabellen bis zur Präsentation vor der Geschäftsführung.*
