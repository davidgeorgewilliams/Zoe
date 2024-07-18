const std = @import("std");
const zap = @import("zap");
const AdManager = @import("ad_manager.zig").AdManager;
const home = @import("handlers/home.zig");
const ads = @import("handlers/ads.zig");
const space_adventure = @import("handlers/space_adventure.zig");

pub const AdServer = struct {
    allocator: std.mem.Allocator,
    ad_manager: AdManager,

    pub fn init(allocator: std.mem.Allocator) !AdServer {
        return AdServer{
            .allocator = allocator,
            .ad_manager = try AdManager.init(allocator),
        };
    }

    pub fn deinit(self: *AdServer) void {
        self.ad_manager.deinit();
    }

    pub fn handleRequest(self: *AdServer, req: zap.Request) void {
        const path = req.path orelse {
            req.setStatus(.bad_request);
            req.sendBody("Invalid request: missing path") catch {};
            return;
        };

        if (std.mem.eql(u8, path, "/")) {
            home.handle(req);
        } else if (std.mem.eql(u8, path, "/ads")) {
            ads.handle(req, &self.ad_manager);
        } else if (std.mem.eql(u8, path, "/adventure")) {
            space_adventure.handle(req);
        } else {
            req.setStatus(.not_found);
            req.sendBody("Oops! Zoe couldn't find that page in the cosmic void!") catch {};
        }
    }
};

pub fn init(allocator: std.mem.Allocator) !AdServer {
    return AdServer.init(allocator);
}

