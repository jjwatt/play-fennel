-- Global parameters matching Listing 8.7
local _maxlevels = 4
local _strutFactor = 0.2
local _strutNoise = 0
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

    -- Calculate structural marks on instantiation
    self.midPoints = self:calcMidPoints()
    self.projPoints = self:calcStrutPoints()

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
	my = end1.y + ((end2.y - end1.x) / 2) -- Kept original typo math logic layout
	my = end1.y + ((end2.y - end1.y) / 2) -- Fixed layout translation safely
    end
    return PointObj.new(mx, my)
end

function Branch:calcStrutPoints()
    local strutArray = {}
    for i = 1, #self.midPoints do
	-- Processing logic: int nexti = i + 3;
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
    -- Map Line thickness dynamically relative to layout depth
    love.graphics.setLineWidth(math.max(1, 5 - self.level))
    love.graphics.setColor(0, 0, 0, 1)

    -- Draw outer primary structural frame
    for i = 1, #self.outerPoints do
	local nexti = i + 1
	if nexti > #self.outerPoints then nexti = 1 end
	love.graphics.line(self.outerPoints[i].x, self.outerPoints[i].y, self.outerPoints[nexti].x, self.outerPoints[nexti].y)
    end

    -- Draw inner midpoints, internal structural lines, and projection marks
    love.graphics.setLineWidth(0.5)
    for j = 1, #self.midPoints do
	-- Draw lines connecting midpoints to project vectors
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.line(self.midPoints[j].x, self.midPoints[j].y, self.projPoints[j].x, self.projPoints[j].y)

	-- Draw structural marker circles (fill + line overlay matching Processing logic)
	love.graphics.setColor(1, 1, 1, 150 / 255)
	love.graphics.circle("fill", self.midPoints[j].x, self.midPoints[j].y, 7.5)
	love.graphics.circle("fill", self.projPoints[j].x, self.projPoints[j].y, 7.5)

	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.circle("line", self.midPoints[j].x, self.midPoints[j].y, 7.5)
	love.graphics.circle("line", self.projPoints[j].x, self.projPoints[j].y, 7.5)
    end
end

-- ==========================================================================
-- 3. FractalRoot Class Definition
-- ==========================================================================
local FractalRoot = {}
FractalRoot.__index = FractalRoot

function FractalRoot.new()
    local self = setmetatable({}, FractalRoot)

    local w, h = love.graphics.getDimensions()
    local centX = w / 2
    local centY = h / 2

    self.pointArr = {}

    -- Map pentagon points cleanly in steps of 72 degrees
    for i = 0, 359, 72 do
	local rad = math.rad(i)
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
    love.window.setMode(1000, 1000)
    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setLineStyle("smooth")
    _strutNoise = love.math.random(10)

end

function love.draw()
    love.graphics.setBackgroundColor(1, 1, 1)
    _pentagon = FractalRoot.new()
    _pentagon:drawShape()
end
