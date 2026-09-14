# Session 2 — Into the Game

A program by [Pheirce Bytes](https://www.pheircebytes.com/ai-consulting), in partnership with [Bright Tomorrow](https://www.brighttomorrowmath.com/).

Today the mod goes into the real game. You'll get it building, put it into your Sentient Pets instance, launch Minecraft, and go looking for the quest giver. Something will probably go wrong, and that's the point: the main skill today is telling the AI what's wrong in a way it can act on.

This assumes session 1 is done: there's a `PLAN.md` in the project and the AI wrote some code. It doesn't matter if that code builds or runs yet. If you don't have a `PLAN.md`, go back to [Session 1](session1.md).

## Step 1 — Pick up where you left off

Double-click the **opencode** shortcut. Check the bottom of the window: it should say **build**. If it says plan, press **Tab**.

Here's something to know about the AI: it doesn't remember last session. Every time you open opencode, it starts fresh. What it *does* have is the project folder, and everything from last time is in there: the code, and the `PLAN.md` you had it write. The files are its memory. That's why we wrote the plan down.

So start by pointing it at that memory:

```
Read PLAN.md and look through the project. Tell me where we left off last
time, and what the smallest next step is to get this mod loading in Minecraft.
```

Read what it says. If it matches what you remember, good. If it doesn't, tell it what you remember and let it adjust.

## Step 2 — Make it build

```
Build the mod and fix any errors until it builds cleanly.
```

Now watch. It'll run Gradle, read the errors, change something, and run Gradle again. This might take a couple of rounds. The first build is also slow because Gradle has to download Minecraft itself and get it ready to compile against, so this is a good time to talk about what's going on (your instructor has some questions for you).

If it seems stuck on the same error, say so: "You've tried that three times. Step back and explain what you think is going wrong."

There's another kind of stuck. Sometimes opencode looks busy, with the spinner going, but nothing has actually happened for a couple of minutes: no new text, no new command output. Usually a command is hanging or a reply got lost on the way back. When that happens:

1. Press **Esc** twice. That cancels whatever it was waiting on and gives you the prompt back.
2. Ask it what happened:

```
You looked stuck for a while and I cancelled. What were you doing, and why
do you think it stalled?
```

3. Read the answer, then tell it to carry on:

```
Okay. Pick up where you left off.
```

Nothing is lost when you cancel. The files it already changed are still changed, and it can see them.

When it says the build is clean it usually tells you where it built the jar file, if not just ask it:

```
Where is the jar file you produced, and which one do I install into Minecraft?
```

It'll point you at a `build/libs` folder. There may be more than one jar in there; the one with `-sources` in the name is not the one you want. Remember the name of the right one.

## Step 3 — Install the jar by hand

Fabric doesn't come with a way to see which mods are loaded. So first, give yourself one:

1. Open **Modrinth App** and open the **Sentient Pets** instance.
2. Go to the **Content** tab, search for **Mod Menu**, and install it. It adds a Mods button to the title screen.

Now install your mod:

3. In the instance, find the option to open the instance folder (it's in the menu with the three dots, or a folder icon, depending on the version). A Windows Explorer window opens.
4. Open the `mods` folder inside it. Fabric API and Mod Menu are already there.
5. In another Explorer window, go to your project's `build/libs` folder and copy your mod's jar into `mods`.
6. Back in Modrinth App, click **Play**.

When Minecraft reaches the title screen, click **Mods**. Look for **Sentient Pets** in the list. If it's there, your code is running inside Minecraft. That's a real milestone.

If it's not there, or Minecraft crashed before the title screen, skip ahead to the bug report part of step 4. Same skill, just earlier.

Before you move on, count what you just did by hand: found the jar, opened a folder, copied a file, launched the game. Keep that count in mind.

## Step 4 — Find the quest giver and playtest

Create a new world. Creative mode is fine, it's faster. Look around where you spawn.

One of three things happens.

**It's there.** Walk up to it. Right-click it. See what it does, and whether it matches what `PLAN.md` said the first version would do. Then pick one small thing to change (its name, or what it says when you click it) and go to step 5 with that change.

**It's not there, or the game crashed.** This is normal, and it's the most important part of today.

The temptation is to go back to opencode and type "it doesn't work." Don't. That gives the AI nothing to go on, and it would give a human nothing either. A useful bug report has four parts:

1. What you did
2. What you expected to happen
3. What actually happened
4. The log

The log is the part people skip, and it's the part that matters most. Minecraft writes down everything it does in a file called `latest.log`, in a `logs` folder inside your instance folder. If it crashed, there's also a `crash-reports` folder with a file for each crash. The AI can read both, but it needs to know where they are, and that location is different on every computer.

So: go back to the instance folder you opened in step 3, click in the address bar at the top of Explorer, and copy the path. Then fill this in:

```
I built the mod and installed the jar in my Modrinth instance. I created a
new creative world and looked around spawn.

I expected: [what PLAN.md says should happen, in your words]

What actually happened: [the quest giver wasn't there / the game crashed
with this message / it was there but ...]

The instance folder is at: [paste the path here]
Read logs/latest.log there, and anything in crash-reports, and tell me
whether the mod loaded and what went wrong.
```

Read its diagnosis. Ask it questions if you don't follow. Then let it fix the problem.

**When it says "rebuild and try again," stop.** Don't copy the jar by hand again. Go to step 5 first.

## Step 5 — Make the AI automate the loop

You've now done the build, find the jar, copy it, launch cycle once by hand. You're going to do it fifty more times over this course. Every one of those manual steps is a chance to forget one and then spend ten minutes wondering why your change didn't show up.

The AI can take that off your plate. This is a different kind of request from what you've made so far: you're not asking it to change the game, you're asking it to change how *you* work.

```
Every time we build the mod, I want the new jar copied into my Modrinth
instance's mods folder automatically, replacing the old one. The mods folder
is at: [paste the instance path here]\mods
Set that up so it just happens as part of the build.
```

It'll probably add a task to the Gradle build, or write a small script. Either is fine. Ask it how to run it if that's not obvious.

Now test the whole loop:

```
Build the mod.
```

Check the `mods` folder: the jar should have a new timestamp. Launch Minecraft from Modrinth App, create a new world, and look for the change you were waiting on, whether that's the fix from step 4 or the small change from "it's there."

If it worked, you now have a one-step build-and-install. If it didn't, that's a bug report: what you did, what you expected, what happened.

## Step 6 — Commit

Something works now, even if it's just "the mod loads." That's worth saving.

```
Commit everything that works, with a message that says what we got working today.
```

Then:

```
Show me the commit history for this project.
```

That's your first commit. From now on, any time something works that didn't before, say "commit this" before you move on. It's free, and it means you can always get back to here.

## What you should walk away with

- The mod loads in the real game, and you can prove it from the Mods screen
- Building the mod puts the new jar into your instance without you copying anything
- The bug report formula: what you did, what you expected, what happened, and where the log is
- A first commit, and the habit of committing whenever something works

## Things that might go wrong

**The mod isn't in the Mods list and there's no crash.** Usually a version mismatch: the mod's `fabric.mod.json` says it's for a different Minecraft version than 26.2, or Fabric API isn't in the instance. Report it: "Sentient Pets doesn't appear in the Mods list. The instance is Minecraft 26.2 with Fabric API. Check fabric.mod.json and the log."

**The log says `UnsupportedClassVersionError`.** The jar was compiled for a newer Java than the game is running. Tell the AI exactly that, and ask it to set the Java release target in `build.gradle` to match what Minecraft 26.2 needs.

**The quest giver shows up twice, or shows up once and then is gone when you reload the world.** That's a real design problem, and it's one of the questions from session 1. Don't try to fix it yourself today. Write it up as a bug report and let the AI deal with it, or note it in `PLAN.md` for next time.

**The AI keeps making the same fix and it keeps not working.** Say: "You've tried that three times. Stop, and explain what you think is going wrong before you change anything else." Then read the log yourself with your instructor.

## Next session

Talking to the quest giver: the first gather quest, from "go get me ten wheat" to handing over the reward. And a first look at the code the AI has written, so you can start to read it even if you can't write it yet.
