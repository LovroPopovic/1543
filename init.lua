-- Set mapleader and maplocalleader to a space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable Nerd Font icons (assuming you have a Nerd Font installed)
-- This is checked by several plugins, so keep it here
vim.g.have_nerd_font = true

-- General editor settings
vim.opt.number = true -- Show line numbers
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.showmode = false -- Don't show -- INSERT -- etc.
vim.schedule(function()
 -- Set clipboard to unnamedplus for system clipboard integration
 vim.opt.clipboard = "unnamedplus"
end)
vim.opt.breakindent = true -- Maintain indent when wrapping lines
vim.opt.undofile = true -- Enable persistent undo
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search pattern contains uppercase
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.updatetime = 250 -- Decrease update time for faster cursor movement feedback
vim.opt.timeoutlen = 300 -- Decrease timeout for key sequences
vim.opt.splitright = true -- Split windows vertically to the right
vim.opt.splitbelow = true -- Split windows horizontally below
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Define how invisible characters look
vim.opt.inccommand = "split" -- Show incremental results for :substitute
vim.opt.cursorline = true -- Highlight the current line
vim.opt.scrolloff = 10 -- Keep 10 lines above and below the cursor when scrolling
vim.opt.confirm = true -- Ask for confirmation before quitting modified buffers

-- Keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open location list with diagnostics" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- Window navigation with Ctrl + H/J/K/L
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move to down window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move to up window" })

-- Autocommand to highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
 group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
 callback = function()
  vim.highlight.on_yank()
 end,
})

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
 local lazyrepo = "https://github.com/folke/lazy.nvim.git"
 local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
 if vim.v.shell_error ~= 0 then
  error("Error cloning lazy.nvim:\n" .. out)
 end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Plugin setup with Lazy.nvim
require("lazy").setup({
 -- Essential plugins
 "tpope/vim-sleuth", -- Detect indent settings
 {
  "lewis6991/gitsigns.nvim", -- Show git signs in the sign column
  opts = {
   signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
   },
  },
 },
 { "tpope/vim-fugitive" }, -- Git integration
 {
  "folke/which-key.nvim", -- Show available keymaps after leader key
  event = "VimEnter",
  opts = {
   delay = 0,
   -- Custom icons for which-key if Nerd Font is not available
   icons = vim.g.have_nerd_font and {} or {
    Up = "<Up> ",
    Down = "<Down> ",
    Left = "<Left> ",
    Right = "<Right> ",
    C = "<C-…> ",
    M = "<M-…> ",
    D = "<D-…> ",
    S = "<S-…> ",
    CR = "<CR> ",
    Esc = "<Esc> ",
    ScrollWheelDown = "<ScrollWheelDown> ",
    ScrollWheelUp = "<ScrollWheelUp> ",
    NL = "<NL> ",
    BS = "<BS> ",
    Space = "<Space> ",
    Tab = "<Tab> ",
    F1 = "<F1>",
    F2 = "<F2>",
    F3 = "<F3>",
    F4 = "<F4>",
    F5 = "<F5>",
    F6 = "<F6>",
    F7 = "<F7>",
    F8 = "<F8>",
    F9 = "<F9>",
    F10 = "<F10>",
    F11 = "<F11>",
    F12 = "<F12>",
   },
   -- Define keymap groups for which-key
   spec = {
    { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
    { "<leader>d", group = "[D]ocument" },
    { "<leader>r", group = "[R]ename" },
    { "<leader>s", group = "[S]earch" },
    { "<leader>w", group = "[W]orkspace" },
    { "<leader>t", group = "[T]oggle" },
    { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
   },
  },
 },

 -- Fuzzy finding with Telescope
 {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  -- Keep the branch here, but ensure you update regularly.
  -- If the warnings persist after updating, consider switching to 'main' temporarily
  branch = "0.1.x",
  dependencies = {
   "nvim-lua/plenary.nvim", -- Required by Telescope
   {
    "nvim-telescope/telescope-fzf-native.nvim", -- FZF integration for faster searching
    build = "make",
    cond = function()
     return vim.fn.executable("make") == 1
    end,
   },
   { "nvim-telescope/telescope-ui-select.nvim" }, -- Better UI for certain Telescope pickers
   { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font }, -- Icons for Telescope
  },
  config = function()
   require("telescope").setup({
    defaults = {
     hidden = true, -- Hide hidden files
     file_ignore_patterns = { -- Ignore specific directories and files
      "node_modules",
      ".git",
      "dist",
      "build",
      "coverage",
      "%.lock",
      "%.sqlite3",
      "/vendor/",
      "/tmp/",
     },
    },
    pickers = {
     find_files = {}, -- Default configuration for find_files
     live_grep = {}, -- Default configuration for live_grep
    },
    extensions = {
     ["ui-select"] = {
      require("telescope.themes").get_dropdown(), -- Use dropdown theme for ui-select
     },
    },
   })

   -- Load Telescope extensions
   pcall(require("telescope").load_extension, "fzf")
   pcall(require("telescope").load_extension, "ui-select")

   -- Telescope keymaps
   local builtin = require("telescope.builtin")
   vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
   vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
   vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
   vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
   vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
   vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
   vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
   vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
   vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
   vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

   -- Custom Telescope searches
   vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
     winblend = 10,
     previewer = false,
    }))
   end, { desc = "[/] Fuzzily search in current buffer" })

   vim.keymap.set("n", "<leader>s/", function()
    builtin.live_grep({
     grep_open_files = true,
     prompt_title = "Live Grep in Open Files",
    })
   end, { desc = "[S]earch [/] in Open Files" })

   vim.keymap.set("n", "<leader>sn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
   end, { desc = "[S]earch [N]eovim files" })

   vim.keymap.set("n", "<leader>sp", function()
    builtin.find_files({ cwd = "~/projects" })
   end, { desc = "[S]earch [P]rojects files" })
  end,
 },

 -- Lua development utilities
 {
  "folke/lazydev.nvim", -- Lazy development setup
  ft = "lua",
  opts = {
   library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
   },
  },
 },

 -- LSP (Language Server Protocol) setup
 {
  "neovim/nvim-lspconfig", -- Neovim's LSP client
  dependencies = {
   { "williamboman/mason.nvim", opts = {} }, -- LSP installer
   "williamboman/mason-lspconfig.nvim", -- Bridges Mason and Lspconfig
   "WhoIsSethDaniel/mason-tool-installer.nvim", -- Install formatters and linters
   { "j-hui/fidget.nvim", opts = {} }, -- LSP progress notifications
   "hrsh7th/cmp-nvim-lsp", -- LSP completion source for nvim-cmp
  },
  config = function()
   -- Autocommand for actions on LSP attach
   vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
     -- Helper function to set keymaps for LSP buffers
     local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
     end

     -- LSP keymaps - These use Telescope's built-in LSP pickers,
     -- so the fix for deprecated calls is in Telescope, not here.
     map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
     map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
     map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
     map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
     map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
     map(
      "<leader>ws",
      require("telescope.builtin").lsp_dynamic_workspace_symbols,
      "[W]orkspace [S]ymbols"
     )
     map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
     map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
     map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

     -- Helper function to check if a client supports a method.
     -- This was using a deprecated method in Neovim itself in older configs,
     -- but your provided code already uses the conditional check for Nvim 0.11,
     -- which seems to be the correct way to handle older/newer Neovim versions.
     -- The deprecation for client.supports_method was related to how *Telescope* called it,
     -- not how you check it in this helper.
     local function client_supports_method(client, method, bufnr)
      if vim.fn.has("nvim-0.11") == 1 then
       return client:supports_method(method, bufnr) -- This uses the colon syntax
      else
       return client.supports_method(method, { bufnr = bufnr }) -- Fallback for older Neovim
      end
     end

     -- Configure document highlight
     local client = vim.lsp.get_client_by_id(event.data.client_id)
     if
      client
      and client_supports_method(
       client,
       vim.lsp.protocol.Methods.textDocument_documentHighlight,
       event.buf
      )
     then
      local highlight_augroup =
       vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
       buffer = event.buf,
       group = highlight_augroup,
       callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
       buffer = event.buf,
       group = highlight_augroup,
       callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
       group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
       callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
       end,
      })
     end

     -- Configure inlay hints
     if
      client
      and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
     then
      map("<leader>th", function()
       vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
     end
    end,
   })

   -- Configure LSP diagnostics
   vim.diagnostic.config({
    severity_sort = true, -- Sort diagnostics by severity
    float = { border = "rounded", source = "if_many" }, -- Floating window for diagnostics
    underline = { severity = vim.diagnostic.severity.ERROR }, -- Underline errors
    -- Custom signs for diagnostics if Nerd Font is available
    signs = vim.g.have_nerd_font and {
     text = {
      [vim.diagnostic.severity.ERROR] = "? ",
      [vim.diagnostic.severity.WARN] = "? ",
      [vim.diagnostic.severity.INFO] = "? ",
      [vim.diagnostic.severity.HINT] = "? ",
     },
    } or {},
    virtual_text = { -- Show diagnostic messages as virtual text
     source = "if_many",
     spacing = 2,
     format = function(diagnostic)
      local diagnostic_message = {
       [vim.diagnostic.severity.ERROR] = diagnostic.message,
       [vim.diagnostic.severity.WARN] = diagnostic.message,
       [vim.diagnostic.severity.INFO] = diagnostic.message,
       [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
     end,
    },
   })

   -- Setup LSP capabilities
   local capabilities = vim.lsp.protocol.make_client_capabilities()
   capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

   -- Define configured language servers and their settings
   local servers = {
    lua_ls = {
     settings = {
      Lua = {
       completion = {
        callSnippet = "Replace",
       },
      },
     },
    },
    clangd = {},
    pyright = {},
    ["typescript-language-server"] = {}, -- Often handles JS/JSX/TS/TSX
    html = {},
    cssls = {},
    jsonls = {},
    -- Add other servers you use here, e.g.,
    -- rust_analyzer = {},
    -- gofumpt = {}, -- For Go
   }

   -- Ensure required tools are installed with Mason
   local ensure_installed_tools = vim.tbl_keys(servers or {})
   vim.list_extend(ensure_installed_tools, {
    "stylua",   -- Lua formatter
    "prettier", -- Code formatter (good for many web formats)
    -- Add other formatters/linters you use here, e.g.,
    -- "eslint_d", -- For JavaScript/TypeScript linting via LSP
    -- "isort", "black", -- For Python formatting
    -- "clang-format", -- For C/C++
   })
   require("mason-tool-installer").setup({ ensure_installed = ensure_installed_tools })

   -- Setup Mason-lspconfig to automatically configure installed servers
   require("mason-lspconfig").setup({
    ensure_installed = {}, -- Do not automatically install servers here
    automatic_installation = false,
    handlers = {
     function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
     end,
    },
   })
  end,
 },

 -- Formatting with Conform
 {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- Run on buffer write
  cmd = { "ConformInfo" },
  keys = {
   {
    "<leader>f",
    function()
     require("conform").format({ async = true, lsp_format = "fallback" })
    end,
    mode = "", -- Apply to all modes
    desc = "[F]ormat buffer",
   },
  },
  opts = {
   notify_on_error = false, -- Don't show errors in notifications
   format_on_save = function(bufnr)
    -- Disable format on save for specific filetypes
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
     return nil
    else
     return {
      timeout_ms = 500,
      lsp_format = "fallback", -- Use LSP formatting as a fallback
     }
    end
   end,
   -- Define formatters for each filetype
   formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    python = { "isort", "black" },
    cpp = { "clang-format" },
   },
  },
 },

 -- Completion with nvim-cmp
 {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- Load when entering insert mode
  dependencies = {
   {
    "L3MON4D3/LuaSnip", -- Snippet engine
    build = (function()
     -- Build for LuaSnip
     if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
      return
     end
     return "make install_jsregexp"
    end)(),
   },
   "saadparwaiz1/cmp_luasnip",          -- LuaSnip completion source
   "hrsh7th/cmp-nvim-lsp",             -- LSP completion source
   "hrsh7th/cmp-path",                 -- File path completion source
   "hrsh7th/cmp-nvim-lsp-signature-help", -- LSP signature help source
   "hrsh7th/cmp-buffer",               -- Buffer completion source
   -- Removed the duplicate "hrsh7th/nvim-cmp" entry here
  },
  config = function()
   local cmp = require("cmp")
   local luasnip = require("luasnip")
   luasnip.config.setup({}) -- Setup LuaSnip

   cmp.setup({
    snippet = {
     expand = function(args)
      luasnip.lsp_expand(args.body)
     end,
    },
    completion = { completeopt = "menu,menuone,noinsert" }, -- Completion options
    mapping = cmp.mapping.preset.insert({ -- Keymaps for completion
     ["<C-n>"] = cmp.mapping.select_next_item(),
     ["<C-p>"] = cmp.mapping.select_prev_item(),
     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
     ["<C-f>"] = cmp.mapping.scroll_docs(4),
     ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Confirm completion with Tab
     ["<C-Space>"] = cmp.mapping.complete({}), -- Trigger completion
     -- Snippet navigation
     ["<C-l>"] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
       luasnip.expand_or_jump()
      end
     end, { "i", "s" }),
     ["<C-h>"] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
       luasnip.jump(-1)
      end
     end, { "i", "s" }),
    }),
    -- Define completion sources and their order
    sources = cmp.config.sources({
     { name = "buffer" },
     { name = "nvim_lsp" },
     { name = "luasnip" },
     { name = "path" },
     { name = "nvim_lsp_signature_help" },
    }),
   })
  end,
 },

 -- Mini.nvim collection
 {
  "echasnovski/mini.pairs", -- Autoclose pairs
  event = "InsertCharPre",
  opts = {},
 },
 {
  "folke/tokyonight.nvim", -- Colorscheme
  priority = 1000, -- Ensure colorscheme loads first
  config = function()
   ---@diagnostic disable-next-line: missing-fields
   require("tokyonight").setup({
    style = "night", -- Explicitly set style for clarity
    styles = {
     comments = { italic = false }, -- Disable italic comments
    },
   })
   vim.cmd.colorscheme("tokyonight-night") -- Set the colorscheme
  end,
 },
 {
  "echasnovski/mini.nvim", -- Collection of minimal plugins
  config = function()
   require("mini.ai").setup({ n_lines = 500 }) -- Text objects
   require("mini.surround").setup() -- Add, change, delete surroundings
   local statusline = require("mini.statusline")
   statusline.setup({ use_icons = vim.g.have_nerd_font }) -- Statusline configuration
   ---@diagnostic disable-next-line: duplicate-set-field
   statusline.section_location = function()
    return "%2l:%-2v" -- Show line and column in statusline
   end
  end,
 },
 -- Syntax highlighting with Treesitter
 {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Build command
  main = "nvim-treesitter.configs",
  opts = {
   ensure_installed = { -- Languages to install parsers for
    "bash",
    "c",
    "diff",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "vimdoc",
    "javascript",
    "typescript",
    "css",
    "json",
    "yaml",
    "cpp",
    "python",

   },
   auto_install = true, -- Automatically install missing parsers
   highlight = {
    enable = true, -- Enable Treesitter highlighting
    additional_vim_regex_highlighting = { "ruby" },
   },
   indent = { enable = true, disable = { "ruby" } }, -- Enable Treesitter indentation
  },
 },
 -- Neotree file explorer - Added this based on your keymap
 {
  "nvim-tree/nvim-tree.lua",
  keys = { { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "[E]xplorer (Neotree) toggle" } },
  opts = {
   -- Add any specific Neotree options here if needed
   -- e.g.,
   -- view = {
   --  width = 30,
   -- },
   -- auto_close = true,
   -- hide_dotfiles = false,
  },
  dependencies = {
   "nvim-tree/nvim-web-devicons", -- For file icons
  },
 },
}, {
 -- Lazy UI icons
 ui = {
  icons = vim.g.have_nerd_font and {} or {
   cmd = "⌘",
   config = "?",
   event = "?",
   ft = "?",
   init = "⚙",
   keys = "?",
   plugin = "?",
   runtime = "?",
   require = "?",
   source = "?",
   start = "?",
   task = "?",
   lazy = "? ",
  },
 },
})

-- Your Neotree keymap is already defined in the plugin table for cleaner organization
-- vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "[E]xplorer (Neotree) toggle" })

-- vim: ts=2 sts=2 sw=2 et
