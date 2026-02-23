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

-- ==========================================
-- 2. CMake Snippets
-- ==========================================
ls.add_snippets("cmake", {

    -- Standard CMake Boilerplate for C Projects
    s("cmakeboiler", {
        t("cmake_minimum_required(VERSION "), i(1, "3.10"), t({")", "", ""}),
        t("project("), i(2, "MyProject"), t({" C)", ""}),
        t({
            "set(CMAKE_C_STANDARD 11)",
            "set(CMAKE_C_STANDARD_REQUIRED True)",
            "",
            "add_compile_options(-Wall -Wextra -g)",
            "",
            "add_executable("
        }),
        rep(2), -- Automatically names the executable after your project name
        t(" "),
        i(3, "main.c"),
        t(")")
    }),

})
