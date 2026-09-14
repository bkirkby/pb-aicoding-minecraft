# Talking Points — Session 4

A program by [Pheirce Bytes](https://www.pheircebytes.com/ai-consulting), in partnership with [Bright Tomorrow](https://www.brighttomorrowmath.com/).

For the instructor. Short discussions for the waits: the model loading, the first slow replies, builds. Same rules: ask first, let the student guess, fill in, then have them ask the AI.

Today the student meets a second AI, and it's a good day to draw contrasts with the first one. Most of these are about the difference.

Companion to [Session 4](session4.md).

---

## While the model loads

### Local versus remote

**Ask:** "Where is the AI in opencode? Where is this one?"

The opencode AI is on a server somewhere, reached over the internet through OpenRouter. Every prompt leaves the laptop, gets answered on a machine with racks of GPUs, and comes back. This one is a program on the laptop, reading a file on the laptop, doing math on the laptop's chip. Turn off the wifi and it keeps going.

Why it matters for the pet:

- **It's free per line.** OpenRouter charges by the token. A pet that talks all day would cost real money. A local one costs electricity.
- **It's private.** Nothing the player says to their pet goes anywhere.
- **It works offline,** which a game has to.
- **It's theirs.** The student can swap the model, tune it, break it. Nobody's terms of service are involved.

The cost is that it's slower and dumber. Which is the next topic.

**Try it:** ask the opencode AI, "What are the tradeoffs between using you for the pet's dialogue and using a local model?" It'll give an honest answer, which is a little funny.

### What's in the 2 GB file?

**Ask:** "The model is one file. What's in it?"

Numbers. Billions of them. A "3B model" has about three billion parameters, each a number learned during training. That's all a model is: a huge pile of numbers and a recipe for running text through them.

Two things worth landing:

- **Size is smarts, roughly.** The opencode AI has hundreds of times more parameters. More parameters, more room to have learned things. A 3B model has read a lot but remembers it fuzzily. Ask it a date and it'll guess.
- **Quantization is why it fits.** Each number is normally stored with lots of precision. Q4 rounds each one down to about 4 bits, a sixteenth of the size, and the model gets slightly worse. That's how three billion numbers fit in 2 GB instead of 12. It's the same idea as a compressed image: smaller, a bit blurrier, usually fine.

**Try it:** ask the AI, "What does Q4_K_M mean in the model's filename, and what did we lose by choosing it?"

### Why is it slow?

**Ask:** "The opencode AI answers fast. Why does this one crawl?"

Every word the model produces means running all three billion numbers through a pile of multiplication. A GPU does that kind of math thousands of ways at once. A CPU does it a few ways at once. Laptops with a real GPU get several words a second; without one, maybe one or two.

The number people use is **tokens per second**. The server prints it after each reply. Have the student find it.

This is also why a pet is a good use for a small model: one sentence at a time, and a pause before it speaks reads as thinking rather than lag. The same model writing an essay would be painful.

**Try it:** run the server with `-ngl 99`, which pushes the model onto the GPU if there is one, and compare tokens per second with and without.

---

## While the student chats with it

### It has no memory unless you give it one

**Ask:** "Ask it your name. Then tell it your name. Then ask again. Then restart the server and ask again."

The model itself remembers nothing between requests. The chat page is sending the whole conversation back every time, so the model can see what came before. That's the **context window**, and it has a limit: a few thousand words, and then the oldest part falls off.

The connection to make: this is session 1's harness idea again. The model is the text-predictor. The chat page is a small harness that keeps the conversation and re-sends it. **The mod is about to become the harness for the pet's model.** Whatever the pet "remembers" is whatever the mod chooses to put in the prompt. The student is now building the thing they learned about in session 1.

**Try it:** ask the opencode AI, "When the pet talks to the player, what should the mod send to the model each time? What does the pet get to remember?"

### Same question, different answer

**Ask:** "Ask it the same thing three times. Why isn't it the same?"

Models pick each next word from a spread of likely words, with some randomness. The dial for that is called **temperature**. Turn it down and it gets predictable and flat. Turn it up and it gets creative and then unhinged. For a pet, a little randomness is the whole point: the player shouldn't be able to predict it.

**Try it:** the chat page has a temperature setting. Try 0, then 1.5, with the same question.

### Object lesson: the system prompt is the character

Do this during step 2, while the student has the chat page open. It's the most useful twenty minutes in the session.

Have them write a system prompt for their pet, then ask it a fixed set of questions:

1. "Who are you?"
2. "Are you hungry?"
3. "Are you a robot?"
4. "What's 2 + 2?"
5. Something rude.

Watch where it breaks character. Then tighten the prompt and run the five again. Some things they'll discover:

- **Say what to do, not just what not to do.** "Never say you're an AI" helps less than "You are a wolf. You know only what a wolf would know."
- **Length has to be in the prompt.** "One or two short sentences" or it writes paragraphs.
- **Give it a situation, not just a personality.** "You just woke up and can think for the first time" produces better lines than "you are curious."
- **It will still break sometimes.** That's what the fallback is for. Not every problem gets solved in the prompt.

This is writing, not programming, and it's the same skill as session 3's dialogue. The difference is that the student writes the character once and the model writes the lines.

---

## While the mod is being built

### How two programs talk

**Ask:** "The mod and the server are two different programs. How does one ask the other a question?"

Over **HTTP**, the same way a browser asks a website for a page. The mod sends a request to `localhost:8080`, which means "this machine, door number 8080," with the prompt inside. The server answers with text. The browser chat page was doing exactly the same thing; the student just couldn't see it.

The format both sides use for the data is **JSON**, which is text laid out so programs can read it: names and values in curly braces. Have the AI show one request and one reply.

**Try it:** ask the AI, "Show me the exact request the mod sends to llama-server, and the reply it gets back."

### Why the game must not wait

**Ask:** "What happens if the game asks the model a question and just stands there until it answers?"

Minecraft redraws the world many times a second, on one thread, and everything the mod does on that thread has to finish in a few milliseconds. A model reply takes seconds. Waiting on the game thread freezes the whole game for that long: no movement, no sound, nothing.

The fix is to ask on a separate thread and carry on. When the answer arrives, the pet speaks. This is **asynchronous** work, and it's one of the ideas that separates people who've built real software from people who haven't. The student doesn't need to write it. They need to know the word, and to recognize the freeze when they see it.

**Try it:** if the first version freezes, don't tell the AI the fix. Have the student describe the freeze precisely and see if the AI names the problem.

### Graceful degradation

**Ask:** "List everything that could go wrong between right-clicking the pet and it speaking."

Server not running. Model not loaded. Request times out. Server errors. Reply is empty. Reply is a paragraph. Reply says "As an AI." Player's laptop can't run it at all. The student will get most of these.

The principle: the pet should say *something* in every one of those cases, and the player should mostly not be able to tell which case they're in. Good software fails quietly and keeps working at a lower level. The canned lines from session 3 aren't a leftover. They're the floor the whole feature stands on.

**Try it:** the server-off test in step 4 of the session. Then ask the AI, "What other failures are we not handling yet?"

---

## Spares

**What is llama.cpp?** One programmer's project to run these models in plain C++ on ordinary computers, with no special hardware. It's the reason a 2 GB model runs on a laptop at all, and it's free and open source. Thousands of people have contributed since. Worth mentioning that most of the tools in this course, Fabric included, are like that.

**What's GGUF?** The file format llama.cpp uses for models. The name doesn't matter. What matters is that a model from one place can be converted to it and then runs anywhere llama.cpp runs.

**What's a port?** The `8080` in `localhost:8080`. A computer has thousands of numbered doors so different programs can listen without stepping on each other. Minecraft servers use 25565. Web servers use 80 or 443. llama-server picked 8080. If two programs want the same door, the second one fails to start.

**Why not just use OpenRouter for the pet?** Cost, privacy, offline, and ownership, from the first talking point. But also ask: "When would the remote model be the right choice?" A pet that has to be genuinely smart, on a game with a subscription, might. There's no universal answer, only tradeoffs. That's most of engineering.
