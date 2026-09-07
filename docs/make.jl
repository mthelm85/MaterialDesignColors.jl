using MaterialDesignColors
using Documenter
using MaterialDocs

DocMeta.setdocmeta!(MaterialDesignColors, :DocTestSetup, :(using MaterialDesignColors); recursive = true)

# Add titles of sections and overrides page titles
const titles = Dict(
    # "10-tutorials" => "Tutorials", # example folder title
    "91-developer.md" => "Developer docs",
)

function recursively_list_pages(folder; path_prefix="")
    pages_list = Any[]
    for file in readdir(folder)
        if file == "index.md"
            # We add index.md separately to make sure it is the first in the list
            continue
        end
        # this is the relative path according to our prefix, not @__DIR__, i.e., relative to `src`
        relpath = joinpath(path_prefix, file)
        # full path of the file
        fullpath = joinpath(folder, relpath)

        if isdir(fullpath)
            # If this is a folder, enter the recursion case
            subsection = recursively_list_pages(fullpath; path_prefix=relpath)

            # Ignore empty folders
            if length(subsection) > 0
                title = if haskey(titles, relpath)
                titles[relpath]
                else
                @error "Bad usage: '$relpath' does not have a title set. Fix in 'docs/make.jl'"
                relpath
                end
                push!(pages_list, title => subsection)
            end

            continue
        end

        if splitext(file)[2] != ".md" # non .md files are ignored
            continue
        elseif haskey(titles, relpath) # case 'title => path'
            push!(pages_list, titles[relpath] => relpath)
        else # case 'title'
            push!(pages_list, relpath)
        end
    end

    return pages_list
end

function list_pages()
    root_dir = joinpath(@__DIR__, "src")
    pages_list = recursively_list_pages(root_dir)

    return ["index.md"; pages_list]
end

makedocs(;
    modules = [MaterialDesignColors],
    authors = "Matt Helm <mthelm85@gmail.com>",
    repo = "https://github.com/mthelm85/MaterialDesignColors.jl/blob/{commit}{path}#{line}",
    sitename = "MaterialDesignColors.jl",
    # The port's internals are documented but deliberately absent from the
    # manual — see Private = false in the reference page.
    checkdocs = :exports,
    # Documented with MaterialDocs, which is built on this package — the
    # seed below is the MD3 baseline color these docs describe.
    format = Material3(
        theme = ThemeConfig(seed = "#6750A4", name = "MaterialDesignColors"),
        dark_mode = :toggle,
    ),
    pages = list_pages(),
)

deploydocs(; repo = "github.com/mthelm85/MaterialDesignColors.jl")
