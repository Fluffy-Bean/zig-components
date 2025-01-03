const c = @import("../c.zig").c;

pub const Gui = struct {
    locked: bool,
    debug: bool,
    _lock_holder: ?*anyopaque,

    const Self: type = @This();

    pub fn New() Gui {
        return Gui{
            .locked = false,
            .debug = false,
            ._lock_holder = null,
        };
    }

    pub fn HasLockOwnership(self: *Self, element: *anyopaque) bool {
        return self._lock_holder == element;
    }

    pub fn Lock(self: *Self, element: *anyopaque) void {
        if (self.locked) return;
        self.locked = true;
        self._lock_holder = element;
    }

    pub fn UnLock(self: *Self, element: *anyopaque) void {
        if (self._lock_holder != element) return;
        self.locked = false;
        self._lock_holder = null;
    }
};

pub fn DebugDraw(bounds: c.Rectangle) void {
    c.DrawRectangle(
        @intFromFloat(bounds.x - 4),
        @intFromFloat(bounds.y - 4),
        @intFromFloat(bounds.width + 8),
        @intFromFloat(bounds.height + 8),
        c.Fade(c.GREEN, 0.1),
    );
}
