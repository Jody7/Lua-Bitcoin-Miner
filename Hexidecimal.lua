function toDEC(str)
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

function toHEX(num)
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

return{
	toDec=toDEC,
	toHex=toHEX
}
