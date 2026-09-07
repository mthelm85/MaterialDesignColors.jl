```@meta
CurrentModule = MaterialDesignColors
```

# Color Engine

MaterialDesignColors is a pure-Julia port of Google's
[material-color-utilities](https://github.com/material-foundation/material-color-utilities):
the CAM16 appearance model, the HCT color space, tonal palettes, Material
Design 3 scheme generation, and WCAG contrast helpers.

## HCT

HCT combines the hue and chroma of the CAM16 color appearance model with the
lightness (`L*`) of CIELAB. Its value is that **tone maps directly to contrast**:
two colors 40 tones apart have a predictable contrast ratio regardless of hue.
That is what lets a whole palette be generated from one color without
hand-tuning.

```jldoctest
julia> using MaterialDesignColors

julia> c = hct("#6750A4")
HCT(hue=299.0, chroma=48.2, tone=40.1)

julia> to_hex(c)
"#6750A4"
```

Not every hue/chroma pair exists at every tone — the sRGB gamut narrows toward
black and white. Requests outside it resolve to the closest in-gamut color, so
round-tripping a saturated color at an extreme tone may not return the exact
input.

## Working with the Colorant ecosystem

`HCT` is a `ColorTypes.Color{Float64,3}`, so it dispatches anywhere a `Colorant`
is accepted and converts to and from the RGB family:

```julia
using MaterialDesignColors, Colors

convert(RGB, hct("#6750A4"))     # RGB{Float64}(0.404, 0.314, 0.643)
hct(colorant"rebeccapurple")     # HCT from any Colorant
```

Every function that takes a seed or a color accepts a `Colorant` in place of a
hex string, and environments that render color swatches — Pluto, VS Code,
IJulia — display `HCT` values as swatches.

!!! note "Continuous in HCT, 8-bit in sRGB"
    An `HCT` value carries unrounded `Float64` components. Converting to any RGB
    type lands on the 8-bit sRGB grid, because the gamut solver terminates on a
    displayable integer triple. This guarantees `to_hex` and `convert` can never
    disagree.

## Tonal palettes

A [`TonalPalette`](@ref) is one hue and chroma sampled across the tone range:

```julia
p = tonal_palette("#6750A4")
tone_at(p, 40)           # HCT at tone 40 — primary in a light scheme
to_hex(tone_at(p, 80))   # "#CFBCFF" — primary in a dark scheme
p[90]                    # indexing is an alias for tone_at
```

A palette returns `HCT` values, carrying its hue and chroma at exactly the tone
you asked for; gamut mapping happens when you convert with `to_hex` or
`convert(RGB, …)`. Tones are cached as requested, and [`precompute!`](@ref)
fills the standard MD3 tone stops in one pass.

## Schemes

[`color_scheme`](@ref) generates the 34 MD3 roles from a seed, as colors:

```julia
light = color_scheme("#6750A4")
dark  = color_scheme("#6750A4"; dark = true)

light[:primary]              # RGB{Float64}
light[:on_primary_container]
```

[`color_scheme_pair`](@ref) returns both at once. When you need CSS strings
rather than colors, [`hex_scheme`](@ref) and [`hex_scheme_pair`](@ref) return
the same roles formatted as `#RRGGBB`.

Roles are derived by fixed rules: secondary shares the seed hue at chroma 16,
tertiary rotates 60° at chroma 24, neutrals hold the seed hue at very low
chroma, and error is a fixed red. Each role then sits at the tone the MD3 spec
assigns it for that mode.

## Contrast

```julia
contrast_ratio("#FFFFFF", "#6750A4")   # 6.44
meets_aa("#FFFFFF", "#6750A4")         # true
meets_aaa("#FFFFFF", "#6750A4")        # false
```

[`contrast_ratio`](@ref) also accepts two tones directly, which is cheaper when
working in HCT. To find a tone meeting a target ratio against a known one, use
[`lighter_tone`](@ref) and [`darker_tone`](@ref):

```julia
lighter_tone(40.0, 4.5)   # lightest tone with 4.5:1 against tone 40
```

Both return `NaN` when the ratio is unreachable, so check before using the
result:

```julia
t = lighter_tone(60.0, 7.0)
isnan(t) && error("no tone meets that contrast")
```
