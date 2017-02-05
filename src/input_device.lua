InputDevice = Class{
	device = 'keyboard'
}

-- TODO: make keyboard inputs configurable
-- TODO: make gamepad inputs configurable
-- TODO: make joystick inputs configurable

function InputDevice:init()
	self:set_input_source()
	self:update()
end

function InputDevice:update()
	self.a_old = self.a
	self.a = self:button_down_a()
	self.start_old = self.start
	self.start = self:button_down_start()
	self.up_old = self.up
	self.up = self:button_down_up()
	self.down_old = self.down
	self.down = self:button_down_down()
	self.left_old = self.left
	self.left = self:button_down_left()
	self.right_old = self.right
	self.right = self:button_down_right()
end

-- no source defaults to keyboard input
function InputDevice:set_input_source( src )
	if src and src:typeOf('Joystick') then
		self.device = src
		if src:isGamepad() then
			-- It's a joystick that maps to a standard XBox 360 controller
			-- self.axis_x = self.axis_x_gamepad
			-- self.axis_y = self.axis_y_gamepad
			-- self.button_down_a = self.button_down_a_gamepad
			-- self.button_down_start = self.button_down_start_gamepad
			self:map_input_functiions('gamepad')
		else
			-- It's some kind of joystick, possibly weird, possibly a 'XBox 360 like' thats just not being recognised
			-- self.axis_x = self.axis_x_joystick
			-- self.axis_y = self.axis_y_joystick
			-- self.button_down_a = self.button_down_a_joystick
			-- self.button_down_start = self.button_down_start_joystick
			self:map_input_functiions('joystick')
		end
	else
		self.device = 'keyboard'
		-- if src is nil default to keyboard input
		-- self.axis_x = self.axis_x_keyboard
		-- self.axis_y = self.axis_y_keyboard
		-- self.button_down_a = self.button_down_a_keyboard
		-- self.button_down_start = self.button_down_start_keyboard
		self:map_input_functiions('keyboard')
	end
end

function InputDevice:map_input_functiions( src_name )
	self.axis_x = self['axis_x_'..src_name]
	self.axis_y = self['axis_y_'..src_name]
	self.button_down_a = self['button_down_a_'..src_name]
	self.button_down_start = self['button_down_start_'..src_name]
	self.button_down_up = self['button_down_up_'..src_name]
	self.button_down_down = self['button_down_down_'..src_name]
	self.button_down_left = self['button_down_left_'..src_name]
	self.button_down_right = self['button_down_right_'..src_name]
end

-- Button press state, generic across keyboard, gamepad, joystick
function InputDevice:button_pressed_up() return self.up and not self.up_old end
function InputDevice:button_pressed_down() return self.down and not self.down_old end
function InputDevice:button_pressed_left() return self.left and not self.left_old end
function InputDevice:button_pressed_right() return self.right and not self.right_old end
function InputDevice:button_pressed_a() return self.a and not self.a_old end
function InputDevice:button_pressed_start() return self.start and not self.start_old end
function InputDevice:button_pressed_any()
	return
		self:button_pressed_up() or
		self:button_pressed_down() or
		self:button_pressed_left() or
		self:button_pressed_right() or
		self:button_pressed_a() or
		self:button_pressed_start()
end

-- Keyboard input

function InputDevice:axis_x_keyboard()
	if love.keyboard.isScancodeDown('left') then
		return -1
	elseif love.keyboard.isScancodeDown('right') then
		return 1
	end
	return 0
end

function InputDevice:axis_y_keyboard()
	if love.keyboard.isScancodeDown('up') then
		return -1
	elseif love.keyboard.isScancodeDown('down') then
		return 1
	end
	return 0
end

function InputDevice:button_down_a_keyboard() return love.keyboard.isScancodeDown('space') end
function InputDevice:button_down_up_keyboard() return love.keyboard.isScancodeDown('up') end
function InputDevice:button_down_down_keyboard() return love.keyboard.isScancodeDown('down') end
function InputDevice:button_down_left_keyboard() return love.keyboard.isScancodeDown('left') end
function InputDevice:button_down_right_keyboard() return love.keyboard.isScancodeDown('right') end
function InputDevice:button_down_start_keyboard() return love.keyboard.isScancodeDown('escape') end

-- Gamepad input

function InputDevice:axis_x_gamepad()
	local axis = self.device:getGamepadAxis('leftx')

	-- Only return the axis if it's greater than our deadzone value
	if math.abs(axis) > 0.2 then
		return axis
	end
	return 0;
end

function InputDevice:axis_y_gamepad()
	local axis = self.device:getGamepadAxis('lefty')

	-- Only return the axis if it's greater than our deadzone value
	if math.abs(axis) > 0.2 then
		return axis
	end
	return 0;
end

function InputDevice:button_down_a_gamepad() return self.device:isGamepadDown('a') end
function InputDevice:button_down_up_gamepad() return self.device:isGamepadDown('dpup') end
function InputDevice:button_down_down_gamepad() return self.device:isGamepadDown('dpdown') end
function InputDevice:button_down_left_gamepad() return self.device:isGamepadDown('dpleft') end
function InputDevice:button_down_right_gamepad() return self.device:isGamepadDown('dpright') end
function InputDevice:button_down_start_gamepad() return self.device:isGamepadDown('start') end

-- Joystick input

function InputDevice:axis_x_joystick()
	local axis = self.device:getAxis(1)

	-- Only return the axis if it's greater than our deadzone value
	if math.abs(axis) > 0.2 then
		return axis
	end
	return 0;
end

function InputDevice:axis_y_joystick()
	local axis = self.device:getAxis(2)

	-- Only return the axis if it's greater than our deadzone value
	if math.abs(axis) > 0.2 then
		return axis
	end
	return 0;
end

function InputDevice:button_down_a_joystick() return self.device:isDown(1) end
function InputDevice:button_down_up_joystick() return self.device:isDown(12) end
function InputDevice:button_down_down_joystick() return self.device:isDown(13) end
function InputDevice:button_down_left_joystick() return self.device:isDown(14) end
function InputDevice:button_down_right_joystick() return self.device:isDown(15) end
function InputDevice:button_down_start_joystick() return self.device:isDown(9) end
-- FYI: back button id is 10