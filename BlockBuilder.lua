local Version=2
SHA256=require(script.Parent.SHA256)
Hex=require(script.Parent.Hexidecimal)
Bitwise=require(script.Parent.Bitwise)
BinaryData=require(script.Parent.BinaryData)

local RNG = require(game.ServerScriptService.BTC.Random)

local x = tick()
local seedobj = {seed = x}

local function random(a, b)
	return RNG(seedobj, a, b)
end

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

local Display = game.workspace.Display.SurfaceGui["1"]

local elem = {}
local zalpha = 0
local function prin(x)
	zalpha = zalpha + 1
	if zalpha > 6 then
		zalpha = 0
		elem = {}
		Display:ClearAllChildren()
	end
	local c = game.ServerStorage.TextLabel:Clone()
	c.Text = x
	c.Position = UDim2.new(0, 0, 0, 50)
	c.Parent = Display
	c.Visible = true
	for i,v in pairs(elem) do
		local yoff =  v.Position.Y.Offset
		v.Position = UDim2.new(0, 0, 0, 50 + yoff)
	end
	table.insert(elem, c)
end

local hcount = 0
local D2 = game.workspace.Display.SurfaceGui["2"].TextLabel

return function(PreviousBlock,Transactions,Target, MerkleRoot, Bits)
	Display:ClearAllChildren()
--	spawn(function()
--		while wait(1) do
--			prin(hcount .. " Hs/Sec")
--		end
--	end)
	local Time=math.floor(tick()+0.5)
	if Target:sub(1,2)=='0x' then
		Target=Target:sub(3)
	end
	local Target_F=Hex.toDec(Target:sub(1,2))
	local Target_R=Hex.toDec(Target:sub(3))
	local MineTarget=Target_R * (2 * (8 * (Target_F - 3)))
	
	print(MineTarget)
	
	local exp,mant=Target_F,Target_R
	
	local nonce = random(0,4294967296)
	
	
	local function little_endian_bytestr(...)
		return BinaryData.pack(string.rep('L',#{...})..'<',...)
	end
	
	local function hex_str_to_hex_bytestr(str)
		return BinaryData.pack('H*',str)
	end	
	
	local function tobinReverse(str)
	    local n = ""
	    for i = 1, #str,2 do
	     	local c = str:sub(i,i+1)
				n = string.char(toDEC(c)) .. n
	   		end
	    return n
	end

	for i,v in pairs(game.Players:GetChildren()) do
		game.ReplicatedStorage.RemoteEvent:FireClient(v, Version, PreviousBlock, MerkleRoot, Time, Bits, MineTarget)
	end	
	
	game.Players.PlayerAdded:connect(function(player)
		-- DISABLE "BITCOIN" MINING BECAUSE BITCOINS ARE SCARY
			MerkleRoot = MerkleRoot .. "00"
		---
		game.ReplicatedStorage.RemoteEvent:FireClient(player, Version, PreviousBlock, MerkleRoot, Time, Bits, MineTarget)
	end)
	local fullcount = 0
	
	game.ReplicatedStorage.RemoteEvent.OnServerEvent:connect(function(player, a, b)
		prin(player.Name .." : " .. tostring(a) .. " HPS")
		fullcount = fullcount + b
		D2.Text = ("Hashes Tried Total: " .. fullcount)
	end)
	
--	wait(99999)
--	while nonce<4294967296 do
--		wait()
--		local header = little_endian_bytestr(Version)
--		..tobinReverse(PreviousBlock)
--		..tobinReverse(MerkleRoot)
--		..little_endian_bytestr(Time,Bits,nonce)
--		local hash=SHA256(SHA256(header)):reverse()
--		hcount = hcount + 1
--		if Hex.toDec(hash)<MineTarget then
--			--We mined the block! 20 BTC is ours!
--			--return block
--			print("FOUND HASH:", hash, "HEADER:", header)
--			return hash
--		else
--			print("Failed Hash: ", hash, "Nonce: ", nonce)
--			D2.Text = ("Failed Hash: " .. hash .. " Nonce: "..  nonce)
--		end
--		nonce= random(1,4294967296)
--	end
end
