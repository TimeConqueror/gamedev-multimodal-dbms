# Построение: 
Необходима коллекция players.

Пример документа:
```json
{
  "inventory": [
    {
      "item": "items/stone",
      "count": 5,
      "data": {}
    },
    {
      "item": "items/wood",
      "count": 6,
      "data": {}
    }
  ],
  "params": {
    "pos": [
      100,
      200,
      300
    ],
    "level": 54,
    "experience": 58000
  },
  "online": true
}
```

Помимо этого необходимо создать и настроить представление player_level_view:
```json
{
  ...,
  "links": {
    "players": {
      "analyzers": [
        "identity"
      ],
      "fields": {
        "online": {},
        "params": {
          "fields": {
            "level": {}
          }
        }
      },
      "includeAllFields": false,
      "storeValues": "none",
      "trackListPositions": false
    }
  }
}
```

# 1. Запрос подходящих игроков
## Запрос
```aql
LET level = (
        FOR player IN players
        FILTER player._key == @player_name
        LIMIT 1

        RETURN player.params.level
    )

FOR player IN player_level_view
SEARCH player.online == true AND player.params.level IN level-5..level+5
FILTER player._key != @player_name

RETURN {
    name: player._key,
    level: player.params.level
}

```

## Пример параметров
```json
{
  "player_name": "Time_Conqueror"
}
```

## Пример вывода
```json
[
  {
    "name": "player3000",
    "level": 53
  }
]
```