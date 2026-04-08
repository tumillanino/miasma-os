--[[
  A note pattern created from a scale, distributed via euclidean patterns.
  Variation paramters allow shifting the 2nd and 4th part of the sequence.
--]]

-- Scale we're creating the note pattern from
local s = scale("c3", "minor")

return pattern {
  unit = "1/16",
  parameter = {
    parameter.integer("var1", 0, {0, 8}, "Variation 1"),
    parameter.integer("var2", 0, {0, 8}, "Variation 2"),
  },
  event = function(context)
    local v1, v2 = context.parameter.var1, context.parameter.var2
     -- Create a notes pattern from euclidean distributed chords 
    local notes =
      pulse.from(s:chord("I", 3)):euclidean(8) + 
      pulse.from(s:chord("VI", 3)):euclidean(8, v1):reverse() +
      pulse.from(s:chord("V", 3)):euclidean(8) +
      pulse.from(s:chord("III", 5)):euclidean(8, v2):reverse()
    -- Cycle through notes with every new step
    local step = math.imod(context.step, #notes)
    return note(notes[step])
  end
}
