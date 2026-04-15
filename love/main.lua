local clj = require("cljlib")
local function norm(value, low, high)
  return ((value - low) / (high - low))
end
local function lerp(low, high, amt)
  return (low + (amt * (high - low)))
end
local function mapvalue(value, low1, high1, low2, high2)
  local n = norm(value, low1, high1)
  local c = lerp(low2, high2, n)
  return c
end
local custom_random
local function custom_random0(...)
  do
    local cnt_54_auto = select("#", ...)
    if (0 ~= cnt_54_auto) then
      error(("Wrong number of args (%s) passed to %s"):format(cnt_54_auto, "custom-random"))
    else
    end
  end
  return (1 - (math.random(0, 1) ^ 5))
end
custom_random = custom_random0
local function my_spiral(centerx, centery, radius, _3fstartradius, _3fstep, _3fradiusinc)
  if (nil == radius) then
    _G.error("Missing argument radius on main.fnl:22", 2)
  else
  end
  if (nil == centery) then
    _G.error("Missing argument centery on main.fnl:21", 2)
  else
  end
  if (nil == centerx) then
    _G.error("Missing argument centerx on main.fnl:20", 2)
  else
  end
  local spiral = {radius = (_3fstartradius or (radius / 10)), radiusinc = (_3fradiusinc or 0.25), lastx = 0, lasty = 0}
  for angle = 0, (360 * 4), (_3fstep or 8) do
    spiral.radius = (spiral.radius + spiral.radiusinc)
    local radians = math.rad(angle)
    local x = (centerx + (spiral.radius * math.cos(radians)))
    local y = (centery + (spiral.radius * math.sin(radians)))
    if (spiral.lastx > 0) then
      love.graphics.line(x, y, spiral.lastx, spiral.lasty)
    else
    end
    spiral.lastx = x
    spiral.lasty = y
  end
  return nil
end
local function my_spiral2(centerx, centery, radius, _3fstartradius, _3fstep, _3fradiusinc)
  if (nil == radius) then
    _G.error("Missing argument radius on main.fnl:46", 2)
  else
  end
  if (nil == centery) then
    _G.error("Missing argument centery on main.fnl:45", 2)
  else
  end
  if (nil == centerx) then
    _G.error("Missing argument centerx on main.fnl:44", 2)
  else
  end
  local spiral = {radius = (_3fstartradius or (radius / 10)), radiusinc = (_3fradiusinc or 0.25), lastx = centerx, lasty = centery}
  for angle = 0, (360 * 4), (_3fstep or 8) do
    spiral.radius = (spiral.radius + spiral.radiusinc)
    local radians = math.rad(angle)
    local x = (centerx + (spiral.radius * math.cos(radians)))
    local y = (centery + (spiral.radius * math.sin(radians)))
    love.graphics.line(x, y, spiral.lastx, spiral.lasty)
    spiral.lastx = x
    spiral.lasty = y
  end
  return nil
end
local function my_sin_wave(_3foffset, _3fscale_val, _3fangle_inc, _3fangle)
  local lastx = 0
  local lasty = 0
  local angle = (_3fangle or 0)
  local offset = (_3foffset or 50)
  local scale_val = (_3fscale_val or 20)
  local angle_inc = (_3fangle_inc or (math.pi / 18))
  local width, _ = love.graphics.getDimensions()
  for x = 0, width, 5 do
    local y = (offset + (math.sin(angle) * scale_val))
    if (lastx > 0) then
      love.graphics.line(x, y, lastx, lasty)
    else
    end
    angle = (angle + angle_inc)
    lastx = x
    lasty = y
  end
  return nil
end
local function my_eight_eleven(width, height, _3fpow)
  for x = 5, width, 5 do
    local n = mapvalue(x, 5, width, -1, 1)
    local p = (n ^ (_3fpow or 4))
    local ypos = lerp(20, height, p)
    love.graphics.line(x, 0, x, ypos)
  end
  return nil
end
local function my_curve()
  for x = 0, 200, 1 do
    local n = norm(x, 0.0, 200.0)
    local y = (n ^ 4)
    y = (200 * y)
    love.graphics.points(x, y)
  end
  return nil
end
local draw_sine_wave
local function draw_sine_wave0(...)
  local case_15_ = select("#", ...)
  if (case_15_ == 0) then
    local width, height = love.graphics.getDimensions()
    local scale_val = 40
    local angle_inc = 1
    local startangle = 0
    return draw_sine_wave0((height / 2), scale_val, angle_inc, startangle)
  elseif (case_15_ == 1) then
    local offset = ...
    return draw_sine_wave0(offset, 40, 1, 0)
  elseif (case_15_ == 2) then
    return error(("Wrong number of args (%s) passed to %s"):format(2, "draw-sine-wave"))
  elseif (case_15_ == 3) then
    return error(("Wrong number of args (%s) passed to %s"):format(3, "draw-sine-wave"))
  elseif (case_15_ == 4) then
    local offset, scale_val, angle_inc, startangle = ...
    local width, height = love.graphics.getDimensions()
    local xstep = 5
    local borderx = 20
    local _2_16_ = borderx
    local x = _2_16_
    local _4_17_ = 0
    local lastx = _4_17_
    local _6_18_ = 0
    local lasty = _6_18_
    local _8_19_ = startangle
    local angle = _8_19_
    local function recur(x0, lastx0, lasty0, angle0)
      local rad = math.rad(angle0)
      local y = (offset + (math.sin(rad) * scale_val))
      if ((lastx0 > 0) and (lastx0 <= (width - borderx))) then
        love.graphics.line(x0, y, lastx0, lasty0)
      else
      end
      if (x0 <= width) then
        return recur((x0 + xstep), x0, y, (angle_inc + angle0))
      else
        return nil
      end
    end
    return recur(_2_16_, _4_17_, _6_18_, _8_19_)
  else
    local _ = case_15_
    return error(("Wrong number of args (%s) passed to %s"):format(_, "draw-sine-wave"))
  end
end
draw_sine_wave = draw_sine_wave0
local draw_sine_wave_noise
local function draw_sine_wave_noise0(...)
  local case_28_ = select("#", ...)
  if (case_28_ == 0) then
    local width, height = love.graphics.getDimensions()
    local scale_val = 60
    local angle_inc = 1
    local startangle = 0
    return draw_sine_wave_noise0((height / 2), scale_val, angle_inc, startangle)
  elseif (case_28_ == 1) then
    local offset = ...
    return draw_sine_wave_noise0(offset, 40, 1, 0)
  elseif (case_28_ == 2) then
    return error(("Wrong number of args (%s) passed to %s"):format(2, "draw-sine-wave-noise"))
  elseif (case_28_ == 3) then
    return error(("Wrong number of args (%s) passed to %s"):format(3, "draw-sine-wave-noise"))
  elseif (case_28_ == 4) then
    local offset, scale_val, angle_inc, startangle = ...
    local width, height = love.graphics.getDimensions()
    local xstep = 5
    local borderx = 20
    local _2_29_ = borderx
    local x = _2_29_
    local _4_30_ = 0
    local lastx = _4_30_
    local _6_31_ = 0
    local lasty = _6_31_
    local _8_32_ = startangle
    local angle = _8_32_
    local function recur(x0, lastx0, lasty0, angle0)
      local rad = math.rad(angle0)
      local y = (offset + (custom_random() * scale_val))
      if ((lastx0 > 0) and (lastx0 <= (width - borderx))) then
        love.graphics.line(x0, y, lastx0, lasty0)
      else
      end
      if (x0 <= width) then
        return recur((x0 + xstep), x0, y, (angle0 + angle_inc))
      else
        return nil
      end
    end
    return recur(_2_29_, _4_30_, _6_31_, _8_32_)
  else
    local _ = case_28_
    return error(("Wrong number of args (%s) passed to %s"):format(_, "draw-sine-wave-noise"))
  end
end
draw_sine_wave_noise = draw_sine_wave_noise0
love.keypressed = function(key)
  love.event.quit()
  return love.event.quit()
end
canvas = nil
love.load = function()
  canvas = love.graphics.newCanvas(800, 600)
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.setBlendMode("alpha")
  love.graphics.setColor(0, 1, 0)
  draw_sine_wave_noise()
  return love.graphics.setCanvas()
end
love.draw = function()
  local WIDTH, HEIGHT = love.graphics.getDimensions()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  return love.graphics.draw(canvas, 0, 0)
end
return love.draw
