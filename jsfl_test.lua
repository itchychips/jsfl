-- This file is part of jsfl
--
-- jsfl - convert JSON to a flattened, mostly greppable language
-- Copyright (C) 2023  Donny Johnson
--
-- This program is free software: you can redistribute it and/or modify it
-- under the terms of the GNU Affero General Public License as published by the
-- Free Software Foundation, either version 3 of the License, or (at your
-- option) any later version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-- FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License
-- for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

local json = require("json")
local jsfl = require("jsfl")

local function pcall_test(name, fn)
    local success,message = pcall(fn)

    if success then
        print("Test '" .. name .. "' succeeded.")
    else
        print("Test '" .. name .. "' failed: " .. message)
    end

    return success
end

local function test()
    local result = true
    result = result and pcall_test("empty",
        function()
            local before = json.decode("{}")
            local after = jsfl.table_to_string(before)
            assert(after == "")
        end)

    result = result and pcall_test("simple_values",
        function()
            local before = json.decode('{"a": 1, "b": 2, "c": "three"}')
            local after = jsfl.table_to_string(before)
            local lines = {}
            for line in string.gmatch(after, "(.-)\n") do
                table.insert(lines, line)
            end
            table.sort(lines)
            assert(#lines == 3)
            assert(lines[1] == ".a: 1")
            assert(lines[2] == ".b: 2")
            assert(lines[3] == ".c: \"three\"")
        end)

    result = result and pcall_test("nested_value",
        function()
            local before = json.decode('{"a": {"b": "nested"}}')
            local after = jsfl.table_to_string(before)
            local lines = {}
            for line in string.gmatch(after, "(.-)\n") do
                table.insert(lines, line)
            end
            table.sort(lines)
            assert(#lines == 1)
            assert(lines[1] == ".a.b: \"nested\"")
        end)

    result = result and pcall_test("nested_array",
        function()
            local before = json.decode('{"a": [2,3,4,5]}')
            local after = jsfl.table_to_string(before)
            local lines = {}
            for line in string.gmatch(after, "(.-)\n") do
                table.insert(lines, line)
            end
            table.sort(lines)
            assert(#lines == 4)
            assert(lines[1] == ".a[1]: 2")
            assert(lines[2] == ".a[2]: 3")
            assert(lines[3] == ".a[3]: 4")
            assert(lines[4] == ".a[4]: 5")
        end)

    result = result and pcall_test("array",
        function()
            local before = json.decode('[2,3,4,5]')
            local after = jsfl.table_to_string(before)
            local lines = {}
            for line in string.gmatch(after, "(.-)\n") do
                table.insert(lines, line)
            end
            table.sort(lines)
            assert(#lines == 4)
            assert(lines[1] == "[1]: 2")
            assert(lines[2] == "[2]: 3")
            assert(lines[3] == "[3]: 4")
            assert(lines[4] == "[4]: 5")
        end)

    result = result and pcall_test("string_with_newlines",
        function()
            local before = json.decode('{"my_string": "a string\\nnew line\\nanother line"}')
            local after = jsfl.table_to_string(before)
            local lines = {}
            for line in string.gmatch(after, "(.-)\n") do
                table.insert(lines, line)
            end
            table.sort(lines)
            assert(#lines == 1)
            assert(lines[1] == ".my_string: \"a string\\nnew line\\nanother line\"")
        end)

    result = result and pcall_test("values_with_quotes",
        function()
            local before = json.decode('{"bob_quote": "Bob said, \\\"Hello there!\\\""}')
            local after = jsfl.table_to_string(before)
            local lines = {}
            for line in string.gmatch(after, "(.-)\n") do
                table.insert(lines, line)
            end
            table.sort(lines)
            assert(#lines == 1)
            assert(lines[1] == ".bob_quote: \"Bob said, \\\"Hello there!\\\"\"")
        end)

    result = result and pcall_test("keys_with_quotes",
        function()
            local before = json.decode('{"bob \\"quote\\"": "I\'m not sure why you\'d put a double quote in a key, but whatevs"}')
            local after = jsfl.table_to_string(before)
            local lines = {}
            for line in string.gmatch(after, "(.-)\n") do
                table.insert(lines, line)
            end
            table.sort(lines)
            assert(#lines == 1)
            assert(lines[1] == ".bob \\\"quote\\\": \"I'm not sure why you'd put a double quote in a key, but whatevs\"")
        end)
end

test()
