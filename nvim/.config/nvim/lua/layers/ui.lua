return {
  require 'layers.style',
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      exclude = { filetypes = { 'dashboard' } },
    },
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    'leon-richardt/comment-highlights.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
    cmd = 'CHToggle',
    keys = {
      {
        '<leader>cc',
        function()
          require('comment-highlights').toggle()
        end,
        desc = 'Toggle comment highlighting',
      },
    },
  },
  --[[{
    'tribela/transparent.nvim',
    event = 'VimEnter',
    config = true,
  },]]
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
        theme = 'doom',
        config = {
          week_header = {
            enable = true,
          },
          center = {
            {
              icon = ' ',
              icon_hl = 'Title',
              desc = 'Find File           ',
              desc_hl = 'String',
              key = 'b',
              keymap = 'SPC s f',
              key_hl = 'Number',
              key_format = ' %s', -- remove default surrounding `[]`
              action = 'lua print(2)',
            },
            {
              icon = ' ',
              desc = 'Find Dotfiles',
              key = 'f',
              keymap = 'SPC f d',
              key_format = ' %s', -- remove default surrounding `[]`
              action = 'lua print(3)',
            },
          },
          footer = {}, --your footer
          shortcut = {
            { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
            {
              desc = ' Apps',
              group = 'DiagnosticHint',
              action = 'Telescope app',
              key = 'a',
            },
            {
              desc = ' dotfiles',
              group = 'Number',
              action = 'Telescope dotfiles',
              key = 'd',
            },
          },
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'danilamihailov/beacon.nvim',
    opts = {
      enabled = true,
      speed = 2, --- integer speed at wich animation goes
      width = 40, --- integer width of the beacon window
      winblend = 70, --- integer starting transparency of beacon window :h winblend
      fps = 60, --- integer how smooth the animation going to be
      min_jump = 10, --- integer what is considered a jump. Number of lines
      cursor_events = { 'CursorMoved' }, -- table<string> what events trigger check for cursor moves
      window_events = { 'WinEnter', 'FocusGained', 'BufRead' },
    },
  },
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {}
    end,
  },
  {
    'echasnovski/mini.animate',
    version = false,
    config = function()
      require('mini.animate').setup()
    end,
  },
}
