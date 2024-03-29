" Theme based on Tomorrow

" Colours
let s:gui_foreground = "4d4d4c"
let s:cterm_foreground = 59
let s:gui_background = "ffffff"
let s:cterm_background = 231
let s:gui_selection = "d6d6d6"
let s:cterm_selection = 188
let s:gui_selection_dark = "d6d6d6"
let s:cterm_selection_dark = 188
let s:gui_line = "efefef"
let s:cterm_line = 254
let s:gui_comment = "8e908c"
let s:cterm_comment = 102
let s:gui_red = "c82829"
let s:cterm_red = 167
let s:gui_orange = "f5871f"
let s:cterm_orange = 208
let s:gui_yellow = "eab700"
let s:cterm_yellow = 178
let s:gui_green = "718c00"
let s:cterm_green = 64
let s:gui_aqua = "3e999f"
let s:cterm_aqua = 67
let s:gui_blue = "4271ae"
let s:cterm_blue = 61
let s:gui_purple = "8959a8"
let s:cterm_purple = 97
let s:gui_window = "efefef"
let s:cterm_window = 254
let s:gui_highlight = "7fa2bc"
let s:cterm_highlight = 109
let s:gui_insert = "b4bc73"
let s:cterm_insert = 144
let s:gui_replace = "af4e44"
let s:cterm_replace = 131

highlight clear
syntax reset
let g:colors_name = "Light"

set background=dark

" Sets the highlighting for the given group
function! Highlight(group, guifg, ctermfg, guibg, ctermbg, attr)
  if a:guifg != ""
    exec "hi " . a:group . " guifg=#" . a:guifg
  endif
  if a:guibg != ""
    exec "hi " . a:group . " guibg=#" . a:guibg
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
endfun

" Vim Highlighting
call Highlight("Normal", s:gui_foreground, s:cterm_foreground, s:gui_background, s:cterm_background, "")
call Highlight("NonText", s:gui_selection, s:cterm_selection, "", "", "")
call Highlight("SpecialKey", s:gui_selection, s:cterm_selection, "", "", "")
call Highlight("Search", s:gui_background, s:cterm_background, s:gui_yellow, s:cterm_yellow, "")
call Highlight("ErrorMsg", s:gui_red, s:cterm_red, s:gui_background, s:cterm_background, "reverse")

" Line number
call Highlight("LineNr", s:gui_selection, s:cterm_selection, "", "", "")
call Highlight("CursorLineNr", s:gui_foreground, s:cterm_foreground, "", "", "")

" Tab line
call Highlight("TabLine", s:gui_selection_dark, s:cterm_selection_dark, s:gui_foreground, s:cterm_foreground, "reverse")
call Highlight("TabLineFill", s:gui_line, s:cterm_line, s:gui_foreground, s:cterm_foreground, "reverse")
call Highlight("TabLineSel", s:gui_highlight, s:cterm_highlight, s:gui_foreground, s:cterm_foreground, "reverse")

" Status line
call Highlight("StatusLine", s:gui_selection_dark, s:cterm_selection_dark, s:gui_foreground, s:cterm_foreground, "reverse")
call Highlight("StatusLineNC", s:gui_selection_dark, s:cterm_selection_dark, s:gui_foreground, s:cterm_foreground, "reverse")
call Highlight("StatusLineInfo", s:gui_selection_dark, s:cterm_selection_dark, s:gui_foreground, s:cterm_foreground, "reverse")
call Highlight("StatusLineError", s:gui_red, s:cterm_red, s:gui_background, s:cterm_background, "reverse")
call Highlight("StatusLineFlag", s:gui_selection, s:cterm_selection, s:gui_foreground, s:cterm_foreground, "reverse")
call Highlight("StatusLineHighlightNormal", s:gui_highlight, s:cterm_highlight, s:gui_foreground, s:cterm_foreground, "reverse")
call Highlight("StatusLineHighlightInsert", s:gui_insert, s:cterm_insert, s:gui_background, s:cterm_background, "reverse")
call Highlight("StatusLineHighlightReplace", s:gui_replace, s:cterm_replace, s:gui_background, s:cterm_background, "reverse")

call Highlight("VertSplit", s:gui_selection_dark, s:cterm_selection_dark, s:gui_window, s:cterm_window, "none")
call Highlight("Visual", "", "", s:gui_selection, s:cterm_selection, "")
call Highlight("Directory", s:gui_blue, s:cterm_blue, "", "", "")
call Highlight("ModeMsg", s:gui_green, s:cterm_green, "", "", "")
call Highlight("MoreMsg", s:gui_green, s:cterm_green, "", "", "")
call Highlight("Question", s:gui_green, s:cterm_green, "", "", "")
call Highlight("WarningMsg", s:gui_background, s:cterm_background, "", s:cterm_red, "")
call Highlight("MatchParen", "", "", s:gui_selection, s:cterm_selection, "")
call Highlight("Folded", s:gui_comment, s:cterm_comment, s:gui_background, s:cterm_background, "")
call Highlight("FoldColumn", "", "", s:gui_background, s:cterm_background, "")

if version >= 700
  call Highlight("CursorLine", "", "", s:gui_line, s:cterm_line, "none")
  call Highlight("CursorColumn", "", "", s:gui_line, s:cterm_line, "none")
  call Highlight("PMenu", s:gui_foreground, s:cterm_foreground, s:gui_selection, s:cterm_selection, "none")
  call Highlight("PMenuSel", s:gui_foreground, s:cterm_foreground, s:gui_selection, s:cterm_selection, "reverse")
  call Highlight("SignColumn", "", "", s:gui_background, s:cterm_background, "none")
end
if version >= 703
  call Highlight("ColorColumn", "", "", s:gui_line, s:cterm_line, "none")
end

" Standard Highlighting
call Highlight("Comment", s:gui_comment, s:cterm_comment, "", "", "")
call Highlight("Todo", s:gui_comment, s:cterm_comment, s:gui_background, s:cterm_background, "")
call Highlight("Title", s:gui_comment, s:cterm_comment, "", "", "")
call Highlight("Identifier", s:gui_red, s:cterm_red, "", "", "none")
call Highlight("Statement", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("Conditional", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("Repeat", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("Structure", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("Function", s:gui_blue, s:cterm_blue, "", "", "")
call Highlight("Constant", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("String", s:gui_green, s:cterm_green, "", "", "")
call Highlight("Special", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("PreProc", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("Operator", s:gui_aqua, s:cterm_aqua, "", "", "none")
call Highlight("Type", s:gui_blue, s:cterm_blue, "", "", "none")
call Highlight("Define", s:gui_purple, s:cterm_purple, "", "", "none")
call Highlight("Include", s:gui_blue, s:cterm_blue, "", "", "")
call Highlight("Quote", s:gui_green, s:cterm_green, "", "", "")

" Vim Highlighting
call Highlight("vimCommand", s:gui_red, s:cterm_red, "", "", "none")

" C Highlighting
call Highlight("cType", s:gui_yellow, s:cterm_yellow, "", "", "")
call Highlight("cStorageClass", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("cConditional", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("cLabel", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("cRepeat", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("cStatement", s:gui_purple, s:cterm_purple, "", "", "")

" Shell Highlighting
call Highlight("shLoop", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("shConditional", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("shSet", s:gui_aqua, s:cterm_aqua, "", "", "")

" ZSH Highlighting
call Highlight("zshKeyword", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("zshConditional", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("zshCommands", s:gui_red, s:cterm_red, "", "", "")
call Highlight("zshTodo", s:gui_purple, s:cterm_purple, "", "", "")

" Ruby Highlighting
call Highlight("rubySymbol", s:gui_red, s:cterm_red, "", "", "")
call Highlight("rubyConstant", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("rubyAccess", s:gui_yellow, s:cterm_yellow, "", "", "")
call Highlight("rubyAttribute", s:gui_blue, s:cterm_blue, "", "", "")
call Highlight("rubyInclude", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("rubyLocalVariableOrMethod", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("rubyCurlyBlock", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("rubyStringDelimiter", s:gui_green, s:cterm_green, "", "", "")
call Highlight("rubyInterpolationDelimiter", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("rubyConditional", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("rubyRepeat", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("rubyControl", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("rubyException", s:gui_purple, s:cterm_purple, "", "", "")

" Python Highlighting
call Highlight("pythonInclude", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("pythonStatement", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("pythonConditional", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("pythonRepeat", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("pythonException", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("pythonFunction", s:gui_blue, s:cterm_blue, "", "", "")
call Highlight("pythonPreCondit", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("pythonRepeat", s:gui_aqua, s:cterm_aqua, "", "", "")
call Highlight("pythonExClass", s:gui_orange, s:cterm_orange, "", "", "")

" JavaScript Highlighting
call Highlight("javaScriptBraces", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptFetchAPIMethods", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptBranch", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptFunction", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptLabel", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptReserved", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptConditional", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptRepeat", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptNumber", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("javaScriptMember", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("javaScriptNull", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("javascriptGlobal", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javascriptStatement", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javascriptIdentifier", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javascriptException", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptCommentTodo", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptParens", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptLabel", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptSource", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptDocParam", s:gui_comment, s:cterm_comment, "", "", "")
call Highlight("javaScriptFuncExp", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptFuncEq", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptFuncComma", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptEndColons", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptOpSymbols", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptLogicSymbols", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptAjaxMethods", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptDOMMethods", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptDOMObjects", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptBrowserObjects", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptEventListenerKeywords", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptWebAPI", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptFuncKeyword", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptFuncdef", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("javaScriptExceptions", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("javaScriptTemplateDelim", s:gui_orange, s:cterm_orange, "", "", "")

" JSON Highlighting
call Highlight("jsonNumber", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("jsonBoolean", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("jsonBraces", s:gui_blue, s:cterm_blue, "", "", "")
call Highlight("jsonKeywordMatch", s:gui_blue, s:cterm_blue, "", "", "")
call Highlight("jsonNoise", s:gui_blue, s:cterm_blue, "", "", "")
call Highlight("jsonKeyword", s:gui_red, s:cterm_red, "", "", "")

" HTML Highlighting
call Highlight("htmlTag", s:gui_red, s:cterm_red, "", "", "")
call Highlight("htmlTagN", s:gui_red, s:cterm_red, "", "", "")
call Highlight("htmlTagName", s:gui_red, s:cterm_red, "", "", "")
call Highlight("htmlSpecialTagName", s:gui_red, s:cterm_red, "", "", "")
call Highlight("htmlArg", s:gui_red, s:cterm_red, "", "", "")
call Highlight("htmlScriptTag", s:gui_red, s:cterm_red, "", "", "")

" Diff Highlighting
call Highlight("diffAdded", s:gui_green, s:cterm_green, "", "", "")
call Highlight("diffRemoved", s:gui_red, s:cterm_red, "", "", "")

" ShowMarks Highlighting
call Highlight("ShowMarksHLl", s:gui_orange, s:cterm_orange, s:gui_background, s:cterm_background, "none")
call Highlight("ShowMarksHLo", s:gui_purple, s:cterm_purple, s:gui_background, s:cterm_background, "none")
call Highlight("ShowMarksHLu", s:gui_yellow, s:cterm_yellow, s:gui_background, s:cterm_background, "none")
call Highlight("ShowMarksHLm", s:gui_aqua, s:cterm_aqua, s:gui_background, s:cterm_background, "none")

" Markdown highlighting
call Highlight("markdownJekyllFrontMatter", s:gui_green, s:cterm_green, "", "", "")
call Highlight("markdownJekyllDelimiter", s:gui_green, s:cterm_green, "", "", "")
call Highlight("markdownItalic", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("markdownError", s:gui_foreground, s:cterm_foreground, "", "", "")

" C++ highlighting
call Highlight("cppStatement", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("cppExceptions", s:gui_purple, s:cterm_purple, "", "", "")

" TypeScript highlighting
call Highlight("typescriptReserved", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("typescriptIdentifier", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("typescriptConditional", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("typescriptParens", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("typescriptBraces", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("typescriptOpSymbols", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("typescriptLogicSymbols", s:gui_foreground, s:cterm_foreground, "", "", "")
call Highlight("typescriptNull", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("typescriptInterpolationDelimiter", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("typescriptExceptions", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("typescriptStorageClass", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("typescriptLabel", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("typescriptFuncKeyword", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("typescriptBranch", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("typescriptStatement", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("typescriptRepeat", s:gui_purple, s:cterm_purple, "", "", "")

" Swift highlighting
call Highlight("swiftKeyword", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("swiftIdentifierKeyword", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("swiftType", s:gui_orange, s:cterm_orange, "", "", "")
call Highlight("swiftVarName", s:gui_foreground, s:cterm_foreground, "", "", "")

" SQL
call Highlight("sqlStatement", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("sqlSpecial", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("sqlKeyword", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("sqlType", s:gui_foreground, s:cterm_foreground, "", "", "")

" DTrace
call Highlight("dtraceReservedKeyword", s:gui_purple, s:cterm_purple, "", "", "")
call Highlight("dtraceType", s:gui_yellow, s:cterm_yellow, "", "", "")

" Spell Checking
call Highlight("SpellBad", s:gui_background, s:cterm_background, s:gui_red, s:cterm_red, "")
call Highlight("SpellLocal", s:gui_background, s:cterm_background, s:gui_blue, s:cterm_blue, "")
call Highlight("SpellCap", s:gui_background, s:cterm_background, s:gui_highlight, s:cterm_highlight, "")
call Highlight("SpellRare", s:gui_background, s:cterm_background, s:gui_purple, s:cterm_purple, "")

if !has("gui_running")
  highlight Normal ctermbg=NONE
  highlight SignColumn ctermbg=NONE
  highlight FoldColumn ctermbg=NONE
endif
