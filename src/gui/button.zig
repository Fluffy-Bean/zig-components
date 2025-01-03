const gui = @import("gui.zig").Gui;
const theme = @import("../theme.zig");
const c = @import("../c.zig").c;


pub const Style = enum {
    Accent,
    Text,
};


pub const Button = struct {
    bounds:   c.Rectangle,
    label:    []const u8,
    on_click: *const fn () void,
    style:    Style,

    _label_position:        c.Vector2,
    _hovered:               bool,
    _selected:              bool,
    _require_recalculation: bool,

    _gui: *gui,

    const Self: type = @This();

    pub fn New(
        bounds:   c.Rectangle,
        label:    []const u8,
        on_click: fn () void,
        style:    Style,
        gui_t:    *gui,
    ) Button {
        return Button{
            .bounds = bounds,
            .label = label,
            .on_click = on_click,
            .style = style,

            ._label_position = c.Vector2{},
            ._hovered = false,
            ._selected = false,
            ._require_recalculation = true,

            ._gui = gui_t,
        };
    }

    pub fn Update(
        self: *Self
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
        self._selected = self._gui.locked and self._gui.HasLockOwnership(self);

        if (self._gui.locked) {
            if (!self._gui.HasLockOwnership(self)) return;
            if (c.IsMouseButtonReleased(c.MOUSE_BUTTON_LEFT)) {
                // Maybe the user moved their cursor off of the button....
                if (self._hovered) self.on_click();
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
        switch (self.style) {
            Style.Accent => self.DrawAccent(),
            Style.Text => self.DrawText(),
        }

        if (self._require_recalculation and self._gui.debug) {
            @import("gui.zig").DebugDraw(self.bounds);
        }
    }

    fn DrawAccent(self: *Self) void {
        c.DrawRectangleRounded(
            self.bounds,
            1,
            8,
            theme.ColorAccent,
        );
        if ((self._hovered and !self._gui.locked) or self._selected) {
            c.DrawRectangleRounded(
                self.bounds,
                1,
                8,
                c.Fade(c.WHITE, 0.1),
            );
        }
        c.DrawText(
            @ptrCast(self.label),
            @intFromFloat(self._label_position.x),
            @intFromFloat(self._label_position.y),
            10,
            theme.ColorForeground,
        );
    }

    fn DrawText(self: *Self) void {
        if ((self._hovered and !self._gui.locked) or self._selected) {
            c.DrawRectangleRounded(
                self.bounds,
                1,
                8,
                c.Fade(c.WHITE, 0.1),
            );
        }
        c.DrawText(
            @ptrCast(self.label),
            @intFromFloat(self._label_position.x),
            @intFromFloat(self._label_position.y),
            10,
            theme.ColorForeground,
        );
    }
};
