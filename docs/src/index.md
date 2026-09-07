```@meta
CurrentModule = MaterialDesignColors
```

# MaterialDesignColors.jl

**The HCT color space and the Material Design 3 color system, in pure Julia.**

A port of Google's
[material-color-utilities](https://github.com/material-foundation/material-color-utilities):
the CAM16 color appearance model, the HCT color space and its gamut-mapping
solver, tonal palettes, MD3 scheme generation, and WCAG contrast helpers.

Give it one color and it gives you a complete, accessible palette.

```julia
using MaterialDesignColors

scheme = color_scheme("#6750A4")   # 34 MD3 roles, as Colorants
scheme[:primary]
scheme[:on_primary_container]
```

!!! tip "This site is its own demo"
    These pages are rendered by [MaterialDocs.jl](https://github.com/mthelm85/MaterialDocs.jl),
    which is built on this package. Every color you can see was generated from
    the seed `#6750A4` by the code documented here.

## Why HCT

HCT pairs the hue and chroma of CAM16 with the lightness (`L*`) of CIELAB. The
useful consequence is that **tone maps directly to contrast**: two colors a
fixed distance apart in tone have a predictable contrast ratio regardless of
hue.

That is what makes it possible to generate a whole palette from a single seed
and know in advance that the text on each surface will be readable — rather
than picking colors and checking them afterwards.

## Installation

MaterialDesignColors is not yet registered in the General registry, so add it by URL:

```julia
using Pkg
Pkg.add(url = "https://github.com/mthelm85/MaterialDesignColors.jl.git")
```

## At a glance

| | |
|---|---|
| [`hct`](@ref), [`to_hex`](@ref) | Convert to and from the HCT color space |
| [`tonal_palette`](@ref), [`tone_at`](@ref) | One hue and chroma across the tone range |
| [`color_scheme`](@ref), [`color_scheme_pair`](@ref) | All 34 MD3 roles, as Colorants |
| [`hex_scheme`](@ref), [`hex_scheme_pair`](@ref) | The same roles as CSS hex strings |
| [`contrast_ratio`](@ref), [`meets_aa`](@ref) | WCAG contrast checks |
| [`lighter_tone`](@ref), [`darker_tone`](@ref) | Find a tone meeting a target ratio |

## Works with the Colorant ecosystem

[`HCT`](@ref) is a `ColorTypes.Color{Float64,3}`, so it converts to and from the
RGB family and passes anywhere a `Colorant` is accepted — including into
Makie themes, ColorSchemes.jl, and Plots. Environments that render color
swatches show `HCT` values as swatches rather than numbers.

## Where to go next

- [Color Engine](@ref) — the full guide, with worked examples
- [Reference](@ref reference) — every exported function

## Licence

Apache-2.0, matching the upstream project this is derived from. Material Design
is a trademark of Google; this project is not affiliated with or endorsed by
Google.
