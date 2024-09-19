return {
  {
    'quarto-dev/quarto-nvim',
    -- dev = true,
    dependencies = {
      {
        'jmbuhr/otter.nvim',
        opts = {
          handle_leading_whitespace = true,
          lsp = {
            hover = { border = 'none' },
          },
        },
        dev = false,
      },
      'nvim-cmp',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
      {
        'nvimtools/hydra.nvim',
        config = function()
          local function keys(str)
            return function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), 'm', true)
            end
          end

          local hydra = require 'hydra'
          hydra {
            name = 'QuartoNavigator',
            hint = [[
      _j_/_k_: move down/up  _r_: run cell
      _l_: run line  _R_: run above
      ^^     _<esc>_/_q_: exit ]],
            config = {
              color = 'pink',
              invoke_on_body = true,
              hint = {
                border = 'rounded', -- you can change the border if you want
              },
            },
            mode = { 'n' },
            body = '<localleader>j', -- this is the key that triggers the hydra
            heads = {
              { 'j', keys ']b' },
              { 'k', keys '[b' },
              { 'r', ':QuartoSend<CR>' },
              { 'l', ':QuartoSendLine<CR>' },
              { 'R', ':QuartoSendAbove<CR>' },
              { '<esc>', nil, { exit = true } },
              { 'q', nil, { exit = true } },
            },
          }
        end,
      },
    },
    ft = { 'quarto', 'markdown', 'norg' },
    config = function()
      local quarto = require 'quarto'
      quarto.setup {
        lspFeatures = {
          languages = { 'python', 'rust', 'lua' },
          chunks = 'all', -- 'curly' or 'all'
          diagnostics = {
            enabled = true,
            triggers = { 'BufWritePost' },
          },
          completion = {
            enabled = true,
          },
        },
        keymap = {
          hover = 'H',
          definition = 'gd',
          rename = '<leader>rn',
          references = 'gr',
          format = '<leader>gf',
        },
        codeRunner = {
          enabled = true,
          ft_runners = {
            bash = 'slime',
          },
          default_method = 'molten',
        },
      }

      vim.keymap.set('n', '<localleader>qp', quarto.quartoPreview, { desc = 'Preview the Quarto document', silent = true, noremap = true })
      -- to create a cell in insert mode, I have the ` snippet
      vim.keymap.set('n', '<localleader>cc', 'i`<c-j>', { desc = 'Create a new code cell', silent = true })
      vim.keymap.set('n', '<localleader>cs', 'i```\r\r```{}<left>', { desc = 'Split code cell', silent = true, noremap = true })
    end,
  },

  {
    'benlubas/molten-nvim',
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.keymap.set('n', '<localleader>mi', ':MoltenInit<CR>', { silent = true, desc = 'Initialize the plugin' })
      vim.keymap.set('n', '<localleader>e', ':MoltenEvaluateOperator<CR>', { silent = true, desc = 'run operator selection' })
      vim.keymap.set('n', '<localleader>rl', ':MoltenEvaluateLine<CR>', { silent = true, desc = 'evaluate line' })
      vim.keymap.set('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { silent = true, desc = 're-evaluate cell' })
      vim.keymap.set('v', '<localleader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', { silent = true, desc = 'evaluate visual selection' })
      vim.keymap.set('n', '<localleader>oh', ':MoltenHideOutput<CR>', { desc = 'close output window', silent = true })
      vim.keymap.set('n', '<localleader>md', ':MoltenDelete<CR>', { desc = 'delete Molten cell', silent = true })
      -- automatically import output chunks from a jupyter notebook
      -- tries to find a kernel that matches the kernel in the jupyter notebook
      -- falls back to a kernel that matches the name of the active venv (if any)
      local imb = function(e) -- init molten buffer
        vim.schedule(function()
          local kernels = vim.fn.MoltenAvailableKernels()
          local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, 'r'):read 'a')['metadata']
            return metadata.kernelspec.name
          end
          local ok, kernel_name = pcall(try_kernel_name)
          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            local venv = os.getenv 'VIRTUAL_ENV'
            if venv ~= nil then
              kernel_name = string.match(venv, '/.+/(.+)')
            end
          end
          if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(('MoltenInit %s'):format(kernel_name))
          end
          vim.cmd 'MoltenImportOutput'
        end)
      end

      -- automatically import output chunks from a jupyter notebook
      vim.api.nvim_create_autocmd('BufAdd', {
        pattern = { '*.ipynb' },
        callback = imb,
      })

      -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.ipynb' },
        callback = function(e)
          if vim.api.nvim_get_vvar 'vim_did_enter' ~= 1 then
            imb(e)
          end
        end,
      })
      -- automatically export output chunks to a jupyter notebook on write
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.ipynb' },
        callback = function()
          if require('molten.status').initialized() == 'Molten' then
            vim.cmd 'MoltenExportOutput!'
          end
        end,
      })
      --[[
      
      -- change the configuration when editing a python file
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*.py',
        callback = function(e)
          if string.match(e.file, '.otter.') then
            return
          end
          if require('molten.status').initialized() == 'Molten' then -- this is kinda a hack...
            vim.fn.MoltenUpdateOption('virt_lines_off_by_1', false)
            vim.fn.MoltenUpdateOption('virt_text_output', false)
          else
            vim.g.molten_virt_lines_off_by_1 = false
            vim.g.molten_virt_text_output = false
          end
        end,
      })

     --]]

      -- Undo those config changes when we go back to a markdown or quarto file
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.qmd', '*.md', '*.ipynb' },
        callback = function(e)
          if string.match(e.file, '.otter.') then
            return
          end
          if require('molten.status').initialized() == 'Molten' then
            vim.fn.MoltenUpdateOption('virt_lines_off_by_1', true)
            vim.fn.MoltenUpdateOption('virt_text_output', true)
          else
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_output = true
          end
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MoltenInitPost',
        callback = function()
          -- quarto code runner mappings
          local r = require 'quarto.runner'
          vim.keymap.set('n', '<localleader>rc', r.run_cell, { desc = 'run cell', silent = true })
          vim.keymap.set('n', '<localleader>ra', r.run_above, { desc = 'run cell and above', silent = true })
          vim.keymap.set('n', '<localleader>rb', r.run_below, { desc = 'run cell and below', silent = true })
          vim.keymap.set('n', '<localleader>rl', r.run_line, { desc = 'run line', silent = true })
          vim.keymap.set('n', '<localleader>rA', r.run_all, { desc = 'run all cells', silent = true })
          vim.keymap.set('n', '<localleader>RA', function()
            r.run_all(true)
          end, { desc = 'run all cells of all languages', silent = true })

          -- setup some molten specific keybindings
          vim.keymap.set('n', '<localleader>e', ':MoltenEvaluateOperator<CR>', { desc = 'evaluate operator', silent = true })
          vim.keymap.set('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { desc = 're-eval cell', silent = true })
          vim.keymap.set('v', '<localleader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'execute visual selection', silent = true })
          vim.keymap.set('n', '<localleader>os', ':noautocmd MoltenEnterOutput<CR>', { desc = 'open output window', silent = true })
          vim.keymap.set('n', '<localleader>oh', ':MoltenHideOutput<CR>', { desc = 'close output window', silent = true })
          vim.keymap.set('n', '<localleader>md', ':MoltenDelete<CR>', { desc = 'delete Molten cell', silent = true })
          local open = false
          vim.keymap.set('n', '<localleader>ot', function()
            open = not open
            vim.fn.MoltenUpdateOption('auto_open_output', open)
          end)

          -- if we're in a python file, change the configuration a little
          if vim.bo.filetype == 'python' then
            vim.fn.MoltenUpdateOption('molten_virt_lines_off_by_1', false)
            vim.fn.MoltenUpdateOption('molten_virt_text_output', false)
          end
        end,
      })
    end,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    '3rd/image.nvim',
    opts = {
      backend = 'kitty', -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },
  {
    'GCBallesteros/jupytext.nvim',
    opts = {
      custom_language_formatting = {
        python = {
          extension = 'md',
          style = 'markdown',
          force_ft = 'markdown', -- you can set whatever filetype you want here
        },
      },
    },
  },
}
