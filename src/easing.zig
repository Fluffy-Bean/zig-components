const math = @import("std").math;

pub fn EaseLinearNone(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * time;
}

pub fn EaseLinearIn(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * time;
}

pub fn EaseLinearOut(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * time;
}

pub fn EaseLinearInOut(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * time;
}

pub fn EaseSineIn(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * (1 - math.cos(time * (math.Pi / 2)));
}

pub fn EaseSineOut(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * math.sin(time * (math.Pi / 2));
}

pub fn EaseSineInOut(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * 0.5 * (1 - math.cos(time * math.Pi));
}

pub fn EaseCircIn(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * (1 - math.sqrt(1 - time * time));
}

pub fn EaseCircOut(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * math.sqrt(1 - (time - 1) * (time - 1));
}

pub fn EaseCubicIn(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * time * time * time;
}

pub fn EaseCubicOut(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1) - 1;
    return a + (b - a) * (time * time * time + 1);
}

pub fn EaseQuadIn(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * time * time;
}

pub fn EaseQuadOut(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * (1 - (1 - time) * (1 - time));
}

pub fn EaseExpoIn(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * (if (time == 0) 0 else math.pow(2, 10 * (time - 1)));
}

pub fn EaseExpoOut(a: f32, b: f32, t: f32) f32 {
    const time = math.clamp(t, 0, 1);
    return a + (b - a) * (if (time == 1) 1 else 1 - math.pow(2, -10 * time));
}
