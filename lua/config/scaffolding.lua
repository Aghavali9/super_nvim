-- Create only into locations that do not already contain generated targets.
local function preflight(name, paths)
  if not name:match("^[A-Za-z][A-Za-z0-9_-]*$") then
    vim.notify("Project name must start with a letter and contain letters, digits, _ or -", vim.log.levels.ERROR)
    return false
  end
  for _, path in ipairs(paths) do
    if vim.uv.fs_lstat(path) then
      vim.notify("Scaffolding stopped: " .. path .. " already exists. Use an empty directory.", vim.log.levels.WARN)
      return false
    end
  end
  return true
end
local function open_new(path)
  -- Exclusive creation also protects against an intervening file/symlink appearing.
  local fd, err = vim.uv.fs_open(path, "wx", 420)
  assert(fd, err)
  local offset = 0
  return {
    write = function(_, data)
      local count, write_err = vim.uv.fs_write(fd, data, offset)
      assert(count == #data, write_err or "Incomplete scaffold write")
      offset = offset + count
    end,
    close = function() assert(vim.uv.fs_close(fd)) end,
  }
end

-- ─── :CProject [name] ────────────────────────────────────────────────────────
vim.api.nvim_create_user_command("CProject", function(opts)
  local proj_name = opts.args == "" and "MyProject" or opts.args

  if not preflight(proj_name, { "CMakeLists.txt", "src/main.c", ".gitignore" }) then return end
  vim.fn.mkdir("src", "p")
  vim.fn.mkdir("include", "p")

  local cmake_file = open_new("CMakeLists.txt")
  if cmake_file then
    cmake_file:write(string.format([[cmake_minimum_required(VERSION 3.10)
project(%s C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_compile_options(-Wall -Wextra -g)

include_directories(include)

add_executable(%s src/main.c)
]], proj_name, proj_name))
    cmake_file:close()
  end

  local main_c = open_new("src/main.c")
  if main_c then
    main_c:write([[#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    printf("Project initialized successfully.\n");
    return 0;
}
]])
    main_c:close()
  end

  local gitignore = open_new(".gitignore")
  if gitignore then
    gitignore:write("build/\n*.o\n*.a\n*.so\n.cache/\ncompile_commands.json\n")
    gitignore:close()
  end

  print("Scaffolded C project: " .. proj_name)
  vim.cmd("edit src/main.c")
end, { nargs = "?" })

-- ─── :PyProject [name] ───────────────────────────────────────────────────────
vim.api.nvim_create_user_command("PyProject", function(opts)
  local proj_name = opts.args == "" and "myproject" or opts.args
  local pkg_name  = proj_name:lower():gsub("[%-%s]", "_")

  if not preflight(proj_name, { "src/" .. pkg_name, "tests/test_basic.py", "pyproject.toml", ".gitignore" }) then return end
  vim.fn.mkdir("src/" .. pkg_name, "p")
  vim.fn.mkdir("tests", "p")

  local init_py = open_new("src/" .. pkg_name .. "/__init__.py")
  if init_py then
    init_py:write("")
    init_py:close()
  end

  local main_py = open_new("src/" .. pkg_name .. "/__main__.py")
  if main_py then
    main_py:write([[def main():
    print("Project initialized successfully.")


if __name__ == "__main__":
    main()
]])
    main_py:close()
  end

  local test_py = open_new("tests/test_basic.py")
  if test_py then
    test_py:write(string.format([[import pytest
from %s.__main__ import main


def test_main(capsys):
    main()
    captured = capsys.readouterr()
    assert "initialized" in captured.out
]], pkg_name))
    test_py:close()
  end

  local pyproject = open_new("pyproject.toml")
  if pyproject then
    pyproject:write(string.format([[
[build-system]
requires = ["setuptools>=68"]
build-backend = "setuptools.build_meta"

[project]
name = "%s"
version = "0.1.0"
description = "A Python project"
requires-python = ">=3.10"

[tool.setuptools.packages.find]
where = ["src"]

[tool.pytest.ini_options]
pythonpath = ["src"]

[tool.ruff]
line-length = 88

[tool.black]
line-length = 88
]], proj_name))
    pyproject:close()
  end

  local gitignore = open_new(".gitignore")
  if gitignore then
    gitignore:write("__pycache__/\n*.pyc\n*.pyo\n.venv/\ndist/\nbuild/\n*.egg-info/\n.pytest_cache/\n")
    gitignore:close()
  end

  print("Scaffolded Python project: " .. proj_name)
  vim.cmd("edit src/" .. pkg_name .. "/__main__.py")
end, { nargs = "?" })

-- ─── :JavaProject [name] ─────────────────────────────────────────────────────
vim.api.nvim_create_user_command("JavaProject", function(opts)
  local proj_name  = opts.args == "" and "MyProject" or opts.args
  local group_path = "com/example"
  local pkg_name   = "com.example"
  local src_main   = "src/main/java/" .. group_path
  local src_test   = "src/test/java/" .. group_path

  if not preflight(proj_name, { src_main .. "/Main.java", "pom.xml", ".gitignore" }) then return end
  vim.fn.mkdir(src_main, "p")
  vim.fn.mkdir(src_test, "p")

  local main_java = open_new(src_main .. "/Main.java")
  if main_java then
    main_java:write(string.format([[package %s;

public class Main {
    public static void main(String[] args) {
        System.out.println("Project initialized successfully.");
    }
}
]], pkg_name))
    main_java:close()
  end

  local pom = open_new("pom.xml")
  if pom then
    pom:write(string.format([[<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>%s</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <exec.mainClass>com.example.Main</exec.mainClass>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.5</version>
            </plugin>
            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>exec-maven-plugin</artifactId>
                <version>3.1.0</version>
            </plugin>
        </plugins>
    </build>
</project>
]], proj_name:lower()))
    pom:close()
  end

  local gitignore = open_new(".gitignore")
  if gitignore then
    gitignore:write("target/\n*.class\n*.jar\n.gradle/\nbuild/\n.idea/\n*.iml\n")
    gitignore:close()
  end

  print("Scaffolded Java project: " .. proj_name)
  vim.cmd("edit " .. src_main .. "/Main.java")
end, { nargs = "?" })
