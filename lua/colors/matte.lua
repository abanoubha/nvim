-- File: colors/matte.lua
-- Neovim Colorscheme: Matte
-- Version: 1.0.1
-- Description: A dark, high-contrast Neovim colorscheme with matte olive greens,
--              earthy browns, and warm orange accents for enhanced readability
--              during coding. Supports Tree-sitter, LSP, and common plugins.
-- Compatible with Neovim v0.5.0 and above (including v0.11.2).

local M = {}

-- Define the color palette
-- These hex values are chosen to provide a matte appearance and high contrast
-- against the dark background.
local palette = {
	-- Backgrounds
	bg_dark = "#1A1A1A", -- Very dark, almost black, for the main editor background. Provides the core "matte" feel.
	bg_medium = "#252525", -- Slightly lighter background for UI elements like borders, popups, and status lines.
	bg_light = "#333333", -- Used for very subtle distinctions, e.g., current line number background or subtle dividers.

	-- Foregrounds (text colors)
	fg_light = "#F0F0F0", -- Very light off-white for primary text, ensuring high contrast against dark backgrounds.
	fg_medium = "#D0D0D0", -- Slightly less bright for less important text or secondary UI elements.

	-- Earthy Tones / Browns
	brown_dark = "#5C4033", -- Dark muted brown, good for less prominent elements.
	brown_medium = "#8B6F4F", -- Medium earthy brown, versatile for various syntax.
	brown_light = "#B88E6D", -- Lighter, warmer brown for emphasis on certain constants or types.

	-- Olive Greens
	olive_dark = "#4F5D3D", -- Dark muted olive, subtle but distinct.
	olive_medium = "#7B8C6C", -- Classic olive green, ideal for identifiers and general variables.
	olive_light = "#A9B49C", -- Lighter, slightly desaturated olive for types or definitions.

	-- Warm Orange Accents (High Contrast)
	orange_vibrant = "#FFA500", -- Pure, vibrant orange. Used sparingly for keywords and crucial highlight groups to ensure maximum impact and readability.
	orange_muted = "#C28B00", -- A more subdued, slightly darker orange. For operators or less critical accentuation.
	orange_light = "#FFD700", -- Gold-like color, can be used for numbers or certain constants, adding warmth.

	-- Other important accent colors
	red_error = "#DC143C", -- Crimson red for errors, warnings, and deletions – designed for immediate attention.
	purple_muted = "#8A2BE2", -- Blue Violet, for preprocessor directives or special constants.
	cyan_muted = "#008B8B", -- Dark Cyan, excellent for strings due to its distinct hue.
	blue_muted = "#4682B4", -- Steel Blue, good for function names or specific types.
	comment_color = "#6A737D", -- Muted gray for comments, providing readability without distracting from code.

	-- UI state colors
	selection_bg = "#3A4045", -- Darker background for visual selection, clearly visible.
	line_nr_fg = "#6A737D", -- Line number foreground, same as comments for consistency.
	line_nr_bg = "NONE", -- No background for line numbers, allowing background color to show.
	cursor_line_bg = "#2A2A2A", -- Slightly lighter background for the current line to provide subtle focus.
	match_highlight = "#4F5D3D", -- Background for search matches, using a subtle olive.

	-- Diagnostic signs (LSP)
	error_sign = "#DC143C", -- Red for errors
	warning_sign = "#FFD700", -- Gold for warnings
	info_sign = "#4682B4", -- Blue for information
	hint_sign = "#8B6F4F", -- Brown for hints
}

-- Helper function to set highlight groups
-- `group`: The name of the highlight group (e.g., "Normal", "Comment", "@keyword")
-- `fg`: Foreground color (hex string or nil for default/none)
-- `bg`: Background color (hex string or nil for default/none)
-- `opts`: An optional table for styles like `{bold = true, italic = true, underline = true, reverse = true, undercurl = true}`
local function highlight(group, fg, bg, opts)
	local hl = { fg = fg, bg = bg }
	if opts then
		for k, v in pairs(opts) do
			hl[k] = v
		end
	end
	vim.api.nvim_set_hl(0, group, hl)
end

function M.setup()
	-- Clear any existing highlight definitions. This is crucial for themes to apply cleanly.
	vim.cmd("hi clear")
	-- Reset syntax if it exists to ensure a fresh application of colors.
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	-- Enable true colors (24-bit RGB) in the terminal, essential for precise color rendering.
	vim.o.termguicolors = true
	-- Set the name of the colorscheme, visible with `:colorscheme` and `:echo &colorscheme`.
	vim.g.colors_name = "matte"

	-- Core UI Highlights
	highlight("Normal", palette.fg_light, palette.bg_dark)
	highlight("NormalNC", palette.fg_light, palette.bg_dark) -- Normal colors for non-current windows.
	highlight("NormalFloat", palette.fg_light, palette.bg_medium) -- Colors for floating windows (e.g., LSP popups).
	highlight("FloatBorder", palette.brown_medium, palette.bg_medium) -- Borders of floating windows.

	highlight("Folded", palette.comment_color, palette.bg_medium, { italic = true }) -- Folded text display.
	highlight("SignColumn", palette.fg_light, palette.bg_dark) -- Column where signs (e.g., diagnostics, GitGutter) are displayed.
	highlight("VertSplit", palette.brown_dark, palette.bg_dark) -- Vertical separator between windows.
	highlight("LineNr", palette.line_nr_fg, palette.line_nr_bg) -- Line numbers.
	highlight("CursorLineNr", palette.brown_medium, palette.cursor_line_bg, { bold = true }) -- Line number of the current line.
	highlight("CursorLine", nil, palette.cursor_line_bg) -- The line where the cursor is.
	highlight("MatchParen", palette.orange_light, palette.bg_medium, { bold = true }) -- Matching parentheses/brackets highlighting.

	-- Visual selection and search
	highlight("Visual", nil, palette.selection_bg, { reverse = true }) -- Highlight for visually selected text.
	highlight("IncSearch", palette.bg_dark, palette.orange_light) -- Highlight for incremental search matches.
	highlight("Search", palette.bg_dark, palette.orange_muted) -- Highlight for the last search pattern matches.

	-- Status Line (bottom bar)
	highlight("StatusLine", palette.fg_light, palette.bg_medium, { bold = true }) -- Status line of the current window.
	highlight("StatusLineNC", palette.comment_color, palette.bg_medium) -- Status line of non-current windows.

	-- Command Line / Prompt / Completion Menu
	highlight("Pmenu", palette.fg_light, palette.bg_medium) -- Popup menu (e.g., completion suggestions).
	highlight("PmenuSel", palette.bg_dark, palette.orange_muted) -- Selected item in the popup menu.
	highlight("PmenuThumb", palette.fg_light, palette.brown_dark) -- Thumb of the scrollbar in the popup menu.
	highlight("PmenuSbar", palette.fg_light, palette.bg_medium) -- Scrollbar of the popup menu.
	highlight("ModeMsg", palette.orange_vibrant, nil, { bold = true }) -- Mode message (e.g., "-- INSERT --").
	highlight("CmdLine", palette.fg_light, palette.bg_dark) -- Command line prompt.

	-- LSP Diagnostics Highlights
	highlight("DiagnosticError", palette.red_error, nil, { bold = true })
	highlight("DiagnosticWarn", palette.orange_muted, nil, { bold = true })
	highlight("DiagnosticInfo", palette.blue_muted, nil, { bold = true })
	highlight("DiagnosticHint", palette.brown_medium, nil, { bold = true })

	-- Diagnostic underlines (squiggly lines)
	highlight("DiagnosticUnderlineError", nil, nil, { undercurl = true })
	highlight("DiagnosticUnderlineWarn", nil, nil, { undercurl = true })
	highlight("DiagnosticUnderlineInfo", nil, nil, { undercurl = true })
	highlight("DiagnosticUnderlineHint", nil, nil, { undercurl = true })

	-- Signs in the sign column for diagnostics
	highlight("LspDiagnosticsSignError", palette.error_sign, nil, { bold = true })
	highlight("LspDiagnosticsSignWarning", palette.warning_sign, nil, { bold = true })
	highlight("LspDiagnosticsSignInformation", palette.info_sign, nil, { bold = true })
	highlight("LspDiagnosticsSignHint", palette.hint_sign, nil, { bold = true })

	-- LSP references and code lens
	highlight("LspReferenceText", palette.orange_light, palette.bg_medium) -- Highlighted text for references
	highlight("LspReferenceRead", palette.orange_light, palette.bg_medium) -- Highlighted text for read references
	highlight("LspReferenceWrite", palette.orange_vibrant, palette.bg_medium, { bold = true }) -- Highlighted text for write references
	highlight("LspCodeLens", palette.comment_color, nil, { italic = true }) -- Inlay hints/code lenses from LSP.

	-- General Syntax Highlighting (for Vim's built-in syntax parser and fallbacks)
	highlight("Comment", palette.comment_color, nil, { italic = true })
	highlight("Constant", palette.brown_light, nil) -- For various constants like numbers, booleans.
	highlight("String", palette.cyan_muted, nil) -- String literals.
	highlight("Character", palette.cyan_muted, nil) -- Character literals.
	highlight("Number", palette.brown_light, nil) -- Numeric literals.
	highlight("Boolean", palette.brown_light, nil) -- Boolean literals (true, false).
	highlight("Float", palette.brown_light, nil) -- Floating-point numbers.

	highlight("Identifier", palette.olive_medium, nil) -- General identifiers (variable names, function calls).
	highlight("Function", palette.blue_muted, nil) -- Function definitions.
	highlight("Statement", palette.orange_vibrant, nil, { bold = true }) -- Control flow statements (if, for, while, return).
	highlight("Conditional", palette.orange_vibrant, nil, { bold = true }) -- Conditional statements.
	highlight("Repeat", palette.orange_vibrant, nil, { bold = true }) -- Loop statements.
	highlight("Operator", palette.orange_muted, nil) -- Operators (+, -, =, ==, etc.).
	highlight("Keyword", palette.orange_vibrant, nil, { bold = true }) -- Language keywords (e.g., `const`, `var`, `function`).

	highlight("PreProc", palette.purple_muted, nil) -- Preprocessor directives (#include, #define).
	highlight("Type", palette.olive_light, nil, { bold = true }) -- Data types (int, string, struct names).
	highlight("StorageClass", palette.olive_light, nil, { bold = true }) -- Storage class specifiers (static, public, private).
	highlight("Structure", palette.olive_light, nil) -- Structure definitions.

	highlight("Special", palette.red_error, nil) -- Special characters, escape sequences.

	highlight("Underlined", palette.fg_light, nil, { underline = true }) -- Underlined text.
	highlight("Error", palette.red_error, palette.bg_medium) -- General error highlighting.
	highlight("Todo", palette.orange_light, palette.bg_medium, { bold = true }) -- TODO/FIXME comments.

	-- Tree-sitter Highlights (these override or link to Vim's default groups)
	-- Tree-sitter provides more granular and accurate syntax highlighting.
	highlight("@comment", palette.comment_color, nil, { italic = true })
	highlight("@constant", palette.brown_light, nil)
	highlight("@constant.builtin", palette.orange_muted, nil, { bold = true }) -- Built-in constants (e.g., `true`, `false`, `nil`).
	highlight("@constant.macro", palette.purple_muted, nil, { bold = true }) -- Macros (e.g., C preprocessor macros).

	highlight("@string", palette.cyan_muted, nil)
	highlight("@character", palette.cyan_muted, nil)
	highlight("@boolean", palette.brown_light, nil)
	highlight("@number", palette.brown_light, nil)
	highlight("@float", palette.brown_light, nil)

	highlight("@variable", palette.olive_medium, nil) -- General variables.
	highlight("@variable.builtin", palette.blue_muted, nil) -- Built-in variables (e.g., `self` in Python, `this` in JS).
	highlight("@property", palette.olive_medium, nil) -- Object properties or fields.

	highlight("@function", palette.blue_muted, nil)
	highlight("@function.builtin", palette.blue_muted, nil, { bold = true }) -- Built-in functions.
	highlight("@function.call", palette.blue_muted, nil) -- Function calls.

	highlight("@method", palette.blue_muted, nil) -- Method definitions.
	highlight("@method.call", palette.blue_muted, nil) -- Method calls.

	highlight("@parameter", palette.olive_light, nil, { italic = true }) -- Function or method parameters.

	highlight("@keyword", palette.orange_vibrant, nil, { bold = true })
	highlight("@keyword.function", palette.orange_vibrant, nil, { bold = true }) -- Keywords for function definition (e.g., `def`, `fn`).
	highlight("@keyword.operator", palette.orange_muted, nil) -- Keywords that act as operators (e.g., `and`, `or` in Python).
	highlight("@operator", palette.orange_muted, nil) -- All other operators.

	highlight("@type", palette.olive_light, nil, { bold = true })
	highlight("@type.builtin", palette.olive_light, nil, { bold = true }) -- Built-in types (e.g., `int`, `string`).
	highlight("@type.definition", palette.olive_light, nil, { bold = true }) -- Type definitions (e.g., `struct`, `class`, `enum`).

	highlight("@field", palette.brown_medium, nil) -- Fields of structs/objects.
	highlight("@label", palette.orange_muted, nil) -- For `goto` labels or similar constructs.

	highlight("@tag", palette.brown_light, nil, { bold = true }) -- HTML/XML tags.
	highlight("@attribute", palette.orange_muted, nil) -- HTML/XML attributes.
	highlight("@string.regexp", palette.orange_muted, nil) -- Regular expressions.
	highlight("@string.escape", palette.red_error, nil) -- Escape characters within strings.

	highlight("@punctuation.delimiter", palette.fg_medium, nil) -- General delimiters (commas, semicolons).
	highlight("@punctuation.bracket", palette.fg_medium, nil) -- Brackets (parentheses, square brackets, curly braces).
	highlight("@punctuation.special", palette.orange_muted, nil) -- Special punctuation.

	-- Markup (e.g., Markdown files)
	highlight("@markup.heading", palette.orange_vibrant, nil, { bold = true }) -- Markdown headings.
	highlight("@markup.italic", palette.fg_light, nil, { italic = true }) -- Italic text.
	highlight("@markup.bold", palette.fg_light, nil, { bold = true }) -- Bold text.
	highlight("@markup.link", palette.blue_muted, nil, { underline = true }) -- Links.
	highlight("@markup.raw", palette.comment_color, nil) -- Raw code blocks.

	-- Telescope.nvim specific highlights
	highlight("TelescopeBorder", palette.brown_medium, palette.bg_medium)
	highlight("TelescopeNormal", palette.fg_light, palette.bg_medium)
	highlight("TelescopePromptNormal", palette.fg_light, palette.bg_dark)
	highlight("TelescopePromptBorder", palette.orange_vibrant, palette.bg_dark)
	highlight("TelescopePromptPrefix", palette.orange_vibrant, palette.bg_dark, { bold = true })
	highlight("TelescopePromptCounter", palette.olive_medium, palette.bg_dark)
	highlight("TelescopeResultsNormal", palette.fg_light, palette.bg_medium)
	highlight("TelescopeResultsBorder", palette.brown_medium, palette.bg_medium)
	highlight("TelescopeResultsFile", palette.olive_medium, nil) -- Files listed in results.
	highlight("TelescopeResultsLine", palette.fg_light, nil) -- Content lines in preview.
	highlight("TelescopeMatching", palette.orange_light, nil, { bold = true }) -- Highlighted matches in results.
	highlight("TelescopeSelection", nil, palette.selection_bg, { bold = true }) -- Selected item in Telescope list.
	highlight("TelescopePreviewNormal", palette.fg_light, palette.bg_dark)
	highlight("TelescopePreviewBorder", palette.brown_medium, palette.bg_dark)
	highlight("TelescopePreviewTitle", palette.orange_vibrant, palette.bg_dark, { bold = true })
	highlight("TelescopePreviewLine", palette.fg_light, nil)
	highlight("TelescopePreviewMatch", palette.orange_light, palette.bg_medium, { bold = true })

	-- Other common plugin highlights (examples for NvimTree, GitSigns, BufferLine, LSP Saga)
	-- NvimTree (file explorer)
	highlight("NvimTreeRootFolder", palette.orange_light, nil, { bold = true })
	highlight("NvimTreeFolderIcon", palette.brown_medium, nil)
	highlight("NvimTreeFileIcon", palette.fg_medium, nil)
	highlight("NvimTreeSpecialFile", palette.orange_muted, nil, { italic = true })
	highlight("NvimTreeIndentMarker", palette.comment_color, nil)

	-- GitSigns (Git integration)
	highlight("GitSignsAdd", palette.olive_medium, nil) -- Added lines.
	highlight("GitSignsChange", palette.blue_muted, nil) -- Changed lines.
	highlight("GitSignsDelete", palette.red_error, nil) -- Deleted lines.

	-- BufferLine / Tabline (for showing open buffers/tabs)
	highlight("BufferLineFill", palette.bg_dark, palette.bg_dark)
	highlight("BufferLineBuffer", palette.fg_medium, palette.bg_medium)
	highlight("BufferLineBufferSelected", palette.orange_vibrant, palette.bg_dark, { bold = true }) -- Selected buffer.
	highlight("BufferLineBufferInactive", palette.comment_color, palette.bg_medium) -- Inactive buffer.
	highlight("BufferLineTab", palette.fg_medium, palette.bg_medium) -- General tab.
	highlight("BufferLineTabSelected", palette.orange_vibrant, palette.bg_dark, { bold = true }) -- Selected tab.

	-- LSP Saga / UI (if used for LSP UI)
	highlight("LspSagaBorderFg", palette.brown_medium, nil)
	highlight("LspSagaNormal", palette.fg_light, palette.bg_medium)
	highlight("LspSagaDocText", palette.fg_light, nil)
	highlight("LspSagaType", palette.olive_light, nil)
	highlight("LspSagaSignatureHelpBorder", palette.brown_medium, palette.bg_medium)
	highlight("LspSagaHoverBorder", palette.brown_medium, palette.bg_medium)

	-- Define explicit links for clarity or where Tree-sitter/plugins might not map directly
	-- These ensure consistency by linking less common groups to already defined ones.
	vim.api.nvim_command("hi link CursorColumn CursorLine") -- Cursor in column highlights with cursor line.
	vim.api.nvim_command("hi link QuickFixLine Visual") -- QuickFix list lines highlight like visual selection.
	vim.api.nvim_command("hi link Directory Function") -- Directory names in file explorers.
	vim.api.nvim_command("hi link DiffAdd GitSignsAdd") -- Diff added lines.
	vim.api.nvim_command("hi link DiffChange GitSignsChange") -- Diff changed lines.
	vim.api.nvim_command("hi link DiffDelete GitSignsDelete") -- Diff deleted lines.
	vim.api.nvim_command("hi link DiagnosticVirtualText Comment") -- Inline diagnostic virtual text.
end

return M
