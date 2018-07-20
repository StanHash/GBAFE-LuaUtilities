require "util/rng"

burn_count = 0
frame_count = 0
current_input = 0

function display_rn_per_frame()
	if frame_count ~= 0 then
		gui.text(8, 8,  ("%f rn/frame"):format(burn_count / frame_count))
		gui.text(8, 16, ("%d frames"):format(frame_count))
		gui.text(8, 24, ("%d rns"):format(burn_count))
	end
end

gui.register(display_rn_per_frame)

memory.registerexec(
	0x08000BC0, -- NextRN
	function()
		burn_count = burn_count + 1
	end 
)

while true do
	local last_burn_count = burn_count

	frame_count = frame_count + 1

	if current_input == 0 then
		current_input = 1
		joypad.set(1, { down = 1, right = 1 })
	else
		current_input = 0
		joypad.set(1, { up = 1, left = 1 })
	end
	
	vba.frameadvance()
	
	if (burn_count - last_burn_count) == 0 then
		-- We encountered the bug where the path is broken
		vba.pause()
		break
	end
end
