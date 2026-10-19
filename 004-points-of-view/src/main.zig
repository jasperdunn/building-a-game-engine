const std = @import("std");
const sdl3 = @import("sdl3");
const Point = @import("point.zig").Point;
const math = @import("math.zig");
const Vec3 = math.Vec3;

const window_width = 1280 / 2;
const window_height = 720 / 2;

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

    var points = [_]Vec3{
        .init(1, 1, -8),
        .init(1, 1, -9),
        .init(1, 1, -10),
        .init(1, 1, -11),
        .init(1, 1, -12),
        .init(1, 1, -13),
        .init(1, -1, -8),
        .init(1, -1, -9),
        .init(1, -1, -10),
        .init(1, -1, -11),
        .init(1, -1, -12),
        .init(1, -1, -13),
        .init(-1, 1, -8),
        .init(-1, 1, -9),
        .init(-1, 1, -10),
        .init(-1, 1, -11),
        .init(-1, 1, -12),
        .init(-1, 1, -13),
        .init(-1, -1, -8),
        .init(-1, -1, -9),
        .init(-1, -1, -10),
        .init(-1, -1, -11),
        .init(-1, -1, -12),
        .init(-1, -1, -13),
    };

    var distance: f32 = 8;
    const movement_speed: f32 = 4;

    var running = true;
    var previous_frame_ns = sdl3.timer.getNanosecondsSinceInit();

    // Render loop
    while (running) {
        // Calculate delta time
        const current_frame_ns = sdl3.timer.getNanosecondsSinceInit();
        defer previous_frame_ns = current_frame_ns;
        const delta_ns = current_frame_ns - previous_frame_ns;
        const delta_seconds = @as(f32, @floatFromInt(delta_ns)) / std.time.ns_per_s;

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

        // Update
        const keys = sdl3.keyboard.getState();
        const previous_distance = distance;

        if (keys[@intFromEnum(sdl3.Scancode.w)]) {
            distance -= movement_speed * delta_seconds;
        } else if (keys[@intFromEnum(sdl3.Scancode.s)]) {
            distance += movement_speed * delta_seconds;
        }

        // We're clamping the distance so we don't move too close or too far away.
        distance = @min(8, @max(1, distance));

        const change = previous_distance - distance;

        for (&points) |*point| {
            point.z += change;
        }

        // Draw
        try renderer.setDrawColor(.{ .r = 227, .g = 115, .b = 94, .a = 255 });
        try renderer.clear();

        try renderer.setDrawColor(.{ .r = 0, .g = 0, .b = 0, .a = 255 });
        for (&points) |position| {
            const point = Point{ .position = position, .size = 20 };
            try renderer.renderFillRect(point.toNDC().toScreenSpace(window_width, window_height).toRect());
        }

        try renderer.present();
    }
}
