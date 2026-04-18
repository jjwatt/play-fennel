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
local function cutom_random()
  return (1 - (math.random(0, 1) ^ 5))
end
local draw_sine_wave
local function draw_sine_wave0(...)
  local case_6_ = select("#", ...)
  if (case_6_ == 0) then
    local width, height = love.graphics.getDimensions()
    local scale_val = 40
    local angle_inc = 1
    local startangle = 0
    return draw_sine_wave0((height / 2), scale_val, angle_inc, startangle)
  elseif (case_6_ == 1) then
    local offset = ...
    return draw_sine_wave0(offset, 40, 1, 0)
  elseif (case_6_ == 2) then
    return error(("Wrong number of args (%s) passed to %s"):format(2, "draw-sine-wave"))
  elseif (case_6_ == 3) then
    return error(("Wrong number of args (%s) passed to %s"):format(3, "draw-sine-wave"))
  elseif (case_6_ == 4) then
    local offset, scale_val, angle_inc, startangle = ...
    local width, height = love.graphics.getDimensions()
    local xstep = 5
    local borderx = 20
    local _2_7_ = borderx
    local x = _2_7_
    local _4_8_ = 0
    local lastx = _4_8_
    local _6_9_ = 0
    local lasty = _6_9_
    local _8_10_ = startangle
    local angle = _8_10_
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
    return recur(_2_7_, _4_8_, _6_9_, _8_10_)
  else
    local _ = case_6_
    return error(("Wrong number of args (%s) passed to %s"):format(_, "draw-sine-wave"))
  end
end
draw_sine_wave = draw_sine_wave0
local draw_sine_wave_noise
local function draw_sine_wave_noise0(...)
  local case_19_ = select("#", ...)
  if (case_19_ == 0) then
    local width, height = love.graphics.getDimensions()
    local scale_val = 60
    local angle_inc = 1
    local startangle = 0
    return draw_sine_wave_noise0((height / 2), scale_val, angle_inc, startangle)
  elseif (case_19_ == 1) then
    local offset = ...
    return draw_sine_wave_noise0(offset, 40, 1, 0)
  elseif (case_19_ == 2) then
    return error(("Wrong number of args (%s) passed to %s"):format(2, "draw-sine-wave-noise"))
  elseif (case_19_ == 3) then
    return error(("Wrong number of args (%s) passed to %s"):format(3, "draw-sine-wave-noise"))
  elseif (case_19_ == 4) then
    local offset, scale_val, angle_inc, startangle = ...
    local width, height = love.graphics.getDimensions()
    local xstep = 5
    local borderx = 20
    local _2_20_ = borderx
    local x = _2_20_
    local _4_21_ = 0
    local lastx = _4_21_
    local _6_22_ = 0
    local lasty = _6_22_
    local _8_23_ = startangle
    local angle = _8_23_
    local function recur(x0, lastx0, lasty0, angle0)
      local rad = math.rad(angle0)
      local y = (offset + (__fnl_global__custom_2drandom() * scale_val))
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
    return recur(_2_20_, _4_21_, _6_22_, _8_23_)
  else
    local _ = case_19_
    return error(("Wrong number of args (%s) passed to %s"):format(_, "draw-sine-wave-noise"))
  end
end
draw_sine_wave_noise = draw_sine_wave_noise0
love.keypressed = function(key)
  return love.event.quit()
end
canvas = nil
love.load = function()
  canvas = love.graphics.newCanvas(800, 600)
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.setBlendMode("alpha")
  love.graphics.setColor(0, 1, 0)
  draw_sine_wave(200, 30, 1, 0)
  draw_sine_wave(300, 100, 1, 0)
  return love.graphics.setCanvas()
end
love.draw = function()
  local WIDTH, HEIGHT = love.graphics.getDimensions()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1, 1, 1, 1)
  return love.graphics.draw(canvas, 0, 0)
end
return love.draw
