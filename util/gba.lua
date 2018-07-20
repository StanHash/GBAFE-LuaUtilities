
gba = {
	game_code = (function()
		local result = ""
		
		for i = 0, 3 do
			result = result .. string.char(memory.readbyte(0x080000AC + i))
		end
		
		return result
	end)(),
	
	read_cstring = function(pointer)
		local result = ""
		
		if pointer == 0 then
			return result
		end
		
		while true do
			local chr = memory.readbyte(pointer)
			
			if chr == 0 then
				break
			end
			
			result = result .. string.char(chr)
			pointer = pointer + 1
		end
		
		return result
	end
}
