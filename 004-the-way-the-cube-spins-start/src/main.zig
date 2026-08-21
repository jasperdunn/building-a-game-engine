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

    var previous_frame_ns = sdl3.timer.getNanosecondsSinceInit();
    var point = Point{ .x = window_width / 2, .y = window_height / 2 };

    var target_fps: u32 = 120;
    var running = true;

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
                .key_down => |keyboard| switch (keyboard.key orelse continue) {
                    .escape => running = false,
                    .one => target_fps = 15,
                    .two => target_fps = 30,
                    .three => target_fps = 60,
                    .four => target_fps = 120,
                    else => {},
                },
                else => {},
            }
        }

        // Draw
        try renderer.setDrawColor(.{ .r = 0, .g = 0, .b = 0, .a = 255 });
        try renderer.clear();

        try renderer.setDrawColor(.{ .r = 227, .g = 115, .b = 94, .a = 255 });
        try renderer.renderFillRect(point.toRect());

        try renderer.present();

        capFrameRate(current_frame_ns, target_fps);
    }
}

/// Call at the end of the render loop to throttle the frame rate to `target_fps`.
fn capFrameRate(frame_start_ns: u64, target_fps: u32) void {
    const elapsed_ns = sdl3.timer.getNanosecondsSinceInit() - frame_start_ns;
    const frame_budget_ns = std.time.ns_per_s / target_fps;

    if (elapsed_ns < frame_budget_ns) {
        const delay_ns = frame_budget_ns - elapsed_ns;
        sdl3.timer.delayNanoseconds(delay_ns);
    }
}
