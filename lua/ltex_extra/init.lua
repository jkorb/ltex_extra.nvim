local M = {}

M.opts = {
    init_check = true,   -- boolean : whether to load dictionaries on startup
    load_langs = {},     -- table <string> : language for witch dictionaries will be loaded
    log_level = "none",  -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
    path = "",           -- string : path to store dictionaries. Relative path uses current working directory
    server_start = true, -- boolean : Enable the call to ltex. Usefull for migration and test
    server_opts = nil,
}

local function register_lsp_commands()
    vim.lsp.commands["_ltex.addToDictionary"] = require("ltex_extra.commands-lsp").addToDictionary
    vim.lsp.commands["_ltex.hideFalsePositives"] = require("ltex_extra.commands-lsp").hideFalsePositives
    vim.lsp.commands["_ltex.disableRules"] = require("ltex_extra.commands-lsp").disableRules
end

local function call_ltex(server_opts)
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
        error("LTeX_extra: can't initialize ltex lspconfig module not found")
    end
    lspconfig["ltex"].setup(server_opts)
end

local function first_load()
    if M.opts.init_check == true then
        M.reload(M.opts.load_langs)
    end
end

local function extend_ltex_on_attach(on_attach)
    if on_attach then
        return function(...)
            on_attach(...)
            first_load()
        end
    else
        return first_load
    end
end

local ltex_languages = {
    "auto",
    "ar",
    "ast-ES",
    "be-BY",
    "br-FR",
    "ca-ES",
    "ca-ES-valencia",
    "da-DK",
    "de",
    "de-AT",
    "de-CH",
    "de-DE",
    "de-DE-x-simple-language",
    "el-GR",
    "en",
    "en-AU",
    "en-CA",
    "en-GB",
    "en-NZ",
    "en-US",
    "en-ZA",
    "eo",
    "es",
    "es-AR",
    "fa",
    "fr",
    "ga-IE",
    "gl-ES",
    "it",
    "ja-JP",
    "km-KH",
    "nl",
    "nl-BE",
    "pl-PL",
    "pt",
    "pt-AO",
    "pt-BR",
    "pt-MZ",
    "pt-PT",
    "ro-RO",
    "ru-RU",
    "sk-SK",
    "sl-SI",
    "sv",
    "ta-IN",
    "tl-PH",
    "uk-UA",
    "zh-CN",
}

local register_user_cmds = function()
    vim.api.nvim_create_user_command("LtexSwitchLang", function()
        vim.ui.select(ltex_languages, {
            prompt = "Select language:",
        }, function(choice)
            require("ltex_extra.commands-lsp").switchLanguage(choice)
        end)
    end, { desc = "ltex_extra.nvim: Switch sever language" })
end

M.reload = function(...)
    require("ltex_extra.commands-lsp").reload(...)
end

M.setup = function(opts)
    M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
    M.opts.path = vim.fs.normalize(M.opts.path) .. "/"

    register_user_cmds()
    register_lsp_commands()

    if M.opts.server_opts and M.opts.server_start then
        M.opts.server_opts.on_attach = extend_ltex_on_attach(M.opts.server_opts.on_attach)
        call_ltex(M.opts.server_opts)
    else
        first_load()
    end
end

return M
