const std = @import("std");
const Ad = @import("models/ad.zig").Ad;

const AD_CREATIVES_JSON = @embedFile("resources/ad_creatives.json");

pub const AdManager = struct {
    ads: std.ArrayList(Ad),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !AdManager {
        var manager = AdManager{
            .ads = std.ArrayList(Ad).init(allocator),
            .allocator = allocator,
        };

        try manager.loadAdsFromJson();

        return manager;
    }

    pub fn deinit(self: *AdManager) void {
        for (self.ads.items) |ad| {
            self.allocator.free(ad.title);
            self.allocator.free(ad.content);
            self.allocator.free(ad.creative);
        }
        self.ads.deinit();
    }

    fn loadAdsFromJson(self: *AdManager) !void {
        var json_parsed = try std.json.parseFromSlice(
            std.json.Value,
            self.allocator,
            AD_CREATIVES_JSON,
            .{}
        );
        defer json_parsed.deinit();

        const ads = json_parsed.value.array;

        for (ads.items) |ad_value| {
            const ad = ad_value.object;
            try self.ads.append(Ad{
                .id = @intCast(self.ads.items.len + 1),
                .title = try self.allocator.dupe(u8, ad.get("title").?.string),
                .content = try self.allocator.dupe(u8, ad.get("content").?.string),
                .creative = try self.allocator.dupe(u8, ad.get("creative").?.string),
            });
        }
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