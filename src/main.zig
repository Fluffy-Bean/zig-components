const std = @import("std");
const gui = @import("gui/gui.zig").Gui;
const button = @import("gui/button.zig").Button;
const slider = @import("gui/slider.zig").Slider;
const switch_ = @import("gui/switch.zig").Switch; // _ to not conflict with builtins...
const theme = @import("theme.zig");
const c = @import("c.zig").c;


var WindowWidth:  f32 = 0;
var WindowHeight: f32 = 0;

var Gui:        gui     = undefined;
var Button:     button  = undefined;
var ButtonText: button  = undefined;
var Slider:     slider  = undefined;
var Switch:     switch_ = undefined;
var Switch2:    switch_ = undefined;


pub fn main() !void {
    c.SetConfigFlags(c.FLAG_WINDOW_RESIZABLE | c.FLAG_MSAA_4X_HINT | c.FLAG_WINDOW_HIGHDPI);
    c.InitWindow(600, 600, "Zig Components");
    c.SetTargetFPS(120);

    WindowWidth = @floatFromInt(c.GetScreenWidth());
    WindowHeight = @floatFromInt(c.GetScreenHeight());

    Gui = gui.New();
    Gui.debug = true;

    Button = button.New(
        c.Rectangle{.x = 25, .y = 50, .width = 80, .height = 30},
        "Button",
        struct {
            fn cb() void {
                c.TraceLog(c.LOG_INFO, "Button pressed");
            }
        }.cb,
        .Accent,
        &Gui,
    );

    ButtonText = button.New(
        c.Rectangle{.x = 115, .y = 50, .width = 150, .height = 30},
        "Very Wide Text Button",
        struct {
            fn cb() void {
                c.TraceLog(c.LOG_INFO, "Button 2 pressed");
            }
        }.cb,
        .Text,
        &Gui,
    );

    Slider = slider.New(
        c.Rectangle{.x = 25, .y = 140, .width = WindowWidth - 50, .height = 30},
        0,
        100,
        &Gui,
    );

    Switch = switch_.New(
        c.Rectangle{.x = 25, .y = 230, .width = 52, .height = 30},
        &Gui,
    );

    Switch2 = switch_.New(
        c.Rectangle{.x = 91, .y = 230, .width = 52, .height = 30},
        &Gui,
    );

    while (!c.WindowShouldClose()) {
        if (c.IsWindowResized()) {
            WindowWidth = @floatFromInt(c.GetScreenWidth());
            WindowHeight = @floatFromInt(c.GetScreenHeight());
            Slider.bounds.width = WindowWidth-50;
        }

        if (c.IsKeyPressed(c.KEY_F5)) {
            Gui.debug = !Gui.debug;
        }

        Button.Update();
        ButtonText.Update();
        Slider.Update();
        Switch.Update();
        Switch2.Update();

        c.BeginDrawing();
        c.ClearBackground(theme.ColorSurfaceLow);

        const button_container: c.Rectangle = c.Rectangle{.x = 10, .y = 10, .width = WindowWidth - 20, .height = 80};
        c.DrawRectangleRounded(button_container, 0.1, 5, theme.ColorSurface);
        c.DrawRectangleRoundedLinesEx(button_container, 0.1, 5, 2, theme.ColorSurfaceHigh);
        c.DrawText("Buttons", 25, 20, 20, theme.ColorForeground);
        Button.Draw();
        ButtonText.Draw();

        const slider_container: c.Rectangle = c.Rectangle{.x = 10, .y = 100, .width = WindowWidth - 20, .height = 80};
        c.DrawRectangleRounded(slider_container, 0.1, 5, theme.ColorSurface);
        c.DrawRectangleRoundedLinesEx(slider_container, 0.1, 5, 2, theme.ColorSurfaceHigh);
        c.DrawText("Sliders", 25, 110, 20, theme.ColorForeground);
        Slider.Draw();

        const toggle_switch_container: c.Rectangle = c.Rectangle{.x = 10, .y = 190, .width = WindowWidth - 20, .height = 80};
        c.DrawRectangleRounded(toggle_switch_container, 0.1, 5, theme.ColorSurface);
        c.DrawRectangleRoundedLinesEx(toggle_switch_container, 0.1, 5, 2, theme.ColorSurfaceHigh);
        c.DrawText("Switches", 25, 200, 20, theme.ColorForeground);
        Switch.Draw();
        Switch2.Draw();

        c.EndDrawing();
    }
    c.CloseWindow();
}
