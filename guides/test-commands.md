# Test Commands Cheat Sheet

Minecraft's chat commands are the fastest way to get to the thing you're testing. You're not playing when you test; you're checking whether one moment works. Skip everything else.

Type these in the chat box (press **T** or **/**). **Tab** completes command names, item IDs, and selectors, so you don't have to remember spelling.

## Cheats have to be on

Commands only work in a world with cheats enabled.

- **Creative worlds** have cheats on by default.
- **New survival world:** turn on **Allow Cheats** on the world creation screen.
- **Existing world with cheats off:** press **Esc**, click **Open to LAN**, set **Allow Cheats** to ON, then **Start LAN World**. That lasts until you quit the world.

## The one from session 3

```
/give @s wheat 10
```

`give` is the command. `@s` means "me." `wheat` is the item's ID. `10` is how many.

Item IDs are registry names, so anything the mod registers works the same way:

```
/give @s sentientpets:sentience_potion
```

(The exact ID depends on what the AI named it. Ask: "What's the item ID of the sentience potion?")

## Selectors

The `@s` part is a target selector. It's what makes commands powerful.

| Selector | Means |
| --- | --- |
| `@s` | Me |
| `@p` | The nearest player |
| `@a` | Every player |
| `@e` | Every entity: mobs, items on the ground, everything |

Square brackets narrow it down:

```
/tp @s @e[type=sentientpets:quest_giver,limit=1]
/kill @e[type=wolf,distance=..10]
```

The first teleports you to the quest giver. The second removes every wolf within 10 blocks. Useful filters: `type=`, `limit=`, `distance=..N`, `sort=nearest`.

## Commands you'll actually use

**Get around**

```
/gamemode creative
/gamemode survival
/gamemode spectator
/tp @s @e[type=sentientpets:quest_giver,limit=1]
```

Spectator lets you fly through blocks, which is how you find a quest giver that spawned inside a hill.

**Set up a test**

```
/give @s bone 10
/summon wolf
/summon cat
/give @s cod 10
/clear
```

Summon a wolf, tame it with bones. Summon a cat, tame it with fish. `/clear` empties your inventory so you can test "player doesn't have the items" without dropping everything.

**Reset a test**

```
/kill @e[type=sentientpets:quest_giver]
/kill @e[type=wolf]
```

Remove the quest giver to test whether the mod respawns it. Remove a pet to test what happens when a sentient pet dies.

**Make the world quiet**

```
/time set day
/weather clear
/gamerule doMobSpawning false
/gamerule doDaylightCycle false
```

Nothing creeping up on you mid-test, and it stays daytime.

**Look inside an entity**

```
/data get entity @e[type=sentientpets:quest_giver,limit=1]
/data get entity @s
```

This prints everything the game has saved about that entity, or about you. If the quest "forgets progress" when you reload, this shows whether the progress was ever saved. Copy the output and hand it to the AI.

## Ask the AI to add your own

Mods can add commands. If you find yourself doing the same five commands before every test, ask for one:

```
Add a command, /sentientpets reset, that clears my quest progress so I can
test the quest from the start without making a new world.
```

That's a five-minute ask, and it's a good example of asking the AI to change how you work, not just what the mod does.
