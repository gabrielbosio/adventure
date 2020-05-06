local jsFileName = arg[1]
local luaFileName = arg[2]

if not jsFileName or not luaFileName then
  print("Usage: genspr.lua <jsFileName> <luaFileName>")
  return
end

for line in io.lines(jsFileName) do
  line = string.gsub(line, "\0", "")  -- string.char(0) == "\0"
  local pattern = "frames: "
  local framesKeyIndex = string.find(line, pattern)
  if framesKeyIndex then
    local framesValueStartIndex = framesKeyIndex + #pattern
    local framesValueEndIndex = string.find(line, "]]});") + 1;
    local framesJS = string.sub(line, framesValueStartIndex, framesValueEndIndex)
    print("\nJS Frames")
    print(framesJS .. "\n")
    local framesLua = string.gsub(framesJS,"[%[|%]]", {["["] = "{", ["]"] = "}"})
    print("\nLua Frames")
    print(framesLua)
    -- Add indentation
    local framesLua = string.gsub(framesLua,",([^%s\n])", ", %1")
    local framesLua = string.gsub(framesLua,"{{", "{\n  {")
    local framesLua = string.gsub(framesLua,"},", "},\n  ")
    local framesLua = string.gsub(framesLua,"}}", "}\n}\n")
    local spritesContent = "sprites = " .. string.gsub(framesLua, ", 0,", ",")
    print("\nSprites file")
    print(spritesContent)
    local destinationFile = io.open(luaFileName, "w+")
    destinationFile:write(spritesContent)
    io.close(destinationFile)
    break
  end
end
