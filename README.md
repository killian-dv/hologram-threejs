# Hologram — Three.js Journey

Quick recap of the **Hologram** lesson from [Three.js Journey](https://threejs-journey.com/) by Bruno Simon.

## What this project covers

This project builds a **holographic-looking material** with a **full custom shader pair** (`ShaderMaterial`). The look comes from **Fresnel-based rim lighting**, **animated vertical stripes**, and a **subtle vertex glitch** driven by time and pseudo-random noise—not from textures. The fragment stage combines those terms so surfaces read as **sci-fi glass or projected UI**, with **additive blending** so layers stack into a soft glow.

- **`ShaderMaterial`** with external **`.glsl`** files (via **Vite** + **`vite-plugin-glsl`**) keeps vertex and fragment logic readable and editable in separate files.
- The **vertex shader** offsets positions in **X/Z** using a **hash-based `random2D`** and a **time-modulated strength** tied to height (`modelPosition.y`), so the mesh **jitters** in a controlled, “signal noise” way.
- The **fragment shader** animates **stripes** along the model with **`mod`** on world-space **Y**, sharpens them with **`pow`**, and multiplies by **Fresnel** (view vs normal) plus a **falloff** so only the edges and bands stay bright.
- **Transparency** uses **`transparent: true`**, **`depthWrite: false`**, and **`AdditiveBlending`**, which fits emissive/hologram aesthetics (bright stacking, no need for a smoke-style alpha blend).
- The scene uses **three primitives** (torus knot, sphere) and **`suzanne.glb`** from **`GLTFLoader`**; **`OrbitControls`**, **`Clock`**, and **`lil-gui`** drive inspection, **`uTime`**, and **tint color**.

## What I built

- **`ShaderMaterial`** with uniforms **`uTime`** and **`uColor`**, **`DoubleSide`**, **`depthWrite: false`**, **`AdditiveBlending`**, and GLSL from **`vertex.glsl`** / **`fragment.glsl`**.
- **`random2D`** in **`includes/random2D.glsl`**, included from the vertex shader with **`#include`** (same modular pattern as other Journey demos).
- **Vertex glitch**: combine several **`sin`** terms on **`glitchTime`**, **`smoothstep`** the strength, then displace **X/Z** by **`random2D`** so the wobble stays **bounded** and **time-coherent**.
- **Fragment**: **stripes** from **`mod((vPosition.y - uTime * 0.02) * 20.0, 1.0)`**, **Fresnel** from view direction vs normal, **`falloff`** with **`smoothstep`** on Fresnel, then pack **alpha** into **`gl_FragColor.a`** for the hologram intensity.
- **Double-sided normals**: use **`gl_FrontFacing`** to flip the normal when rendering the back face so Fresnel stays consistent when **`DoubleSide`** is on.
- **Output**: Three’s **`tonemapping_fragment`** and **`colorspace_fragment`** includes so the final color matches the renderer’s tone mapping and color space.
- **Debug**: **`lil-gui`** for **clear color** and **hologram tint** (`uColor`).

## What I learned

### 1) Holograms as shading, not a texture pack

- A convincing **hologram** is often **procedural**: **moving stripes** + **rim/Fresnel** + **falloff**. You steer **feel** (sci-fi, unstable signal) with math and a few uniforms, not necessarily with image maps.

### 2) Vertex stage: glitch strength from time and height

- Tie **glitch amplitude** to **`sin` combinations** of **`uTime - modelPosition.y`** so the noise **varies along the mesh** and over time.
- **`smoothstep`** on that strength avoids **harsh on/off** jitter.
- **`random2D`** on **swizzled positions + time** gives **cheap pseudo-random** offsets in **X** and **Z** without a noise texture.

### 3) Fragment stage: stripes, Fresnel, and falloff

- **Stripes**: **`mod`** on a **scrolling** world **Y** (`vPosition.y - uTime * speed`) creates repeating bands; **`pow`** makes them **thinner/brighter** in the right places.
- **Fresnel**: **`dot(viewDirection, normal)`** (with sign fixed for **back faces**) makes **edges** brighter than **center**, which reads as **thin shell** or **glass**.
- **Falloff**: **`smoothstep`** on Fresnel **suppresses** the effect where you do not want a full-screen glow.

### 4) Transparency, depth, and additive blending

- **`depthWrite: false`** is common with **transparent** effects so **sorting** is less brittle when multiple meshes overlap.
- **`AdditiveBlending`** adds **RGB** to the framebuffer—good for **light-like** holograms; it differs from **alpha-blended** “smoke card” setups that rely more on **alpha** and **non-additive** blending.

### 5) Modular GLSL with Vite

- **`#include`** (via **`vite-plugin-glsl`**) lets you **reuse** helpers like **`random2D`** across shaders without duplicating **hash** code.

## Run the project

```bash
npm install
npm run dev
```

## Credits

Part of the **Three.js Journey** course by Bruno Simon.
