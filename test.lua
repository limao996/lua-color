local color = require 'color'

local a, b = '#f18', '#f00'

local g = color.eval(b, a, true)
print(color.to_hex(g(0.5)))
