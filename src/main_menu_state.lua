main_menu_state = MenuState()

-- TODO: allow the intro to be skipped by pressing start on the controller

function main_menu_state:init()
	self.items = {'play', 'options', 'credits', 'quit'}
    self.title_colour = {0,0,0}
    self.menu_colour = {0,0,0}
    self.title_is_done = false
    self.allow_input = false

    -- Tutorial text to fade when playing is highlighted
    self.tut_str = {
        {text="Something is moving,",               colour={0,0,0}, target={255,255,255}, fade=1.5},
        {text="out there,",                         colour={0,0,0}, target={255,255,255}, fade=1.5},
        {text="in the darkness...",                 colour={0,0,0}, target={255,255,255}, fade=1.5},
        {text="",                                   colour={0,0,0}, target={255,255,255}, fade=1},
        {text="Zombies will kill you.",             colour={0,0,0}, target={100,255,100}, fade=2},
        {text="Sounds attracted zombies.",          colour={0,0,0}, target={100,100,255}, fade=2},
        {text="Lava kill everything.",              colour={0,0,0}, target={255,100,100}, fade=2}
    }
    self.tut_str_index = 1

    -- Init is run just before entering the state for the first time
    -- The following is run to give us a nice intro sequence when we reach the main menu

    local function fade_in_title()
        Timer.tween(3, main_menu_state.title_colour, {255,255,255}, 'in-out-quad')
        main_menu_state.title_is_done = true
    end
    local function fade_in_menu()
        Timer.tween(1, main_menu_state.menu_colour, {255,255,255}, 'in-out-quad')
        Timer.after(0.5, function() self.allow_input = true end)
    end

    -- Fade in each line in the tutorial string (actually it's a table of strings)
    Timer.every( 1, function()
            local self = main_menu_state
            Timer.tween(
                self.tut_str[self.tut_str_index].fade,      -- Time to fade in
                self.tut_str[self.tut_str_index].colour,    -- initial colour
                self.tut_str[self.tut_str_index].target,    -- end colour
                'in-out-quad')
            self.tut_str_index = self.tut_str_index + 1
        end, #self.tut_str )

    -- Then fade in the title
    Timer.after( #self.tut_str+1, fade_in_title )
    -- Then fade in th menu
    Timer.after( #self.tut_str+4, fade_in_menu )
end

function main_menu_state:enter()
    self.index = 1
end

function main_menu_state:leave()
    self.allow_input = true
    self.title_is_done = true
end

function main_menu_state:update()
    -- Only allow the user to interact with the menu when the intro is done
    if self.allow_input then
        self:navigate_menu()
    end
end

function main_menu_state:draw()
    love.graphics.setBackgroundColor(self.bg)
    love.graphics.setColor(self.title_colour)
    love.graphics.print("Sounds in a Dark Room", 20, 20, 0, 3, 3)

    -- Only draw the menu when the intro is done
    if self.title_is_done then
        love.graphics.setColor(self.menu_colour)
        for i = 1, #self.items do
        	local string = self.items[i]
        	if i == self.index then string = "> "..string end
        	love.graphics.print(string, 20, 80 + 30 * i)
        end
    end

    -- Draw the tutorial stings
    for i = 1, #self.tut_str do
        love.graphics.setColor(self.tut_str[i].colour)
        love.graphics.print(self.tut_str[i].text, 220, 80 + 30 * i)
    end
end

function main_menu_state:keypressed( keycode, scancode, isrepeat )
    -- Allow escape to skip the intro sequence
    if scancode == 'escape' and not self.title_is_done then
        self.title_is_done = true
        self.allow_input = true
        self.menu_colour = {255,255,255}
    end
    -- Since we are overriding the keypressed function we need to
    -- explicitly forward inputs
    if self.allow_input then
        MenuState.keypressed( self, keycode, scancode, isrepeat )
    end
end

main_menu_state['play'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		Gamestate.switch(level_select_state)
	end
end

main_menu_state['options'] = function( self, scancode )
    if scancode == 'space' or controller_1:button_pressed_a() then
        Gamestate.switch(options_menu_state)
    end
end

main_menu_state['credits'] = function( self, scancode )
    if scancode == 'space' or controller_1:button_pressed_a() then
        Gamestate.switch(credits_screen_state)
    end
end

main_menu_state['quit'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
        love.event.quit()
    end
end