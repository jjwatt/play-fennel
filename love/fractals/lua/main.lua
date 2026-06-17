-- Global parameters matching Listing 8.8
local _maxlevels = 4
local _strutFactor = 0.3
local _strutNoise = 0
local _numSides = 8
local _angleAccumulator = 0
local _rotationSpeed = 24
local _noiseSpeed = 0.24
-- local bgColor = {0.96, 0.94, 0.90}
local bgColor = {0.08, 0.18, 0.36}
local _pentagon

-- ==========================================================================
-- 1. PointObj Class Definition
-- ==========================================================================
local PointObj = {}
PointObj.__index = PointObj

function PointObj.new(ex, why)
    local self = setmetatable({}, PointObj)
    self.x = ex
    self.y = why
    return self
end

-- ==========================================================================
-- 2. Branch Class Definition
-- ==========================================================================
local Branch = {}
Branch.__index = Branch

function Branch.new(lev, n, points)
    local self = setmetatable({}, Branch)

    self.level = lev
    self.num = n
    self.outerPoints = points
    self.midPoints = self:calcMidPoints()
    self.projPoints = self:calcStrutPoints()
    self.myBranches = {} -- Dynamic children table

    -- Recursive structural branching
    if (self.level + 1) < _maxlevels then
	-- Construct the central inner core branch
	local childBranch = Branch.new(self.level + 1, 0, self.projPoints)
	table.insert(self.myBranches, childBranch)

	-- Construct peripheral neighborhood sub-branches around the perimeter
	for k = 1, #self.outerPoints do
	    local nextk = k - 1
	    if nextk < 1 then nextk = #self.outerPoints end

	    -- Re-bundle coordinates clockwise/counter-clockwise
	    local newPoints = {
		self.projPoints[k],
		self.midPoints[k],
		self.outerPoints[k],
		self.midPoints[nextk],
		self.projPoints[nextk]
	    }

	    childBranch = Branch.new(self.level + 1, k, newPoints)
	    table.insert(self.myBranches, childBranch)
	end
    end

    return self
end

function Branch:calcMidPoints()
    local mpArray = {}
    for i = 1, #self.outerPoints do
	local nexti = i + 1
	if nexti > #self.outerPoints then nexti = 1 end

	local thisMP = self:calcMidPoint(self.outerPoints[i], self.outerPoints[nexti])
	table.insert(mpArray, thisMP)
    end
    return mpArray
end

function Branch:calcMidPoint(end1, end2)
    local mx, my
    if end1.x > end2.x then
	mx = end2.x + ((end1.x - end2.x) / 2)
    else
	mx = end1.x + ((end2.x - end1.x) / 2)
    end

    if end1.y > end2.y then
	my = end2.y + ((end1.y - end2.y) / 2)
    else
	my = end1.y + ((end2.y - end1.y) / 2)
    end
    return PointObj.new(mx, my)
end

function Branch:calcStrutPoints()
    local strutArray = {}
    for i = 1, #self.midPoints do
	local nexti = i + 3
	if nexti > #self.midPoints then
	    nexti = nexti - #self.midPoints
	end

	local thisSP = self:calcProjPoint(self.midPoints[i], self.outerPoints[nexti])
	table.insert(strutArray, thisSP)
    end
    return strutArray
end

function Branch:calcProjPoint(mp, op)
    local px, py
    local adj, opp

    if op.x > mp.x then opp = op.x - mp.x else opp = mp.x - op.x end
    if op.y > mp.y then adj = op.y - mp.y else adj = mp.y - op.y end

    if op.x > mp.x then
	px = mp.x + (opp * _strutFactor)
    else
	px = mp.x - (opp * _strutFactor)
    end

    if op.y > mp.y then
	py = mp.y + (adj * _strutFactor)
    else
	py = mp.y - (adj * _strutFactor)
    end

    return PointObj.new(px, py)
end

function Branch:drawMe()
    -- Map Line weight down smoothly
    love.graphics.setLineWidth(math.max(1, 5 - self.level))
    love.graphics.setColor(0.85, 0.92, 1.0, 0.6)

    -- Draw outer frame geometries
    for i = 1, #self.outerPoints do
	local nexti = i + 1
	if nexti > #self.outerPoints then nexti = 1 end
	love.graphics.line(self.outerPoints[i].x, self.outerPoints[i].y, self.outerPoints[nexti].x, self.outerPoints[nexti].y)
    end

    -- Draw inner midpoints, line connections, and projection anchors
    love.graphics.setLineWidth(0.5)
    for j = 1, #self.midPoints do
	love.graphics.setColor(0.85, 0.92, 1.0, 0.6)
	love.graphics.line(self.midPoints[j].x, self.midPoints[j].y, self.projPoints[j].x, self.projPoints[j].y)

	-- Joint circles
	love.graphics.setColor(0.85, 0.92, 1.0, 0.6)
	love.graphics.circle("fill", self.midPoints[j].x, self.midPoints[j].y, 2.5)
	love.graphics.circle("fill", self.projPoints[j].x, self.projPoints[j].y, 2.5)

	-- Joint circle outlines
	love.graphics.setColor(0.08, 0.18, 0.36, 0.9)
	love.graphics.circle("line", self.midPoints[j].x, self.midPoints[j].y, 2.5)
	love.graphics.circle("line", self.projPoints[j].x, self.projPoints[j].y, 2.5)
    end

    -- Run layout drawing downstream recursively
    for k = 1, #self.myBranches do
	self.myBranches[k]:drawMe()
    end
end

-- ==========================================================================
-- 3. FractalRoot Class Definition
-- ==========================================================================
local FractalRoot = {}
FractalRoot.__index = FractalRoot

function FractalRoot.new(startAngle)
    local self = setmetatable({}, FractalRoot)

    local w, h = love.graphics.getDimensions()
    local centX = w / 2
    local centY = h / 2
    local angleStep = 360.0 / _numSides
    self.pointArr = {}

    for i = 0, 359, angleStep do
	local rad = math.rad(startAngle + i)
	local x = centX + (400 * math.cos(rad))
	local y = centY + (400 * math.sin(rad))
	table.insert(self.pointArr, PointObj.new(x, y))
    end

    self.rootBranch = Branch.new(0, 0, self.pointArr)
    return self
end

function FractalRoot:drawShape()
    self.rootBranch:drawMe()
end

-- ==========================================================================
-- LÖVE Lifecycle Loops
-- ==========================================================================

function love.load()
    love.window.setTitle("Listing 8.8ish: Sutcliffe Octogan Fractal, tweaked")
    love.window.setMode(1000, 1000)
    love.graphics.setLineStyle("smooth")

    love.graphics.setBackgroundColor(bgColor[1], bgColor[2], bgColor[3])
    -- Pick a random noise start position point
    _strutNoise = love.math.random(10)
end

function love.update(dt)
    -- Rotate cleanly based on time.
    _angleAccumulator = _angleAccumulator + (_rotationSpeed * dt)

    -- Advance noise smoothly based on time.
    _strutNoise = _strutNoise + (_noiseSpeed * dt)
    _strutFactor = love.math.noise(_strutNoise) * 2

    -- Rebuild the complete structural graph
    _pentagon = FractalRoot.new(_angleAccumulator)
end

function love.draw()
    love.graphics.clear(bgColor[1], bgColor[2], bgColor[3]) -- Clean clear background color canvas pass
    if _pentagon then
	_pentagon:drawShape()
    end
end
