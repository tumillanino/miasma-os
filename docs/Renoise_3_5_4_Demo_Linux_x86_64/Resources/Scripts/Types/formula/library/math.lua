---@meta
error("Do not try to execute this file. It's just a type definition file.")


--- redefine all math consts as globals

---
---Returns the absolute value of `x`.
---
---@generic Number: number
---@param x Number
---@return Number
---@nodiscard
function abs(x) end

---
---Returns the arc cosine of `x` (in radians).
---
---@param x number
---@return number
---@nodiscard
function acos(x) end

---
---Returns the arc sine of `x` (in radians).
---
---@param x number
---@return number
---@nodiscard
function asin(x) end

---
---Returns the arc tangent of `x` (in radians).
---
---@param y number
---@return number
---@nodiscard
function atan(y) end

---@version <5.2
---
---Returns the arc tangent of `y/x` (in radians).
---
---@param y number
---@param x number
---@return number
---@nodiscard
function atan2(y, x) end

---
---Returns the smallest integral value larger than or equal to `x`.
---
---@param x number
---@return integer
---@nodiscard
function ceil(x) end

---
---Returns the cosine of `x` (assumed to be in radians).
---
---@param x number
---@return number
---@nodiscard
function cos(x) end

---@version <5.2
---
---Returns the hyperbolic cosine of `x` (assumed to be in radians).
---
---@param x number
---@return number
---@nodiscard
function cosh(x) end

---
---Converts the angle `x` from radians to degrees.
---
---@param x number
---@return number
---@nodiscard
function deg(x) end

---
---Returns the value `e^x` (where `e` is the base of natural logarithms).
---
---@param x number
---@return number
---@nodiscard
function exp(x) end

---
---Returns the largest integral value smaller than or equal to `x`.
---
---@param x number
---@return integer
---@nodiscard
function floor(x) end

---
---Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.
---
---@param x number
---@param y number
---@return number
---@nodiscard
function fmod(x, y) end

---@version <5.2
---
---Decompose `x` into tails and exponents. Returns `m` and `e` such that `x = m * (2 ^ e)`, `e` is an integer and the absolute value of `m` is in the range [0.5, 1) (or zero when `x` is zero).
---
---@param x number
---@return number m
---@return number e
---@nodiscard
function frexp(x) end

---@version <5.2
---
---Returns `m * (2 ^ e)` .
---
---@param m number
---@param e number
---@return number
---@nodiscard
function ldexp(m, e) end

---
---Returns the logarithm of `x` in the given base.
---
---@param x     number
---@param base? integer
---@return number
---@nodiscard
function log(x, base) end

---@version <5.1
---
---Returns the base-10 logarithm of x.
---
---@param x number
---@return number
---@nodiscard
function log10(x) end

---
---Returns the argument with the maximum value, according to the Lua operator `<`.
---
---@generic Number: number
---@param x Number
---@param ... Number
---@return Number
---@nodiscard
function max(x, ...) end

---
---Returns the argument with the minimum value, according to the Lua operator `<`.
---
---@generic Number: number
---@param x Number
---@param ... Number
---@return Number
---@nodiscard
function min(x, ...) end

---
---Returns the integral part of `x` and the fractional part of `x`.
---
---@param x number
---@return integer
---@return number
---@nodiscard
function modf(x) end

---@version <5.2
---
---Returns `x ^ y` .
---
---@param x number
---@param y number
---@return number
---@nodiscard
function pow(x, y) end

---
---Converts the angle `x` from degrees to radians.
---
---@param x number
---@return number
---@nodiscard
function rad(x) end

---
---* `math.random()`: Returns a float in the range [0,1).
---* `math.random(n)`: Returns a integer in the range [1, n].
---* `math.random(m, n)`: Returns a integer in the range [m, n].
---
---@overload fun():number
---@overload fun(m: integer):integer
---@param m integer
---@param n integer
---@return integer
---@nodiscard
function random(m, n) end

---
---Sets `x` as the "seed" for the pseudo-random generator.
---
---@param x integer
function randomseed(x) end

---
---Returns the sine of `x` (assumed to be in radians).
---
---@param x number
---@return number
---@nodiscard
function sin(x) end

---@version <5.2
---
---Returns the hyperbolic sine of `x` (assumed to be in radians).
---
---@param x number
---@return number
---@nodiscard
function sinh(x) end

---
---Returns the square root of `x`.
---
---@param x number
---@return number
---@nodiscard
function sqrt(x) end

---
---Returns the tangent of `x` (assumed to be in radians).
---
---@param x number
---@return number
---@nodiscard
function tan(x) end

---@version <5.2
---
---Returns the hyperbolic tangent of `x` (assumed to be in radians).
---
---@param x number
---@return number
---@nodiscard
function tanh(x) end


--- Renoise specific additions

---Converts a linear value to a db value. db values will be clipped to INFDB.
---@param n number
---@return number
---### examples:
---```lua
---print(lin2db(1.0)) --> 0
---print(lin2db(0.0)) --> -200 (INFDB)
---```
function lin2db(n) end

---Converts a dB value to a linear value.
---@param n number
---@return number
---### examples:
---```lua
---print(db2lin(INFDB)) --> 0
---print(db2lin(6.0)) --> 1.9952623149689
---```
function db2lin(n) end


--- a few more consts

---The value of *π*.
PI = math.pi

---The value of *2*π*.
TWOPI = 2 * pi

---A value larger than any other numeric value.
INF = math.huge

---A value equal or smaller than this will be treated as silence.
INFDB = -200.0


--- remove global math table

math = nil
