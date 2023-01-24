options_menu_state = MenuState()

local lg = love.graphics

function options_menu_state:init()
	self:add_item('Volume', 'volume')
	self:add_item('Fullscreen', 'fullscreen')
	self:add_item('VSync', 'vsync')
	self:add_item('Back to Main Menu', 'return')
	self:get_window_mode()
	self.test_sound = love.audio.newSource('res/audio/player/sonar/Sonar_Player_01.wav', 'static')
end

function options_menu_state:enter()
	self:get_window_mode()
	self.index = 1
end

function options_menu_state:draw()
    lg.setBackgroundColor(self.bg)
    lg.print("Options", Fonts.title, 20, 20)

    lg.setColor(1,1,1)
    for i = 1, #self.items do
    	local item_action = self.items[i].action
    	local item_name = self.items[i].name

    	if item_action == 'volume' then
    		item_name = item_name..': '..string.format('%d%%', love.audio.getVolume()*100)
    	elseif item_action == 'fullscreen' then
    		if self.window_mode.fullscreen then
    			item_name = item_name..': [ON] off'
			else
				item_name = item_name..': on [OFF]'
			end
		elseif item_action == 'vsync' then
    		if self.window_mode.vsync ~= 0 then
    			item_name = item_name..': [ON] off'
			else
				item_name = item_name..': on [OFF]'
			end
		end

		self:print_menu_item(item_name, i)
    end
end

options_menu_state['volume'] = function( self, scancode )
	if scancode == 'left' or controller_1:button_pressed_left() then
		love.audio.setVolume( math.max(love.audio.getVolume() - 0.05, 0) )
	elseif scancode == 'right' or controller_1:button_pressed_right() then
		love.audio.setVolume( math.min(love.audio.getVolume() + 0.05, 1) )
	end

	Audio.play_random( player.sonar_sounds )
end

options_menu_state['fullscreen'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		if not self.window_mode.fullscreen then
			love.window.setMode( lg.getWidth(), lg.getHeight(), {fullscreen=true} )
		else
			love.window.setMode( 800, 600, {fullscreen=false} )
		end
		self:get_window_mode()
	end
end

options_menu_state['vsync'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		if self.window_mode.vsync == 0 then
			love.window.setMode( lg.getWidth(), lg.getHeight(), {vsync=1, fullscreen=self.window_mode.fullscreen} )
		else
			love.window.setMode( lg.getWidth(), lg.getHeight(), {vsync=0, fullscreen=self.window_mode.fullscreen} )
		end
		self:get_window_mode()
	end
end

options_menu_state['return'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		Gamestate.switch(main_menu_state)
	end
end

function options_menu_state:get_window_mode()
	local x, y = 0, 0
	x, y, self.window_mode = love.window.getMode()
end