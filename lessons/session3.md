# Session 3 — How It Should Feel

By now the mod does things. The quest giver is there, the quests exist in some form, and somewhere in the code is a potion that wakes up a pet. Whether all of it works yet is beside the point today. Today is about whether it's *good*.

Working and good are different questions. The AI can answer the first one. Only you can answer the second. This session is about taste: deciding what the player should feel at each moment, telling the AI, and then playing it until it feels that way.

This assumes session 2 is done: the mod loads in your instance, building puts the jar in place automatically, and there's at least one commit.

## Step 1 — Checkpoint

Every session starts this way. Open the **opencode** shortcut, make sure it says **build**, and point the AI at its memory:

```
Read PLAN.md and the git log. Tell me what's working, what's not, and
what the plan says comes next.
```

Then check its answer against the game. Build, launch, new world. Walk the quest as far as it goes today. If the basics are broken, fix them first with the bug report formula from session 2. You can't polish something that doesn't run.

## Step 2 — Play it like a player

Play through everything that exists, start to finish, and this time pay attention to how it feels rather than whether it works.

Use shortcuts to get through the gathering. Creative mode, or in chat:

```
/give @s wheat 10
```

(Swap in whatever the quest actually asks for.) You're not testing the farming. You're testing the moments around it. There's a page of these in the [Test Commands Cheat Sheet](../guides/test-commands.md): teleporting to the quest giver, summoning a pet, clearing your inventory, resetting a test.

As you go, write down every moment. A notes file in the project is fine; ask the AI to make one called `NOTES.md`. For each moment, one line: what happened, and how it felt. Flat, confusing, fine, good. Be honest. Some things to watch for:

- When you first talk to the quest giver, do you know what it wants and why?
- When you hand over the items, does anything happen, or does a line of chat just appear?
- When you get the reward, does it feel like a reward?
- Does the quest giver sound like anyone, or like a form letter?
- If the potion exists: when you give it to a pet, what happens? Is that the moment the whole mod is about, and does it feel like it?

If something is missing, write that down too. "No pet wake-up yet" is a note.

## Step 3 — Decide what you want the player to feel

This is the heart of the session. There are three moments that matter:

1. **Getting the quest.** The player meets a stranger who wants something.
2. **Completing it.** The player comes back and gets rewarded.
3. **Waking the pet.** The player gives the potion, and something that was an animal becomes someone.

For each, decide what you want the player to *feel*, in a sentence. Not what should happen on screen. What it should feel like. "Curious." "Like I earned something." "Like the pet was always in there and just woke up."

Then tell the AI the feeling and let it propose mechanics. This is session 1's rule again: describe the experience, not the code. The AI has seen how hundreds of games do these moments. Let it suggest.

```
I want to talk about how the mod feels, not what it does. Here are my
notes from playing it: [paste or point it at NOTES.md]

For the moment the player wakes up the pet, I want it to feel like the pet
was always in there and just opened its eyes. Give me three ways to make
that moment land, from cheap to expensive, and tell me which you'd pick.
```

Do the same for the other two moments. You'll get options like a sound, particles, a pause before the first words, a name change, a title on screen. Some will be good. Some will be too much. Say so. Ask "what's the least we could do that still feels right?"

**Pick one moment to get right today.** Probably the wake-up, since that's what the whole mod is for. The other two can get a small pass. One moment done well beats three done flat.

## Step 4 — Build the feel, in pieces

Same discipline as always: one visible change at a time, test between.

```
Let's start with the pet wake-up. Do the pause and the first line of
dialogue, nothing else yet. Build it.
```

Launch, get a potion with `/give` or creative, find a pet, do it. Then the next piece.

The bug reports you write today are a new kind. Not "it crashed," not "it works but it's wrong," but "it works and it's flat." Be exact about the experience:

```
The pet's first line shows up as plain white chat text, at the same time
as the potion effect, and I almost missed it. I want the player to stop
and notice. What if there was a beat of nothing first, and then the line?
```

You're allowed to have opinions about timing and words. In fact that's the job. If the AI's version doesn't feel right, don't accept it because it works. Say what's off and try again.

## Step 5 — Write the words yourself

The AI's dialogue is probably fine and probably generic. "Greetings, traveler" fine. Nobody's quest giver should say that.

This is the part of the mod you can own directly, because dialogue is just text in a file. Time to open the code.

Double-click the **IntelliJ IDEA** shortcut. First launch takes a minute while it reads the project. In opencode:

```
Where does every line of dialogue live? The quest giver's lines and the
pet's lines. Give me the file and the line numbers.
```

Open that file in IntelliJ and find the words in quotes. Rewrite them. Give the quest giver a voice: cranky, mysterious, cheerful, whatever fits the world you have in your head. Give the pet's first words some weight. Read them out loud. If they sound like a video game, try again. Save with **Ctrl+S**.

Then:

```
I rewrote the dialogue in IntelliJ. Build it.
```

Launch and hear your words in the game. That's the first change you made by hand, and it's the one that most changes how the mod feels.

## Step 6 — Commit, and write down the taste

```
Commit this with a message describing what changed about how the mod feels.
```

Then update the plan, and add something new to it:

```
Update PLAN.md: mark what's done, and add a section called "How it should
feel" with the feeling I described for each of the three moments and the
decisions we made today. Commit that too.
```

That section is the most important thing in the plan now. Next session the AI reads it fresh, and it'll build toward the feeling instead of just the feature.

## What you should walk away with

- One moment in the mod, probably the wake-up, that feels the way you want it to
- A one-sentence feeling for each of the three moments, written into `PLAN.md`
- Dialogue in your own voice, edited by hand in IntelliJ
- The habit of describing a feeling and letting the AI propose the mechanics
- The habit of saying "that works, but it's flat" and not settling

## Things that might go wrong

**The potion or pet wake-up doesn't exist yet.** Then step 3 is where it gets designed, and step 4 builds its first version with the feel in mind from the start. That's not behind; that's the better order.

**The AI builds a whole particle system when you asked for a pause.** It'll over-deliver sometimes. Test what it made. If it's too much, say so: "That's more than I wanted. Take it back to just the pause and the line." Cheap first, then add.

**The AI's dialogue suggestions are all the same.** They will be. Generic is its default. Write it yourself, or give it a voice to imitate: "Make the quest giver talk like a tired old fisherman who's seen this before."

**IntelliJ shows red underlines everywhere.** It hasn't finished reading the project. Wait for the progress bar at the bottom. If it's still red, ask the AI: "IntelliJ shows errors in every file but Gradle builds fine. What's the usual cause?"

**Your hand edit didn't show up.** Did you save in IntelliJ? Did the build run after? Ask the AI to compare the jar's timestamp to your change.

## Next session

The pet gets a brain. Instead of the lines you wrote, its replies will be generated by a small language model running on your own laptop. You'll run one by hand first, talk to it, and give it your pet's voice, then wire the mod to it, with your canned lines as the fallback for when the model isn't there.
