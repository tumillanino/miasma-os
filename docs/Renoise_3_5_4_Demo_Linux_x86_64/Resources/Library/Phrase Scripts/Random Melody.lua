--[[
  Combine two randomly generated euclidean rhythms
  with randomly generated notes in a given scale
--]]

local UNIT = "1/16"
local PATTERN_LEN = 16
local MELODY_LEN = PATTERN_LEN * 2

-- Create a random rhythm from two Euclidean rhythms
local function generate_rhythm(seed)
  -- Create a new local random number generator
  local rand = math.randomstate(1234 + seed)

  -- Generate the primary Euclidean rhythm pattern
  local primary = pulse.euclidean(
    rand(1, PATTERN_LEN / 2), PATTERN_LEN)
  -- Generate a secondary Euclidean rhythm pattern
  local secondary = pulse.euclidean(
    rand(1, PATTERN_LEN / 2), PATTERN_LEN)

  -- Volume randomization state
  local volumes = { 0.25, 0.5 }
  local last_volume = 1.0
  local last_step = 1

  -- Combine the two rhythms using the Schillinger principle
  local combined = { 1 }
  for step = 2, #primary do
    if primary[step] == 1 or secondary[step] == 1 then
      -- randomize note volume
      local volume = (step % 4 == 1) and 1.0 or volumes[rand(#volumes)]
      if last_volume < 1.0 or step - last_step > 1 then
        volume = 1.0
      end 
      combined[step] = volume
      last_step = step
      last_volume = volume
    else
      combined[step] = 0
    end
  end
  return combined
end

-- Create a function to map combined rhythm to the scale with randomness
local function generate_melody(pattern_len, scale, seed)
  -- Create a new local random number generator
  local rand = math.randomstate(222 + seed)
  -- generate the melody, starting with the root note
  local melody = { { key = scale[1] } }
  local last_note_index = nil 
  for step = 2, pattern_len do
    -- pick a random note from the scale
    local note_index = rand(#scale)
    while note_index == last_note_index do 
      note_index = rand(#scale)
    end
    last_note_index = note_index
    melody[#melody + 1] = scale[note_index]
  end
  return melody
end

-- generate pretty list of all scales
local scales = scale_names() 
for k,s in pairs(scales) do
  scales[k] = s:gsub("^%l", string.upper):gsub(" %l", string.upper)
end

-- return rhythm
return pattern {
  unit = UNIT,
  parameter = {
    parameter.enum("scale", scales[4], scales, "Scale"),
    parameter.integer("rhythm_seed", 250, { 0, 0xfff }, "Rhythm"),
    parameter.integer("melody_seed", 221, { 0, 0xfff }, "Notes"),
  },
  pulse = function(context)
    -- Generate combined rhythm
    local rhythm = generate_rhythm(context.parameter.rhythm_seed)
    -- Pick pulse from the rhythm for each new step
    return function(context)
      return rhythm[math.imod(context.pulse_step, #rhythm)]
    end
  end,
  event = function(context)
    -- Define the notes that should be used for the melody
    local scale = scale("c", context.parameter.scale).notes
    -- Generate the melody based on the combined rhythm
    local melody = generate_melody(
      MELODY_LEN, scale, context.parameter.melody_seed)
    -- Pick note from the melody and use the pulse value as volume
    ---@param context EmitterContext
    return function(context)
      local step = math.imod(context.pulse_step, #melody)
      return note(melody[step]):volume(context.pulse_value)
    end
  end
}