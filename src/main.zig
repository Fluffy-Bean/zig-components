const std = @import("std");
const elements = @import("elements.zig");
const theme = @import("theme.zig");
const c = @import("c.zig").c;

var WindowWidth: f32 = 0;
var WindowHeight: f32 = 0;

pub fn main() !void {
    c.SetConfigFlags(c.FLAG_WINDOW_RESIZABLE | c.FLAG_MSAA_4X_HINT);
    c.InitWindow(600, 600, "Zig Components");

    WindowWidth = @floatFromInt(c.GetScreenWidth());
    WindowHeight = @floatFromInt(c.GetScreenHeight());

    var button = elements.Button.new(
        "Button",
        .{
            .x = 30,
            .y = 50,
            .width = 80,
            .height = 30,
        },
        struct {
            fn click() void {
                c.TraceLog(c.LOG_INFO, "Button Pressed");
            }
        }.click,
        theme.ColorAccent,
        theme.ColorForeground,
    );

    var slider = elements.Slider.new(
        0,
        100,
        .{
            .x = 30,
            .y = 140,
            .width = WindowWidth - 60,
            .height = 30,
        },
        theme.ColorSurfaceHigh,
        theme.ColorAccent,
        theme.ColorForeground,
    );

    var toggleSwitch = elements.Switch.new(
        .{
            .x = 30,
            .y = 230,
            .width = 52,
            .height = 30,
        },
        theme.ColorAccent,
        theme.ColorForeground,
    );

    while (!c.WindowShouldClose()) {
        if (c.IsWindowResized()) {
            WindowWidth = @floatFromInt(c.GetScreenWidth());
            WindowHeight = @floatFromInt(c.GetScreenHeight());

            slider.bounds.width = WindowWidth-60;
        }

        button.update();
        slider.update();
        toggleSwitch.update();

        c.BeginDrawing();
        c.ClearBackground(theme.ColorSurfaceLow);

        { // Button
            c.DrawRectangleRounded(
                .{
                    .x = 10,
                    .y = 10,
                    .width = WindowWidth - 20,
                    .height = 80,
                },
                0.2,
                5,
                theme.ColorSurface,
            );
            c.DrawText("Button", 30, 20, 20, theme.ColorForeground);
            button.draw();
        }

        { // Slider
            c.DrawRectangleRounded(
                .{
                    .x = 10,
                    .y = 100,
                    .width = WindowWidth - 20,
                    .height = 80,
                },
                0.2,
                5,
                theme.ColorSurface,
            );
            c.DrawText("Sliders", 30, 110, 20, theme.ColorForeground);
            slider.draw();
        }

        { // Switch
            c.DrawRectangleRounded(
            .{
                .x = 10,
                .y = 190,
                .width = WindowWidth - 20,
                .height = 80,
            },
            0.2,
            5,
            theme.ColorSurface,
        );
            c.DrawText("Switches", 30, 200, 20, theme.ColorForeground);
            toggleSwitch.draw();
        }

        c.EndDrawing();
    }
    c.CloseWindow();
}
