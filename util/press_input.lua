
press_input = {
	_previous = input.get(),
	_current  = input.get(),
	
	update = function(this)
		this._previous = this._current
		this._current  = input.get()
	end,
	
	is_pressed = function(this, key)
		return this._current[key] and not this._previous[key]
	end,
	
	is_released = function(this, key)
		return this._previous[key] and not this._current[key]
	end
}
