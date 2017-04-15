--[[
	Returns all un-confirmed transactions as a table.
	
	Example of one: http://prntscr.com/c3sb1r
--]]

local hs = game:GetService("HttpService")
local url = "https://blockchain.info/unconfirmed-transactions?format=json"

local function GetUnconfirmedTX()
	local data = hs:GetAsync(url, true)
	return data
end

return GetUnconfirmedTX
