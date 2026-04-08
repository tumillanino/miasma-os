-- Identifiers in cycles can be dynamically mapped to something else
local s = scale("C4", "minor")

return cycle("I III V VII"):map(function(context, value)
  -- value here is a single roman number from the cycle above
  local degree = value
  -- apply value as roman number chord degree
  return s:chord(degree)
end)

-- TRY THIS: Change scale to "major", "dorian", or "pentatonic minor"
-- TRY THIS: use identifiers and map them to notes via a table
--   `:map{ bd="c4 #1", sn="g4 #2"}`
