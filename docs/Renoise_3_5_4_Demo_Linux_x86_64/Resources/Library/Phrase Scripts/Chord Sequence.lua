--[[
  Simple chord progression, created from a scale.
--]]

local modes = { "Major", "Minor" }
local roman_numbers = { "I", "II", "III", "IV", "V", "VI", "VII"}

return pattern {
  unit = "1/1",
  parameter = { 
    parameter.enum("mode", modes[1], modes, "Scale"),
    parameter.enum("d1", "I", roman_numbers, "1. Degree"),
    parameter.enum("d2", "V", roman_numbers, "2. Degree"),
    parameter.enum("d3", "VI", roman_numbers, "3. Degree"),
    parameter.enum("d4", "IV", roman_numbers, "4. Degree"),
  },
  event = function (context)
    -- Get parameter values
    local mode = context.parameter.mode
    local d1, d2, d3, d4 = context.parameter.d1, context.parameter.d2, 
      context.parameter.d3, context.parameter.d4
    -- Create a scale from the mode parameter
    local s = scale("c4", mode)
    -- Create a chord sequence frm the degree parameters
    local chords = { s:chord(d1), s:chord(d2), s:chord(d3), s:chord(d4) }
    -- return actual chord in step
    local step = math.imod(context.step, 4)
    return note(chords[step]):volume(0.7)
  end 
}