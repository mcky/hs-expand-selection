default:
    @just --list

test:
    busted tests.lua

test-watch:
    fd -e .lua | entr -r busted tests.lua

format:
    stylua *.lua

format-check:
    stylua --check *.lua

install-deps:
    luarocks install busted
    luarocks install luacheck

lint:
    luacheck *.lua

build:
    luarocks make hs-expand-selection-0.1.0-1.rockspec

clean:
    rm -rf ./lua_modules
    rm -rf ./.luarocks

check: lint format-check test
    @echo "All checks passed!"
