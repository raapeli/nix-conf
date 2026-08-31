{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.neovim = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
    inherit pkgs;
      module = {
        colorschemes.gruvbox.enable = true;

        opts = {
          number = true;
          relativenumber = true;
          shiftwidth = 2;
          tabstop = 2;
          expandtab = true;
          autoindent = true;
          wrap = true;
          mouse = "a";
          clipboard = "unnamedplus";
          splitright = true;
          splitbelow = true;
          termguicolors = true;
          hidden = true;
          swapfile = false;
          undofile = true;
          scrolloff = 8;
          updatetime = 300;
          signcolumn = "yes";
        };

        globals = {
          mapleader = " ";
          maplocalleader = " ";
        };

        keymaps = [
          {
            mode = "n";
            key = "L";
            action = "<cmd>BufferLineCycleNext<CR>";
            options.desc = "Next buffer";
          }
          {
            mode = "n";
            key = "H";
            action = "<cmd>BufferLineCyclePrev<CR>";
            options.desc = "Prev buffer";
          }
          {
            mode = "n";
            key = "<leader>w";
            action = "<cmd>w<CR>";
            options.desc = "Save";
          }
          {
            mode = "n";
            key = "<leader>q";
            action = "<cmd>q<CR>";
            options.desc = "Quit";
          }
          {
            mode = "n";
            key = "<leader>e";
            action = "<cmd>Oil<CR>";
            options.desc = "File explorer";
          }
          {
            mode = "n";
            key = "<leader>ff";
            action = "<cmd>Telescope find_files<CR>";
            options.desc = "Find files";
          }
          {
            mode = "n";
            key = "<leader>fg";
            action = "<cmd>Telescope live_grep<CR>";
            options.desc = "Live grep";
          }
          {
            mode = "n";
            key = "<leader>fb";
            action = "<cmd>Telescope buffers<CR>";
            options.desc = "Find buffers";
          }
          {
            mode = "n";
            key = "<leader>fh";
            action = "<cmd>Telescope help_tags<CR>";
            options.desc = "Help tags";
          }
          {
            mode = "n";
            key = "K";
            action = "<cmd>lua vim.lsp.buf.hover()<CR>";
            options.desc = "LSP hover";
          }
          {
            mode = "n";
            key = "gd";
            action = "<cmd>lua vim.lsp.buf.definition()<CR>";
            options.desc = "LSP definition";
          }
          {
            mode = "n";
            key = "gD";
            action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
            options.desc = "LSP declaration";
          }
          {
            mode = "n";
            key = "<leader>ca";
            action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
            options.desc = "LSP code action";
          }
          {
            mode = "n";
            key = "<leader>rn";
            action = "<cmd>lua vim.lsp.buf.rename()<CR>";
            options.desc = "LSP rename";
          }
          {
            mode = "n";
            key = "gi";
            action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
            options.desc = "LSP implementation";
          }
          {
            mode = "n";
            key = "gt";
            action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
            options.desc = "LSP type definition";
          }
          {
            mode = "n";
            key = "<leader>d";
            action = "<cmd>lua vim.diagnostic.open_float()<CR>";
            options.desc = "Diagnostic float";
          }
          {
            mode = "n";
            key = "]d";
            action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
            options.desc = "Next diagnostic";
          }
          {
            mode = "n";
            key = "[d";
            action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
            options.desc = "Prev diagnostic";
          }
          {
            mode = "n";
            key = "]c";
            action = "<cmd>Gitsigns next_hunk<CR>";
            options.desc = "Next hunk";
          }
          {
            mode = "n";
            key = "[c";
            action = "<cmd>Gitsigns prev_hunk<CR>";
            options.desc = "Prev hunk";
          }
          {
            mode = "n";
            key = "<leader>hs";
            action = "<cmd>Gitsigns stage_hunk<CR>";
            options.desc = "Stage hunk";
          }
          {
            mode = "v";
            key = "<leader>hs";
            action = "<cmd>Gitsigns stage_hunk<CR>";
            options.desc = "Stage hunk";
          }
          {
            mode = "n";
            key = "<leader>hr";
            action = "<cmd>Gitsigns reset_hunk<CR>";
            options.desc = "Reset hunk";
          }
          {
            mode = "n";
            key = "<leader>hb";
            action = "<cmd>Gitsigns blame_line<CR>";
            options.desc = "Blame";
          }
          {
            mode = "n";
            key = "<leader>hd";
            action = "<cmd>Gitsigns diffthis<CR>";
            options.desc = "Diff this";
          }
        ];

        autoGroups = {
          lsp_attach = {};
        };

        autoCmd = [
          {
            event = "LspAttach";
            group = "lsp_attach";
            callback.__raw = ''
              function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client.server_capabilities.inlayHintProvider then
                  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
              end
            '';
          }
        ];

        plugins = {
          lualine.enable = true;

          bufferline.enable = true;

          which-key.enable = true;

          telescope.enable = true;

          treesitter = {
            enable = true;
            settings = {
              highlight.enable = true;
              indent.enable = true;
            };
          };

          lsp = {
            enable = true;
            servers = {
              gopls.enable = true;
              rust_analyzer = {
                enable = true;
                installCargo = true;
                installRustc = true;
              };
              nil_ls.enable = true;
              nixd.enable = true;
              pyright.enable = true;
              ts_ls.enable = true;
              lua_ls.enable = true;
            };
          };

          cmp = {
            enable = true;
            settings = {
              mapping = {
                "<C-b>" = "cmp.mapping.scroll_docs(-4)";
                "<C-f>" = "cmp.mapping.scroll_docs(4)";
                "<C-Space>" = "cmp.mapping.complete()";
                "<C-e>" = "cmp.mapping.abort()";
                "<CR>" = "cmp.mapping.confirm({ select = true })";
                "<TAB>" = ''
                  function(fallback)
                    if cmp.visible() then
                      cmp.select_next_item()
                    else
                      fallback()
                    end
                  end
                '';
              };
              sources = [
                {name = "nvim_lsp";}
                {name = "path";}
                {name = "buffer";}
              ];
            };
          };

          oil = {
            enable = true;
            settings.default_file_explorer = true;
          };

          gitsigns = {
            enable = true;
            settings.current_line_blame = true;
          };

          comment.enable = true;

          todo-comments.enable = true;

          mini = {
            enable = true;
            modules = {
              icons = {};
              pairs = {};
            };
          };

          web-devicons.enable = true;

          lean ={
            enable = true;
            settings.mappings = true;
          };
        };
      };
    };
  };
}
