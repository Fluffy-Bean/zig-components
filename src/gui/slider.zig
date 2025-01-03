const math = @import("std").math;
const gui = @import("gui.zig").Gui;
const theme = @import("../theme.zig");
const c = @import("../c.zig").c;


pub const Slider = struct {
    bounds:           c.Rectangle,
    min:              f32,
    max:              f32,
    value:            f32,

    _track_bounds:          c.Rectangle,
    _track_value_bounds:    c.Rectangle,
    _handle_bounds:         c.Rectangle,
    _hovered:               bool,
    _selected:              bool,
    _require_recalculation: bool,

    _gui: *gui,

    const Self: type = @This();

    pub fn New(
        bounds: c.Rectangle,
        min: f32,
        max: f32,
        gui_t: *gui,
    ) Slider {
        return Slider{
            .bounds = bounds,
            .min = min,
            .max = max,
            .value = 0,

            ._track_bounds = c.Rectangle{},
            ._track_value_bounds = c.Rectangle{},
            ._handle_bounds = c.Rectangle{},
            ._hovered = false,
            ._selected = false,
            ._require_recalculation = true,

            ._gui = gui_t,
        };
    }

    pub fn Update(
        self: *Self,
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
        self._selected = self._gui.locked and self._gui.HasLockOwnership(self);

        if (self._gui.locked) {
            if (!self._gui.HasLockOwnership(self)) return;
            if (c.IsMouseButtonDown(c.MOUSE_BUTTON_LEFT)) {
                self._require_recalculation = true;
                self.value = self.max * ((c.GetMousePosition().x - self.bounds.x) / self.bounds.width);
            }
            if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT)) {
                self._require_recalculation = true;
                self._gui.UnLock(self);
            }
        } else if (self._hovered) {
            if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT)) {
                self._gui.Lock(self);
            }
        }

        self.value = math.clamp(self.value, self.min, self.max);
    }

    pub fn Draw(
        self: *Self,
    ) void {
        c.DrawRectangleRounded(self._track_bounds, 1, 5, theme.ColorSurfaceHigh);
        c.DrawRectangleRounded(self._track_value_bounds, 1, 5, theme.ColorAccent);
        if ((self._hovered and !self._gui.locked) or self._selected) {
            c.DrawRectangleRounded(self._track_bounds, 1, 5, c.Fade(c.WHITE, 0.1));
        }
        c.DrawRectangleRounded(self._handle_bounds, 1, 5, theme.ColorForeground);

        if (self._require_recalculation and self._gui.debug) {
            @import("gui.zig").DebugDraw(self.bounds);
        }
    }
};