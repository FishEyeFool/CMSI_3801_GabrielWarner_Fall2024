function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

function first_then_lower_case(string_table, predicate)

  for _, string in pairs(string_table) do
    if predicate(string) then
      return string.lower(string)
    end
  end
  return nil
end

function powers_generator(base, limit)
  local power = 1
  return coroutine.create(function ()
    while power <= limit do
      coroutine.yield(power)
      power = power * base
    end
  end)
end

function say(word)
  if word == nil then
    return ""
  end
  return function(next)
    if next == nil then
      return word
    else
      return say(word .. " " .. next)
    end
  end
end

function meaningful_line_count(fileName)
  local file, _ = io.open(fileName, "r")

  if not file then
      error(string.format("No such file", fileName))
  end

  local lineCount = 0

  for line in file:lines() do
      local strippedLine = line:gsub("^%s*(.-)%s*$", "%1")
      if strippedLine ~= "" and not strippedLine:match("^%s*#") then
          lineCount = lineCount + 1
      end
  end

  file:close()

  return lineCount
end


Quaternion = {}
Quaternion.__index = Quaternion

function Quaternion.new(a, b, c, d)
    local self = setmetatable({}, Quaternion)
    self.a = a or 0
    self.b = b or 0
    self.c = c or 0
    self.d = d or 0
    return self
end

function Quaternion:__tostring()
  local parts = {}

    if self.a ~= 0 then
      table.insert(parts, tostring(self.a))
    end

    if self.b ~= 0 then
      if self.b == 1 then
        table.insert(parts, "+i")
      elseif self.b == -1 then
        table.insert(parts, "-i")
      else
        if self.b > 0 and #parts > 0 then
          table.insert(parts, "+" .. tostring(self.b) .. "i")
        else
          table.insert(parts, tostring(self.b) .. "i")
        end
      end
    end

    if self.c ~= 0 then
      if self.c == 1 then
        table.insert(parts, "+j")
      elseif self.c == -1 then
        table.insert(parts, "-j")
      else
        if self.c > 0 and #parts > 0 then
          table.insert(parts, "+" .. tostring(self.c) .. "j")
        else
          table.insert(parts, tostring(self.c) .. "j")
        end
      end
    end

    if self.d ~= 0 then
      if self.d == 1 then
        table.insert(parts, "+k")
      elseif self.d == -1 then
        table.insert(parts, "-k")
      else
        if self.d > 0 and #parts > 0 then
          table.insert(parts, "+" .. tostring(self.d) .. "k")
        else
          table.insert(parts, tostring(self.d) .. "k")
        end
      end
    end

  local result = table.concat(parts)

  if result == "" then
    return "0"
  end
  if result:sub(1, 1) == "+" then
    result = result:sub(2)
  end

  return result
end

function Quaternion:__add(other)
  if getmetatable(other) == Quaternion then
    return Quaternion.new(
      self.a + other.a,
      self.b + other.b,
      self.c + other.c,
      self.d + other.d
    )
  else
    return nil
  end
end

function Quaternion:__mul(other)
  if getmetatable(other) == Quaternion then
    local a1, b1, c1, d1 = self.a, self.b, self.c, self.d
    local a2, b2, c2, d2 = other.a, other.b, other.c, other.d

    return Quaternion.new(
      a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2,
      a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2,
      a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2,
      a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2
    )
  else
    return nil
  end
end

function Quaternion:__eq(other)
  if getmetatable(other) == Quaternion then
    return self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d
  else
    return false
  end
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end
