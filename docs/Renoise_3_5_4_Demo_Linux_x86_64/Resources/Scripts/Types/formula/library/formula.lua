---@meta
error("Do not try to execute this file. It's just a type definition file.")


--- helper function to define types without actual values

---@return number
local function some_number() end
---@return integer
local function some_integer() end
---@return integer
local function zero_or_one() end


--- Input/Output variables

---First input parameter [0..1]
A = some_number()
---Second input parameter [0..1]
B = some_number()
---Third input parameter [0..1]
C = some_number()
---Output parameter from previous run
OUTPUT = some_number()


--- Musical variables

---Playing or stopped (1 or 0)
PLAYING = zero_or_one()
---Actual sampling rate
SRATE = some_integer()
---Beats per minute
BPM = some_integer()
---Lines per beat
LPB = some_integer()
---Ticks per line
TPL = some_integer()
---Samples per line
SPL = some_integer()
---Number of lines in current pattern
NUMLINES = some_integer()

---Tick number in current line
TICK = some_integer()
---Line number in current pattern
LINE = some_integer()
---Line number with tick fractions
LINEF = some_number()

---Absolute position in song in samples
SAMPLES = some_integer()
---Absolute position in song in beats
BEATS = some_number()
---Absolute position in song in lines
LINES = some_integer()
---Absolute position in song in patterns
SEQPOS = some_integer()

---Continuously running sample counter
SAMPLECOUNTER = some_integer()
---Continuously running tick counter
TICKCOUNTER = some_integer()
---Continuously running line counter
LINECOUNTER = some_integer()
---Line counter with tick fractions
LINEFCOUNTER = some_number()
