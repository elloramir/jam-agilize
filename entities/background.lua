-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local Sprite = require("entities.sprite")
local Background = Sprite:extend()

function Background:new()
    Background.super.new(self, 0, 0)
    self:set_order(0)
    self.pivot_x = 0
    self.pivot_y = 0
    self:set_image(assets.background)
end

return Background