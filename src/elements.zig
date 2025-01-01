const math = @import("std").math;
const easing = @import("easing.zig");
const c = @import("c.zig").c;

pub var debugRender: bool = false;

var guiLock: bool = false;
var guiLockID: ?*anyopaque = null;

fn checkGuiLockID(element: *anyopaque) bool {
    return guiLockID == element;
}

pub const Button = struct {
    label: []const u8,
    bounds: c.Rectangle,
    background: c.Color,
    foreground: c.Color,
    on_click: *const fn () void,

    _label_position: c.Vector2,
    _hovered: bool,
    _selected: bool,
    _require_recalculation: bool,

    pub fn new(
        label: []const u8,
        bounds: c.Rectangle,
        on_click: fn () void,
        background: c.Color,
        foreground: c.Color,
    ) Button {
        return Button{
            .label = label,
            .bounds = bounds,
            .background = background,
            .foreground = foreground,
            .on_click = on_click,

            ._label_position = c.Vector2{},
            ._hovered = false,
            ._selected = false,
            ._require_recalculation = true,
        };
    }

    pub fn update(
        self: *Button
    ) void {
        if (self._require_recalculation) {
            const label_width: f32 = @as(f32, @floatFromInt(c.MeasureText(@ptrCast(self.label), 10)));
            const label_height: f32 = 10;
            self._label_position = .{
                .x = self.bounds.x + (self.bounds.width/2) - (label_width/2),
                .y = self.bounds.y + (self.bounds.height/2) - (label_height/2),
            };
        }

        self._require_recalculation = c.IsWindowResized();
        self._hovered = c.CheckCollisionPointRec(c.GetMousePosition(), self.bounds);
        self._selected = guiLock and checkGuiLockID(self);

        if (guiLock) {
            if (!checkGuiLockID(self)) return;
            if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT)) {
                // Maybe the user moved their cursor off of the button....
                if (self._hovered) self.on_click();
                guiLock = false;
                guiLockID = null;
            }
        } else if (self._hovered) {
            if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT)) {
                guiLock = true;
                guiLockID = self;
            }
        }
    }

    pub fn draw(
        self: *Button,
    ) void {
        c.DrawRectangleRounded(self.bounds, 1, 8, self.background);
        if ((self._hovered and !guiLock) or self._selected) {
            c.DrawRectangleRounded(self.bounds, 1, 8, c.Fade(c.WHITE, 0.1));
        }
        c.DrawText(
            @ptrCast(self.label),
            @intFromFloat(self._label_position.x),
            @intFromFloat(self._label_position.y),
            10,
            self.foreground,
        );

        if (self._require_recalculation and debugRender) {
            c.DrawRectangleLines(
                @intFromFloat(self.bounds.x - 3),
                @intFromFloat(self.bounds.y - 3),
                @intFromFloat(self.bounds.width + 6),
                @intFromFloat(self.bounds.height + 6),
                c.GREEN,
            );
        }
    }
};

pub const Slider = struct {
    min: f32,
    max: f32,
    bounds: c.Rectangle,
    track_background: c.Color,
    track_foreground: c.Color,
    handle_color: c.Color,

    value: f32,

    _track_bounds: c.Rectangle,
    _track_value_bounds: c.Rectangle,
    _handle_bounds: c.Rectangle,
    _hovered: bool,
    _selected: bool,
    _require_recalculation: bool,

    pub fn new(
        min: f32,
        max: f32,
        bounds: c.Rectangle,
        track_background: c.Color,
        track_foreground: c.Color,
        handle_color: c.Color,
    ) Slider {
        return Slider{
            .min = min,
            .max = max,
            .bounds = bounds,
            .track_background = track_background,
            .track_foreground = track_foreground,
            .handle_color = handle_color,

            .value = 0,

            ._track_bounds = c.Rectangle{},
            ._track_value_bounds = c.Rectangle{},
            ._handle_bounds = c.Rectangle{},
            ._hovered = false,
            ._selected = false,
            ._require_recalculation = true,
        };
    }

    pub fn update(
        self: *Slider,
    ) void {
        if (self._require_recalculation) {
            self._track_bounds = c.Rectangle{
                .x = self.bounds.x,
                .y = self.bounds.y + (self.bounds.height/2) - 3,
                .width = self.bounds.width,
                .height = 6,
            };
            self._track_value_bounds = c.Rectangle{
                .x = self.bounds.x,
                .y = self.bounds.y + (self.bounds.height/2) - 3,
                .width = self.bounds.width * (self.value / self.max),
                .height = 6,
            };
            self._handle_bounds = c.Rectangle{
                .x = self.bounds.x + (self.bounds.width * (self.value / self.max)) - 3,
                .y = self.bounds.y + 3,
                .width = 6,
                .height = self.bounds.height - 6,
            };
        }

        self._require_recalculation = c.IsWindowResized();
        self._hovered = c.CheckCollisionPointRec(c.GetMousePosition(), self.bounds);
        self._selected = guiLock and checkGuiLockID(self);

        if (guiLock) {
            if (!checkGuiLockID(self)) return;
            if (c.IsMouseButtonDown(c.MOUSE_BUTTON_LEFT)) {
                self._require_recalculation = true;
                self.value = self.max * ((c.GetMousePosition().x - self.bounds.x) / self.bounds.width);
            }
            if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT)) {
                self._require_recalculation = true;
                guiLock = false;
                guiLockID = null;
            }
        } else if (self._hovered) {
            if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT)) {
                guiLock = true;
                guiLockID = self;
            }
        }

        self.value = math.clamp(self.value, self.min, self.max);
    }

    pub fn draw(
        self: *Slider,
    ) void {
        c.DrawRectangleRounded(self._track_bounds, 1, 5, self.track_background);
        c.DrawRectangleRounded(self._track_value_bounds, 1, 5, self.track_foreground);
        if ((self._hovered and !guiLock) or self._selected) {
            c.DrawRectangleRounded(self._track_bounds, 1, 5, c.Fade(c.WHITE, 0.1));
        }
        c.DrawRectangleRounded(self._handle_bounds, 1, 5, self.handle_color);

        if (self._require_recalculation and debugRender) {
            c.DrawRectangleLines(
                @intFromFloat(self.bounds.x - 3),
                @intFromFloat(self.bounds.y - 3),
                @intFromFloat(self.bounds.width + 6),
                @intFromFloat(self.bounds.height + 6),
                c.GREEN,
            );
        }
    }
};

const SwitchAnimationTime: f32 = 0.15;

pub const Switch = struct {
    bounds: c.Rectangle,
    background: c.Color,
    foreground: c.Color,

    toggled: bool,

    _handle_bounds: c.Vector2,
    _handle_radius: f32,
    _hovered: bool,
    _selected: bool,
    _require_recalculation: bool,

    _animation: ?easing.Animate,

    pub fn new(
        bounds: c.Rectangle,
        background: c.Color,
        foreground: c.Color,
    ) Switch {
        return Switch{
            .bounds = bounds,
            .background = background,
            .foreground = foreground,

            .toggled = false,

            ._handle_bounds = c.Vector2{},
            ._handle_radius = 0,
            ._hovered = false,
            ._selected = false,
            ._require_recalculation = true,

            ._animation = null,
        };
    }

    pub fn update(
        self: *Switch,
    ) void {
        if (self._require_recalculation) {
            var offset_x: f32 = self.bounds.width - (self._handle_radius * 2);

            if (if (self._animation != null) self._animation.?.animating else false) {
                self._animation.?.update();
                offset_x *= self._animation.?.progress;
            } else {
                offset_x *= if (self.toggled) 1 else 0;
            }

            self._handle_radius = (self.bounds.height/2);
            self._handle_bounds = c.Vector2{
                .x = self.bounds.x + self._handle_radius + offset_x,
                .y = self.bounds.y + self._handle_radius,
            };
        }

        self._require_recalculation = c.IsWindowResized() or (if (self._animation != null) self._animation.?.animating else false);
        self._hovered = c.CheckCollisionPointRec(c.GetMousePosition(), self.bounds);
        self._selected = guiLock and checkGuiLockID(self);

        if (guiLock) {
            if (!checkGuiLockID(self)) return;
            if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT)) {
                // Maybe the user moved their cursor off of the switch....
                if (self._hovered) {
                    if (self.toggled) {
                        self._animation = easing.Animate.new(1, 0, SwitchAnimationTime, .quadIn);
                        self.toggled = false;
                    } else {
                        self._animation = easing.Animate.new(0, 1, SwitchAnimationTime, .quadIn);
                        self.toggled = true;
                    }
                    self._require_recalculation = true;
                }
                guiLock = false;
                guiLockID = null;
            }
        } else if (self._hovered) {
            if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT)) {
                guiLock = true;
                guiLockID = self;
            }
        }
    }

    pub fn draw(
        self: *Switch,
    ) void {
        c.DrawRectangleRounded(self.bounds, 1, 8, self.background);
        if ((self._hovered and !guiLock) or self._selected) {
            c.DrawCircle(@intFromFloat(self._handle_bounds.x), @intFromFloat(self._handle_bounds.y), (self.bounds.height/2)+4, c.Fade(c.WHITE, 0.1));
        }
        c.DrawCircle(@intFromFloat(self._handle_bounds.x), @intFromFloat(self._handle_bounds.y), self._handle_radius - 6, self.foreground);

        if (self._require_recalculation and debugRender) {
            c.DrawRectangleLines(
                @intFromFloat(self.bounds.x - 3),
                @intFromFloat(self.bounds.y - 3),
                @intFromFloat(self.bounds.width + 6),
                @intFromFloat(self.bounds.height + 6),
                c.GREEN,
            );
        }
    }
};
