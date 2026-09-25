# Current State

## Milestone

M2 - Web Proof (in development on `feature/player-playground`)

## Working

- GitHub repository created.
- Local repository connected.
- Initial multi-AI project structure created.
- Project documentation created.
- Godot 4 project created with the Compatibility renderer.
- Player Playground is the configured main scene.
- Placeholder owl player with collision and a readable gameplay silhouette.
- Constrained 2.5D horizontal movement with acceleration, deceleration and air control.
- Jump foundations: variable height, coyote time and input buffering.
- One-air-flap, hold-to-glide and down-to-dive prototypes.
- Smooth player-follow camera with horizontal look-ahead and vertical dead zone.
- Lit greybox course with ground and ascending platforms.
- On-screen controls and movement-state readout for playtesting.
- Procedural placeholder animation for idle, running, rising, falling, flap,
  glide, dive and landing states.
- Web export preset configured for a single-threaded Compatibility-renderer build.
- Godot 4.7.2 release web export generated and launched successfully through a
  local static server with no browser console errors.
- Traversal greybox course with staged jump, climb, glide and dive challenges.
- Automatic checkpoint progression and safe fall recovery across the course.

## In Development

- Movement values and camera behaviour require hands-on playtesting and tuning.
- Wing traversal behaviours are prototypes, not accepted final mechanics.

## Known Issues

- Placeholder animation uses simple procedural transforms and is not a replacement
  for the future rigged owl or authored animation set.
- Browser controls require hands-on playtesting outside the automated smoke test.
- A representative performance baseline must wait for the forest art test; the
  current greybox scene is too light to provide meaningful GPU measurements.

## Last Known-Good State

`main` remains the initial project structure. M1 work is intentionally isolated on
`feature/player-playground` pending Tom's playtest and approval.

## Next Intended Task

Open the playground in Godot 4.7.x, resolve any engine-version import issues, and
playtest movement feel. Tune the exported controller values based on feedback,
then complete an early desktop-web export and performance baseline.
