const math = @import("std").math;
const c = @import("c.zig").c;

pub const Eases = enum {
    linearIn, linearOut, linearInOut,
    sineIn,   sineOut,   sineInOut,
    circIn,   circOut,
    cubicIn,  cubicOut,
    quadIn,   quadOut,
    expoIn,   expoOut,
};

pub const Animate = struct {
    progress:  f32,
    animating: bool,

    _start:  f32,
    _end:    f32,
    _length: f32,
    _ease:   Eases,
    _time:   f32,

    pub fn New(
        start:  f32,
        end:    f32,
        length: f32,
        ease:   Eases,
    ) Animate {
        return Animate{
            .progress = 0,
            .animating = true,

            ._start = start,
            ._end = end,
            ._length = length,
            ._ease = ease,
            ._time = 0,
        };
    }

    pub fn Update(
        self: *Animate,
    ) void {
        self._time += c.GetFrameTime();

        self.progress = switch (self._ease) {
            .linearIn    => easeLinear(self._start, self._end, self._time / self._length),
            .linearOut   => easeLinearIn(self._start, self._end, self._time / self._length),
            .linearInOut => easeLinearOut(self._start, self._end, self._time / self._length),
            .sineIn      => easeLinearInOut(self._start, self._end, self._time / self._length),
            .sineOut     => easeSineIn(self._start, self._end, self._time / self._length),
            .sineInOut   => easeSineOut(self._start, self._end, self._time / self._length),
            .circIn      => easeSineInOut(self._start, self._end, self._time / self._length),
            .circOut     => easeCircIn(self._start, self._end, self._time / self._length),
            .cubicIn     => easeCircOut(self._start, self._end, self._time / self._length),
            .cubicOut    => easeCubicIn(self._start, self._end, self._time / self._length),
            .quadIn      => easeCubicOut(self._start, self._end, self._time / self._length),
            .quadOut     => easeQuadIn(self._start, self._end, self._time / self._length),
            .expoIn      => easeQuadOut(self._start, self._end, self._time / self._length),
            .expoOut     => easeExpoIn(self._start, self._end, self._time / self._length),
        };

        if (self._time >= self._length) self.animating = false;
    }
};

fn easeLinear(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * time;
}

fn easeLinearIn(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * time;
}

fn easeLinearOut(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * time;
}

fn easeLinearInOut(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * time;
}

fn easeSineIn(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * (1 - math.cos(time * (math.pi / 2.0)));
}

fn easeSineOut(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * math.sin(time * (math.pi / 2.0));
}

fn easeSineInOut(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * 0.5 * (1 - math.cos(time * math.pi));
}

fn easeCircIn(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * (1 - math.sqrt(1 - time * time));
}

fn easeCircOut(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * math.sqrt(1 - (time - 1) * (time - 1));
}

fn easeCubicIn(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * time * time * time;
}

fn easeCubicOut(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1) - 1;
    return a + (b - a) * (time * time * time + 1);
}

fn easeQuadIn(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * time * time;
}

fn easeQuadOut(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * (1 - (1 - time) * (1 - time));
}

fn easeExpoIn(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * (if (time == 0) 0 else math.pow(f32, 2, 10 * (time - 1)));
}

fn easeExpoOut(a: f32, b: f32, t: f32) f32 {
    const time: f32 = math.clamp(t, 0, 1);
    return a + (b - a) * (if (time == 1) 1 else 1 - math.pow(f32, 2, -10 * time));
}
