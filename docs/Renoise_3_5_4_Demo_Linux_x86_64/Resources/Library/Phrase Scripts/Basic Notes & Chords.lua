--[[
  Variation of the beginning of the tetris theme.
--]]

return pattern {
  unit = "1/4",  
  pulse = { 1, { 1, 1 } }, -- 1/4, 1/8, 1/8
  event = {
    "e5'm", "b4", "c5'5" , "d5"  , "c5" , "b4" , 
    "a4'm", "--", "c5'5" , "d5"  , "d5" , "c5" , 
    "b4'm", "--", "c5'5" , "d5"  , "e5" , "--", 
    "c5'M", "a4", "--"   , "a4'5", "--" , "--"
  }
}
