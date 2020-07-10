--- Replace Lua 5.1 module function with "The Basic Approach" (PiL 4th ed)
-- This script assumes that module variables and functions are declared global,
-- and that their declarations start immediatly, without spaces, comments, and
-- weird stuff. If you don't link this coding style restriction, I don't care.
-- @author Federico A. Bosio
-- @script moduleclean

local deprecated = "^%s*module%(%s*[^,]+(,%s*package.seeall%s*%)?)"
local foundDeprecated = false

io.input(arg[1])

for line in io.lines() do
  -- Look for the deprecated pattern
  if not foundDeprecated then
    local s, n = string.gsub(line, deprecated, "local M = {}")
    io.write(s, "\n")
    foundDeprecated = n > 0
  else
    -- Add nonlocal fields to the module table
    local s = string.gsub(string.gsub(line, "^(function%s+)", "%1M."),
      "^(%S+%s*=)", "M.%1")

    io.write(s, "\n")
  end  -- if not foundDeprecated
end  -- for

io.write("\nreturn M\n")
