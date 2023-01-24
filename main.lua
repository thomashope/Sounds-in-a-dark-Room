-- Load the required hump modules
Gamestate = require 'lib.hump.gamestate'
Camera = require 'lib.hump.camera'
Timer = require 'lib.hump.timer'
Class = require 'lib.hump.class'
Vector = require 'lib.hump.vector-light'
--Lovebird = require 'lib.lovebird.lovebird'

-- Load game modules
require 'src.states.state'
require 'src.states.splash_screen_state'
require 'src.states.main_menu_state'
require 'src.states.pause_menu_state'
require 'src.states.options_menu_state'
require 'src.states.level_select_state'
require 'src.states.credits_screen_state'
require 'src.states.controller_prompt_state'
require 'src.states.playing_state'
require 'src.states.console_state'
require 'src.utils'
require 'src.input_device'
require 'src.physics'
require 'src.level'
require 'src.audio'
require 'src.entity'
require 'src.pulse'
require 'src.player'
require 'src.zombie'
require 'src.wall'
require 'src.fonts'

flags = {
	debug = false,
	skip_intro = false,
}

local initial_state = splash_screen_state

function love.load(args)

	for i,v in ipairs(args) do
		if v == '--debug' then
			io.stdout:setvbuf('no')
			flags.debug = true
		end

		if v == '--skip-intro' then
			initial_state = main_menu_state
			flags.skip_intro = true
		end

		print(i,v)
	end

	-- Application setup
	Physics:init()
	Fonts:init()
	love.mouse.setVisible(false)
	love.graphics.setNewFont(18)
	love.audio.setVolume(0.5)
	love.math.setRandomSeed(love.timer.getTime())

	-- Set globals
	window_width, window_height = love.graphics.getDimensions()
	platform = love.system.getOS()

	player = Player(0, 0)
	camera = Camera(player.x, player.y)
	controller_1 = InputDevice()

	-- Initialise the game states
	Gamestate.registerEvents()
	Gamestate.switch(initial_state)

	if flags.skip_intro then		
		main_menu_state:end_intro_sequence()
	end
end

function love.update(dt)
	Timer.update(dt)
	controller_1:update()

	if flags.debug then
		-- Lovebird.update()
	end
end

function love.resize(w,h)
	window_width = w
	window_height = h
	playing_state.pips = love.graphics.newCanvas(w, h)
end

function love.keypressed( keycode, scancode, isrepeat )
	-- Open up the console from any state
	if scancode == 'f1' then
		if Gamestate.current() == console_state then
			Gamestate.switch(console_state.previous)
		else
			Gamestate.switch(console_state)
		end
	end
end

function love.joystickadded( joystick )
	controller_1:set_input_source( joystick )
	joystick:setVibration(0.5, 0.5, 0.2)
end

function love.joystickremoved()
	controller_1:set_input_source()
end