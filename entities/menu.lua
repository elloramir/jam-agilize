-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = require("level")
local assets = require("assets")
local Entity = require("entity")
local Menu = Entity:extend()

function Menu:new()
    Menu.super.new(self)
    self:set_order(ORDER_UI)
    self.offset_x = 0
    self.offset_y = 0
end

function Menu:update(dt)
    Menu.super.update(self, dt)

    self.offset_x = self.offset_x + 30 * dt
    self.offset_y = self.offset_y + 30 * dt

    if love.keyboard.isDown("space") then
        level.load()
    end
end

function Menu:post_draw()
    -- draw a lot of  rectangles scrolling infinitely
    local t_size = 32
    local x = self.offset_x
    local y = self.offset_y
    local tiles_x = math.ceil((x + WIDTH) / t_size)
    local tiles_y = math.ceil((y + HEIGHT) / t_size)

    for i = 0, tiles_x do
        for j = 0, tiles_y do
            if (i + j) % 2 == 0 then
                love.graphics.setColor(0, 0, 0, 0.5)
            else
                love.graphics.setColor(0, 0, 0, 0.3)
            end

            love.graphics.rectangle("fill", i * t_size - x, j * t_size - y, t_size, t_size)
        end
    end

    -- wobble
    local wobble = math.sin(love.timer.getTime() * 5) * 5

    -- press any button
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(assets.font)
    love.graphics.printf("Press any SPACE to start", 0, HEIGHT/2 + wobble, WIDTH, "center")

    love.graphics.setColor(1, 1, 1, self.opacity)
    love.graphics.printf({
        {1, 1, 1}, "A game by:\n",
        {0.7, 075, 0}, "Elloramir\n",
        {0, 0.7, 0.7}, "Rosendo\n",
        {0.7, 0, 0.7}, "PG Ninja"
    }, 0, 215, WIDTH, "center")
end

return Menu