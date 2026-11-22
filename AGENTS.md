# Mermaid agent guide

Standalone Ziran package for bounded Unicode terminal diagrams: flowcharts,
sequences, flat state machines, classes, and entity relationships. Rendering
preserves semantic node/edge/text roles and fails with `UNSUPPORTED`, `LIMIT`
or `TOO_WIDE` instead of partial output.

## Layout

- `src/mermaid.zi` — the module, exported as `mermaid`; import
  `mermaid/mermaid`. Entry points: `Render`, `RenderTextBytes`, `RenderBytes`
  (contracts in README).
- `tests/mermaid_test.zi` — the shared test entry for all backends.
- `Makefile` — `check` and `test`; `build/` holds outputs; an ignored
  `ziran.local.toml` drops `--locked`.

## Commands

- `make check` — `ziran check --project`.
- `make test` — check, then the same entry as C (build + run), Go
  (`--target=go`, `GO111MODULE=off go build`, run), and a portable bundle run
  on the engine backend.

## Pins

- Toolchain: `ziran.lock` pins ziran.git
  `5db3d3c39425d5dfe4bfe4a84e6f6e2e5a810ad0`.
- Consumers: `ziran add https://git.waozi.xyz/ziranlang/mermaid.git`.

## Question -> file

- Render contracts and span format? -> README, `src/mermaid.zi`.
- Supported syntax and limits? -> `src/mermaid.zi`, README.
- How is it tested across backends? -> `Makefile`, `tests/mermaid_test.zi`.
- Which toolchain? -> `ziran.toml`, `ziran.lock`.
