--[[
  Random bassline generator with configurable seeds (variations)
--]]

-- generate pretty list of all scales
local scales = scale_names() 
for k,s in pairs(scales) do
  scales[k] = s:gsub("^%l", string.upper):gsub(" %l", string.upper)
end

return pattern {
  parameter = {
    parameter.enum('scale', scales[2], scales, "Scale"),
    parameter.integer('notes', 7, {1, 12}, "#Notes"),
    parameter.integer('variation', 0, {0, 0xff}, "Variation"),
  },
  unit = "1/1",
  pulse = function (context)
    local rand = math.randomstate(2345 + context.parameter.variation)
    return pulse.euclidean(rand(3, 16), 16, 0)
  end,
  event = function(context)
    local notes = scale("c4", context.parameter.scale).notes
    local rand = math.randomstate(127364 + context.parameter.variation)
    local notes = pulse.new(context.parameter.notes):map(function(_)
      return notes[rand(#notes)]
    end)
    return notes[math.imod(context.step, #notes)]
  end
}
