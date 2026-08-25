# FluxGit User Guide

FluxGit is a desktop Git client for Windows. Repositories, branches, history, staging
and remotes live in one window, and the real `git` command line does the work
underneath. The goal is to make Git easier without hiding it: every action maps to a
command you could have typed yourself, and the command log shows exactly what ran.

This guide describes what the app does today. Where something is deliberately not built
yet, it says so instead of pretending.

## Getting started

The welcome screen appears when no repository is open. From there, or from the
Repository menu, you can:

- **Open** a folder that already contains a `.git` directory (`Ctrl+O`).
- **Create** a repository in an empty folder — runs `git init` (`Ctrl+N`).
- **Clone** a remote repository, with progress and cancellation (`Ctrl+Shift+C`).
- **Search** repositories FluxGit already knows about (`Ctrl+Shift+S`).
- **Scan for repositories** — point FluxGit at the folders you keep repositories in
  (scan roots) and it finds them for you; the roots are managed in that same dialog.

Every open repository gets a tab. FluxGit reopens the tabs from your last session at
startup; turn that off with "Reopen last repositories" in App Settings if you prefer a
clean start.

## The window

- **Menu bar** — Repository, Edit, View, Remote, Local, Branch, Query, Tools, Review,
  Window, Help.
- **Toolbar** — Fetch, Pull, Push, Branch, Merge, Stash, Tag, plus theme toggle,
  credentials and repository settings on the right.
- **Branch sidebar** — local branches, remotes (one collapsible group per remote), tags
  and stashes, with a filter box. Names containing `/` are grouped into folders, and the
  collapsed state survives a restart.
- **Commit graph** — history with lanes, refs, hash, author and date, and a search box.
- **Details panel** — the selected commit's metadata, its changed files, and the diff.
  The file list and the diff are separately resizable, and diff text is selectable.
- **Working tree** — unstaged and staged changes, plus the commit box.
- **Status bar** — current branch, change count, repository health, operation progress
  with a cancel button, and the backend connection state.

All three panel dividers can be dragged, and the sizes are remembered. The centre graph
keeps a minimum width so its columns never overflow.

## Staging and committing

- Click a file to see its diff. Double-click, or the `+`/`−` button on the row, moves it
  between unstaged and staged. Rows can also be dragged from one column to the other.
- Shift-click selects a range; the row button then acts on the whole selection.
- "Stage all" and "Unstage all" act on the column.
- Partial staging is supported: stage individual hunks from the diff.
- The working tree is grouped into folders, which can be collapsed.

The commit box carries:

- **Commit message** with an optional template (Repository settings) and an advisory
  warning when the subject runs past the configured length. The body is wrapped at the
  configured column when you commit; the subject is left alone.
- **Amend** — loads the previous message for editing. When the commit being amended is
  already on the remote, FluxGit warns first, and afterwards offers a
  `--force-with-lease` push.
- **Sign off** — appends a `Signed-off-by` trailer.
- **Secret detection** — staged changes are scanned for things that look like keys and
  tokens (AWS, GitHub, GitLab, Slack, JWT, private keys). Findings are advisory: you are
  shown what was found, masked, and can proceed or cancel.
- **Commit signing** — configured per repository in Settings; signature status is shown
  for commits that carry one.

To throw work away: **Local ▸ Discard all** (`git reset --hard`, behind a typed
confirmation) or **Local ▸ Clean** (`git clean`), which previews the exact file list
before deleting anything, with an option to include ignored files. Individual files can
be discarded from their row's context menu.

## History

- The search box filters the loaded history by subject, author or hash.
- **File history** and **Blame** are on the context menu of any file row in the working
  tree.
- A commit's context menu offers cherry-pick, revert, reset, "create tag here", and
  squash — either from a commit up to HEAD, or a contiguous run of selected commits.
  Squash refuses a dirty tree, a merge in range, or a root commit, and rolls back if the
  commit fails.

## Branches, merging and rebasing

- Create a branch from the Branch menu or the toolbar; check out from the sidebar.
- Checking out with a dirty tree prompts before touching your work.
- **Merge** and **Rebase** are driven from the Branch menu, with a banner while an
  operation is in progress and explicit continue/abort actions.
- **Branch compare** shows what is ahead and behind between two branches.
- **Tags** — create lightweight or annotated tags at HEAD or at any commit, delete them
  locally, and push one or all.
- **Protected branches** and **commit message policies** are enforced before git runs,
  so a blocked action fails with a reason instead of a git error.

Conflicts are detected and shown, and a conflicted file can be opened in your configured
merge tool. The in-app three-way conflict editor is **not built yet** — that is the next
milestone.

## Remotes and syncing

- **Fetch** with options, or **Fast fetch** (`Ctrl+F`) which fetches every remote
  immediately with no dialog.
- **Pull** and **Push** with progress; force pushes use `--force-with-lease`.
- **Multiple remotes** are supported, each with its own collapsible group in the sidebar.
- **Manage remotes** — add, rename, remove, and change URLs.
- **Open pull request** builds the provider's web URL (GitHub or GitLab) for the current
  branch and opens it in your browser. Creating a PR through the provider's API is not
  built yet.
- **Background fetch** can be enabled per repository, with a global interval and an
  optional fetch when the window regains focus. New commits and expired credentials
  raise a notification.

## Credentials and SSH

- Credentials are stored in the Windows credential vault, never in the repository.
- A credential is chosen for an operation in this order: a binding for that repository
  and remote, then a username in the remote URL, then the most specific host pattern,
  then the default entry.
- Per-remote bindings are set from the credential dropdown under each remote in
  Repository ▸ Remotes.
- SSH keys can be generated (with or without a passphrase), listed, and converted to
  PuTTY `.ppk` format. When a remote operation fails for want of a key, FluxGit offers to
  open the host's "add an SSH key" page.

## Stash

Stash from the toolbar or Local menu, then apply, pop or drop entries from the sidebar.
Stashing untracked files is offered where it applies.

## External tools

Settings ▸ External Tools configures a diff tool, merge tool, editor and terminal.

- A **preset** list covers the common applications and fills in the usual install path;
  a tool that is not installed says so instead of silently failing.
- Tools are launched with the right files bound: for a diff, the two sides are
  materialised from git; for a merge, the three stages plus your working file.
- File rows carry "Open in external diff", "Open in editor", and — when the file is
  conflicted — "Resolve in merge tool". The in-app diff stays the default.
- Per-repository overrides are available in Repository settings.

## Terminal and command log

- **Terminal** (`Ctrl+` `` ` ``) opens an embedded terminal in the repository directory.
- **Command log** (`Ctrl+Shift+` `` ` ``) shows the git commands FluxGit ran, with exit
  codes and durations. This is the answer to "what did it actually do?".

## Settings

Settings are split into two groups:

- **Repository settings** (toolbar gear, or Repository ▸ Settings) — git config,
  per-repository tool overrides, remotes, Git LFS.
- **App settings** (Window ▸ Preferences, or `Ctrl+,`) — general workspace behaviour,
  keyboard shortcuts, appearance, external tools, credentials, notifications and
  auto-fetch.

Anything FluxGit stores in git config is read back from git config: git remains the
source of truth, so a change made in a terminal is not overwritten.

## Keyboard shortcuts

Defaults, all rebindable in App Settings ▸ Keyboard shortcuts:

- `Ctrl+O` — Open repository
- `Ctrl+N` — Create repository
- `Ctrl+Shift+C` — Clone repository
- `Ctrl+Shift+S` — Search repositories
- `Ctrl+Enter` — Open commit dialog
- `Ctrl+B` — Checkout
- `Ctrl+F` — Fast fetch (all remotes)
- `Ctrl+Shift+F` — Fetch
- `Ctrl+Shift+P` — Pull
- `Ctrl+P` — Push
- `Ctrl+` `` ` `` — Toggle terminal
- `Ctrl+Shift+` `` ` `` — Toggle command log
- `Ctrl+,` — Open settings
- `F5` — Refresh

## Updates

FluxGit checks for a newer release once at startup and offers to download and install
it. The check is silent: if there is nothing new, or the network is unavailable, it says
nothing. Turn it off with "Check for updates automatically" in App Settings.

To ask by hand, use **Help ▸ About FluxGit ▸ Check for updates**. That one always
answers, including "you are up to date" and the reason a check failed.

While the published installer is unsigned, FluxGit installs updates after verifying the
checksum published with the release. Once the installed app is itself code-signed, an
unsigned update is refused — the signature requirement turns itself back on.

## Where your data lives

- Repository data is in your repositories. Git is the source of truth for everything
  git owns.
- FluxGit's own database, logs and caches are under `%LOCALAPPDATA%\FluxGit`.
- Logs: `%LOCALAPPDATA%\FluxGit\logs\fluxgit.log` (backend) and
  `fluxgit-frontend.log` (app). Credentials and tokens are masked in both.

## Troubleshooting

- **The app sits on the splash screen.** The backend failed to start. The splash offers
  Retry; `fluxgit-frontend.log` records the launch and what it waited for.
- **An operation seems stuck.** The status bar shows progress with a cancel button;
  cancelling kills the git process for that repository.
- **"Database was rebuilt" notice.** FluxGit found its own database corrupt, moved it
  aside and rebuilt it. Nothing of yours is lost — git holds the real data.
- **Authentication keeps failing.** Check which credential is being picked in
  Repository ▸ Remotes, and bind the remote to a specific one if two accounts share a
  host.
- **Something looks wrong after an external change.** `F5` refreshes; the sidebar and
  graph reload from git.

## Not built yet

Named here so you do not go looking: in-app conflict resolution (use your merge tool for
now), interactive rebase, reflog viewer, bisect, patch management, the Git LFS management
UI, creating pull requests through a provider API, CI/CD and pipeline views, and the
repair centre for common Git problems. Query ▸ Find, Edit ▸ Undo/Redo and
Review ▸ Code review are placeholders in the menus.
