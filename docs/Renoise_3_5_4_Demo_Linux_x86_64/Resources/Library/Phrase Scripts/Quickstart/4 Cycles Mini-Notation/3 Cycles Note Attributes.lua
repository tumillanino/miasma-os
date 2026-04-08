-- Set note attributes in cycles
return pattern {
  unit = "1/4",
  -- `:` in combination with `v,p,d,#` sets note attributes
  event = cycle("[c4:v0.5 e4 g4]:<p-0.5 p0.5>")
}

-- TRY THIS: Set instrument with #: e4(3,4):#4
-- TRY THIS: use `[c4 g5]:v=<0.1 0.8>` as shortcut

-- See https://tidalcycles.org/docs/reference/mini_notation/
-- for more info about the Tidal Cycles mini-notation