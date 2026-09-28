require("colorizer").setup({
    user_default_options = {
      RRGGBBAA = true,                     -- #RRGGBBAA (transparency)
      rgb_fn   = true,                     -- CSS rgb()/rgba() functions
      hsl_fn   = true,                     -- CSS hsl()/hsla() functions
      tailwind = true,                     -- Enable Tailwind color parsing
      mode     = "virtualtext",             -- Display as background (or "foreground"/"virtualtext")
      virtualtext = "●",                   -- Custom symbol for virtualtext mode
    },
  })
