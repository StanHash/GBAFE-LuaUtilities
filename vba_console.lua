
vba_console = {
	current_line = 0,
	background_color = 0x00000080,
	
	geometry = {
		x = 1,
		y = 1,
		w = 238,
		h = 158
	},
	
	margin = {
		x = 3,
		y = 3
	},
	
	begin_frame = function(this, startLine)
		gui.box(
			this.geometry.x,
			this.geometry.y,
			this.geometry.x+this.geometry.w,
			this.geometry.y+this.geometry.h,
			this.background_color, 0
		)
		
		this.current_line = startLine
	end,
	
	print_line = function(this, line)
		if (this.current_line >= 0) and (this.current_line < (this.geometry.h - this.margin.y*2)/8) then
			gui.text(
				this.geometry.x + this.margin.x,
				this.geometry.y + this.margin.y + this.current_line*8,
				line
			)
		end
		
		this.current_line = this.current_line + 1
	end
}
