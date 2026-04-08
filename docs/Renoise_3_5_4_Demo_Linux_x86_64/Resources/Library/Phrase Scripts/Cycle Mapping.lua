--[[
  Cycle with dynamic map function which converts roman numbers into chords.
--]]

local c_minor = scale("c3", "minor")

return pattern {
  unit = "1/1",
  repeats = 0,
  event = cycle("I _ V _!2 III _ VI"):map(
    function(context, value)
      return value ~= "_" and c_minor:chord(value) or value
    end
  )
}
