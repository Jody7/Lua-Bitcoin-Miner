local hs = game:GetService("HttpService")

local function GetTX(num)
		local tservice = require(game.ServerScriptService.BTC.UnconfirmedTX)()
		local d = {}
		local tArray = hs:JSONDecode(tservice)["txs"]
		
		for i=1, num do
			d[i] = tArray[i]["hash"]
		end
		
		return d
end

return GetTX
