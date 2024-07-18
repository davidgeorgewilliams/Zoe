const std = @import("std");
const Ad = @import("models/ad.zig").Ad;

pub const AdManager = struct {
    ads: std.ArrayList(Ad),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !AdManager {
        var manager = AdManager{
            .ads = std.ArrayList(Ad).init(allocator),
            .allocator = allocator,
        };

        // Add some sample ads
        try manager.addAd("Lunar Lander Insurance", "Don't crash and burn! Get covered today!");
        try manager.addAd("Martian Real Estate", "Own a piece of the Red Planet!");
        try manager.addAd("Asteroid Mining Equipment", "Strike it rich in the belt!");

        return manager;
    }

    pub fn deinit(self: *AdManager) void {
        self.ads.deinit();
    }

    pub fn addAd(self: *AdManager, title: []const u8, content: []const u8) !void {
        const id = @as(u32, @intCast(self.ads.items.len + 1));
        const ad = Ad{
            .id = id,
            .title = try self.allocator.dupe(u8, title),
            .content = try self.allocator.dupe(u8, content),
        };
        try self.ads.append(ad);
    }

    pub fn getAds(self: *AdManager) []const Ad {
        return self.ads.items;
    }

    pub fn getAdById(self: *AdManager, id: u32) ?Ad {
        for (self.ads.items) |ad| {
            if (ad.id == id) return ad;
        }
        return null;
    }
};
