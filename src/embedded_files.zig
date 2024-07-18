const std = @import("std");

pub const EmbeddedFiles = struct {
    const Self = @This();

    pub const File = struct {
        name: []const u8,
        content: []const u8,
        };

    files: []const File,

    pub fn get(self: Self, name: []const u8) ?[]const u8 {
        for (self.files) |file| {
            if (std.mem.eql(u8, file.name, name)) {
                return file.content;
            }
        }
        return null;
    }
};

pub const embedded_files = EmbeddedFiles{
    .files = &[_]EmbeddedFiles.File{
        .{
            .name = "LunarLanderInsurance.jpg",
            .content = @embedFile("resources/creatives/LunarLanderInsurance.jpg"),
        },
        .{
            .name = "MartianRealEstate.jpg",
            .content = @embedFile("resources/creatives/MartianRealEstate.jpg"),
        },
        .{
            .name = "AsteroidMiningEquipment.jpg",
            .content = @embedFile("resources/creatives/AsteroidMiningEquipment.jpg"),
        },
        .{
            .name = "InterstellarTravelAgency.jpg",
            .content = @embedFile("resources/creatives/InterstellarTravelAgency.jpg"),
        },
        .{
            .name = "ZoeBlastOff.jpg",
            .content = @embedFile("resources/creatives/ZoeBlastOff.jpg"),
        },
    },
};