let mapleader=" "
set number
set encoding=utf-8
set fileencoding=utf-8
set termguicolors

set hidden
call plug#begin('~/.vim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'skywind3000/asyncrun.vim'
Plug 'rust-lang/rust.vim'
Plug 'mg979/vim-visual-multi'
Plug 'lervag/vimtex'
Plug 'luochen1990/rainbow'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'wellle/targets.vim'
Plug 'camspiers/animate.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'folke/trouble.nvim'
Plug 'romgrk/barbar.nvim'
Plug 'lazytanuki/nvim-mapper'
Plug 'romgrk/nvim-treesitter-context'
Plug 'kristijanhusak/orgmode.nvim'
Plug 'winston0410/cmd-parser.nvim'
Plug 'winston0410/range-highlight.nvim'
Plug 'mbbill/undotree'
Plug 'lewis6991/gitsigns.nvim'
Plug 'famiu/feline.nvim'
Plug 'terrortylor/nvim-comment'
Plug 'arecarn/vim-frisk'
Plug 'kdheepak/lazygit.nvim'
Plug 'tpope/vim-surround'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'seblj/nvim-echo-diagnostics'
Plug 'justinmk/vim-sneak'
Plug 'voldikss/vim-floaterm'
Plug 't9md/vim-choosewin'
call plug#end()
let g:asyncrun_open = 15
colo sonokai
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:sneak#label = 1


" let g:indentLine_char = '|'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" show chunk diff at current position

set shell=/usr/bin/zsh

set completeopt=menuone,noselect
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })



let g:EasyMotion_do_mapping = 0 " Disable default mappings
" binding.
" " `s{char}{label}`
" " Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
set smartcase
"autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()

"
"
" This will echo the diagnostics on CursorHold, and will also consider cmdheight
autocmd CursorHold * lua require('echo-diagnostics').echo_line_diagnostic()

" This will echo the entire diagnostic message. 
" Should prompt you with Press ENTER or type command to continue.

nnoremap <leader>cd <cmd>lua require("echo-diagnostics").echo_entire_diagnostic()<CR>

lua <<EOF
-- nvim_lsp object
require("echo-diagnostics").setup{
    show_diagnostic_number = true
}
require("indent_blankline").setup {
    char = "|",
    buftype_exclude = {"terminal"}
}

require('nvim_comment').setup()
local nvim_lsp = require'lspconfig'

local on_attach = function(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
    capabilities=capabilities,
    on_attach=on_attach,
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
nvim_lsp.ccls.setup({})
nvim_lsp.jdtls.setup{ cmd = { 'jdtls' } }
nvim_lsp.pylsp.setup{}
EOF


" Completion
lua <<EOF
require('orgmode').setup({
  org_agenda_files = {'~/my-orgs/**/*'},
  org_default_notes_file = '~/my-notes/org/refile.org',
})

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    orgmode = true;
  };
}
EOF
lua << EOF
require'lspconfig'.pyright.setup{}
EOF


let $FZF_DEFAULT_COMMAND = 'rg --files '

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set shortmess+=c
set smartcase

" Enable master mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

set cursorline


" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup


" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

set updatetime=300
" Show diagnostic popup on cursor hover

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }


lua << EOF
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF


lua << EOF
  require("todo-comments").setup {
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = "F", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = "T ", color = "info" },
    HACK = { icon = "H", color = "warning" },
    WARN = { icon = "W ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = "P ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = "N ", color = "hint", alt = { "INFO" } },
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlightng (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of hilight groups or use the hex color if hl not found as a fallback
  colors = {
    error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
    warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
    info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
    hint = { "LspDiagnosticsDefaultHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  }
  }
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
" http://blog.trk.in.rs/2015/12/01/vim-tips/
" http://modal.us/blog/2013/07/27/back-to-vim-with-nerdtree-nope-netrw/
" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction

" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" Default to tree mode
let g:netrw_liststyle=3

" Change directory to the current buffer when opening files.
" set autochdir
" maybe is easier within netrw just press c  help :netrw-c
" that's better than 'cd ../path' which change in all tabs
lua << EOF
  require("trouble").setup {
    fold_open = "v", -- icon used for open folds
    fold_closed = ">", -- icon used for closed folds
    indent_lines = false, -- add an indent guide below the fold icons
    signs = {
        -- icons / text used for a diagnostic
        error = "error",
        warning = "warn",
        hint = "hint",
        information = "info"
    },
    use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
  }
EOF
let bufferline = get(g:, 'bufferline', {})
let bufferline.icons = v:false
let bufferline.clickable = v:false
let bufferline.icon_separator_active = '|'
let bufferline.icon_separator_inactive = '|'
let bufferline.icon_close_tab = ''
let bufferline.icon_close_tab_modified = 'M'

lua << EOF
require("nvim-mapper").setup({})
local actions = require('telescope.actions')
-- Global remapping
------------------------------
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      }
    }
  }
})



require'telescope'.load_extension('mapper')
Mapper = require("nvim-mapper")
Mapper.map('i', 'jj', "<Esc>", {silent = true, noremap = true}, "Exit insert mode", "exit_insert", "Exit insert mode with another key mapping to speed up the process.")
Mapper.map('t','jj',"<C-\\><C-n>",{silent = true, noremap = true}, "Exit terminal insert mode", "exit_term_insert", "Exit the terminal insert mode with the same mapping as in the normal mode.")
Mapper.map('n','<leader>p',":GFiles<cr>",{silent = true, noremap = true}, "Find files","fuzzy_find_files","Fuzzy searching for files in the current working directory.")
Mapper.map('n','<leader>b',":Buffers<cr>",{silent = true, noremap = true}, "Find buffers","fuzzy_find_buffer","Fuzzy searching for open buffers.")
Mapper.map('n','<leader>l',":Lines<cr>",{silent = true, noremap = true}, "Search open lines","fuzzy_find_lines","Fuzzy searching for through the lines in the buffer.")
Mapper.map('n','<leader>g',":LazyGit<cr>",{silent = false, noremap = true}, "Open the git console","git_console","Open the git console for commiting and changing things.")
Mapper.map('n','<leader>f',":Rg<cr>",{silent = true, noremap = true}, "Search strings in files", "live_grep","Matching the string in every file in the working directory.")
Mapper.map('n','<leader>h',":Telescope mapper<cr>",{silent = true, noremap = true}, "Show keymappings", "show_help","Show this keymapping help to support the user of this config file.")
Mapper.map('n','<leader>ss',":GFiles?<cr>",{silent = true, noremap = true}, "Search git diff","show_status","Show fuzzy search of the git status and shows a preview of the diff file.")
Mapper.map('n','<leader>sc',":Commits<cr>",{silent = true, noremap = true}, "Search git commits","show_commits","Fuzzy search git commits with telescope plugin.")
Mapper.map('n','<leader>sb',":Telescope git_branches<cr>",{silent = true, noremap = true}, "Search git branches", "show_branches","Fuzzy search git branches with the telescope plugin.")
Mapper.map('n','<leader>t',":TodoTrouble<cr>",{silent = true, noremap = true}, "Show project todos/notes","show_todos","Shows a nice overview of the todos and notes in the current working directory.")
Mapper.map('n','<leader>m',":BufferPick<cr>",{silent = true, noremap = true}, "Buffer picker","pick_buffer","Pick a buffer by doing selecting the buffer in the tab bar.")
Mapper.map('n','<leader>oa',"<Cmd>lua require('orgmode').action('agenda.prompt')<cr>",{silent = true, noremap = true}, "Open orgmode agenda","orgmode_agenda","Opens the orgmode agenda based on all todos in the opened buffers.")
Mapper.map('n','<leader>u',"<cmd>lua require\"gitsigns\".reset_hunk()<CR>",{silent = true, noremap = true}, "Undo git hunk","undo_git_hunk","Undo git hunk from file.")

Mapper.map('n','<leader>a',"<cmd>lua require\"gitsigns\".stage_hunk()<CR>",{silent = true, noremap = true}, "Stage git hunk","stage_git_hunk","Stage the current git hunk for the next commit.")
Mapper.map('v','<leader>a',"<cmd>lua require\"gitsigns\".stage_hunk({vim.fn.line(\".\"), vim.fn.line('v')})<CR>",{silent = true, noremap = true}, "Stage visual git hunk","stage_vis_git_hunk","Stage selected hunk from visual mode for the next commit.")

Mapper.map('n','<leader>x',"<cmd>lua require\"gitsigns\".blame_line(true)<CR>",{silent = true, noremap = true}, "Toggle Git line highlight","git_line_highlight","Toggle the git line highlighting.")
Mapper.map('n','<leader>n',"<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>",{silent = true, noremap = true}, "Next git hunk","git_next_hunk","Jump to the next git hunk in the file.")
Mapper.map('n','<leader>N',"<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>",{silent = true, noremap = true}, "Previous git hunk","git_prev_hunk","Jump to the previous git hunk in the file.")
Mapper.map('n','<leader>d',"<cmd>lua vim.lsp.diagnostic.goto_next({enable_popup=false})<CR>",{silent = true, noremap = true}, "Next diagnostic","diag_next","Jump to the next diagnostic message.")
Mapper.map('n','<leader>D',"<cmd>lua vim.lsp.diagnostic.goto_prev({enable_popup=false})<CR>",{silent = true, noremap = true}, "Previous diagnostic","diag_prev","Jump to the previous diagnostic message.")
Mapper.map('n','<leader>v',":Trouble<CR>",{silent = true, noremap = true}, "Show diagnostics","diag_nice_show","Show the file diagnostics in a file preview.")
Mapper.map('n','<leader>w',":Frisk ",{silent = false, noremap = true}, "Browser search for word","browser_search","Search the web for a specific term.")
Mapper.map('v','<leader>w',":'<,'>Frisk<cr>",{silent = false, noremap = false}, "Browser search for selection","browser_search_3","Search the web for the text selected with visual mode.")
Mapper.map('n','<leader>r',":AsyncRun ",{silent = false, noremap = false}, "Async run command","async_run","Asynchronously execute the command and pipe the output to copen.")
Mapper.map('n','<leader>q',":cn<cr>",{silent = false, noremap = false}, "Next entry in quickfix","quickfix_next","Select the next quickfix entry.")
Mapper.map('n','<leader>Q',":cp<cr>",{silent = false, noremap = false}, "Previous entry in quickfix","quickfix_prev","Select the previous quickfix entry.")
Mapper.map('n','<leader>e',":call ToggleVExplorer()<CR>",{silent = false, noremap = false}, "Open explorer","open_explorer","Opens the explorer to explore the filesystem")
Mapper.map('n','<leader>z',":FloatermNew<CR>",{silent = false, noremap = false}, "Opens floating terminal","float_term","Opens the floating terminal window.")
Mapper.map('n','<leader>j',"<Plug>(choosewin)",{silent = false, noremap = false}, "Selects a window","window_picker","Selects a window with a character.")
EOF

lua << EOF
require'treesitter-context.config'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    throttle = true, -- Throttles plugin updates (may improve performance)
}
EOF

hi BufferCurrent ctermfg=blue
hi BufferCurrentMod ctermfg=red
hi BufferVisibleTarget ctermfg=yellow
hi BufferCurrentTarget ctermfg=yellow
hi BufferInactiveTarget ctermfg=yellow
set relativenumber

lua << EOF
require("range-highlight").setup {
    highlight = "Visual",
	highlight_with_out_range = {
        d = true,
        delete = true,
        m = true,
        move = true,
        y = true,
        yank = true,
        c = true,
        change = true,
        j = true,
        join = true,
        ["<"] = true,
        [">"] = true,
        s = true,
        subsititue = true,
        sno = true,
        snomagic = true,
        sm = true,
        smagic = true,
        ret = true,
        retab = true,
        t = true,
        co = true,
        copy = true,
        ce = true,
        center = true,
        ri = true,
        right = true,
        le = true,
        left = true,
        sor = true,
        sort = true
	}
}
EOF


"Taken from https://stackoverflow.com/questions/5700389/using-vims-persistent-undo/22676189
" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'

if stridx(&runtimepath, expand(vimDir)) == -1
  " vimDir is not on runtimepath, add it
  let &runtimepath.=','.vimDir
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

lua << EOF
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
  watch_index = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = false,
  current_line_blame_delay = 1000,
  current_line_blame_position = 'eol',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = false,
  use_decoration_api = true,
  use_internal_diff = true,  -- If luajit is present
}

-- require('feline').setup({
--     preset = 'noicon',
-- })
EOF


lua << EOF
local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

local b = vim.b
local fn = vim.fn

local M = {
    properties = {
        force_inactive = {
            filetypes = {},
            buftypes = {},
            bufnames = {}
        }
    },
    components = {
        left = {
            active = {},
            inactive = {}
        },
        mid = {
            active = {},
            inactive = {}
        },
        right = {
            active = {},
            inactive = {}
        }
    }
}

M.properties.force_inactive.filetypes = {
    'NvimTree',
    'packer',
    'startify',
    'fugitive',
    'fugitiveblame',
    'qf',
    'help'
}

M.properties.force_inactive.buftypes = {
    'terminal'
}

M.components.left.active[1] = {
    provider = '▊ ',
    hl = {
        fg = 'skyblue'
    }
}

M.components.left.active[2] = {
    provider = 'vi_mode',
    hl = function()
        local val = {}

        val.name = vi_mode_utils.get_mode_highlight_name()
        val.fg = vi_mode_utils.get_mode_color()
        val.style = 'bold'

        return val
    end,
    right_sep = ' ',
    icon = ''
}

M.components.left.active[3] = {
    provider = 'file_info',
    hl = {
        fg = 'white',
        bg = 'oceanblue',
        style = 'bold'
    },
    left_sep = '',
    right_sep = ' ',
    icon = ''
}

M.components.left.active[4] = {
    provider = 'file_size',
    enabled = function() return fn.getfsize(fn.expand('%:p')) > 0 end,
    right_sep = {
        ' ',
        {
            str = 'vertical_bar_thin',
            hl = {
                fg = 'fg',
                bg = 'bg'
            }
        },
    }
}

M.components.left.active[5] = {
    provider = 'position',
    left_sep = ' ',
    right_sep = {
        ' ',
        {
            str = 'vertical_bar_thin',
            hl = {
                fg = 'fg',
                bg = 'bg'
            }
        }
    }
}

M.components.left.active[6] = {
    provider = 'diagnostic_errors',
    enabled = function() return lsp.diagnostics_exist('Error') end,
    hl = { fg = 'red' },
    icon = ' E-'
}

M.components.left.active[7] = {
    provider = 'diagnostic_warnings',
    enabled = function() return lsp.diagnostics_exist('Warning') end,
    hl = { fg = 'yellow' },
    icon = ' W-'
}

M.components.left.active[8] = {
    provider = 'diagnostic_hints',
    enabled = function() return lsp.diagnostics_exist('Hint') end,
    hl = { fg = 'cyan' },
    icon = ' H-'
}

M.components.left.active[9] = {
    provider = 'diagnostic_info',
    enabled = function() return lsp.diagnostics_exist('Information') end,
    hl = { fg = 'skyblue' },
    icon = ' I-'
}

M.components.right.active[1] = {
    provider = function()
      local result = vim.lsp.buf_get_clients()
      local count = 0
      for _ in pairs(result) do count = count + 1 end
      if next(result) ~= nil then
        return "LSP: " .. (result[0] or result[1]).name
      else
        return "LSP: none"
      end

    end,
    hl = {
        fg = 'red',
        bg = 'black',
        style = 'bold'
    },
    icon = ' ',
    right_sep = {
            str = ' |',
            hl = {
                fg = 'white',
                bg = 'black'
            }
    }
}

M.components.right.active[2] = {
    provider = 'git_branch',
    hl = {
        fg = 'white',
        bg = 'black',
        style = 'bold'
    },
    right_sep = function()
        local val = {hl = {fg = 'NONE', bg = 'black'}}
        if b.gitsigns_status_dict then val.str = ' ' else val.str = '' end

        return val
    end,
    icon = ' '
}

M.components.right.active[3] = {
    provider = 'git_diff_added',
    hl = {
        fg = 'green',
        bg = 'black'
    },
    icon = ' +'
}

M.components.right.active[4] = {
    provider = 'git_diff_changed',
    hl = {
        fg = 'orange',
        bg = 'black'
    },
    icon = ' ~'
}

M.components.right.active[5] = {
    provider = 'git_diff_removed',
    hl = {
        fg = 'red',
        bg = 'black'
    },
    right_sep = function()
        local val = {hl = {fg = 'NONE', bg = 'black'}}
        if b.gitsigns_status_dict then val.str = ' ' else val.str = '' end

        return val
    end,
    icon = ' -'
}

M.components.right.active[6] = {
    provider = 'line_percentage',
    hl = {
        style = 'bold'
    },
    left_sep = '  ',
    right_sep = ' '
}

M.components.right.active[7] = {
    provider = 'scroll_bar',
    hl = {
        fg = 'skyblue',
        style = 'bold'
    }
}

M.components.left.inactive[1] = {
    provider = 'file_type',
    hl = {
        fg = 'white',
        bg = 'oceanblue',
        style = 'bold'
    },
    left_sep = {
        str = ' ',
        hl = {
            fg = 'NONE',
            bg = 'oceanblue'
        }
    },
    right_sep = {
        {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = 'oceanblue'
            }
        },
        ' '
    }
}

require('feline').setup({
    default_bg = '#1F1F23',
    default_fg = '#D0D0D0',
    colors = M.colors,
    separators = M.separators,
    components = M.components,
    properties = M.properties,
    vi_mode_colors = M.vi_mode_colors
})
EOF
set showcmd
