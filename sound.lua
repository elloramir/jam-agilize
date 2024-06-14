-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Object = require("classic")
local Sound = Object:extend()

Sound.base_volume = 1

function Sound:new(filename)
    self.bus = {}

    for i = 1, MAX_AUDIO_STACK do
        local sound = love.audio.newSource(filename, "static")
        table.insert(self.bus, sound)
    end
end

function Sound.change_base_volume(volume)
    Sound.base_volume = volume
end

function Sound:play(volume, pitch)
    for i, sampler in ipairs(self.bus) do
        if not sampler:isPlaying() then
            sampler:play()
            sampler:setVolume((volume or 1) * Sound.base_volume)
			sampler:setPitch(pitch or 1)
            return sampler
        end
    end
end

return Sound