<p align="center">
  <img src="../assets/pheircebytes-matrix.png" alt="Pheirce Bytes bear chewing on a keyboard, drawn in green 1s and 0s" width="360">
</p>

# Windows Setup Guide — The Sentience Quest

This gets a Windows machine ready for session 1. Takes about 10-15 minutes, most of it automatic. Minecraft: macOS and Linux guides are coming — this one's Windows-only.

## What you'll end up with

- Git, IntelliJ IDEA (Community Edition), Java 25, the Modrinth App, and opencode (our AI coding agent) installed
- A project folder at `devel\sentient-pets` in your user folder
- A **Pheirce Bytes** folder on your Desktop with one-click shortcuts into that project
- A Fabric mod instance in Modrinth App, named **Sentient Pets**, ready to test in

## Before you start

- Windows 10 or 11
- **Minecraft Java Edition already installed and launched at least once.** The setup script checks for this — if it's never been opened, do that first so a `.minecraft` folder exists.
- You do **not** need Administrator rights to run any of this. If an individual installer needs elevation, it'll ask for it itself with a normal Windows permission popup — that's expected, click **Yes**.

## Step 1 — You're already here

If you're reading this, you've already downloaded `minecraft-dev-setup.ps1` and run it — the script opened this page for you automatically. Good sign: that means PowerShell is working and the script started successfully.

Go back to that terminal window; it's working through the automated setup right now. Two things it'll actually stop and ask you for along the way:

- **A prompt to continue**, right after it reports what Minecraft versions it found — read the result, then press Enter.
- **A name and email for git commits**, but only the first time this ever runs on a machine. Any name is fine; the email doesn't need to be real or verified.

Everything else — installing Git, IntelliJ, Java, Modrinth App, opencode, configuring the IntelliJ plugin, building the desktop shortcuts — happens without further input. If a Windows permission popup appears partway through, that's a normal part of one of the installers; click **Yes**.

Didn't get here by running the script? Download `minecraft-dev-setup.ps1` from [the course repo](https://github.com/bkirkby/pb-aicoding-minecraft/raw/main/scripts/minecraft-dev-setup.ps1), open PowerShell normally (not "Run as administrator"), `cd` to wherever you saved it, and run:
```powershell
powershell -ExecutionPolicy Bypass -File .\minecraft-dev-setup.ps1
```

## Step 2 — Reopen your terminal

Close the PowerShell window once the script finishes, then open a fresh one. This matters: PATH changes from the installs above won't be picked up in the same window they were installed in.

## Step 3 — Sign in the AI coding agent

opencode needs an API key attached before it can do anything. Run:

```powershell
opencode auth login
```

and follow the prompts. **This step should be done by you, not the student** — it involves entering a real credential, and there's no reason a first-time setup needs a minor creating or holding that account/key themselves.

## Step 4 — Create the Fabric instance in Modrinth App

This is the one part of setup worth doing together rather than automating — it's fast, and it's a good first look at how mod loaders and versions fit together.

1. Open **Modrinth App**. If it asks you to sign in with a Microsoft account, that's normal — go ahead.
2. Click the **+** (Create Instance) button.
3. Fill in:
   - **Name:** `Sentient Pets`
   - **Loader:** Fabric
   - **Game version:** 26.2
4. Click **Create**, and let it download Fabric Loader — this takes a minute or two depending on your connection.
5. Once it's done, open the new instance and go to its **Content** (or **Install Content**) tab.
6. Search for **Fabric API**, and install it into the instance.

That's it — the instance is ready for session 2.

## Troubleshooting

**"Running scripts is disabled on this system"**
You skipped the `-ExecutionPolicy Bypass` part of the run command in Step 1, or tried to run the file another way. Re-run it exactly as written above.

**A winget install fails with a certificate error mentioning `msstore`**
The script is already written to avoid this (it pins every install to the `winget` source specifically), but if you ever run a winget command manually and hit this, add `--source winget` to it and it'll skip the broken source entirely.

**IntelliJ shows a yellow warning about its version**
Fabric requires IntelliJ 2025.3 or newer to mod 26.2 correctly — older versions can cause mixin-related features to misbehave. Open IntelliJ and check **Help → Check for Updates**.

**Modrinth App won't create a 26.2 instance, or the option isn't there**
This usually means Modrinth App itself is out of date and winget's update check missed it (a known winget quirk, not specific to this app). Force a fresh install:
```powershell
winget install -e --id Modrinth.ModrinthApp --source winget --force --accept-package-agreements --accept-source-agreements
```

**Nothing happens after running the script**
Make sure you opened PowerShell first and ran the script *inside* that window (Step 1), rather than right-clicking the file and choosing "Run with PowerShell" — that method can close the window immediately on an error or a prompt, before you get a chance to see or respond to anything.

## What's next

Session 2 picks up from here: writing the first line of the mod, meeting opencode as a coding partner, and launching Minecraft into the Sentient Pets instance for the first time.
