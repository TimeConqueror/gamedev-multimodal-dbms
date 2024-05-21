# Построение: 
Помимо создания коллекции items необходимо также создать коллекцию loot_tables.

Пример документа:
```json
{
  "pools": [
    {
      "rolls": 2,
      "entries": [
        {
          "item": "items/planks",
          "count": 3,
          "weight": 10
        },
        {
          "item": "items/flint",
          "count": 1,
          "weight": 5
        }
      ]
    },
    {
      "rolls": 1,
      "entries": [
        {
          "item": "items/wood",
          "count": 3,
          "weight": 20
        },
        {
          "item": "items/tree_heart",
          "count": 1,
          "weight": 5
        }
      ]
    }
  ]
}
```

# 1. Получить случайный набор ресурсов
## Запрос
```aql
for table in loot_tables
filter table._key == @loot_table

let out = (for pool in table.pools
    let sumWeight = sum(pool.entries[*].weight)
    
    let summedEntries = (FOR i IN 0..LENGTH(pool.entries)-1
        LET entry = pool.entries[i]
        LET sum = pool.entries[i].weight + SUM(SLICE(pool.entries, 0, i)[*].weight)
        RETURN {entry:entry,sum:sum})
    
    let items = (for roll in 0..pool.rolls-1
        let randFloat = (RAND() + DATE_MILLISECOND(DATE_NOW()) / 1000.0) / 2.0
        let randWeight = MIN([sumWeight, CEIL(randFloat * sumWeight)])
        
        return (for e in summedEntries
            SORT e.sum ASC
            FILTER e.sum >= randWeight
            LIMIT 1
            RETURN {item: e.entry.item, count: e.entry.count})
        )
    
    return items)
return flatten(out, 2)
```

## Пример параметров
```json
{
  "loot_table": "firewood_ent"
}
```

## Пример вывода 1
```json
[
  [
    {
      "item": "items/flint",
      "count": 1
    },
    {
      "item": "items/flint",
      "count": 1
    },
    {
      "item": "items/tree_heart",
      "count": 1
    }
  ]
]
```

## Пример вывода 2
```json
[
  [
    {
      "item": "items/flint",
      "count": 1
    },
    {
      "item": "items/planks",
      "count": 3
    },
    {
      "item": "items/wood",
      "count": 3
    }
  ]
]
```

# 2. Показ шанса выпадения предмета
## Запрос
```aql 
for table in loot_tables
filter table._key == @loot_table

let poolWeights = (for pool in table.pools
    let sumWeight = sum(pool.entries[*].weight)
    
    for e in pool.entries
    FILTER e.item == @item_id
    return e.weight / sumWeight)
return sum(poolWeights)
```

## Пример параметров
```json
{
  "loot_table": "frosty",
  "item_id": "items/snow_heart"
}
```

## Пример вывода
```json
[
  0.11011904761904762
]
```