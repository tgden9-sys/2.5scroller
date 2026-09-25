# Asset Register

## Original generated assets

### Owl hero idle v1

- File: `assets/generated/owl_hero_idle_v1.png`
- Source: OpenAI image generation, created for this project on 2026-09-25.
- Use: Current high-fidelity 2.5D player visual and approved-design candidate.
- Notes: Original project asset. Transparent cutout; future authored movement poses
  should preserve this character's identity, palette and proportions.

### Owl hero glide v1

- File: `assets/generated/owl_hero_glide_v1.png`
- Source: OpenAI image generation, created for this project on 2026-09-25 using
  the idle hero as the identity reference.
- Use: Airborne, flap, fall, glide and dive visual prototype.
- Notes: Original project asset with transparent background. It is a pose proof,
  not yet a frame-by-frame animation.

Record third-party assets that are actually introduced into the
project.

Do not record assets merely considered during research.

For each asset record:

- Asset name
- Creator
- Source
- Licence
- Date acquired
- Original filename/package
- Location in project
- Modifications
- Notes

---

## Quaternius - Stylized Nature MegaKit (Standard)

- **Creator:** Quaternius (`@Quaternius`)
- **Source:** https://quaternius.com/packs/stylizednaturemegakit.html
- **Licence:** CC0 1.0 Universal / Public Domain Dedication
- **Date acquired:** 2026-09-25
- **Original package:** `Stylized Nature MegaKit[Standard].zip`
- **Location:** `assets/third_party/quaternius_stylized_nature/`
- **Imported subset:** Common Tree 1, Twisted Tree 2, Medium Rock 1, Fern 1,
  Common Short Grass and Common Bush, with their required textures.
- **Modifications:** No source meshes or texture pixels modified. Instances are
  scaled, rotated and composed in Godot. Oversized 2048px textures are imported
  with a 1024px size limit for this browser-focused test.
- **Notes:** The included `License_Standard.txt` is retained alongside the assets.
  Only a small evaluation subset of the 68-model free package is committed to
  control repository and web-build size.
