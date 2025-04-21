  require("colorizer").setup({
    filetypes = { "*" },                   -- Enable for all filetypes
    user_default_options = {
      RGB      = true,                     -- #RGB hex codes
      RRGGBB   = true,                     -- #RRGGBB hex codes
      names    = true,                     -- "red", "blue" color names
      RRGGBBAA = true,                     -- #RRGGBBAA (transparency)
      rgb_fn   = true,                     -- CSS rgb()/rgba() functions
      hsl_fn   = true,                     -- CSS hsl()/hsla() functions
      mode     = "background",             -- Display as background (or "foreground"/"virtualtext")
      tailwind = true,                     -- Enable Tailwind color parsing
      sass = { enable = true },            -- Sass/SCSS specific settings
      virtualtext = "●",                   -- Custom symbol for virtualtext mode
    },
  })
