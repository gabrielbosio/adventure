local jsFileName = arg[1]
local luaFileName = arg[2]

if not jsFileName or not luaFileName then
  print("Usage: genspr.lua <jsFileName> <luaFileName>")
  return
end

io.input(jsFileName)
jsContent = string.gsub(io.read("*all"), string.char(0), "")
filtered = string.gsub(jsContent, ".*frames:%s*(%[.*%])}.*$", "%1")
luaContent = string.gsub(filtered, "%[([%d%.,]+)%]", "\n  {%1}")
luaContent = string.gsub(luaContent, "[%[|%]]", {["["] = "{", ["]"] = "\n}\n"})
luaContent = "sprites = " .. string.gsub(luaContent, ",([^}])", ", %1")
print("JS Frames\n" .. jsContent .. "\n")
print("Lua Frames\n" .. luaContent)
io.output(luaFileName)
io.write(luaContent)
