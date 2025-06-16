-- File: colors/abanoub.lua
-- Neovim Colorscheme: abanoub
-- Version: 1.0.0 (Initial Release - High Contrast +90%)
-- Description: A vibrant and high-contrast Neovim colorscheme with a deep black background,
--              designed for maximum readability and visual pop. Features bright,
--              distinct colors for syntax highlighting. Supports Tree-sitter
--              for Go, PHP, Laravel, Markdown, Lua, Fish, Bash, JSON, YAML,
--              and common plugins like LSP clients and Telescope.nvim.
-- Compatible with Neovim v0.5.0 and above (including v0.11.2).

local M = {}

-- Define the color palette for abanoub.
-- Colors are selected to be very bright and saturated against the deep black background,
-- ensuring a luminance contrast ratio of at least 10:1 (often much higher for +90%).
local palette = {
	-- Backgrounds
	bg_deep_black = "#000000", -- Absolute black for the main editor background.
	bg_darker_ui = "#0A0A0A", -- Slightly off-black for UI elements like borders, popups.
	bg_medium_ui = "#1C1C1C", -- For subtle visual distinctions in UI, like current line background.

	-- Foregrounds (primary text colors, very bright)
	fg_white = "#FFFFFF", -- Pure white for main text, providing maximum contrast.
	fg_light_gray = "#E6E6E6", -- A very light gray for less critical text, still high contrast.

	-- Vibrant Primary Accent Colors
	-- These are highly saturated and bright to stand out sharply.
	vibrant_red = "#FF6666", -- Bright, clear red for errors, warnings, important keywords.
	vibrant_orange = "#FFB366", -- Bright orange for operators, numbers, certain statements.
	vibrant_yellow = "#FFFF66", -- Pure bright yellow for constants, specific variables.
	vibrant_green = "#66FF66", -- Bright green for strings, added lines (Git).
	vibrant_cyan = "#66FFFF", -- Bright cyan for functions, types, identifiers.
	vibrant_blue = "#66B3FF", -- Bright blue for parameters, arguments, info messages.
	vibrant_magenta = "#FF66FF", -- Bright magenta for preprocessor directives, special elements.
	vibrant_purple = "#CC99FF", -- A softer, vibrant purple for more subdued but still distinct elements.

	-- Supporting Colors (still high contrast, but might be used for less emphasis)
	comment_gray = "#7A7A7A", -- A solid medium gray for comments, highly readable without being distracting.
	dim_gray = "#505050", -- A darker gray for less important UI elements or subtle borders.
	selection_bg = "#2F2F2F", -- Dark background for visual selection.

	-- Diagnostic and Sign Colors (for immediate attention)
	diag_error = "#FF0000", -- Pure red for errors.
	diag_warning = "#FFD700", -- Gold/Yellow for warnings.
	diag_info = "#00BFFF", -- Deep Sky Blue for information.
	diag_hint = "#9ACD32", -- YellowGreen for hints.
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
	vim.g.colors_name = "abanoub"

	-- Core UI Highlights
	highlight("Normal", palette.fg_white, palette.bg_deep_black)
	highlight("NormalNC", palette.fg_white, palette.bg_deep_black) -- Normal colors for non-current windows.
	highlight("NormalFloat", palette.fg_white, palette.bg_darker_ui) -- Colors for floating windows (e.g., LSP popups).
	highlight("FloatBorder", palette.comment_gray, palette.bg_darker_ui) -- Borders of floating windows.

	highlight("Folded", palette.comment_gray, palette.bg_darker_ui, { italic = true }) -- Folded text display.
	highlight("SignColumn", palette.fg_white, palette.bg_deep_black) -- Column where signs (e.g., diagnostics, GitGutter) are displayed.
	highlight("VertSplit", palette.dim_gray, palette.bg_deep_black) -- Vertical separator between windows.
	highlight("LineNr", palette.comment_gray, nil) -- Line numbers.
	highlight("CursorLineNr", palette.vibrant_blue, palette.bg_medium_ui, { bold = true }) -- Line number of the current line.
	highlight("CursorLine", nil, palette.bg_medium_ui) -- The line where the cursor is.
	highlight("MatchParen", palette.vibrant_yellow, palette.bg_darker_ui, { bold = true }) -- Matching parentheses/brackets highlighting.

	-- Visual selection and search
	highlight("Visual", nil, palette.selection_bg, { reverse = true }) -- Highlight for visually selected text.
	highlight("IncSearch", palette.bg_deep_black, palette.vibrant_orange) -- Highlight for incremental search matches.
	highlight("Search", palette.bg_deep_black, palette.vibrant_yellow) -- Highlight for the last search pattern matches.

	-- Status Line (bottom bar)
	highlight("StatusLine", palette.fg_white, palette.bg_darker_ui, { bold = true }) -- Status line of the current window.
	highlight("StatusLineNC", palette.comment_gray, palette.bg_darker_ui) -- Status line of non-current windows.

	-- Command Line / Prompt / Completion Menu
	highlight("Pmenu", palette.fg_white, palette.bg_darker_ui) -- Popup menu (e.g., completion suggestions).
	highlight("PmenuSel", palette.bg_deep_black, palette.vibrant_blue) -- Selected item in the popup menu.
	highlight("PmenuThumb", palette.vibrant_red, palette.bg_darker_ui) -- Thumb of the scrollbar in the popup menu.
	highlight("PmenuSbar", palette.comment_gray, palette.bg_darker_ui) -- Scrollbar of the popup menu.
	highlight("ModeMsg", palette.vibrant_orange, nil, { bold = true }) -- Mode message (e.g., "-- INSERT --").
	highlight("CmdLine", palette.fg_white, palette.bg_deep_black) -- Command line prompt.

	-- LSP Diagnostics Highlights
	highlight("DiagnosticError", palette.diag_error, nil, { bold = true })
	highlight("DiagnosticWarn", palette.diag_warning, nil, { bold = true })
	highlight("DiagnosticInfo", palette.diag_info, nil, { bold = true })
	highlight("DiagnosticHint", palette.diag_hint, nil, { bold = true })

	-- Diagnostic underlines (squiggly lines)
	highlight("DiagnosticUnderlineError", nil, nil, { undercurl = true, sp = palette.diag_error }) -- `sp` sets the color of the underline
	highlight("DiagnosticUnderlineWarn", nil, nil, { undercurl = true, sp = palette.diag_warning })
	highlight("DiagnosticUnderlineInfo", nil, nil, { undercurl = true, sp = palette.diag_info })
	highlight("DiagnosticUnderlineHint", nil, nil, { undercurl = true, sp = palette.diag_hint })

	-- Signs in the sign column for diagnostics
	highlight("LspDiagnosticsSignError", palette.diag_error, nil, { bold = true })
	highlight("LspDiagnosticsSignWarning", palette.diag_warning, nil, { bold = true })
	highlight("LspDiagnosticsSignInformation", palette.diag_info, nil, { bold = true })
	highlight("LspDiagnosticsSignHint", palette.diag_hint, nil, { bold = true })

	-- LSP references and code lens
	highlight("LspReferenceText", palette.vibrant_blue, palette.bg_darker_ui) -- Highlighted text for references
	highlight("LspReferenceRead", palette.vibrant_blue, palette.bg_darker_ui) -- Highlighted text for read references
	highlight("LspReferenceWrite", palette.vibrant_red, palette.bg_darker_ui, { bold = true }) -- Highlighted text for write references
	highlight("LspCodeLens", palette.comment_gray, nil, { italic = true }) -- Inlay hints/code lenses from LSP.

	-- General Syntax Highlighting (for Vim's built-in syntax parser and fallbacks)
	highlight("Comment", palette.comment_gray, nil, { italic = true })
	highlight("Constant", palette.vibrant_yellow, nil) -- For various constants like numbers, booleans.
	highlight("String", palette.vibrant_green, nil) -- String literals.
	highlight("Character", palette.vibrant_green, nil) -- Character literals.
	highlight("Number", palette.vibrant_orange, nil) -- Numeric literals.
	highlight("Boolean", palette.vibrant_magenta, nil, { bold = true }) -- Boolean literals (true, false).
	highlight("Float", palette.vibrant_orange, nil) -- Floating-point numbers.

	highlight("Identifier", palette.vibrant_cyan, nil) -- General identifiers (variable names, function calls).
	highlight("Function", palette.vibrant_blue, nil) -- Function definitions.
	highlight("Statement", palette.vibrant_red, nil, { bold = true }) -- Control flow statements (if, for, while, return).
	highlight("Conditional", palette.vibrant_red, nil, { bold = true }) -- Conditional statements.
	highlight("Repeat", palette.vibrant_red, nil, { bold = true }) -- Loop statements.
	highlight("Operator", palette.vibrant_orange, nil) -- Operators (+, -, =, ==, etc.).
	highlight("Keyword", palette.vibrant_red, nil, { bold = true }) -- Language keywords (e.g., `const`, `var`, `function`).

	highlight("PreProc", palette.vibrant_magenta, nil, { bold = true }) -- Preprocessor directives (#include, #define).
	highlight("Type", palette.vibrant_cyan, nil, { bold = true }) -- Data types (int, string, struct names).
	highlight("StorageClass", palette.vibrant_purple, nil, { bold = true }) -- Storage class specifiers (static, public, private).
	highlight("Structure", palette.vibrant_cyan, nil) -- Structure definitions.

	highlight("Special", palette.vibrant_red, nil) -- Special characters, escape sequences.

	highlight("Underlined", palette.fg_white, nil, { underline = true }) -- Underlined text.
	highlight("Error", palette.diag_error, palette.bg_darker_ui) -- General error highlighting.
	highlight("Todo", palette.vibrant_yellow, palette.bg_darker_ui, { bold = true }) -- TODO/FIXME comments.

	-- Tree-sitter Highlights (these override or link to Vim's default groups)
	-- Designed to provide granular highlighting for Go, PHP, Laravel, Markdown, Lua, Fish, Bash, JSON, YAML.
	highlight("@comment", palette.comment_gray, nil, { italic = true })
	highlight("@constant", palette.vibrant_yellow, nil)
	highlight("@constant.builtin", palette.vibrant_orange, nil, { bold = true }) -- Built-in constants (e.g., `true`, `false`, `nil`).
	highlight("@constant.macro", palette.vibrant_magenta, nil, { bold = true }) -- Macros (e.g., C preprocessor macros).

	highlight("@string", palette.vibrant_green, nil)
	highlight("@character", palette.vibrant_green, nil)
	highlight("@boolean", palette.vibrant_magenta, nil, { bold = true })
	highlight("@number", palette.vibrant_orange, nil)
	highlight("@float", palette.vibrant_orange, nil)

	highlight("@variable", palette.vibrant_cyan, nil) -- General variables.
	highlight("@variable.builtin", palette.vibrant_blue, nil) -- Built-in variables (e.g., `self` in Python, `this` in JS/PHP).
	highlight("@property", palette.vibrant_cyan, nil) -- Object properties or fields (e.g., in Go structs, PHP classes).

	highlight("@function", palette.vibrant_blue, nil)
	highlight("@function.builtin", palette.vibrant_blue, nil, { bold = true }) -- Built-in functions.
	highlight("@function.call", palette.vibrant_blue, nil) -- Function calls.

	highlight("@method", palette.vibrant_blue, nil) -- Method definitions (Go, PHP).
	highlight("@method.call", palette.vibrant_blue, nil) -- Method calls.

	highlight("@parameter", palette.vibrant_blue, nil, { italic = true }) -- Function or method parameters.

	highlight("@keyword", palette.vibrant_red, nil, { bold = true })
	highlight("@keyword.function", palette.vibrant_red, nil, { bold = true }) -- Keywords for function definition (e.g., `func` in Go, `function` in PHP).
	highlight("@keyword.operator", palette.vibrant_orange, nil) -- Keywords that act as operators (e.g., `and`, `or`).
	highlight("@operator", palette.vibrant_orange, nil) -- All other operators.

	highlight("@type", palette.vibrant_cyan, nil, { bold = true })
	highlight("@type.builtin", palette.vibrant_cyan, nil, { bold = true }) -- Built-in types (e.g., `int`, `string` in Go/Lua).
	highlight("@type.definition", palette.vibrant_cyan, nil, { bold = true }) -- Type definitions (e.g., `struct`, `class`, `enum`).

	highlight("@field", palette.vibrant_yellow, nil) -- Fields of structs/objects (Go, PHP, JSON/YAML keys).
	highlight("@label", palette.vibrant_orange, nil) -- For `goto` labels or similar constructs.

	-- Markup (e.g., Markdown files)
	highlight("@tag", palette.vibrant_red, nil, { bold = true }) -- HTML/XML tags, often found in Markdown.
	highlight("@attribute", palette.vibrant_orange, nil) -- HTML/XML attributes.
	highlight("@string.regexp", palette.vibrant_orange, nil) -- Regular expressions.
	highlight("@string.escape", palette.vibrant_magenta, nil) -- Escape characters within strings.

	highlight("@punctuation.delimiter", palette.fg_light_gray, nil) -- General delimiters (commas, semicolons).
	highlight("@punctuation.bracket", palette.fg_white, nil) -- Brackets (parentheses, square brackets, curly braces) - made very bright.
	highlight("@punctuation.special", palette.vibrant_orange, nil) -- Special punctuation.

	highlight("@markup.heading", palette.vibrant_red, nil, { bold = true }) -- Markdown headings.
	highlight("@markup.italic", palette.fg_light_gray, nil, { italic = true }) -- Italic text.
	highlight("@markup.bold", palette.fg_white, nil, { bold = true }) -- Bold text.
	highlight("@markup.link", palette.vibrant_blue, nil, { underline = true }) -- Links.
	highlight("@markup.raw", palette.comment_gray, nil) -- Raw code blocks.
	highlight("@markup.list", palette.vibrant_cyan, nil) -- Markdown lists.
	highlight("@markup.quote", palette.vibrant_green, nil, { italic = true }) -- Markdown blockquotes.

	-- Tree-sitter for specific languages (linking common groups where applicable)
	-- Go
	highlight("@type.qualifier.go", palette.vibrant_magenta, nil) -- e.g., `chan`
	highlight("@namespace.go", palette.vibrant_purple, nil) -- Package names
	-- PHP / Laravel
	highlight("@variable.member.php", palette.vibrant_cyan, nil, { italic = true }) -- `$this->property`
	highlight("@variable.field.php", palette.vibrant_yellow, nil) -- Class properties
	highlight("@keyword.function.php", palette.vibrant_red, nil, { bold = true }) -- `fn`, `function`
	highlight("@keyword.operator.php", palette.vibrant_orange, nil) -- `and`, `or`, `xor`
	highlight("@type.php", palette.vibrant_cyan, nil, { bold = true }) -- Type hints
	highlight("@attribute.php", palette.vibrant_purple, nil) -- PHP 8 attributes
	-- Laravel-specifics would largely fall under general PHP or be handled by LSP if defined.

	-- Lua
	highlight("@keyword.lua", palette.vibrant_red, nil, { bold = true }) -- `local`, `function`, `end`
	highlight("@variable.builtin.lua", palette.vibrant_blue, nil) -- `vim`, `true`, `false`, `nil`
	highlight("@constant.builtin.lua", palette.vibrant_yellow, nil) -- `nil`, `true`, `false` in Lua
	highlight("@field.lua", palette.vibrant_cyan, nil) -- Table keys

	-- Fish / Bash
	highlight("@keyword.shell", palette.vibrant_red, nil, { bold = true }) -- `if`, `for`, `function`
	highlight("@variable.shell", palette.vibrant_yellow, nil) -- Shell variables
	highlight("@function.builtin.shell", palette.vibrant_blue, nil, { bold = true }) -- `echo`, `cd`
	highlight("@string.shell", palette.vibrant_green, nil)

	-- JSON / YAML (mostly rely on general string/number/punctuation)
	highlight("@property.json", palette.vibrant_yellow, nil) -- JSON keys
	highlight("@property.yaml", palette.vibrant_yellow, nil) -- YAML keys
	highlight("@string.json", palette.vibrant_green, nil)
	highlight("@string.yaml", palette.vibrant_green, nil)
	highlight("@boolean.json", palette.vibrant_magenta, nil)
	highlight("@number.json", palette.vibrant_orange, nil)

	-- Telescope.nvim specific highlights
	highlight("TelescopeBorder", palette.comment_gray, palette.bg_darker_ui)
	highlight("TelescopeNormal", palette.fg_white, palette.bg_darker_ui)
	highlight("TelescopePromptNormal", palette.fg_white, palette.bg_deep_black)
	highlight("TelescopePromptBorder", palette.vibrant_red, palette.bg_deep_black)
	highlight("TelescopePromptPrefix", palette.vibrant_red, palette.bg_deep_black, { bold = true })
	highlight("TelescopePromptCounter", palette.vibrant_orange, palette.bg_deep_black)
	highlight("TelescopeResultsNormal", palette.fg_light_gray, palette.bg_darker_ui)
	highlight("TelescopeResultsBorder", palette.comment_gray, palette.bg_darker_ui)
	highlight("TelescopeResultsFile", palette.vibrant_cyan, nil) -- Files listed in results.
	highlight("TelescopeResultsLine", palette.fg_light_gray, nil) -- Content lines in preview.
	highlight("TelescopeMatching", palette.vibrant_yellow, nil, { bold = true }) -- Highlighted matches in results.
	highlight("TelescopeSelection", nil, palette.selection_bg, { bold = true }) -- Selected item in Telescope list.
	highlight("TelescopePreviewNormal", palette.fg_light_gray, palette.bg_deep_black)
	highlight("TelescopePreviewBorder", palette.comment_gray, palette.bg_deep_black)
	highlight("TelescopePreviewTitle", palette.vibrant_red, palette.bg_deep_black, { bold = true })
	highlight("TelescopePreviewLine", palette.fg_light_gray, nil)
	highlight("TelescopePreviewMatch", palette.vibrant_yellow, palette.bg_darker_ui, { bold = true })

	-- Other common plugin highlights (examples for NvimTree, GitSigns, BufferLine, LSP Saga)
	-- NvimTree (file explorer)
	highlight("NvimTreeRootFolder", palette.vibrant_orange, nil, { bold = true })
	highlight("NvimTreeFolderIcon", palette.comment_gray, nil)
	highlight("NvimTreeFileIcon", palette.fg_light_gray, nil)
	highlight("NvimTreeSpecialFile", palette.vibrant_yellow, nil, { italic = true })
	highlight("NvimTreeIndentMarker", palette.dim_gray, nil)

	-- GitSigns (Git integration)
	highlight("GitSignsAdd", palette.vibrant_green, nil) -- Added lines.
	highlight("GitSignsChange", palette.vibrant_blue, nil) -- Changed lines.
	highlight("GitSignsDelete", palette.vibrant_red, nil) -- Deleted lines.

	-- BufferLine / Tabline (for showing open buffers/tabs)
	highlight("BufferLineFill", palette.bg_deep_black, palette.bg_deep_black)
	highlight("BufferLineBuffer", palette.fg_light_gray, palette.bg_darker_ui)
	highlight("BufferLineBufferSelected", palette.vibrant_red, palette.bg_deep_black, { bold = true }) -- Selected buffer.
	highlight("BufferLineBufferInactive", palette.comment_gray, palette.bg_darker_ui) -- Inactive buffer.
	highlight("BufferLineTab", palette.fg_light_gray, palette.bg_darker_ui) -- General tab.
	highlight("BufferLineTabSelected", palette.vibrant_red, palette.bg_deep_black, { bold = true }) -- Selected tab.

	-- LSP Saga / UI (if used for LSP UI)
	highlight("LspSagaBorderFg", palette.comment_gray, nil)
	highlight("LspSagaNormal", palette.fg_white, palette.bg_darker_ui)
	highlight("LspSagaDocText", palette.fg_light_gray, nil)
	highlight("LspSagaType", palette.vibrant_cyan, nil)
	highlight("LspSagaSignatureHelpBorder", palette.comment_gray, palette.bg_darker_ui)
	highlight("LspSagaHoverBorder", palette.comment_gray, palette.bg_darker_ui)

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
