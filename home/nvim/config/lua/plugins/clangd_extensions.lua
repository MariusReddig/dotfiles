require("clangd_extensions").setup({
    role_icons = {
        type = "",
        declaration = "",
        expression = "",
        specifier = "",
        statement = "",
        ["template argument"] = " ",
    },

    kind_icons = {
        Compound = "",
        Recovery = "",
        TranslationUnit = "",
        PackExpansion = " ",
        TemplateTypeParm = " ",
        TemplateTemplateParm = " ",
        TemplateParamObject = " ",
    },
    inlay_hints = {
        inline = false,
        only_current_line = false,
        show_parameter_hints = true,
        parameter_hints_prefix = "← ",
        other_hints_prefix = "→ ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
    },
})
