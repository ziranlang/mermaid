# Mermaid for Ziran

A standalone Ziran package for bounded Unicode terminal diagrams: flowcharts,
sequences, flat state machines, classes, and entity relationships. Rendering
preserves semantic node, edge, and text roles and returns errors for unsupported
syntax, unsafe terminal labels, or exceeded limits.

```sh
ziran add https://git.waozi.xyz/ziranlang/mermaid.git
```

```zi
Mermaid :: #import "mermaid/mermaid"

main :: () -> s32 {
    result := Mermaid.Render("flowchart TD; A --> B", 100)
    if result.status != .NONE { return 1 }
    // result.text owns its UTF-8 bytes and is released with result.
    return 0
}
```

`Render(source: string, max_width: s64) -> RenderedText` returns owned
`std/vec.Text` and an `Error`: `NONE`, `UNSUPPORTED`, `LIMIT`, or `TOO_WIDE`.
No partial text is returned on failure. Width is in terminal columns.

`RenderTextBytes(source, max_width, output: *Vec(u8)) -> Error` writes plain
UTF-8 text; `RenderBytes` writes semantic spans. Both clear a reused output
buffer first. Each semantic run has a one-byte role (`0` edge, `1` node, `2`
text), a four-byte little-endian byte length, and that many UTF-8 bytes. A
five-byte record with role `3` and length zero ends each line. The last line
also has this terminator. No ANSI escapes are generated.

`RenderGrid(source, max_width) -> RenderedGrid` exposes owned, row-major
`points: Vec(u32)` and `roles: Vec(u8)`, with `width`, `height`, and `status`.
Read cells only when status is `NONE`. Both vectors then have `width * height`
elements. Scalars are Unicode values; a zero cell continues a preceding wide
character. Roles use the same three values as the semantic format. Keep the
result alive while borrowing either vector; move or release it once. Native
consumers can construct their own strings and spans without serializing and
parsing an intermediate format.

The source is limited to 16 KiB, with at most 16 graph nodes, 24 graph edges,
40 columns per label line, and 65,536 canvas cells. Labels with many `<br>`
lines use owned overflow storage; ordinary labels stay inline. Supported
families have additional grammar limits matching the original renderer.
The implementation has no Xcoder dependency, foreign calls, or platform-specific
standard module imports. Xcoder's native Rust adapter consumes `RenderGrid`.

Run `build-queue -- make test` for C, Go, and engine tests. Local toolchain
overrides belong in the ignored `ziran.local.toml`; the committed lock pins the
published toolchain. Xcoder's adapter tests run the original Rust renderer's
suite and snapshots against this package, plus digests of generated
flowchart, Unicode, limit and long-label cases recorded from that renderer.

The original renderer and its grammar originate in OpenAI Codex (Apache-2.0).
Unicode width behavior follows the Rust reference's unicode-width 0.2.1.
