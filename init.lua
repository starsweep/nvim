vim.o.clipboard = "unnamedplus"
vim.o.number = true
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.termguicolors = true
vim.o.wrap = true
vim.o.showtabline = 2
vim.o.syntax = "on"

vim.cmd("set noswapfile")
vim.cmd("set undofile")

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.cmd('syntax on')

vim.loader.enable()

vim.cmd("set omnifunc=ale#completion#OmniFunc")
vim.cmd("let g:ale_completion_enabled = 1")
vim.cmd("let g:ale_completion_autoimport = 1")

vim.api.nvim_create_user_command('Files', 'lua MiniFiles.open()', {})

-- netrw config

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.netrw_keepdir = 0
vim.g.netrw_sort_sequence = [[[\/]$,*]]
vim.g.netrw_keepdir = 0

vim.cmd("hi! link netrwMarkFile Search")

local function netrw_maps()
  if vim.bo.filetype ~= "netrw" then
    return
  end

  local opts = { silent = true }
  -- Toggle dotfiles
  vim.api.nvim_buf_set_keymap(0, "n", ".", "gh", opts)

  -- Open file and close netrw
  vim.api.nvim_buf_set_keymap(0, "n", "l", "<CR>:Lexplore<CR>", opts)

  -- Open file or directory
  vim.api.nvim_buf_set_keymap(0, "n", "o", "<CR>", opts)

  -- Show netrw help in a floating (or maybe sidebar?) window
  -- TODO: implement show_help function so we can implement this mapping
  --[[ vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "?",Text File.txt
    ":lua require('doom.core.settings.netrw').show_help()<CR>",
    opts
  ) ]]

  -- Close netrw
  vim.api.nvim_buf_set_keymap(0, "n", "q", ":Lexplore<CR>", opts)

  -- Create a new file and save it
  vim.api.nvim_buf_set_keymap(0, "n", "ff", "%:w<CR>:buffer #<CR>", opts)

  -- Create a new directory
  vim.api.nvim_buf_set_keymap(0, "n", "fa", "d", opts)

  -- Rename file
  vim.api.nvim_buf_set_keymap(0, "n", "fr", "R", opts)

  -- Remove file or directory
  vim.api.nvim_buf_set_keymap(0, "n", "fd", "D", opts)

  -- Copy marked file
  vim.api.nvim_buf_set_keymap(0, "n", "fc", "mc", opts)

  -- Copy marked file in one step, with this we can put the cursor in a directory
  -- after marking the file to assign target directory and copy file
  vim.api.nvim_buf_set_keymap(0, "n", "fC", "mtmc", opts)

  -- Move marked file
  vim.api.nvim_buf_set_keymap(0, "n", "fx", "mm", opts)

  -- Move marked file in one step, same as fC but for moving files
  vim.api.nvim_buf_set_keymap(0, "n", "fX", "mtmm", opts)

  -- Execute commands in marked file or directory
  vim.api.nvim_buf_set_keymap(0, "n", "fe", "mx", opts)

  -- Show a list of marked files and directories
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "fm",
    ':echo "Marked files:\n" . join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>',
    opts
  )

  -- Show target directory
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "ft",
    ':echo "Target: " . netrw#Expose("netrwmftgt")<CR>',
    opts
  )

  -- Toggle the mark on a file or directory
  vim.api.nvim_buf_set_keymap(0, "n", "<TAB>", "mf", opts)

  -- Unmark all the files in the current buffer
  vim.api.nvim_buf_set_keymap(0, "n", "<S-TAB>", "mF", opts)

  -- Remove all the marks on all files
  vim.api.nvim_buf_set_keymap(0, "n", "<Leader><TAB>", "mu", opts)

  -- Create a bookmark
  vim.api.nvim_buf_set_keymap(0, "n", "bc", "mb", opts)

  -- Remove the most recent bookmark
  vim.api.nvim_buf_set_keymap(0, "n", "bd", "mB", opts)

  -- Jumo to the most recent bookmark
  vim.api.nvim_buf_set_keymap(0, "n", "bj", "gb", opts)
end

netrw_maps()

-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim

require("lazy").setup({
  spec = {
    {"echasnovski/mini.nvim",
      version = false
    },
    {"williamboman/mason.nvim"},
    {"ellisonleao/glow.nvim", config = true, cmd = "Glow"},
    {"mhartington/formatter.nvim"},
    {"iamcco/markdown-preview.nvim",
      cmd = {
        "MarkdownPreviewToggle",
        "MarkdownPreview",
        "MarkdownPreviewStop"
      },
      ft = { "markdown" },
      build = function() vim.fn["mkdp#util#install"]() end,
    },
    {'nullromo/go-up.nvim',
      opts = {}, -- specify options here
      config = function(_, opts)
      local goUp = require('go-up')
      goUp.setup(opts)
      end,
    },
    {"dstein64/nvim-scrollview"},
    {"pocco81/auto-save.nvim"},
    {"nvim-treesitter/nvim-treesitter", config = true},
    {"mhinz/vim-startify"},
    {'prichrd/netrw.nvim', opts = {}},
    {"nguyenvukhang/nvim-toggler", config = true},
    {"ryanoasis/vim-devicons"},
    {"lewis6991/gitsigns.nvim", confing = true},
    {"kevinhwang91/nvim-hlslens", config = true},
    {'nvim-telescope/telescope.nvim', tag = '0.1.8',
      -- or                          , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"kevinhwang91/nvim-ufo",
      dependencies = {"kevinhwang91/promise-async"}
    },
    {"ahmedkhalf/project.nvim"},
    {"norcalli/nvim-colorizer.lua"},
    {"folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" },
          function() require("flash").jump() end,
          desc = "Flash"
        },
        { "S", mode = { "n", "x", "o" },
          function() require("flash").treesitter() end,
          desc = "Flash Treesitter"
        },
        { "r", mode = "o",
          function() require("flash").remote() end,
          desc = "Remote Flash"
        },
        { "R", mode = { "o", "x" },
          function() require("flash").treesitter_search() end,
          desc = "Treesitter Search"
        },
        { "<c-s>", mode = { "c" },
          function() require("flash").toggle() end,
          desc = "Toggle Flash Search"
        },
      },
    },
    {"folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = true })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    {"folke/drop.nvim", opts = {} },
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {"danielfalk/smart-open.nvim",
      branch = "0.2.x",
      config = function()
        require("telescope").load_extension("smart_open")
      end,
      dependencies = {
        "kkharji/sqlite.lua",
        -- Only required if using match_algorithm fzf
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
        { "nvim-telescope/telescope-fzy-native.nvim" },
      },
    },
    {"roxma/nvim-yarp"},
    {'dense-analysis/ale'},
    {"dundalek/lazy-lsp.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
        {"VonHeikemen/lsp-zero.nvim", branch = "v3.x"},
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
      },
      config = function()
        local lsp_zero = require("lsp-zero")
          lsp_zero.on_attach(function(client, bufnr)
            -- see :help lsp-zero-keybindings to learn the available actions
          lsp_zero.default_keymaps({
            buffer = bufnr,
            preserve_mappings = false
          })
        end)
        require("lazy-lsp").setup {}
      end,
    },
    {'nanozuki/tabby.nvim'},
    {"michaelb/sniprun"},
    {"CRAG666/betterTerm.nvim",
      opts = {
      position = "bot",
      size = 15,
      },
    },
    {"CRAG666/code_runner.nvim", config = true },
    {"lukas-reineke/headlines.nvim",
      dependencies = "nvim-treesitter/nvim-treesitter",
      config = true, -- or `opts = {}`
    },
    {"folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.cmd[[colorscheme tokyonight]]

require("netrw").setup({})

require("mini.icons").setup()
require("mini.completion").setup()
require("mini.files").setup()
require("mini.align").setup()
require("mini.clue").setup()
require("mini.git").setup()
require("mini.hipatterns").setup()
require("mini.map").setup()
require("mini.move").setup()
require("mini.notify").setup()
require("mini.snippets").setup()
require("mini.tabline").setup()
require("mini.indentscope").setup()
require('mini.pairs').setup()

require("formatter").setup()

require("mason").setup()

require("auto-save").setup()

require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
    end
})

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}

require('tabby').setup({
  line = function(line)
    return {
      {
        { '  ', hl = theme.head },
        line.sep('', theme.head, theme.fill),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          line.sep('', hl, theme.fill),
          tab.is_current() and '' or '󰆣',
          tab.number(),
          tab.name(),
          tab.close_btn(''),
          line.sep('', hl, theme.fill),
          hl = hl,
          margin = ' ',
        }
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return {
          line.sep('', theme.win, theme.fill),
          win.is_current() and '' or '',
          win.buf_name(),
          line.sep('', theme.win, theme.fill),
          hl = theme.win,
          margin = ' ',
        }
      end),
      {
        line.sep('', theme.tail, theme.fill),
        { '  ', hl = theme.tail },
      },
      hl = theme.fill,
    }
  end,
  -- option = {}, -- setup modules' option,
})

require('scrollview').setup({
  excluded_filetypes = {'nerdtree'},
  current_only = true,
  base = 'buffer',
  column = 80,
  signs_on_startup = {'all'},
  diagnostics_severities = {vim.diagnostic.severity.ERROR}
})

require 'colorizer'.setup()

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  -- List of parsers to ignore installing (or "all")
  ignore_install = {},
  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
  highlight = {
    enable = true,
    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = true,
  },
}

require('code_runner').setup({
  filetype = {
    java = {
      "cd $dir &&",
      "javac $fileName &&",
      "java $fileNameWithoutExt"
    },
    python = "python3 -u",
    typescript = "deno run",
    rust = {
      "cd $dir &&",
      "rustc $fileName &&",
      "$dir/$fileNameWithoutExt"
    },
    c = function(...)
      c_base = {
        "cd $dir &&",
        "gcc $fileName -o",
        "/tmp/$fileNameWithoutExt",
      }
      local c_exec = {
        "&& /tmp/$fileNameWithoutExt &&",
        "rm /tmp/$fileNameWithoutExt",
      }
      vim.ui.input({ prompt = "Add more args:" }, function(input)
        c_base[4] = input
        vim.print(vim.tbl_extend("force", c_base, c_exec))
        require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
      end)
    end,
  },
})
