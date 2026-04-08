--[[
  Drum pattern cycle.
  Sample #0: HiHat, #1: Kick, #2: Snare
--]]

return cycle(
  "[<h1 h2 h2>*12] ,"..
  "[kd ~]*2 ~ [~ kd] ~ ,"..
  "[~ s1]*2 ,"..
  "[~ s2]*8"
):map({
  kd = "c4 #0", -- Kick
  s1 = "c4 #1", -- Snare
  s2 = "c4 #1 v0.1", -- Ghost snare
  h1 = "c4 #2", -- Hat
  h2 = "c4 #2 v0.2", -- Hat
})
