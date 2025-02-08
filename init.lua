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
vim.o.foldlevel = 99 -- ufo syntax provider needs a large value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.cmd('syntax on')

vim.loader.enable()

vim.cmd("set omnifunc=ale#completion#OmniFunc")
vim.cmd("let g:ale_completion_enabled = 1")
vim.cmd("let g:ale_completion_autoimport = 1")

vim.api.nvim_create_user_command('Files', 'lua MiniFiles.open()', {})

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
    {"mhinz/vim-sayonara"},
    {"moll/vim-bbye"},
    {"williamboman/mason.nvim"},
    {"ellisonleao/glow.nvim", config = true, cmd = "Glow"},
    {"mhartington/formatter.nvim"},
    {"tpope/vim-sleuth"},
    {"tpope/vim-fugitive"},
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
    {"ahmedkhalf/project.nvim",
      dependencies = {"nvim-telescope/telescope.nvim"}
    },
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
    {"justinhj/battery.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
      },
    },
    {'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {"michaelb/sniprun"},
    {"lukas-reineke/headlines.nvim",
      dependencies = "nvim-treesitter/nvim-treesitter",
      config = true, -- or `opts = {}`
    },
    {"rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "folke/lazydev.nvim"
      }
    },
    {"SmiteshP/nvim-navbuddy",
      dependencies = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
        "numToStr/Comment.nvim",        -- Optional
        "nvim-telescope/telescope.nvim" -- Optional
      },
      config = function()
        local navbuddy = require("nvim-navbuddy")
        navbuddy.setup({
          lsp = {auto_attach = true},
        })
      end,
      cmd = "Navbuddy"
    },
    {'numToStr/Comment.nvim',
      opts = {},
    },
    {'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      -- Optional dependencies
      dependencies = { { "echasnovski/mini.icons", opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
    },
    {"folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    -- Pheon-Dev/pigeon
  },

  -- Configure any other settings here.
  -- See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.cmd[[colorscheme tokyonight]]

require("project_nvim").setup()
require('telescope').load_extension('projects')

require('Comment').setup()

require("toggleterm").setup()

require("netrw").setup({})

require("oil").setup()

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
require('mini.ai').setup()
require('mini.cursorword').setup()
require('mini.surround').setup()

require("formatter").setup()

require("mason").setup()

require("auto-save").setup()

require("lazydev").setup({
  library = { "nvim-dap-ui" },
})

local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

local navic = require("nvim-navic")
navic.setup({
  lsp = {auto_attach = true}
})

require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
    end
})
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

require("battery").setup({})
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}
local nvimbattery = {
  function()
    return require("battery").get_status_line()
  end,
  color = { fg = colors.violet, bg = colors.bg },
}
local ostime = {
  function()
    return os.date("%H:%M:%S")
  end
}
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diagnostics'},
    lualine_c = {'filesize', 'filename'},
    lualine_x = {nvimbattery, ostime},
    lualine_y = {'encoding', 'filetype'},
    lualine_z = {'progress', 'location'},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'location'}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})

local theme = {
  fill = 'TabLineFill',
  -- Also you can do this:
  -- fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
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
  ensure_installed = {},
  sync_install = true,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = true,
  },
}

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

  -- Copy marked file in one step
  -- with this we can put the cursor in a directory
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

