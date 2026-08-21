const sdl3 = @import("sdl3");

pub const Point = struct {
    x: f32,
    y: f32,

    pub fn toRect(self: Point) sdl3.rect.FRect {
        return .{
            .x = self.x,
            .y = self.y,
            .w = 10,
            .h = 10,
        };
    }
};
