# ADR-solo — Foundational Decisions (FluxGit, solo dev)

**Status:** Accepted · **Date:** 2026-07-04 · **Applies from:** M0
**Sources:** `FluxGit-Solo-Dev-Plan.md` §B.5, `FluxGit-A4-Pre-Code-Resolution.md`, `FluxGit-Git-Engine-Hybrid.md`

This records the seven decisions locked before coding, plus the hybrid Git engine
(ADR-007), so the rationale lives with the code. Each is the authoritative call;
if a design doc disagrees, the reference noted here wins.

## 1. Database schema source of truth — DD-24 only
`V1__initial_schema.sql` is built from **DD-24**; schema shown in BD-xx docs is
ignored (it is stale — A4-1). All 75 tables are created up front; code is wired
per milestone. PRAGMAs live in HikariCP `connection-init-sql`, not the migration.

## 2. Module boundary DD-03 (read) vs DD-11 (write) — A4-2
DD-03 owns read/cache/graph + the live WorkingTree/Diff/Stash/Reflog services;
DD-11 owns write/workflow (staging, commit, cherry-pick, revert, reset, …).
Packages kept distinct to avoid same-name/same-package collisions:
`commit.cache` / `commit.query` / `commit.live` / `commit.workflow`.
The M0 `WorkingTreeGrpcService` lives in `commit.live`.

## 3. Git engine — Hybrid (ADR-007), a deliberate deviation from DD-21 §2
**Read** path (log/graph/branch/status/diff) → **JGit** in-process, for large-repo
performance (arrives at M2). **Write & network** path (commit/merge/rebase/push/
pull/stash/checkout/config/LFS) → **git CLI** through `GitExecutionEngine` (DD-21),
preserving native git behavior, hooks, signing, and credentials. DD-21 §2 forbids
JGit; this hybrid is an intentional, documented exception confined to the read path.
M0 runs `git status` via the CLI engine (JGit slots in at M2).
Risks tracked for M2: Windows file locks, cache coherence after CLI mutations,
read-op transparency/command-log. See `FluxGit-Git-Engine-Hybrid.md`.

## 4. gRPC shape — unary first, streaming only for progress
Everything is unary except long-running progress operations (clone/fetch/pull/push,
LFS) which use server-streaming `ProgressEvent`. M0 is unary-only (`GetStatus`).

## 5. Auth order — HTTPS/PAT first
Personal-access-token / HTTPS credential injection (via `GIT_ASKPASS`) comes first
(M5); OAuth and SSH keys follow. Credentials are injected via env/temp scripts,
never CLI args, and never logged.

## 6. Platform scope — Windows x64 for v1.0
Only Windows x64 is targeted for v1.0 (matches the SRS MVP). Linux/macOS are
deferred. Cross-platform seams are kept where cheap (e.g. `DatabaseFileProvider`
already resolves per-OS paths) but are not tested off-Windows yet.

## 7. Testing — integration-test the Git engine; defer UI tests
The Git engine is where bugs are most expensive: integration-test it against
temporary real git repositories. Widget/UI tests are deferred until after v0.1
(one smoke widget test is kept to guard app bootstrap).

## 8. Backend structure — Clean Architecture (deviates from DD-21 §4)
**Status:** Accepted 2026-07-05 · supersedes the package layout in DD-21 §4.

The backend is organized by Clean Architecture layers instead of DD-21 §4's
`com.fluxgit.git.{engine,command,result,parser,env,locator}` layout:

```
common/error        — ErrorCode, ErrorCategory, ApplicationException (framework-free)
domain/*            — value objects + ports (GitCommandExecutor, WorkingTreeService,
                      RepositoryRefReader), parsers; no Spring/gRPC/JDBC
infrastructure/*    — adapters (git/cli, git/adapter, persistence); all IO + Spring
presentation/grpc   — gRPC handlers (thin: proto↔domain) + GrpcErrorMapper
```

Rules: dependencies point inward (`presentation → domain ← infrastructure`);
domain is framework-free; ports (interfaces) live in domain, adapters in
infrastructure; constructor DI throughout.

**Naming deviations from DD-21:** `GitProcessManager → GitProcessRegistry`
(avoid the generic "Manager"); the single canonical error enum is
`common.error.ErrorCode` (DD-20 §20) — the DD-21 `GitErrorCode` enum is removed;
engine exceptions are unified into `ApplicationException`.

**Rationale:** the app owner requested Clean Architecture/DDD/SOLID; keeping the
read path swappable (JGit at M2) needs ports, and one FE-facing error catalog
needs one error type. Behavior and the gRPC/proto API are unchanged (all
integration tests stay green). Reflected in DD-21 §4 (rev 1.2) and DD-22 §1 (rev 1.3).

---

### Notes recorded during M0 (deviations found while building)
- **Root package** is `info.manhhdtop.fluxgit.backend` (Gradle group), not the
  `com.fluxgit.*` shown in DD docs. New Java lives under the real root; generated
  proto classes keep their `com.fluxgit.grpc.gen` `java_package`.
- **Spring Boot 4.1 modularization:** Flyway and (the new) `EnvironmentPostProcessor`
  moved into dedicated modules/packages — use `spring-boot-starter-flyway` and
  `org.springframework.boot.EnvironmentPostProcessor`, not the bare library / old package.
- **Spring Data JDBC + SQLite** needs an explicit `JdbcDialect` bean
  (`SqliteJdbcDialect`, ANSI-based) — no built-in SQLite dialect exists.
- **SQLite driver does not create parent dirs** → `DatabaseFileProvider` creates
  them before the DataSource is built.
