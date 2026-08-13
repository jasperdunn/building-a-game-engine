const sdl3 = @import("sdl3");

pub const Square = struct {
    x: f32,
    y: f32,
    size: f32,

    pub fn toRect(self: Square) sdl3.rect.FRect {
        return .{
            .x = self.x,
            .y = self.y,
            .w = self.size,
            .h = self.size,
        };
    }
};
