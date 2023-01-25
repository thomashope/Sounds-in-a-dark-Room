Fonts = {}

local lg = love.graphics

function Fonts:init()
	self.body = lg.newFont(18)
	self.title = lg.newFont(36)
	self.splash_screen = lg.newFont(60)

	lg.setFont(self.body)
end