---@meta
error("Do not try to execute this file. It's just a type definition file.")


---Create a new, or convert an exiting table to an object that uses the global
---'table.XXX' functions as methods, just like strings in Lua do.
---@param t table?
---### examples:
---```lua
---t = table.create(); t:insert("a"); rprint(t) -> [1] = a;
---t = table.create{1,2,3}; print(t:concat("|")); -> "1|2|3";
---```
function table.create(t)
  return setmetatable(t or {}, { __index = _G.table })
end

---Returns true when the table is empty, else false and will also work
---for non indexed tables
---@param t table
---@return boolean
---### examples:
---```lua
---t = {};          print(table.is_empty(t)); -> true;
---t = {66};        print(table.is_empty(t)); -> false;
---t = {["a"] = 1}; print(table.is_empty(t)); -> false;
function table.is_empty(t) end

---Count the number of items of a table, also works for non index
---based tables (using pairs).
---@param t table
---@returns integer
---### examples:
---```lua
---t = {["a"]=1, ["b"]=1}; print(table.count(t)) --> 2
---```
function table.count(t) end

---Find first match of *value* in the given table, starting from element
---number *start_index*.<br>
---Returns the first *key* that matches the value or nil
---@param t table
---@param value any
---@param start_index integer?
---@return (string|integer|number)? key_or_nil
---### examples:
---```lua
---t = {"a", "b"}; table.find(t, "a") --> 1
---t = {a=1, b=2}; table.find(t, 2) --> "b"
---t = {"a", "b", "a"}; table.find(t, "a", 2) --> "3"
---t = {"a", "b"}; table.find(t, "c") --> nil
---```
function table.find(t, value, start_index) end

---Return an indexed table of all keys that are used in the table.
---@param t table
---@return table
---### examples:
---```lua
---t = {a="aa", b="bb"}; rprint(table.keys(t)); --> "a", "b"
---t = {"a", "b"};       rprint(table.keys(t)); --> 1, 2
---```
function table.keys(t) end

---Return an indexed table of all values that are used in the table
---@param t table
---@return table
---### examples:
---```lua
--- t = {a="aa", b="bb"}; rprint(table.values(t)); --> "aa", "bb"
--- t = {"a", "b"};       rprint(table.values(t)); --> "a", "b"
---```
function table.values(t) end

---Copy the metatable and all first level elements of the given table into a
---new table. Use table.rcopy to do a recursive copy of all elements
---@param t table
---@return table
function table.copy(t) end

---Deeply copy the metatable and all elements of the given table recursively
---into a new table - create a clone with unique references.
---@param t table
---@return table
function table.rcopy(t) end

---Recursively clears and removes all table elements.
---@param t table
function table.clear(t) end
