<p align="center">
  <a href="https://www.pheircebytes.com/ai-consulting"><img src="assets/pheircebytes-matrix.png" alt="Pheirce Bytes bear chewing on a keyboard, drawn in green 1s and 0s" width="480"></a>
</p>

# Learn AI Coding Through Minecraft Modding

A program by [Pheirce Bytes](https://www.pheircebytes.com/ai-consulting).

Course materials for **Learn AI Coding Through Minecraft Modding** (curriculum codename: *The Sentience Quest*). Students build a Fabric mod for Minecraft Java Edition while learning to work with an AI coding agent.

This repo holds everything needed to run and take the course: setup instructions, automation scripts, and the lessons themselves.

## Repository layout

| Folder | What lives here |
| --- | --- |
| `guides/` | Step-by-step instructions for students (environment setup, troubleshooting, reference). |
| `scripts/` | Automation that installs and configures the development environment. |
| `lessons/` | Session-by-session lesson content, exercises, and starter material. |
| `assets/` | Logos and artwork, all generated from `pheircebytes.jpg`. `scripts/make-matrix-bear.py` makes the full logo (`pheircebytes-matrix.*`); `scripts/make-favicon.py` makes the square head icon (`favicon.ico`, `favicon-32.png`, `favicon-512.png`). |

## Getting started (students)

1. Make sure **Minecraft Java Edition** is installed and has been launched at least once.
2. Download `scripts/minecraft-dev-setup.ps1` and run it from a normal PowerShell window (no admin needed):
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\minecraft-dev-setup.ps1
   ```
3. Follow along in `guides/windows-setup-guide.md`. The script opens it for you automatically.

The setup script installs Git, IntelliJ IDEA Community Edition, Java, the Modrinth App, and the opencode AI coding agent, then creates a `sentient-pets` project folder and desktop shortcuts into it.

macOS and Linux setup guides are planned but not yet written.

## What students build

Over five one-hour sessions, students create the **Sentient Pets** Fabric mod, using an AI coding agent as a collaborator. A quest giver hands out a chain of gather quests that ends in a sentience potion. Feed it to a pet and the pet wakes up and talks. By the end, the pet's replies come from a small language model running on the student's own laptop through llama.cpp, with hand-written lines as the fallback, and the mod downloads and manages that model itself, asking the player first.

Along the way they learn:

- How to describe what the player should experience, and let the AI decide how to build it
- How to report a bug so a human or an AI can act on it
- How to play-test for feel, not just function, and say "that works, but it's flat"
- Git basics: committing whenever something works, and reading the history back
- The structure of a Minecraft mod and how the game loads it
- What a model, a harness, and a fallback are, by building all three

## Contributing

Guides are plain Markdown. Scripts should be safe to re-run and skip anything already installed. Lessons go in `lessons/` as one file per session, with a matching talking-points file for the instructor.
