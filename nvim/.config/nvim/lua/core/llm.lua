return {
  'github/copilot.vim',
  {
    'danieljemoore/model.nvim',
    cmd = { 'Model', 'Mchat' },
    init = function()
      vim.filetype.add { extension = { mchat = 'mchat' } }
    end,
    ft = 'mchat',
    keys = { { '<leader>h', ':Model<cr>', mode = 'v' } },
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    opts = {
      provider = 'claude',
      vendors = {
        ---@type AvanteProvider
        groq = {
          endpoint = 'https://api.groq.com/openai/v1/chat/completions',
          model = 'llama-3.1-70b-versatile',
          api_key_name = 'GROQ_API_KEY',
          parse_curl_args = function(opts, code_opts)
            return {
              url = opts.endpoint,
              headers = {
                ['Accept'] = 'application/json',
                ['Content-Type'] = 'application/json',
                ['Authorization'] = 'Bearer ' .. os.getenv(opts.api_key_name),
              },
              body = {
                model = opts.model,
                messages = { -- you can make your own message, but this is very advanced
                  { role = 'system', content = code_opts.system_prompt },
                  { role = 'user', content = require('avante.providers.openai').get_user_message(code_opts) },
                },
                temperature = 0,
                max_tokens = 4096,
                stream = true, -- this will be set by default.
              },
            }
          end,
          parse_response_data = function(data_stream, event_state, opts)
            require('avante.providers').openai.parse_response(data_stream, event_state, opts)
          end,
        },
        ---@type AvanteSupportedProvider
        ollama = {
          ['local'] = true,
          endpoint = 'http://127.0.0.1:11434',
          model = 'llama3.1:latest',
          parse_curl_args = function(opts, code_opts)
            return {
              url = opts.endpoint .. '/api/generate',
              headers = {
                ['Accept'] = 'application/json',
                ['Content-Type'] = 'application/json',
              },
              body = {
                model = opts.model,
                messages = { -- you can make your own message, but this is very advanced
                  { role = 'system', content = code_opts.system_prompt },
                  { role = 'user', content = require('avante.providers.openai').get_user_message(code_opts) },
                },
                max_tokens = 2048,
                stream = true,
              },
            }
          end,
          parse_response_data = function(data_stream, event_state, opts)
            require('avante.providers').openai.parse_response(data_stream, event_state, opts)
          end,
        },
      },
    },
    keys = {
      {
        '<leader>apg',
        function()
          vim.g.avante_provider = 'groq'
          require('lazy').reload { 'avante.nvim' }
        end,
        desc = 'avante: set provider to groq',
      },
      {
        '<leader>apo',
        function()
          vim.g.avante_provider = 'ollama'
          vim.cmd 'Lazy reload avante.nvim'
        end,
        desc = 'avante : set provider to ollama',
      },
      {
        '<leader>apc ',
        function()
          vim.g.avante_provider = 'claude'
          vim.cmd 'Lazy reload avante.nvim'
        end,
        desc = 'avante:  set provider to claude',
      },
      {
        '<leader>apm',
        function()
          vim.g.avante_provider = 'copilot'
          vim.cmd 'Lazy reload avante.nvim'
        end,
        desc = ' avante: set provider to copilot',
      },
      {
        '<leader>ae',
        function()
          require('avante.api').edit()
        end,
        desc = 'avante: edit',
        mode = 'v',
      },
    },
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to setup it properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
  {
    'chottolabs/kznllm.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      -- { 'chottolabs/plenary.nvim' }, -- patched to resolve symlinked directories
    },
    config = function(self)
      local presets = require 'kznllm.presets'
      local Path = require 'plenary.path'

      -- falls back to `vim.fn.stdpath 'data' .. '/lazy/kznllm/templates'` when the plugin is not locally installed
      local TEMPLATE_DIRECTORY = Path:new(vim.fn.expand(self.dir) .. '/templates')

      -- edit this to change the selected preset (or just fork the repo and add your own)
      local SELECTED_PRESET = presets[1]
      local spec = require(('kznllm.specs.%s'):format(SELECTED_PRESET.provider))

      local function switch_presets()
        table.sort(presets, function(a, _)
          return a == SELECTED_PRESET
        end)
        vim.ui.select(presets, {
          format_item = function(item)
            local options = {}
            for k, v in pairs(item.opts.data_params or {}) do
              if type(v) == 'number' then
                local k_parts = {}
                local k_split = vim.split(k, '_')
                for i, term in ipairs(k_split) do
                  if i > 1 then
                    table.insert(k_parts, term:sub(0, 3))
                  else
                    table.insert(k_parts, term:sub(0, 4))
                  end
                end
                table.insert(options, ('%-5s %-5s'):format(table.concat(k_parts, '_'), v))
              end
            end
            table.sort(options)
            return ('%-20s %10s | %s'):format(item.id, item.provider, table.concat(options, ' '))
          end,
        }, function(choice)
          if not choice then
            return
          end
          spec = require(('kznllm.specs.%s'):format(choice.provider))
          SELECTED_PRESET = choice
          print(('%-15s provider: %-10s'):format(choice.id, choice.provider))
        end)
      end

      vim.keymap.set({ 'n', 'v' }, '<leader>m', switch_presets, { desc = 'switch between presets' })

      local function llm_fill()
        presets.invoke_llm(
          SELECTED_PRESET.make_data_fn,
          spec.make_curl_args,
          spec.make_job,
          vim.tbl_extend('keep', SELECTED_PRESET.opts, {
            template_directory = TEMPLATE_DIRECTORY,
          })
        )
      end

      vim.keymap.set({ 'n', 'v' }, '<leader>k', llm_fill, { desc = 'Send current selection to LLM llm_fill' })

      -- optional for debugging purposes
      local function debug()
        presets.invoke_llm(
          SELECTED_PRESET.make_data_fn,
          spec.make_curl_args,
          spec.make_job,
          vim.tbl_extend('keep', SELECTED_PRESET.opts, {
            template_directory = TEMPLATE_DIRECTORY,
            debug = true,
          })
        )
      end

      vim.keymap.set({ 'n', 'v' }, '<leader>d', debug, { desc = 'Send current selection to LLM debug' })

      vim.api.nvim_set_keymap('n', '<Esc>', '', {
        noremap = true,
        silent = true,
        callback = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'LLM_Escape' })
        end,
      })
    end,
  },
}
