--[[
	Returns the last block mined.
--]]

local hs = game:GetService("HttpService")
local url = "http://btc.blockr.io/api/v1/block/info/last"

return function()
	local data = hs:GetAsync(url, true)
	return hs:JSONDecode(data)
end
