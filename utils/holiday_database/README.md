Für jedes Bundesland bzw. jedes Kanton etc. gib es eine eigene **Region**. Eine Region ist ein geschlossenes System mit
festen Feriendaten. Die ID definiert die Region. Sie ist an die ISO Normen der Länder und Bundesländer gerichtet, siehe
z.B.: https://de.wikipedia.org/wiki/ISO_3166-2:DE
Für jede Region gibt es einen Ordner, in welchem die Daten für die Region enthalten sind. In info.json befinden sich die
Informationen zur Region:
Beispiel NRW:

```json
{
  "id": "de-nw",
  "name": "Nordrhein Westfalen",
  "country": "germany",
  "lastRefreshed": "2019-08-29",
  "years": [
    "2019",
    "2020"
  ],
  "isOfficial": true,
  "published": true
}
```

Datumsangaben folgen im ISO-8601 Format: yyyy-MM-TT Für die jeweiligen Jahre wird eine seperate .json File erstellt, um
die einzelnen Dateien klein und übersichtlich zu halten:
Also 2019.json, 2020.json, 2021.json etc:
Folgendes format wird für die Feriendaten verwendet (Beispiel NRW):

```json
{
  "2019-herbst": {
    "id": "2019-herbst",
    "name": "Herbstferien",
    "start": "2019-10-14",
    "end": "2019-10-26",
    "type": "holiday"
  },
  "2019-weihnachten": {
    "id": "2019-weihnachten",
    "name": "Weihnachtsferien",
    "start": "2019-12-23",
    "end": "2020-01-06",
    "type": "holiday"
  }
}
```

Ich hoffe wir schaffen es schnell eine vollständige Sammlung aller Feriendaten zu schaffen.
