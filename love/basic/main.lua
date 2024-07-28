local x,y,w,h = 0, 0, 0, 0
love.load = function()
  local x0,y0,w0,h0 = 20, 20, 60, 20
  return nil
end
love.update = function(dt)
  w = (w + 1)
  h = (h + 1)
  return nil
end
love.draw = function()
  love.graphics.setColor(0, 0.4, 0.4)
  return love.graphics.rectangle("fill", x, y, w, h)
end
return love.draw
