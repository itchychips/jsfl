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

local jsfl = {}

local json = require("json")

jsfl.debug = false

local function d(message)
    if jsfl.debug then
        print("DEBUG: " .. tostring(message))
    end
end

local function escape_value(value)
    if not value then
        return nil
    end
    return string.gsub(value, "\n", "\\n"):gsub('"', '\\"')
end

function jsfl.table_to_string(tt, path)
    local buffer = ""

    path = path or ""

    d(path)

    for index,value in pairs(tt) do
        if type(value) == "table" then
            buffer = buffer .. jsfl.table_to_string(value, path .. "." .. escape_value(index))
        else
            if type(index) == "number" then
                index = "[" .. tostring(index) .. "]"
            else
                index = "." .. escape_value(index)
            end

            if type(value) == "string" then
                value = escape_value(value)
                buffer = buffer .. path .. index .. ": \"" .. value .. "\"\n"
            else
                buffer = buffer .. path .. index .. ": " .. tostring(value) .. "\n"
            end
        end
    end

    return buffer
end

return jsfl
