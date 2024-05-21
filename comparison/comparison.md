# Спроектированная Мультимодельная СУБД для сравнительного анализа: 

## Квесты
Пример коллекции quests:
```json
{
  "name": "BPRPGYZUIG",
  "desc": "PHADREJDKJVQFAMKPRPQOFFMERDUGZWVUTDGUFFCKQDKTVYOHHOOEHVEDGDPPUWUYRNKHXRSYAIJZINKNJNITNQZFCUVPTEMTQDWHWUUCSJWGARJDGZKSIDKKLRNRFIPRWXOXTSVFWRDMKIEBAEDBVYTYRSDAOUCBIJNVRNZZQQXUJVJFSWTZRBVONJQOJTJZBRFAMQPMXNDBUBMFQZGSCZRWKFQVXHKRIZPTHRVIOQUSRVARFTQQQNKJJVXJYSARBOPMIXBNTFIWHNVRLACPFGHJAQWQSIQEDPPYPZVUGYPMZMPZXCJNVMDEGAYZHRLMDKNLGQWVDZXBLFKTWKBWTJZFGRGPQFLJMRMUKXQUNLYSFMGNZHDSWJUPNPZKNFLWYDZRPHJJLYUYCHNMJPMWAXGWLBAHPUJBDDZNUKKSAHTTYKJTICBQVUFNZBZNLVHICPWKKEYYATRJYFLEHFKVBOYXPOMCYBMSJPXEWWISSIABMFFZYIX",
  "tasks": [
    {
      "type": "buy",
      "id": "apple"
    },
    {
      "type": "get",
      "id": "sword"
    }
  ],
  "reward": "JQCNSYXCWI"
}
```

Пример коллекции players:
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
  "online": true,
  "active_quests": [
    "954933"
  ]
}
```

## Кланы
Документы коллекции clans обладают только стандартными свойствами.
Пример:
```json
{
  "_id": "clans/RYJEJL",
  "_key": "RYJEJL",
  "_rev": "_h2QOCvS---"
}
```

Пример коллекции рёбер players_clans:
```json
{
  "_from": "players/TUFCTPNSRJ",
  "_id": "players_clans/1719552",
  "_key": "1719552",
  "_rev": "_h2QyZcW---",
  "_to": "clans/QSNQLZ"
}
```

## Запрос для поиска враждебных игроков
```aql
for player in players
filter player._id == "players/@me"
FOR v,e,p in 3..3 ANY
player players_clans
filter v._id == "players/@enemy"
filter p.edges[*].state ANY == "war"
return p
```

## Диалоги
Пример документа коллекции instructions:
```json
{
  "instructions": [
    {
      "id": 0,
      "type": "npc_text",
      "data": "Привет, путник!",
      "next": [
        {
          "id": 1
        }
      ]
    },
    {
      "id": 1,
      "type": "player_answer",
      "data": [
        "И тебе привет!",
        "Промолчать"
      ],
      "next": [
        {
          "id": 2
        },
        {
          "predicate": [
            "silence_potion",
            "choosen_2"
          ],
          "id": null
        }
      ]
    },
    {
      "id": 2,
      "type": "action",
      "data": "npc_go_away",
      "next": [
        {
          "id": null
        }
      ]
    }
  ]
}
```
