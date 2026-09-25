# Decisions

Important project decisions are recorded here so that different AI
models do not repeatedly reverse previous choices.

---

## DEC-001 - Godot

Decision:
Use Godot 4.x as the game engine.

Status:
Accepted.

---

## DEC-002 - 2.5D Structure

Decision:
The game world is 3D but primary gameplay is side-scrolling 2.5D.

Status:
Accepted.

---

## DEC-003 - Web Delivery

Decision:
Desktop web browser is the primary delivery target.

Reason:
Easy distribution is desirable.

Web is a delivery mechanism and does not require targeting extremely
low-end hardware.

Status:
Accepted.

---

## DEC-004 - Resolution and Performance

Decision:
1920x1080 is the primary presentation target.

Aim for approximately 60 FPS on reasonably capable modern desktop
hardware.

Status:
Accepted.

---

## DEC-005 - Keyboard First

Decision:
Keyboard is the primary input method.

Initial controls will use A/D and/or arrow keys for movement and Space
for jumping.

Gamepad support may be added later.

Status:
Accepted.

---

## DEC-006 - Vertical Slice First

Decision:
Do not attempt to build the full game before proving a polished
vertical slice.

The first slice should establish movement, camera, visual quality,
character quality and browser viability.

Status:
Accepted.

---

## DEC-007 - Initial Wing Control Scheme

Decision:
For the M1 prototype, Space is contextual: press to jump, press once while
airborne to flap, and hold after the flap while descending to glide. S or Down
prototypes a dive.

Reason:
This keeps the complete traversal prototype playable with the initial keyboard
control set while exposing each movement state separately for evaluation.

Status:
Provisional - requires playtesting before acceptance.

---

## DEC-008 - Hard Gameplay Plane Constraint

Decision:
The M1 player is constrained to world Z = 0 after physics movement. The level
remains fully 3D and the camera uses perspective projection.

Reason:
This provides predictable side-scrolling controls while leaving room for 3D
presentation and a more sophisticated path constraint in later levels.

Status:
Provisional - appropriate for M1.
