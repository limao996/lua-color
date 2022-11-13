local math, tonumber, type, pairs = math, tonumber, type, pairs
local _M = {
    TRANSPARENT = "#0000",
    CYAN = "#0ff",
    BLACK = "#000",
    RED = "#f00",
    BLUE = "#00f",
    YELLOW = "#ff0",
    WHITE = "#fff",
    MAGENTA = "#f0f",
    DKGRAY = "#444",
    LTGRAY = "#ccc",
    GREEN = "#0f0",
    GRAY = "#888"
}

function _M.rgb2hsv(r, g, b)
    r = r / 255
    g = g / 255
    b = b / 255
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local v = max
    local d = max - min
    local s
    if max == 0 then
        s = 0
    else
        s = d / max
    end
    local h = 0
    if max ~= min then
        local _exp_0 = max
        if r == _exp_0 then
            local _
            if g < b then
                _ = 6
            else
                _ = 0
            end
            h = (g - b) / d + _
        elseif g == _exp_0 then
            h = (b - r) / d + 2
        elseif b == _exp_0 then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h * 360, s, v
end

function _M.color2hsv(i)
    return _M.rgb2hsv(_M.color2rgb(i))
end

function _M.rgb2hsl(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local min = math.min(r, g, b)
    local max = math.max(r, g, b)
    local delta = max - min
    local h, s, l = 0, 0, ((min + max) / 2)

    if l > 0 and l < 0.5 then
        s = delta / (max + min)
    end
    if l >= 0.5 and l < 1 then
        s = delta / (2 - max - min)
    end

    if delta > 0 then
        if max == r and max ~= g then
            h = h + (g - b) / delta
        end
        if max == g and max ~= b then
            h = h + 2 + (b - r) / delta
        end
        if max == b and max ~= r then
            h = h + 4 + (r - g) / delta
        end
        h = h / 6
    end

    if h < 0 then
        h = h + 1
    elseif h > 1 then
        h = h - 1
    end

    return h * 360, s, l
end

function _M.color2hsl(i)
    return _M.rgb2hsl(_M.color2rgb(i))
end

function _M.hsv2rgb(h, s, v)
    h = (h % 360) / 360
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    local r, g, b = 0
    local _exp_0 = i % 6
    if 0 == _exp_0 then
        r = v
        g = t
        b = p
    elseif 1 == _exp_0 then
        r = q
        g = v
        b = p
    elseif 2 == _exp_0 then
        r = p
        g = v
        b = t
    elseif 3 == _exp_0 then
        r = p
        g = q
        b = v
    elseif 4 == _exp_0 then
        r = t
        g = p
        b = v
    elseif 5 == _exp_0 then
        r = v
        g = p
        b = q
    end
    return r * 255 // 1, g * 255 // 1, b * 255 // 1
end

local function _h2rgb(m1, m2, h)
    if h < 0 then
        h = h + 1
    elseif h > 1 then
        h = h - 1
    end
    local r
    if h * 6 < 1 then
        r = m1 + (m2 - m1) * h * 6
    elseif h * 2 < 1 then
        r = m2
    elseif h * 3 < 2 then
        r = m1 + (m2 - m1) * (2 / 3 - h) * 6
    else
        r = m1
    end
    return (r * 255) // 1
end

function _M.hsl2rgb(h, s, l)
    h = (h % 360) / 360
    if s < 0 then
        s = 0
    elseif s > 1 then
        s = 1
    end
    if l < 0 then
        l = 0
    elseif l > 1 then
        l = 1
    end

    local m1, m2
    if l <= 0.5 then
        m2 = l * (s + 1)
    else
        m2 = l + s - l * s
    end
    m1 = l * 2 - m2

    return _h2rgb(m1, m2, h + 1 / 3), _h2rgb(m1, m2, h), _h2rgb(m1, m2, h - 1 / 3)
end

function _M.color2rgb(i)
    return i >> 16 & 0xff, i >> 8 & 0xff, i & 0xff
end

function _M.color2argb(i)
    return i >> 24 & 0xff, i >> 16 & 0xff, i >> 8 & 0xff, i & 0xff
end

function _M.rgb2color(r, g, b)
    return 0xff000000 + (r << 16) + (g << 8) + b
end

function _M.argb2color(a, r, g, b)
    return (a << 24) + (r << 16) + (g << 8) + b
end

function _M.hsl2color(h, s, l)
    return _M.rgb2color(_M.hsl2rgb(h, s, l))
end

function _M.hsv2color(h, s, v)
    return _M.rgb2color(_M.hsv2rgb(h, s, v))
end

function _M.parse(hex)
    hex = hex:sub(2)
    local size, num = #hex
    if size % 3 == 0 then
        size = size // 3
        num = 3
    else
        size = size // 4
        num = 4
    end

    local n = tonumber(hex, 16)
    local bit = size * 4
    local i = 2 ^ bit - 1
    local p = 0xff / i
    local a = (n >> (bit * 3) & i) * p
    local r = (n >> (bit * 2) & i) * p
    local g = (n >> (bit * 1) & i) * p
    local b = (n & i) * p

    if num == 3 and a == 0 then
        a = 255
    end

    return (a << 24) + (r << 16) + (g << 8) + b
end

function _M.format(color)
    local a, r, g, b = _M.color2argb(color)
    local fmt, fmt1 = '#%02x%02x%02x', '#%04x%02x%02x'
    if a ~= 255 then
        fmt = fmt1
        r = (a << 8) + r
    end
    return fmt:format(r, g, b)
end

function _M.alpha(color, n)
    if not n then
        return color >> 24 & 0xff
    end
    local r, g, b = _M.color2rgb(color)
    return _M.argb2color(n, r, g, b)
end

function _M.red(color, n)
    if not n then
        return color >> 16 & 0xff
    end
    local a, r, g, b = _M.color2argb(color)
    return _M.argb2color(a, n, g, b)
end

function _M.green(color, n)
    if not n then
        return color >> 8 & 0xff
    end
    local a, r, g, b = _M.color2argb(color)
    return _M.argb2color(a, r, n, b)
end

function _M.blue(color, n)
    if not n then
        return color & 0xff
    end
    local a, r, g = _M.color2argb(color)
    return _M.argb2color(a, r, g, n)
end

function _M.to_color(t)
    local tp = type(t)

    if tp == 'string' then
        return _M.parse(t)
    elseif tp == 'number' then
        return t
    end

    if t.type == 1 then
        return _M.argb2color(t.A, _M.hsv2rgb(t.H, t.S, t.V))
    elseif t.type == 2 then
        return _M.argb2color(t.A, _M.hsl2rgb(t.H, t.S, t.L))
    end

    return _M.argb2color(t.A, t.R, t.G, t.B)
end

function _M.to_rgb(o)
    o = _M.to_color(o)
    local a, r, g, b = _M.color2argb(o)
    return {
        type = 0,
        A = a,
        R = r,
        G = g,
        B = b
    }
end

function _M.to_hsv(o)
    o = _M.to_color(o)
    local h, s, v = _M.color2hsv(o)
    local a = _M.alpha(o)
    return {
        type = 1,
        A = a,
        H = h,
        S = s,
        V = v
    }
end

function _M.to_hsl(o)
    o = _M.to_color(o)
    local h, s, l = _M.color2hsl(o)
    local a = _M.alpha(o)
    return {
        type = 2,
        A = a,
        H = h,
        S = s,
        L = l
    }
end

function _M.to_hex(o)
    o = _M.to_color(o)
    return _M.format(o)
end

function _M.is_dark(o)
    o = _M.to_color(o)
    local r, g, b = _M.color2rgb(o)
    return r * 0.299 + g * 0.587 + b * 0.114 < 192
end

function _M.eval(s, e, is)
    s = _M.to_hsv(s)
    e = _M.to_hsv(e)
    local A1, H1, S1, V1 = s.A, s.H, s.S, s.V
    local A2, H2, S2, V2 = e.A, e.H, e.S, e.V

    if not is then
        if (H2 - H1 > 180) then
            H2 = H2 - 360
        elseif (H2 - H1 < -180) then
            H2 = H2 + 360
        end
    end

    return function(f)
        local A = A1 + ((A2 - A1) * f)
        local H = H1 + ((H2 - H1) * f)
        local S = S1 + ((S2 - S1) * f)
        local V = V1 + ((V2 - V1) * f)
        local color = _M.hsv2color(H, S, V)
        return _M.alpha(color, A // 1)
    end
end

for k, v in pairs(_M) do
    local a = k:sub(1, 1)
    if a:upper() == a then
        _M[k] = _M.parse(v)
    end
end

return _M
