return {
  {
    "folke/snacks.nvim",
    ---@param opts table
    opts = function(_, opts)
      local header_default = [[ 
 ██████╗ ██████╗ ███████╗███████╗██╗███████╗   ██████╗ ███████╗██╗   ██╗
██╔════╝██╔═══██╗██╔════╝██╔════╝██║██╔════╝   ██╔══██╗██╔════╝██║   ██║
██║     ██║   ██║█████╗  █████╗  ██║█████╗     ██║  ██║█████╗  ██║   ██║
██║     ██║   ██║██╔══╝  ██╔══╝  ██║██╔══╝     ██║  ██║██╔══╝  ╚██╗ ██╔╝
╚██████╗╚██████╔╝██║     ██║     ██║███████╗██╗██████╔╝███████╗ ╚████╔╝ 
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝     ╚═╝╚══════╝╚═╝╚═════╝ ╚══════╝  ╚═══╝  

      Personal Config
          ]]
      -- https://patorjk.com/software/taag/#p=display&f=ANSI+Shadow&t=Coffie.dev&x=none&v=4&h=4&w=80&we=false

      local header_chargitect = [[
 ██████╗██╗  ██╗ █████╗ ██████╗  ██████╗ ██╗████████╗███████╗ ██████╗████████╗
██╔════╝██║  ██║██╔══██╗██╔══██╗██╔════╝ ██║╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝
██║     ███████║███████║██████╔╝██║  ███╗██║   ██║   █████╗  ██║        ██║   
██║     ██╔══██║██╔══██║██╔══██╗██║   ██║██║   ██║   ██╔══╝  ██║        ██║   
╚██████╗██║  ██║██║  ██║██║  ██║╚██████╔╝██║   ██║   ███████╗╚██████╗   ██║   
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝   ╚═╝   ╚══════╝ ╚═════╝   ╚═╝   

      Chargitect
          ]]
      -- https://patorjk.com/software/taag/#p=display&f=ANSI+Shadow&t=Chargitect&x=none&v=4&h=4&w=80&we=false

      local cwd = vim.fn.getcwd()
      local home = os.getenv("HOME")
      local chargitect_path = home .. "/projects/github.com/chargitect"

      -- Ensure opts structure exists
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}

      -- Check if cwd starts with the chargitect path
      if cwd:sub(1, #chargitect_path) == chargitect_path then
        opts.dashboard.preset.header = header_chargitect
      else
        opts.dashboard.preset.header = header_default
      end

      return opts
    end,
  },
}

