--[[
	Returns latest block hash. Not reversed yet :/
--]]

local hs = game:GetService("HttpService")
local url = "https://blockchain.info/q/latesthash"

local function a()
	local data = hs:GetAsync(url, true)
	return data
end

return a
