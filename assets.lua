-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Sheet = require("sheet")
local assets = {}

function assets.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setLineStyle("rough")

  assets.player_car = Sheet("assets/car.png")
end

return assets
