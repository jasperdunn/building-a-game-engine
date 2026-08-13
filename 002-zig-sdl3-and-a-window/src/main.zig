const sdl3 = @import("sdl3");

pub fn main() !void {
    try sdl3.init(.{ .video = true });
    defer sdl3.shutdown();

    const window, const renderer = try sdl3.render.Renderer.initWithWindow(
        "What's up? SDL3",
        1280,
        720,
        .{},
    );
    defer window.deinit();
    defer renderer.deinit();

    try renderer.setDrawColor(.{ .r = 227, .g = 115, .b = 94, .a = 255 });

    var running = true;
    while (running) {
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

        try renderer.clear();
        try renderer.present();
    }
}
