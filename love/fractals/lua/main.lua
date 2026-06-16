-- Global settings matching Pearson's logic
local _maxLevels = 5
local _numSides = 5
local _strutFactor = 0.2 -- Controls how deep/tight the inner nesting is
local _strutRot = 0      -- Optional rotation factor
local _rootFractal

-- --------------------------------------------------------------------------
-- OOP FractalNode Class Definition
-- --------------------------------------------------------------------------
local FractalNode = {}
FractalNode.__index = FractalNode

function FractalNode.new(levels, points)
    local self = setmetatable({}, FractalNode)

    self.level = levels
    self.numSides = _numSides

    -- Pass the explicit corner vertices down rather than calculating from a center radius
    self.outerPoints = points
    self.midPoints = {}
    self.children = {}

    -- 1. If we haven't hit the max depth, calculate internal struts
    if self.level < _maxLevels then
	self:calculateMidPoints()

	-- CRITICAL FIX: The book creates an inner pentagon by utilizing the
	-- newly calculated midpoints themselves as the outer vertices for the child!
	table.insert(self.children, FractalNode.new(self.level + 1, self.midPoints))
    end

    return self
end

function FractalNode:calculateMidPoints()
    -- Calculate internal strut vectors projecting across the shape
    for i, pt in ipairs(self.outerPoints) do
	-- Find the opposite edge or next point depending on the Sutcliffe rule
	local nextIndex = (i % self.numSides) + 1
	local nextPt = self.outerPoints[nextIndex]

	-- Interpolate along the edge boundary using the strut factor
	local mx = pt.x + ((nextPt.x - pt.x) * _strutFactor)
	local my = pt.y + ((nextPt.y - pt.y) * _strutFactor)

	table.insert(self.midPoints, {x = mx, y = my})
    end
end

function FractalNode:drawMe()
    -- Dynamically weight line thickness based on recursion depth
    love.graphics.setLineWidth(6 / self.level)

    -- Draw outer frame edges
    for i, pt in ipairs(self.outerPoints) do
	local nextIndex = (i % self.numSides) + 1
	local nextPt = self.outerPoints[nextIndex]

	love.graphics.line(pt.x, pt.y, nextPt.x, nextPt.y)
    end

    -- Recursively cascade down the nested generation stack
    for _, child in ipairs(self.children) do
	child:drawMe()
    end
end

-- --------------------------------------------------------------------------
-- LÖVE Lifecycle Loops
-- --------------------------------------------------------------------------

function love.load()
    love.window.setMode(750, 750)
    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineStyle("smooth")

    local w, h = love.graphics.getDimensions()
    local cx, cy = w / 2, h / 2
    local radius = 300

    -- Generate the foundational root points explicitly
    local rootPoints = {}
    local angleTracker = 0
    local angleStep = 360 / _numSides

    for i = 1, _numSides do
	local rad = math.rad(angleTracker - 90) -- Pointing straight up like the book
	local px = cx + (radius * math.cos(rad))
	local py = cy + (radius * math.sin(rad))
	table.insert(rootPoints, {x = px, y = py})
	angleTracker = angleTracker + angleStep
    end

    -- Instantiate the root fractal node using the coordinate list
    _rootFractal = FractalNode.new(1, rootPoints)
end

function love.draw()
    _rootFractal:drawMe()
end
