# Current State

## Milestone

M3 - Forest Art Test (in development on `feature/forest-blockout`)

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
- Full browser course completed successfully by Tom, including the completion
  state. Movement feel and the M1/M2 baseline were approved.
- M1/M2 pull request merged to `main` as the known-good baseline.
- First procedural forest mood blockout added with layered trees, moss dressing,
  rocks, foliage movement, water, waterfall and mist forms.
- Foreground tree spacing and canopy height adjusted after the first readability
  playtest so the player and landing surfaces remain visible.
- Greybox platforms now have procedural natural silhouettes: uneven earth and
  stone banks for ground, plus mossy fallen-log shells for stepping platforms.

## In Development

- Forest composition, palette, scale and readability require hands-on playtesting.
- The environment is deliberately made from lightweight procedural primitives;
  selected production-quality nature assets are still to be evaluated.

## Known Issues

- Placeholder animation uses simple procedural transforms and is not a replacement
  for the future rigged owl or authored animation set.
- A representative performance baseline must wait for the forest art test; the
  current greybox scene is too light to provide meaningful GPU measurements.

## Last Known-Good State

`main` contains the merged, Tom-tested M1/M2 player playground and browser proof.
M3 work is isolated on `feature/forest-blockout`.

## Next Intended Task

Playtest the first forest mood blockout in desktop and browser builds. Refine the
composition before selecting any third-party nature assets.
