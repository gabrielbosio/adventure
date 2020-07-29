--[[--
 Replace Lua 5.1 module function with "The Basic Approach" (PiL 4th ed).

 This script assumes that module variables and functions are declared global,
 and that their declarations start immediatly, without spaces, comments, and
 weird stuff. So it's an almost useless script, because it doesn't really
 analyze the code nor extract variable names. If that's what you want, maybe
 writing your own script for your own needs would be better.
 @script moduleclean
 @author Federico A. Bosio
 @license GPLv3
]]

--- @usage
local usage = [[moduleclean.lua <luaFile> [<output>]

  Default <output> is stdout
]]

local input = arg[1]
if not input then
  print("Usage: " .. usage)
  return
end
io.input(input)

local output = ""
local deprecated = "^module%(%s*[^,]+,%s*package.seeall%s*%)"
local deprecationsNum = 0
for line in io.lines() do
  -- Look for the deprecated pattern
  local addedOutput
  if deprecationsNum == 0 then
    addedOutput, deprecationsNum = string.gsub(line, deprecated, "local M = {}")
  else
    -- Add nonlocal fields to the module table
    addedOutput = string.gsub(string.gsub(line, "^(function%s+)", "%1M."),
      "^(%S+%s*=)", "M.%1")
  end

  -- Look for global require statements
  local m, n = string.gsub(addedOutput, '^require%s*%(?"(.+)".*$', "%1")
  if n > 0 then
    -- and make them local, when found
    addedOutput = string.format('local %s = require "%s"',
      string.gsub(m, ".+%.([^.]+)$", "%1"), m)
  end


  output = output .. addedOutput .. "\n"
end

if deprecationsNum > 0 then
  output = output .. "\nreturn M\n"
end

io.output(arg[2])  -- to stdout if nil
io.write(output)
