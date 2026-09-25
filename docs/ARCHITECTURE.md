# Architecture

This document records the intended high-level architecture.

It should evolve deliberately as the game develops.

## Principles

Systems should remain modular.

Levels should assemble reusable systems rather than reimplement them.

Gameplay code should not depend unnecessarily on specific levels.

Art assets should remain separate from gameplay logic where practical.

## Player

Location:

`game/player/`

The Player system owns:

- Character movement
- Jump behaviour
- Air control
- Glide behaviour
- Player movement state
- Player animation state coordination

Level-specific behaviour should not be placed in the Player controller.

## Camera

Location:

`game/camera/`

Camera behaviour is separate from Player movement.

The camera may observe Player state but should not own Player physics.

## Levels

Location:

`game/levels/`

Levels assemble:

- Player
- Camera
- Environment
- Collision
- Hazards
- Interactions
- Level-specific scripting

## Environment

Location:

`game/environment/`

Reusable environmental systems belong here.

Examples may eventually include:

- Foliage movement
- Water
- Wind
- Environmental animation
- Reusable platform/environment components

## Input

Input actions should be defined centrally through Godot's Input Map.

Initial expected actions:

- move_left
- move_right
- jump
- move_down
- interact

Exact controls may evolve through playtesting.

## Web

Browser compatibility is a first-class requirement.

Web export should be tested early and repeatedly rather than postponed
until late development.

## Performance

Performance optimisation should be evidence-led.

Do not substantially reduce visual quality based purely on theoretical
performance concerns.

Measure representative scenes first.
