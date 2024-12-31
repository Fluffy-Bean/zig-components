const c = @import("c.zig").c;

pub const ColorSurfaceLow = c.Color{
    .r = 35,
    .g = 34,
    .b = 26,
    .a = 255,
};
pub const ColorSurface = c.Color{
    .r = 41,
    .g = 40,
    .b = 31,
    .a = 255,
};
pub const ColorSurfaceHigh = c.Color{
    .r = 61,
    .g = 60,
    .b = 51,
    .a = 255,
};
pub const ColorForeground = c.Color{
    .r = 234,
    .g = 232,
    .b = 219,
    .a = 255,
};
pub const ColorAccent = c.Color{
    .r = 200,
    .g = 92,
    .b = 23,
    .a = 255,
};
