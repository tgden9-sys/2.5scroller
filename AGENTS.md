# 2.5scroller - AI Development Rules

This is a long-term Godot 4.x 2.5D platform adventure being developed
with assistance from multiple AI models.

## Source of truth

The repository is the source of truth.

Do not rely on previous AI conversations being available or current.

Before making changes:

1. Read this file.
2. Read `docs/GAME_VISION.md`.
3. Read `docs/CURRENT_STATE.md`.
4. Read `docs/ARCHITECTURE.md`.
5. Inspect the existing implementation relevant to the task.

## Core development rules

- Preserve working behaviour unless the task explicitly changes it.
- Make the smallest coherent change required.
- Do not refactor unrelated code.
- Do not rename or move files unnecessarily.
- Do not replace working systems simply because another implementation
  is preferred.
- Do not introduce dependencies without approval.
- Do not silently change architectural decisions.
- Do not change project-wide settings unless required.
- Keep systems modular.
- Prefer readable, maintainable GDScript over clever code.
- Never create duplicate implementations of an existing system.

## System ownership

Player code belongs in `game/player/`.

Camera code belongs in `game/camera/`.

Environment systems belong in `game/environment/`.

Level-specific behaviour belongs in `game/levels/`.

Enemy behaviour belongs in `game/enemies/`.

Interaction systems belong in `game/interaction/`.

UI belongs in `game/ui/`.

Audio systems belong in `game/audio/`.

Visual effects belong in `game/vfx/`.

Third-party and original art assets belong under `assets/`.

## Technical target

- Godot 4.x
- 3D game
- 2.5D side-scrolling presentation
- Desktop web is the primary delivery target
- Keyboard is the primary input method
- 1920x1080 primary visual target
- Smooth 60 FPS gameplay target
- High visual quality is preferred over support for very low-end hardware

Web compatibility must be considered when choosing rendering features.

## Git rules

`main` represents the latest Tom-tested, known-good version.

Do not work directly on `main` unless explicitly instructed.

Use one branch for one feature or fix.

Examples:

- `feature/player-movement`
- `feature/glide`
- `feature/camera-follow`
- `experiment/forest-rendering`
- `fix/camera-jitter`

Do not merge into `main` automatically.

Do not delete unreviewed work.

Do not rewrite Git history.

## Testing

After making changes:

1. Run/test the affected functionality where possible.
2. Check for errors.
3. Check for obvious regressions.
4. State clearly anything that could not be tested.

A feature is not considered accepted merely because it runs.
Gameplay feel and visual quality require Tom's approval.

## Documentation

Update `docs/CURRENT_STATE.md` when functionality materially changes.

Record significant architectural or technical decisions in
`docs/DECISIONS.md`.

Add third-party assets actually used by the project to
`docs/ASSET_REGISTER.md`.

Do not clutter documentation with trivial implementation details.

## AI task boundaries

AI contributors should receive a defined task.

Do not expand a task into unrelated systems without approval.

If another system must change to complete the task, explain why before
making a substantial architectural change.

## Handoff

At the end of a development task provide:

CHANGED
- Files and systems changed.

TESTED
- What was actually tested.

NOT TESTED
- Anything that could not be verified.

NOTES
- Important information for the next developer/model.

NEXT
- Recommended next step without implementing unrelated work.
