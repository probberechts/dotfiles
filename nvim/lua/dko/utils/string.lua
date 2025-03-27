local M = {}

M.capitalize = function(str)
  return (str:gsub("^%l", string.upper))
end

M.longest = function(strs)
  local len = 1
  local match
  for _, str in pairs(strs) do
    if str:len() > len then
      len = str:len()
      match = str
    end
  end
  return match, len
end

-- alt F ғ (ghayn)
-- alt Q ꞯ (currently using ogonek)
local smallcaps =
  "ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ‹›⁰¹²³⁴⁵⁶⁷⁸⁹"
local normal = "ABCDEFGHIJKLMNOPQRSTUVWXYZ<>0123456789"

---@param text string
M.smallcaps = function(text)
  return text and vim.fn.tr(text:upper(), normal, smallcaps)
end

return M
