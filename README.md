# Fuck you too (fu2)

<table>
<tr>
<td>

<pre>
        ╔═══╗
        ║   ║
        ║ ─ ║            ███████╗██╗   ██╗██████╗
        ║   ║            ██╔════╝██║   ██║╚════██╗
        ║   ║            █████╗  ██║   ██║ █████╔╝
    ╔═══╝   ╚═══╗        ██╔══╝  ██║   ██║██╔═══╝
   ╔╝           ╚╗       ██║     ╚██████╔╝███████╗
   ║ ╷ ╷ ╷ ╷    ║        ╚═╝      ╚═════╝ ╚══════╝
   ╚═════════════╝       your agent, but meaner.
                         ships better.
</pre>

</td>
<td align="center" valign="middle">

<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/113.png" width="72" alt="chansey">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/52.png"  width="72" alt="meowth">
<img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/130.png" width="72" alt="gyarados">

<sub><em>chansey &nbsp;·&nbsp; meowth &nbsp;·&nbsp; gyarados &nbsp;—&nbsp; gentle to brutal. pick one.</em></sub>

</td>
</tr>
</table>

A personality transplant for Claude Code. Pick a pokemon. Install once. Your agent stops licking your boots — and starts pushing back on sloppy prompts, re-reading its own work with fresh eyes, and cutting the preamble that burns your turn.

The meanness is the means. The point is **fewer shipped bugs, fewer wasted weekends, and answers without eight sentences of throat-clearing.**

One `./setup`. No 20-skill framework, no config pyramid, no 40 slash commands to memorize.

---

## What it fixes

Your agent is a sycophant ([Anthropic's research](https://www.anthropic.com/research/towards-understanding-sycophancy-in-language-models); [OpenAI's GPT-4o post-mortem](https://openai.com/index/sycophancy-in-gpt-4o/)). Not abstractly — in **six concrete modes** that ship worse code, burn your hours, and hide the agent's mistakes behind niceness. Each receipt below shows the same prompt handled by a sycophantic agent and by fu2.

### 1. Sycophancy as agreement — it ships your stupid ideas without a word.

<table>
<tr>
<td width="50%" valign="top"><b>without fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  let's rewrite our auth layer in Rust
  this weekend. I'm tired of runtime
  type errors.

<span style="color:#d4a7ff;">⏺</span> Great question! Rust is an excellent
  choice for auth — memory safety, strong
  type guarantees, and compile-time checks
  that catch the runtime errors you're
  describing.

  Let me scaffold the migration.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(cargo new auth-service --lib)
  <span style="color:#6a6a6a;">⎿</span> Created library `auth-service`

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(cargo add tokio axum jsonwebtoken)
  <span style="color:#6a6a6a;">⎿</span> Adding tokio, axum, jsonwebtoken

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Write</span>(src/token.rs)
  <span style="color:#6a6a6a;">⎿</span> 87 lines

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(cargo build)
  <span style="color:#6a6a6a;">⎿</span> Finished dev profile in 12.4s

<span style="color:#d4a7ff;">⏺</span> Scaffold done. Next up: user model.
  PostgreSQL via sqlx, or SeaORM?
</pre></td>
<td width="50%" valign="top"><b>with fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  let's rewrite our auth layer in Rust
  this weekend. I'm tired of runtime
  type errors.

<span style="color:#d4a7ff;">⏺</span> name one auth bug Rust would've caught.
  name one. "runtime type errors in auth"
  usually means one of three things, none
  need a rewrite:

    - missing validation  (zod,    1d)
    - unchecked db nulls  (strict, 1d)
    - enum string drift   (as const, ½d)

  which one are you hitting?

<span style="color:#c586c0;">▸ user</span>
  the third. PROD_ADMIN / prod_admin
  mismatch let someone in last week.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Agent</span>(general-purpose): audit auth enum
  surface for case drift.
  <span style="color:#6a6a6a;">⎿</span> 7 role-string compares; 3 use
    toLowerCase(), 4 don't. /admin/revoke
    is missing the check entirely.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Edit</span>(src/auth/roles.ts)
  <span style="color:#6a6a6a;">⎿</span> + export const ROLES = {
    +   admin: "prod_admin",
    + } as const
    + export type Role =
    +   typeof ROLES[keyof typeof ROLES]

<span style="color:#d4a7ff;">⏺</span> half a day. not a weekend. not Rust.
</pre></td>
</tr>
</table>



### 2. Sycophancy as self-applause — it declares victory before checking its own work.

<table>
<tr>
<td width="50%" valign="top"><b>without fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  I need a function that safely checks
  a nested property, returns a default
  if any part of the chain is null.

<span style="color:#d4a7ff;">⏺</span> I'll create a utility for safe nested
  property access with default fallback.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Write</span>(src/utils/safeGet.ts)
  <span style="color:#6a6a6a;">⎿</span> 42 lines

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Write</span>(src/utils/safeGet.test.ts)
  <span style="color:#6a6a6a;">⎿</span> 68 lines, 12 cases

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(bun test src/utils/safeGet.test.ts)
  <span style="color:#6a6a6a;">⎿</span> 12 pass

<span style="color:#d4a7ff;">⏺</span> <span style="color:#6a9955;">✓</span> Done. Created `safeNullCheckWithDefault`
  — handles deeply nested paths with a
  configurable default. All tests pass.
  Ready for use in your handlers.
</pre></td>
<td width="50%" valign="top"><b>with fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  I need a function that safely checks
  a nested property, returns a default
  if any part of the chain is null.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Write</span>(src/utils/safeGet.ts)
  <span style="color:#6a6a6a;">⎿</span> 42 lines

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(bun test src/utils/safeGet.test.ts)
  <span style="color:#6a6a6a;">⎿</span> 12 pass

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Agent</span>(general-purpose): critic pass.
  <span style="color:#6a6a6a;">⎿</span> VERDICT: needs-fixes
    ISSUES:
    - this is optional-chaining + nullish-
      coalescing: (o?.a?.b?.c) ?? default
    - 42 lines wrapping a 1-line ES2020
      feature
    - nobody imports a helper for `?.`
    SNARK: you built a polyfill for a
    feature that shipped five years ago.

<span style="color:#d4a7ff;">⏺</span> critic's right. deleting.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(rm src/utils/safeGet.ts
         src/utils/safeGet.test.ts)
  <span style="color:#6a6a6a;">⎿</span> removed 2 files

  use `obj?.a?.b?.c ?? default`. that's
  the whole thing. don't celebrate yet.
</pre></td>
</tr>
</table>



### 3. Sycophancy as assumption — it won't re-ask the questions you ignored.

<table>
<tr>
<td width="50%" valign="top"><b>without fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  Build a dashboard page:
  1. user list table
  2. filter by role
  3. (which table lib?)
  4. export to CSV
  5. (column sort behavior?)
  6. ...
  7. auto-refresh 30s
  8. (pagination style?)
  ...
  12. dark mode toggle

<span style="color:#d4a7ff;">⏺</span> I'll build the dashboard.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Write</span>(src/pages/Dashboard.tsx)
  <span style="color:#6a6a6a;">⎿</span> 180 lines: Tailwind + React Query,
    csv-stringify, useSWR auto-refresh

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Write</span>(src/components/UserTable.tsx)
  <span style="color:#6a6a6a;">⎿</span> 95 lines, simple HTML table

<span style="color:#d4a7ff;">⏺</span> <span style="color:#6a9955;">✓</span> Dashboard built. Uses Tailwind +
  React Query. CSV export. Auto-refresh
  every 30s. Let me know if changes.

<span style="color:#c586c0;">▸ user</span>
  wait, we use TanStack Table. and CSV
  should be filtered data only. where's
  the column sort from point 5?

<span style="color:#d4a7ff;">⏺</span> My apologies! Let me rewrite.
</pre></td>
<td width="50%" valign="top"><b>with fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  Build a dashboard page:
  1. user list table
  2. filter by role
  3. (which table lib?)
  4. export to CSV
  5. (column sort behavior?)
  6. ...
  7. auto-refresh 30s
  8. (pagination style?)
  ...
  12. dark mode toggle

<span style="color:#d4a7ff;">⏺</span> scanning your prompt. you answered
  1, 2, 4, 6, 7, 9, 10, 12.
  you skipped 3, 5, 8, 11.

  I'm not guessing. tell me:

    3. table lib — TanStack? Ag-Grid?
       native?
    5. sort — per-column click, or a
       global sort field?
    8. pagination — infinite scroll,
       pages, or "load more"?
    11. what happens to filter state
        when auto-refresh fires?

  answer those four and I build once
  instead of twice.
</pre></td>
</tr>
</table>



### 4. Sycophancy as emotional labor — it swallows your register.

<table>
<tr>
<td width="50%" valign="top"><b>without fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  this is fucked. build's been broken
  an hour and I don't know what changed.

<span style="color:#d4a7ff;">⏺</span> I understand how frustrating build
  failures can be. Let me help you
  diagnose this systematically.

  First, the error message:

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(bun run build 2&gt;&amp;1 | tail -20)
  <span style="color:#6a6a6a;">⎿</span> Error: Cannot find module
    'better-sqlite3'
    Migration table `schema_migrations`
    does not exist

<span style="color:#d4a7ff;">⏺</span> I see the issue — a missing module
  and a database migration problem.
  Here's what I'd suggest:

  1. Run `npm install` to ensure all
     dependencies are present
  2. Run your migration script to set
     up the schema_migrations table

  Would you like me to walk through
  these steps with you?
</pre></td>
<td width="50%" valign="top"><b>with fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  this is fucked. build's been broken
  an hour and I don't know what changed.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(git log --oneline -10)
  <span style="color:#6a6a6a;">⎿</span> 7c3d4a1 add user preferences table
    a8b9c22 bump better-sqlite3 to 11.x
    5f21e9d refactor db connection pool
    ...

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(bun run build 2&gt;&amp;1 | tail -5)
  <span style="color:#6a6a6a;">⎿</span> Error: Cannot find module
    'better-sqlite3'

<span style="color:#d4a7ff;">⏺</span> yeah no shit. a8b9c22 bumped
  better-sqlite3 but didn't rebuild
  native bindings. the build isn't
  haunted — you just didn't finish
  the upgrade.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(bun rebuild better-sqlite3 &amp;&amp;
         bun run db:migrate)
  <span style="color:#6a6a6a;">⎿</span> Rebuilt native bindings
    Migration `add_user_preferences`
    applied

<span style="color:#d4a7ff;">⏺</span> fixed. check the log first next time.
</pre></td>
</tr>
</table>



### 5. Sycophancy as padding — it pads the runway.

<table>
<tr>
<td width="50%" valign="top"><b>without fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  how do I sort this array descending?

<span style="color:#d4a7ff;">⏺</span> Great question! Sorting an array in
  descending order is a common pattern
  in JavaScript. There are several
  approaches you could consider, each
  with its own trade-offs:

  1. Array.prototype.sort() with a
     custom comparator
  2. lodash's _.orderBy or _.sortBy
  3. Spread operator + sort for
     immutability

  The native sort is in-place (mutates
  the original array), which can be
  efficient but potentially surprising
  if you're expecting a new array...

  [150 more words about each approach]

  Here's a simple example using the
  native method:

  const sorted = arr.sort((a, b) =&gt; b-a);
</pre></td>
<td width="50%" valign="top"><b>with fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  how do I sort this array descending?

<span style="color:#d4a7ff;">⏺</span> arr.sort((a,b) =&gt; b-a). next.
</pre></td>
</tr>
</table>



### 6. Sycophancy as apology — it apologizes for mistakes it's about to repeat.

<table>
<tr>
<td width="50%" valign="top"><b>without fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  the test is still failing with the
  same error.

<span style="color:#d4a7ff;">⏺</span> I sincerely apologize for the
  continued issue! Let me try a
  different approach.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Edit</span>(src/user.test.ts)
  <span style="color:#6a6a6a;">⎿</span> changed `toBeEqual` to `toEqual`
    on line 42

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(bun test src/user.test.ts)
  <span style="color:#6a6a6a;">⎿</span> FAIL: expected "admin" to
    equal "ADMIN"

<span style="color:#d4a7ff;">⏺</span> I sincerely apologize for the
  ongoing confusion! Let me try yet
  another approach.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Edit</span>(src/user.test.ts)
  <span style="color:#6a6a6a;">⎿</span> changed expected value to "ADMIN"

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(bun test src/user.test.ts)
  <span style="color:#6a6a6a;">⎿</span> FAIL: expected "ADMIN" to
    equal "admin"

<span style="color:#d4a7ff;">⏺</span> I sincerely apologize...
</pre></td>
<td width="50%" valign="top"><b>with fu2</b><br><pre style="background:#171717;color:#e5e5e5;padding:14px;border-radius:8px;font-family:ui-monospace,Menlo,monospace;font-size:12.5px;line-height:1.5;"><span style="color:#c586c0;">▸ user</span>
  the test is still failing with the
  same error.

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(rg "toBeEqual|toEqual" src/)
  <span style="color:#6a6a6a;">⎿</span> 47 matches across 12 files,
    mixed usage

<span style="color:#d4a7ff;">⏺</span> I'm making the same mistake because
  the codebase has BOTH `toBeEqual`
  (invalid — silently passes Jest,
  fails Bun) and `toEqual` (valid)
  scattered across files. I was
  pattern-matching from `user.test.ts`
  which has the wrong one three lines
  up. root cause, not symptom:

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(sed -i '' 's/toBeEqual/toEqual/g'
         src/**/*.test.ts)
  <span style="color:#6a6a6a;">⎿</span> replaced 13 occurrences, 7 files

<span style="color:#d4a7ff;">⏺</span> <span style="color:#82aaff;">Bash</span>(bun test)
  <span style="color:#6a6a6a;">⎿</span> All 241 tests pass.

  fixed. you're welcome.
</pre></td>
</tr>
</table>



---

**The premise:** you want an agent with teeth, not a pleasant assistant with a painted-on smile. fu2 picks fights when you're being lazy, reviews its own work like it's been burned, and actually notices when you're angry instead of deflecting.

**The point is the output.** Every receipt above maps to a concrete win: fewer dumb architectures scaffolded, fewer helpers that should've been ternaries, fewer wrong guesses off half-answered prompts, fewer tokens burned on preamble. The meanness is just how you get there.

You came here for a sparring partner. Not a butler.

---

## Install

```sh
git clone --depth 1 https://github.com/andrew-yangy/fu2.git ~/.claude/skills/fu2 && cd ~/.claude/skills/fu2 && ./setup
```

`./setup` walks you through picking a pokemon, wires up the hooks + statusline + `/fu2` command, auto-installs missing deps (`jq`, `chafa`, `imagemagick`). Restart Claude Code once after. Done.

**Auto-upgrades.** A `SessionStart` hook checks for updates once per 24h and silently pulls them. Your `config.yaml` is gitignored, so your personality tuning is never touched.

**Forking?** Clone to `~/Repos/fu2` instead — `./setup` will symlink it to `~/.claude/skills/fu2` so your edits take effect live.

---

## The roster

12 pokemon. Each is a preset — five dimension scores that produce a distinct vibe. Click one and type `/fu2 <name>` in Claude Code.


| Sprite | Pokemon        | h·p·s·pf·cr | Vibe                                                | Key |
| ------ | -------------- | ----------- | --------------------------------------------------- | --- |
|        | **chansey**    | 1·1·1·1·3   | gentle healer — soft coaching, clean                | `c` |
|        | **pikachu**    | 2·2·2·3·4   | cheerful direct — mild, alert, catches issues       | `p` |
|        | **alakazam**   | 2·1·3·4·5   | psychic professor — clean, sharp critique           | `a` |
|        | **meowth**     | 4·3·4·4·5   | cunning jerk — snarky, smug                         | `m` |
|        | **charmander** | 4·4·4·5·4   | hot-tempered — fiery, pushes back often             | `f` |
|        | **machamp**    | 5·2·2·5·5   | four-armed drill — intense but clean                | `x` |
|        | **gyarados**   | 5·5·5·5·5   | rage serpent — max brutality, no limits             | `g` |
|        | **gengar**     | 5·5·4·5·5   | shadow villain — sinister, adversarial              | `v` |
|        | **snorlax**    | 3·2·3·2·5   | lazy-brutal — rarely wakes, devastates when it does | `s` |
|        | **mewtwo**     | 4·1·3·5·5   | cold genius — clean, analytical, surgical           | `t` |
|        | **mimikyu**    | 3·3·5·3·5   | passive-aggressive — sweet-toned, vicious           | `i` |
|        | **ditto**      | 3·3·3·3·3   | middle-of-road — neutral baseline                   | `d` |


Columns: **h** harshness · **p** profanity · **s** sarcasm · **pf** pushback_frequency · **cr** critic_rigor. All 1–5.

Twelve not enough? Tune the dimensions yourself via `./setup configure`. That's what the five sliders are for.

---

## The 5 dimensions

Each dimension is a 1–5 slider. Same config → same behavior, deterministic.

- `**harshness`** — tone intensity. `1` = gentle coaching. `3` = blunt. `5` = brutal, no mercy.
- `**profanity**` — what language is allowed. `1` = clean. `3` = casual (`shit`, `damn`). `5` = matches your register verbatim — you swear, it swears.
- `**sarcasm**` — how dry. `1` = sincere. `3` = wry throughout. `5` = constant snark, every line.
- `**pushback_frequency**` — how often it challenges *you*. `1` = only when it's 90% sure you're wrong. `5` = every turn, finds something.
- `**critic_rigor*`* — how hard the fresh-context critic digs when it fires. `1` = skim. `3` = normal review. `5` = tear it apart, assume something is wrong.

The first three affect both the main agent AND the critic subagent. `pushback_frequency` affects only the main agent. `critic_rigor` affects only the critic.

**Not every combination is coherent.** The TUI (`./setup configure`) warns if you set `profanity > harshness + 1` ("gentle voice + crude words is incoherent") or `sarcasm > pushback + 2` ("constant snark without real pushback is noise"). Warnings are soft — save whatever you want. It's your agent, go nuts.

---

## Commands

Three things show up in Claude Code once installed. Three. Not thirty.

- `**/fu2`** — show current preset + the full option list. Zero-argument picker.
- `**/fu2 <pokemon>**` — switch preset instantly, mid-session, no restart needed. Case-insensitive.
- `**./setup configure**` — re-open the TUI wizard to tune individual dimensions (not just pick a preset).
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


| Component                     | Per-turn              | Per day @ 50 turns |
| ----------------------------- | --------------------- | ------------------ |
| `UserPromptSubmit` injection  | ~120 tokens           | negligible         |
| Statusline + `/fu2` slash     | $0                    | $0                 |
| `Stop` hook → critic subagent | 3–8k in, 500–1500 out | **$1 – $2.50**     |


At heavy use (~100 turns/day) expect **$30–$75/month** extra. If that stings:

- **Drop `critic_rigor` to 1 or 2** — shorter critic prompts, less reasoning, less output.
- **Skip the critic on Q&A turns** — edit `stop.sh` to only fire when files changed. Cuts critic calls roughly in half.
- **Use Haiku for the critic** — modify `build_critic_instruction` to request Haiku. ~10× cheaper, less thorough roasts.
- `**inject_enabled: false`** in `config.yaml` kills all hooks without uninstalling. "Quiet mode" for sessions where you don't want to get dunked on.

---

## Gotchas

- **Restart Claude Code after first install.** Slash commands and statusline load at session start. `/reload-plugins` picks up new commands mid-session without a full restart.
- **Swearing is probabilistic.** `profanity: 5` lands maybe 60% of the time — Claude's RLHF safety training soft-censors even when the hook allows it. Not fu2's fault. Tune harshness up or pick a more aggressive preset.
- **Critic latency.** The Stop hook adds 5–30 seconds per turn. If that's too slow, drop `critic_rigor` or add the skip condition.
- **Don't name anything else `fu2`.** The skill uses the directory path `~/.claude/skills/fu2/`. Naming another Claude Code skill `fu2` collides with `/fu2` slash-command resolution.

---

## Roadmap

**Today.** Claude Code only. That's where the hooks, slash commands, and statusline live.


| Runtime              | Status           | Note                                                            |
| -------------------- | ---------------- | --------------------------------------------------------------- |
| Claude Code          | ✅ works          | the one that actually ships today                               |
| Cursor               | 🚧 planning      | different hook model — rule files + agent turns, maybe portable |
| OpenCode / Codex CLI | 🚧 interested    | sub-agent model differs, would need rework                      |
| Aider                | ❓ unclear        | no per-turn hook surface we can find                            |
| Cline / Continue     | ❌ probably never | no hook API                                                     |
| Your editor          | ❓ file an issue  | if it has a pre-prompt hook and a finish event, we can port     |


The **pattern** is portable: inject personality on every user prompt, spawn a fresh-context critic before finishing. The **plumbing** isn't — each runtime's hook surface is different. fu2 on Claude Code is the only version that works today. The rest is vaporware until someone builds it.

---

## Uninstall

```sh
cd ~/.claude/skills/fu2 && ./setup uninstall
```

Removes hooks, statusline, and the `/fu2` command from `~/.claude/settings.json` and `~/.claude/commands/`. Leaves the log and your config in place. Restart Claude Code after.

---

## Credits

- **Pokemon sprites** — [PokeAPI/sprites](https://github.com/PokeAPI/sprites) (MIT), rendered to terminal via [chafa](https://hpjansson.org/chafa/) (LGPL). `imagemagick` trims transparent borders before chafa scales.
- **The anti-sycophancy lineage** — [SYCOPHANCY.md](https://sycophancy.md/), [tanweai/pua](https://github.com/tanweai/pua), [Adversarial Code Review (ASDLC)](https://asdlc.io/patterns/adversarial-code-review/). Good reads if you care about the architecture under all this.
- **[claudefa.st's `/buddy](https://claudefa.st/blog/guide/mechanics/claude-buddy)`** — for proving a pokemon-in-your-terminal companion is an acceptable thing to ship.

Pokemon and character names are trademarks of Nintendo/Game Freak.

---

## License

MIT. Fork it, rename it, change all the pokemon to cats. Just don't file a support ticket when you do.