# Построение: 
Необходима коллекция wiki.

Пример документа:
```json
{
  "title": "Basics",
  "tags": [
    "Draconium Ore"
  ],
  "description": "The very basis of Draconic Research. This ore can be found in the overworld below y-level 8 as well as in The Nether at any y-level, although it is extremely rare in both. You can also find it in much larger quantities in The End, both in the main island and in the comets that randomly spawn throughout The End. Drops 1 - 3 Draconium Dust when mined. This can be increased up to 4 - 12 with the Fortune III enchantment."
}
```

Помимо этого необходимо создать и настроить представление wiki_token_view:
```json
{
  ...,
  "links": {
    "wiki": {
      "analyzers": [
        "identity"
      ],
      "fields": {
        "title": {
          "analyzers": [
            "text_en"
          ]
        },
        "tags": {
          "analyzers": [
            "text_en"
          ]
        }
      },
      "includeAllFields": false,
      "storeValues": "none",
      "trackListPositions": false
    }
  }
}
```

# 1. Запрос подходящей статьи
## Запрос
```aql
LET p = (
  FOR word IN TOKENS(@text, "text_en")
    RETURN word
)

FOR doc IN wiki_token_view
  SEARCH PHRASE(doc.title, p, "text_en") 
  OR
  PHRASE(doc.tags, p, "text_en")

  RETURN {
    title: doc.title,
    description: doc.description
  }
```

## Пример параметров 1
```json
{
  "text": "Draconium"
}
```

## Пример вывода 1
```json
[
  {
    "title": "Basics",
    "description": "The very basis of Draconic Research. This ore can be found in the overworld below y-level 8 as well as in The Nether at any y-level, although it is extremely rare in both. You can also find it in much larger quantities in The End, both in the main island and in the comets that randomly spawn throughout The End. Drops 1 - 3 Draconium Dust when mined. This can be increased up to 4 - 12 with the Fortune III enchantment."
  },
  {
    "title": "Draconium Dust",
    "description": "This is the dust dropped when mining Draconium Ore. It can be smelted into Draconium Ingots."
  },
  {
    "title": "Draconium Ingot",
    "description": "The product of smelting Draconium Dust in a furnace. Used in most Draconic Evolution recipes."
  }
]
```

## Пример параметров 2
```json
{
  "text": "Ore"
}
```

## Пример вывода 2
```json
[
  {
    "title": "Basics",
    "description": "The very basis of Draconic Research. This ore can be found in the overworld below y-level 8 as well as in The Nether at any y-level, although it is extremely rare in both. You can also find it in much larger quantities in The End, both in the main island and in the comets that randomly spawn throughout The End. Drops 1 - 3 Draconium Dust when mined. This can be increased up to 4 - 12 with the Fortune III enchantment."
  }
]
```