love.load = function()
  return love.graphics.setBackgroundColor(1, 1, 1)
end
love.draw = function()
  love.graphics.setColor(0, 0, 0)
  return love.graphics.line(20, 50, 480, 50)
end
return love.draw
