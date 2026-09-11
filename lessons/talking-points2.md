# Talking Points — Session 2

For the instructor. Short discussions to have while something is loading: Gradle building, Minecraft launching, a world generating. Same rules as [session 1's talking points](talking-points1.md): ask first, let the student guess, then fill in, and end by having them ask the AI.

Companion to [Session 2](session2.md).

---

## While Gradle builds

### What's actually in a jar?

**Ask:** "The build makes one file. What's in it?"

A `.jar` is a zip file with a different extension. Rename it to `.zip` and Windows will open it. Inside:

- The compiled `.class` files, one per Java class the AI wrote, in folders that match the package name
- `fabric.mod.json`, the mod's ID card: its name, version, which Minecraft and Fabric versions it works with, and where its entry point is
- Any assets: textures, sounds, and the language files that map things like `entity.sentientpets.quest_giver` to "Quest Giver"
- Sometimes a mixin config, which we'll get to

No source code. Minecraft never sees the `.java` files. That's why the `-sources` jar exists separately and why it's not the one you install.

**Try it:** ask the AI, "List everything inside the jar you just built and tell me what each part is for."

### Versions, and why they have to line up

**Ask:** "Why did the setup guide care so much about exact version numbers?"

Four things have to agree for a mod to load:

1. **Minecraft** itself (26.2 in our instance)
2. **Fabric Loader**, the thing that loads mods into that Minecraft
3. **Fabric API**, the shared library most mods lean on
4. **Java**, the version the game runs on

`fabric.mod.json` is where the mod declares which of these it's compatible with. If it says "Minecraft 26.1" and the instance is 26.2, Fabric refuses to load it, usually silently. Most "the mod just isn't there" bugs are one of these four disagreeing.

The Java one bites in a sneaky way. The mod is compiled on the student's machine with Java 25. If the compiler is told to produce Java 25 bytecode and the game runs on an older Java, you get `UnsupportedClassVersionError`. The fix is a one-line setting in `build.gradle` that says what Java version to target.

**Try it:** ask the AI, "Open fabric.mod.json and tell me which versions of Minecraft, Fabric Loader, Fabric API, and Java this mod says it needs. Do they match my instance?"

---

## While Minecraft launches

### What Fabric does at startup

**Ask:** "Vanilla Minecraft has no idea our mod exists. So how does it end up running our code?"

Fabric Loader starts *before* Minecraft. In order:

1. It scans the `mods` folder and reads every `fabric.mod.json` it finds
2. It checks that all the versions agree (see above) and that every mod's dependencies are present
3. It applies **mixins**: small patches each mod asks to have inserted into the game's own code, as it loads. That's how a mod can change what happens when a villager is right-clicked without shipping a modified Minecraft.
4. It calls each mod's **entrypoint**, the one method the mod said "start here" about. That's where our mod registers its quest giver, its potion, and so on.
5. Then Minecraft starts normally, with those patches and registrations in place

Keep mixins light. The one thing worth landing: a mod doesn't replace Minecraft, it hooks into it. That's why mods from different authors can run together, and why they sometimes fight.

**Try it:** ask the AI, "Where is this mod's entrypoint, and what does it do when Minecraft starts? Does this mod use any mixins?"

### Logs vs crash reports

**Ask:** "If the game crashes, where would you even start looking?"

Two files, both in the instance folder:

- **`logs/latest.log`** is everything that happened, in order, from the moment Fabric started. Which mods loaded, every warning, what the game was doing when things went wrong. It's overwritten each launch (older ones are zipped up next to it).
- **`crash-reports/crash-<date>.txt`** only exists if the game died. It's a snapshot of the exact moment: the error, the stack of code that led to it, and which mods were involved.

The log tells the story. The crash report tells you the last page. Both are worth handing to the AI. Humans skim logs and miss the one line that matters, 200 lines above the crash. The AI reads all of it.

**Try it:** the object lesson below.

### Object lesson: have the AI narrate the launch

After the first launch, whether it worked or not:

```
The instance folder is at [paste path]. Read logs/latest.log and give me a
plain-English summary, in order, of what Fabric loaded when the game started.
Was Sentient Pets among them? Point out any warnings or errors, and tell me
which ones matter.
```

What to watch for with the student:

- The load order and the mod count. Fabric prints "Loading N mods" with a list. Sentient Pets should be in it. If it isn't, that's the whole diagnosis right there.
- Warnings. There will be some, most harmless. Ask: "Which of these would you actually fix?" The AI's answer teaches the student that not every warning is a problem.
- Connect it back to session 1's Gradle narration: same move, different log. Anything the computer prints, hand it back and say "explain this."

---

## While the world generates

### Why "one quest giver at spawn" is harder than it sounds

**Ask:** "We said 'put one quest giver where the player spawns.' What could go wrong with that?"

Let the student guess. The real answers, roughly:

- **When** does it spawn? On world creation? The first time a player joins? Every time the world loads? Each is a different piece of code.
- **Where** is spawn, exactly? The spawn point can be inside a hill or over water. Does the quest giver end up buried?
- **Only one.** The game has to remember it already made one, across saves and restarts. If it forgets, you get two. If it remembers wrong, you get zero.
- **Chunks.** Minecraft only keeps nearby parts of the world loaded. Wander off and the quest giver's chunk unloads. Does it come back? Can it wander away on its own?

None of this is a reason to change the design. It's a reason to expect the first version to misbehave, and to treat that as a normal bug rather than a failure. "It spawned twice" is a perfectly good bug report.

**Try it:** ask the AI, "How does the mod decide when and where to spawn the quest giver, and how does it make sure there's only one? What's the weakest part of that?"

---

## The bug report formula

This is the skill of the session, so it's worth a direct conversation even if nothing is loading.

**Ask:** "If your friend said 'my game doesn't work,' what would you ask them?"

They'll come up with most of it: what were you doing, what happened, what did it say. That's the formula:

1. **What I did**
2. **What I expected**
3. **What actually happened**
4. **The log** (or where to find it)

Why it matters for the AI specifically: it can't see the screen. It can't hear the frustration in your voice. It has exactly the words you type and the files it can read. "It doesn't work" gives it nothing. The four parts give it everything.

A habit worth building: have the student say the bug report out loud to you before typing it. If it makes sense to a human, it'll make sense to the AI.

---

## The dev loop, and why to automate it

**Ask:** "Count the steps between changing one word in the code and seeing it in the game."

Edit, build, find the jar, open the mods folder, delete the old one, copy the new one, launch, make a world, walk to spawn. Nine-ish. Every one done by hand is a chance to forget one. The classic: you rebuild, forget to copy, launch, and spend ten minutes debugging a change that isn't installed.

Two points:

- Programmers automate their own chores constantly. Not because they're lazy, because a chore done by hand is a chore done wrong eventually.
- The AI is good at this kind of request, and students rarely think to make it. "Change how I work" is as valid an ask as "change the game." Step 5 in the session is exactly this.

**Try it:** after step 5, ask the AI, "What else in my workflow could you automate? What would you set up if this were your project?"

---

## Spares

**What is an entrypoint?** The one method Fabric calls to start the mod. Everything the mod does starts from there, directly or indirectly. Ask the AI to show it and walk through it line by line.

**Why isn't there a Mods button in plain Fabric?** Fabric Loader is deliberately minimal: it loads mods and nothing else. Mod Menu is itself a mod that adds the screen. That's the Fabric philosophy: small core, everything else is a mod. Ask the student what else they'd expect to be built in that probably isn't.

**"The AI has no memory."** Each opencode session starts blank. Files are the memory: `PLAN.md`, the code, the git history. That's why session 2 opened with "read PLAN.md," and why writing things down for the AI is the same as writing them down for your future self.

**What's a world seed?** If the student asks why spawn looks different every time: the world is generated from one number, the seed. Same seed, same world. Handy for testing: ask the AI whether the mod could use a fixed test world, or just note the seed of a world where the quest giver spawned in a convenient spot.
