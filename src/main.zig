const std = @import("std");
const elements = @import("elements.zig");
const theme = @import("theme.zig");
const c = @import("c.zig").c;

var WindowWidth: f32 = 0;
var WindowHeight: f32 = 0;

pub fn main() !void {
    c.SetConfigFlags(c.FLAG_WINDOW_RESIZABLE | c.FLAG_MSAA_4X_HINT | c.FLAG_WINDOW_HIGHDPI);
    c.InitWindow(600, 600, "Zig Components");
    c.SetTargetFPS(120);

    WindowWidth = @floatFromInt(c.GetScreenWidth());
    WindowHeight = @floatFromInt(c.GetScreenHeight());

    const button_bounds: c.Rectangle = c.Rectangle{.x = 25, .y = 50, .width = 80, .height = 30};
    var button = elements.Button.new("Button",button_bounds,buttonPress,theme.ColorAccent,theme.ColorForeground);

    const button_wide_bounds: c.Rectangle = c.Rectangle{.x = 115, .y = 50, .width = 150, .height = 30};
    var button_transparent = elements.Button.new("Very Wide Text Button",button_wide_bounds,buttonWidePress,c.BLANK,theme.ColorForeground);

    const slider_bounds: c.Rectangle = c.Rectangle{.x = 25, .y = 140, .width = WindowWidth - 50, .height = 30};
    var slider = elements.Slider.new(0,100,slider_bounds,theme.ColorSurfaceHigh,theme.ColorAccent,theme.ColorForeground);

    const toggle_switch_bounds: c.Rectangle = c.Rectangle{.x = 25, .y = 230, .width = 52, .height = 30};
    var toggle_switch = elements.Switch.new(toggle_switch_bounds,theme.ColorAccent,theme.ColorForeground);

    while (!c.WindowShouldClose()) {
        if (c.IsWindowResized()) {
            WindowWidth = @floatFromInt(c.GetScreenWidth());
            WindowHeight = @floatFromInt(c.GetScreenHeight());
            slider.bounds.width = WindowWidth-50;
        }

        if (c.IsKeyPressed(c.KEY_F5)) {
            elements.debugRender = !elements.debugRender;
        }

        button.update();
        button_transparent.update();
        slider.update();
        toggle_switch.update();

        c.BeginDrawing();
        c.ClearBackground(theme.ColorSurfaceLow);

        const button_container: c.Rectangle = c.Rectangle{.x = 10, .y = 10, .width = WindowWidth - 20, .height = 80};
        c.DrawRectangleRounded(button_container, 0.1, 5, theme.ColorSurface);
        c.DrawRectangleRoundedLinesEx(button_container, 0.1, 5, 2, theme.ColorSurfaceHigh);
        c.DrawText("Button", 25, 20, 20, theme.ColorForeground);
        button.draw();
        button_transparent.draw();

        const slider_container: c.Rectangle = c.Rectangle{.x = 10, .y = 100, .width = WindowWidth - 20, .height = 80};
        c.DrawRectangleRounded(slider_container, 0.1, 5, theme.ColorSurface);
        c.DrawRectangleRoundedLinesEx(slider_container, 0.1, 5, 2, theme.ColorSurfaceHigh);
        c.DrawText("Sliders", 25, 110, 20, theme.ColorForeground);
        slider.draw();

        const toggle_switch_container: c.Rectangle = c.Rectangle{.x = 10, .y = 190, .width = WindowWidth - 20, .height = 80};
        c.DrawRectangleRounded(toggle_switch_container, 0.1, 5, theme.ColorSurface);
        c.DrawRectangleRoundedLinesEx(toggle_switch_container, 0.1, 5, 2, theme.ColorSurfaceHigh);
        c.DrawText("Switches", 25, 200, 20, theme.ColorForeground);
        toggle_switch.draw();

        c.EndDrawing();
    }
    c.CloseWindow();
}

fn buttonPress() void {
    c.TraceLog(c.LOG_INFO, "Button pressed");
}

fn buttonWidePress() void {
    c.TraceLog(c.LOG_INFO, "Text Button pressed");
}
