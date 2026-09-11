# Talking Points — Session 3

For the instructor. Short discussions for the waits: builds, launches, IntelliJ opening for the first time. Same rules as before: ask first, let the student guess, fill in, then have them ask the AI.

This session is about taste, so most of these are less "how does the computer work" and more "how do you know if something is good." That's a harder conversation and a more important one.

Companion to [Session 3](session3.md).

---

## While the first build runs

### Working versus good

**Ask:** "The quest works. You can do it start to finish. Is it done?"

No, and the student will probably say so. Push on why. A thing can be correct and still be bad: a joke with the right words and wrong timing, a song played at the wrong tempo. Games are full of this. The mechanic is the skeleton. The feel is everything else.

The point for this course: the AI is very good at "does it work." It can build, test, read logs, and fix until the thing runs. It is not good at "is it good," because that's not a fact, it's a judgment, and the judgment is the student's. This session is where the student finds out that's their job.

**Try it:** ask the AI, "Is the quest good? Not does it work. Is it good?" Watch it hedge. That hedge is honest. It doesn't know.

### Game feel, and where it comes from

**Ask:** "When you get XP in Minecraft, what happens?"

A sound, a green number, orbs that fly to you. Take those away and you still get XP; it just feels like nothing. Minecraft is full of this: the totem pop, the enchantment table's glyphs, the pause before a creeper goes off. None of it changes the rules. All of it changes the feel.

The vocabulary is worth giving the student, because they'll be asking the AI for these things:

- **Feedback:** the player did something, and the game acknowledges it. Sound, particles, a message.
- **Timing:** a beat of nothing before the important thing. Silence is a tool.
- **Weight:** the big moment should cost more than the small ones. If every quest step has fireworks, the wake-up has nothing left.

**Try it:** ask the AI, "What does Minecraft itself do to make small moments feel good? Give me three examples and what each one is doing."

---

## While the polish is being built

### The ways a game can talk to the player

**Ask:** "How many different ways can Minecraft show you a piece of text?"

More than the student thinks. Chat, which scrolls and is easy to miss. The action bar, the line above the hotbar, good for status. Titles and subtitles, big and centered, for the moments that matter. Sounds, which need no text at all. Particles. A name tag changing. Each one has a cost in attention, and using the loud one for everything makes everything quiet.

The quest giver's ask probably belongs in chat. The pet waking up probably doesn't.

**Try it:** ask the AI, "List the ways a Fabric mod can get the player's attention, from quietest to loudest, and say which one you'd use for each of our three moments."

### Client and server, even when you're alone

**Ask:** "When you play singleplayer, is there a server?"

Yes. Minecraft always runs as a client (what you see) talking to a server (the world, the rules, who has what). In singleplayer the server is inside the same program, invisibly. The code is written the same way either way.

Why it matters today: sounds, particles, and messages are shown by the client, but decided by the server. A sound played on the wrong side plays for nobody, or for everybody, or twice. If a polish change "shows up twice" or "doesn't show up," this is the usual suspect.

**Try it:** ask the AI, "The pet's wake-up sound: where does it get triggered, and who hears it on a multiplayer server?"

---

## While IntelliJ opens for the first time

### What is an IDE?

**Ask:** "Notepad can open a `.java` file. Why do programmers use this instead?"

IntelliJ is an **IDE**, an integrated development environment. It's a text editor that understands the code it's showing. So it can color things by what they are, underline mistakes as you type, jump from where something is used to where it's defined, and show what a method does when you hover. The first launch is slow because it's reading the whole project, plus Minecraft's code, to build that understanding.

The AI and the IDE are different kinds of help. The AI writes and explains. The IDE lets you see and navigate. The student will use both.

**Try it:** hover over something in the dialogue file. Then hold **Ctrl** and click a name to jump to where it's defined. Then ask the AI what they just jumped to.

### Writing dialogue is design

**Ask:** "Why does the AI's quest giver sound like every other quest giver?"

Because it learned from every other quest giver. Its default voice is the average of everything it's read, and the average is bland. That's not a flaw to fix, it's a reason the student has a job: the voice of this mod is theirs.

Some things that help a line of dialogue:

- **Read it out loud.** If it sounds like a video game, it is one.
- **Shorter.** Cut the line in half and see if it still works. It usually does.
- **Who is this?** A quest giver who's tired, or hiding something, or too cheerful, is a character. "Greetings, traveler" is a sign.
- **The pet's first words carry the whole mod.** What does something say the moment it realizes it can speak?

**Try it:** have the student write three versions of the pet's first line and read them to you. Pick one together. Then ask the AI which it would pick and why. Disagree with it if you want.

---

## Object lesson: read the script

Do this after step 2 or step 5, whenever there's a build wait.

```
Pull out every line of text the player ever sees from this mod, in the
order they'd see it playing through, and put it in a file called
SCRIPT.md. Just the words, no code.
```

Then read it aloud, the student as the player, you as the quest giver and pet. It takes a minute and it's the fastest way to hear what's flat. Lines that seemed fine in the game are obviously wooden on the page. The student will start editing before you finish.

This is a real technique. Game writers do it. And it shows the student something about the AI: it can reorganize what it wrote into a shape that makes judging it easier. "Show me this in a way I can evaluate" is a good thing to ask for, about anything.

---

## Spares

**Scope, and why one moment beats three.** Ask: "If you had an hour to make one moment great, which one?" The wake-up, almost always. Then: "What happens if you try to do all three?" All three end up okay. Okay is what we're trying to leave. This is a real skill and it has a name, scoping, and adults are bad at it too.

**Where do the words live?** In most mods, player-facing text sits in a language file, a list of IDs and their English text, so the mod can be translated. If the AI did that, the student edits one file and never touches Java. If it didn't, ask the AI whether it should, and why mods do it that way.

**Why write the feeling into the plan?** Because next session the AI reads `PLAN.md` cold. A plan that says "quest giver gives quest" gets a quest. A plan that says "the player should feel like they've met someone who's been waiting a long time" gets something closer to that. Feelings are instructions too.

**The AI will over-deliver.** Ask for a pause and it might add a sound, particles, and a title. Its instinct is more. The student's job is often "less." Say "that's too much, take it back to X" without apology. It won't mind.
