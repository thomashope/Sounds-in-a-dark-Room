State = Class{
	bg = {0, 0, 0},
}

MenuState = Class{
	__includes = State,
	index = 1,
	items = {}
}

function MenuState:enter()
	self.index = 1
end

function MenuState:keypressed( keycode, scancode, isrepeat )
	if scancode == "up" then

		self.index = self.index - 1
		if self.index < 1 then self.index = #self.items end

	elseif scancode == "down" then

		self.index = self.index + 1
		if self.index > #self.items then self.index = 1 end

	else
		-- call the function that is the name of the selected item
		self[self.items[self.index]]( self, keycode, scancode, isrepeat )
	end
end