require "util/gba"

rng = {
	is_fe6 = (gba.game_code == "AFEJ"),

	load_state = function()
		local state = {
			memory.readshort(0x3000000),
			memory.readshort(0x3000002),
			memory.readshort(0x3000004)
		}
		
		return state
	end,

	sync_state = function(state)
		state[1] = memory.readshort(0x3000000)
		state[2] = memory.readshort(0x3000002)
		state[3] = memory.readshort(0x3000004)
	end,

	last_rn = function(state)
		return state[1]
	end,

	advance_get_rn = function(state)
		local rn = bit.band(bit.lshift(state[2], 11) + bit.rshift(state[1], 5), 0xFFFF)
		
		state[3] = bit.band(state[3] * 2, 0xFFFF)
		
		if bit.band(state[2], 0x8000) ~= 0 then
			state[3] = state[3] + 1
		end
		
		rn = bit.bxor(rn, state[3])
		
		state[3] = state[2]
		state[2] = state[1]
		state[1] = rn
		
		return rn
	end,
	
	last_rn_100 = function(state)
		if rng.is_fe6 then
			return math.floor(rng.last_rn(state) / math.floor(65535 / 100))
		else
			return math.floor((rng.last_rn(state) * 100) / 65535)
		end
	end,
	
	next_rn_100 = function(state)
		if rng.is_fe6 then
			return math.floor(rng.advance_get_rn(state) / math.floor(65535 / 100))
		else
			return math.floor((rng.advance_get_rn(state) * 100) / 65535)
		end
	end

}
