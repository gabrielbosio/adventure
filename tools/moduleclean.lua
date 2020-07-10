--- Replace Lua 5.1 module function with "The Basic Approach" (PiL 4th ed)
-- This script assumes that module variables and functions are declared global,
-- and that their declarations start immediatly, without spaces, comments, and
-- weird stuff. If you don't like this style restriction, it's your problem.
-- @author Federico A. Bosio
-- @script moduleclean
-- @usage
local usage = [[Usage: moduleclean.lua <luaFile> [<output>]
  Default <output> is stdout]]

local deprecated = "^module%(%s*[^,]+(,%s*package.seeall%s*%)?)"
local foundDeprecated = false

local input = arg[1]
if not input then
  print(usage)
  return
end
io.input(input)
output = ""

for line in io.lines() do
  -- Look for the deprecated pattern
  if not foundDeprecated then
    local s, n = string.gsub(line, deprecated, "local M = {}")
    output = output .. s .. "\n"
    foundDeprecated = n > 0
  else
    -- Add nonlocal fields to the module table
    local s = string.gsub(string.gsub(line, "^(function%s+)", "%1M."),
      "^(%S+%s*=)", "M.%1")
    output = output .. s .. "\n"
  end
end

if foundDeprecated then
  io.output(arg[2])  -- to stdout if nil
  io.write(output, "\nreturn M\n")
end

