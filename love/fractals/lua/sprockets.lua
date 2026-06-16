local _numChildren = 3
local _maxLevels = 3
local _trunk

local Branch = {}
Branch.__index = Branch

function Branch.new(lev, ind, ex, why)
    local self = setmetatable({}, Branch)
    self.level = lev
    self.index = ind

    -- Aesthetic variables based on level depth
    self.strokeW = (1 / self.level) * 5
    -- Keep standard 0-255 scale logic.
    self.alph = 255 / self.level

    -- Movement state variables
    self.len = (1 / self.level) * love.math.random(0, 200)
    self.rot = love.math.random(0, 360)
    self.lenChange = love.math.random() * 10 - 5
    self.rotChange = love.math.random() * 10 - 5

    self.x = 0
    self.y = 0
    self.endx = 0
    self.endy = 0

    self.children = {}
    self:updateMe(ex, why)

    -- Recursive generation if depth is not reached
    if self.level < _maxLevels then
	for i = 1, _numChildren do
	    table.insert(self.children, Branch.new(self.level + 1, i, self.endx, self.endy))
	end
    end
    return self
end

function Branch:updateMe(ex, why)
    self.x = ex
    self.y = why

    -- Update rotation state and wrap around.
    self.rot = self.rot + self.rotChange
    if self.rot > 360  then
	self.rot = 0
    end
    if self.rot < 0 then
	self.rot = 360
    end

    -- Update length state and bounce boundaries.
    self.len = self.len - self.lenChange
    if self.len < 0 or self.len > 200 then
	self.lenChange = self.lenChange * -1
    end

    -- Convert degrees to radians and calculate end positions.
    local radian = math.rad(self.rot)
    self.endx = self.x + (self.len * math.cos(radian))
    self.endy = self.y + (self.len * math.sin(radian))

    -- Recursively propagate down to children nodes.
    for _, child in ipairs(self.children) do
	child:updateMe(self.endx, self.endy)
    end
end

function Branch:drawMe()
    love.graphics.setLineWidth(self.strokeW)
    love.graphics.setColor(0, 0, 0, self.alph / 255)
    love.graphics.line(self.x, self.y, self.endx, self.endy)

    -- Fill and outline styling for structural node circles
    love.graphics.setColor(1, 1, 1, self.alph / 255)
    love.graphics.circle("fill", self.x, self.y, self.len / 12)
    love.graphics.setColor(0, 0, 0, self.alph / 255)
    love.graphics.circle("line", self.x, self.y, self.len / 12)

    -- Recursively draw children branches.
    for _, child in ipairs(self.children) do
	child:drawMe()
    end
end

-- --------------------------------------------------------------------------
-- LÖVE Core Game Loops
-- --------------------------------------------------------------------------

function love.load()
    love.window.setMode(750, 500)
    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setLineStyle("smooth")

    love.initTree()
end

function love.initTree()
    local width, height = love.graphics.getDimensions()
    -- Init the primary root trunk at the screen's center.
    _trunk = Branch.new(1, 0, width / 2, height / 2)
end

function love.update(dt)
    local width, height = love.graphics.getDimensions()
    _trunk:updateMe(width /2, height / 2)
end

function love.draw()
    _trunk:drawMe()
end

function love.keypressed(key)
    if key == "q" then
	love.event.quit()
    end
    love.initTree()
end
