# Visual Target

## Purpose

This document defines the visual bar for the first forest hero shot. It prevents
technical blockouts or decorated primitives from being mistaken for accepted art.

Primary inspiration:

https://chatgpt.com/s/m_6ab6620d658c8191b988b4b973689aed

The inspiration establishes mood and composition. The game must use original
assets and an original layout rather than copying the image literally.

## Hero Shot

The first approved environment will be one 16:9 gameplay-camera composition near
the start of the level. It must prove the art direction before the style is
expanded across the course.

Required composition:

- A clear left-to-right side-scrolling route.
- A large rooted tree or trunk framing one side of the image.
- A natural log, root or rock formation forming the playable surface.
- Water and a waterfall acting as a middle-distance focal point.
- Distinct foreground, gameplay, midground and background layers.
- A brighter atmospheric opening behind the owl to protect its silhouette.

## Required Quality

- No visible box platforms or thin green caps.
- No floating trees, rocks or foliage.
- Trees must have visible roots or be convincingly occluded by terrain.
- Traversable surfaces must have irregular, natural silhouettes.
- Moss, soil, roots, stones and plants must blend asset contact points.
- Foliage must not reveal square cards at normal gameplay distance.
- Warm key lighting and cooler distance lighting must guide the eye.
- Water, wet stone and mist must support the waterfall focal point.
- The owl and landing surfaces must remain immediately readable.

## Technical Approach

Use a hybrid 2.5D scene:

- Authored 3D foreground geometry for playable logs, roots and rock ledges.
- Hidden simple collision shapes preserving reliable movement.
- Layered scenic geometry or rendered imagery for distant forest depth.
- Controlled parallax and lighting designed for the gameplay camera.
- Compatibility-renderer materials and effects suitable for desktop web.

Generic low-poly packs may support distant scenery, but they are not automatically
acceptable for foreground hero assets.

## Approval Gate

Do not propagate the visual style to the full course until the opening shot:

1. Looks deliberately composed in a still frame.
2. Meets every required-quality item above.
3. Runs successfully in the browser build.
4. Receives Tom's explicit visual approval.

