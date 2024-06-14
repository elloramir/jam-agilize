-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local Sprite = require("entities.sprite")
local Trail = Sprite:extend()

function Trail:new(x, y, strength)
  Trail.super.new(self, x, y)
  self:set_order(ORDER_PLAYER - 1)
  self:set_image(assets.trail)
  self.color[4] = strength
end

function Trail:update(dt)
  self.color[4] = self.color[4] - dt
  if self.color[4] <= 0 then
    self:destroy()
  end
end

return Trail
