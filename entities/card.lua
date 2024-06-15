-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local tick = require("tick")
local flux = require("flux")
local Entity = require("entity")
local Card = Entity:extend()

local CARD_WIDTH = 100
local CARD_HEIGHT = 160
local CARD_MARGIN = 30
local CARD_TOTAL = 3 
local CARD_X = (WIDTH - (CARD_WIDTH * CARD_TOTAL + CARD_MARGIN * (CARD_TOTAL - 1))) / 2

function Card:new(index, type)
    Card.super.new(self)

    self:set_order(ORDER_UI)

    self.x = math.floor((index - 1) * CARD_WIDTH + CARD_X + (index - 1) * CARD_MARGIN)
    self.y = math.floor((HEIGHT - CARD_HEIGHT) / 2)
    self.offset = 300

    tick.delay(function()
        flux.to(self, 1, {offset = 0}):ease("backout")
    end, (index - 1) * 0.25)
end

function Card:cursor_is_over()
    local mx, my = get_mouse()

    return
        mx >= self.x and mx <= self.x + CARD_WIDTH and
        my >= self.y + self.offset and
        my <= self.y + CARD_HEIGHT + self.offset
end

function Card:update(dt)
    -- if self.offset = 0 te
    -- local target = self:cursor_is_over() and -20 or 0
    -- self.offset = approach(self.offset, target, 10)
end

function Card:post_draw()
    -- shadow
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x + 4, self.y + self.offset + 4, CARD_WIDTH, CARD_HEIGHT, 4)
    love.graphics.setColor(22/255, 22/255, 26/255)
    love.graphics.rectangle("fill", self.x, self.y + self.offset, CARD_WIDTH, CARD_HEIGHT, 4)
end

return Card