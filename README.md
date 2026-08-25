# FluxGit

A desktop Git client for Windows. Repositories, branches, history, staging and remotes in one window, with the real `git` command line doing the work underneath — FluxGit aims to make Git easier without hiding it. Every action maps to a command you could have typed yourself, and the command log shows exactly what ran.

**Status:** pre-1.0 (`0.0.8-snapshot`). The daily-driver loop — clone, browse history, stage, commit, branch, merge, rebase, push, stash, tag — is complete and in use. Larger features that are deliberately still ahead are listed under [Not built yet](#not-built-yet).

## Features

- **History** — commit graph with lanes and refs, search, file history, blame, selectable diffs, per-file and per-hunk staging.
- **Everyday commits** — commit templates, amend (with a `--force-with-lease` follow-up when the commit was already pushed), sign-off, commit signing, message policies, and an advisory scan of staged changes for keys and tokens.
- **Branches** — create, checkout, merge, rebase with progress banners and continue/abort, branch compare, protected-branch and commit-policy enforcement before git runs, lightweight and annotated tags.
- **Remotes** — fetch (including a one-keystroke fetch of every remote), pull, push, force-with-lease, multiple remotes, per-remote credential binding, background fetch with notifications, and a "open pull request" URL builder for GitHub and GitLab.
- **Credentials** — Windows credential vault, deterministic credential selection per repository and remote, SSH key generation and `.ppk` conversion.
- **Tools** — configurable diff, merge, editor and terminal applications with presets and install-path detection, an embedded terminal, and a command log with exit codes and durations.
- **Safety** — every destructive action previews what it will do; clean previews the file list, discard sits behind a typed confirmation, and cancellation kills the underlying git process.

## Documentation

The user guide is [`docs/fluxgit-guide.md`](docs/fluxgit-guide.md). It ships inside the app as well, under **Help ▸ Documentation**, so both read the same file.

Architecture decisions are recorded in [`docs/ADR-solo.md`](docs/ADR-solo.md). The full requirement and design set (SRS, basic and detailed design, roadmap) is kept outside this repository.

## Install

Download `FluxGit-Setup-<version>.exe` from the [releases page](https://github.com/manhhdtop/fluxgit/releases) and run it. The installer is x64, installs to Program Files, and creates Start-menu and optional desktop shortcuts.

Every release also publishes `SHA256SUMS`; the in-app updater verifies a download against it. The installer is not code-signed yet, so Windows will warn on first run — verify the checksum yourself if that matters to you.

**Git is not bundled.** FluxGit drives the `git` on your machine, so install
[Git for Windows](https://git-scm.com/download/win) first. `git-lfs` is optional and only needed for LFS repositories.

A Java runtime is bundled with the installer (Eclipse Temurin, GPLv2 with Classpath Exception) — nothing to install separately.

## Not built yet

In-app conflict resolution (a configured merge tool is launched instead), interactive rebase, reflog viewer, bisect, patch management, the Git LFS management UI, pull-request creation through a provider API, CI/CD and pipeline views, and the repair centre for common Git problems. A few menu entries — Query ▸ Find, Edit ▸ Undo/Redo, Review ▸ Code review — are placeholders.

## Licence

Proprietary; see [`LICENSE`](LICENSE). Third-party components and their licences are
listed in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md).