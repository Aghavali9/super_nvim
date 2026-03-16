-- lua/config/snippets.lua
-- LuaSnip snippets organised by filetype

local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node

-- ── Markdown ─────────────────────────────────────────────────────────────────

ls.add_snippets("markdown", {

    -- 2-column, 2-row table
    s("tbl2x2", {
        t("| "), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t({ " |", "" }),
        t("| --- | --- |"),
        t({ "", "| " }), i(3, ""), t(" | "), i(4, ""), t({ " |", "" }),
        t("| "), i(5, ""), t(" | "), i(6, ""), t(" |"),
    }),

    -- 3-column, 2-row table
    s("tbl3x2", {
        t("| "), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t(" | "), i(3, "Header 3"), t({ " |", "" }),
        t("| --- | --- | --- |"),
        t({ "", "| " }), i(4, ""), t(" | "), i(5, ""), t(" | "), i(6, ""), t({ " |", "" }),
        t("| "), i(7, ""), t(" | "), i(8, ""), t(" | "), i(9, ""), t(" |"),
    }),

    -- 3-column, 3-row table
    s("tbl3x3", {
        t("| "), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t(" | "), i(3, "Header 3"), t({ " |", "" }),
        t("| --- | --- | --- |"),
        t({ "", "| " }), i(4, ""), t(" | "), i(5, ""), t(" | "), i(6, ""), t({ " |", "" }),
        t("| "), i(7, ""), t(" | "), i(8, ""), t(" | "), i(9, ""), t({ " |", "" }),
        t("| "), i(10, ""), t(" | "), i(11, ""), t(" | "), i(12, ""), t(" |"),
    }),

    -- Quick 2-column starter table
    s("tbl", {
        t("| "), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t({ " |", "" }),
        t("| --- | --- |"),
        t({ "", "| " }), i(3, ""), t(" | "), i(4, ""), t(" |"),
    }),

})

-- ── Python ───────────────────────────────────────────────────────────────────

ls.add_snippets("python", {

    -- Function with docstring
    s("def", {
        t("def "), i(1, "func_name"), t("("), i(2, ""), t({ "):", "" }),
        t('    """'), i(3, "Summary."), t({ '"""', "" }),
        t("    "), i(4, "pass"),
    }),

    -- Class with __init__
    s("class", {
        t("class "), i(1, "ClassName"), t({ ":", "" }),
        t('    """'), i(2, "Class description."), t({ '"""', "" }),
        t({ "", "    def __init__(self):", "" }),
        t("        "), i(3, "pass"),
    }),

    -- Main guard
    s("main", {
        t({ 'if __name__ == "__main__":', "    " }), i(1, "main()"),
    }),

    -- pytest test function
    s("test", {
        t("def test_"), i(1, "name"), t({ "():", "" }),
        t("    # Arrange"), t({ "", "" }),
        t("    "), i(2, ""), t({ "", "" }),
        t("    # Act"), t({ "", "" }),
        t("    "), i(3, "result = None"), t({ "", "" }),
        t("    # Assert"), t({ "", "" }),
        t("    assert "), i(4, "result is not None"),
    }),

    -- Property decorator pair
    s("prop", {
        t("@property"), t({ "", "def " }), i(1, "name"), t({ "(self):", "" }),
        t("    return self._"), f(function(args) return args[1][1] end, { 1 }),
        t({ "", "", "@" }), f(function(args) return args[1][1] end, { 1 }),
        t(".setter"), t({ "", "def " }), f(function(args) return args[1][1] end, { 1 }),
        t("(self, value):"), t({ "", "    self._" }),
        f(function(args) return args[1][1] end, { 1 }), t(" = value"),
    }),

})

-- ── Lua ──────────────────────────────────────────────────────────────────────

ls.add_snippets("lua", {

    -- Local function
    s("fn", {
        t("local function "), i(1, "name"), t("("), i(2, ""), t({ ")", "    " }),
        i(3, ""), t({ "", "end", "" }),
    }),

    -- Module pattern
    s("mod", {
        t({ "local M = {}", "", "" }),
        t("function M."), i(1, "setup"), t("("), i(2, "opts"), t({ ")", "" }),
        t({ "    ", "" }),
        t({ "end", "", "" }),
        t({ "return M", "" }),
    }),

    -- require shorthand
    s("req", {
        t("local "), i(1, "mod"), t(' = require("'), i(2, "module"), t('")'),
    }),

    -- vim.keymap.set
    s("kmap", {
        t('vim.keymap.set("'), i(1, "n"), t('", "'), i(2, "<leader>"), i(3, "x"),
        t('", '), i(4, "function() end"),
        t(', { desc = "'), i(5, "Description"), t('" })'),
    }),

})

-- ── C ────────────────────────────────────────────────────────────────────────

ls.add_snippets("c", {

    -- main function
    s("main", {
        t({ '#include <stdio.h>', '#include <stdlib.h>', "", "" }),
        t({ "int main(int argc, char *argv[]) {", "    " }), i(1, ""),
        t({ "", "    return 0;", "}" }),
    }),

    -- for loop
    s("for", {
        t("for (int "), i(1, "i"), t(" = "), i(2, "0"), t("; "),
        f(function(args) return args[1][1] end, { 1 }),
        t(" < "), i(3, "n"), t("; "),
        f(function(args) return args[1][1] end, { 1 }),
        t({ "++) {", "    " }), i(4, ""), t({ "", "}" }),
    }),

    -- struct
    s("struct", {
        t("typedef struct {"), t({ "", "    " }), i(1, ""),
        t({ "", "} " }), i(2, "Name"), t(";"),
    }),

    -- printf
    s("pr", {
        t('printf("'), i(1, "%s\\n"), t('", '), i(2, ""), t(");"),
    }),

})

-- ── C++ ──────────────────────────────────────────────────────────────────────

ls.add_snippets("cpp", {

    -- main function
    s("main", {
        t({ "#include <iostream>", "", "" }),
        t({ "int main(int argc, char* argv[]) {", "    " }),
        i(1, ""),
        t({ "", "    return 0;", "}" }),
    }),

    -- class
    s("class", {
        t("class "), i(1, "Name"), t({ " {", "public:", "    " }),
        f(function(args) return args[1][1] end, { 1 }), t("();"),
        t({ "", "    ~" }), f(function(args) return args[1][1] end, { 1 }), t("();"),
        t({ "", "", "private:", "    " }), i(2, ""),
        t({ "", "};" }),
    }),

    -- for range loop
    s("forr", {
        t("for (auto& "), i(1, "item"), t(" : "), i(2, "container"), t({ ") {", "    " }),
        i(3, ""), t({ "", "}" }),
    }),

    -- cout
    s("co", {
        t("std::cout << "), i(1, ""), t(' << std::endl;'),
    }),

    -- namespace block
    s("ns", {
        t("namespace "), i(1, "name"), t({ " {", "", "} // namespace " }),
        f(function(args) return args[1][1] end, { 1 }),
    }),

})

-- ── Java ─────────────────────────────────────────────────────────────────────

ls.add_snippets("java", {

    -- public class with main
    s("main", {
        t("public class "), i(1, "Main"), t({ " {", "" }),
        t("    public static void main(String[] args) {"),
        t({ "", "        " }), i(2, ""),
        t({ "", "    }", "}" }),
    }),

    -- for-each loop
    s("fore", {
        t("for ("), i(1, "Type"), t(" "), i(2, "item"), t(" : "), i(3, "collection"),
        t({ ") {", "    " }), i(4, ""), t({ "", "}" }),
    }),

    -- System.out.println
    s("sout", {
        t("System.out.println("), i(1, ""), t(");"),
    }),

    -- getter + setter pair
    s("gs", {
        t("public "), i(1, "Type"), t(" get"), i(2, "Field"), t({ "() {", "" }),
        t("    return "), f(function(args)
            local s2 = args[1][1] or ""
            return s2:sub(1, 1):lower() .. s2:sub(2)
        end, { 2 }), t({ ";", "}", "", "" }),
        t("public void set"), f(function(args) return args[1][1] or "" end, { 2 }),
        t("("), f(function(args) return args[1][1] or "" end, { 1 }),
        t(" "), f(function(args)
            local s2 = args[1][1] or ""
            return s2:sub(1, 1):lower() .. s2:sub(2)
        end, { 2 }), t({ ") {", "" }),
        t("    this."), f(function(args)
            local s2 = args[1][1] or ""
            return s2:sub(1, 1):lower() .. s2:sub(2)
        end, { 2 }), t(" = "),
        f(function(args)
            local s2 = args[1][1] or ""
            return s2:sub(1, 1):lower() .. s2:sub(2)
        end, { 2 }), t({ ";", "}" }),
    }),

    -- JUnit 5 test method
    s("test", {
        t({ "@Test", "void test" }), i(1, "Name"), t({ "() {", "" }),
        t("    // Arrange"), t({ "", "    " }), i(2, ""),
        t({ "", "    // Act", "    " }), i(3, ""),
        t({ "", "    // Assert", "    " }), i(4, "Assertions.assertNotNull(null);"),
        t({ "", "}" }),
    }),

})
