local configs = require("nvim-treesitter.configs")
configs.setup {
  -- Add a language of your choice
  ensure_installed = { "bash", "c", "comment", "commonlisp", "css", "csv", "diff", "dockerfile", "git_config", "gitignore", "gpg", "html", "htmldjango", "ini", "javascript", "json", "lua", "luadoc", "luap", "luau", "make", "markdown", "markdown_inline", "nix", "passwd", "php", "phpdoc", "python", "query", "regex", "requirements", "sql", "ssh_config", "toml", "vim", "vimdoc", "xml", "yaml", },
  sync_install = false,
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,

  },
  indent = { enable = true, disable = { "yaml" } },
  rainbow = {
    enable = true,
    -- list of languages you want to disable the plugin for
    -- disable = { "jsx", "cpp" },
    -- Which query to use for finding delimiters
    query = 'rainbow-parens',
    -- Highlight the entire buffer all at once
    strategy = require 'ts-rainbow.strategy.global',
    -- Do not enable for files with more than n lines
    max_file_lines = 3000
  }
}
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.hypr = {
  install_info = {
    url = "https://github.com/luckasRanarison/tree-sitter-hypr",
    files = { "src/parser.c" },
    branch = "master",
  },
  filetype = "hypr",
}
