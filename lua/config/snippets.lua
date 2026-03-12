-- lua/config/snippets.lua
-- LuaSnip markdown table snippets

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("markdown", {

    -- 2-column, 2-row table
    s("tbl2x2", {
        t("| "), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t({ " |", "" }),
        t("| --- | --- |"),
        t({ "", "| " }), i(3, ""), t(" | "), i(4, ""), t({ " |", "" }),
        t("| "), i(5, ""), t(" | "), i(6, ""), t(" |"),
    }),

    -- 3-column, 2-row table  (tbl3x2)
    s("tbl3x2", {
        t("| "), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t(" | "), i(3, "Header 3"), t({ " |", "" }),
        t("| --- | --- | --- |"),
        t({ "", "| " }), i(4, ""), t(" | "), i(5, ""), t(" | "), i(6, ""), t({ " |", "" }),
        t("| "), i(7, ""), t(" | "), i(8, ""), t(" | "), i(9, ""), t(" |"),
    }),

    -- 3-column, 3-row table  (tbl3x3)
    s("tbl3x3", {
        t("| "), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t(" | "), i(3, "Header 3"), t({ " |", "" }),
        t("| --- | --- | --- |"),
        t({ "", "| " }), i(4, ""), t(" | "), i(5, ""), t(" | "), i(6, ""), t({ " |", "" }),
        t("| "), i(7, ""), t(" | "), i(8, ""), t(" | "), i(9, ""), t({ " |", "" }),
        t("| "), i(10, ""), t(" | "), i(11, ""), t(" | "), i(12, ""), t(" |"),
    }),

    -- Dynamic table: prompts for dimensions via nested insert nodes
    s("tbl", {
        t("| "), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t({ " |", "" }),
        t("| --- | --- |"),
        t({ "", "| " }), i(3, ""), t(" | "), i(4, ""), t(" |"),
    }),

})
