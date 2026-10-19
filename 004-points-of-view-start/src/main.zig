const std = @import("std");
const sdl3 = @import("sdl3");
const Point = @import("point.zig").Point;

const window_width = 1280;
const window_height = 720;

pub fn main() !void {
    try sdl3.init(.{ .video = true });
    defer sdl3.shutdown();

    const window, const renderer = try sdl3.render.Renderer.initWithWindow(
        "What's up? SDL3",
        window_width,
        window_height,
        .{},
    );
    defer window.deinit();
    defer renderer.deinit();

    // This built-in feature of the SDL Renderer allows us to sync to the display's refresh rate
    // instead of hardcoding an FPS cap like we were doing in the previous article.
    try renderer.setVSync(.{ .on_each_num_refresh = 1 });

    const point = Point{
        .x = 640,
        .y = 360,
        .size = 20,
    };

    var running = true;
    var previous_frame_ns = sdl3.timer.getNanosecondsSinceInit();

    // Render loop
    while (running) {
        // Calculate delta time
        const current_frame_ns = sdl3.timer.getNanosecondsSinceInit();
        defer previous_frame_ns = current_frame_ns;
        const delta_ns = current_frame_ns - previous_frame_ns;
        const delta_seconds = @as(f32, @floatFromInt(delta_ns)) / std.time.ns_per_s;
        _ = delta_seconds; // autofix

        // Event loop
        while (sdl3.events.poll()) |event| {
            switch (event) {
                .quit => running = false,
                .key_down => |keyboard| {
                    if (keyboard.key == .escape) {
                        running = false;
                    }
                },
                else => {},
            }
        }

        // Draw
        try renderer.setDrawColor(.{ .r = 227, .g = 115, .b = 94, .a = 255 });
        try renderer.clear();

        try renderer.setDrawColor(.{ .r = 0, .g = 0, .b = 0, .a = 255 });
        try renderer.renderFillRect(point.toRect());

        try renderer.present();
    }
}
