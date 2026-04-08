--[[
  Polyrythm from two stacks with different timings.
--]]

return cycle(
  "[C3 D#4 F3 G#4]:v=<0.8 0.6>, "..
  "[[D#3?0.2 G4 F4]:p=<0.8 -0.8>/64]*63"
)