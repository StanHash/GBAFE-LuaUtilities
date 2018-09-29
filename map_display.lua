require "util/press_input"

MAP_ADDRESSES = {
	0x0202E4D8, -- unit
	0x0202E4DC, -- terrain
	0x0202E4E0, -- movement
	0x0202E4E4, -- range
	0x0202E4EC, -- hidden
	0x0202E4E8, -- fog
	0x0202E4F0  -- other
}

MAP_NAMES = {
	"UNIT",
	"TERRAIN",
	"MOVEMENT",
	"RANGE",
	"HIDDEN",
	"FOG",
	"OTHER"
}

currentMap = 1

function change_map(newId)
	currentMap = newId

	if currentMap < 1 then
		currentMap = 7
	elseif currentMap > 7 then
		currentMap = 1
	end
	
	print(MAP_NAMES[currentMap])
end

function handle_input()
	press_input:update()
	
	if press_input:is_pressed("numpad-") then
		change_map(currentMap - 1)
	end
	
	if press_input:is_pressed("numpad+") then
		change_map(currentMap + 1)
	end
end

change_map(1)

gui.register(function()
	handle_input()

	local rows = memory.readlong(MAP_ADDRESSES[currentMap])
	
	local xCam = memory.readshort(0x0202BCBC+0)
	local yCam = memory.readshort(0x0202BCBC+2)
	
	local wMap = memory.readshort(0x0202E4D4+0)
	local hMap = memory.readshort(0x0202E4D4+2)
	
	for iy = 1, hMap do
		local row = memory.readlong(rows + 4*(iy - 1))
		
		for ix = 1, wMap do
			local tile = memory.readbyte(row + (ix - 1))
			
			gui.text(ix * 16 - 12 - xCam, iy * 16 - 12 - yCam, string.format("%X", tile))
		end
	end
end)
