--[[
  C64 alike arp swell with volume and pan modulation.
--]]

local chord = {"c4", "e4", "g4"}

return pattern {
  unit = "1/32",
  parameter = { 
    parameter.integer("length", 16, {1, 256}, 
      "Mod.Length", "Length of the modulation in units") 
  },
  event = function(context)
    local step = math.imod(context.step, #chord)
    local note = chord[step]
    local mod_length = context.parameter.length
    -- Calculate volume for a dynamic feel
    local volume = 0.7 + 0.3 * math.cos(context.step / mod_length * 2 * math.pi)
    -- Calculate panning to spread the sound
    local panning = math.sin(context.step / mod_length * 2 * math.pi)
    -- Emit the note event
    return {
        key = note,
        volume = volume,
        panning = panning
    }
end
}