# Talking Points — Session 5

A program by [Pheirce Bytes](https://www.pheircebytes.com/ai-consulting), in partnership with [Bright Tomorrow](https://www.brighttomorrowmath.com/).

For the instructor. Short discussions for the waits: builds, the model loading, the download, the last play-through. Same rules: ask first, let the student guess, fill in, then have them ask the AI.

It's the last session, so a few of these are about looking back rather than about the computer.

Companion to [Session 5](session5.md).

---

## While the flow is being designed

### Ask before you take

**Ask:** "A game you just installed starts downloading two gigabytes without telling you. How do you feel about that game?"

They know. Everyone's had it happen. The rules the student is building into the mod are the rules they'd want:

- **Say what, how big, and why** before doing it
- **Take no for an answer,** and don't ask again five minutes later
- **Show progress,** so nobody wonders if it's stuck
- **Work anyway if they say no,** just with less

This is what people mean by respecting the user. It's not a feature. It's the difference between software people keep and software people delete. The fallback from session 4 is what makes "no" a real option: the mod can afford to take no because the pet still talks.

**Try it:** have the student read the mod's ask out loud as if they'd never seen it. Would they say yes? Do they know what they're agreeing to?

### What "can this machine handle it" means

**Ask:** "What would stop a laptop from running the model?"

Three things, and they're different:

- **Disk.** Is there room for the download? Easy to check, easy to forget.
- **Memory.** The model gets loaded into RAM to run. A 2 GB file needs a bit more than 2 GB free, on top of Minecraft's own appetite. A laptop with 8 GB total is borderline. 4 GB won't.
- **Speed.** Not a yes-or-no. A slow CPU still runs it, just slowly. This one's about whether it's *worth* it, and that's the player's call, not the mod's.

The mod checks the first two and asks about the third by asking at all.

**Try it:** ask the AI, "How much memory does this laptop have, how much is free, and how does the mod check that?"

### Safe defaults

**Ask:** "There's a GPU build that's faster and a CPU build that always works. Which should the mod download?"

The one that always works. Then let people who know what they're doing switch. This is a pattern everywhere in software: the default is the boring option that can't fail, and the fast option is a choice. Getting it backwards means the first experience for a lot of players is a crash.

**Try it:** ask the AI, "If we wanted to let advanced players use the GPU build, how would they turn it on, and what happens if it doesn't work on their machine?"

---

## While detection and launch are being built

### Programs that start programs

**Ask:** "When the mod starts llama-server, who's in charge of it?"

Minecraft is now a parent with a child process. The child has its own memory, its own life, and if the parent forgets about it, it keeps running after the parent dies. That's the leftover-in-Task-Manager bug, and it's one of the oldest bugs there is.

The fix is a **shutdown hook**: a thing the program promises to do on its way out. But a force-close, or a crash, skips the promise. That's why step 3 of the session checks Task Manager, and why the mod also checks "is one already running?" before starting another.

**Try it:** ask the AI, "What happens to llama-server if Minecraft crashes instead of quitting normally? How would we handle that?"

### The chain of checks

**Ask:** "Draw the flow from launching the game to the pet's first line. Where are the branches?"

Get them to actually draw it, on paper. A chain of questions, each with a yes arrow and a no arrow, and every no arrow ends at "canned lines." When they're done, count the no arrows. Five or six. That's five or six ways the game keeps working.

The name for this shape is a **state machine**, and they don't need the name. They need the habit: for every step, ask "and if that fails?" until every branch lands somewhere safe. Session 4 called it graceful degradation. Today they built one.

---

## While the download runs

### Pin your versions

**Ask:** "The mod downloads llama.cpp. Which version?"

If the answer is "the latest," the mod that works today breaks the day a new release changes something. Pinning means the mod names one exact version and one exact file, forever, until a human decides to move it. It's less exciting and it's what every serious project does. Same reason the setup guide named exact versions of everything.

There's a second half: **checking what arrived.** A download can be cut off, corrupted, or swapped. Serious code checks the file's size or a checksum, a fingerprint of the exact bytes, before trusting it. Ask whether the mod does.

**Try it:** ask the AI, "Does the mod verify the downloaded files before using them? What would happen if the download was cut off halfway?"

### Where things live

**Ask:** "Where did the mod put the files? Why there?"

Every game and program has conventions for where its stuff goes. Minecraft's instance folder has `mods`, `config`, `saves`, `logs`. The mod's downloads went into a folder of their own inside it, the personality went into `config`, and the "no" answer went somewhere too. Ask the student to find all three.

The principle: put things where the next person would look. That includes the student, in three months, when they've forgotten.

---

## While the personality and memory are built

### Config versus code

**Ask:** "Why move the personality out of the code?"

Because changing it shouldn't need a programmer. A config file is the line between "things the builder decides" and "things the user decides." The student just moved the pet's voice across that line. Now a player who can't build the mod can still make their wolf grumpy.

Ask what else could cross the line. The quest item? The reward? The model? Each one is a tradeoff: more knobs, more ways to set them wrong.

**Try it:** edit the personality file to something absurd, rejoin, and see the pet change with no rebuild. Then ask the AI, "What happens if the config file has a mistake in it?"

### Memory costs speed

**Ask:** "The pet remembers the last few exchanges. Why not all of them?"

Because everything it remembers gets sent to the model every time, and the model reads all of it before answering. Ten remembered turns is ten turns of reading before the first word comes out. It's session 4's context window again, now with a cost the student can feel: the pet got slower the moment it got a memory.

So it's a dial. More memory, better conversation, longer pause. The student picks the number. There isn't a right one.

**Try it:** set the remembered turns to 2, then to 20, and time the pet's reply.

---

## Object lesson: the failure audit

Do this after step 4, when the whole flow exists.

```
List every place this mod could fail between launching the game and the
pet's first generated line. For each one, tell me what the player sees
and whether the game keeps working.
```

Compare the list to the drawing from earlier. There will be cases the student didn't draw: a corrupted download, the port already taken by something else, the config file with a typo, the model loading but never answering. For each new one, ask: does it land on canned lines, or somewhere worse?

This is what reviewing software looks like. Not reading every line, but asking "and if that fails?" until you run out of things that can fail. The AI is good at generating the list. The student is the one who decides what's acceptable.

---

## Looking back

Save these for the last play-through, or the very end.

### What could the AI do that you couldn't?

Write Java. Read the Fabric API. Read a 400-line log in a second. Know how a hundred other mods handled the same problem. Try a fix, see it fail, try another, without getting tired.

### What could you do that the AI couldn't?

Decide what the game should be. Know when the quest felt flat. Write the pet's first words. Say no to the particle system. Notice the download prompt would step on the wake-up moment. Decide two remembered turns was enough.

Every one of those is a judgment, and none of them is going away. The tools will get better at the first list. The second list is the job.

### Which habit mattered most?

Ask the student. There's no right answer. Common ones: writing the plan down, the bug report formula, building one piece at a time, "that works but it's flat." Whichever they pick, ask them where else it applies. School. A band. A team. The answer is everywhere.

### The tour

If there's time at the end, one last thing to ask the AI:

```
Walk me through the whole mod, file by file, as if I were a new programmer
joining the project. What's the shape of it?
```

The student has never read most of that code. They'll understand more of the tour than they expect, because they decided what every piece was for. That's a good place to end.

---

## Spares

**Why not put llama.cpp inside the jar?** Size, for one: the jar would be huge and most players might say no anyway. Licenses, for another. And the program is different for every kind of computer, so the jar would need all of them. Downloading the right one on demand is the honest answer. Ask the AI what else it would consider.

**Where do models come from?** Most public models live on Hugging Face, a site that's to models what GitHub is to code. The model file the mod downloads is one file on one page there. Have the student find it and look at the page: who made it, how big, what license.

**What's a checksum?** A short fingerprint computed from a file's bytes. Change one byte, the fingerprint changes completely. It's how you know the file that arrived is the file that was sent. Ask the AI to show the model's checksum and how it would verify it.

**What if the player has a Mac?** The mod as built targets Windows. The download URL, the executable name, the launch command all assume it. Ask the student what would have to change, then ask the AI. It's a good preview of what "cross-platform" actually costs.
