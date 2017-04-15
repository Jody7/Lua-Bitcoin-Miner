local Block = require(game.ServerScriptService.BTC.BlockBuilder)
local LatestHash = require(game.ServerScriptService.BTC.LatestHash)
local hex = require(game.ServerScriptService.BTC.Hexidecimal)
local tx = require(game.ServerScriptService.BTC.TXGetter)
local Merkle = require(game.ServerScriptService.BTC.Merkle)


local waitForPlayer = true
game.Players.PlayerAdded:connect(function(player)
    player.Chatted:connect(function(message)
        if message == "start" then
			waitForPlayer = false
		end
    end)
end)

while true do
	if waitForPlayer == false then
		print("player started")
		break
	end
	wait(1)
end

local Transactions = tx(50) -- Get 50 unproccesed transactions and get the merkle root

local MerkleRoot = Merkle(Transactions)

print("Merkle Root: " .. MerkleRoot)

local function toDEC(str)
    str = tostring(str)
    if str:sub(1,2)=='0x' then str=str:sub(3) end
    local tot = 0
    local lkUp = {a = 10, b = 11, c = 12, d = 13, e = 14, f = 15} 
    local pow = 0
    for a = str:len(), 1, -1 do
        local char = str:sub(a, a)
        local num = lkUp[char] or tonumber(char)
        if not num then return nil end
        num = num*(16^pow)
        tot = tot + num
        pow = pow + 1
    end
    return tot
end


local function base256(x)
	local r = ""
	local base = 256
	local nums = {}
	
	while x > 0 do
	    r = (x % base ) 
		table.insert(nums, 1, r)
	    x = math.floor(x / base)
	end
	
	return nums
end

local function Bits(z)

	--[[
		convert the integer into base 256.
	if the first (most significant) digit is greater than 127 (0x7f), prepend a zero digit
	the first byte of the 'compact' format is the number of digits in the above base 256 representation, including the prepended zero if it's present
	the following three bytes are the first three digits of the above representation. If less than three digits are present, then one or more of the last bytes of the compact representation will be zero.
	--]]
	local d = base256(z)
	local t
	
	t =string.format("%02s", hex["toHex"](#d))
	 --t =string.format("%02s", (#d))
	for i=1,3 do
		if d[i] == nil then
			t = t .. "00"
		else
			t = t .. string.format("%02s", hex["toHex"](d[i]	))
			--t = t .. string.format("%02s",d[i])
		end
	end

	print(t)
	--toHEX add precision numbers	

end


--Bits(	hex["toDec"]("0x696f3ffffffe0c000000000000000000000000000000000"))

-- Block = Version + hashPrevBlock + hashMerkleroot + Time + Bits 	+ 	Nonce
-- stuck on :												this 									this

--print(LatestHash())

local PreviousBlock = require(game.ServerScriptService.BTC.GetLastBlock)()

local b = Block(PreviousBlock["data"]["hash"],
	Transactions,
	"201893210853", 
	MerkleRoot, 
	0)
