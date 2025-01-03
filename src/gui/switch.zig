const easing = @import("../easing.zig");
const gui = @import("gui.zig").Gui;
const theme = @import("../theme.zig");
const c = @import("../c.zig").c;


const AnimationLength: f32          = 0.12;
const AnimationEase:   easing.Eases = .circIn;


pub const Switch = struct {
    bounds:  c.Rectangle,
    toggled: bool,

    _handle_bounds:         c.Vector2,
    _handle_radius:         f32,
    _hovered:               bool,
    _selected:              bool,
    _require_recalculation: bool,
    _animation:             easing.Animate,

    _gui: *gui,

    const Self: type = @This();

    pub fn New(
        bounds: c.Rectangle,
        gui_t: *gui,
    ) Switch {
        // ToDo: Make some sane default, instead of this monstrosity to avoid checking for nulls first
        var animation = easing.Animate.Newq(0, 0, 0, AnimationEase);
        animation.animating = false;

        return Switch{
            .bounds = bounds,
            .toggled = false,

            ._handle_bounds = c.Vector2{},
            ._handle_radius = 0,
            ._hovered = false,
            ._selected = false,
            ._require_recalculation = true,

            ._animation = animation,

            ._gui = gui_t,
        };
    }

    pub fn Update(
        self: *Self,
    ) void {
        if (self._require_recalculation) {
            var offset_x: f32 = self.bounds.width - (self._handle_radius * 2);

            if (self._animation.animating) {
                self._animation.Update();
                offset_x *= self._animation.progress;
            } else {
                offset_x *= if (self.toggled) 1 else 0;
            }

            self._handle_radius = (self.bounds.height/2);
            self._handle_bounds = c.Vector2{
                .x = self.bounds.x + self._handle_radius + offset_x,
                .y = self.bounds.y + self._handle_radius,
            };
        }

        self._require_recalculation = c.IsWindowResized() or self._animation.animating;
        self._hovered = c.CheckCollisionPointRec(c.GetMousePosition(), self.bounds);
        self._selected = self._gui.locked and self._gui.HasLockOwnership(self);

        if (self._gui.locked) {
            if (!self._gui.HasLockOwnership(self)) return;
            if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT)) {
                // Maybe the user moved their cursor off of the switch....
                if (self._hovered) {
                    if (self.toggled) {
                        self._animation = easing.Animate.Newq(1, 0, AnimationLength, AnimationEase);
                        self.toggled = false;
                    } else {
                        self._animation = easing.Animate.Newq(0, 1, AnimationLength, AnimationEase);
                        self.toggled = true;
                    }
                    self._require_recalculation = true;
                }
                self._gui.UnLock(self);
            }
        } else if (self._hovered) {
            if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT)) {
                self._gui.Lock(self);
            }
        }
    }

    pub fn Draw(
        self: *Self,
    ) void {
        c.DrawRectangleRounded(
            self.bounds,
            1,
            5,
            if (self.toggled) theme.ColorAccent else theme.ColorSurfaceLow,
        );
        c.DrawRectangleRoundedLinesEx(
            self.bounds,
            1,
            5,
            2,
            if (self.toggled) theme.ColorAccent else theme.ColorSurfaceHigh,
        );

        if ((self._hovered and !self._gui.locked) or self._selected) {
            c.DrawCircle(
                @intFromFloat(self._handle_bounds.x),
                @intFromFloat(self._handle_bounds.y),
                (self.bounds.height/2)+4,
                c.Fade(c.WHITE, 0.1),
            );
        }

        c.DrawCircle(
            @intFromFloat(self._handle_bounds.x),
            @intFromFloat(self._handle_bounds.y),
            self._handle_radius - 6,
            theme.ColorSurfaceHigh,
        );

        if (self._require_recalculation and self._gui.debug) {
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
