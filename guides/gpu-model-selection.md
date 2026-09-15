# GPU Detection and Model Selection

A program by [Pheirce Bytes](https://www.pheircebytes.com/ai-consulting), in partnership with [Bright Tomorrow](https://www.brighttomorrowmath.com/).

A stretch project for after session 5. The course runs one model, Phi-3.5 mini, on the CPU build of llama.cpp, because that works on every machine. This page is the spec for the next step: the mod looks at the machine, picks a llama.cpp build to match its GPU, picks a bigger model if the GPU can carry it, downloads the right pair, and falls back when any of it doesn't work.

Hand this whole page to the AI as facts. It decides the code.

## The models

| Model | File | Size | When |
| --- | --- | --- | --- |
| Qwen2.5 7B Instruct | `Qwen2.5-7B-Instruct-Q4_K_M.gguf` | about 4.7 GB | A capable GPU was found |
| Phi-3.5 mini Instruct | `Phi-3.5-mini-instruct-Q4_K_M.gguf` | about 2.4 GB | Everything else |

Both at Q4_K_M quantization, both in GGUF format, both from Hugging Face. Pin the exact file URLs in the mod.

## Backend resolution

`gpu: auto` is the default. The mod resolves it to one backend, checking in this order and stopping at the first match:

| Order | Check | Backend |
| --- | --- | --- |
| 1 | Running on macOS | **METAL** (any Mac) |
| 2 | NVIDIA GPU detected (`nvidia-smi` runs and lists a device) | Windows: **CUDA**. Linux: **VULKAN** (llama.cpp ships no Linux CUDA build) |
| 3 | Vulkan is available | **VULKAN** |
| 4 | An AMD or Intel GPU is listed by the OS | **VULKAN** |
| 5 | None of the above | **CPU** |

How each check is made:

- **macOS:** the OS name from Java.
- **NVIDIA:** run `nvidia-smi`. If it exits cleanly and lists at least one GPU, NVIDIA is present. Read the memory column too; it's used for the model choice below.
- **Vulkan:** on Windows, the Vulkan runtime library `vulkan-1.dll` exists in System32; on Linux, `libvulkan.so.1` is findable. If `vulkaninfo` is on the path, run it as a confirming check, but don't require it: it ships with the Vulkan SDK, not with most drivers.
- **AMD or Intel GPU:** on Windows, query `Win32_VideoController` through PowerShell (`wmic` is deprecated and missing on Windows 11 24H2). On Linux, `lspci` and look for a VGA or 3D controller line naming AMD, ATI, or Intel.

## Model selection

`model: auto` is the default. The backend alone doesn't decide the model, because an integrated GPU that passes the Vulkan check can't carry a 7B model any better than the CPU can. The model is chosen by whether the GPU is *capable*:

| Condition | Model |
| --- | --- |
| Apple Silicon Mac | Qwen |
| NVIDIA with 6 GB or more of GPU memory (from `nvidia-smi`) | Qwen |
| Discrete AMD card | Qwen |
| Anything else, including integrated Intel or AMD graphics, or no GPU | Phi |

If the check can't tell whether a card is discrete or how much memory it has, choose Phi. Wrong-and-fast beats right-and-slow here.

## Overrides

In the mod's config file:

```
gpu: auto | cuda | vulkan | metal | cpu
model: auto | qwen | phi | <path to a .gguf file>
```

And in-game, for the same settings without editing a file:

```
/sentientpets ai gpu <auto|cuda|vulkan|metal|cpu>
/sentientpets ai model <auto|qwen|phi|path>
/sentientpets ai status
```

`status` prints what was detected, which backend and model were chosen, why, and whether the server is currently running. Build this first; it's how everything else gets tested.

An override that names a build or model that isn't on disk triggers the download for it, same as auto would.

## What gets downloaded

One llama.cpp release, pinned by version, from its GitHub releases page. Which zip depends on the resolved backend and the OS:

| Backend | Windows | Linux | macOS |
| --- | --- | --- | --- |
| CPU | `win-cpu-x64` | `ubuntu-x64` | `macos-arm64` or `macos-x64` |
| VULKAN | `win-vulkan-x64` | `ubuntu-vulkan-x64` | not used |
| CUDA | `win-cuda-<ver>-x64` **plus** the matching `cudart-...` zip from the same release, unless the CUDA toolkit is already installed | not available | not used |
| METAL | not used | not used | `macos-arm64` (Metal is built in) |

The exact zip names change between releases. Pin one release and read its asset list when writing the download code.

Plus one model file, per the model selection above. The mod should check the file's size, and ideally its checksum, before trusting a download.

## The fallback chain

Every step has a next step. Nothing here ends in a crash or a silent pet.

1. Resolve the backend and model, from overrides first, then auto.
2. If the chosen build and model are on disk, start the server. If it responds, done.
3. If the build was a GPU build and the server failed to start or didn't respond, **fall back to the CPU build**, downloading it if needed, and start again. Tell the player once.
4. If the model was Qwen and the server starts but replies are unusably slow (a threshold, in tokens per second, from the status output), **fall back to Phi** on the next launch. Tell the player once.
5. If the CPU build won't start either, or nothing can be downloaded, **canned lines**. Tell the player once why.

"Once" means once per game session, not on every world join.

## Testing

- `status` on a machine with no GPU should say CPU and Phi.
- `status` on a machine with an NVIDIA card should say CUDA on Windows, and Qwen if the card has 6 GB or more.
- Set `gpu: cpu` in the config on a GPU machine, rejoin, and `status` should flip to CPU. Set it back.
- Set `model: phi` on a GPU machine. It should use the GPU build with the small model. This is the right setting for a machine with a 4 GB card.
- Force the fallback: point `gpu: vulkan` at a machine whose driver won't run it, and confirm the mod ends up on the CPU build with a single message.
- The Metal and Linux paths can't be tested on the course's Windows setup. Build them, mark them untested in `PLAN.md`, and test on a Mac when one is available.

## Why this is a stretch goal

The course's version, one model on the CPU build, has one download and one way to fail. This version has five backends, two models, three platforms, and a fallback chain, and most of it can't be tested on one machine. It's a real project. It's also exactly the kind of thing the AI is good at once the rules are written down, which is what this page is.
