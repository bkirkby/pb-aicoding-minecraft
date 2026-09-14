# Session 5 — On Its Own

Last session. Two jobs, and then a step back.

First, the mod stops depending on you. Right now the pet only thinks if someone started llama-server by hand. Today the mod checks the machine, asks the player before downloading anything, fetches llama.cpp and the model itself, starts the server, and shuts it down when the game closes, with the canned lines waiting at every step where something's missing.

Second, the pet gets a real personality: a voice you can edit without rebuilding, and a memory of what you've said to it.

Then you play the whole thing through, from meeting the quest giver to arguing with your wolf, and look at what you built and how you built it.

This assumes session 4 is done: the pet speaks through a local model when the server is running, the fallback works, and `PLAN.md` has a "The pet's brain" section.

## Before the session (instructor)

- The llama.cpp folder and model file from session 4 should still be on the machine. Know where they are.
- The mod will need a place to keep its own copies. Somewhere inside the instance folder is the natural choice, like `sentientpets\llm`. Decide that ahead of time, and consider moving the session 4 files there before class so the "already present" path is what runs first.
- The mod needs download URLs for a pinned llama.cpp release and the model file. Ask your coding AI for current ones the day before, and open each in a browser to make sure they resolve. A 404 during class is a bad way to spend ten minutes.
- If class wifi is poor, the download path gets demonstrated up to the progress bar and then cancelled. That's fine. The point is the ask, not the bytes.

## Step 1 — Checkpoint

If llama-server is still running from last time, stop it. Today the mod starts it.

Open **opencode**, make sure it says **build**:

```
Read PLAN.md and the git log. Tell me what's working, and read me the
"next" list from the pet's brain section.
```

Launch the game and confirm the pet falls back to canned lines with no server running. That's the starting state.

## Step 2 — Design the hand-off

**Tab** to **plan** mode. This is the most involved design conversation in the course, so take it slowly.

```
I want the mod to handle the model itself, so a player who installs this
mod never has to start llama-server by hand. Facts:

- The llama.cpp program and the model file might already be on the
  machine, or might not.
- Never download anything without asking the player first. If they say
  no, remember it and don't ask again every time they join.
- Before asking, check whether the machine can even run it: enough free
  disk for the download, enough memory to load the model.
- Show download progress in the game. The player should never wonder if
  it's stuck.
- The mod starts the server when it's needed and stops it when the game
  closes. No leftover processes.
- At every step where something is missing or fails, the pet uses canned
  lines. Nothing here should ever crash the game or freeze it.

Walk me through the flow from launching the game to the pet's first
generated line. What are the checks, in order, and what happens when each
one fails?
```

What comes back should be a chain, something like:

1. Is a server already reachable? Use it.
2. Are the program and model on disk? Start the server, wait until it answers, use it.
3. Can this machine handle it? If not, canned lines, and tell the player once why.
4. Has the player already said no? Canned lines, quietly.
5. Ask. On no, remember it. On yes, download with progress, then go to step 2.

Every arrow that points at "canned lines" is a place the game keeps working. Count them. That's the design.

Questions to settle, because the AI will ask or should:

- **Where do the files live?** Tell it the folder you decided on.
- **When does it ask?** At world join? The moment the pet wakes up? Through the quest giver? Waking the pet is the emotional moment from session 3, and a download prompt would step on it. Your call, but think about it.
- **What does "capable" mean?** A number for free disk and a number for memory. The AI will propose them.
- **Which llama.cpp build?** The CPU build runs everywhere and is the safe default. The GPU build is faster and sometimes won't start. Safe default first.
- **What if the download dies halfway?** Delete the partial file and let the player try again later. Not the end of the world.
- **What if the game is force-closed?** The server should not outlive it. Ask the AI how it'll make sure.

```
Write this flow into PLAN.md under "The pet's brain," replacing the "next"
list. Include the folder, the numbers, and what we decided about when to ask.
```

## Step 3 — Detection and launch

**Tab** to **build**. The files are already on the machine, so build the path that finds them first:

```
Build the detection and launch part: on world join, if a server isn't
already reachable, look for llama.cpp and the model in the folder in
PLAN.md. If they're there, start the server, wait until it responds, and
use it. Stop it when the game closes. Don't build the download or the
asking yet.
```

Test it properly, because this one is easy to get half right:

1. Make sure no llama-server is running. Launch the game, join a world, wait a few seconds, right-click the pet. A generated line means the mod started the server.
2. Open Task Manager and find `llama-server` in the list. It's real.
3. Quit Minecraft. Look at Task Manager again. It should be gone. If it's still there, that's the bug report: "llama-server keeps running after I quit the game."
4. Launch again. It should start a fresh one, not fail because the old one held the port.

The pause before the pet's first line is longer now, since the model has to load. If that bothers you, note it. It might be a "the pet is still waking up" canned line's job.

## Step 4 — Asking, and downloading

```
Now build the check-and-ask part: if the files aren't there, check disk and
memory, and if the machine can handle it, ask the player the way we decided
in PLAN.md. If they say no, remember that and use canned lines. If they say
yes, download both files with progress shown in the game, then start the
server. Build it.
```

To test it, make the files disappear without deleting them. Rename the model file, adding `.bak` to the end. Then:

1. Launch, join a world. The mod should notice the model is missing and ask. Read the ask as a player would. Is it clear what it's offering, how big it is, and that saying no is fine?
2. Say **no**. The pet should use canned lines. Quit, rejoin. It should not ask again.
3. Ask the AI how to reset that "no" (probably a command or a file). Reset it, rejoin, and this time say **yes**.
4. Watch the progress. If the wifi is good, let it finish, and the pet should start thinking without you doing anything else. If it isn't, quit partway. Then rename the model back and confirm the mod finds it.

There's a conversation to have here about why the ask matters. Software that downloads two gigabytes without asking is software people uninstall. Your instructor has more on that.

## Step 5 — A voice you can edit, and a memory

The system prompt is in the code right now. That means changing one word of the pet's personality means a rebuild. Move it out:

```
Move the pet's system prompt into a file in the instance's config folder,
so I can edit the personality in a text editor without rebuilding. Load it
fresh when the world loads.
```

Then give the pet a memory:

```
Have the pet remember the last few things the player said and it replied,
and send those along with each request so it can follow a conversation.
Also tell it a few facts about the moment: its name, the time of day,
whether it's hurt. Keep it short; every extra word makes the reply slower.
```

Test both. Find the config file and rewrite the personality in Notepad or IntelliJ. Rejoin the world; no build. Then hold a conversation with the pet: tell it something, talk about something else, then ask it about the first thing. It should remember. Then keep going until it forgets. That's the edge of its memory, and you chose where it is.

## Step 6 — Play it through

New world. Cheats on, so you can skip the farming with the [cheat sheet](../guides/test-commands.md), but this time try to play it straight where you can.

Meet the quest giver. Do the quest. Get the potion. Find a pet, wake it up, and talk to it. Then turn off the wifi and do it again in a fresh world.

Write down what bugs you. Pick the one thing that bugs you most and fix it, with the AI, the way you've been doing it for five sessions. Then stop. There will always be one more thing.

## Step 7 — Commit, and ship

```
Commit this with a message saying the mod now manages the model itself and
the pet has an editable personality and memory.
```

```
Update PLAN.md so it describes the mod as it is now, not as a plan. Add a
short "How to install" section for someone who isn't me. Commit that.
```

Then find the jar in `build/libs`. That file is the mod. Anyone with Minecraft, Fabric, and the same version can drop it in their `mods` folder and play what you made. The first time their pet wakes up, it'll ask them about the download, because you built it that way.

Give it to someone.

## Step 8 — Look back

You've been doing this for five sessions. Look at what you built:

- A quest giver with a voice
- A quest chain that ends in a potion
- A pet that wakes up and talks, with lines you wrote
- A pet that thinks, using a model on your own laptop, with your lines as the safety net
- A mod that sets all of that up for a stranger, politely

And look at how you built it. You never wrote a class. You did these things instead:

- **Described what the player should experience** and let the AI decide how to build it
- **Asked what you'd missed** before saying go
- **Wrote the plan down** so the AI could remember it, and kept it honest
- **Reported bugs** with what you did, what you expected, what happened, and the log
- **Built one visible piece at a time** and tested between pieces
- **Tested with shortcuts** instead of playing the long way
- **Said "that works, but it's flat"** and didn't settle
- **Asked the AI to change how you work,** not just what the mod does
- **Made sure it fails quietly,** with a fallback at every step
- **Committed** whenever something worked

That list is the course. Minecraft was the excuse.

## Where to go from here

The mod is yours, and the AI is still there. Some things people do next:

- More quests, and a quest giver who remembers you
- More kinds of pets, with different personalities in different config files
- Two sentient pets that talk to each other
- The pet doing things, not just saying things: following, fetching, warning you
- Making it work on a multiplayer server with friends
- Trying a different model and seeing how the pet changes
- Opening the code in IntelliJ and having the AI walk you through it, file by file, until you could have written it

Every one of those starts the same way: open opencode, read `PLAN.md`, describe what the player should experience, and ask what you've missed.

## Things that might go wrong

**The download URL gives a 404.** Releases move. Ask the AI for a current llama.cpp release URL and model URL, pin them, and check them in a browser before class next time.

**The mod starts a second server on top of one that's already running.** Step 1 of the flow is "is one already reachable?" It's being skipped. Bug report it exactly that way.

**llama-server survives quitting the game.** The shutdown isn't wired up, or the game was force-closed. Ask the AI how it stops the server and what happens on a force-close. Kill the leftover one in Task Manager.

**The first launch of the downloaded program is slow, or Windows shows a warning.** Antivirus scanning a new executable. Normal. If Windows blocks it outright, that's a real deployment problem worth a conversation: how would you ship this to someone you can't sit next to?

**It asks every time you join.** The "no" isn't being saved, or it's being saved per world. Bug report.

**The pet got slower after the memory change.** More context, more time. Ask for fewer remembered turns, or shorter facts. It's a dial, and you're holding it.

**The disk fills up.** Two gigabytes is two gigabytes. The check in the flow should have caught it. If it didn't, that's the bug.
