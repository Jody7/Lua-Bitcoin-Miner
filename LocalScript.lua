local BinaryData=require(game.ReplicatedStorage.BinaryData)
local SHA=require(game.ReplicatedStorage.SHA256)
local RNG=require(game.ReplicatedStorage.Random)

local x = tick()
local seedobj = {seed = x}

local function Random(a, b)
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
local nonce = 0

local hcount = 0
local fcount = 0

spawn(function()
	while wait(1) do
		game.ReplicatedStorage.RemoteEvent:FireServer(hcount, fcount)
		hcount = 0
	end	
end)

game.ReplicatedStorage.RemoteEvent.OnClientEvent:connect(function(...)
	local args = {...}
	local Version, PreviousBlock, MerkleRoot, Time, Bits, MineTarget = args[1], args[2], args[3], args[4], args[5], args[6]
	print("Starting Local Hasher")
	while nonce<4294967296 do
		wait()
		local header = little_endian_bytestr(Version)
		..tobinReverse(PreviousBlock)
		..tobinReverse(MerkleRoot)
		..little_endian_bytestr(Time,Bits,nonce)
		local hash=SHA(SHA(header)):reverse()
		if toDEC(hash)<MineTarget then
			print("FOUND HASH:", hash, "HEADER:", header)
			return hash
		else
			print("Failed Hash: ", hash, "Nonce: ", nonce)
		end
		hcount = hcount + 1
		fcount = fcount + 1
		nonce= Random(1,4294967296)
	end
		
end)
