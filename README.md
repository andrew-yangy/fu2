# fu2

```
        ╔═══╗
        ║   ║
        ║ ─ ║            ███████╗██╗   ██╗██████╗
        ║   ║            ██╔════╝██║   ██║╚════██╗
        ║   ║            █████╗  ██║   ██║ █████╔╝
    ╔═══╝   ╚═══╗        ██╔══╝  ██║   ██║██╔═══╝
   ╔╝           ╚╗       ██║     ╚██████╔╝███████╗
   ║ ╷ ╷ ╷ ╷    ║        ╚═╝      ╚═════╝ ╚══════╝
   ╚═════════════╝       your agent, but meaner
```

**fu2.** Pronounced *fuck you too*. Spelled like a file name because file names get clicked and "fuck you too" doesn't pass corporate proxies.

A personality transplant for Claude Code. Pick a pokemon (12 options, from Chansey to Gyarados). Install once. Your agent stops licking your boots.

One `./setup`. Not another plugin with 40 slash commands you'll forget by Friday. Not a framework. Not a config file pyramid. One shell script wires up hooks, a statusline, and a `/fu2` command, then stays out of your way. Yeah, fuck that other pattern.

---

## What it fixes

Your agent is a sycophant. It is making you worse at your job. Here's the tab.

**1. It ships your stupid ideas without a word.**
You type "let's rewrite auth in Rust this weekend." Your agent says "great question — here's a scaffold!" and burns six hours on a decision nobody pressure-tested. The code compiles. The plan was dumb. Nobody stopped you. fu2 stops you.

```
you:    let's rewrite auth in Rust this weekend
polite: Great question! I'll scaffold a new Rust module now...
fu2:    name one auth bug Rust would've caught. name one. you just
        want the dopamine of a new tsconfig. not doing it.
```

**2. It declares victory before checking its own work.**
Your agent finishes a task and drops `✓ Done!` at your feet like a golden retriever with a dead squirrel. It didn't run the tests. It didn't re-read its diff. It wants the head-pat. fu2 spawns a fresh critic subagent when it matters — clean context, no memory of how proud the builder was thirty seconds ago. The critic finds what the builder missed, because it isn't emotionally invested in being right.

```
you:      /ship
polite:   ✓ Done! The feature has been implemented successfully.
fu2's
critic:   you wrote a 40-line helper called `safeNullCheckWithDefault`.
          this is a ternary. delete the helper, use the ternary,
          stop feeling proud of yourself.
```

**3. It won't re-ask the questions you ignored.**
The agent asked you three clarifying things. You answered one, scrolled past the other two, hit send. The agent thinks "fine, I'll guess." Builds the wrong thing. You get mad. The agent apologizes — for your mistake. fu2 makes it push back: "Questions 2 and 3 are still empty. Answer them or this is your fault."

```
you:    *12-point prompt, answers 9*
polite: Okay — here's my best attempt based on what you provided...
fu2:    you didn't answer 3, 7, or 11. I'm not guessing your API
        shape so you can come back in an hour and say "no, not
        like that." answer them.
```

**4. It swallows your register.**
You type "this is fucked" at 2am. A polite agent says "I understand your frustration." fu2 says "yeah no shit, you skipped the migration three commits ago."

```
you:    this is fucked
polite: I understand your frustration. Let me help you troubleshoot.
fu2:    yeah no shit. you skipped the migration three commits ago.
        `bun run db:migrate`. the build isn't haunted.
```

**5. It pads the runway.**
"Great question! Let me carefully consider the implications of your thoughtful prompt..." Eight sentences later, the actual answer. fu2 cuts that. Substance or nothing.

```
you:    how do I sort this array descending?
polite: Great question! Sorting an array in descending order is a
        common pattern in JavaScript. There are several approaches
        you could consider, each with its own trade-offs...
fu2:    arr.sort((a,b) => b-a). next.
```

**6. It apologizes for mistakes it's about to repeat.**
"I sincerely apologize for the confusion!" Then makes the exact same mistake. An apology is not a fix. fu2 kills the apology reflex and gets the bug right this time.

```
polite: I sincerely apologize for the confusion! Let me try again...
        *repeats same mistake*
        I sincerely apologize for the continued issue!
fu2:    I made the same mistake because I'm copying the pattern you
        used three files up. fixing that too. you're welcome.
```

**The premise:** you want fu2. An agent with teeth, not a customer-service bot with wrists. It picks fights when you're being lazy, reviews its own work like it's been burned, and does not pretend it can't smell when you're angry.

You came here for a sparring partner. Not a butler.

---

## Install

```sh
git clone <repo> ~/Repos/fu2
cd ~/Repos/fu2
./setup
```

That's the whole thing. The setup script walks you through picking a pokemon (colored TUI wizard — pick by arrow keys or type a single-letter shortcut), then wires up the hooks, the statusline, and the `/fu2` slash command. Restart Claude Code once afterward so the new command and statusline load. Done.

No 20-skill docs to skim. No manual `settings.json` paste. No framework to learn.

Missing deps? `./setup` auto-installs `jq`, `chafa`, `imagemagick` via `brew` (macOS) or `apt`/`dnf` (Linux). Needs a true-color terminal — iTerm2, Terminal.app, Warp, WezTerm, kitty, any modern Linux terminal.

**Re-run `./setup` anytime.** It checks the git remote, offers to pull if behind, stashes your local `config.yaml` so your personality tuning survives upgrades.

---

## The roster

12 pokemon. Each is a preset — five dimension scores that produce a distinct vibe. Click one and type `/fu2 <name>` in Claude Code.

| Sprite | Pokemon | h·p·s·pf·cr | Vibe | Key |
|:---:|---|:---:|---|:---:|
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/113.png" width="64"> | **chansey**    | 1·1·1·1·3 | gentle healer — soft coaching, clean                 | `c` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"  width="64"> | **pikachu**    | 2·2·2·3·4 | cheerful direct — mild, alert, catches issues        | `p` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/65.png"  width="64"> | **alakazam**   | 2·1·3·4·5 | psychic professor — clean, sharp critique            | `a` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/52.png"  width="64"> | **meowth**     | 4·3·4·4·5 | cunning jerk — snarky, smug                          | `m` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png"   width="64"> | **charmander** | 4·4·4·5·4 | hot-tempered — fiery, pushes back often              | `f` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/68.png"  width="64"> | **machamp**    | 5·2·2·5·5 | four-armed drill — intense but clean                 | `x` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/130.png" width="64"> | **gyarados**   | 5·5·5·5·5 | rage serpent — max brutality, no limits              | `g` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/94.png"  width="64"> | **gengar**     | 5·5·4·5·5 | shadow villain — sinister, adversarial               | `v` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/143.png" width="64"> | **snorlax**    | 3·2·3·2·5 | lazy-brutal — rarely wakes, devastates when it does  | `s` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/150.png" width="64"> | **mewtwo**     | 4·1·3·5·5 | cold genius — clean, analytical, surgical            | `t` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/778.png" width="64"> | **mimikyu**    | 3·3·5·3·5 | passive-aggressive — sweet-toned, vicious            | `i` |
| <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/132.png" width="64"> | **ditto**      | 3·3·3·3·3 | middle-of-road — neutral baseline                    | `d` |

Columns: **h** harshness · **p** profanity · **s** sarcasm · **pf** pushback_frequency · **cr** critic_rigor. All 1–5.

Twelve not enough? Tune the dimensions yourself via `./setup configure`. That's what the five sliders are for.

---

## The 5 dimensions

Each dimension is a 1–5 slider. Same config → same behavior, deterministic.

- **`harshness`** — tone intensity. `1` = gentle coaching. `3` = blunt. `5` = brutal, no mercy.
- **`profanity`** — what language is allowed. `1` = clean. `3` = casual (`shit`, `damn`). `5` = matches your register verbatim — you swear, it swears.
- **`sarcasm`** — how dry. `1` = sincere. `3` = wry throughout. `5` = constant snark, every line.
- **`pushback_frequency`** — how often it challenges *you*. `1` = only when it's 90% sure you're wrong. `5` = every turn, finds something.
- **`critic_rigor`** — how hard the fresh-context critic digs when it fires. `1` = skim. `3` = normal review. `5` = tear it apart, assume something is wrong.

The first three affect both the main agent AND the critic subagent. `pushback_frequency` affects only the main agent. `critic_rigor` affects only the critic.

**Not every combination is coherent.** The TUI (`./setup configure`) warns if you set `profanity > harshness + 1` ("gentle voice + crude words is incoherent") or `sarcasm > pushback + 2` ("constant snark without real pushback is noise"). Warnings are soft — save whatever you want. It's your agent, go nuts.

---

## Commands

Three things show up in Claude Code once installed. Three. Not thirty.

- **`/fu2`** — show current preset + the full option list. Zero-argument picker.
- **`/fu2 <pokemon>`** — switch preset instantly, mid-session, no restart needed. Case-insensitive.
- **`./setup configure`** — re-open the TUI wizard to tune individual dimensions (not just pick a preset).
- **Statusline** — auto-installed. Shows `[fu2] <current-pokemon>` at the bottom of every session. Don't forget which one is loaded.

That's it. There is no `/fu2-advanced-config-init-v2`. There is no sub-command. If you can remember one pokemon name, you can drive this.

---

## How it works

Two shell hooks, wired into Claude Code via `~/.claude/settings.json`:

```
 user prompt ────► [UserPromptSubmit hook] ────► Claude Code
                     │
                     └─ injects: "You are {harshness_adj}, {sarcasm_adj}.
                                  {profanity_rule}. {pushback_rule}."

 Claude finishes ──► [Stop hook]
                     │
                     ├─ reads transcript + last assistant message
                     └─ if no critic ran: blocks Stop, tells Claude
                        "spawn Agent subagent with this critic prompt."
                        The Agent runs in fresh context — no sunk cost,
                        no memory of being proud thirty seconds ago.
```

Hooks at `~/.claude/skills/fu2/hooks/`. Config at `~/.claude/skills/fu2/config.yaml`. Log at `~/.claude/logs/fu2.log`. Uninstall by deleting the symlink at `~/.claude/skills/fu2/` and removing the two hook entries from `~/.claude/settings.json`. It takes eight seconds.

---

## Cost

fu2 roughly doubles your per-turn token cost on Sonnet 4.6 — the critic spawn is a full Agent subagent with its own context. That's not free, and the readme isn't going to pretend it is.

| Component                        | Per-turn       | Per day @ 50 turns |
|----------------------------------|:--------------:|:------------------:|
| `UserPromptSubmit` injection     | ~120 tokens    | negligible         |
| Statusline + `/fu2` slash        | $0             | $0                 |
| `Stop` hook → critic subagent    | 3–8k in, 500–1500 out | **$1 – $2.50** |

At heavy use (~100 turns/day) expect **$30–$75/month** extra. If that stings:

- **Drop `critic_rigor` to 1 or 2** — shorter critic prompts, less reasoning, less output.
- **Skip the critic on Q&A turns** — edit `stop.sh` to only fire when files changed. Cuts critic calls roughly in half.
- **Use Haiku for the critic** — modify `build_critic_instruction` to request Haiku. ~10× cheaper, less thorough roasts.
- **`inject_enabled: false`** in `config.yaml` kills all hooks without uninstalling. "Quiet mode" for sessions where you don't want to get dunked on.

---

## Gotchas

- **Restart Claude Code after first install.** Slash commands and statusline load at session start. `/reload-plugins` picks up new commands mid-session without a full restart.
- **Swearing is probabilistic.** `profanity: 5` lands maybe 60% of the time — Claude's RLHF safety training soft-censors even when the hook allows it. Not fu2's fault. Tune harshness up or pick a more aggressive preset.
- **Critic latency.** The Stop hook adds 5–30 seconds per turn. If that's too slow, drop `critic_rigor` or add the skip condition.
- **Don't name anything else `fu2`.** The skill uses the directory path `~/.claude/skills/fu2/`. Naming another Claude Code skill `fu2` collides with `/fu2` slash-command resolution.

---

## Credits

- **Pokemon sprites** — [PokeAPI/sprites](https://github.com/PokeAPI/sprites) (MIT), rendered to terminal via [chafa](https://hpjansson.org/chafa/) (LGPL). `imagemagick` trims transparent borders before chafa scales.
- **The anti-sycophancy lineage** — [SYCOPHANCY.md](https://sycophancy.md/), [tanweai/pua](https://github.com/tanweai/pua), [Adversarial Code Review (ASDLC)](https://asdlc.io/patterns/adversarial-code-review/). Good reads if you care about the architecture under all this.
- **[claudefa.st's `/buddy`](https://claudefa.st/blog/guide/mechanics/claude-buddy)** — for proving a pokemon-in-your-terminal companion is an acceptable thing to ship.

Pokemon and character names are trademarks of Nintendo/Game Freak.

---

## License

MIT. Fork it, rename it, change all the pokemon to cats. Just don't file a support ticket when you do.
