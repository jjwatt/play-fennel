-- Global settings matching Pearson's logic
local _maxLevels = 5
local _numSides = 5
local _strutFactor = 0.2
local _strutRot = 0
local _rootFractal

local FractalNode = {}
FractalNode.__index = FractalNode

function FractalNode.new(levels, cx, cy, r)
    local self = setmetatable({}, FractalNode)
    self.level = levels
    self.numSides = _numSides
    self.x = cx
    self.y = cy
    self.radius = r

    self.outerPoints = {}
    self.midPoints = {}
    self.children = {}

    self:caclulatePoints()

    if self.level < _maxLevel then
	self.calculateMidPoints()

	-- Compute the new center and radius for the inner child node.
	local nextX = self.midPoints[1].x
	local nextY = self.midPoints[1].y
	local nextR = self.radius * _strutFactor

	table.insert(
	    self.children,
	    FractalNode.new(self.level + 1, nextX, nextY, nextR)
	)
    end
    return self
end

function FractalNode:calculatePoints()
    -- Calculate positions using basic polar to cartesian conversions.
    local angleTracker = 0
    local angleStep = 360 / self.numSides

    for i = 1, self.numSides do
	local rad = math.rad(angleTracker + _strutRot)
	local px = self.x + (self.radius * math.cos(rad))
	local py = self.y + (self.radius * math.sin(rad))
	table.insert(self.outerPoints, {x = px, y = py})
	angleTracker = angleTracker + angleStep
    end
end

function FractalNode:calculateMidPoints()
    for i, pt in ipairs(self.outerPoints) do
	local nextIndex = (i % self.numSides) + 1
	local nextPt = self.outerPoints[nextIndex]

	local mx = pt.x + ((nextPt.x - pt.x) * _strutFactor)
	local my = pt.y + ((nextPt.y - pt.y) * _strutFactor)
	table.insert(self.midPoints, {x = mx, y = my})
    end
end

function FractalNode:drawMe()
    love.graphics.setLineWidth(6 / self.level)

    for i, pt in ipairs(self.outerPoints) do
	local nextIndex = (i % self.numSides) + 1
	local nextPt = self.outerPoints[nextIndex]
	love.graphics.line(pt.x, pt.y, nextPt.x, nextPt.y)
    end

    for _, child in ipairs(self.children) do
	child:drawMe()
    end
end

function love.load()
    love.window.setMode(750, 500)
    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineStyle("smooth")

    local w, h = love.graphics.getDimensions()
    _rootFractal = FractalNode.new(1, w / 2, h / 2, 200)
end

function love.draw()
    _rootFractal:drawMe()
end

