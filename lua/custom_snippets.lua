-- lua/custom_snippets.lua

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep -- The mirroring tool

-- 1. C Language Snippets
ls.add_snippets("c", {
    
    -- The Main Boilerplate
    s("boiler", {
        t({
            "#include <stdio.h>",
            "#include <stdlib.h>",
            "",
            "int main(int argc, char *argv[]) {",
            "\t"
        }),
        i(1, "// Start coding here..."),
        t({
            "",
            "\treturn 0;",
            "}"
        })
    }),

    -- The Header Guard Boilerplate
    s("head", {
        t("#ifndef "), i(1, "HEADER_NAME_H"),
        t({"", "#define "}), rep(1), -- Instantly mirrors what you type in i(1)
        t({"", "", ""}),
        i(2, "// Declarations..."),
        t({"", "", "#endif // "}), rep(1) -- Mirrors it again at the bottom
    }),

})
