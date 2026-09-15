# Session 1 — The First Prompt

A program by [Pheirce Bytes](https://www.pheircebytes.com/ai-consulting), in partnership with [Bright Tomorrow](https://www.brighttomorrowmath.com/).

Today you tell the AI what you want to build and let it plan the first version of the Sentient Pets mod. You won't write any code yourself. Your job is to describe the game you want clearly, and then get out of the way.

This assumes setup is done: the shortcuts are in the Pheirce Bytes folder on your Desktop, opencode is signed in, and the Sentient Pets instance exists in Modrinth App. If not, go back to the [Windows Setup Guide](../guides/windows-setup-guide.md).

## The mindset: treat your AI as a partner, not just a tool

Before you type anything, get this straight in your head.

The AI you're about to work with has read more Minecraft mod code than any human ever will. It knows the Fabric API, it knows how quests and potions and entities are usually built, and it knows a lot of ways those things go wrong. **Assume it knows more than you think it does.**

That changes how you should talk to it:

- **Describe the game, not the code.** Tell it what the player should experience. Don't tell it which classes to make or how to store data. That's its job, and it'll probably do it better than your first guess.
- **Don't restrict it with your own solutions.** If you've already decided "the quest giver should be a villager," ask yourself whether you actually care. Maybe you do. But if you only said villager because it's the first thing you thought of, leave it open and let the AI suggest something. The more you pin down, the less room it has to find a better answer.
- **Tell it the things that are actually facts.** Fabric, Java edition, the Minecraft version you're targeting. Those aren't solutions, they're the world it has to work in.
- **Ask it questions.** It's not a vending machine. Ask what it thinks, what you've missed, what would be hard. It will tell you.

You'll still be in charge. You decide what the game is. The AI decides how to build it, and you check its work.

## Step 1 — Open opencode in plan mode

Double-click the **opencode** shortcut in the Pheirce Bytes folder.

Now press **Tab**. Look at the bottom of the window: it should say the agent is **plan** instead of **build**.

Plan mode means the AI will think and talk but won't touch any files or run any commands without asking you first. That's what we want right now. We're having a conversation about what to build, not building it yet.

## Step 2 — Describe the game

Type this in and press Enter. It's a starting point, not a script, so if you want to change something, change it.

```
I'd like to create a Minecraft Java Edition mod for creating sentient pets.
I'm thinking that we have a quest giver that starts out in the same area as
the player spawn. There should be only one quest giver. The quest giver will
give a series of gather quests that at the end will then give a sentience
potion to the player. The player can then feed that potion to a pet and the
pet will then become sentient and start speaking to the player. There should
only be one sentient pet or sentience potion per player (they can have a pet
or potion, and if they have neither they are allowed to do the quest).
```

Notice what this prompt does and doesn't do. It says what the player *experiences*: a quest giver, gather quests, a potion, a talking pet, one per player. It says nothing about how any of that works in code. Good.

## Step 3 — Ask what you've missed

Don't tell it to start building. Instead, ask it to think out loud. Something like:

```
Before we build anything: what should I be thinking about that I haven't
mentioned? And how would you go about building this?
```

Then read what comes back. Really read it. It will probably raise things you hadn't considered. Some things it might bring up:

- What happens if the quest giver dies, or the player wanders off and can't find it again?
- What counts as a "pet"? Only tamed wolves and cats? Horses? Parrots?
- What does "speaking" mean? Chat messages? A name tag that changes? Does it answer the player, or just talk?
- What happens when the sentient pet dies? Can the player do the quest again?
- Which Minecraft version and which Fabric version, since that decides a lot about the code.
- How to split the work into pieces small enough to test one at a time.

Every one of those is a game design question. The AI can suggest answers, but they're your call.

## Step 4 — Have a conversation

Answer its questions. Ask your own. Push back if you don't like something. A few useful things to say:

- "What's the simplest version of this that we could get running first?"
- "What part of this is going to be hardest?"
- "If you were building this for yourself, what would you do differently?"
- "Give me two different ways to do the quest giver and tell me which you'd pick."

Keep going until you understand the plan and you're happy with it. That might take five minutes or twenty. Don't rush it: a good plan makes everything after it easier.

When you're done, ask it to write the plan down:

```
Write this plan to a file called PLAN.md in the project so we can refer back to it.
```

It'll ask permission since we're in plan mode. Say yes.

## Step 5 — Let it build

Press **Tab** again to switch back to **build** mode. Then:

```
Go ahead and build the first version, following PLAN.md. Start with the
smallest piece we can test in the game.
```

Now watch. It'll create files, run Gradle, and probably hit a few errors and fix them. You don't need to understand all of it yet. Notice how it works: it reads, it tries, it checks, it adjusts. That's the loop you'll learn to drive.

If it stops and asks you something, answer it. If it seems stuck on the same error for a while, tell it so: "You've tried that three times. Step back and explain what you think is going wrong."

## What you should walk away with

- A `PLAN.md` in the project describing what the mod is and how it'll be built
- The first pieces of the mod, whether or not they run yet
- The habit of describing what you want, not how to do it
- The habit of asking the AI what you've missed before telling it to go

## Next session

Getting the mod to load in Minecraft, meeting the quest giver in the game for the first time, and learning how to tell the AI what's wrong when something doesn't work.
