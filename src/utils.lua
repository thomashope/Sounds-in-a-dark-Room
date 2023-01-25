-- Clamps a number to within a certain range, with optional rounding
function math.clamp(n, low, high) return math.min(math.max(n, low), high) end

-- If the input number is greater than high, returns low. If it's lower than low, returns high
function math.wrap(n, low, high)
	if n > high then return low end
	if n < low then return high end
	return n
end

function debug_print(...)
	if flags.debug then print(...) end
end

function get_filename_without_extension(str)
  return str:match("(.+)%..+")
end

function get_filename(str)
  return str:match("^.+/(.+)$"):match("(.+)%..+")
end

function get_file_extension(str)
  return str:match("^.+(%..+)$")
end