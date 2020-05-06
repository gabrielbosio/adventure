local jsFileName = arg[1]
local luaFileName = arg[2]

if not jsFileName then
  print("Format: genspr.lua <jsFileName>")
  return
end

for line in io.lines(jsFileName) do
  line = string.gsub(line, "\0", "")
  local framesKeyIndex = string.find(line, "frames")
  if framesKeyIndex then
    local framesValueStartIndex = framesKeyIndex + 8
    local framesValueEndIndex = string.find(line, "]]});") + 1;
    local framesJS = string.sub(line, framesValueStartIndex, framesValueEndIndex)
    print("\nJS Frames")
    print(framesJS .. "\n")
    local framesLua = string.gsub(framesJS,"[%[|%]]", {["["] = "{", ["]"] = "}"})
    print("\nLua Frames")
    print(framesLua .. "\n")
    local spritesContent = "sprites = " .. string.gsub(framesLua, ",0", "")
    print("\nSprites file")
    print(spritesContent .. "\n")
    local destinationFile = io.open(luaFileName, "w+")
    destinationFile:write(spritesContent)
    io.close(destinationFile)
    break
  end
end
