-- lua/custom_snippets.lua

return function(ls)
	local s = ls.snippet
	local t = ls.text_node
	local i = ls.insert_node
	local rep = require("luasnip.extras").rep

	ls.add_snippets("c", {
		s("boiler", {
			t({ "#include <stdio.h>", "#include <stdlib.h>", "", "int main(int argc, char *argv[]) {", "\t" }),
			i(1, ""),
			t({ "", "\treturn 0;", "}" }),
		}),
		s("head", {
			t("#ifndef "),
			i(1, "HEADER_NAME_H"),
			t({ "", "#define " }),
			rep(1),
			t({ "", "", "" }),
			i(2, ""),
			t({ "", "", "#endif // " }),
			rep(1),
		}),
	})

	ls.add_snippets("cmake", {
		s("cmakeboiler", {
			t("cmake_minimum_required(VERSION "),
			i(1, "3.10"),
			t({ ")", "", "" }),
			t("project("),
			i(2, "MyProject"),
			t({ " C)", "" }),
			t({
				"set(CMAKE_C_STANDARD 11)",
				"set(CMAKE_C_STANDARD_REQUIRED True)",
				"",
				"add_compile_options(-Wall -Wextra -g)",
				"",
				"add_executable(",
			}),
			rep(2),
			t(" "),
			i(3, "main.c"),
			t(")"),
		}),
	})
end
