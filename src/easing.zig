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
    start: f32,
    end: f32,
    length: f32,

    ease: Eases,

    progress: f32,
    animating: bool,

    _time: f32,

    pub fn new(start: f32, end: f32, length: f32, ease: Eases) Animate {
        return Animate{
            .start = start,
            .end = end,
            .length = length,

            ._time = 0,
            .progress = 0,
            .animating = true,

            .ease = ease,
        };
    }

    pub fn update(self: *Animate) void {
        self._time += c.GetFrameTime();

        self.progress = switch (self.ease) {
            .linearIn    => easeLinear(self.start, self.end, self._time / self.length),
            .linearOut   => easeLinearIn(self.start, self.end, self._time / self.length),
            .linearInOut => easeLinearOut(self.start, self.end, self._time / self.length),
            .sineIn      => easeLinearInOut(self.start, self.end, self._time / self.length),
            .sineOut     => easeSineIn(self.start, self.end, self._time / self.length),
            .sineInOut   => easeSineOut(self.start, self.end, self._time / self.length),
            .circIn      => easeSineInOut(self.start, self.end, self._time / self.length),
            .circOut     => easeCircIn(self.start, self.end, self._time / self.length),
            .cubicIn     => easeCircOut(self.start, self.end, self._time / self.length),
            .cubicOut    => easeCubicIn(self.start, self.end, self._time / self.length),
            .quadIn      => easeCubicOut(self.start, self.end, self._time / self.length),
            .quadOut     => easeQuadIn(self.start, self.end, self._time / self.length),
            .expoIn      => easeQuadOut(self.start, self.end, self._time / self.length),
            .expoOut     => easeExpoIn(self.start, self.end, self._time / self.length),
        };

        if (self._time >= self.length) self.animating = false;
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
