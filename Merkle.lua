local BinaryData=require(game.ServerScriptService.BTC.BinaryData)
local SHA = require(game.ServerScriptService.BTC.SHA256)
local bit32=require(game.ServerScriptService.BTC.Bitwise).bit32


local function toHEX(num)
    local dig = {'1', '2', '3', '4', '5', '6' ,'7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'}
    local Hx = ""
    local write0 = false
    for i = 8, 0, -1 do         --1, using 16 as input
        local plc = 16^i        --16
        local digit = ""
        for dg = 15, 1, -1 do
            if (num - (dg*plc)) >= 0 then
                digit = dig[dg]
                num = num - (dg*plc)
                write0 = true
                break
            end
        end
        if digit == "" and write0 then digit = '0' end
        Hx = Hx..digit
    end
    return Hx
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


local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function len(x)
	return tablelength(x)
end

local function rev(str)
    local n = ""
    for i = 1, #str,2 do
     local c = str:sub(i,i+1)
     n = c .. n
    end
    return n
end

local function tobin(str)
    local n = ""
    for i = 1, #str,2 do
     local c = str:sub(i,i+1)
     n = n .. string.char(toDEC(c))
    end
    return n
end

local function hash2(first, second)
	
	--TODO MAKE THIS DO SHIT	
	
	--endian stuff
	local firstreverse = rev(first)
	local secondreverse = rev(second)
	
	local z = tobin(firstreverse .. secondreverse)
	local h = SHA(tobin(SHA(z))) -- double sha512
--	local z = string.reverse(h)
	-- back to our original endian
	--return toHEX(z)
	--print(firstreverse, tohex(revt(h)))
	--debugging
	return rev(h)
end

local Display = game.workspace.Display.SurfaceGui["1"]

local elem = {}
local function prin(x)
	local c = Display.TextLabel:Clone()
	c.Text = x
	c.Position = UDim2.new(0, 0, 0, 50)
	c.Parent = Display
	c.Visible = true
	for i,v in pairs(elem) do
		local yoff =  v.Position.Y.Offset
		v.Position = UDim2.new(0, 0, 0, 50 + yoff)
	end
	table.insert(elem, c)
	wait(0.1)
end

local function append(array, element)
	array[tablelength(array)] = element
end	

local function rewriteTable(hashlist)
	-- need to remove last element to fix it
	local temp = {}
	if #hashlist % 2 == 1 then
		for i,v in pairs(hashlist) do
			if i == #hashlist then
				break
			end
			temp[i] = v
		end
	end
	return temp
end

local function merkle(hashlist)
 -- ported by the jody of the four sevens

	local Round = 0
	Round = Round + 1
	--local NotDone = true
	local OddOneOut = nil

	while true do
		if #hashlist == 1 then
				return hashlist[1]
		end
		
		
		--merge all branches
		for i=1, #hashlist, 2 do
			if(hashlist[i+1] == nil) then
				--print("this one has no partner: hash with itself ", i)
				hashlist[i] = hash2(hashlist[i], hashlist[i])
			else
				prin("MERKLE OP: merging: " .. i .. " " .. i+1)
				hashlist[i] = hash2(hashlist[i], hashlist[i+1])
				hashlist[i+1] = nil
			end
		end
		
		--shift down all elements when done
		--wait(0.1)
		local temp = {}
		local c = 0
		for i,v in pairs(hashlist) do
			c = c + 1
			temp[c] = v
		end
		hashlist = temp
		
		prin("MERKLE OP: Finished Layer")
	end
	
end

return merkle
