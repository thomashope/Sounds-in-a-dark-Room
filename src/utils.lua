-- Clamps a number to within a certain range, with optional rounding
function math.clamp(n, low, high) return math.min(math.max(n, low), high) end

function math.wrap(n, low, high)
	if n > high then return low end
	if n < low then return high end
	return n
end