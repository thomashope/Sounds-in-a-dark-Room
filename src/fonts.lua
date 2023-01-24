Fonts = {}

local lg = love.graphics

function Fonts:init()
	self.body = lg.newFont()
	self.title = lg.newFont(36)

	lg.setFont(self.body)
end