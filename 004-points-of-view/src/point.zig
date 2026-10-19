const sdl3 = @import("sdl3");
const math = @import("math.zig");
const Vec3 = math.Vec3;

pub const Point = struct {
    position: Vec3,
    size: f32,

    pub fn toRect(self: Point) sdl3.rect.FRect {
        const half_size = self.size / 2;

        return .{
            .x = self.position.x - half_size,
            .y = self.position.y - half_size,
            .w = self.size,
            .h = self.size,
        };
    }

    /// Convert a point from Normalized Device Coordinates to Screen Space Coordinates (pixels).
    /// This is known as the viewport transform.
    pub fn toScreenSpace(self: Point, width: f32, height: f32) Point {
        return .{
            .position = .{
                .x = (self.position.x + 1) / 2 * width,
                // We have to flip the sign for the Y axis, since NDCs have +Y up, whereas Screen Space Coordinates have +Y down.
                .y = (1 - self.position.y) / 2 * height,
                .z = self.position.z,
            },
            .size = self.size,
        };
    }

    /// Convert a point from view space to Normalized Device Coordinates.
    /// This is known as the perspective divide.
    pub fn toNDC(self: Point) Point {
        return .{
            .position = .{
                // We divide by -Z because the camera looks towards -Z, everything visible has a negative Z value.
                .x = self.position.x / -self.position.z,
                .y = self.position.y / -self.position.z,
                .z = self.position.z,
            },
            .size = self.size,
        };
    }
};
