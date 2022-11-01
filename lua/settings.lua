require("global_settings")

local ui_utils = require("ui_utils")
local file_utils = require("file_utils")
local text_utils = require("text_utils")
local lsp_utils = require("lsp_utils")

local opts = { noremap = true, silent = true }

local dbs = {}
if vim.api.nvim_get_runtime_file("lua/dbs_local.lua", false)[1] then
    dbs = require("dbs_local")
end

local home = os.getenv("HOME") or ""

vim.opt.encoding = "utf-8"

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- tab settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- completion menu
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,list:full"
vim.opt.wildignore:append(
    "*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,*.pyc,*.dll,*.pdb,*.DS_Store,*.db,env,*/debug/*,*/Debug/*,*/publish/*"
)

vim.opt.undofile = true

vim.opt.tags = "tags;" .. home .. "/.config/nvim/tags/;" .. home .. "/tmp/tags/" -- find ctags
-- vim.opt.listchars = [[tab:▸\ ,space:⋅,eol:↴]] -- listchars for invisibles
vim.opt.listchars = [[tab:▸\ ,eol:↴]] -- listchars for invisibles
vim.opt.mouse:append({ a = true }) -- mouse all
vim.opt.ls = 2 -- status line always show
vim.opt.scrolloff = 5 -- show 5 lines before cursor always
vim.opt.showcmd = true -- display incomplete commands
vim.opt.linebreak = true -- show line breaks
vim.opt.wrap = true -- wrap lines
vim.opt.title = true -- title in the console
vim.opt.ttyfast = true -- smoother changes
vim.opt.shortmess = "atIF" -- abbreviate messages
vim.opt.backupdir = "/tmp" -- backup directory
vim.opt.showtabline = 1 -- always show the tab line
vim.opt.hidden = true -- has to do with undo in buffer I think...
vim.opt.cursorline = true -- show cursor where my cursor is...
vim.opt.lazyredraw = false -- better redrawing of text
vim.opt.termguicolors = true -- 24 bit term gui colors
vim.opt.modeline = true -- use modeline overrides
vim.opt.spell = false -- set spell
vim.opt.spelllang = { "en_us" } -- set us spell
vim.opt.updatetime = 12 -- very low update time for fast fps
vim.opt.showmode = false -- disable mode since we use lualine
vim.opt.laststatus = 3

-- tabs...
vim.api.nvim_set_keymap("n", "<Tab>j", ":tabnext<CR>", opts)
vim.api.nvim_set_keymap("n", "tj", ":tabnext<CR>", opts)

vim.api.nvim_set_keymap("n", "<Tab>l", ":tabnext<CR>", opts)
vim.api.nvim_set_keymap("n", "tl", ":tabnext<CR>", opts)

vim.api.nvim_set_keymap("n", "<Tab>h", ":tabprevious<CR>", opts)
vim.api.nvim_set_keymap("n", "th", ":tabprevious<CR>", opts)

vim.api.nvim_set_keymap("n", "<Tab>k", ":tabprevious<CR>", opts)
vim.api.nvim_set_keymap("n", "tk", ":tabprevious<CR>", opts)

vim.api.nvim_set_keymap("n", "<Tab>x", ":tabclose<CR>", opts)
vim.api.nvim_set_keymap("n", "tx", ":tabclose<CR>", opts)

vim.api.nvim_set_keymap("n", "<Tab>q", ":tabclose<CR>", opts)
vim.api.nvim_set_keymap("n", "tq", ":tabclose<CR>", opts)

vim.api.nvim_set_keymap("n", "<Tab>n", ":tabnew<CR>", opts)
vim.api.nvim_set_keymap("n", "tn", ":tabnew<CR>", opts)

-- autocomplete options
vim.opt.completeopt = "menu,menuone,noselect"

-- autocommands... here I got lazy
vim.cmd([[
    " Remember last location in file
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal g'\"" | endif

    " Make Python follow PEP8 (http://www.python.org/dev/peps/pep-0008/)
    au FileType python set softtabstop=4 tabstop=4 shiftwidth=4

    au FileType less set softtabstop=2 tabstop=2 shiftwidth=2
    au FileType css set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType slim set softtabstop=2 tabstop=2 shiftwidth=2
    au FileType sql set softtabstop=2 tabstop=2 shiftwidth=2
    au FileType cs set softtabstop=4 tabstop=4 shiftwidth=4

    " Code indentation and file detection
    " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
    au BufRead,BufNewFile {Procfile,Procfile.*,Gemfile,Rakefile,Capfile,Vagrantfile,Thorfile,*.ru,*.feature} set ft=ruby
    au BufRead,BufNewFile {*.crontab} set ft=crontab
    au BufRead,BufNewFile {*.redis} set ft=redis
    au BufNewFile,BufRead *.feature set tabstop=2 shiftwidth=2 softtabstop=2

    " Code indentation
    au FileType nim set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType dart set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType yaml set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType crystal set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType coffee set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType json set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType javascript set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType vuejs set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType haskell set ai
    au FileType less set ai
    au FileType less set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType scala set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType html set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType xhtml set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType xml set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType lua set tabstop=4 shiftwidth=4 softtabstop=4
    au BufEnter *.tsx set tabstop=2 shiftwidth=2 softtabstop=2

    " Fix issue when doing syntax highlight
    au BufEnter *.html :syntax sync fromstart
    au BufEnter *.dart :syntax sync fromstart
    au BufEnter *.py :syntax sync fromstart
    au BufEnter *.lua :syntax sync fromstart
    au BufEnter *.ex :syntax sync fromstart
    au BufEnter *.nim :syntax sync fromstart

    " Jsonc (json with comments) support
    au FileType json syntax match Comment +\/\/.\+$+

    " Support for csharp script
    au BufRead,BufNewFile *.csx set filetype=cs
]])

-- go to config
vim.api.nvim_create_user_command("Conf", file_utils.cd_conf, {})
vim.api.nvim_create_user_command("ConfInit", file_utils.edit_init, {})
vim.api.nvim_create_user_command("ConfSettings", file_utils.edit_settings, {})
vim.api.nvim_create_user_command("ConfPlugins", file_utils.edit_plugins, {})

-- theme helpers
vim.api.nvim_set_keymap("n", "<leader>x", "<Cmd>TSHighlightCapturesUnderCursor<CR>", opts)
vim.keymap.set("n", "<leader>X", ui_utils.syn_stack, opts)

vim.notify = require("notify")
vim.notify.setup({
    render = "minimal",
    timeout = 1500,
    stages = "static",
    background_colour = "#000000",
})

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.notify.setup({
            background_colour = ui_utils.hi_co("Normal", "bg"),
        })
    end,
})

-- sets tabline without the "X" for close, this is done for aesthetic reasons
-- and this code is copied from :h setting-tabline
vim.cmd([[
    function NoXTabLine()
        let s = ''
        for i in range(tabpagenr('$'))
            " select the highlighting
            if i + 1 == tabpagenr()
                let s ..= '%#TabLineSel#'
            else
                let s ..= '%#TabLine#'
            endif

            " set the tab page number (for mouse clicks)
            let s ..= '%' .. (i + 1) .. 'T'

            " the label is made by NoXTabLabel()
            let s ..= ' %{NoXTabLabel(' .. (i + 1) .. ')} '
        endfor

        " after the last tab fill with TabLineFill and reset tab page nr
        let s ..= '%#TabLineFill#%T'

        " right-align the label to close the current tab page
        if tabpagenr('$') > 1
            " Does not include the close button
            let s ..= '%=%#TabLine#%999X'
        endif

        return s
    endfunction

    function NoXTabLabel(n)
        let buflist = tabpagebuflist(a:n)
        let winnr = tabpagewinnr(a:n)
        let name = bufname(buflist[winnr - 1])

        " Modification for no name...
        if name == ''
            return '[No Name]'
        endif

        return name
    endfunction

    set tabline=%!NoXTabLine()
]])

-- telescope
local telescope = require("telescope")

telescope.load_extension("lsp_handlers")
telescope.load_extension("notify")
telescope.load_extension("noice")

local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
})

vim.api.nvim_set_keymap("n", "<leader>p", "<Cmd>Telescope git_files<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>P", "<Cmd>Telescope live_grep<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>n", "<Cmd>Telescope find_files<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>N", "<Cmd>Telescope noice<CR>", {})

-- windowze config
if vim.fn.has("win32") == 1 then
    vim.opt.shell = "powershell"
    vim.opt.shellcmdflag = [[-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command]]
    vim.opt.shellpipe = [[\|]]
    vim.opt.shellredir = [[\|\ Out-File\ -Encoding\ UTF8]]
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
else
    if vim.fn.executable("zsh") == 1 then
        vim.opt.shell = "zsh"
    else
        vim.opt.shell = "bash"
    end
end

-- setup nvim-cmp.
local cmp = require("cmp")

assert(cmp, not nil)

local sources = {}
if vim.fn.has("win32") == 1 then
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "nvim_lsp_signature_help" },
    }, {
        { name = "treesitter" },
        { name = "path" },
        { name = "spell" },
        { name = "dictionary" },
        { name = "buffer" },
        { name = "fonts", options = { space_filter = "-" } },
    })
else
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "nvim_lsp_signature_help" },
    }, {
        { name = "treesitter" },
        { name = "path" },
        { name = "spell" },
        { name = "dictionary" },
        { name = "zsh" }, -- problems in windows
        { name = "buffer" },
        { name = "fonts", options = { space_filter = "-" } },
    })
end

local winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:CursorLine,Search:Search"

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").load()

-- local mapping for nvim-cmp.
-- <Tab> is used by Copilot, I found the pluggin doesn't work
-- if I use <Tab> for nvim-cmp or any other plugin
local mapping = {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-n>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif text_utils.has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm(),
}

-- cmp plugin
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered({ winhighlight = winhighlight }),
        documentation = cmp.config.window.bordered({ winhighlight = winhighlight }),
        preview = cmp.config.window.bordered({ winhighlight = winhighlight }),
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = require("lspkind").cmp_format({
            with_text = false,
            menu = {
                nvim_lsp = "[lsp]",
                nvim_lua = "[lua]",
                luasnip = "[luasnip]",
                buffer = "[buffer]",
                path = "[path]",
                calc = "[calc]",
                vsnip = "[vsnip]",
                nvim_lsp_signature_help = "[lsp]",
                treesitter = "[treesitter]",
                spell = "[spell]",
                dictionary = "[dictionary]",
                zsh = "[zsh]",
                ["vim-dadbod-completion"] = "[db]",
            },
        }),
    },
    mapping = cmp.mapping.preset.insert(mapping),
    sources = sources,
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
        { name = "buffer" },
    }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "nvim_lsp_document_symbol" },
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
    }),
})

-- mason
require("mason").setup({
    ui = {
        border = "rounded",
        winhighlight = winhighlight,
    },
})

-- lsp config mason
require("mason-lspconfig").setup({
    ensure_installed = {},
    automatic_instalation = true,
})

-- nvim diagnostics signs
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticWarning" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticInformation" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticHint" })

-- trouble
require("trouble").setup({
    auto_open = false,
    auto_close = true,
    auto_preview = true,
    auto_fold = true,
    use_diagnostic_signs = true,
})

-- toggle trouble with t (for local file) or T (for all files)
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>T", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
local formatter_util = require("formatter.util")
require("formatter").setup({
    -- Enable or disable logging
    logging = false,

    -- All formatter configurations are opt-in
    filetype = {
        lua = {
            function()
                return {
                    exe = "stylua",
                    args = {
                        "--search-parent-directories",
                        "--stdin-filepath",
                        formatter_util.escape_path(formatter_util.get_current_buffer_file_path()),
                        "--indent-type",
                        "Spaces",
                        "--",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },

        javascript = {
            require("formatter.filetypes.javascript").prettier,
        },

        typescript = {
            require("formatter.filetypes.javascript").prettier,
        },

        json = {
            require("formatter.filetypes.json").prettier,
        },

        python = {
            require("formatter.filetypes.python").black,
            require("formatter.filetypes.python").isort,
        },

        sql = {
            require("formatter.filetypes.sql").sqlformat,
        },

        elixir = {
            function()
                local buffn = formatter_util.escape_path(formatter_util.get_current_buffer_file_path())

                return {
                    exe = "mix",
                    args = {
                        "format",
                        buffn,
                    },
                    stdin = false,
                    transform = function(text)
                        vim.cmd("e!")

                        return text
                    end,
                }
            end,
        },

        markdown = {
            require("formatter.filetypes.markdown").prettier,
        },

        nim = {
            function()
                local buffn = formatter_util.escape_path(formatter_util.get_current_buffer_file_path())

                return {
                    exe = "nimpretty",
                    args = {
                        "--out:" .. buffn,
                        buffn,
                    },
                }
            end,
        },

        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})

vim.api.nvim_set_keymap("n", "<leader>f", ":Format<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>F", ":FormatWrite<CR>", opts)

-- setup LSP
local lspconfig_util = require("lspconfig").util

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.cmd([[
    autocmd BufEnter,CursorHold,InsertLeave <buffer> lua if next(vim.lsp.codelens.get()) ~= nil then vim.lsp.codelens.refresh() end
]])

vim.keymap.set("n", "<leader>d", lsp_utils.diagnostics_toggle, opts)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

-- saga
local saga = require("lspsaga")

saga.init_lsp_saga({
    border_style = "rounded",
    code_action_icon = " ",
    code_action_lightbulb = {
        virtual_text = false,
    },
    rename_in_select = false,
    symbol_in_winbar = {
        enable = true,
        show_file = false,
        click_support = function(node, clicks, button, modifiers)
            -- To see all avaiable details: vim.pretty_print(node)
            local st = node.range.start
            local en = node.range["end"]
            if button == "l" then
                if clicks == 2 then
                -- double left click to do nothing
                else -- jump to node's starting line+char
                    vim.fn.cursor(st.line + 1, st.character + 1)
                end
            elseif button == "r" then
                if modifiers == "s" then
                    print("lspsaga") -- shift right click to print "lspsaga"
                end -- jump to node's ending line+char
                vim.fn.cursor(en.line + 1, en.character + 1)
            elseif button == "m" then
                -- middle click to visual select node
                vim.fn.cursor(st.line + 1, st.character + 1)
                vim.cmd("normal v")
                vim.fn.cursor(en.line + 1, en.character + 1)
            end
        end,
    },
    show_outline = {
        enable = false,
        auto_refresh = false,
    },
})

-- set keymaps from lsp saga
local sagaopts = { silent = true }

vim.keymap.set("n", "<leader>2", "<cmd>LSoutlineToggle<CR>", sagaopts)
vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", sagaopts)
vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", sagaopts)
vim.keymap.set("n", "<leader>cd", "<cmp>Lspsaga peek_definition<CR>", sagaopts)
vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", sagaopts)
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", sagaopts)
vim.keymap.set("n", "<leader>ck", "<cmd>Lspsaga hover_doc<CR>", sagaopts)

-- diagnostics style
vim.diagnostic.config({
    float = { border = "rounded" },
})

-- lsp handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = {
        spacing = 0,
        prefix = "",
    },
    signs = true,
    update_in_insert = false,
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- python
require("lspconfig").pyright.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
                reportUnnecessaryTypeIgnoreComment = true,
            },
        },
    },
})

-- vala
require("lspconfig").vala_ls.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
})

-- dart
vim.g.dart_style_guide = 2
vim.g.dart_html_in_string = true
vim.g.dart_format_on_save = 1
vim.g.dart_trailing_comma_indent = true
vim.g.dartfmt_options = { "--fix" }

-- flutter
if vim.fn.executable("flutter") == 1 then
    require("flutter-tools").setup({
        ui = {
            border = "rounded",
            notification_style = "native",
        },
        widget_guides = {
            enabled = true,
        },
        closing_tags = {
            enabled = true,
            prefix = "➥  ",
        },
        outline = {
            open_cmd = "botright 40vnew",
            auto_open = false,
        },
        dev_log = {
            enabled = true,
            open_cmd = "botright 5sp",
        },
        lsp = {
            on_attach = function(client, bufnr)
                lsp_utils.on_attach(client, bufnr)

                vim.keymap.set("n", "<leader>2", ":FlutterOutlineToggle<CR>", { buffer = true, noremap = true })

                vim.cmd([[
                    augroup FlutterTools
                        autocmd!
                        autocmd FileType flutterToolsOutline noremap <buffer> <leader>2 :FlutterOutlineToggle<CR>
                    augroup END
                ]])

                require("flutter-tools").lsp_on_attach(client, bufnr)
            end,
            capabilities = lsp_utils.capabilities,
            color = {
                enabled = true,
                background = true,
            },
            settings = {
                showTodos = false,
                completeFunctionCalls = true,
                updateImportsOnRename = true,
                enableSnippets = true,
                renameFilesWithClasses = true,
            },
        },
        debugger = {
            enabled = true,
            -- run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
            -- -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
            -- -- see |:help dap.set_exception_breakpoints()| for more info
            -- exception_breakpoints = {},
            register_configurations = function(_)
                require("dap").configurations.dart = {}
                require("dap.ext.vscode").load_launchjs()
            end,
        },
    })

    require("telescope").load_extension("flutter")
else
    -- If not flutter, use dartls which is optional
    require("lspconfig").dartls.setup({
        capabilities = lsp_utils.capabilities,
        on_attach = lsp_utils.on_attach,
    })
end

-- semshi config
vim.g["semshi#simplify_markup"] = false
vim.g["semshi#mark_selected_nodes"] = 1
vim.g["semshi#error_sign"] = false
vim.g["semshi#always_update_all_highlights"] = true

-- csharp
-- use vscode omnisharp install
-- local omnisharp_dll = home .. "/.vscode/extensions/ms-dotnettools.csharp-1.25.0-linux-x64/.omnisharp/1.39.0-net6.0/OmniSharp.dll"
require("lspconfig").omnisharp.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,

    handlers = {
        ["textDocument/definition"] = require("omnisharp_extended").handler,
    },
    -- NOTE to use the same install as vscode
    -- cmd = { "dotnet", omnisharp_dll, "--hostPID", tostring(pid) },

    enable_editorconfig_support = true,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    sdk_include_prereleases = true,

    root_dir = function(file, _)
        if file:sub(-#".csx") == ".csx" then
            return lspconfig_util.path.dirname(file)
        end
        return lspconfig_util.root_pattern("*.sln")(file) or lspconfig_util.root_pattern("*.csproj")(file)
    end,
})

-- omnisharp-vim config, related to ^^ (skips auto complete settings)
vim.cmd([[
augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  autocmd FileType cs nmap <silent> <buffer> \[\[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> \]\] <Plug>(omnisharp_navigate_down)

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field

  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <leader>osgcc <Plug>(omnisharp_global_code_check)
  autocmd FileType cs nmap <silent> <buffer> <leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <leader>ossp <Plug>(omnisharp_stop_server)
augroup END
]])

local omnisharp_bin = home .. "/.local/share/nvim/mason/packages/omnisharp/omnisharp"
vim.g.OmniSharp_server_path = omnisharp_bin
vim.g.OmniSharp_diagnostic_showid = 1
vim.g.OmniSharp_highlighting = 3
vim.g.OmniSharp_diagnostic_overrides = "None"
vim.g.OmniSharp_popup = 1
vim.g.OmniSharp_timeout = 60000
vim.g.OmniSharp_server_type = "roslyn"
vim.g.OmniSharp_server_use_net6 = 1
vim.g.OmniSharp_server_stdio = 1

-- elixir
require("lspconfig").elixirls.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
    settings = {
        dialyzerEnabled = true,
        fetchDeps = true,
        enableTestLenses = true,
        suggestSpecs = true,
    },
})

-- -- another plugin
-- local elixir = require("elixir")
-- elixir.setup({
--     -- specify a repository and branch
--     -- repo = "elixir-lsp/elixir-ls",
--     -- branch = "master",
--     -- repo = "mhanberg/elixir-ls", -- defaults to elixir-lsp/elixir-ls
--     -- branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
--
--     -- default settings, use the `settings` function to override settings
--     settings = elixir.settings({
--         dialyzerEnabled = true,
--         fetchDeps = true,
--         enableTestLenses = true,
--         suggestSpecs = true,
--     }),
--
--     capabilities = lsp_utils.capabilities,
--     on_attach = function(client, bufnr)
--         local elixir_opts = { noremap = true, silent = true, buffer = bufnr }
--
--         -- remove the pipe operator
--         vim.keymap.set("n", "<leader>fp", ":ElixirFromPipe<cr>", elixir_opts)
--
--         -- add the pipe operator
--         vim.keymap.set("n", "<leader>tp", ":ElixirToPipe<cr>", elixir_opts)
--         vim.keymap.set("v", "<leader>em", ":ElixirExpandMacro<cr>", elixir_opts)
--
--         -- keybinds
--         vim.keymap.set("n", "gr", ":References<cr>", elixir_opts)
--         vim.keymap.set("n", "g0", ":DocumentSymbols<cr>", elixir_opts)
--         vim.keymap.set("n", "gW", ":WorkspaceSymbols<cr>", elixir_opts)
--         vim.keymap.set("n", "<leader>d", ":Diagnostics<cr>", elixir_opts)
--
--         lsp_utils.on_attach(client, bufnr)
--     end,
-- })

-- nim
require("lspconfig").nimls.setup({
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.capabilities,
})

-- ts and js
require("lspconfig").tsserver.setup({
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.capabilities,
})

-- java
require("lspconfig").jdtls.setup({
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.capabilities,
})

-- c
require("lspconfig").clangd.setup({
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.capabilities,
})

-- lua
require("lspconfig").sumneko_lua.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim", "use" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

-- html
require("lspconfig").html.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
})

-- dap
local dap, dapui = require("dap"), require("dapui")

-- dap.set_log_level("TRACE")

vim.fn.sign_define(
    "DapBreakpoint",
    { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapLogPoint",
    { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

-- dap ui
dapui.setup({
    floating = {
        border = "rounded",
    },
})

-- events for dap to automatically open the dap ui
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
end

-- dap bindings
vim.cmd([[
    nnoremap <silent> <F5> <Cmd>lua require('dap').continue()<CR>
    nnoremap <silent> <F6> <Cmd>lua require('dap').step_over()<CR>
    nnoremap <silent> <F7> <Cmd>lua require('dap').step_into()<CR>
    nnoremap <silent> <F8> <Cmd>lua require('dap').step_out()<CR>
    nnoremap <silent> <leader>b <Cmd>lua require('dap').toggle_breakpoint()<CR>
    nnoremap <silent> <leader>B <Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    nnoremap <silent> <leader>L <Cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
    nnoremap <silent> <leader>dr <Cmd>lua require('dap').repl.open()<CR>
    nnoremap <silent> <leader>dl <Cmd>lua require('dap').run_last()<CR>
    nnoremap <silent> <leader>dL <Cmd>lua require('dap').run_last()<CR>
]])

-- dap for dart debug adapter
-- if vim.fn.executable("flutter") == 1 then
--     dap.adapters.dart = {
--         type = "executable",
--         command = "flutter",
--         args = { "debug_adapter" },
--     }
--
--     dap.configurations.dart = {
--         {
--             type = "dart",
--             request = "launch",
--             name = "Launch Flutter Program",
--             -- The nvim-dap plugin populates this variable with the filename of the current buffer
--             program = "${file}",
--             -- The nvim-dap plugin populates this variable with the editor's current working directory
--             cwd = "${workspaceFolder}",
--             toolArgs = { "-d", "chrome" }, -- for Flutter apps toolArgs
--         },
--         {
--             type = "dart",
--             request = "attach",
--             name = "Attach Flutter Program",
--             cwd = "${workspaceFolder}",
--         },
--     }
-- else
--     dap.adapters.dart = {
--         type = "executable",
--         command = "dart",
--         args = { "debug_adapter" },
--     }
--
--     dap.configurations.dart = {
--         {
--             type = "dart",
--             request = "launch",
--             name = "Launch Dart Program",
--             -- The nvim-dap plugin populates this variable with the filename of the current buffer
--             program = "${file}",
--             -- The nvim-dap plugin populates this variable with the editor's current working directory
--             cwd = "${workspaceFolder}",
--             args = { "--help" }, -- for Dart apps this is args
--         },
--     }
-- end

-- python dap
require("dap-python").setup(home .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python")

-- elixir
dap.adapters.elixir = {
    type = "executable",
    command = home .. "/.local/share/nvim/mason/packages/elixir-ls/debugger.sh",
}

dap.configurations.elixir = {
    {
        type = "elixir",
        name = "Run Elixir Program",
        task = "phx.server",
        taskArgs = { "--trace" },
        request = "launch",
        startApps = true, -- for Phoenix projects
        projectDir = "${workspaceFolder}",
        requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
        },
    },
}

-- gitsigns
require("gitsigns").setup()

-- lualine
-- load default first
require("lualine").setup(ui_utils.lualine_setup_options())

-- overwrite with colorscheme specific my own defaults
vim.api.nvim_create_autocmd("colorscheme", {
    pattern = "*",
    callback = function()
        require("lualine").setup(ui_utils.lualine_setup_options())
    end,
})

-- nvim tree lua
require("nvim-tree").setup({
    filters = { dotfiles = true },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    renderer = {
        icons = {
            show = {
                folder_arrow = false,
            },
        },
    },
})

vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<CR>")

-- rainbow treesitter
require("nvim-treesitter.configs").setup({
    auto_install = true,
    highlight = {
        enable = true,
        -- sometimes we need to disable some of them...
        -- disable = { "dart", "python", "elixir" },
        disable = { "dart", "python" },
        additional_vim_regex_highlighting = true,
    },
    markid = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
    },
})

-- colorizer
require("colorizer").setup({ "*" }, {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = true, -- "Name" codes like Blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn

    -- Available modes: foreground, background
    mode = "foreground", -- Set the display mode.
})

-- LspInfo rounded borders
require("lspconfig.ui.windows").default_options.border = "rounded"

-- Comment.nvim
require("Comment").setup()

-- indent.blankline
-- vim.g.indent_blankline_char = "▏"
vim.g.indent_blankline_enabled = false

require("indent_blankline").setup({
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
})

vim.keymap.set("n", "<leader>l", function()
    vim.cmd("IndentBlanklineToggle")
    vim.cmd.set("list!")
end)

-- disable indentblankline in Startify
vim.cmd([[
    augroup DisableIndentBlankline
        autocmd!
        autocmd FileType startify IndentBlanklineDisable
    augroup END
]])

-- dadbod ui
vim.g.dbs = dbs
vim.g.db_ui_use_nerd_fonts = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "mysql", "plsql", "redis" },
    callback = function()
        cmp.setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
    end,
})

-- set the connections, maps and config edit command
vim.keymap.set("n", "<leader>db", "<Cmd>DBUIToggle<Cr>")
vim.api.nvim_create_user_command("DBConfig", file_utils.edit_dbs_config, {})

-- todo comments
require("todo-comments").setup()

-- noice
require("noice").setup({
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,
    },
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
})
