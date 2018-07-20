require "util/rng"

function on_frame()
	local state = rng.load_state()
	local near_table = {}
	
	for i = 1, 18 do
		rn = rng.next_rn_100(state)
		near_table[i] = rn

		gui.text(8, 8 + 8 * (i - 1), string.format("%d", rn))
	end

	for i = 1, 1 do
		y = 24 * (i - 1)
		
		gui.line(20, y + 8, 20, y + 22, "black")
		gui.text(24, y + 12, string.format("hit %d", math.floor((near_table[(i-1)*3 + 1] + near_table[(i-1)*3 + 2]) / 2)))
	end
end

function find_next_2rn_roll(threshold)
	local i = 0

	local state = rng.load_state()
	rng.advance_get_rn(state)
	
	while i < 10000000 do -- safety
		local roll = rng.last_rn_100(state)
		roll = roll + rng.next_rn_100(state)
		roll = math.floor(roll / 2)
		
		if threshold <= roll then
			return i
		end
		
		i = i + 1
	end
	
	return -1
end

-- This takes like 10 seconds to compute lol
print(string.format("Next 100%% double roll miss in %d RNs", find_next_2rn_roll(100)))

gui.register(on_frame)

--[[
burns_left = find_next_2rn_roll(100) - 100

memory.registerexec(
	0x08000BC0, -- NextRN
	function()
		burns_left = burns_left - 1
	end 
)

current_input = 0

while burns_left > 0 do
	if current_input == 0 then
		current_input = 1
		joypad.set(1, { down = 1, left = 1 })
	else
		current_input = 0
		joypad.set(1, { up = 1, right = 1 })
	end
	
	if math.fmod(burns_left, 60) == 0 then
		print(string.format("%d", burns_left))
	end

	vba.frameadvance()
end
]]
