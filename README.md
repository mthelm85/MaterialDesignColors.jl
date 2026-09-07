# MaterialDesignColors.jl

**The HCT color space and the Material Design 3 color system, in pure Julia.**

[![Development documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://mthelm85.github.io/MaterialDesignColors.jl/dev)
[![Test workflow status](https://github.com/mthelm85/MaterialDesignColors.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/mthelm85/MaterialDesignColors.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Docs workflow Status](https://github.com/mthelm85/MaterialDesignColors.jl/actions/workflows/Docs.yml/badge.svg?branch=main)](https://github.com/mthelm85/MaterialDesignColors.jl/actions/workflows/Docs.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/mthelm85/MaterialDesignColors.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/mthelm85/MaterialDesignColors.jl)
[![License: Apache 2.0](https://img.shields.io/badge/license-Apache_2.0-green.svg)](LICENSE)
[![BestieTemplate](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/JuliaBesties/BestieTemplate.jl/main/docs/src/assets/badge.json)](https://github.com/JuliaBesties/BestieTemplate.jl)

A Julia port of Google's
[material-color-utilities](https://github.com/material-foundation/material-color-utilities):
the CAM16 color appearance model, the HCT color space and its gamut-mapping
solver, tonal palettes, MD3 scheme generation, and WCAG contrast helpers.

Give it one color and it gives you a complete, accessible palette.

## Why HCT

HCT pairs the hue and chroma of CAM16 with the lightness (`L*`) of CIELAB. The
useful consequence is that **tone maps directly to contrast**: two colors a
fixed distance apart in tone have a predictable contrast ratio regardless of
hue. That is what makes it possible to generate a whole palette from a single
seed and know in advance that the text on each surface will be readable.

## Installation

Not yet registered in the General registry. Add it by URL:

```julia
using Pkg
Pkg.add(url = "https://github.com/mthelm85/MaterialDesignColors.jl.git")
```

## Quick start

```julia
using MaterialDesignColors

# A full Material Design 3 scheme — 34 roles — from one seed
scheme = color_scheme("#6750A4")
scheme[:primary]                # RGB{Float64}
scheme[:on_primary_container]

# Light and dark together
light, dark = color_scheme_pair("#6750A4")

# Or as CSS hex strings
hex_scheme("#6750A4")[:surface]   # "#FDF8FD"
```

Working in HCT directly:

```julia
c = hct("#6750A4")        # HCT(hue=299.0, chroma=48.2, tone=40.1)
to_hex(c)                 # "#6750A4"

p = tonal_palette("#6750A4")
tone_at(p, 40)            # HCT at tone 40 — primary in a light scheme
to_hex(tone_at(p, 80))    # "#CFBCFF" — primary in a dark scheme
```

A palette hands back `HCT` values, not strings: the tone you asked for is
preserved exactly, and gamut mapping happens when you convert.

Checking and hitting contrast targets:

```julia
contrast_ratio("#FFFFFF", "#6750A4")   # 6.44
meets_aa("#FFFFFF", "#6750A4")         # true

# The lightest tone reaching 4.5:1 against tone 40 — NaN if unreachable
lighter_tone(40.0, 4.5)
```

## Works with the Colorant ecosystem

`HCT` is a `ColorTypes.Color{Float64,3}`, so it converts to and from the RGB
family and passes anywhere a `Colorant` is accepted:

```julia
using MaterialDesignColors, Colors

convert(RGB, hct("#6750A4"))    # RGB{Float64}(0.404, 0.314, 0.643)
hct(colorant"rebeccapurple")    # HCT from any Colorant
color_scheme(colorant"teal")    # seeds accept Colorants too
```

Environments that render color swatches — Pluto, VS Code, IJulia — display
`HCT` values as swatches rather than numbers.

> [!NOTE]
> An `HCT` value carries unrounded `Float64` components; converting to any RGB
> type lands on the 8-bit sRGB grid, because the gamut solver terminates on a
> displayable integer triple. So `to_hex` and `convert` can never disagree.

## What it does not do

Deliberately out of scope: extracting a theme from an image, the MD3 dynamic
scheme variants beyond the baseline (content, fidelity, vibrant, expressive),
and perceptual color-difference metrics — [Colors.jl](https://github.com/JuliaGraphics/Colors.jl)
already covers the last of those.

## Used by

[MaterialDocs.jl](https://github.com/mthelm85/MaterialDocs.jl), a Documenter.jl
writer that generates Material Design 3 documentation sites, uses this package
to generate every color token on a site from one seed.

> [!NOTE]
> MaterialDocs' live theme editor previously carried its own JavaScript port of
> this engine. It no longer does — the editor asks Julia for the scheme, so the
> preview cannot drift from the build. If you vendor this logic elsewhere, the
> same hazard applies.

## Licence and attribution

Apache-2.0, matching the upstream project this is derived from. See
[LICENSE](LICENSE) and [NOTICE](NOTICE).

Material Design is a trademark of Google. This project is not affiliated with
or endorsed by Google.
