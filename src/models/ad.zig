const std = @import("std");

pub const Ad = struct {
    id: u32,
    title: []const u8,
    content: []const u8,

    pub fn format(self: Ad, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        try writer.print("Ad(id: {}, title: {s})", .{ self.id, self.title });
    }
};