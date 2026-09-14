# Talking Points — Session 1

A program by [Pheirce Bytes](https://www.pheircebytes.com/ai-consulting), in partnership with [Bright Tomorrow](https://www.brighttomorrowmath.com/).

For the instructor. These are short discussions to have with the student while something is loading: opencode thinking in plan mode, the first Gradle build pulling down Minecraft, an IDE indexing. Each one is a couple of minutes. Pick whichever fits the moment; you won't get through all of them, and you don't need to.

The goal isn't to lecture. Ask the question, let the student guess, then fill in. Most of these end with something to ask the AI, because the point of the whole course is that the AI is right there and can explain its own world.

Companion to [Session 1](session1.md).

---

## While opencode is thinking (plan mode)

### What is a model?

**Ask:** "What do you think is actually answering you right now?"

The thing writing the reply is a **model**: a very large math function that was trained by reading an enormous amount of text, including a huge amount of code. It learned to predict what text comes next. Do that well enough, over enough text, and it starts to look a lot like understanding.

Points worth landing:

- It doesn't look things up as it goes. What it knows, it learned during training. That's why it can know the Fabric API cold but be unsure about something that changed last month.
- It's not running on the laptop. The laptop sends the conversation over the internet to a computer with big graphics cards, and the answer streams back. That's the "loading."
- It works in **tokens**, chunks of a word at a time. That's why the reply appears in a trickle rather than all at once, and it's also how the service charges: by the token, in and out.

**Try it:** ask the AI, "What model are you, and what's the last date you have knowledge of?"

### What is a harness? (and what is opencode?)

**Ask:** "If the model is just a text-predictor, how did it read a file / run Gradle / ask for permission?"

The model can only read text and write text. Everything else is the **harness**: the program wrapped around the model that turns its writing into actions. When the model writes "I'd like to read PLAN.md," the harness actually opens the file and pastes the contents back into the conversation. When it writes "run `gradlew build`," the harness runs it and feeds the output back.

**opencode** is the harness we use. It's the terminal window they're typing in. It handles:

- The chat itself, and sending it to the model
- Tools: reading and editing files, running commands, searching the project
- Permissions: plan mode vs build mode is a harness feature, not a model feature. The model is the same either way; the harness just refuses to act on file edits in plan mode until you say yes.
- The API key and which model to use (`/connect`, `/models`)

A useful analogy: the model is a brilliant consultant on the phone who can't touch your computer. The harness is the assistant sitting at the keyboard doing exactly what the consultant says, reading back what happens.

**Try it:** ask the AI, "What tools do you have available to you right now, and which ones can't you use in plan mode?"

### What is OpenRouter, and why did we pick DeepSeek?

**Ask:** "Where does the API key we typed in actually go?"

There are lots of companies that train models: OpenAI, Anthropic, Google, DeepSeek, Meta. Each has its own website, own account, own billing. **OpenRouter** is a middleman: one account and one key, and you can point it at any of a few hundred models. opencode sends the conversation to OpenRouter, OpenRouter forwards it to whichever model you picked, and the answer comes back the same way.

Why that's handy for us:

- Swap models with `/models` without changing anything else. If DeepSeek is slow today, pick something else.
- Cheap models and expensive models sit side by side, so you can see the tradeoff
- Individual student keys can be limited to amount allowed to spend

We're on **DeepSeek V4 Flash** because it's fast, good at code, and costs a small fraction of the big-name models. That matters when a build session runs Gradle a dozen times and each run pumps thousands of tokens of log output through the model.

**Try it:** `/models` and scroll. Ask the student to guess why prices vary by 100x.

---

## While Gradle runs for the first time

The first build is the long one. It downloads Minecraft itself, downloads the "mappings" that give readable names to Minecraft's obfuscated code, and remaps the whole game so the mod can compile against it. Several minutes on a good connection. That's the best window for these.

### Compiled languages, in two minutes

**Ask:** "The AI just wrote a bunch of `.java` files. Can Minecraft run those?"

No. Java is a **compiled** language. Humans write `.java` source files; a program called the compiler turns them into `.class` files of bytecode, which is what the Java Virtual Machine actually runs. Minecraft never sees the source. It only sees the compiled result, bundled into a `.jar` file (which is just a zip with a different name).

Contrast with Python or JavaScript, where the program is read and run directly from the source. The tradeoff:

- **Compiled:** an extra step every time you change something, but errors get caught before the program runs, and the result is faster.
- **Interpreted:** change and run instantly, but a typo in a function you haven't called yet won't show up until it's called.

This is why "it built" and "it works" are different questions. Building only proves the compiler was happy.

**Try it:** ask the AI, "What's the difference between a `.java` file, a `.class` file, and a `.jar` file? Where do each of those live in this project?"

### What is Gradle for?

**Ask:** "Compiling is one command. So why is there a whole tool for it, and why does it take five minutes?"

Building a mod is a lot more than compiling:

1. Download the exact version of Minecraft the mod targets
2. Download the Fabric loader, Fabric API, and the mappings
3. Remap Minecraft's obfuscated names (`class_1234.method_5678`) to readable ones (`PlayerEntity.getHealth`) so the code can reference them
4. Compile the mod's Java against all of that
5. Copy in the non-code files: `fabric.mod.json`, textures, language files
6. Package everything into a `.jar`
7. Remap the jar *back* so it runs against the real, obfuscated game

**Gradle** is the build tool that runs all of that in the right order, and skips steps whose inputs haven't changed. The `build.gradle` file in the project is the recipe. The `gradlew` script (the "Gradle wrapper") downloads the right Gradle version so nobody has to install it.

The first build is slow because steps 1 through 3 happen once and get cached. After that, a rebuild is mostly step 4, which is seconds.

**Try it:** ask the AI, "Open `build.gradle` and explain to me in plain English what each section is for. Which lines say what Minecraft version we're targeting?"

### Everything leaves a log

**Ask:** "The build just printed 300 lines and scrolled off the screen. Is that gone?"

Almost every step in this pipeline writes down what it did, somewhere. The Gradle output in the terminal. The Gradle daemon's own log files. Minecraft's `latest.log` when the game runs. Crash reports in a `crash-reports` folder. opencode keeps the whole conversation, including every command's output.

Two things to get across:

- **The AI can find and read them.** That's a harness tool: it can search the project for `*.log`, open one, and read it. You don't need to know where the logs are. You need to know they exist, so you can say "go look at the log."
- **Logs are where the real error lives.** The message on screen is usually the last symptom. The cause is 50 lines up. Humans skim past it; the AI reads all of it.

This becomes the main skill of session 2: when something breaks in the game, the instinct to build is "find the log and hand it to the AI."

**Try it:** ask the AI, "Where does Gradle keep its log files in this project, and where will Minecraft write its logs when we run the game?"

### What is git?

**Ask:** "The AI is about to change a dozen files. If it makes a mess, how do we get back to where we were?"

**git** is a save-game system for code. Every so often you take a snapshot of the whole project, called a **commit**, with a short note about what changed. git keeps every snapshot forever, so you can:

- Look back at exactly what the project looked like an hour ago, or a week ago
- See what changed between any two snapshots, line by line
- Throw away everything since the last snapshot and start over, cleanly
- Try something risky on a **branch**, a side copy, and either merge it back or delete it

The setup script already ran `git init` in the project folder and asked for a name and email. That's what the name is for: every commit is signed with who made it.

Points worth landing:

- git tracks the **recipe**, not the cake. Source files, `build.gradle`, `fabric.mod.json`. Not the `build` folder or downloaded jars, since those can be regenerated. That's what `.gitignore` is for.
- A commit is cheap. There's no reason not to commit after every working step. "It builds and the quest giver spawns" is a commit.
- GitHub is not git. git lives on the laptop. GitHub is a website where you can push a copy of the snapshots so they're backed up and other people can see them. This project doesn't need GitHub yet.
- The AI can drive git for you. "Commit what we have with a good message" and "undo everything since the last commit" are both things you can just say.

**Try it:** ask the AI, "Has anything been committed in this project yet? Show me the history, and tell me what's changed since the last commit."

### Object lesson: have the AI narrate the build

Do this one after the first build finishes (or fails; that works too). Switch to build mode if you're not there already.

Ask the AI:

```
Run the Gradle build again and save the complete output to a file called
build-log.txt. Then read that file and give me a plain-English summary of
each step Gradle went through, in order, what each one was for, and roughly
how long each took. Point out anything that looks like a warning or an error.
```

What to watch for with the student:

- It will run the command and the output will fly by. Point out that it's not reading the screen; it's reading the file it just saved.
- The summary should map to the numbered list in the Gradle section above. If it mentions "remapJar" or "genSources," connect that back.
- The second build will be much faster than the first. Ask the student why, then ask the AI: "Why was this build faster than the first one? Which steps did it skip and how did it know it could?"
- If there are warnings, ask: "Should we care about these warnings? Which ones would you fix and which would you ignore?"

The lesson underneath: the AI isn't a code vending machine. It's also the best reader of technical output the student will ever sit next to. Anything the computer prints, the student can hand back and say "explain this."

---

## Spares

If you've done the above and something is still loading.

**What is a mod loader?** Minecraft doesn't have a "load mods" button. Fabric is a small program that starts up first, patches the game in memory, and loads the mod jars. Fabric API is a shared library of helpers so every mod doesn't have to reinvent the same hooks. The instance in Modrinth App is just a copy of Minecraft with Fabric installed. Ask the AI: "What does Fabric Loader actually do when Minecraft starts?"

**Why did it ask permission?** Because the harness is set to ask. The model would happily edit files in plan mode; opencode stops it. Ask the student: what's a command they'd want it to always ask about, and what's one they'd let it run without asking?

**What is `.gitignore`?** (Follow-on to the git topic above.) The project has a file listing what git should ignore: the `build` folder, the `.gradle` cache, the downloaded Minecraft jar. Those are all things that can be regenerated. Git tracks the recipe, not the cake. Ask the AI: "Show me `.gitignore` and tell me why each line is there."

**Why does it sometimes get things wrong?** It's predicting likely text, not looking up truth. It'll confidently reference a method that was renamed two versions ago. That's why you check its work and why the compiler is your friend: a wrong method name fails to build, loudly. Ask the student: what kinds of mistakes would the compiler *not* catch?
